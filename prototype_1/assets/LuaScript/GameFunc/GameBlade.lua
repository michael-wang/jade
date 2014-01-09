--***********************************************************************
-- @file GameBlade.lua
--***********************************************************************

-------------------------------------------------------------------------
BLADE_RADIUS = 30;
BLADE_DIST_THESHOLD = BLADE_RADIUS * BLADE_RADIUS;
--BLADE_COOLDOWN_DURATION = 1000;	  				-- cooldown after 1.0 sec
--ENERGY_REFRESH_FACTOR = 0.002;	  					-- restore 2 points per sec
BLADE_COOLDOWN_DURATION = 200;	  					-- cooldown after 0.2 sec
ENERGY_REFRESH_FACTOR = 0.002;	  					-- restore 2 points per sec
DEFAULT_ENERGY_MAX = 100;
DEFAULT_CRITICAL_HIT_FACTOR = 1.0;

DEFAULT_HAND_SET = 1;
INVERSE_HAND_SET = 2;

WEAPON_INV_POS =
{
	[DEFAULT_HAND_SET] = { 0, 245 },
	[INVERSE_HAND_SET] = { 355, 245 },
};

WEAPON_SLOTS_POS =
{
	[DEFAULT_HAND_SET] =
	{
		{ 33, 270 },
		{ 10, 255 },
		{ 65, 255 },
	},

	[INVERSE_HAND_SET] =
	{
		{ 398, 270 },
		{ 370, 255 },
		{ 425, 255 },
	},
};

SCROLL_SLOTS_POS =
{
	[DEFAULT_HAND_SET] =
	{
		{ 420, 270 },
		{ 350, 270 }, --{ 330, 270 },
	},
	
	[INVERSE_HAND_SET] =
	{
		{ 15, 270 },
		{ 85, 270 }, --{ 105, 270 },
	},
};

