--***********************************************************************
-- @file GameScroll.lua
--***********************************************************************

-------------------------------------------------------------------------
SCROLL_SLOT_MAX = 6;

SCROLL_CAT_SCROLL = 1;
SCROLL_CAT_JADE = 2;
SCROLL_CAT_AVATAR = 3;
SCROLL_MAX_PAGE = SCROLL_CAT_AVATAR;

SCROLL_EFFECT_MAX = 13;

SCROLL_STATUS_NONE = 1;
SCROLL_STATUS_READY = 2;
SCROLL_STATUS_USED = 3;

SCROLL_EFFECT_NONE = 0;
SCROLL_EFFECT_CASTLE_SHIELD = 1;
SCROLL_EFFECT_ENERGY = 2;
SCROLL_EFFECT_LIFE = 4;
SCROLL_EFFECT_ENEMY_FREEZE = 3;
SCROLL_EFFECT_ENEMY_KILL = 5;
SCROLL_MAX = SCROLL_EFFECT_ENEMY_KILL;

SCROLL_T_NAME = 1;
SCROLL_T_ICON = 2;
SCROLL_T_COST = 3;
SCROLL_T_SYMBOL = 4;
SCROLL_T_TEXT = 5;
SCROLL_T_ICONBAR = 6;
SCROLL_T_COOLDOWN = 7;
SCROLL_T_MASK = 8;

MASK_COLOR_DEFAULT = { 0.1, 0.1, 0.1, 0.5 };

SCROLL_COST_SHADOW = 3;
SCROLL_COST_CHALLENGE = 10;

SCROLL_DATA =
{
	[SCROLL_EFFECT_CASTLE_SHIELD] =
	{
		"avatar_shield",
		"ui_scroll_icon_01",
		50,
		"scrolleffect_magiccircle_symbol_01",
		"ui_scroll_dialog_01",
		"ui_scroll_iconbar_01",
		50000,
		MASK_COLOR_DEFAULT,
	},

	[SCROLL_EFFECT_ENERGY] =
	{
		"avatar_energy",
		"ui_scroll_icon_02",
		65,
		"scrolleffect_magiccircle_symbol_02",
		"ui_scroll_dialog_02",
		"ui_scroll_iconbar_02",
		30000,
		{ 0.117, 0.306, 0.415, 0.5 },
	},

	[SCROLL_EFFECT_ENEMY_FREEZE] =
	{
		"enemy_blizzard",
		"ui_scroll_icon_03",
		80,
		"scrolleffect_magiccircle_symbol_03",
		"ui_scroll_dialog_03",
		"ui_scroll_iconbar_03",
		50000,
		{ 0, 0, 0, 0 },
	},

	[SCROLL_EFFECT_LIFE] =
	{
		"avatar_life",
		"ui_scroll_icon_04",
		100,
		"scrolleffect_magiccircle_symbol_04",
		"ui_scroll_dialog_04",
		"ui_scroll_iconbar_04",
		60000,
		{ 0.725, 0.423, 0.239, 0.5 },
	},

	[SCROLL_EFFECT_ENEMY_KILL] =
	{
		"enemy_meteor",
		"ui_scroll_icon_05",
		125,
		"scrolleffect_magiccircle_symbol_05",
		"ui_scroll_dialog_05",
		"ui_scroll_iconbar_05",
		50000,
		{ 0.7, 0.1, 0.1, ALPHA_HALF },
	},
--[[
	[SCROLL_EFFECT_ENEMY_POISON] =
	{
		"enemy_poison",
		"ui_scroll_icon_05",
		150,
		"scrolleffect_magiccircle_symbol_05",
		"ui_scroll_dialog_05",
		35000,
		MASK_COLOR_DEFAULT,
	},
--]]
};

SCROLL_METEOR_BOSS_DAMAGE = 100;



-------------------------------------------------------------------------
ScrollManager =
{	
	m_Scrolls = {},
	m_ScrollsStatus = {},
	m_ScrollsBought = {},
	m_ScrollsBoughtCount = 0,
	m_ColorMask = MASK_COLOR_GREY,

	m_EffectPool = nil,
	m_ActiveEffects = nil,
	m_ScrollPreEffectBKUp = nil,
	m_ScrollPreEffectBKDown = nil,
	m_ScrollPreEffectMCOut = nil,
	m_ScrollPreEffectMCIn = nil,
	m_ScrollShowTimer = nil,
	m_ScrollCooldownSM = {},
	m_ScrollEffectPool = { {}, {} },
	m_CurrentScrollIndex = 0,
	m_CurrentScrollCooldown = 0,
	
	m_IsScrollPage = false,
	m_EquippedAvatar = 0,
	m_EquippedJade = 0,
	m_CurrentScrollCategory = SCROLL_CAT_SCROLL,

	---------------------------------------------------------------------
	Create = function(self)
		self.m_EffectPool = PoolManager:Create("ScrollEffectObject", SCROLL_EFFECT_MAX);
		self.m_ActiveEffects = self.m_EffectPool:GetActivePool();

		for i = 1, SCROLL_SLOT_MAX do
			CycleGOAlpha(UIManager:GetWidgetObject("ScrollSelect", "Scroll"..i), ALPHA_MAX, ALPHA_QUARTER, 1000);
		end
		
		self.m_ScrollPreEffectBKUp = UIManager:GetWidgetObject("PreGameScroll", "ScrollPreEffectBKUp");
		self.m_ScrollPreEffectBKDown = UIManager:GetWidgetObject("PreGameScroll", "ScrollPreEffectBKDown");
		self.m_ScrollPreEffectMCOut = UIManager:GetWidgetObject("PreGameScroll", "ScrollPreEffectMCOut");
		self.m_ScrollPreEffectMCIn = UIManager:GetWidgetObject("PreGameScroll", "ScrollPreEffectMCIn");
		
		self.m_ScrollShowTimer = ObjectFactory:CreateGameObject("Clock");
		
		for i = 1, 2 do
			local obj = UIManager:GetWidgetObject("InGame", "Scroll"..i);
			obj["Attribute"]:Set("Index", i);
			self.m_ScrollCooldownSM[i] = obj["StateMachine"];
		end

		self:SetScrollInTutorial(false);
		log("ScrollManager creation done");
	end,
	---------------------------------------------------------------------
	Reset = function(self, noDialog)
		for i = 1, 2 do
			self.m_ScrollsStatus[i] = SCROLL_STATUS_NONE;

			-- Reset scroll cooldown
			local go = UIManager:GetWidgetObject("InGame", "Scroll"..i);
			local width, height = go["Sprite"]:GetSize();
			go["Sprite"]:GetSprite(2):SetQuadVertices(0, 0, 0, height, width, 0, width, height);
			go["Sprite"]:SetIndieOffset(2, 0, 0);
			go["Interpolator"]:Reset();
			go["Transform"]:SetScale(1.0);
			go["StateMachine"]:ChangeState("inactive");

			UIManager:EnableWidget("InGame", "Scroll"..i, false);
		end

		UIManager:SetWidgetTranslate("ScrollSelect", "Master", SCREEN_UNIT_X * 0.5, SCREEN_UNIT_Y);
		UIManager:EnableWidget("ScrollSelect", "ScrollText", false);
		
		for i = 1, SCROLL_MAX do
			self.m_ScrollsBought[i] = nil;
			
			UIManager:GetWidget("ScrollSelect", "ScrollButton"..i):SetImage("ui_scroll_button_buy");
			UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, false);
		end
		self.m_ScrollsBoughtCount = 0;

		-- Reset scroll cost according to level difficulty
		for i = 1, SCROLL_SLOT_MAX do
			UIManager:GetWidget("ScrollSelect", "ScrollCoinNum"..i):SetValue(self:GetScrollCost(i));
		end

		self.m_EquippedAvatar = IOManager:GetValue(IO_CAT_HACK, "Avatar", "Equip");
		self.m_EquippedJade = IOManager:GetValue(IO_CAT_HACK, "Jade", "Equip");

		UIManager:GetWidget("ScrollSelect", "Category"):Reselect(1);
		
		self:SwitchCategory(1, noDialog);

		self:UpdateScrollButtons();

		self:SetScrollInTutorial(false);

		self:EnterOnMotion();

		log("ScrollManager reset");
	end,
	---------------------------------------------------------------------
	Reload = function(self)
		for _, effect in ipairs(self.m_EffectPool:GetInactivePool()) do
			effect:UnloadByDummy();
		end
		
		log("ScrollManager reloaded");
	end,
	---------------------------------------------------------------------
	Unload = function(self)
		self.m_EffectPool:ResetPool();
		
		for _, effect in ipairs(self.m_EffectPool:GetInactivePool()) do
			effect:UnloadByDummy();
		end

		log("ScrollManager unloaded");
	end,
	---------------------------------------------------------------------
	UnloadScrollEffects = function(self)
