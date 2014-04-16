--***********************************************************************
-- @file GameShop.lua
--***********************************************************************

-------------------------------------------------------------------------
SHOP_CAT_WEAPON = 1;
SHOP_CAT_JADE = 2;
SHOP_CAT_AVATAR = 3;
SHOP_CAT_COINBAG = 4;
SHOP_CAT_TREASURE = 5;
SHOP_CAT_MAX = SHOP_CAT_TREASURE;

SHOP_CAT_INDEX =
{
	[1] = "Weapon",
	[2] = "Jade",
	[3] = "Avatar",
	[4] = "Coinbag",
	[5] = "Treasure",

	["Weapon"] = 1,
	["Jade"] = 2,
	["Avatar"] = 3,
	["Coinbag"] = 4,
	["Treasure"] = 5,
};

CAT_SHOW_LV =
{
	[SHOP_CAT_WEAPON] = true,
	[SHOP_CAT_JADE] = true,
--	[SHOP_CAT_AVATAR] = false,
--	[SHOP_CAT_COINBAG] = false,
--	[SHOP_CAT_TREASURE] = false,
};

CAT_SHOW_COST =
{
--	[SHOP_CAT_WEAPON] = false,
--	[SHOP_CAT_JADE] = false,
	[SHOP_CAT_AVATAR] = true,
	[SHOP_CAT_COINBAG] = true,
--	[SHOP_CAT_TREASURE] = false,
};

CAT_CAN_SWIPE =
{
	[SHOP_CAT_JADE] = true,
	[SHOP_CAT_AVATAR] = true,
	[SHOP_CAT_COINBAG] = true,
	[SHOP_CAT_TREASURE] = true,
}

ITEM_ICON = 1;
ITEM_LV = 2;
ITEM_TEXT = 3;

ITEM_JADE_LOCK = nil;

SHOP_LV_PREFIX = "ui_shop_upgrade_lv";