-------------------------------------------------------------------------
BladeManager =
{	
	m_BladePosX = 0,
	m_BladePosY = 0,
	m_TransX = 0,
	m_TransY = 0,
	m_MaxEnergy = 0,
    m_BladeEnergy = 0,
	m_BaseEnergy = 0,
	m_BaseLevel = 1,
	m_EnergyRefreshRate = 0,
    m_EnergyCostPerAttack = 0,
	m_CriticalHitFactor = DEFAULT_CRITICAL_HIT_FACTOR,
	m_CriticalHitRate = DEFAULT_CRITICAL_HIT_FACTOR,
	m_CurrentWeapon = 1,
	
    m_Blade = nil,
	m_BladeTemplate = nil,
    m_BladeEnergyWidget = nil,
	m_BladeEnergyNumberWidget = nil,
	m_BladeEnergyInterpolator = nil,
	m_CurrentWeaponFxOffset = nil,	
	m_AttackPower = nil,
	m_SkillType = nil,
	m_SkillValue = nil,	
	m_SliceType = nil,
	m_WeaponWidgetOrder = nil,
	
	m_EquipItemId = {},
	m_EquipTemlates = {},
	m_WeaponObj = {},
	m_WeaponFxOffset = {},
	
    m_HasAttacked = false,
	m_OnEnergyRefreshing = true,
	m_OnTriggerWeapon = false,
	m_OnEnergyTip = false,
	--m_Picker = nil,
	--m_WeaponWidgetSM = nil,
	--m_VibrationEnabled = true,
	
	---------------------------------------------------------------------
	Create = function(self)
        self.m_Blade = ObjectFactory:CreateGameObject("Blade");		
        g_UpdateManager:AddObject(self.m_Blade, BLADE_GROUP);

        self.m_CriticalEffect = ObjectFactory:CreateGameObject("CriticalEffect");
        g_UpdateManager:AddObject(self.m_CriticalEffect, BLADE_GROUP);
		
		self.m_WeaponInv = ObjectFactory:CreateGameObject("WeaponInv");
        self.m_BladeEnergyWidget = UIManager:GetWidget("InGame", "EnergyBar");
		self.m_BladeEnergyNumberWidget = UIManager:GetWidget("InGame", "EnergyBarNumber");
		self.m_BladeEnergyInterpolator = UIManager:GetWidgetComponent("InGame", "EnergyBar", "Interpolator");
		self.m_BladeEnergyInterpolator:AttachUpdateCallback(UpdateBladeEnergy, self.m_BladeEnergyWidget);
		
		-- FX offsets
		local sprite = self.m_Blade["Sprite"];
		local weaponFx = { "we_katana_blue", "we_blade_red", "we_yari_green" };
		for i = 1, 3 do
			sprite:ResetAnimation(weaponFx[i]);
			sprite:ResetRenderSizeAndRadius();
						
			local width, height = sprite:GetSize();
			self.m_WeaponFxOffset[i] = {};
			
			self.m_WeaponFxOffset[i][1] =  { 0, -0.5 * height };
			self.m_WeaponFxOffset[i][2] =  { 0.25 * height, 0 };
			self.m_WeaponFxOffset[i][3] =  { 0.5 * height, 0 };
			self.m_WeaponFxOffset[i][4] =  { 0.75 * height, 0 };
			self.m_WeaponFxOffset[i][5] =  { 0, 0.5 * height };
			self.m_WeaponFxOffset[i][6] =  { 0, -0.5 * height };
			self.m_WeaponFxOffset[i][7] =  { -0.25 * height, 0 };
			self.m_WeaponFxOffset[i][8] =  { -0.5 * height, 0 };
			self.m_WeaponFxOffset[i][9] =  { -0.75 * height, 0 };
			self.m_WeaponFxOffset[i][10] = { 0, 0.5 * height };
		end
		
		-- Shortcuts
		for i = 1, 3 do
			self.m_WeaponObj[i] = UIManager:GetWidgetObject("InGame", "Weapon"..i);
		end
		
		local handset = IOManager:GetRecord(IO_CAT_OPTION, "Handset");
		if (handset) then
			self:ResetHandsettings(handset, false);
		end
		
		self.m_CritWidth, self.m_CritHeight = self.m_CriticalEffect["Sprite"]:GetSize();
		self.m_CritWidth = self.m_CritWidth * 0.5;
		self.m_CritHeight = self.m_CritHeight * 0.5;
		self.m_CriticalWidgetSM = UIManager:GetWidgetComponent("InGame", "CriticalText", "StateMachine");
		self.m_CriticalWidgetSP = UIManager:GetWidgetComponent("InGame", "CriticalText", "Sprite");
--[[ @Vibrate
		self.m_VibrationEnabled = IOManager:GetValue(IO_CAT_OPTION, "Audio", "Vibrate");
		UIManager:GetWidget("GamePause", "Vibrate"):ChangeState(self.m_VibrationEnabled);
--]]
		self.m_TipGO = UIManager:GetWidgetObject("InGame", "TipText");
		self.m_TipInterGC = self.m_TipGO["Interpolator"];
		
		self.Attack = self.AttackInGame;
		self.ShowCriticalHit = self.ShowCriticalHitInNormalStage;
		self.RefreshEnergy = self.RefreshEnergyNormal;
		
		log("BladeManager creation done");
	end,
	---------------------------------------------------------------------
	Reset = function(self)
		local wp = IOManager:GetRecord(IO_CAT_HACK, "Weapon");
		--log("WEAPON: [katana] "..wp[WEAPON_TYPE_KATANA].."  [blade] "..wp[WEAPON_TYPE_BLADE].."  [spear] "..wp[WEAPON_TYPE_SPEAR])
		local itemId1 = SHOP_ITEM_POOL["Weapon"][WEAPON_TYPE_KATANA][ wp[WEAPON_TYPE_KATANA] ];
		local itemId2 = SHOP_ITEM_POOL["Weapon"][WEAPON_TYPE_BLADE][ wp[WEAPON_TYPE_BLADE] ];
		local itemId3 = SHOP_ITEM_POOL["Weapon"][WEAPON_TYPE_SPEAR][ wp[WEAPON_TYPE_SPEAR] ];

		self:EquipWeapon(1, itemId1);
		self:EquipWeapon(2, itemId2);
		self:EquipWeapon(3, itemId3);
		self:ChangeWeapon(1);

		self:ResetEnergyBar();		
		self:ResetBlade();
		self:ResetWeaponSlot();
		
		self:EnableEnergyRefresh(true);
		self:ResetEnergyTip();

		self.Attack = self.AttackInGame;
		self.ShowCriticalHit = self.ShowCriticalHitInNormalStage;
		self.RefreshEnergy = self.RefreshEnergyNormal;
		
		log("BladeManager reset");
    end,
	---------------------------------------------------------------------
	Reload = function(self)
		self.m_Blade:Reload();
		self.m_CriticalEffect:Reload();
		log("BladeManager reloaded");
	end,
	---------------------------------------------------------------------
	Unload = function(self)
		self.m_Blade:Unload();
		self.m_CriticalEffect:Unload();
		log("BladeManager unloaded");
	end,
	---------------------------------------------------------------------
	ResetHandsettings = function(self, hand, doSave)
		assert(hand == 1 or hand == 2);
		
		local weaponSet = WEAPON_SLOTS_POS[hand];		
		UIManager:SetWidgetTranslate("InGame", "Weapon3", weaponSet[3][1], weaponSet[3][2]);
		UIManager:SetWidgetTranslate("InGame", "Weapon2", weaponSet[2][1], weaponSet[2][2]);
		UIManager:SetWidgetTranslate("InGame", "Weapon1", weaponSet[1][1], weaponSet[1][2]);
		
		UIManager:GetWidget("MainEntry", "Hand"):SetImage("ui_mainmenu_handset"..hand);

		self:UpdateHandsettings(hand, doSave);
	end,
	---------------------------------------------------------------------
	ToggleHandsettings = function(self)
		local hand = IOManager:GetRecord(IO_CAT_OPTION, "Handset");
		if (hand == 1) then
			self:ResetHandsettings(2, true);
			UIManager:GetWidgetComponent("MainEntry", "Hand", "Sprite"):SetImage(2, "ui_logo_hand2");			
		else
			self:ResetHandsettings(1, true);
			UIManager:GetWidgetComponent("MainEntry", "Hand", "Sprite"):SetImage(2, "ui_logo_hand1");			
		end

		UIManager:GetWidgetComponent("MainEntry", "Hand", "StateMachine"):ChangeState("show");
	end,
	---------------------------------------------------------------------
	UpdateHandsettings = function(self, hand, doSave)	
		local scrollSet = SCROLL_SLOTS_POS[hand];
		UIManager:SetWidgetTranslate("InGame", "Scroll1", scrollSet[1][1], scrollSet[1][2]);
		UIManager:SetWidgetTranslate("InGame", "Scroll2", scrollSet[2][1], scrollSet[2][2]);
--[[
		if (hand == 1) then
			UIManager:GetWidget("Handsetting", "Handset1"):ChangeState(true);
			UIManager:GetWidget("Handsetting", "Handset2"):ChangeState(false);
		else
			UIManager:GetWidget("Handsetting", "Handset1"):ChangeState(false);
			UIManager:GetWidget("Handsetting", "Handset2"):ChangeState(true);
		end
--]]
		self.m_WeaponInv["Transform"]:SetTranslateEx(WEAPON_INV_POS[hand]);

		UI_WEAPON_POS = WEAPON_SLOTS_POS[hand];

		TUTORIAL_SWIPE_POS = TUTORIAL_SWIPE_POS_SET[hand];
		TUTORIAL_SWIPE_TARGET = TUTORIAL_SWIPE_TARGET_SET[hand];
		TUTORIAL_TAP_POS = TUTORIAL_TAP_POS_SET[hand];
		
		IOManager:SetRecord(IO_CAT_OPTION, "Handset", hand, doSave);
	end,
--[[		
	---------------------------------------------------------------------
	ModifyHandsettings = function(self, hand)
		assert(hand == 1 or hand == 2);

		if (hand == IOManager:GetRecord(IO_CAT_OPTION, "Handset")) then
			--UIManager:GetWidget("Handsetting", "Handset"..hand):ChangeState(true);
			return;
		end

		local offset;
		if (hand == DEFAULT_HAND_SET) then
			offset = -360;
		else
			offset = 360;
		end

		self.m_WeaponObj[1]["Transform"]:ModifyTranslate(offset, 0);
		self.m_WeaponObj[2]["Transform"]:ModifyTranslate(offset, 0);
		self.m_WeaponObj[3]["Transform"]:ModifyTranslate(offset, 0);
		
		self:UpdateHandsettings(hand, true);
	end,
--]]			
	---------------------------------------------------------------------
	ResetBaseEnergy = function(self, value)
		--log("  => ResetBaseEnergy: "..value)
		self.m_BaseEnergy = value;
	end,
	---------------------------------------------------------------------
	ResetBaseLevel = function(self, level)
		--log("  => ResetEnergyLevel: "..level)
		self.m_BaseLevel = level;
	end,
	---------------------------------------------------------------------
	ResetEnergyBar = function(self)
		self.m_MaxEnergy = self:GetMaxEnergyByLevel(self.m_BaseLevel);
        self.m_BladeEnergy = self.m_MaxEnergy;
		self.m_EnergyRefreshRate = self.m_MaxEnergy * ENERGY_REFRESH_FACTOR;
		
		self.m_BladeEnergyWidget:SetValuePair(self.m_MaxEnergy);
		self.m_BladeEnergyNumberWidget:SetValuePair(self.m_MaxEnergy);
		self.m_BladeEnergyInterpolator:Reset();
	end,
	---------------------------------------------------------------------
	UpdateWeaponStat = function(self)
		if (self.m_CurrentWeapon == WEAPON_TYPE_KATANA) then
			UpdateGameStat(GAME_STAT_SLASH_KATANA);
		elseif (self.m_CurrentWeapon == WEAPON_TYPE_BLADE) then
			UpdateGameStat(GAME_STAT_SLASH_BLADE);
		else  
			UpdateGameStat(GAME_STAT_SLASH_SPEAR);
		end
	end,
	---------------------------------------------------------------------
	GetCurrentEnergy = function(self)
		return self.m_BladeEnergy;
	end,
	---------------------------------------------------------------------
	GetMaxEnergy = function(self)
		return self.m_MaxEnergy;
	end,
	---------------------------------------------------------------------
	GetMaxEnergyByLevel = function(self, lv)
		assert(lv > 0);
		return math.ceil(self.m_BaseEnergy * ENERGY_BASE_FACTOR[lv]);
	end,
	---------------------------------------------------------------------
	GetOldAndNewMaxEnergy = function(self)
		--return self.m_MaxEnergy, math.floor(self.m_BaseEnergy + self.m_BaseEnergy * ENERGY_BASE_FACTOR[self.m_BaseLevel + 1]);
		return self.m_MaxEnergy, self:GetMaxEnergyByLevel(self.m_BaseLevel + 1);
	end,
	---------------------------------------------------------------------
	ResetBlade = function(self)
		self.m_CriticalWidgetSM:ChangeState("hide", "CriticalText");
		UIManager:GetWidgetComponent("InGame", "Combo", "StateMachine"):ChangeState("hide");
	end,
	---------------------------------------------------------------------
	ResetWeaponSlot = function(self)
--[[	
		if (self.m_CurrentWeapon ~= 1) then
			self.m_CurrentWeapon = 1;
			UIManager:ExchangeWidgetOrder("InGame", "Weapon1", "Weapon2")
		end
--]]		
		self.m_CurrentWeapon = 1;
		self.m_OnTriggerWeapon = false;

		for i = 1, 3 do
			self.m_WeaponObj[i]["Motion"]:Reset();
			self.m_WeaponObj[i]["Transform"]:SetTranslate(UI_WEAPON_POS[i][1], UI_WEAPON_POS[i][2]);
		end
		
		--[[
		     2------3
			 \     /
			  \  /
			   1 @ UI_WEAPON_POS[1]
		--]]
		self.m_WeaponWidgetOrder = { 1, 2, 3 };
		self.m_WeaponObj[1]["Sprite"]:EnableRender(2, false);
		self.m_WeaponObj[2]["Sprite"]:EnableRender(2, true);
		self.m_WeaponObj[3]["Sprite"]:EnableRender(2, true);

		self:SetCurrentBlade(1);

		UIManager:MoveWidgetToLast("InGame", "Weapon1");
	end,
	---------------------------------------------------------------------
    ResetStatus = function(self, x, y)
		self.m_BladePosX = x;
		self.m_BladePosY = y;
        self.m_HasAttacked = false;
		
		if (self.m_WeaponInv["Bound"]:IsPicked(x, y)) then
			self.m_OnTriggerWeapon = true;
		else
			self.m_OnTriggerWeapon = false;
		end
    end,
	---------------------------------------------------------------------
	EnableWeaponSwitch = function(self, enable)
		if (enable) then
			self.m_WeaponInv["Bound"]:SetSize(140 * APP_SCALE_FACTOR, 90 * APP_SCALE_FACTOR);
		else
			self.m_WeaponInv["Bound"]:SetSize(0, 0);
		end
	end,
	---------------------------------------------------------------------
	EnableWeaponAttack = function(self, enable)
		if (enable) then
			self.Attack = self.AttackInGame;
		else
			self.Attack = self.Switch;
		end
	end,
--[[ @Vibrate	
	---------------------------------------------------------------------
	EnableDeviceVibration = function(self, enable)
		self.m_VibrationEnabled = enable;
		
		if (enable) then
			GameKit.VibrateDevice();
		end
		
		IOManager:SetValue(IO_CAT_OPTION, "Audio", "Vibrate", enable);	
		IOManager:Save();
	end,
--]]	
	---------------------------------------------------------------------
    IsAllowedToAttack = function(self)
        if (self.m_HasAttacked or self.m_Blade["StateMachine"]:IsCurrentState("active")) then
            return false;
        end

		if (self.m_OnEnergyRefreshing and (self.m_BladeEnergy < self.m_EnergyCostPerAttack)) then
--[[ @Vibrate		
			if (self.m_VibrationEnabled) then
				GameKit.VibrateDevice();
			end
--]]
			self:ShowEnergyZeroTip();
		    AudioManager:PlaySfx(SFX_OBJECT_NO_ENERGY);

            return false;
		end
        
        return true;
    end,
	---------------------------------------------------------------------
    Switch = function(self, x, y)
		local transX = x - self.m_BladePosX;
		local transY = y - self.m_BladePosY;
		
		if (self.m_OnTriggerWeapon) then
			if (transX * transX > 100) then
				self.m_OnTriggerWeapon = false;
				self.m_HasAttacked = true;
				
				if (transX > 0) then
					self:SwitchWeaponBySwipeRight();
				else
					self:SwitchWeaponBySwipeLeft();
				end
			end
		end
	end,
	---------------------------------------------------------------------
    AttackInGame = function(self, x, y)
		local transX = x - self.m_BladePosX;
		local transY = y - self.m_BladePosY;
		
		-- Check whether player has triggerred weapon switch action
		if (self.m_OnTriggerWeapon) then
			--if ((transX * transX > 120) and (transY * transY < 80)) then
			if (transX * transX > 100) then
				self.m_OnTriggerWeapon = false;
				self.m_HasAttacked = true;
				
				if (transX > 0) then
					self:SwitchWeaponBySwipeRight();
				else
					self:SwitchWeaponBySwipeLeft();
				end
			end
			
			return;
		end

		if (not self:IsAllowedToAttack()) then
			return;
		end

        local distanceSqr = Square(transX, transY);            
        if (distanceSqr < BLADE_DIST_THESHOLD) then
			return;
        end

		self.m_TransX = math.abs(transX);
		self.m_TransY = math.abs(transY);

        local rad = math.atan2(transY, transX);
        local angle = math.deg(rad);

		--===========================================================
		-- Bounding Sphere
		--===========================================================
		local nx, ny = Normalize(transX, transY);
		local r = self.m_Blade["Bound"]:GetRadius();
		local cx = self.m_BladePosX + nx * r;
		local cy = self.m_BladePosY + ny * r;
		
		self.m_Blade["Bound"]:SetCenter(cx, cy);

		--===========================================================
		-- Slice type
		--===========================================================
		local angleP = angle;
		if (angle < 0) then
			angleP = angle + 180;
		end
		assert(angleP >= 0 and angleP <= 180, "Error blade angle: "..angleP);
		
		if (angleP <= 45) then
			self.m_SliceType = 4;
		elseif (angleP <= 90) then
			self.m_SliceType = 1;
		elseif (angleP <= 135) then
			self.m_SliceType = 2;
		elseif (angleP <= 180) then
			self.m_SliceType = 3;
		else
			assert(false, "error angle: "..angleP)
		end
		--log("Slice : "..self.m_SliceType)
		
		--===========================================================
		-- Weapon offset
		--===========================================================
		local offset;
		if (angle >= 0 and angle <= 15) then
			offset = self.m_CurrentWeaponFxOffset[1];
		elseif (angle >= 15 and angle <= 75) then
			offset = self.m_CurrentWeaponFxOffset[2];
		elseif (angle >= 75 and angle <= 105) then
			offset = self.m_CurrentWeaponFxOffset[3];
		elseif (angle >= 105 and angle <= 165) then
			offset = self.m_CurrentWeaponFxOffset[4];
		elseif (angle >= 165 and angle <= 180) then
			offset = self.m_CurrentWeaponFxOffset[5];
		elseif (angle <= 0 and angle >= -15) then
			offset = self.m_CurrentWeaponFxOffset[6];
		elseif (angle <= -15 and angle >= -75) then
			offset = self.m_CurrentWeaponFxOffset[7];
		elseif (angle <= -75 and angle >= -105) then
			offset = self.m_CurrentWeaponFxOffset[8];
		elseif (angle <= -105 and angle >= -165) then
			offset = self.m_CurrentWeaponFxOffset[9];
		elseif (angle <= -165 and angle >= -180) then
			offset = self.m_CurrentWeaponFxOffset[10];
		end

		local fx = self.m_BladePosX + offset[1];
		local fy = self.m_BladePosY + offset[2];
		self.m_Blade["Transform"]:SetTranslate(fx, fy);
--		self.m_Blade["Transform"]:SetIndieTranslate(fx, fy);
        self.m_Blade["Transform"]:SetRotateByRadian(rad);

		self.m_Blade["Sprite"]:Animate();

		if (self.m_OnEnergyRefreshing) then
			self.m_Blade["StateMachine"]:ChangeState("active");
			self.m_BladeEnergy = self.m_BladeEnergyWidget:ModifyValue(-self.m_EnergyCostPerAttack);
			self.m_BladeEnergyNumberWidget:SetValue(self.m_BladeEnergy);

			if (self.m_BladeEnergy < ENERGY_LOW_THRESHOLD) then
				self:ActivateEnergyTip();
			end
		else
			self.m_Blade["StateMachine"]:ChangeState("active_paused");
		end

        self.m_HasAttacked = true;

		-- Critical hit
		local power = self.m_AttackPower;
		if (math.random(1, 100) <= self.m_CriticalHitRate) then
			power = power * 2;
			self.m_Blade["Attribute"]:Set("criticalHit", true);
		else
			self.m_Blade["Attribute"]:Clear("criticalHit");
	        AudioManager:PlayWeaponSfx();
		end

        EnemyManager:AttackEnemy(self.m_Blade, power, self.m_SkillType);
	end,
	---------------------------------------------------------------------
	SetCriticalHitFactor = function(self, factor)
	log("SetCriticalHitFactor @ " .. self.m_CriticalHitFactor .. "x => " .. factor .."x")
		self.m_CriticalHitFactor = factor;
	end,
	---------------------------------------------------------------------
	GetCriticalHitFactor = function(self)
		return self.m_CriticalHitFactor;
	end,
	---------------------------------------------------------------------    
    RefreshEnergyNormal = function(self)
        if (self.m_BladeEnergy < self.m_MaxEnergy) then
            self.m_BladeEnergy = self.m_BladeEnergyWidget:ModifyValue(g_Timer:GetDeltaTime() * ENERGY_REFRESH_FACTOR);
			self.m_BladeEnergyNumberWidget:SetValue(self.m_BladeEnergy);
        end    
    end,
	---------------------------------------------------------------------    
    RefreshEnergyLow = function(self)
        if (self.m_BladeEnergy < self.m_MaxEnergy) then
            self.m_BladeEnergy = self.m_BladeEnergyWidget:ModifyValue(g_Timer:GetDeltaTime() * ENERGY_REFRESH_FACTOR);
			self.m_BladeEnergyNumberWidget:SetValue(self.m_BladeEnergy);
			
			if (self.m_BladeEnergy >= ENERGY_LOW_THRESHOLD) then
				self:DeactivateEnergyTip();
			end
        end    
    end,
	---------------------------------------------------------------------    
    RefreshEnergyZero = function(self)
        if (self.m_BladeEnergy < self.m_MaxEnergy) then
            self.m_BladeEnergy = self.m_BladeEnergyWidget:ModifyValue(g_Timer:GetDeltaTime() * ENERGY_REFRESH_FACTOR);
			self.m_BladeEnergyNumberWidget:SetValue(self.m_BladeEnergy);
			
			if (self.m_BladeEnergy >= ENERGY_ZERO_THRESHOLD) then
				self:ActivateEnergyTip();
			elseif (self.m_BladeEnergy >= ENERGY_LOW_THRESHOLD) then
				self:DeactivateEnergyTip();
			end
        end    
    end,
	---------------------------------------------------------------------
	EnableEnergyRefresh = function(self, enable)
		self.m_OnEnergyRefreshing = enable;
		
		if (enable) then
			self.m_Blade["StateMachine"]:ChangeState("cooldown");
		else
			self.m_Blade["StateMachine"]:ChangeState("paused");
		end
	end,
	---------------------------------------------------------------------
	HealEnergy = function(self, value)
		value = value * 0.01 * self.m_MaxEnergy;

		if (self.m_BladeEnergy + value > self.m_MaxEnergy) then
			value = self.m_MaxEnergy - self.m_BladeEnergy;
		end
		
		self.m_BladeEnergyInterpolator:AppendNextTarget(self.m_BladeEnergy, self.m_BladeEnergy + value, HEAL_INTER_RATE);
		self.m_BladeEnergy = self.m_BladeEnergy + value;
		--log("HealEnergy: "..value.." => "..self.m_BladeEnergy + value)
		if (self.m_BladeEnergy < ENERGY_LOW_THRESHOLD) then
			self:ActivateEnergyTip();
		else
			self:DeactivateEnergyTip();
		end
	end,
	---------------------------------------------------------------------
	HealEnergyPoint = function(self, point)
--[[ @Old Method
		if (self.m_BladeEnergy + point > self.m_MaxEnergy) then
			point = self.m_MaxEnergy - self.m_BladeEnergy;
		end		
		self.m_BladeEnergyInterpolator:AppendNextTarget(self.m_BladeEnergy, self.m_BladeEnergy + point, HEAL_INTER_RATE);
		self.m_BladeEnergy = self.m_BladeEnergy + point;
--]]		
		self.m_BladeEnergy = self.m_BladeEnergy + point;

		if (self.m_BladeEnergy > self.m_MaxEnergy) then
			self.m_BladeEnergy = self.m_MaxEnergy;
		end		

        self.m_BladeEnergyWidget:SetValue(self.m_BladeEnergy);
		self.m_BladeEnergyNumberWidget:SetValue(self.m_BladeEnergy);

		if (self.m_BladeEnergy < ENERGY_LOW_THRESHOLD) then
			self:ActivateEnergyTip();
		else
			self:DeactivateEnergyTip();
		end
	end,
	---------------------------------------------------------------------
	RestoreAllEnergy = function(self)
		self.m_BladeEnergy = self.m_MaxEnergy;
		self.m_BladeEnergyWidget:SetValue(self.m_MaxEnergy);
		self.m_BladeEnergyNumberWidget:SetValue(self.m_MaxEnergy);
	end,
	---------------------------------------------------------------------
	HurtEnergy = function(self, value)
		value = value * 0.01 * self.m_MaxEnergy;
		
		self.m_BladeEnergy = math.floor(self.m_BladeEnergy - value);

		if (self.m_BladeEnergy < 0) then
			self.m_BladeEnergy = 0;
		end
		--log("HurtEnergy: "..value.." => "..self.m_BladeEnergy)
		
		self.m_BladeEnergyWidget:SetValue(self.m_BladeEnergy);
		self.m_BladeEnergyNumberWidget:SetValue(self.m_BladeEnergy);
		
		self.m_Blade["StateMachine"]:ChangeState("cooldown");
		--AudioManager:PlaySfx(SFX_OBJECT_NO_ENERGY);
	end,
	---------------------------------------------------------------------
	IsHealEnergyDone = function(self)
		return self.m_BladeEnergyInterpolator:IsDone();
	end,
	---------------------------------------------------------------------
	EquipWeapon = function(self, index, itemId)
		--log(">>>>>> [E]: "..itemId.." @ index "..index);
		assert(index == 1 or index == 2 or index == 3);
		
		local obj = GAME_STUFF[itemId];
		assert(obj);
		
		local template = obj[STUFF_ATTR];
		assert(template);
		
		self.m_EquipItemId[index] = itemId;
		self.m_EquipTemlates[index] = template;		

		UIManager:GetWidget("InGame", "Weapon"..index):SetImage(obj[STUFF_ICON]);

		local sprite = self.m_Blade["Sprite"];
		sprite:ResetAnimation(template[ST_WEAPON_FX]);
		sprite:ResetRenderSizeAndRadius();
	end,
	---------------------------------------------------------------------
	SetCurrentBlade = function(self, index)
	--log("======SetCurrentBlade====== weapon # "..index)
		self.m_CurrentWeapon = index;
				
		local template = self.m_EquipTemlates[self.m_CurrentWeapon];
		assert(template, "SetCurrentBlade error: [index] "..index);

		self.m_BladeTemplate = template;
		self.m_AttackPower = template[ST_WEAPON_POWER];
		self.m_EnergyCostPerAttack = template[ST_WEAPON_ENERGY];
		self.m_CriticalHitRate = self.m_CriticalHitFactor * template[ST_WEAPON_CRITICAL];
		--log("Crit Rate: [base] "..template[ST_WEAPON_CRITICAL].." [f] "..self.m_CriticalHitFactor.."  => "..self.m_CriticalHitRate);
		
		self.m_Blade["Attribute"]:Set("template", template);
		
		if (template[ST_WEAPON_SKILL]) then
			self.m_SkillType = template[ST_WEAPON_SKILL][WS_TYPE];
			self.m_SkillValue = template[ST_WEAPON_SKILL][WS_VALUE];
		else
			self.m_SkillType = nil;
			self.m_SkillValue = 0;
		end

		local sprite = self.m_Blade["Sprite"];
		sprite:ResetAnimation(template[ST_WEAPON_FX]);
		sprite:ResetRenderSizeAndRadius();

		-- Set weapon's bounding sphere to 0.8
		local width, height = sprite:GetSize();
		local radius = math.max(width, height) * 0.5;
		self.m_Blade["Bound"]:SetRadius(radius * 0.8);

		local weaponType = template[ST_WEAPON_TYPE];
		self.m_CurrentWeaponFxOffset = self.m_WeaponFxOffset[weaponType];
		AudioManager:SetWeaponSfx(weaponType);
		
		return weaponType;
	end,
	---------------------------------------------------------------------
	IsCurrentBlade = function(self, weaponType)
		return (self.m_CurrentWeapon == weaponType);
	end,
	---------------------------------------------------------------------
	ChangeWeapon = function(self, index)
		assert(index == 1 or index == 2 or index == 3);

		local weaponType = self:SetCurrentBlade(index);
    	self.m_WeaponObj[index]["Sprite"]:EnableRender(2, false);
		
		EnemyManager:ChangeWeapon(weaponType);

		AudioManager:PlaySfx(SFX_UI_SWITCH_WEAPON[weaponType]);
	end,
	---------------------------------------------------------------------
	SwitchWeapon = function(self, x, y)
		if (self.m_OnTriggerWeapon and self.m_WeaponInv["Bound"]:IsPicked(x, y)) then
			self:SwitchWeaponBySwipeRight();
		end
	end,
	---------------------------------------------------------------------
	SwitchWeaponBySwipeRight = function(self)
		--log("SwitchWeaponBySwipeRight =>")
		--log("  OLD : { " .. self.m_WeaponWidgetOrder[1] .. " , " .. self.m_WeaponWidgetOrder[2] .. " , " .. self.m_WeaponWidgetOrder[3] .." }");
		if (self.m_WeaponObj[1]["Motion"]:IsOnMotion()) then
			return;
		end
		
		local prevIndex = table.remove(self.m_WeaponWidgetOrder, 1);
		table.insert(self.m_WeaponWidgetOrder, prevIndex);
		
		local a = self.m_WeaponWidgetOrder[1];
		local b = self.m_WeaponWidgetOrder[2];
		local c = self.m_WeaponWidgetOrder[3];
		--log("  NEW : { " .. a .. " , " .. b .. " , " .. c .." }");
		
		self.m_WeaponObj[a]["Motion"]:SetVelocity(UI_WEAPON_VELOCITY);
		self.m_WeaponObj[a]["Motion"]:ResetTarget(UI_WEAPON_POS[1][1], UI_WEAPON_POS[1][2]);
		self.m_WeaponObj[b]["Motion"]:SetVelocity(UI_WEAPON_VELOCITY_MOD);
		self.m_WeaponObj[b]["Motion"]:ResetTarget(UI_WEAPON_POS[2][1], UI_WEAPON_POS[2][2]);
		self.m_WeaponObj[c]["Motion"]:SetVelocity(UI_WEAPON_VELOCITY);
		self.m_WeaponObj[c]["Motion"]:ResetTarget(UI_WEAPON_POS[3][1], UI_WEAPON_POS[3][2]);

		for i = 1, 3 do
			self.m_WeaponObj[i]["Sprite"]:EnableRender(2, not (i == a));
		end
		UIManager:MoveWidgetToLast("InGame", "Weapon"..a);
		BladeManager:ChangeWeapon(a);
	end,
	---------------------------------------------------------------------
	SwitchWeaponBySwipeLeft = function(self)
		--log("SwitchWeaponBySwipeLeft =>")
		--log("  OLD : { " .. self.m_WeaponWidgetOrder[1] .. " , " .. self.m_WeaponWidgetOrder[2] .. " , " .. self.m_WeaponWidgetOrder[3] .." }");
		if (self.m_WeaponObj[1]["Motion"]:IsOnMotion()) then
			return;
		end
		
		local prevIndex = table.remove(self.m_WeaponWidgetOrder);
		table.insert(self.m_WeaponWidgetOrder, 1, prevIndex);
		
		local a = self.m_WeaponWidgetOrder[1];
		local b = self.m_WeaponWidgetOrder[2];
		local c = self.m_WeaponWidgetOrder[3];
		--log("  NEW : { " .. a .. " , " .. b .. " , " .. c .." }");
		
		self.m_WeaponObj[a]["Motion"]:SetVelocity(UI_WEAPON_VELOCITY);
		self.m_WeaponObj[a]["Motion"]:ResetTarget(UI_WEAPON_POS[1][1], UI_WEAPON_POS[1][2]);
		self.m_WeaponObj[b]["Motion"]:SetVelocity(UI_WEAPON_VELOCITY);
		self.m_WeaponObj[b]["Motion"]:ResetTarget(UI_WEAPON_POS[2][1], UI_WEAPON_POS[2][2]);
		self.m_WeaponObj[c]["Motion"]:SetVelocity(UI_WEAPON_VELOCITY_MOD);
		self.m_WeaponObj[c]["Motion"]:ResetTarget(UI_WEAPON_POS[3][1], UI_WEAPON_POS[3][2]);

		for i = 1, 3 do
			self.m_WeaponObj[i]["Sprite"]:EnableRender(2, not (i == a));
		end
		UIManager:MoveWidgetToLast("InGame", "Weapon"..a);
		BladeManager:ChangeWeapon(a);
	end,
	---------------------------------------------------------------------
	ResetCriticalHit = function(self)
		self.m_CriticalWidgetSM:ChangeState("hide", "CriticalText");
	end,
	---------------------------------------------------------------------
	ShowCriticalHitInNormalStage = function(self, go)
		local x, y = go["Transform"]:GetTranslate();
		local w, h = go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):GetSize();