--		for _, effect in ipairs(self.m_EffectPool:GetInactivePool()) do
			effect:UnloadByDummy();
--		end

		log("ScrollEffect unloaded");
	end,
	---------------------------------------------------------------------
	EnterOnMotion = function(self)
		local mx, my = UIManager:GetWidgetTranslate("ScrollSelect", "Master");
		UIManager:GetWidgetComponent("ScrollSelect", "Master", "Motion"):ResetTarget(mx, my - UI_SCROLL_MASTER);

		for _, widget in ipairs(UIManager:GetWidgetGroup("ScrollSelect", "ScrollWidgets")) do
			local x, y = UIManager:GetWidgetTranslate("ScrollSelect", widget);
			UIManager:SetWidgetTranslate("ScrollSelect", widget, x - APP_WIDTH * 0.5, y);
			UIManager:GetWidgetComponent("ScrollSelect", widget, "Motion"):ResetTarget(x, y);
			--UIManager:GetWidgetObject("ScrollSelect", widget):EnableRender(true);
		end
		
		--UIManager:ToggleWidgetGroup("ScrollSelect", "ScrollWidgets", true);
		UIManager:ToggleWidgetGroup("ScrollSelect", "ButtonWidgets", false);
		UIManager:ToggleWidgetGroup("ScrollSelect", "MoneyWidgets", false);
	end,
	---------------------------------------------------------------------
	ExitOnMotion = function(self)
		local mx, my = UIManager:GetWidgetTranslate("ScrollSelect", "Master");
		UIManager:GetWidgetComponent("ScrollSelect", "Master", "Motion"):ResetTarget(mx, my + UI_SCROLL_MASTER);

		for _, widget in ipairs(UIManager:GetWidgetGroup("ScrollSelect", "ScrollWidgets")) do
			local x, y = UIManager:GetWidgetTranslate("ScrollSelect", widget);
			UIManager:GetWidgetComponent("ScrollSelect", widget, "Motion"):ResetTarget(x - APP_WIDTH * 0.5, y);
		end
		
		UIManager:EnableWidget("ScrollSelect", "ScrollText", false);
		UIManager:ToggleWidgetGroup("ScrollSelect", "ButtonWidgets", false);
		UIManager:ToggleWidgetGroup("ScrollSelect", "MoneyWidgets", false);
	end,
	---------------------------------------------------------------------
	ReloadMagicCircle = function(self)
		self.m_ScrollPreEffectBKUp:Reload();
		self.m_ScrollPreEffectBKDown:Reload();
		self.m_ScrollPreEffectMCOut:Reload();
		self.m_ScrollPreEffectMCIn:Reload();
	end,
	---------------------------------------------------------------------
	UnloadMagicCircle = function(self)
		self.m_ScrollPreEffectBKUp:Unload();
		self.m_ScrollPreEffectBKDown:Unload();
		self.m_ScrollPreEffectMCOut:Unload();
		self.m_ScrollPreEffectMCIn:Unload();
	end,
	---------------------------------------------------------------------
	SwitchCategory = function(self, index, noDialog)
		assert(index <= SCROLL_MAX_PAGE, "Error switching scroll category");
		self.m_CurrentScrollCategory = index;

		-- Reset translation
		UIManager:SetWidgetTranslate("ScrollSelect", "ScrollBackdrop", 0, 0);
		UIManager:SetWidgetTranslate("ScrollSelect", "ScrollCover", 0, 0);
		UIManager:SetWidgetTranslate("ScrollSelect", "Category", UI_SCROLL_ORIGIN[1], UI_SCROLL_ORIGIN[2] - 35);
		
		for i = 1, SCROLL_SLOT_MAX do
			local x = UI_SCROLL_ORIGIN[1];
			local y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * (i - 1);
			UIManager:SetWidgetTranslate("ScrollSelect", "Scroll"..i, x, y);

			local x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_COIN_OFFSET[1];
			local y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * (i - 1) + UI_SCROLL_COIN_OFFSET[2];
			UIManager:SetWidgetTranslate("ScrollSelect", "ScrollCoinNum"..i, x, y);

			local x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_BUTTON_OFFSET[1];
			local y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * (i - 1) + UI_SCROLL_BUTTON_OFFSET[2];
			UIManager:SetWidgetTranslate("ScrollSelect", "ScrollButton"..i, x, y);
		end

		for _, widget in ipairs(UIManager:GetWidgetGroup("ScrollSelect", "MoneyWidgets")) do
			UIManager:EnableWidget("ScrollSelect", widget, false);
		end
		
		UIManager:EnableWidget("ScrollSelect", "ScrollText", false);
		UIManager:EnableWidget("ScrollSelect", "ScrollCoinNum6", false);
		UIManager:EnableWidget("ScrollSelect", "ScrollButton6", false);
		UIManager:EnableWidget("ScrollSelect", "Scroll6", true);

		--============================
		-- Scroll Page
		--============================
		if (index == SCROLL_CAT_SCROLL) then
			local data = IOManager:GetRecord(IO_CAT_HACK, "Scroll");
			for i = 1, SCROLL_MAX do
				local scroll = data[i];
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(1, SCROLL_DATA[i][SCROLL_T_ICONBAR]);
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, false);
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, false);
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(4, false);
				
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(5, "ui_lvunlock_"..((i - 1) * 2 + 1));
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(5, not scroll);
				UIManager:EnableWidget("ScrollSelect", "ScrollCoinNum"..i, scroll);
				UIManager:EnableWidget("ScrollSelect", "ScrollButton"..i, scroll);				
			end

			UIManager:GetWidgetComponent("ScrollSelect", "ScrollText", "Sprite"):SetImage(2, "ui_scroll_dialog_00");
			UIManager:EnableWidget("ScrollSelect", "Scroll6", false);

			self.m_IsScrollPage = true;
		--============================
		-- Avatar Page
		--============================
		elseif (index == SCROLL_CAT_AVATAR) then
			local data = IOManager:GetRecord(IO_CAT_HACK, "Avatar");
			
			for i = 1, SCROLL_SLOT_MAX do
				if (self.m_EquippedAvatar == i) then
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, true);
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, true);
				else
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, false);
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, false);
				end
				
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(3, "ui_scroll_button_assign");
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(5, "ui_shop_locked");
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(5, not data[i]);
			end

			for i = 1, AVATAR_MAX do
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(1, AVATAR_DATA_POOL[i][AVATAR_ICON]);
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(4, data[i]);

				if (data[i]) then
					local lv = IOManager:GetValue(IO_CAT_HACK, "AvatarLv", i);
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(4, "ui_shop_upgrade_lv"..lv);
				end

				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(3, "ui_scroll_button_assign");
			end
			
			UIManager:GetWidgetComponent("ScrollSelect", "ScrollText", "Sprite"):SetImage(2, "ui_scroll_dialog_07");
			self.m_IsScrollPage = false;
		--============================
		-- Jade Page
		--============================
		elseif (index == SCROLL_CAT_JADE) then
			local data = IOManager:GetRecord(IO_CAT_HACK, "Jade");
			
			for i = 1, SCROLL_SLOT_MAX do
				if (self.m_EquippedJade == i) then
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, true);
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, true);
				else
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, false);
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, false);
				end
				
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(3, "ui_scroll_button_apply");
				
				if (i == JADE_EFFECT_INNO_PROTECT) then
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(5, "ui_shop_locked");
				else
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(5, "ui_lvunlock_".. (i * 2));
				end
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(5, not data[i]);
			end

			for i = 1, JADE_MAX do
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(1, JADE_DATA_POOL[i][JE_SCROLLICON]);
				
				if (data[i]) then
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):SetImage(4, "ui_shop_upgrade_lv"..data[i]);
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(4, JADE_SHOW_LV[i]);
				else
					UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(4, false);				
				end
			end
			
			UIManager:GetWidgetComponent("ScrollSelect", "ScrollText", "Sprite"):SetImage(2, "ui_jade_dialog_00");
			self.m_IsScrollPage = false;
		end
	end,
	---------------------------------------------------------------------
	UpdateTargetScroll = function(self, index)
		for i = 1, SCROLL_SLOT_MAX do
			if (i == index) then
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, true);
			else
				UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(2, false);
			end
		end

		-- Master's dialog
		if (self.m_IsScrollPage) then
			UIManager:GetWidgetComponent("ScrollSelect", "ScrollText", "Sprite"):SetImage(2, SCROLL_DATA[index][SCROLL_T_TEXT]);
			g_TaskManager:AddTask(CallbackTask, { PopScrollDialog, nil, nil, nil }, 0, 0);
		else
			if (self.m_CurrentScrollCategory == SCROLL_CAT_AVATAR) then				
				local data = IOManager:GetRecord(IO_CAT_HACK, "Avatar");
				if (data[index]) then
					self.m_EquippedAvatar = index;

					for i = 1, SCROLL_SLOT_MAX do --SCROLL_MAX do
						if (i == index) then
							UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, true);
						else
							UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, false);
						end
					end
				end
			elseif (self.m_CurrentScrollCategory == SCROLL_CAT_JADE) then
				local data = IOManager:GetRecord(IO_CAT_HACK, "Jade");
				if (data[index]) then
					self.m_EquippedJade = index;

					for i = 1, SCROLL_SLOT_MAX do --SCROLL_MAX do
						if (i == index) then
							UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, true);
						else
							UIManager:GetWidgetComponent("ScrollSelect", "Scroll"..i, "Sprite"):EnableRender(3, false);
						end
					end
				end
				
				UIManager:GetWidgetComponent("ScrollSelect", "ScrollText", "Sprite"):SetImage(2, "ui_jade_dialog_0"..index);
				g_TaskManager:AddTask(CallbackTask, { PopScrollDialog, nil, nil, nil }, 0, 0);
			end
		end
	end,
	---------------------------------------------------------------------
	ShowScrollButtons = function(self)
		if (self.m_CurrentScrollCategory == SCROLL_CAT_SCROLL) then
			local data = IOManager:GetRecord(IO_CAT_HACK, "Scroll");
			for i = 1, SCROLL_MAX do
				UIManager:EnableWidget("ScrollSelect", "ScrollCoinNum"..i, data[i]);
				UIManager:EnableWidget("ScrollSelect", "ScrollButton"..i, data[i]);
			end
			--UIManager:ToggleWidgetGroup("ScrollSelect", "MoneyWidgets", true);
			self:UpdateScrollButtons();
		elseif (self.m_CurrentScrollCategory == SCROLL_CAT_JADE) then
			UIManager:ToggleWidgetGroup("ScrollSelect", "MoneyWidgets", false);
		end

		UIManager:ToggleWidgetGroup("ScrollSelect", "ButtonWidgets", true);
		
		PopScrollDialog();
	end,
	---------------------------------------------------------------------
	UpdateScrollButtons = function(self)
		if (self.m_ScrollsBoughtCount == 2) then
			for i = 1, SCROLL_MAX do
				UIManager:GetWidget("ScrollSelect", "ScrollButton"..i):Enable(self.m_ScrollsBought[i]);
			end
		else		
			for i = 1, SCROLL_MAX do
				if (self.m_ScrollsBought[i]) then
					UIManager:GetWidget("ScrollSelect", "ScrollButton"..i):Enable(true);
				else
					UIManager:GetWidget("ScrollSelect", "ScrollButton"..i):Enable(MoneyManager:HasEnoughCoin(self:GetScrollCost(i)));
				end
			end
		end
	end,
	---------------------------------------------------------------------
	BuyOrRefundScroll = function(self, index)
		if (self.m_ScrollsBought[index]) then
		-- Refund money
			MoneyManager:ResetMotion("ScrollSelect");
			MoneyManager:ModifyCoin(self:GetScrollCost(index));

			self.m_ScrollsBought[index] = nil;
			self.m_ScrollsBoughtCount = self.m_ScrollsBoughtCount - 1;
			
			UIManager:GetWidget("ScrollSelect", "ScrollButton"..index):SetImage("ui_scroll_button_buy");
			AudioManager:PlaySfx(SFX_UI_MONEY_REFUND);
		else
		-- Spend money
			MoneyManager:ModifyCoinWithMotion(-self:GetScrollCost(index), "ScrollSelect");
			
			self.m_ScrollsBought[index] = true;
			self.m_ScrollsBoughtCount = self.m_ScrollsBoughtCount + 1;
			
			UIManager:GetWidget("ScrollSelect", "ScrollButton"..index):SetImage("ui_scroll_button_cancel");
			AudioManager:PlaySfx(SFX_UI_MONEY_SPEND);
		end
		
		self:UpdateScrollButtons();
		
		self:UpdateTargetScroll(index);
	end,
	---------------------------------------------------------------------
	RefundAllScroll = function(self)
		local candidates = {};
		for i = 1, SCROLL_MAX do
			if (self.m_ScrollsBought[i]) then
				table.insert(candidates, i);
			end
		end

		for i = 1, 2 do
			local scrollIndex = candidates[i];
			if (scrollIndex) then
				MoneyManager:ModifyCoin(self:GetScrollCost(scrollIndex));
			end
		end
		
		if (self.m_ScrollsBoughtCount > 0) then
			self.m_ScrollsBoughtCount = 0;
			AudioManager:PlaySfx(SFX_UI_MONEY_REFUND);
		end
	end,
	---------------------------------------------------------------------
	GetScrollCost = function(self, index)
		if (index > SCROLL_MAX) then
			return 0;
		end
		assert(SCROLL_DATA[index], "GetScrollCost error");
		
		if (LevelManager:IsChallengeMode()) then
			if (index == SCROLL_EFFECT_LIFE) then	-- Special case for Scroll of Life
				return 1;
			else
				return SCROLL_DATA[index][SCROLL_T_COST] * SCROLL_COST_CHALLENGE;
			end
		elseif (LevelManager:IsShadowDifficulty()) then
			return SCROLL_DATA[index][SCROLL_T_COST] * SCROLL_COST_SHADOW;
		else
			return SCROLL_DATA[index][SCROLL_T_COST];
		end
	end,
	---------------------------------------------------------------------
	DetermineScrollByIndex = function(self, index, scrollIndex)
		assert(index == 1 or index == 2);
		
		if (scrollIndex) then
			self.m_Scrolls[index] = scrollIndex;
			self.m_ScrollsStatus[index] = SCROLL_STATUS_READY;
	
			UIManager:EnableWidget("InGame", "Scroll"..index, true);
			UIManager:GetWidget("InGame", "Scroll"..index):Enable(true);
			UIManager:GetWidget("InGame", "Scroll"..index):SetImage(SCROLL_DATA[scrollIndex][SCROLL_T_ICON], nil, true);
		end
	end,
	---------------------------------------------------------------------
	RestoreScroll = function(self, index)
		self.m_ScrollsStatus[index] = SCROLL_STATUS_READY;
    	UIManager:GetWidget("InGame", "Scroll"..index):Enable(true);
	end,
	---------------------------------------------------------------------
	ReviveScrolls = function(self)
		for index = 1, 2 do
			local scroll = self.m_ScrollsStatus[index];
			
			if (scroll == SCROLL_STATUS_READY) then
				UIManager:GetWidget("InGame", "Scroll"..index):Enable(enable);
			elseif (scroll == SCROLL_STATUS_USED) then
				local go = UIManager:GetWidgetObject("InGame", "Scroll"..index);
				local sprite = go["Sprite"]:GetSprite(2);
				local width, height = go["Sprite"]:GetSize();			
				sprite:SetQuadVertices(0, 0, 0, height, width, 0, width, height);
				go["Sprite"]:SetIndieOffset(2, 0, 0);

				self.m_ScrollCooldownSM[index]:ChangeState("active");
			end
		end
	end,
	---------------------------------------------------------------------
	EnableScrollButtons = function(self, enable)
		for index = 1, 2 do
			if (self.m_ScrollsStatus[index] == SCROLL_STATUS_READY) then
				UIManager:GetWidget("InGame", "Scroll"..index):Enable(enable);
			end
		end
	end,
	---------------------------------------------------------------------
	Complete = function(self, shouldIgnoreMotion)
		--=============
		-- Scrolls
		--=============
		local candidates = {};
		for i = 1, SCROLL_MAX do
			if (self.m_ScrollsBought[i]) then
				table.insert(candidates, i);
			end
		end

		for i = 1, 2 do
			local scrollIndex = candidates[i];
			if (scrollIndex) then
				self.m_Scrolls[i] = scrollIndex;
				self.m_ScrollsStatus[i] = SCROLL_STATUS_READY;
				self.m_ScrollCooldownSM[i]:ChangeState("active");
	
				UIManager:EnableWidget("InGame", "Scroll"..i, true);
				UIManager:GetWidget("InGame", "Scroll"..i):Enable(true);
				UIManager:GetWidget("InGame", "Scroll"..i):SetImage(SCROLL_DATA[scrollIndex][SCROLL_T_ICON], nil, true);

				GameKit.LogEventWithParameter("Scroll", SCROLL_DATA[scrollIndex][SCROLL_T_NAME], "type", false);
			end
		end
		
		local scrollCount = #candidates;
		GameKit.LogEventWithParameter("Scroll", tostring(scrollCount), "count", false);
		
		if (scrollCount > 0) then
			GameKit.LogEventWithParameter("Money", "scroll", "CoinUsage", false);
		end

		--=============
		-- Avatar
		--=============
		--log("Avatar @@@ "..self.m_EquippedAvatar);
		local avatar = AVATAR_DATA_POOL[self.m_EquippedAvatar];
		assert(avatar, "Avatar error");		
		LevelManager:ResetAvatar(avatar, self.m_EquippedAvatar);
		GameKit.LogEventWithParameter("AvatarEquipped", avatar[AVATAR_ID], "action", false);

		--=============
		-- Jade
		--=============
		-- Deactivate previous jade first
		--self:DeactivateEquippedJade();
		
		--log("Jade @@@ "..self.m_EquippedJade);
		if (self.m_EquippedJade == 0) then
			UIManager:EnableWidget("InGame", "JadeIcon", false);
			UIManager:EnableWidget("InGame", "JadeText", false);
			GameKit.LogEventWithParameter("JadeEquipped", "N/A", "action", false);
		else
			local jade = JADE_DATA_POOL[self.m_EquippedJade];
			assert(jade, "Jade error");
			self:ActivateEquippedJade();
			GameKit.LogEventWithParameter("JadeEquipped", jade[JE_ID], "action", false);
		end

		IOManager:SetValue(IO_CAT_HACK, "Jade", "Equip", self.m_EquippedJade);
		IOManager:SetValue(IO_CAT_HACK, "Avatar", "Equip", self.m_EquippedAvatar, true);
		
		--=============
		-- Audio
		--=============
		local rec = IOManager:GetRecord(IO_CAT_OPTION, "Audio");
		for k, v in pairs(rec) do
			if (v == true) then
				GameKit.LogEventWithParameter("Audio", "YES", k, false);
			else
				GameKit.LogEventWithParameter("Audio", "NO", k, false);
			end
			--log("LogAudio: "..k.." => "..tostring(v));
		end

		-- Start game
		if (shouldIgnoreMotion) then
			StageManager:ChangeStage("PreInGameDoor");
		else
			StageManager:ChangeStage("PostScrollSelect");
		end
	end,
	---------------------------------------------------------------------
	UseScrollInGame = function(self, index)
		assert(index == 1 or index == 2);
		
		if (LevelManager:IsCurrentLifeZero() or LevelManager:IsAvatarBerserking()) then
			return;
		end

		StageManager:PushStage("PreGameScroll");

		local scroll = self.m_Scrolls[index];
		assert(scroll);

		self.m_CurrentScrollIndex = index;
		self.m_CurrentScrollCooldown = SCROLL_DATA[scroll][SCROLL_T_COOLDOWN];
		self.m_ScrollCooldownSM[index]:ChangeState("freeze");
		
		--log("UseScroll @ "..index.."  => effect: "..self.m_Scrolls[index])
		self.m_CurrentScroll = ScrollEffector[scroll];
		self.m_ScrollsStatus[index] = SCROLL_STATUS_USED;
		self.m_ColorMask = SCROLL_DATA[scroll][SCROLL_T_MASK];
		self.m_ScrollPreEffectMCIn["Sprite"]:SetImage(2, SCROLL_DATA[scroll][SCROLL_T_SYMBOL]);

		ScrollUsed();
		AudioManager:PlaySfx(SFX_SCROLL_USE);
	end,
	---------------------------------------------------------------------
	UseScrollInTutorial = function(self, index)
		HideTapHand();		
		self:UseScrollInGame(index);
	end,
	---------------------------------------------------------------------
	GetCooldownDuration = function(self)
		return self.m_CurrentScrollCooldown;
	end,
	---------------------------------------------------------------------
	StartMagicCircle = function(self)
		self.m_ScrollPreEffectMCOut["StateMachine"]:ChangeState("enter", self.m_ScrollPreEffectMCIn);
	end,
	---------------------------------------------------------------------
	StartScrollEffect = function(self)
		self.m_CurrentScroll["initial"]();
	end,
	---------------------------------------------------------------------	
	EnterStage = function(self)