-------------------------------------------------------------------------
ShopManager =
{
	m_ShopItems = {},
	m_ShopItemsMaxItemId = {},
	m_CurrentCategory = 0,
	m_InitialCategory = 0,
	m_TargetItem = nil,
	m_HasEnoughMoney = false,
	
	---------------------------------------------------------------------
	Create = function(self)
		ITEMS_PER_CAT_MAX = JADE_MAX;  -- Max # of jades

		for i = 1, SHOP_CAT_MAX do
			self.m_ShopItems[i] = {};
			self.m_ShopItemsMaxItemId[i] = {};
		end

		for i = 1, WEAPON_MAX do
			self:ResetItem("Weapon", i);
		end

		for i = 1, JADE_MAX do
			self:ResetJadeItem("Jade", i);
		end

		for i = 1, AVATAR_MAX do
			self:ResetItem("Avatar", i);
		end

		self:ResetCoinbagItem();
		self:ResetTreasureItem();
		
		self.m_UIFrame = UIManager:GetUI("ShopCategory");
		self.m_SellerSM = UIManager:GetWidgetComponent("Shop", "Seller", "StateMachine");

		CycleGOScale(UIManager:GetWidgetObject("LevelUnlock", "Go"), 1.0, 1.05, 500);
		CycleGORotate(UIManager:GetWidgetObject("ScrollUnlock", "LightEffect"), 0, 1, 5000);
		CycleGORotate(UIManager:GetWidgetObject("JadeUnlock", "LightEffect"), 0, 1, 5000);

		log("ShopManager creation done");
	end,
	---------------------------------------------------------------------
	Reset = function(self)	
		if (self.m_InitialCategory == 0) then
			self:SwitchShopCategory(1);
		else
			self:SwitchShopCategory(self.m_InitialCategory);
			self.m_InitialCategory = 0;
		end

		self.m_SellerSM:ChangeState("idle");
		
		log("ShopManager reset");
    end,

	--======================
	-- @Items
	--======================
	---------------------------------------------------------------------
	ResetItem = function(self, category, pos)
		local level = IOManager:GetValue(IO_CAT_HACK, category, pos) or 0;
		local itemId = SHOP_ITEM_POOL[category][pos][level];  		-- Show current item level
		
		if (itemId == nil) then  									-- Special case for level -1 jades
			itemId = SHOP_ITEM_POOL[category][pos][1];
		end
		assert(itemId, "ResetItem error");
		
		local len = #SHOP_ITEM_POOL[category][pos];
		self.m_ShopItemsMaxItemId[ SHOP_CAT_INDEX[category] ][pos] = SHOP_ITEM_POOL[category][pos][len];
		--log("Shop item MAX: "..SHOP_ITEM_POOL[category][pos][len].." @ "..category.."  [pos] "..pos)

		local index = SHOP_CAT_INDEX[category];		
		table.insert(self.m_ShopItems[index], itemId);
	end,
	---------------------------------------------------------------------
	ResetJadeItem = function(self, category, pos)
		local level = IOManager:GetValue(IO_CAT_HACK, category, ITEM_POS_JADE_ID[pos]) or 0;
		local itemId = SHOP_ITEM_POOL[category][pos][level];  		-- Show current item level
		
		if (itemId == nil) then  									-- Special case for level -1 jades
			itemId = SHOP_ITEM_POOL[category][pos][1];
		end
		assert(itemId, "ResetItem error");
		
		local len = #SHOP_ITEM_POOL[category][pos];
		self.m_ShopItemsMaxItemId[ SHOP_CAT_INDEX[category] ][pos] = SHOP_ITEM_POOL[category][pos][len];
		--log("Shop item MAX: "..SHOP_ITEM_POOL[category][pos][len].." @ "..category.."  [pos] "..pos)

		local index = SHOP_CAT_INDEX[category];		
		table.insert(self.m_ShopItems[index], itemId);
		--log("Shop item id: "..itemId.." @ pos "..pos)
	end,
	---------------------------------------------------------------------	
	ResetCoinbagItem = function(self)
		for _, itemId in ipairs(SHOP_ITEM_POOL["Coinbag"]) do
			table.insert(self.m_ShopItems[SHOP_CAT_COINBAG], itemId);
		end
	end,
	---------------------------------------------------------------------	
	ResetTreasureItem = function(self)
		for _, itemId in ipairs(SHOP_ITEM_POOL["Treasure"]) do
			table.insert(self.m_ShopItems[SHOP_CAT_TREASURE], itemId);
		end
	end,
	---------------------------------------------------------------------
	UpdateWeaponItems = function(self)
		self.m_ShopItems[SHOP_CAT_WEAPON] = {};
		for i = 1, WEAPON_MAX do
			self:ResetItem("Weapon", i);
		end
	end,
	---------------------------------------------------------------------
	UpdateJadeItems = function(self)
		self.m_ShopItems[SHOP_CAT_JADE] = {};
		for i = 1, JADE_MAX do
			self:ResetJadeItem("Jade", i);
		end		
	end,

	--======================
	-- @General
	--======================
	---------------------------------------------------------------------
	SwitchShopCategory = function(self, index)				
		local itemCount = #self.m_ShopItems[index];
		--log("itemCount = "..itemCount.." @ cat #"..index)
		self.m_CurrentCategory = index;

		-- Show/Hide price tag or soldout
		for i = 1, itemCount do
			local itemId = self.m_ShopItems[index][i];
			
			if (self:HasSoldout(i, itemId)) then
			--log("SOLDOUT: "..itemId.." @ "..i)
				self:ShowSoldout(i);
			else
			--log("AVAIL: "..itemId.." @ "..i)
				UIManager:GetWidgetComponent("ShopCategory", "Item"..i, "Sprite"):EnableRender(ITEM_TEXT, false);
				UIManager:EnableWidget("ShopCategory", "ItemNum"..i, CAT_SHOW_COST[index]);
			end
		end

		-- Disable unused item widgets		
		for i = itemCount + 1, ITEMS_PER_CAT_MAX do
			UIManager:EnableWidget("ShopCategory", "Item"..i, false);
			UIManager:EnableWidget("ShopCategory", "ItemNum"..i, false);
		end
		
		-- Reset category state
		for i = 1, SHOP_CAT_MAX do
			if (i == index) then
				UIManager:GetWidget("ShopCategory", "Cat"..i):ChangeState(true);
			else
				UIManager:GetWidget("ShopCategory", "Cat"..i):ChangeState(false);
			end
		end
		
		-- Reset items price & position
		local showLv = CAT_SHOW_LV[index];
		for i = 1, itemCount do
			local itemId = self.m_ShopItems[index][i];
			self:UpdateShopIcon(itemId, i, true);

			-- Set item LEVEL
			local sprite = UIManager:GetWidgetComponent("ShopCategory", "Item"..i, "Sprite");
			sprite:EnableRender(ITEM_LV, showLv);

			if (showLv) then
				local level = IOManager:GetValue(IO_CAT_HACK, SHOP_CAT_INDEX[index], i) or 1;
				sprite:SetImage(ITEM_LV, SHOP_LV_PREFIX..level);
			end
		end

		-- Category specific
		if (self.m_CurrentCategory == SHOP_CAT_JADE) then			
			for i = 1, JADE_MAX do
				local itemId = self.m_ShopItems[index][i];

				if (ITEM_POS_JADE_IAP[i]) then
					if (self:HasSoldout(i, itemId)) then
						self:ShowSoldout(i);
					else
						self:ShowDollar(GAME_STUFF[itemId][STUFF_ATTR], i);
					end
					UIManager:GetWidgetComponent("ShopCategory", "Item"..i, "Sprite"):EnableRender(ITEM_LV, false);
				else
					local lv = IOManager:GetValue(IO_CAT_HACK, "Jade", ITEM_POS_JADE_ID[i]);
					if (lv) then
						UIManager:GetWidgetComponent("ShopCategory", "Item"..i, "Sprite"):SetImage(ITEM_LV, SHOP_LV_PREFIX..lv);
					else
					--log("JADE LOCK: "..i)
						self:ShowLockout(i);
						UIManager:GetWidgetComponent("ShopCategory", "Item"..i, "Sprite"):EnableRender(ITEM_LV, false);
					--log("JADE: "..i)					
					end
				end
--[[ @Old Method			
				if (IOManager:GetValue(IO_CAT_HACK, "Jade", i) == nil) then
					self:ShowLockout(i);
					UIManager:GetWidgetComponent("ShopCategory", "Item"..i, "Sprite"):EnableRender(ITEM_LV, false);
				end
--]]				
			end
		elseif (self.m_CurrentCategory == SHOP_CAT_AVATAR) then
			for i = 1, AVATAR_MAX do
				local itemId = self.m_ShopItems[index][i];
				if (self:HasSoldout(i, itemId)) then
					self:ShowSoldout(i);
				else
					if (ITEM_POS_AVATAR_IAP[i]) then
						self:ShowDollar(GAME_STUFF[itemId][STUFF_ATTR], i);
					else
						UIManager:GetWidgetComponent("ShopCategory", "Item"..i, "Sprite"):EnableRender(ITEM_TEXT, false);
						UIManager:EnableWidget("ShopCategory", "ItemNum"..i, CAT_SHOW_COST[index]);
					end
				end
			end
		elseif (self.m_CurrentCategory == SHOP_CAT_TREASURE) then		
			for i = 1, TREASURE_MAX do
				local itemId = self.m_ShopItems[index][i];
				self:ShowDollar(GAME_STUFF[itemId][STUFF_ATTR], i);
			end
			
			if (IOManager:GetRecord(IO_CAT_HACK, "StarterKit")) then
				self:ShowSoldout(1);
			end
		end
		
		-- Enable/Disable swipe
		UIManager:GetUI("ShopCategory"):EnableSwipe(CAT_CAN_SWIPE[index]);

		-- Reset target to 1st item
		self:UpdateShopTargetInfo(1);

		-- Reset UI swipe bounds
		self.m_UIFrame:SetSwipeDataRecord("bound", { -(itemCount + 1) * UI_SHOP_ITEM_SIZE[1], UI_SHOP_ITEM_SIZE[1] });
	end,
	---------------------------------------------------------------------
	SetInitialCategory = function(self, index)
		self.m_InitialCategory = index;
	end,
	---------------------------------------------------------------------
	UpdateShopIcon = function(self, itemId, pos, doReposition)
		assert(itemId);
		assert(pos);
		local item = GAME_STUFF[itemId];
		assert(item);

		-- Item icon
		UIManager:GetWidget("ShopCategory", "Item"..pos):SetImage(item[STUFF_SHOPLOOK], nil, true);		
		UIManager:GetWidgetComponent("ShopCategory", "Item"..pos, "Motion"):Reset();			
		UIManager:GetWidgetComponent("ShopCategory", "ItemNum"..pos, "Motion"):Reset();
		UIManager:EnableWidget("ShopCategory", "Item"..pos, true);

		-- Item price
		local price = item[STUFF_PRICE];
		local cost = math.abs(item[STUFF_PRICE]);

		if (doReposition) then
			local x = UI_SHOP_ITEM_ORIGIN[1] + UI_SHOP_ITEM_OFFSET * (pos - 1);
			local y = UI_SHOP_ITEM_ORIGIN[2];
			local offset = UI_SHOP_COIN_OFFSET[string.len(cost)];
			UIManager:GetWidgetComponent("ShopCategory", "Item"..pos, "Transform"):SetTranslate(x, y);
			UIManager:GetWidgetComponent("ShopCategory", "ItemNum"..pos, "Transform"):SetTranslate(x + offset[1] + UI_SHOP_NUM_OFFSET, y + offset[2]);
		end

		-- Set image to COIN, KOBAN or SOLDOUT
		if (self:HasSoldout(pos, self.m_TargetItemId)) then		
			self:ShowSoldout(pos);
			return;
		end
		
		if (CAT_SHOW_COST[self.m_CurrentCategory]) then
			UIManager:EnableWidget("ShopCategory", "ItemNum"..pos, true);
			UIManager:GetWidget("ShopCategory", "ItemNum"..pos):SetValue(cost);

			if (price > 0) then
				UIManager:GetWidget("ShopCategory", "ItemNum"..pos):ResetPrefix(UI_COIN_PREFIX);
				UIManager:GetWidgetComponent("ShopCategory", "Item"..pos, "Sprite"):EnableRender(ITEM_TEXT, false);
			elseif (price < 0) then
				UIManager:GetWidget("ShopCategory", "ItemNum"..pos):ResetPrefix(UI_KOBAN_PREFIX);
				UIManager:GetWidgetComponent("ShopCategory", "Item"..pos, "Sprite"):EnableRender(ITEM_TEXT, false);
			else
				self:ShowDollar(item[STUFF_ATTR], pos);
			end
		end
	end,
	---------------------------------------------------------------------
	UpdateShopTargetInfo = function(self, index)
		AudioManager:PlaySfx(SFX_UI_BUTTON_1);

		-- Update info
		self.m_TargetItemIndex = index;
		self.m_TargetItemId = self.m_ShopItems[self.m_CurrentCategory][index];
		self.m_TargetItem = GAME_STUFF[self.m_TargetItemId];
		self.m_TargetItemPrice = self.m_TargetItem[STUFF_PRICE];
		
		
		-- Update target cursor
		local x, y = UIManager:GetWidgetComponent("ShopCategory", "Item"..index, "Transform"):GetTranslate();
		UIManager:GetWidgetComponent("ShopCategory", "ItemTarget", "Transform"):SetTranslate(x + UI_SHOP_TARGET_OFFSET[1], y + UI_SHOP_TARGET_OFFSET[2]);

		local lv = 0;
		if (CAT_SHOW_LV[self.m_CurrentCategory]) then
			if (self.m_CurrentCategory == SHOP_CAT_JADE) then
				lv = IOManager:GetValue(IO_CAT_HACK, SHOP_CAT_INDEX[self.m_CurrentCategory], ITEM_POS_JADE_ID[self.m_TargetItemIndex]);
			else
				lv = IOManager:GetValue(IO_CAT_HACK, SHOP_CAT_INDEX[self.m_CurrentCategory], self.m_TargetItemIndex);
			end
		end

		-- Item has soldout
		if (self:HasSoldout(index, self.m_TargetItemId)) then
			if (self.m_CurrentCategory == SHOP_CAT_TREASURE) then
			-- Special case for StarterKit
				self:UpdateItemInfo("ShopInfo", self.m_TargetItem, lv);
			else
				local maxId = self.m_ShopItemsMaxItemId[self.m_CurrentCategory][index];
				self:UpdateItemInfo("ShopInfo", GAME_STUFF[maxId], lv);
			end
			self:UpdateActionButton("Max", lv);
			--log("SOLDOUT : "..index.."  [id] "..self.m_TargetItemId.." => "..maxId)
			return;
		--else
		--log("AVAIL : "..index.."  [id] "..self.m_TargetItemId)
		end

		self:UpdateItemInfo("ShopInfo", self.m_TargetItem, lv);

		-- Update BUY/UPGRADE buttons
		if (self.m_CurrentCategory == SHOP_CAT_WEAPON) then
			self:UpdateActionButton("Upgrade", lv);
		elseif (self.m_CurrentCategory == SHOP_CAT_JADE) then
			if (self.m_TargetItemPrice == 0) then
				self:UpdateActionButton("Buy", lv);
			else
				self:UpdateActionButton("Upgrade", lv);
			end
		else -- Avatar, Coinbag, Treasure
			self:UpdateActionButton("Buy", lv);
		end
	end,
	---------------------------------------------------------------------
	UpdateActionButton = function(self, widget, lv)
		assert(self.m_TargetItemPrice);
		
		local hasEnoughMoney = true;
		if (widget == "Buy") then
			if (self.m_TargetItemPrice > 0) then -- Coins
				hasEnoughMoney = MoneyManager:HasEnoughCoin(self.m_TargetItemPrice);
			elseif (self.m_TargetItemPrice < 0) then -- Kobans
				hasEnoughMoney = MoneyManager:HasEnoughKoban(-self.m_TargetItemPrice);
			else -- Dollars
				hasEnoughMoney = true;
			end
			UIManager:EnableWidget("ShopInfo", "Upgrade", false);
		elseif (widget == "Upgrade") then
			UIManager:EnableWidget("ShopInfo", "Buy", false);
			if (lv == nil) then  -- Jade is locked
				UIManager:EnableWidget("ShopInfo", "Upgrade", false);
				UIManager:GetWidget("ShopInfo", "Upgrade"):Enable(false);
				return;
			end
		elseif (widget == "Max") then
			UIManager:EnableWidget("ShopInfo", "Buy", false);
			UIManager:EnableWidget("ShopInfo", "Upgrade", false);
			return;
		else
			assert(false);
		end
		
		UIManager:EnableWidget("ShopInfo", widget, true);
		UIManager:GetWidget("ShopInfo", widget):Enable(hasEnoughMoney);

		if (hasEnoughMoney) then
			CycleGOScale(UIManager:GetWidgetObject("ShopInfo", widget), 1.0, 1.05, 500);
		else
			UIManager:GetWidgetComponent("ShopInfo", widget, "Interpolator"):Reset();
			UIManager:GetWidgetComponent("ShopInfo", widget, "Transform"):SetScale(1.0);
		end
	end,
	---------------------------------------------------------------------
	UpdateItemInfo = function(self, ui, item, lv)
		local itemType = item[STUFF_TYPE];
		local attr = item[STUFF_ATTR];

		-- Main info
		--log("item info pic: "..item[STUFF_INFO])
		UIManager:EnableWidget(ui, "ItemInfo", true);
		UIManager:GetWidget(ui, "ItemInfo", "Sprite"):SetImage(item[STUFF_INFO]);
		SetInfoPos(ui, "ItemInfo", UI_SHOPINFO_INFO_POS);
		-- Sub description
		local desc = item[STUFF_DESC];
		UIManager:EnableWidget(ui, "ItemDesc", desc);
		if (desc) then
			UIManager:GetWidget(ui, "ItemDesc", "Sprite"):SetImage(desc);
			SetInfoPos(ui, "ItemDesc", UI_SHOPINFO_DESC_POS[itemType]);
		end
		
		-- Item icon & lv
		UIManager:EnableWidget(ui, "ItemIcon", item[STUFF_ICON]);
		UIManager:EnableWidget(ui, "ItemLv", item[STUFF_ICON]);
		if (item[STUFF_ICON]) then
			UIManager:GetWidget(ui, "ItemIcon"):ResetImage(item[STUFF_ICON]);
			SetInfoPos(ui, "ItemIcon", UI_SHOPINFO_ICON_POS);

			if (itemType == ST_TREASURE) then  -- Special case for treasure DISCOUNT
				UIManager:EnableWidget(ui, "ItemLv", false);
				UIManager:GetWidgetComponent(ui, "ItemIcon", "Transform"):SetScale(1.5);
			else
				UIManager:GetWidget(ui, "ItemLv"):SetImage(SHOP_LV_PREFIX..lv);
				SetInfoPos(ui, "ItemLv", UI_SHOPINFO_LV_POS);
				UIManager:GetWidgetComponent(ui, "ItemIcon", "Transform"):SetScale(1.0);
			end
		end
		
		-- Item type specific
		UIManager:ToggleWidgetGroup(ui, "WeaponValues", false);		
		
		-- Position for value 1~3
		if (UI_SHOPINFO_VALUE_POS[itemType]) then
			for i = 1, 3 do
				local pos = UI_SHOPINFO_VALUE_POS[itemType][i];
				if (pos) then
					SetInfoPos(ui, "ItemValue"..i, pos);
				end
			end
		end
		
		if (itemType == ST_WEAPON) then
			-- Update weapon values
			UIManager:GetWidget(ui, "ItemValue1"):SetValue(attr[ST_WEAPON_POWER]);
			UIManager:GetWidget(ui, "ItemValue2"):SetValue(attr[ST_WEAPON_ENERGY]);
			UIManager:GetWidget(ui, "ItemValue3"):SetValue(attr[ST_WEAPON_CRITICAL]);
			UIManager:ToggleWidgetGroup(ui, "WeaponValues", true);
		elseif (itemType == ST_JADE) then
			if (type(attr) == "number") then
				UIManager:GetWidget(ui, "ItemValue1"):SetValue(attr);
				UIManager:ToggleWidgetGroup(ui, "SingleValues", true);
			end
		elseif (itemType == ST_AVATAR) then
			UIManager:EnableWidget(ui, "ItemDesc", false);
			UIManager:EnableWidget(ui, "ItemIcon", false);
		elseif (itemType == ST_COIN) then
			UIManager:EnableWidget(ui, "ItemDesc", false);
			UIManager:EnableWidget(ui, "ItemIcon", false);
		elseif (itemType == ST_TREASURE) then
			UIManager:EnableWidget(ui, "ItemDesc", false);
			--UIManager:EnableWidget(ui, "ItemIcon", false);
		else
			UIManager:EnableWidget(ui, "ItemInfo", false);
			UIManager:EnableWidget(ui, "ItemDesc", false);
			UIManager:EnableWidget(ui, "ItemIcon", false);
		end
				
		-- Special case for Xmas sales "N% OFF" tag
		if (self.m_TargetItemIndex == 1) then
			local result = false;
			if (itemType == ST_JADE) then
				result = true;
				UIManager:GetWidget(ui, "ItemIcon"):ResetImage("ui_shopicon_xmaxoff_01");
			elseif (itemType == ST_AVATAR) then
				result = true;
				UIManager:GetWidget(ui, "ItemIcon"):ResetImage("ui_shopicon_xmaxoff_01");
			elseif (itemType == ST_TREASURE) then
				result = true;
				UIManager:GetWidget(ui, "ItemIcon"):ResetImage("ui_shopicon_xmaxoff_02");		
			end

			if (result) then
				UIManager:EnableWidget(ui, "ItemIcon", true);
				UIManager:GetWidgetComponent(ui, "ItemIcon", "Transform"):SetScale(1.0);
				SetInfoPos(ui, "ItemIcon", UI_SHOPINFO_SALES_POS);
			end
		end
	end,
	
	--======================
	-- @Upgrade
	--======================
	---------------------------------------------------------------------
	UpdateUpgradeUI = function(self)
		local itemPos = self.m_TargetItemIndex;
		local itemCat = self.m_CurrentCategory;
		local itemCatName = SHOP_CAT_INDEX[itemCat];
		
		local lv;
		if (self.m_CurrentCategory == SHOP_CAT_JADE) then
			lv = IOManager:GetValue(IO_CAT_HACK, "Jade", ITEM_POS_JADE_ID[itemPos]);
		else
			lv = IOManager:GetValue(IO_CAT_HACK, itemCatName, itemPos);
		end
		
		local itemId = SHOP_ITEM_POOL[itemCatName][itemPos][lv + 1];
		local itemIdPre = SHOP_ITEM_POOL[itemCatName][itemPos][lv];
		local item = GAME_STUFF[itemId];
		local itemPre = GAME_STUFF[itemIdPre];
		
		if ((itemId == nil) or (itemIdPre == nil)) then
			log("UpdateUpgradeUI: item error")
			return;
		end
		
		local attr = item[STUFF_ATTR];
		local attrPre = itemPre[STUFF_ATTR];
		--log("itemId: "..itemId.." / itemPre: "..itemIdPre)

		-- Re-position cost numbers
		local price = item[STUFF_PRICE];
		local cost = math.abs(item[STUFF_PRICE]);
		--log("item price: "..price)
		
		local offset = UI_SHOP_COST_OFFSET[string.len(cost)];
		UIManager:SetWidgetTranslate("ShopUpgrade", "Cost", UI_SHOP_COST_POS[1] + offset, UI_SHOP_COST_POS[2]);
		
		-- Cost & Button
		self.m_TargetItemPrice = price;
		UIManager:GetWidget("ShopUpgrade", "Cost"):SetValue(cost);
		
		self.m_HasEnoughMoney = false;
		if (price > 0) then
			UIManager:GetWidget("ShopUpgrade", "Cost"):ResetPrefix(UI_COIN_PREFIX);
			self.m_HasEnoughMoney = MoneyManager:HasEnoughCoin(self.m_TargetItemPrice);
		else --if (price < 0) then
			UIManager:GetWidget("ShopUpgrade", "Cost"):ResetPrefix(UI_KOBAN_PREFIX);
			self.m_HasEnoughMoney = MoneyManager:HasEnoughKoban(-self.m_TargetItemPrice);
		end
		
		-- Upgrade button
		if (self.m_HasEnoughMoney) then
			CycleGOScale(UIManager:GetWidgetObject("ShopUpgrade", "Go"), 1.0, 1.05, 500);
			--UIManager:GetWidget("ShopUpgrade", "Go"):Enable(true);
		else
			UIManager:GetWidgetComponent("ShopUpgrade", "Go", "Interpolator"):Reset();
			UIManager:GetWidgetComponent("ShopUpgrade", "Go", "Transform"):SetScale(0.9);
			--UIManager:GetWidget("ShopUpgrade", "Go"):Enable(false);
		end

		self:UpdateItemInfo("ShopUpgrade", itemPre, lv);

		for i = 1, 3 do		-- Position for value 1~3
			local pos = UI_SHOPINFO_POSTVALUE_POS[ item[STUFF_TYPE] ][i];
			if (pos) then
				SetInfoPos("ShopUpgrade", "ItemValuePost"..i, pos);
			end
		end
		
		if (item[STUFF_TYPE] == ST_WEAPON) then
			UIManager:EnableWidget("ShopUpgrade", "ItemIcon", true);
			UIManager:EnableWidget("ShopUpgrade", "ItemLv", true);
			UIManager:EnableWidget("ShopUpgrade", "ItemValuePost2", true);
			UIManager:EnableWidget("ShopUpgrade", "ItemValuePost3", true);

			UIManager:GetWidget("ShopUpgrade", "ItemIcon"):SetImage(item[STUFF_ICON]);
			SetInfoPos("ShopUpgrade", "ItemIcon", UI_SHOPINFO_UPGICON_POS);

			UIManager:GetWidget("ShopUpgrade", "ItemLv"):SetImage(SHOP_LV_PREFIX..(lv + 1));
			SetInfoPos("ShopUpgrade", "ItemLv", UI_SHOPINFO_UPGLV_POS);

			UIManager:GetWidget("ShopUpgrade", "ItemValuePost1"):SetValue(attr[ST_WEAPON_POWER]);
			UIManager:GetWidget("ShopUpgrade", "ItemValuePost2"):SetValue(attr[ST_WEAPON_ENERGY]);
			UIManager:GetWidget("ShopUpgrade", "ItemValuePost3"):SetValue(attr[ST_WEAPON_CRITICAL]);
			
			UIManager:GetWidget("ShopUpgrade", "ItemArrow"):SetImage("ui_upgrade_weaponinfo");
			UIManager:SetWidgetTranslate("ShopUpgrade", "ItemArrow", UI_SHOPINFO_UPG_ARROW[1], UI_SHOPINFO_UPG_ARROW[2]);

			if (item[STUFF_DESC]) then
				SetInfoPos("ShopUpgrade", "ItemDesc", UI_SHOPINFO_DESC_POS[ST_WEAPON]);
				UIManager:EnableWidget("ShopUpgrade", "ItemDesc", true);
				UIManager:GetWidget("ShopUpgrade", "ItemDesc"):SetImage(item[STUFF_DESC]);
			end
		elseif (item[STUFF_TYPE] == ST_JADE) then
			UIManager:EnableWidget("ShopUpgrade", "ItemIcon", false);
			UIManager:EnableWidget("ShopUpgrade", "ItemLv", false);
			UIManager:EnableWidget("ShopUpgrade", "ItemValuePost2", false);
			UIManager:EnableWidget("ShopUpgrade", "ItemValuePost3", false);
			
			if (item[STUFF_INFO] == "ui_iteminfo_jade05") then  -- Special case for Jade of Rage
				UIManager:GetWidget("ShopUpgrade", "ItemArrow"):SetImage("ui_upgrade_jadeinfo2");
				UIManager:SetWidgetTranslate("ShopUpgrade", "ItemArrow", UI_SHOPINFO_UPG_ARROW_SP[1], UI_SHOPINFO_UPG_ARROW_SP[2]);
			else
				UIManager:GetWidget("ShopUpgrade", "ItemArrow"):SetImage("ui_upgrade_jadeinfo1");
				UIManager:SetWidgetTranslate("ShopUpgrade", "ItemArrow", UI_SHOPINFO_UPG_ARROW[1], UI_SHOPINFO_UPG_ARROW[2]);
			end

			UIManager:GetWidget("ShopUpgrade", "ItemValuePost1"):SetValue(attr);
		end
	end,
	---------------------------------------------------------------------
	UpgradeAction = function(self)
		if (self.m_HasEnoughMoney) then
			self.m_HasEnoughMoney = false;
			self:BuyTargetItem();

			local transGC = UIManager:GetUIComponent("ShopUpgrade", "Transform");
			local x, y = transGC:GetTranslate();
			transGC:SetTranslate(x, -SCREEN_UNIT_Y);
			UIManager:ToggleUI("ShopUpgrade");

			StageManager:ChangeStage("Shop");
		else
			AudioManager:PlaySfx(SFX_OBJECT_NO_ENERGY);
			GameKit.ShowMessage("text_status", "shop_no_coin");
		end
	end,
	---------------------------------------------------------------------
	BuyTargetItem = function(self)
		--log("BuyTargetItem : [id] "..self.m_TargetItemId)
		local itemBought = true;		
		local itemType = self.m_TargetItem[STUFF_TYPE];
		local attr = self.m_TargetItem[STUFF_ATTR];
		
		if (itemType == ST_WEAPON) then
		--====================================
		-- WEAPON
		--====================================		
			self:UpgradeTargetItem("Weapon");
			
			local str = WEAPON_STR[ attr[ST_WEAPON_TYPE] ];
			if (str) then
				--log("Weapon Upgraded: "..str)
				GameKit.LogEventWithParameter("Upgrade", str, "Weapon", false);
			end
			GameKit.LogEventWithParameter("Money", "weapon", "CoinUsage", false);
		elseif (itemType == ST_JADE) then
		--====================================
		-- JADE
		--====================================		
			if (self.m_TargetItem[STUFF_PRICE] == 0) then
			-- IAP jades
				itemBought = false;
				local obj = IAP_ITEM_CALLBACK[self.m_TargetItemId];
				if (obj) then
					BuyProduct(obj[1], obj[2], true);
				end
			else
			-- Normal jades
				self:UpgradeTargetItem("Jade");				
				GameKit.LogEventWithParameter("Money", "jade", "CoinUsage", false);

				local str = JADE_STR[ ITEM_POS_JADE_ID[self.m_TargetItemIndex] ];
				if (str) then
					--log("Jade Upgraded: "..str)
					GameKit.LogEventWithParameter("Upgrade", str, "Jade", false);
				end
			end
		elseif (itemType == ST_AVATAR) then
		--====================================
		-- AVATAR
		--====================================		
			if (self.m_TargetItem[STUFF_PRICE] == 0) then
			-- IAP avatars
				itemBought = false;
				local obj = IAP_ITEM_CALLBACK[self.m_TargetItemId];
				if (obj) then
					BuyProduct(obj[1], obj[2], true);
				end
			else
			-- Normal avatars
				self:BuyAvatar();

				local str = AVATAR_STR[self.m_TargetItemId];
				if (str) then
					--log("Avatar Bought: "..str)
					GameKit.LogEventWithParameter("Upgrade", str, "Avatar", false);
				end
				GameKit.LogEventWithParameter("Money", "avatar", "KobanUsage", false);
			end
		elseif (itemType == ST_COIN) then
		--====================================
		-- COIN
		--====================================		
			CoinEarned(attr[ST_ITEM_VALUE]);

			for i = 1, COINBAG_MAX do
				if (self.m_TargetItemId == SHOP_ITEM_POOL["Coinbag"][i]) then
					--log("Coinbag bought : bag #"..i);
					--GameKit.LogEventWithParameter("Shop", "bag #" .. i, "Coinbag", false);
					GameKit.LogEventWithParameter("Upgrade", "bag #" .. i, "Coinbag", false);
				end
			end			
			GameKit.LogEventWithParameter("Money", "coinbag", "KobanUsage", false);
		elseif (itemType == ST_TREASURE) then
		--====================================
		-- GOLD
		--====================================		
			itemBought = false;
			local obj = IAP_ITEM_CALLBACK[self.m_TargetItemId];
			if (obj) then
				BuyProduct(obj[1], obj[2], true);
			end
		else
			log("Unsupported item effect: "..self.m_TargetItemId)
		end

		if (itemBought) then
			if (self.m_TargetItemPrice > 0) then -- Cost Coins
				MoneyManager:ModifyCoinWithMotion(-self.m_TargetItemPrice, "Shop");
			elseif (self.m_TargetItemPrice < 0) then -- Cost Kobans
				MoneyManager:ModifyKobanWithMotion(self.m_TargetItemPrice, "Shop");
			end
			
			IOManager:Save();
			
			self:UpdateShopTargetInfo(self.m_TargetItemIndex);
			self:CompleteIAP();
		end
	end,
	---------------------------------------------------------------------
	CompleteIAP = function(self, iapItem)
		self.m_SellerSM:ChangeState("buy");
		if (iapItem) then
			AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);
		else
			AudioManager:PlaySfx(SFX_UI_MONEY_SPEND);
		end

		SaveToCloud();
	end,
	---------------------------------------------------------------------	
	UpgradeTargetItem = function(self, itemType)
		local itemPos = self.m_TargetItemIndex;
		local itemCat = self.m_CurrentCategory;
		local itemCatName = SHOP_CAT_INDEX[itemCat];		

		local lv;
		if (self.m_CurrentCategory == SHOP_CAT_JADE) then
			lv = IOManager:ModifyValue(IO_CAT_HACK, "Jade", ITEM_POS_JADE_ID[itemPos], 1);
		else
			lv = IOManager:ModifyValue(IO_CAT_HACK, itemCatName, itemPos, 1);
		end
		local itemId = SHOP_ITEM_POOL[itemCatName][itemPos][lv];
		assert(itemId, "Error: No More Upgrades");
		--log("[UPG] "..itemType.." for "..itemPos.." => Lv "..lv)
		--log("   new itemId => "..itemId.." @ Lv "..lv + 1)		

		self.m_ShopItems[itemCat][itemPos] = itemId;
		self.m_TargetItemId = itemId;
		self:UpdateShopIcon(itemId, itemPos, false);
		
		UIManager:GetWidgetComponent("ShopCategory", "Item"..itemPos, "Sprite"):SetImage(ITEM_LV, SHOP_LV_PREFIX..lv);
		
		if (itemType == "Weapon") then
			self:UpdateShopAchievement(ACH_WEAPON_PROGRESS, itemPos, lv);
			
			if (lv == WEAPON_MAX_LV and WEAPON_STR[itemPos]) then
				--log("ShopMax WEAPON LV: "..lv.." @ "..WEAPON_STR[itemPos])
				GameKit.LogEventWithParameter("ShopMax", WEAPON_STR[itemPos], "Weapon", false);
			end
			--if (SHOP_WEAPON_NAME[itemPos]) then
			--	GameKit.LogEventWithParameter("Shop", SHOP_WEAPON_NAME[itemPos], "Weapon", false);
			--end
		elseif (itemType == "Jade") then
			self:UpdateShopAchievement(ACH_JADE_PROGRESS, ITEM_POS_JADE_ID[itemPos], lv);

			if (lv == JADE_MAX_LV and JADE_STR[ ITEM_POS_JADE_ID[itemPos] ]) then
				--log("ShopMax JADE LV: "..lv.." @ "..JADE_STR[ ITEM_POS_JADE_ID[itemPos] ])
				GameKit.LogEventWithParameter("ShopMax", JADE_STR[ ITEM_POS_JADE_ID[itemPos] ], "Jade", false);
			end
			--if (SHOP_JADE_NAME[itemPos]) then
			--	GameKit.LogEventWithParameter("Shop", SHOP_JADE_NAME[itemPos], "Jade", false);
			--end
		--else
			-- N/A
		end
	end,
	---------------------------------------------------------------------
	UpdateShopAchievement = function(self, cat, index, lv)
		if (cat[index]) then
			for _, v in ipairs(cat[index]) do
				UpdateAchievement(v, lv, true);
			end
		end
	end,
	---------------------------------------------------------------------
	SerializeAvatar = function(self, id)

		if (not IOManager:GetValue(IO_CAT_HACK, "Avatar", id)) then
			IOManager:SetValue(IO_CAT_HACK, "Avatar", id, 1);
			IOManager:SetValue(IO_CAT_HACK, "AvatarLv", id, 1);
			IOManager:SetValue(IO_CAT_HACK, "AvatarExp", id, 0);
			IOManager:SetValue(IO_CAT_HACK, "Avatar", "Equip", id, true);
			--log("BuyAvatar @ avatar id # "..id.." => item id: "..self.m_TargetItemId)
		end
	end,
	---------------------------------------------------------------------	
	SerializeJade = function(self, id)

		if (not IOManager:GetValue(IO_CAT_HACK, "Jade", id)) then
			IOManager:SetValue(IO_CAT_HACK, "Jade", JADE_EFFECT_INNO_PROTECT, 1);
			IOManager:SetValue(IO_CAT_HACK, "Jade", "Equip", JADE_EFFECT_INNO_PROTECT, true);
		end
	end,
	---------------------------------------------------------------------	
	BuyAvatar = function(self)
		local itemPos = self.m_TargetItemIndex;
		self:SerializeAvatar(ITEM_POS_AVATAR_ID[itemPos]);
		self:ShowSoldout(itemPos);
	end,
	---------------------------------------------------------------------
	BuyAvatarByDollar = function(self, itemPos, firstBuy)
		self:SerializeAvatar(ITEM_POS_AVATAR_ID[itemPos]);
		
		if (firstBuy) then		
			self:ShowSoldout(itemPos);
			self:CompleteIAP(true);

			UIManager:EnableWidget("ShopInfo", "Buy", false);

			if (AVATAR_STR[id]) then
				--log("IAP Avatar : "..AVATAR_STR[id])
				GameKit.LogEventWithParameter("Upgrade", AVATAR_STR[id], "Avatar", false);
			end
		end
	end,
	---------------------------------------------------------------------
	BuyJadeByDollar = function(self, itemPos, firstBuy)
		-- Serialize jade
		local id = ITEM_POS_JADE_ID[itemPos];
		IOManager:SetValue(IO_CAT_HACK, "Jade", id, 1);
		IOManager:SetValue(IO_CAT_HACK, "Jade", "Equip", id, true);
		
		UpdateAchievement(ACH_JADE_PROTECTION);

		if (firstBuy) then
			self:ShowSoldout(itemPos);
			self:CompleteIAP(true);

			UIManager:EnableWidget("ShopInfo", "Buy", false);

			if (JADE_STR[id]) then
				--log("IAP Jade : "..JADE_STR[id])
				GameKit.LogEventWithParameter("Upgrade", JADE_STR[id], "Jade", false);
			end
		end
	end,
	---------------------------------------------------------------------
	BuyStarterKitByDollar = function(self, firstBuy)
        self:SerializeAvatar(ITEM_POS_AVATAR_ID[2]);  -- Thief

		if (IOManager:GetRecord(IO_CAT_HACK, "StarterKit") ~= true) then
			CoinEarned(IAP_STARTERKIT_COIN);
			KobanEarned(TREASURE_COUNT[5]);
		end

		IOManager:SetRecord(IO_CAT_HACK, "StarterKit", true);
		
		if (firstBuy) then
			UIManager:EnableWidget("ShopInfo", "Buy", false);
			self:ShowSoldout(1);
	        self:CompleteIAP(true);
		end
	end,
	---------------------------------------------------------------------
	HasSoldout = function(self, index, itemId)
		if (self.m_CurrentCategory == SHOP_CAT_AVATAR) then
			if (IOManager:GetValue(IO_CAT_HACK, "Avatar", itemId - AVATAR_ID_PREFIX)) then
			--log("SOLDOUT: "..itemId.." / index: "..index)
				return true;
			end
		elseif (self.m_CurrentCategory == SHOP_CAT_JADE) then
			local realId = ITEM_POS_JADE_ID[index];
			if (ITEM_POS_JADE_IAP[index]) then	-- Special case for IAP jades
				if (IOManager:GetValue(IO_CAT_HACK, "Jade", realId)) then
					return true;
				end
			else			
				if (itemId == self.m_ShopItemsMaxItemId[self.m_CurrentCategory][index]) then
				--if (itemId == self.m_ShopItemsMaxItemId[self.m_CurrentCategory][realId]) then
					return true;
				end
			end
		elseif (self.m_CurrentCategory == SHOP_CAT_TREASURE) then
			if (itemId == 9201 and IOManager:GetRecord(IO_CAT_HACK, "StarterKit") == true) then
				return true;
			end
		else
			if (itemId == self.m_ShopItemsMaxItemId[self.m_CurrentCategory][index]) then
				return true;
			end
		end
		
		return false;
	end,
	---------------------------------------------------------------------
	ShowSoldout = function(self, index)
		--log("Soldout @ "..index)
		UIManager:GetWidgetComponent("ShopCategory", "Item"..index, "Sprite"):ResetImage(ITEM_TEXT, "ui_shop_soldout");
		UIManager:GetWidgetComponent("ShopCategory", "Item"..index, "Sprite"):SetOffset(ITEM_TEXT, -3, 66);
		UIManager:GetWidgetComponent("ShopCategory", "Item"..index, "Sprite"):EnableRender(ITEM_TEXT, true);
		UIManager:EnableWidget("ShopCategory", "ItemNum"..index, false);
	end,
	---------------------------------------------------------------------
	ShowLockout = function(self, index)
		--log("ShowLockout : "..index)
		UIManager:GetWidgetComponent("ShopCategory", "Item"..index, "Sprite"):ResetImage(ITEM_TEXT, "ui_shop_locked");
		UIManager:GetWidgetComponent("ShopCategory", "Item"..index, "Sprite"):SetOffset(ITEM_TEXT, -3, 61);
		UIManager:GetWidgetComponent("ShopCategory", "Item"..index, "Sprite"):EnableRender(ITEM_TEXT, true);
		UIManager:EnableWidget("ShopCategory", "ItemNum"..index, false);
	end,
	---------------------------------------------------------------------
	ShowDollar = function(self, priceTag, pos)
		UIManager:GetWidgetComponent("ShopCategory", "Item"..pos, "Sprite"):ResetImage(ITEM_TEXT, priceTag);
		UIManager:GetWidgetComponent("ShopCategory", "Item"..pos, "Sprite"):SetOffset(ITEM_TEXT, -10, 66);
		UIManager:GetWidgetComponent("ShopCategory", "Item"..pos, "Sprite"):EnableRender(ITEM_TEXT, true);
		UIManager:EnableWidget("ShopCategory", "ItemNum"..pos, false);
	end,
	---------------------------------------------------------------------
	GetBuyableCount = function(self)
		local count = 0;
		
		for i = 1, WEAPON_MAX do
			local lv = IOManager:GetValue(IO_CAT_HACK, "Weapon", i);
			if (lv) then
				local price = WEAPON_PRICE[i][lv + 1];
				if (price and MoneyManager:HasEnoughCoin(price)) then
					count = count + 1;
				end
			end
		end
		
		for i = 1, JADE_NORMAL_MAX do --JADE_MAX do
			local lv = IOManager:GetValue(IO_CAT_HACK, "Jade", i);
			if (lv) then
				local price = JADE_PRICE[i][lv + 1];
				if (price and MoneyManager:HasEnoughCoin(price)) then
					count = count + 1;
				end				
			end
		end
		
		return count;
	end,
	---------------------------------------------------------------------
	ShowShopIcon = function(self)
		local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal");
		-- Unlock SHOP when:
		--   1) 500m reached in 1st stage
		--   2) 2nd stage is unlocked
		if ((rec[1] ~= nil and rec[1]["Medal"] > 0) or (rec[2] ~= nil)) then
			UIManager:EnableWidget("EndlessMap", "SHOP", true);
			return true;
		else
			UIManager:EnableWidget("EndlessMap", "SHOP", false);
		end
		return false;
	end,
	---------------------------------------------------------------------
	ShowShopButton = function(self)
		--local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal");
		--if (rec[1] and (rec[1]["Medal"] > 0)) then
		--	UIManager:EnableWidget("GameStat", "Shop", true);
		if (self:ShowShopIcon()) then
			local count = ShopManager:GetBuyableCount();
			if (count > 0) then
				UIManager:GetWidgetComponent("GameStat", "Shop", "Sprite"):EnableRender(2, true);
				UIManager:GetWidgetComponent("GameStat", "Shop", "Sprite"):SetImage(2, "ui_shop_tip"..count);
			else
				UIManager:GetWidgetComponent("GameStat", "Shop", "Sprite"):EnableRender(2, false);
			end
		--else
		--	UIManager:EnableWidget("GameStat", "Shop", false);
		end
	end,
};



-------------------------------------------------------------------------
function SetInfoPos(ui, widget, pos)
	local o = UI_SHOPINFO_POS[ui];
	UIManager:SetWidgetTranslate(ui, widget, o[1] + pos[1], o[2] + pos[2]);
end