--		x = x - self.m_CritWidth + w * 0.5;
--		y = y - self.m_CritHeight + h * 0.5;
--		x = x - self.m_CritWidth * 0.5 + w * 0.25;
--		y = y - self.m_CritHeight * 0.5 + h * 0.25;
		x = x - (self.m_CritWidth - w * 0.5) / APP_SCALE_FACTOR;
		y = y - (self.m_CritHeight - h * 0.5) / APP_SCALE_FACTOR;

		self.m_CriticalEffect["Transform"]:SetTranslate(x, y);
		self.m_CriticalEffect["Sprite"]:SetAnimation("effect_critical", true);
---[[ @Screenshot
		self.m_CriticalWidgetSP:SetImage("ui_critical");
		self.m_CriticalWidgetSM:ChangeState("show", "CriticalText");
--]]
	    AudioManager:PlaySfx(SFX_UI_WEAPON_CRITICAL);
	end,
	---------------------------------------------------------------------
	ShowParryEffect = function(self, go)
		local x, y = go["Transform"]:GetTranslate();
		local w, h = go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):GetSize();
		x = x - (self.m_CritWidth - w * 0.5) / APP_SCALE_FACTOR;
		y = y - (self.m_CritHeight - h * 0.5) / APP_SCALE_FACTOR;
		
		-- It can't be coexited with Critical Effect
		self.m_Blade["Attribute"]:Clear("criticalHit");

		self.m_CriticalEffect["Transform"]:SetTranslate(x, y);
		self.m_CriticalEffect["Sprite"]:SetAnimation("effect_parry", true);
	    AudioManager:PlaySfx(SFX_CHAR_SKILL_BLOCK);
	end,
	---------------------------------------------------------------------
	ShowDodgeEffect = function(self)
		self.m_CriticalWidgetSP:SetImage("ui_dodge");
		self.m_CriticalWidgetSM:ChangeState("show", "CriticalText");
		AudioManager:PlaySfx(SFX_OBJECT_TRAP_SHOW);
	end,
	---------------------------------------------------------------------
	ShowEnergyZeroTip = function(self)
		self.m_OnEnergyTip = true;
		self.RefreshEnergy = self.RefreshEnergyZero;

		self.m_TipInterGC:ResetTarget(0.95, 1.1, 250);
		self.m_TipInterGC:AppendNextTarget(1.1, 1.0, 80);
		self.m_TipInterGC:SetCycling(false);	
		self.m_TipInterGC:AttachUpdateCallback(UpdateGOScale, self.m_TipGO["Transform"]);
		self.m_TipGO["Sprite"]:SetAlpha(ALPHA_MAX);

		UIManager:GetWidget("InGame", "TipText"):SetImage("ui_ingame_tip2");
	end,
	---------------------------------------------------------------------
	ActivateEnergyTip = function(self)
		self.m_OnEnergyTip = true;
		self.RefreshEnergy = self.RefreshEnergyLow;

		self.m_TipInterGC:ResetTarget(ALPHA_MAX, ALPHA_HALF, 300);
		self.m_TipInterGC:AppendNextTarget(ALPHA_HALF, ALPHA_MAX, 300);
		self.m_TipInterGC:SetCycling(true);	
		self.m_TipInterGC:AttachUpdateCallback(UpdateGOAlphaAndScale, self.m_TipGO);

		self.m_TipGO:EnableUpdate(true);
		UIManager:GetWidget("InGame", "TipText"):SetImage("ui_ingame_tip1");
		UIManager:EnableWidget("InGame", "TipText", true);
	end,
	---------------------------------------------------------------------
	DeactivateEnergyTip = function(self)
		if (self.m_OnEnergyTip) then
			self.m_OnEnergyTip = false;
			self.RefreshEnergy = self.RefreshEnergyNormal;
			self.m_TipGO:EnableUpdate(false);
			UIManager:EnableWidget("InGame", "TipText", false);
		end
	end,
	---------------------------------------------------------------------
	ResetEnergyTip = function(self)
		self.m_OnEnergyTip = false;
		self.RefreshEnergy = self.RefreshEnergyNormal;
		self.m_TipGO:EnableUpdate(false);
		UIManager:EnableWidget("InGame", "TipText", false);
	end,
	---------------------------------------------------------------------
	GetSkillValue = function(self)
		return self.m_SkillValue;
	end,
	---------------------------------------------------------------------
	GetBladeAttribute = function(self)
		return self.m_Blade["Attribute"];
	end,
	---------------------------------------------------------------------
	GetSliceData = function(self)
		return self.m_SliceType, self.m_TransX, self.m_TransY;
	end,
	---------------------------------------------------------------------
	Render = function(self)
		self.m_Blade:Render();
		
		self.m_CriticalEffect:Render();
	end,
};



-------------------------------------------------------------------------
function UpdateBladeEnergy(value, go)
	go:SetValue(value);
	UIManager:GetWidget("InGame", "EnergyBarNumber"):SetValue(value);
end

-------------------------------------------------------------------------
function UpdateGOAlphaAndScale(value, go)
    go["Sprite"]:SetAlpha(value);
    go["Transform"]:SetScale(1 + value * 0.2);
end