--		LevelManager:RemoveAllScrollEffects();
		LevelManager:HideBoostUI();
		LevelManager:EnableUpdate(false);
		BladeManager:EnableEnergyRefresh(false);
		
		self.m_ScrollPreEffectMCOut["StateMachine"]:ChangeState("inactive", self.m_ScrollPreEffectMCIn);
		self.m_ScrollPreEffectBKUp["StateMachine"]:ChangeState("enter");
		self.m_ScrollPreEffectBKDown["StateMachine"]:ChangeState("enter", true);

--		self.m_EffectPool:ResetPool();		
		self:EnableScrollButtons(false);
	end,
	---------------------------------------------------------------------	
	ExitStage = function(self)
		LevelManager:EnableUpdate(true);
		BladeManager:EnableEnergyRefresh(true);
		self:EnableScrollButtons(true);

		if (self.m_CurrentScrollIndex and self.m_CurrentScrollCooldown) then
			--self.m_ScrollCooldownSM[self.m_CurrentScrollIndex]:ChangeState("cooldown", self.m_CurrentScrollIndex);
			self.m_ScrollCooldownSM[self.m_CurrentScrollIndex]:ChangeState("cooldown", self.m_CurrentScrollCooldown);
		end
	end,
	---------------------------------------------------------------------
	ResetScrollShowTimer = function(self, duration)
		self.m_ScrollShowTimer["Timer"]:Reset(duration);
	end,

	--===================================================================
	-- Scroll Effects
	--===================================================================

	---------------------------------------------------------------------
	LaunchLifeHealer = function(self)
		local pool = self.m_ScrollEffectPool[self.m_CurrentScrollIndex];
		for i = 1, 5 do
			local effect = self.m_EffectPool:ActivateResource();
			assert(effect, "LaunchLifeHealer error");			
			pool[i] = effect;

			effect["Transform"]:SetScale(1.0);
			effect["Sprite"]:ResetAnimation("scrolleffect_life", true);
		end
		
		assert(#self.m_ActiveEffects == 5);
		self.m_ActiveEffects[1]["Transform"]:SetTranslate(29, 80);
		self.m_ActiveEffects[2]["Transform"]:SetTranslate(200, 89);
		self.m_ActiveEffects[3]["Transform"]:SetTranslate(267, 24);

		self.m_ActiveEffects[4]["Transform"]:SetTranslate(102, 30);
		self.m_ActiveEffects[4]:ToggleRenderAndUpdate();
		self.m_ActiveEffects[5]["Transform"]:SetTranslate(351, 76);
		self.m_ActiveEffects[5]:ToggleRenderAndUpdate();
		
		g_TaskManager:AddTask(CallbackTask, { LaunchHealer, nil, nil, self.m_ActiveEffects[4], }, 0, 200);
		g_TaskManager:AddTask(CallbackTask, { LaunchHealer, nil, nil, self.m_ActiveEffects[5], }, 0, 0);
	end,
	---------------------------------------------------------------------
	LaunchEnergyHealer = function(self)
		local pool = self.m_ScrollEffectPool[self.m_CurrentScrollIndex];
		for i = 1, 5 do
			local effect = self.m_EffectPool:ActivateResource();
			assert(effect, "LaunchEnergyHealer error");			
			pool[i] = effect;

			effect["Transform"]:SetScale(1.0);
			effect["Sprite"]:ResetAnimation("scrolleffect_energy", true);
		end

		self.m_ActiveEffects[1]["Transform"]:SetTranslate(29, 80);
		self.m_ActiveEffects[2]["Transform"]:SetTranslate(200, 89);
		self.m_ActiveEffects[3]["Transform"]:SetTranslate(267, 24);

		self.m_ActiveEffects[4]["Transform"]:SetTranslate(102, 30);
		self.m_ActiveEffects[4]:ToggleRenderAndUpdate();
		self.m_ActiveEffects[5]["Transform"]:SetTranslate(351, 76);
		self.m_ActiveEffects[5]:ToggleRenderAndUpdate();
		
		g_TaskManager:AddTask(CallbackTask, { LaunchHealer, nil, nil, self.m_ActiveEffects[4], }, 0, 200);
		g_TaskManager:AddTask(CallbackTask, { LaunchHealer, nil, nil, self.m_ActiveEffects[5], }, 0, 0);
	end,
	---------------------------------------------------------------------
	LaunchFireball = function(self)
		local pool = self.m_ScrollEffectPool[self.m_CurrentScrollIndex];
		for i = 1, 5 do
			local effect = self.m_EffectPool:ActivateResource();
			assert(effect, "LaunchFireball error");			
			pool[i] = effect;

			effect["Transform"]:SetScale(1.0);
			effect:ToggleRenderAndUpdate();
			g_TaskManager:AddTask(CallbackTask, { LaunchFireball, nil, nil, effect, }, 0, 300);
		end
		--g_TaskManager:AddTask(CallbackTask, { PlaySfxCallback, nil, nil, SFX_SCROLL_METEOR_EXIT, }, 0, 1000);
		
		local halfSize = 45;
		local x =  APP_WIDTH  * 0.33 - halfSize;
		local rx = APP_WIDTH  * 0.2;
		local y =  APP_HEIGHT * 0.33 - halfSize;
		local ry = APP_HEIGHT * 0.2;

		assert(#self.m_ActiveEffects == 5);
		self.m_ActiveEffects[1]["Transform"]:SetTranslate(ModifyValueByRandRange(x * 2, rx), ModifyValueByRandRange(y, ry));
		self.m_ActiveEffects[2]["Transform"]:SetTranslate(ModifyValueByRandRange(x * 2, rx), ModifyValueByRandRange(y * 2, ry));
		self.m_ActiveEffects[3]["Transform"]:SetTranslate(ModifyValueByRandRange(x, rx), ModifyValueByRandRange(y * 2, ry));
		self.m_ActiveEffects[4]["Transform"]:SetTranslate(ModifyValueByRandRange(x, rx), ModifyValueByRandRange(y, ry));
		self.m_ActiveEffects[5]["Transform"]:SetTranslate(ModifyValueByRandRange(APP_WIDTH * 0.5 - halfSize, rx), ModifyValueByRandRange(APP_HEIGHT * 0.5 - halfSize, ry));		

		AudioManager:PlaySfx(SFX_SCROLL_METEOR_ENTER);
	end,
	---------------------------------------------------------------------
	LaunchShield = function(self)		
		local pool = self.m_ScrollEffectPool[self.m_CurrentScrollIndex];
		local effect = self.m_EffectPool:ActivateResource();
		assert(effect, "LaunchShield error");
		pool[1] = effect;

		effect["Transform"]:SetTranslate(LevelManager:GetCastleShieldPos());
		effect["Transform"]:SetScale(0.01);
		effect["Interpolator"]:AttachUpdateCallback(UpdateGOScale, effect["Transform"]);
		effect["Interpolator"]:ResetTarget(0.01, 1.0, 500);
		effect["Sprite"]:ResetAnimation("scrolleffect_energyshield", true);
	end,
	---------------------------------------------------------------------
	LaunchBlizzard = function(self)
		local pool = self.m_ScrollEffectPool[self.m_CurrentScrollIndex];
		local effect = self.m_EffectPool:ActivateResource();
		assert(effect, "LaunchBlizzard error");
		pool[1] = effect;
		
		effect["Transform"]:SetTranslate(0, 0);
		effect["Transform"]:SetScale(3.0);
		effect["Sprite"]:ResetAnimation("scrolleffect_blizzard", true);

		AudioManager:PlaySfx(SFX_SCROLL_FREEZE);
	end,
--[[	
	---------------------------------------------------------------------
	LaunchPoison = function(self)
		for i = 1, SCROLL_EFFECT_MAX do
			local effect = self.m_EffectPool:ActivateResource();
			assert(effect, "LaunchPoison error");
			
			local x, y = LevelManager:GetRandFieldPos();
			effect["Transform"]:SetTranslate(x - 50, y - 50);			
			effect["Transform"]:SetScale(1.0);
			effect:ToggleRenderAndUpdate();

		    g_TaskManager:AddTask(CallbackTask, { LaunchPoison, nil, nil, effect, }, 0, 300);
		end

		AudioManager:PlaySfx(SFX_SCROLL_POISON);
	end,
--]]
	--===================================================================
	-- Jade
	--===================================================================

	---------------------------------------------------------------------
	ActivateEquippedJade = function(self)
		assert(self.m_EquippedJade > 0);
		
		local jadeLv = IOManager:GetValue(IO_CAT_HACK, "Jade", self.m_EquippedJade);
		local value = JADE_EFFECT_DATA[self.m_EquippedJade][jadeLv];
		--log("ActivateEquippedJade @ "..JADE_DATA_POOL[self.m_EquippedJade][1].." => value: "..value)
		JADE_EFFECT_FUNC[self.m_EquippedJade]["Enter"](value);

		UIManager:GetWidgetComponent("InGame", "JadeIcon", "Sprite"):SetImage(JADE_DATA_POOL[self.m_EquippedJade][JE_ICON]);
		UIManager:GetWidgetComponent("InGame", "JadeText", "Sprite"):SetImage(JADE_DATA_POOL[self.m_EquippedJade][JE_TEXT]);            
---[[ @Screenshot
		UIManager:EnableWidget("InGame", "JadeIcon", true);
		UIManager:EnableWidget("InGame", "JadeText", true);
--]]
--[[
		UIManager:EnableWidget("InGame", "JadeIcon", false);
		UIManager:EnableWidget("InGame", "JadeText", false);
--]]		
	end,
	---------------------------------------------------------------------
	DeactivateEquippedJade = function(self)
		if (self.m_EquippedJade > 0) then
			JADE_EFFECT_FUNC[self.m_EquippedJade]["Exit"]();
			UIManager:EnableWidget("InGame", "JadeIcon", false);
			UIManager:EnableWidget("InGame", "JadeText", false);
		end
	end,

	--===================================================================
	-- Tutorial
	--===================================================================

	---------------------------------------------------------------------
	EnterTutorial = function(self)
		for i = 1, 2 do
			local go = UIManager:GetWidgetObject("InGame", "Scroll"..i);
			local sprite = go["Sprite"]:GetSprite(2);
			local width, height = go["Sprite"]:GetSize();
			sprite:SetQuadVertices(0, 0, 0, height, width, 0, width, height);
			go["Sprite"]:SetIndieOffset(2, 0, 0);
			go["Interpolator"]:Reset();
		end

		--local candidates = { 1, 5 };
		local candidates = { 5 };
		for i = 1, 2 do
			local scrollIndex = candidates[i];
			if (scrollIndex) then
				self.m_Scrolls[i] = scrollIndex;
				self.m_ScrollsStatus[i] = SCROLL_STATUS_READY;
				self.m_ScrollCooldownSM[i]:ChangeState("freeze");
	
				UIManager:EnableWidget("InGame", "Scroll"..i, true);
				UIManager:GetWidget("InGame", "Scroll"..i):Enable(true);
				UIManager:GetWidget("InGame", "Scroll"..i):SetImage(SCROLL_DATA[scrollIndex][SCROLL_T_ICON], nil, true);
			else
				UIManager:EnableWidget("InGame", "Scroll"..i, false);
			end
		end

		LevelManager:ResetAvatar(AVATAR_DATA_POOL[1], 1, true);

		UIManager:EnableWidget("InGame", "JadeIcon", false);
		UIManager:EnableWidget("InGame", "JadeText", false);
		
		StageManager:ChangeStage("PostScrollSelect");		
	end,
	---------------------------------------------------------------------
	SetScrollInTutorial = function(self, enable)
		if (enable) then
			self.UseScroll = self.UseScrollInTutorial;
		else
			self.UseScroll = self.UseScrollInGame;
		end
	end,
	
	--===================================================================
	-- Update/Render
	--===================================================================
--[[
	---------------------------------------------------------------------
	AddEffectsToRenderQueue = function(self)
		for _, obj in ipairs(self.m_ActiveEffects) do
			AddToPostRenderQueue(obj);
		end
	end,
	---------------------------------------------------------------------
	RemoveEffectsFromRenderQueue = function(self)
		for _, obj in ipairs(self.m_ActiveEffects) do
			RemoveFromPostRenderQueue(obj);
		end
		
        self:Unload();
	end,
--]]	
	---------------------------------------------------------------------	
	UpdateScroll = function(self)
		for _, obj in ipairs(self.m_ActiveEffects) do
			obj:Update();
		end

		self.m_ScrollShowTimer:Update();
		
		-- Update for healing life & energy
		UIManager:GetWidgetObject("InGame", "LifeBar"):Update();
		UIManager:GetWidgetObject("InGame", "EnergyBar"):Update();
		
		if (self.m_ScrollShowTimer["Timer"]:IsOver()) then
			self.m_CurrentScroll["over"]();
			
			local pool = self.m_ScrollEffectPool[self.m_CurrentScrollIndex];
			for i = #pool, 1, -1 do
				--log("recycle res # "..i)
				local effect = pool[i];
				self.m_EffectPool:DeactivateResource(effect);
				effect:UnloadByDummy();
				table.remove(pool);
			end
			
			StageManager:PopStage();
		end
	end,
	---------------------------------------------------------------------	
	RenderScroll = function(self)
		DrawFullscreenColorMask(self.m_ColorMask[1], self.m_ColorMask[2], self.m_ColorMask[3], self.m_ColorMask[4]);

		for _, obj in ipairs(self.m_ActiveEffects) do
			obj:Render();
		end
	end,
	---------------------------------------------------------------------	
	UpdatePreEffect = function(self)
		self.m_ScrollPreEffectBKUp:Update();
		self.m_ScrollPreEffectBKDown:Update();
		
		self.m_ScrollPreEffectMCOut:Update();
		self.m_ScrollPreEffectMCIn:Update();
	end,
	---------------------------------------------------------------------	
	RenderPreEffect = function(self)
		self.m_ScrollPreEffectBKUp:Render();
		self.m_ScrollPreEffectBKDown:Render();
		
		self.m_ScrollPreEffectMCOut:Render();
		self.m_ScrollPreEffectMCIn:Render();
	end,
};



-------------------------------------------------------------------------
ScrollEffector =
{
	---------------------------------------------------------------------
	[SCROLL_EFFECT_LIFE] =
	{
		-----------------------------------------------------------------
		initial = function()
			--ScrollManager:Reload();
			ScrollManager:ResetScrollShowTimer(1500);
			ScrollManager:LaunchLifeHealer();

			LevelManager:HealLife(50);
			AudioManager:PlaySfx(SFX_SCROLL_HEAL_LIFE);
		end,
		-----------------------------------------------------------------
		over = function()
			--ScrollManager:Unload();
		end,
	},
	---------------------------------------------------------------------
	[SCROLL_EFFECT_ENERGY] =
	{
		-----------------------------------------------------------------
		initial = function()
			--ScrollManager:Reload();
			ScrollManager:ResetScrollShowTimer(1500);
			ScrollManager:LaunchEnergyHealer();

			BladeManager:HealEnergy(50);			
			AudioManager:PlaySfx(SFX_SCROLL_HEAL_ENERGY);
		end,
		-----------------------------------------------------------------
		over = function()
			--ScrollManager:Unload();
		end,	
	},
	---------------------------------------------------------------------
	[SCROLL_EFFECT_CASTLE_SHIELD] =
	{
		-----------------------------------------------------------------
		initial = function()
			--ScrollManager:Reload();
			ScrollManager:ResetScrollShowTimer(1500);
			ScrollManager:LaunchShield();			
			LevelManager:ReloadCastleShield();
		end,
		-----------------------------------------------------------------
		over = function()
			LevelManager:LaunchCastleShield();
			--ScrollManager:Unload();
		end,
	},	
	---------------------------------------------------------------------
	[SCROLL_EFFECT_ENEMY_FREEZE] =
	{
		-----------------------------------------------------------------
		initial = function()
			--ScrollManager:Reload();
			ScrollManager:LaunchBlizzard();
			ScrollManager:ResetScrollShowTimer(2200);
			--LevelManager:ReloadCastleEffect();
		end,
		-----------------------------------------------------------------
		over = function()
			LevelManager:LaunchCastleEffect("freeze_scroll", 15000);
		end,
	},
	---------------------------------------------------------------------
	[SCROLL_EFFECT_ENEMY_KILL] =
	{
		-----------------------------------------------------------------
		initial = function()
			--ScrollManager:Reload();
			ScrollManager:LaunchFireball();
			ScrollManager:ResetScrollShowTimer(3000);
		end,
		-----------------------------------------------------------------
		over = function()
			--ScrollManager:Unload();
			EnemyManager:KillAllEnemies();
			AudioManager:PlaySfx(SFX_SCROLL_METEOR_EXIT);
		end,
	},	
--[[
	---------------------------------------------------------------------
	[SCROLL_EFFECT_ENEMY_POISON] =
	{
		-----------------------------------------------------------------
		initial = function()			
			ScrollManager:Reload();

			ScrollManager:LaunchPoison();
			ScrollManager:ResetScrollShowTimer(3500);
		end,
		-----------------------------------------------------------------
		over = function()
			EnemyManager:EnchantAllEnemies("poison_scroll");
			LevelManager:LaunchCastleScroll("poison_scroll", 15000);
		end,
	},	
--]]
};



-------------------------------------------------------------------------
function UpdateRotateScaleMCOuter(value, go)
    go:SetScale(MAGIC_CIRCLE_SCALE + ((1 - MAGIC_CIRCLE_SCALE) * value));
	go:SetRotateByRadian(math.pi * 2 * value);
end

-------------------------------------------------------------------------
function UpdateRotateScaleMCInner(value, go)
    go:SetScale(MAGIC_CIRCLE_SCALE + ((1 - MAGIC_CIRCLE_SCALE) * value));
	go:SetRotateByRadian(- math.pi * 2 * value);
end

-------------------------------------------------------------------------
function LaunchHealer(go)
	go["Sprite"]:Animate();
	go:ToggleRenderAndUpdate();
end

-------------------------------------------------------------------------
function LaunchFireball(go)
	local x, y = go["Transform"]:GetTranslate();
	go["Transform"]:SetTranslate(x + 250, y - 250);
	go["Motion"]:AppendNextTarget(x, y);
	go["Motion"]:AttachCompleteCallback(LaunchFirePillar);
	go["Sprite"]:ResetAnimation("scrolleffect_fireball", true);

	go:ToggleRenderAndUpdate();
end

-------------------------------------------------------------------------
function LaunchFirePillar(go)
	go["Transform"]:ModifyTranslate(-20, -110);
	go["Sprite"]:ResetAnimation("scrolleffect_explotion", true);

	LevelManager:ShakeScene();
	AudioManager:PlaySfx(SFX_SCROLL_METEOR_HIT);
end

--[[
-------------------------------------------------------------------------
function LaunchPoison(go)
	go["Sprite"]:ResetAnimation("scrolleffect_poison", true);
	go:ToggleRenderAndUpdate();
end
--]]

-------------------------------------------------------------------------
function PopScrollDialog()
	local transGC = UIManager:GetWidgetComponent("ScrollSelect", "ScrollText", "Transform");
	local interGC = UIManager:GetWidgetComponent("ScrollSelect", "ScrollText", "Interpolator");
	interGC:AttachUpdateCallback(UpdateGOScale, transGC);
	interGC:ResetTarget(0.01, 1.1, 180);
	interGC:AppendNextTarget(1.1, 1.0, 70);

	local spriteGC = UIManager:GetWidgetComponent("ScrollSelect", "Master", "Sprite");
	spriteGC:SetAnimation("ui_scroll_master_talk", true);
	spriteGC:Animate();

	UIManager:EnableWidget("ScrollSelect", "ScrollText", true);
end

-------------------------------------------------------------------------
function UpdateScrollCooldown(value, go)
    local sprite = go["Sprite"]:GetSprite(2);
    local width, height = go["Sprite"]:GetSize();	

    sprite:SetQuadVertices(0, 0, 0, value, width, 0, width, value);
    go["Sprite"]:SetIndieOffset(2, 0, width - value);
end

-------------------------------------------------------------------------
function EndScrollCooldown(value, go)
    local sprite = go["Sprite"]:GetSprite(2);
    local width, height = go["Sprite"]:GetSize();	

    sprite:SetQuadVertices(0, 0, 0, height, width, 0, width, height);
    go["Sprite"]:SetIndieOffset(2, 0, 0);
	go["StateMachine"]:ChangeState("restore");
end

-------------------------------------------------------------------------
function UpdateScrollSlot(value, go)
	go["Transform"]:SetScale(1.0 + (ALPHA_MAX - value) * 0.2);
	go["Sprite"]:SetAlpha(value);
end
