--***********************************************************************
-- @file GameLevel.lua
--***********************************************************************

--[[

Map Index
	0: Dojo
	1: Map 1
	2: Map 2
	3: Map 3
	4: Map 4
	5: Map 5
	6: Difficulty
--]]
LEVEL_MAX = 5;
LEVEL_AVAIL_MAX = 5;
LEVEL_DIFFICULTY_INDEX = 6;

ENEMY_WAVE_COUNT_MAX = 3;
--ENEMY_WAVE_DURATION = 20000;  -- (enemy wave) 15 sec + (empty) 5 sec
ENEMY_WAVE_DURATION = 15000;  -- (enemy wave) 15 sec

DISTANCE_COUNTER_SPEED = 250;
--TIME_TO_LEAP = 15 / 100;    -- 15 seconds/meter
TIME_TO_LEAP = 60 / 500;      -- Velocity is 500m/60sec

REVIVE_EFFECT_OFFSET = { -70, -70 };
REVIVAL_COST = { 2, 4, 8, 16, 32, 64, 128, 256, 512, 999 };

AVATAR_POS_DEFAULT = 0;
AVATAR_POS_UPPER = 1;
AVATAR_POS_LOWER = 2;

MEDAL_DISTANCE = { 500, 1500, 3000 };
MEDAL_ANIM_NAME = { "ui_medal_500m", "ui_medal_1500m", "ui_medal_3000m" };

BOSS_START_CHANCE = 0;
BOSS_MOD_CHANCE =
{
	5,
	5,
	4,
	4,
	3,
};



-------------------------------------------------------------------------
LevelManager =
{
	m_GameScene = nil,
	m_GameLevel = nil,
	m_CurrentLevel = nil,
	m_GameDifficulty = nil,
	m_NextStage = nil,
	m_MapTargetInterGC = nil,
	m_MapIndex = 1,
	
	m_BaseLife = 0,
	m_BaseLevel = 1,
	m_MaxLife = 0,
	m_Life = 0,
	m_CurrentExp = 0,
	m_MaxExp = 0,
	m_ExpToGain = 0,
	m_MedalLevel = 0,
	m_TimeToLeap = 0,
	m_ShadowEnemyChance = 0,
	m_RandsetEnemyChance = 0,
	m_OldDistCounterSpeed = 0,
	m_OldDropRate = 0,
	m_OldCriticalRate = 0,

	m_BossModeChance = nil,
	m_BossHuntCount = 0,
	m_CurrentDistance = 0,

	m_InnocentPool = nil,
	m_RandsetEnemyPool = nil,
	m_ScrollingEnabled = false,
	m_HasAvatarLevelMax = false,
	m_InTutorialStage = false,
	m_WasNewLevelUnlocked = false,
	m_HasPlayedLevelBgm = false,
	m_IsOnDistanceBoosting = false,
	m_IsOnBossMode = false,
	m_InnocentProtect = false,
	m_IsAvatarBerserker = false,
	m_IsStatusBerserker = false,
	
	m_LifeBarWidget = nil,
	m_LifeBarNumberWidget = nil,
	m_LifeBarInterpolar = nil,
	m_DistanceCounterWidget = nil,
		
	m_Castle = nil,
	m_SceneShaker = nil,
	m_BackdropShade = nil,
	m_CastleShield = nil,
	m_SpeedEffect = nil,
	m_ReviveEffect = nil,
	m_WarningEffect = nil,
	
	m_Avatar = nil,
	m_AvatarIndex = nil,
	m_AvatarName = nil,
	m_AvatarSfx = nil,
	
	m_EnemyLauncher = nil,
	m_EnemyWaveClock = nil,
	m_CastleScrollClock = nil,
	m_EnemyModulesPool = nil,

	m_DecoratorPool = nil,
	m_ActiveDecorators = nil,
	
	m_FieldSet = nil,
	m_MidRangeSet = nil,
	m_LongRangeSet = nil,
		
	---------------------------------------------------------------------
	Create = function(self)		
		--=================
		-- Data
		--=================
		self.m_GameScene = GAME_SCENE_POOL;
		self.m_GameLevel = NINJA_ENDLESS_GAME_LEVEL;		

		--=================
		-- Enemy
		--=================
		self.m_EnemyModulesPool = {};
		
		self.m_EnemyLauncher = ObjectFactory:CreateGameObject("EnemyLauncher");		
		g_UpdateManager:AddObject(self.m_EnemyLauncher, ENEMY_GROUP);
		
		self.m_EnemyWaveClock = ObjectFactory:CreateGameObject("Clock");
		g_UpdateManager:AddObject(self.m_EnemyWaveClock, ENEMY_GROUP);

		self.m_ShadowEnemyClock = ObjectFactory:CreateGameObject("Clock");
		self.m_ShadowEnemyClock["Timer"]:Reset(2000);
		g_UpdateManager:AddObject(self.m_ShadowEnemyClock, ENEMY_GROUP);

		self.m_DistanceCounterWidget = UIManager:GetWidget("InGame", "DistanceCounter");
    
		--===================
		-- Boss
		--===================
		self.m_BossController = ObjectFactory:CreateGameObject("BossController");
		
		if (IOManager:GetRecord(IO_CAT_CONTENT, "BossChance") == nil) then
			IOManager:SetRecord(IO_CAT_CONTENT, "BossChance", BOSS_START_CHANCE, true);
		end

		--===================
		-- Castle
		--===================
	    self.m_Castle = ObjectFactory:CreateGameObject("Castle");		
		self.m_CastleShield = ObjectFactory:CreateGameObject("CastleShield");
		self.m_CastleComboText = ObjectFactory:CreateGameObject("CastleComboText");
		
		self.m_CastleComboEffect = ObjectFactory:CreateGameObject("CastleComboEffect");
		self.m_CastleComboEffect["Interpolator"]:AttachUpdateCallback(UpdateGOScale, self.m_CastleComboEffect["Transform"]);
		
		self.m_CastleHurtEffect = ObjectFactory:CreateGameObject("CastleHurtEffect");
		self.m_CastleHurtEffect["Shape"]:SetSize(SCREEN_UNIT_X, SCREEN_UNIT_Y);

		self.m_CastleFullScreenEffect = ObjectFactory:CreateGameObject("ScrollEffectObject");
		self.m_CastleFullScreenEffect["Transform"]:SetTranslate(0, 0);
		self.m_CastleFullScreenEffect["Transform"]:SetScale(3.0);
				
		--===================
		-- Backdrop
		--===================
		
		self:InitScrollingLayers();
				
		self.m_BackdropShade = ObjectFactory:CreateGameObject("BackdropShade");
		self.m_BackdropShade:EnableRender(false);
		
		self.m_SceneShaker = ObjectFactory:CreateGameObject("RealShaker");
	    g_UpdateManager:AddObject(self.m_SceneShaker, CASTLE_GROUP);
		
		self.m_CastleScrollClock = ObjectFactory:CreateGameObject("CastleScrollClock");
		
		self.m_SpeedEffect = ObjectFactory:CreateGameObject("SpeedEffect");

		self.m_ReviveEffect = ObjectFactory:CreateGameObject("ReviveEffect");
		self.m_ReviveEffect["Transform"]:SetScale(2.0);
		
		self.m_WarningEffect = ObjectFactory:CreateGameObject("WarningEffect");	
--[[ @BackdropField
		self.m_BackdropField = ObjectFactory:CreateGameObject("BackdropField");
		self.m_BackdropField["Shape"]:SetColor(0, 100, 0, 50);
		
		self.m_BackdropMidRange = ObjectFactory:CreateGameObject("BackdropField");
		self.m_BackdropMidRange["Shape"]:SetColor(100, 0, 0, 100);
		
		self.m_BackdropLongRange = ObjectFactory:CreateGameObject("BackdropField");
		self.m_BackdropLongRange["Shape"]:SetColor(0, 0, 100, 100);
--]]
		--=================
		-- Decorator
		--=================
		DECORATOR_MAX = 20;
		
		self.m_DecoratorLauncher = ObjectFactory:CreateGameObject("SceneDecoratorLauncher");
		self.m_DecoratorPool = PoolManager:Create("SceneDecorator", DECORATOR_MAX, "inactive");
		self.m_ActiveDecorators = self.m_DecoratorPool:GetActivePool();

		--=================
		-- UI
		--=================
		
		-- Shortcuts
        self.m_LifeBarWidget = UIManager:GetWidget("InGame", "LifeBar");
		self.m_LifeBarNumberWidget = UIManager:GetWidget("InGame", "LifeBarNumber");
		assert(self.m_LifeBarWidget and self.m_LifeBarNumberWidget);
		
		self.m_LauncherAttr = self.m_EnemyLauncher["Attribute"];
		
		self.m_LifeBarInterpolar = UIManager:GetWidgetComponent("InGame", "LifeBar", "Interpolator");
		self.m_LifeBarInterpolar:AttachUpdateCallback(UpdateCastleLife, self.m_LifeBarWidget);
		
		-- Re-position widgets according to 'Background' in 'AvatarStat' UI
		
		local w, h = UIManager:GetWidgetComponent("AvatarStat", "Background", "Sprite"):GetSize();
		UIManager:SetWidgetTranslate("AvatarStat", "Background", (SCREEN_UNIT_X - w) * 0.5, (SCREEN_UNIT_Y - h) * 0.5);
		
		local ox, oy = UIManager:GetWidgetTranslate("AvatarStat", "Background");
		local widgetGroup = UIManager:GetWidgetGroup("AvatarStat", "CenterWidgets");
		for _, widgetName in ipairs(widgetGroup) do
			local x, y = UIManager:GetWidgetTranslate("AvatarStat", widgetName);
			UIManager:SetWidgetTranslate("AvatarStat", widgetName, ox + x * APP_SCALE_FACTOR, oy + y * APP_SCALE_FACTOR);
		end

		CycleGORotate(UIManager:GetWidgetObject("AvatarStat", "AvatarShine"), 0, 1, 5000);
		
		-- EndlessMap
		for i = 0, LEVEL_MAX do
			local interGC = UIManager:GetWidgetComponent("EndlessMap", "Map"..i, "Interpolator");
			interGC:AttachUpdateCallback(UpdateGOScale, UIManager:GetWidgetComponent("EndlessMap", "Map"..i, "Transform"));		
		end
		local interGC = UIManager:GetWidgetComponent("EndlessMap", "GameDifficulty", "Interpolator");
		interGC:AttachUpdateCallback(UpdateGOScale, UIManager:GetWidgetComponent("EndlessMap", "GameDifficulty", "Transform"));
		
		self.m_MedalDistanceSM = UIManager:GetWidgetComponent("Medal", "MedalDistance", "StateMachine");
		
		self.m_BoostSM = UIManager:GetUIComponent("Boost", "StateMachine");
		self.m_BoostSM:ChangeState("inactive");

		self:ResetBaseLife(0);
		self:ResetBaseLevel(1);
		
		--===================
		-- Game Difficulty
		--===================    
		self.m_GameDifficulty = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Difficulty");
		--log("GAME DIFF : "..GAME_DIFFICULTY[self.m_GameDifficulty])

		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			self.LaunchEnemy = self.LaunchEnemyNormalMode;
			self.EnterBossMode = self.EnterBossMode_Normal;
		else
			self.LaunchEnemy = self.LaunchEnemyShadowMode;
			self.EnterBossMode = self.EnterBossMode_Shadow;
		end

	    self:InitializeMapButtons();
		
		--=================
		-- UI: BossLifebar
		--=================
		local bossInter = UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Interpolator");
		bossInter:AttachCallback(UpdateWidgetNumber, UpdateWidgetNumber, UIManager:GetWidget("BossLifebar", "BossBar"));
		
		--=================
		-- UI: AvatarStat
		--=================
		local interGC1 = UIManager:GetWidgetComponent("AvatarStat", "LifeBar", "Interpolator");
		interGC1:AttachCallback(UpdateAvatarLife, UpdateAvatarLife, UIManager:GetWidget("AvatarStat", "LifeBar"));

		local interGC2 = UIManager:GetWidgetComponent("AvatarStat", "EnergyBar", "Interpolator");
		interGC2:AttachCallback(UpdateAvatarEnergy, UpdateAvatarEnergy, UIManager:GetWidget("AvatarStat", "EnergyBar"));

		local interGC3 = UIManager:GetWidgetComponent("AvatarStat", "ExpBar", "Interpolator");
		--interGC3:AttachCallback(UpdateAvatarExpBar, UpdateAvatarExpBar, UIManager:GetWidget("AvatarStat", "ExpBar"));
		interGC3:AttachCallback(UpdateWidgetNumber, UpdateWidgetNumber, UIManager:GetWidget("AvatarStat", "ExpBar"));

		local interGC4 = UIManager:GetWidgetComponent("AvatarStat", "ExpBarNumber", "Interpolator");
		--interGC4:AttachCallback(UpdateExpGain, UpdateExpGain, UIManager:GetWidget("AvatarStat", "ExpBarNumber"));
		interGC4:AttachCallback(UpdateWidgetNumber, UpdateWidgetNumber, UIManager:GetWidget("AvatarStat", "ExpBarNumber"));
		
		local interGC5 = UIManager:GetWidgetComponent("AvatarStat", "AvatarLv", "Interpolator");
		interGC5:AttachCallback(UpdateGOScale, UpdateGOScale, UIManager:GetWidgetComponent("AvatarStat", "AvatarLv", "Transform"));

        local interGC6 = UIManager:GetWidgetComponent("EndlessMap", "Title", "Interpolator");
        interGC6:AttachCallback(UpdateGOScale, UpdateGOScale, UIManager:GetWidgetComponent("EndlessMap", "Title", "Transform"));

	    local interGC7 = UIManager:GetWidgetComponent("GameStat", "ScoreNum", "Interpolator");
		interGC7:AttachUpdateCallback(UpdateWidgetNumber, UIManager:GetWidget("GameStat", "ScoreNum"));
		
		--=================
		-- UI: Misc
		--=================		
		self:RepositionMap();
		
	    UIManager:SetUITranslate("EndlessMap", 0, APP_HEIGHT);
	    UIManager:SetUITranslate("History", 0, APP_HEIGHT);

		UI_BOOST_POS[1], UI_BOOST_POS[2] = UIManager:GetUIComponent("Boost", "Transform"):GetTranslate();
		UI_REVIVE_POS[1], UI_REVIVE_POS[2] = UIManager:GetUIComponent("Revive", "Transform"):GetTranslate();
		
	    GameDataManager:SetData("ReviveCount", 0);
	    GameDataManager:SetData("ReviveCountAfterThreshold", 0);

		log("LevelManager creation done");
	end,
	---------------------------------------------------------------------
	Reset = function(self)
		--=================
		-- Castle
		--=================
		self.m_Castle["StateMachine"]:ChangeState("inactive", self.m_CastleShield);

		self:ResetComboEffect();

		self.m_SceneShaker["Shaker"]:Reset();
		
		--=================
		-- Enemy
		--=================
		self.m_EnemyLauncher["StateMachine"]:ChangeState("inactive");
		self.m_EnemyWaveClock["Timer"]:Reset();

		--=================
		-- Boss
		--=================
		self:ResetFromBossMode();

		--=================
		-- Decorator
		--=================
		self.m_DecoratorLauncher["StateMachine"]:ChangeState("inactive");
		self.m_DecoratorPool:ResetPool();
		
		self.m_CastleScrollClock["StateMachine"]:ChangeState("inactive");

		--=================
		-- Data
		--=================
		self.m_BossEnemy = nil;
		self.m_MapTargetInterGC = nil;
		self.m_NextStage = nil;
		self.m_WasNewLevelUnlocked = false;
		self.m_HasPlayedLevelBgm = false;
		self.m_IsOnDistanceBoosting = false;
		self.m_RandsetEnemyChance = 0;
		self.m_OldDistCounterSpeed = 0;
		self.m_OldDropRate = 0;
		self.m_OldCriticalRate = 0;
		self.m_BossHuntCount = 0;
		self.m_CurrentDistance = 0;
		self.m_BossModeChance = nil;
		
		--=================
		-- UI
		--=================
		self:ResetLifeBar();
		self:EnableDistanceCounter(false);
		
		self.m_DistanceCounterWidget:SetValue(0);
		self.m_BoostSM:ChangeState("inactive");

	    GameDataManager:SetData("ReviveCount", 0);
	    GameDataManager:SetData("ReviveCountAfterThreshold", 0);

		log("LevelManager reset");
	end,
	---------------------------------------------------------------------
	Reload = function(self)		
		self.m_Backdrop:UnloadByDummy();		
		self.m_LayerPre:UnloadByDummy();
		self.m_LayerMid:UnloadByDummy();
		self.m_LayerPost:UnloadByDummy();
		self.m_LayerOverlay:UnloadByDummy();

		for _, deco in ipairs(self.m_DecoratorPool:GetInactivePool()) do
			deco:UnloadByDummy();
		end

		self.m_Castle:UnloadByDummy();

		log("LevelManager reloaded");
	end,
	---------------------------------------------------------------------
	Unload = function(self)
		self.m_Backdrop:UnloadByDummy();
		self.m_LayerPre:UnloadByDummy();
		self.m_LayerMid:UnloadByDummy();
		self.m_LayerPost:UnloadByDummy();
		self.m_LayerOverlay:UnloadByDummy();

		self.m_DecoratorPool:ResetPool();
		for _, deco in ipairs(self.m_DecoratorPool:GetInactivePool()) do
			deco:UnloadByDummy();
		end

		self.m_Castle:UnloadByDummy();

		for _, texture in ipairs(self.m_CurrentLevel[LEVEL_PRELOAD_TEXTURES]) do
			UnloadTexture(texture);
		end
		
		log("LevelManager unloaded");
	end,
	---------------------------------------------------------------------
	ResetBaseLife = function(self, value)
		--log("  => ResetBaseLife: "..value)
		self.m_BaseLife = value;
		self:ResetLifeBar();
	end,
	---------------------------------------------------------------------
	ResetBaseLevel = function(self, level)
		--log("  => ResetBaseLevel: "..level)
		self.m_BaseLevel = level;
		self:ResetLifeBar();
	end,
	---------------------------------------------------------------------
	ResetLifeBar = function(self)
--[[	
		self.m_MaxLife = self:GetMaxLifeByLevel(self.m_BaseLevel);
		self.m_Life = self.m_MaxLife;

		self.m_LifeBarWidget:SetValuePair(self.m_MaxLife);
		self.m_LifeBarNumberWidget:SetValuePair(self.m_MaxLife);
--]]		
		self.m_LifeBarInterpolar:Reset();
		
		if (self.m_IsChallengeMode) then
			self.m_MaxLife = 1;
			self.m_Life = 1;
			self.m_LifeBarWidget:SetValuePair(1);
			self.m_LifeBarNumberWidget:SetValuePair(1);

			if (self.m_IsAvatarBerserker) then
				self:SetAvatarBerserk(true);
			end
		else
			self.m_MaxLife = self:GetMaxLifeByLevel(self.m_BaseLevel);
			self.m_Life = self.m_MaxLife;
			self.m_LifeBarWidget:SetValuePair(self.m_MaxLife);
			self.m_LifeBarNumberWidget:SetValuePair(self.m_MaxLife);
		end
	end,
	---------------------------------------------------------------------
	GetMaxLifeByLevel = function(self, lv)
		assert(lv > 0);
		return math.ceil(self.m_BaseLife * LIFE_BASE_FACTOR[lv]);
	end,
	---------------------------------------------------------------------
	GetOldAndNewMaxLife = function(self)
		--return self.m_MaxLife, math.floor(self.m_BaseLife + self.m_BaseLife * LIFE_BASE_FACTOR[self.m_BaseLevel + 1]);
		return self.m_MaxLife, self:GetMaxLifeByLevel(self.m_BaseLevel + 1);
	end,
	---------------------------------------------------------------------
	HealLife = function(self, value)
		value = value * 0.01 * self.m_MaxLife;

		if (self.m_Life + value > self.m_MaxLife) then
			value = self.m_MaxLife - self.m_Life;
		end
		--log("HealLife: "..value.." => "..self.m_Life + value)
		
		local speed = HEAL_INTER_RATE;
		if (value > 500) then
			speed = HEAL_INTER_RATE * 3;
		elseif (value > 250) then			
			speed = HEAL_INTER_RATE * 2;
		end
		self.m_LifeBarInterpolar:AppendNextTarget(self.m_Life, self.m_Life + value, speed);
		
		self.m_Life = self.m_Life + value;

		-- Special case for Avatar Berserker
		if (self.m_IsStatusBerserker and (not self.m_IsChallengeMode)) then
			if ((self.m_Life ~= self.m_MaxLife) and (self.m_Life >= self.m_MaxLife * 0.3)) then
				self:SetAvatarBerserk(false);
			end
		end
	end,
	---------------------------------------------------------------------
	IsHealLifeDone = function(self)
		return self.m_LifeBarInterpolar:IsDone();
	end,
	---------------------------------------------------------------------
	GetLifePercent = function(self)
		return math.floor(100 * self.m_Life / self.m_MaxLife);
	end,

	--===================================================================
	-- Avatar
	--===================================================================

	---------------------------------------------------------------------
	ResetAvatar = function(self, avatar, index, forTutorial)
		self.m_Avatar = avatar;
		self.m_AvatarIndex = index;
		self.m_AvatarName = avatar[AVATAR_NAME];
		self.m_AvatarSfx = avatar[AVATAR_SFX];
		self.m_AvatarDodge = avatar[AVATAR_DODGE];
		self.m_ExpToGain = 0;

		local lv = IOManager:GetValue(IO_CAT_HACK, "AvatarLv", index);
		
		if (forTutorial) then
			lv = 1;
		end

		self:ResetBaseLevel(lv);
		BladeManager:ResetBaseLevel(lv);
				
		self.m_Castle["Attribute"]:Set("AnimMove", avatar[AVATAR_NAME] .. "_move");
		self.m_Castle["Attribute"]:Set("AnimHurt", avatar[AVATAR_NAME] .. "_wounded");
		self.m_Castle["Attribute"]:Set("AnimFail", avatar[AVATAR_NAME] .. "_dead");
		self.m_Castle["Attribute"]:Set("PositionIndex", AVATAR_POS_DEFAULT);

		self:ResetBaseLife(avatar[AVATAR_LIFE]);		
		self:ResetBaseSpeed(avatar[AVATAR_SPEED]);

		BladeManager:ResetBaseEnergy(avatar[AVATAR_ENERGY]);
		BladeManager:SetCriticalHitFactor(DEFAULT_CRITICAL_HIT_FACTOR);
		
		if (avatar[AVATAR_COIN]) then
			EnemyManager:SetCoinMutiplier(3);
		else
			EnemyManager:SetCoinMutiplier(1);
		end

		self.m_IsAvatarBerserker = avatar[AVATAR_CRIT];
		self.m_IsStatusBerserker = false;
	end,
	---------------------------------------------------------------------
	GetAvatarID = function(self)
		if (self.m_Avatar) then
			return self.m_Avatar[AVATAR_ID];
		end
	end,
	---------------------------------------------------------------------
	GetAvatarName = function(self)
		if (self.m_Avatar) then
			return self.m_Avatar[AVATAR_NAME];
		end
	end,
	---------------------------------------------------------------------
	GetAvatarStatImage = function(self)
		return self.m_Avatar[AVATAR_STAT];
	end,
	---------------------------------------------------------------------
	GetAvatarLevel = function(self)
		return IOManager:GetValue(IO_CAT_HACK, "AvatarLv", self.m_AvatarIndex);
	end,
	---------------------------------------------------------------------
	GetAvatarKobanBonusChance = function(self)
		if (self.m_Avatar[AVATAR_COIN]) then
			return 8; --10 -- 10% more chance to get koban
		else
			return 0;
		end
	end,
	---------------------------------------------------------------------
	GetDistanceKobanBonusChance = function(self)
		local distance = self.m_DistanceCounterWidget:GetValue();
		-- Base is 10%
		if (distance < 1500) then
			return -5;	-- 5%
		elseif (distance < 3000) then
			return 0;	-- 10%
		else
			return 5;	-- 15%
		end
	end,
	---------------------------------------------------------------------
	ResetBaseSpeed = function(self, speed)
		--log("ResetBaseSpeed : "..speed)
		UIManager:GetWidgetComponent("InGame", "DistanceCounter", "Timer"):Reset(speed);
	end,
	---------------------------------------------------------------------
	UpdateAvatarForBgm = function(self)
		if (not self.m_HasPlayedLevelBgm and AudioManager:IsCurrentBgmDone()) then
			self.m_HasPlayedLevelBgm = true;
			AudioManager:PlayLevelLoopBgm(self.m_MapIndex);
			StageManager:ChangeStage("InGame");
		end
	end,
	---------------------------------------------------------------------
	UpdateAvatarStartRunning = function(self)
		self.m_Castle:Update();
		
		if (not self.m_HasPlayedLevelBgm and AudioManager:IsCurrentBgmDone()) then
			self.m_HasPlayedLevelBgm = true;
			AudioManager:PlayLevelLoopBgm(self.m_MapIndex);
		end

		if (self.m_Castle["Motion"]:IsDone()) then
			if (self.m_HasPlayedLevelBgm) then
				StageManager:ChangeStage("InGame");
			else
				StageManager:ChangeStage("PreInGameBgm");
			end

			-- Must call ShowBoostUI() before EnableScrollingBackdrop()
			self:ShowBoostUI();
			self:EnableScrollingBackdrop(true);
			self:StartLauncher();
		end
	end,
	---------------------------------------------------------------------
	UpdateAvatarTutorial = function(self)
		self.m_Castle:Update();

		if (not self.m_HasPlayedLevelBgm and AudioManager:IsCurrentBgmDone()) then
			self.m_HasPlayedLevelBgm = true;
			AudioManager:PlayLevelLoopBgm(self.m_MapIndex);
		end
		
		if (self.m_HasPlayedLevelBgm and self.m_Castle["Motion"]:IsDone()) then
			self:EnableScrollingBackdrop(true);
			self:EnableDistanceCounter(false);
			UIManager:EnableWidget("InGame", "DistanceCounter", false);			
			StageManager:ChangeStage("TutorialWait");
		end
	end,
	---------------------------------------------------------------------
	AvatarPreFail = function(self)
		EnemyManager:Stop();
		
		BladeManager:EnableEnergyRefresh(false);
		ScrollManager:EnableScrollButtons(false);
		
		self:RemoveAllScrollEffects();
        self:EnableScrollingBackdrop(false);
		
		self.m_EnemyLauncher["Timer"]:EnableUpdate(false);
		self.m_EnemyWaveClock["Timer"]:EnableUpdate(false);
		self.m_Castle["StateMachine"]:ChangeState("broken", self.m_CastleHurtEffect);

		-- Cost for revival
		local cost;
		if (self.m_IsOnBossMode) then
			local count = GameDataManager:ModifyData("ReviveCountBossMode", 1);
			cost = REVIVAL_COST[count] or 999;
		elseif (self.m_IsChallengeMode) then
			local count = GameDataManager:ModifyData("ReviveCountAfterThreshold", 1);
			cost = REVIVAL_COST[count] or 999;
		else
			if (self.m_DistanceCounterWidget:GetValue() < 3000) then
				if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
					cost = 1;
				else
					cost = 2;
				end
			else
				local count = GameDataManager:GetData("ReviveCountAfterThreshold") + 1;
				cost = REVIVAL_COST[count] or 999;
			end
		end
		assert(cost, "Revival cost error");
		--log("COST: "..cost)		
		UIManager:GetWidget("Revive", "Cost"):SetValue(cost);

		-- Proceed revive
		StageManager:ChangeStage("GameRevive");

		-- Special achievements
		if (BladeManager:GetCurrentEnergy() < 5) then
			--log("Energy Waster!")
			UpdateAchievement(ACH_ENERGY_LOW);
		end

		if (EnemyManager:GetInnocentHitCount() >= 3) then
			UpdateAchievement(ACH_INNOCENT_MULTLE_HURT);
		end
		
		if (self.m_IsOnBossMode) then
			GameKit.LogEventWithParameter("AvatarFail", "boss", "reason", false);
		    GameKit.LogEventWithParameter("BossFight", "lose", "result", false);
		    GameKit.LogEventWithParameter("BossFight", "lose", "boss #" .. self.m_MapIndex, false);
		else
			GameKit.LogEventWithParameter("AvatarFail", "enemy", "reason", false);
		end
	end,
	---------------------------------------------------------------------
	Revive = function(self)
		GameDataManager:ModifyData("ReviveCount", 1);
		if (self.m_DistanceCounterWidget:GetValue() >= 3000) then
			GameDataManager:ModifyData("ReviveCountAfterThreshold", 1);
		end
		
		self.m_ReviveEffect:Reload();
		
		self.m_Castle["StateMachine"]:ChangeState("revive", self.m_ReviveEffect);

		--BladeManager:ResetWeaponSlot();
        LevelManager:HealLife(100);
        BladeManager:HealEnergy(100);

        AudioManager:PlaySfx(SFX_UI_REVIVE);
	end,
	---------------------------------------------------------------------
	ReviveAvatar = function(self)
		self.m_ReviveEffect:Unload();

		BladeManager:EnableEnergyRefresh(true);
		ScrollManager:ReviveScrolls();

        self:EnableScrollingBackdrop(true);
		self.m_EnemyLauncher["Timer"]:EnableUpdate(true);
		
		if (not self.m_IsOnBossMode) then
			self.m_EnemyWaveClock["Timer"]:EnableUpdate(true);
		end

		if (self.m_IsAvatarBerserker and (not self.m_IsChallengeMode)) then
			self:SetAvatarBerserk(false);
--			self.m_IsStatusBerserker = state;
--			self.m_Castle["Attribute"]:Set("AnimMove", "avatar_berserker1_move");
--			BladeManager:SetCriticalHitFactor(DEFAULT_CRITICAL_HIT_FACTOR);
		end

        StageManager:ChangeStage("InGame");
	end,
	---------------------------------------------------------------------
	GainExp = function(self, exp)
		--log("GainExp: "..self.m_ExpToGain.."  =>  "..self.m_ExpToGain + exp)
		self.m_ExpToGain = self.m_ExpToGain + exp;
	end,
	---------------------------------------------------------------------
	ResetExpBar = function(self, lv)
		self.m_CurrentExp = IOManager:GetValue(IO_CAT_HACK, "AvatarExp", self.m_AvatarIndex);
		assert(self.m_CurrentExp, "Current Exp is error")
				
		if (lv == AVATAR_MAX_LV) then
			self.m_HasAvatarLevelMax = true;
			self.m_MaxExp = 0;

			UIManager:GetWidget("AvatarStat", "ExpBar"):SetValuePair(100);
			UIManager:GetWidget("AvatarStat", "ExpBarNumber"):SetValue(self.m_ExpToGain);
		else
			self.m_HasAvatarLevelMax = false;
			self.m_MaxExp = DEFAULT_EXP_DATA[lv + 1];
			assert(self.m_MaxExp, "Max Exp is error")

			UIManager:GetWidget("AvatarStat", "ExpBar"):SetMaxValue(self.m_MaxExp);
			UIManager:GetWidget("AvatarStat", "ExpBar"):SetValue(self.m_CurrentExp);		
		end		
	end,
	---------------------------------------------------------------------
	ResetAvatarStat = function(self)
		local lv = IOManager:GetValue(IO_CAT_HACK, "AvatarLv", self.m_AvatarIndex);
		
		self:ResetExpBar(lv);
		
		UIManager:GetWidget("AvatarStat", "AvatarLv"):SetImage("ui_lvup_lv"..lv);
		UIManager:GetWidget("AvatarStat", "LifeBar"):SetValuePair(self.m_MaxLife);
		UIManager:GetWidget("AvatarStat", "LifeBarNumber"):SetValuePair(self.m_MaxLife);
		UIManager:GetWidget("AvatarStat", "EnergyBar"):SetValuePair(BladeManager:GetMaxEnergy());
		UIManager:GetWidget("AvatarStat", "EnergyBarNumber"):SetValuePair(BladeManager:GetMaxEnergy());

		UIManager:GetWidget("AvatarStat", "AvatarName"):ResetImage(AVATAR_DATA_POOL[self.m_AvatarIndex][AVATAR_LVNAME]);
		UIManager:GetWidget("AvatarStat", "AvatarIcon"):ResetImage(AVATAR_DATA_POOL[self.m_AvatarIndex][AVATAR_STAT]);
		
		UIManager:EnableWidget("AvatarStat", "AvatarShine", false);
		UIManager:EnableWidget("AvatarStat", "Paperfall", false);
		UIManager:EnableWidget("AvatarStat", "ExpBarNumber", true);

		g_TaskManager:AddTask(StageChangeTask, "AvatarExp", 0, 500);
	end,
	---------------------------------------------------------------------
	EnterAccumExpState = function(self)
		if (self.m_HasAvatarLevelMax) then
			UIManager:GetWidget("AvatarStat", "ExpBarNumber"):SetValue(self.m_ExpToGain);
			UIManager:GetUIComponent("AvatarStat", "StateMachine"):ChangeState("maxlevel");
		else
			UIManager:GetUIComponent("AvatarStat", "StateMachine"):ChangeState("exp", true);
		end
	end,
--[[	
	---------------------------------------------------------------------
	SkipAvatarStat = function(self)
		local sm = UIManager:GetUIComponent("AvatarStat", "StateMachine");
		if (sm:IsCurrentState("exp")) then
	        g_TaskManager:Clear();
			
			local exp = IOManager:GetValue(IO_CAT_HACK, "AvatarExp", self.m_AvatarIndex);
			UIManager:GetWidget("AvatarStat", "ExpBar"):SetValue(exp);
			UIManager:GetWidgetComponent("AvatarStat", "ExpBar", "Interpolator"):Reset();
			UIManager:GetWidget("AvatarStat", "ExpBarNumber"):SetValue(self.m_ExpToGain);
			UIManager:GetWidgetComponent("AvatarStat", "ExpBarNumber", "Interpolator"):Reset();
			UIManager:EnableWidget("AvatarStat", "ExpBarNumber", true);
			
			if (exp >= self:GetMaxExp()) then
				sm:ChangeState("levelup");
			else
				sm:ChangeState("delay", "inactive");
			end
		end
	end,
--]]	
	---------------------------------------------------------------------
	AccumulateExp = function(self, initial)
		if (initial and (self.m_ExpToGain < EXP_GAIN_MIN)) then
			self.m_ExpToGain = EXP_GAIN_MIN;
		end

		local exp = self.m_CurrentExp + self.m_ExpToGain;
		local realExp, realExpToGain;
		--log("ExpToGain: "..self.m_ExpToGain)		
		if (self.m_CurrentExp + exp > self.m_MaxExp) then
			realExp = self.m_MaxExp;
			realExpToGain = self.m_MaxExp - self.m_CurrentExp;
			self.m_ExpToGain = exp - realExpToGain;
		else
			realExp = exp;
			realExpToGain = self.m_ExpToGain;
			self.m_ExpToGain = 0;
		end
		--log("Max Exp: "..self.m_MaxExp.." / Total Exp: "..exp.." / Real Exp: "..realExp)

		IOManager:SetValue(IO_CAT_HACK, "AvatarExp", self.m_AvatarIndex, realExp);

		UIManager:GetWidget("AvatarStat", "ExpBar"):SetValue(self.m_CurrentExp);
		UIManager:GetWidgetComponent("AvatarStat", "ExpBar", "Interpolator"):ResetTarget(self.m_CurrentExp, realExp, 500);

		UIManager:GetWidget("AvatarStat", "ExpBarNumber"):SetValue(0);
		UIManager:GetWidgetComponent("AvatarStat", "ExpBarNumber", "Interpolator"):ResetTarget(0, realExpToGain, 500);

	    AudioManager:PlaySfx(SFX_UI_STAT_ACCUM);
	end,
	---------------------------------------------------------------------
	ReaccumulateExp = function(self, sm)
		if ((self.m_ExpToGain == 0) or self.m_HasAvatarLevelMax) then
			sm:ChangeState("delay", "inactive");
		else
			sm:ChangeState("delay", "exp");
		end
	end,
	---------------------------------------------------------------------
	LevelUpAvatar = function(self)
		assert(self.m_AvatarIndex > 0);

		IOManager:SetValue(IO_CAT_HACK, "AvatarExp", self.m_AvatarIndex, 0);
		local lv = IOManager:ModifyValue(IO_CAT_HACK, "AvatarLv", self.m_AvatarIndex, 1);
		local interGC = UIManager:GetWidgetComponent("AvatarStat", "AvatarLv", "Interpolator");
		interGC:ResetTarget(1.0, 1.3, 125);
		interGC:AppendNextTarget(1.3, 0.9, 125);
		interGC:AppendNextTarget(0.9, 1.0, 75);            
        UIManager:GetWidgetComponent("AvatarStat", "AvatarLv", "Sprite"):SetImage("ui_lvup_lv"..lv);
		UIManager:EnableWidget("AvatarStat", "AvatarShine", true);
		UIManager:EnableWidget("AvatarStat", "Paperfall", true);
		
		self:ShowLifeAndEnergy();
		self:UpdateAvatarAchievement(lv);
		
		--if (lv == AVATAR_MAX_LV) then
		--	self.m_ExpToGain = 0;
		--end
		self:ResetExpBar(lv);

	    AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
		AudioManager:PlaySfx(SFX_UI_BEST_SCORE);
	end,
	---------------------------------------------------------------------
	AccumulateMaxLifeAndEnergy = function(self)	
		--local widget = UIManager:GetWidget("AvatarStat", "LifeBar");
		local interGC = UIManager:GetWidgetComponent("AvatarStat", "LifeBar", "Interpolator");
		--interGC:AttachCallback(UpdateAvatarLife, UpdateAvatarLife, widget);
		local i1, i2 = self:GetOldAndNewMaxLife();
		interGC:ResetTarget(i1, i2, 30);

		--local widget2 = UIManager:GetWidget("AvatarStat", "EnergyBar");
		local interGC2 = UIManager:GetWidgetComponent("AvatarStat", "EnergyBar", "Interpolator");
		--interGC2:AttachCallback(UpdateAvatarEnergy, UpdateAvatarEnergy, widget2);
		local e1, e2 = BladeManager:GetOldAndNewMaxEnergy();
		interGC2:ResetTarget(e1, e2, 30);

		AudioManager:PlaySfx(SFX_UI_REVIVE);
	end,
	---------------------------------------------------------------------
	ShowLifeAndEnergy = function(self)
		local i1, i2 = self:GetOldAndNewMaxLife();
		--logp(i1, i2, "LIFE")
		UIManager:GetWidget("AvatarStat", "LifeBar"):SetMaxValue(i2);
		UIManager:GetWidget("AvatarStat", "LifeBar"):SetValue(i1);
		UIManager:GetWidget("AvatarStat", "LifeBarNumber"):SetMaxValue(i2);
		UIManager:GetWidget("AvatarStat", "LifeBarNumber"):SetValue(i1);

		local e1, e2 = BladeManager:GetOldAndNewMaxEnergy();
		--logp(e1, e2, "ENERGY")
		UIManager:GetWidget("AvatarStat", "EnergyBar"):SetMaxValue(e2);
		UIManager:GetWidget("AvatarStat", "EnergyBar"):SetValue(e1);
		UIManager:GetWidget("AvatarStat", "EnergyBarNumber"):SetMaxValue(e2);
		UIManager:GetWidget("AvatarStat", "EnergyBarNumber"):SetValue(e1);
	end,
	---------------------------------------------------------------------
	GetCurrentExp = function(self)
		return self.m_CurrentExp;
	end,
	---------------------------------------------------------------------
	GetMaxExp = function(self)
		return self.m_MaxExp;
	end,

	--===================================================================
	-- Scene
	--===================================================================

	---------------------------------------------------------------------
	ResetScene = function(self, sceneName)
		self.m_CurrentScene = self.m_GameScene[sceneName];
		assert(self.m_CurrentScene, "Fatal error at scene settings");		
		self:BuildDynamicScene();

		--=================================
		-- Castle		
		--=================================
		local castle = self.m_CurrentScene.castle;
		assert(castle);
		
		local posY = castle.y;
		if (self.m_IsAvatarBerserker) then
			posY = posY - 16;
		end

		self.m_Castle["Transform"]:SetTranslate(-75, posY);
		self.m_Castle["Motion"]:ResetTarget(castle.x, posY);
		
		self.m_Castle["Bound"]:SetSize(castle.width, castle.height);
		self.m_Castle["Bound"]:SetOffset(castle.offsetX, castle.offsetY);
		
		self.m_Castle["StateMachine"]:UnlockAllStates();
		self.m_Castle["StateMachine"]:ChangeState("initial");
---[[		
		self.m_Castle["Sprite"]:ResetAnimation(self.m_AvatarName .. "_move", true);
--]]
		-- Shaker
		self.m_SceneShaker["Shaker"]:AddObject(self.m_Backdrop);
		
		-- Castle effects	
		--self.m_SpeedEffect["SpriteGroup"]:SetOffset(1, self.m_CurrentScene.speedline.x, self.m_CurrentScene.speedline.y);
		self.m_SpeedEffect["SpriteGroup"]:SetOffset(1, 0, self.m_CurrentScene.speedline.y * APP_UNIT_Y);

		self.m_ReviveEffect["Transform"]:SetTranslate(castle.x + REVIVE_EFFECT_OFFSET[1], castle.y + REVIVE_EFFECT_OFFSET[2]);

		--=================================
		-- Decorator (optional)		
		--=================================
		if (self.m_CurrentScene.decorator) then
			local decoType = self.m_CurrentScene.decorator[1];
			local decoList = self.m_CurrentScene.decorator[2];
			local decoAttr = self.m_CurrentScene.decorator[3];

			for _, deco in ipairs(self.m_DecoratorPool:GetInactivePool()) do
				deco["Transform"]:SetRotateByDegree(0);
				deco["Motion"]:Reset();
				deco["Sprite"]:ResetAnimation(decoList[1], true);
			end

			if (decoAttr) then
		        self.m_DecoratorLauncher["Timer"]:ResetRandRange(decoAttr[1], decoAttr[2]);
				
				DECO_VELOCITY_MIN = decoAttr[3];
				DECO_VELOCITY_MAX = decoAttr[4];
			else
		        self.m_DecoratorLauncher["Timer"]:ResetRandRange(DECO_LAUNCHER_DURATION_MIN, DECO_LAUNCHER_DURATION_MAX);
				
				DECO_VELOCITY_MIN = DECO_VELOCITY_TEMPLATE_MIN;
				DECO_VELOCITY_MAX = DECO_VELOCITY_TEMPLATE_MAX;
			end

			DecoratorController = DecoratorManager[decoType];		
			DecoratorController["initial"](self.m_DecoratorLauncher);
		end

		--=====================================
		-- Field, mid range & long range
		--=====================================
		self.m_FieldSet = self.m_CurrentScene["field"];
		assert(self.m_FieldSet);
		
		self.m_MidRangeSet = self.m_CurrentScene["range_mid"];
		assert(self.m_MidRangeSet);
		
		self.m_LongRangeSet = self.m_CurrentScene["range_long"];
		assert(self.m_LongRangeSet);
		
		--=====================================
		-- Medal
		--=====================================
		self:ResetMedal();

--[[ @BackdropField
		local field = self.m_CurrentScene.field;
		self.m_BackdropField["Transform"]:SetTranslate(field.x[1], field.y[1]);
		self.m_BackdropField["Shape"]:SetSize(field.x[2] - field.x[1], field.y[2] - field.y[1]);

		local range = self.m_CurrentScene["range_mid"];
		self.m_BackdropMidRange["Transform"]:SetTranslate(range.x[1], range.y[1]);
		self.m_BackdropMidRange["Shape"]:SetSize(range.x[2] - range.x[1], range.y[2] - range.y[1]);

		local range = self.m_CurrentScene["range_long"];
		self.m_BackdropLongRange["Transform"]:SetTranslate(range.x[1], range.y[1]);
		self.m_BackdropLongRange["Shape"]:SetSize(range.x[2] - range.x[1], range.y[2] - range.y[1]);
--]]
	end,
	---------------------------------------------------------------------
	BuildLayer = function(self, target, layer)
		target["Transform"]:SetTranslate(layer[2], layer[3]);
		target["Sprite"]:ResetImage(1, layer[1]);
		target["Sprite"]:ResetImage(2, layer[1]);
		target["Sprite"]:SetIndieOffset(1, 0, 0);
		target["Sprite"]:SetIndieOffset(2, SCENE_LAYER_SIZE, 0);

		self.m_SceneShaker["Shaker"]:AddObject(target);
	end,
	---------------------------------------------------------------------
	BuildOverlayLayer = function(self)
		local obj = self.m_CurrentScene.layer_overlay;
		if (obj) then
			self.m_LayerOverlay:EnableRender(true);
			self.m_LayerOverlay["Sprite"]:ResetImage(obj[1]);
			self.m_LayerOverlay["Transform"]:SetTranslate(obj[2], obj[3]);
			self.m_LayerOverlay["Transform"]:SetScale(obj[4] or 1.0);	
			self.m_SceneShaker["Shaker"]:AddObject(self.m_LayerOverlay);
		else
			self.m_LayerOverlay:EnableRender(false);
		end
	end,
	---------------------------------------------------------------------
	BuildDynamicScene = function(self)
		--=====================================
		-- Backdrop, overlay & decorators
		--=====================================
		assert(self.m_CurrentScene.layer_pre);
		assert(self.m_CurrentScene.layer_mid);
		assert(self.m_CurrentScene.layer_post);
		
		self.m_Backdrop["Sprite"]:ResetImage(self.m_CurrentScene.backdrop);
		
		-- pre/mid/post layer
		self:BuildLayer(self.m_LayerPre, self.m_CurrentScene.layer_pre);
		self:BuildLayer(self.m_LayerMid, self.m_CurrentScene.layer_mid);
		self:BuildLayer(self.m_LayerPost, self.m_CurrentScene.layer_post);
		
		self:BuildOverlayLayer();
--[[
		-- overlay layers
		self.m_LayerOverlay = {};
		
		if (self.m_CurrentScene.layer_overlay) then
			for i, obj in ipairs(self.m_CurrentScene.layer_overlay) do
				self.m_LayerOverlay[i] = ObjectFactory:CreateGameObject("StaticBackdrop");
				self.m_LayerOverlay[i]["Sprite"]:ResetImage(obj[1]);
				self.m_LayerOverlay[i]["Transform"]:SetTranslate(obj[2], obj[3]);
				self.m_LayerOverlay[i]["Transform"]:SetScale(obj[4] or 1.0);
	
				self.m_SceneShaker["Shaker"]:AddObject(self.m_LayerOverlay[i]);
			end
		end
--]]		
	end,
	---------------------------------------------------------------------
	ShakeScene = function(self)
		self.m_SceneShaker["Transform"]:SetTranslate(0, 0);
		self.m_SceneShaker["Shaker"]:Shake();
	end,

	--===================================================================
	-- Map & Level
	--===================================================================

	---------------------------------------------------------------------
	HasMapPopupMessage = function(self, index)
		if (IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[self.m_GameDifficulty])[index]) then
			return false;
		end

		AudioManager:PlaySfx(SFX_OBJECT_BOOST);
		
		if (index == 1) then
			if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
				GameKit.ShowMessage("game_map_title", "game_map_first");
			else
				GameKit.ShowMessage("game_map_title", "game_shaodw_first");
			end
		else
			if (index >= 2 and index <= LEVEL_AVAIL_MAX and
				IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[self.m_GameDifficulty])[index - 1]) then
				local cost = MAP_UNLOCK_COST[self.m_GameDifficulty][index] or DEFAULT_MAP_UNLOCK_COST;
				if (MoneyManager:HasEnoughKoban(cost)) then
					self.m_MapIndex = index;
					local desc = string.format("%s%d%s", GameKit.GetLocalizedString("map_unlock_prefix"), cost, GameKit.GetLocalizedString("map_unlock_postfix"));
					ShowMessageChoices("map_unlock_title", desc, UnlockMapByKoban);
					return true;
				end
			end
			
			if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
				if (index == 2 or index == 3) then
					GameKit.ShowMessage("game_map_title", "game_map_middle");
				else
					GameKit.ShowMessage("game_map_title", "game_shadow_middle");
				end
			else  -- GAME_DIFF_SHADOW
				GameKit.ShowMessage("game_map_title", "game_shadow_middle");
			end
		end

		return true;
	end,
--[[	
	---------------------------------------------------------------------
	GotoNextStageAfterMoviePlayback = function(self)
		TutorialManager:EnableJustCompleted(false);
	
		if (self.m_NextStage == "PostEndlessMapToGame") then
		--log("Goto: PostEndlessMapToGame")
			UIManager:ToggleUI("Door");
			ScrollManager:Reset();
			ScrollManager:Complete();
			StageManager:ChangeStage("PreInGameDoor");
		else -- PostEndlessMapToScroll
		--log("Goto: PostEndlessMapToScroll")
			StageManager:ChangeStage("PreScrollSelect");
		end
	end,
--]]	
	---------------------------------------------------------------------
	EnterMap = function(self, index, isChallengeMode)
		-- Check availability
		if (not isChallengeMode) then
			if (self:HasMapPopupMessage(index)) then
				return;
			end
		end

		--log("EnterMap: "..index);
		self.m_MapIndex = index;
		self.m_IsChallengeMode = isChallengeMode;
		self.m_NextStage = "PostEndlessMapToScroll";
		
		if (self.m_MapIndex == 1 and self.m_GameDifficulty == GAME_DIFF_NORMAL) then			
			local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal");
			--if (rec[1]["Medal"] == 0) then		-- Special case for 1st level: skip scroll select stage
			if (rec[2] == nil) then
				self.m_NextStage = "PostEndlessMapToGame";
			end
		end
		
		self.m_MapTargetInterGC = UIManager:GetWidgetComponent("EndlessMap", "Map"..index, "Interpolator");
		IOManager:SetValue(IO_CAT_CONTENT, "Level", "LastEntered", index);

		self.m_DistanceCounterWidget:SetValue(0);
		
		UIManager:EnableWidget("InGame", "DistanceCounter", true);
		AudioManager:PlaySfx(SFX_UI_SWITCH_WEAPON_1);
		StageManager:ChangeStage("PostEndlessMap");
	end,
	---------------------------------------------------------------------
	EnterMapAgain = function(self)
		local nextStage = "ScrollSelectPerform";
		
		if (self.m_MapIndex == 1 and self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal");
			if (rec[1]["Medal"] == 0) then
				nextStage = "PreInGameDoor";
			end
		end

		StageManager:ChangeStage("PostGameStat", nextStage);
	end,
	---------------------------------------------------------------------
	EnterTutorialMap = function(self)
		self.m_MapIndex = 101;
		self.m_NextStage = "PostEndlessMapToTutorial";
		self.m_MapTargetInterGC = UIManager:GetWidgetComponent("EndlessMap", "Map0", "Interpolator");
		self.m_InTutorialStage = true;
		IOManager:SetValue(IO_CAT_CONTENT, "Level", "LastEntered", 0);
		
		UIManager:EnableWidget("InGame", "DistanceCounter", false);
		ScrollManager:EnterTutorial();
		AudioManager:PlaySfx(SFX_UI_SWITCH_WEAPON_1);

		self.m_TargetMovie = "jade.m4v";
		self.m_TargetMovieCallback = OnOPMoviePlaybackCompleted;
		StageManager:ChangeStage("PostEndlessMapToMovie");
	end,
	---------------------------------------------------------------------
	EnterDifficulty = function(self)
--[[ @ShadowUnlock	
		-- Check availability
		local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Shadow");
		if (not rec[1]) then
			AudioManager:PlaySfx(SFX_UI_BUTTON_2);
			GameKit.ShowMessage("game_map_title", "game_shadow_middle")
			return;
		end
--]]
		-- Must do before ChangeStage()
		self.m_MapTargetInterGC = UIManager:GetWidgetComponent("EndlessMap", "GameDifficulty", "Interpolator");

		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			self.m_TargetMovie = "boss.m4v";
			self.m_TargetMovieCallback = OnBossMoviePlaybackCompleted;
			StageManager:ChangeStage("PostEndlessMapToMovie");
		else
			self.m_NextStage = "GameDifficulty";
			StageManager:ChangeStage("PostEndlessMap");
		end

		AudioManager:PlaySfx(SFX_UI_SWITCH_WEAPON_1);
	end,
	---------------------------------------------------------------------
	EnterNextMap = function(self)
		self.m_MapIndex = self.m_MapIndex + 1;
		assert(self.m_GameLevel[self.m_MapIndex], "EnterNextMap error");
	end,
	---------------------------------------------------------------------
	GetNextStage = function(self)
		return self.m_NextStage;
	end,
	---------------------------------------------------------------------
	GetTargetMovie = function(self)
		return self.m_TargetMovie, self.m_TargetMovieCallback;
	end,
	---------------------------------------------------------------------
	GetMapIndex = function(self)
		return self.m_MapIndex;
	end,
	---------------------------------------------------------------------
	GetMapName = function(self)
	    local name = "Map" .. self.m_MapIndex;
		if (self.m_GameDifficulty == GAME_DIFF_SHADOW) then
		    name = name .. "_shadow";
		end
		return name;
	end,
	---------------------------------------------------------------------
	GetMapTargetInterGC = function(self)
		return self.m_MapTargetInterGC;
	end,
	---------------------------------------------------------------------
	RepositionMap = function(self, index)
		if (index) then
			IOManager:SetValue(IO_CAT_CONTENT, "Level", "LastEntered", index);
		else
			index = IOManager:GetValue(IO_CAT_CONTENT, "Level", "LastEntered");
		end
		
		assert(index >= 0 and index <= LEVEL_DIFFICULTY_INDEX);
		
		--log("!!!! RepositionMap !!!! => "..index + 1)
		UIManager:CenterSwipeObjects("EndlessMap", index + 1);
	
		if (index == LEVEL_DIFFICULTY_INDEX) then
			UIManager:EnableWidget("EndlessMap", "Title", false);
		else
			UIManager:GetWidget("EndlessMap", "Title"):SetImage("ui_map_title".. index);
			UIManager:EnableWidget("EndlessMap", "Title", true);
		end
		
		self:ResetMapButtons(index);
	end,
	---------------------------------------------------------------------
	RepositionMaxAvailableMap = function(self)
		self:RepositionMap(self:GetMaxAvailableLevelIndex());
	end,	
	---------------------------------------------------------------------
	Start = function(self)
		assert(self.m_MapIndex);
		assert(self.m_GameLevel[self.m_MapIndex]);
		
		local map = self.m_GameLevel[self.m_MapIndex];
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			self.m_CurrentLevel = map[1];	-- Day scene
			self.LaunchEnemy = self.LaunchEnemyNormalMode;
			self.EnterBossMode = self.EnterBossMode_Normal;
		else
			self.m_CurrentLevel = map[2];	-- Night scene
			self.LaunchEnemy = self.LaunchEnemyShadowMode;
			self.EnterBossMode = self.EnterBossMode_Shadow;
		end

		self.m_EnemyWaveCount = 0;
		self.m_EnemyDiffLevel = 0;
		self.m_EnemyMaxDiffLevel = 0;

		assert(self.m_CurrentLevel);
		assert(self.m_CurrentLevel[LEVEL_SCENE_NAME]);
		assert(self.m_CurrentLevel[LEVEL_ENEMY_LAUNCHER]);
		assert(self.m_CurrentLevel[LEVEL_ENEMY_EVENTS]);
		assert(self.m_CurrentLevel[LEVEL_ENEMY_RANDSET]);
		assert(self.m_CurrentLevel[LEVEL_PRELOAD_TEXTURES]);

		self.m_LevelEvent = self.m_CurrentLevel[LEVEL_ENEMY_EVENTS];		

		self:BuildRandsetEnemyPool(self.m_CurrentLevel[LEVEL_ENEMY_RANDSET]);

		self:ResetLifeBar();

		self:ResetScene(self.m_CurrentLevel[LEVEL_SCENE_NAME]);

		for _, texture in ipairs(self.m_CurrentLevel[LEVEL_PRELOAD_TEXTURES]) do
			PreloadTexture(texture);
		end

		self.m_Castle["Timer"]:EnableUpdate(true);
		self.m_CastleScrollClock["Timer"]:EnableUpdate(true);
		self.m_EnemyLauncher["Timer"]:EnableUpdate(true);
		self.m_EnemyWaveClock["Timer"]:EnableUpdate(true);
		self.m_DecoratorLauncher["Timer"]:EnableUpdate(true);
		
		if (self.m_IsChallengeMode) then
			local currentTime = math.floor(GameKit.GetCurrentSystemTime());
			IOManager:SetValue(IO_CAT_CONTENT, "ChallengeMode", "Duration", currentTime, true);
			--log("Challenge Time RESET: "..currentTime);
			GameKit.LogEventWithParameter("GameMode", "Mode", "Challenge", false);
		else
			GameKit.LogEventWithParameter("GameMode", "Mode", "Normal", false);
		end
		
		AudioManager:CreateBgmList(GAME_LEVEL_BGM[self.m_MapIndex]);
	    AudioManager:PlayLevelStartBgm(self.m_MapIndex);
	end,
	---------------------------------------------------------------------
	Stop = function(self)
		AudioManager:DestroyBgmList(GAME_LEVEL_BGM[self.m_MapIndex]);

		self.m_DecoratorLauncher["StateMachine"]:ChangeState("inactive");		

		if (self.m_InTutorialStage) then
			self.m_InTutorialStage = false;
			TutorialManager:Exit();
		end
	end,

	--===================================================================
	-- Game Difficulty
	--===================================================================

	---------------------------------------------------------------------
	ToggleDifficulty = function(self)
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
		-- Now is on NORMAL mode, switch to SHADOW mode
			self.m_GameDifficulty = GAME_DIFF_SHADOW;
			UIManager:EnableWidget("EndlessMap", "Challenge", true);
		else
		-- Now is on SHADOW mode, switch to NORMAL mode
			self.m_GameDifficulty = GAME_DIFF_NORMAL;
			UIManager:EnableWidget("EndlessMap", "Challenge", false);
		end
		
		EnemyManager:ToggleDifficulty(self.m_GameDifficulty);
		IOManager:SetValue(IO_CAT_CONTENT, "Level", "Difficulty", self.m_GameDifficulty, true);
		--log("GAME DIFF : "..GAME_DIFFICULTY[self.m_GameDifficulty])
	end,
	---------------------------------------------------------------------
	GetGameDifficulty = function(self)
		return self.m_GameDifficulty;
	end,
	---------------------------------------------------------------------
	IsShadowDifficulty = function(self)
		return (self.m_GameDifficulty == GAME_DIFF_SHADOW);
	end,
	---------------------------------------------------------------------
	GetScoreFactors = function(self)
		assert(GAME_SCORE_FACTOR[self.m_GameDifficulty]);
		assert(GAME_SCORE_FACTOR[self.m_GameDifficulty][self.m_MapIndex]);
		return GAME_SCORE_FACTOR[self.m_GameDifficulty][self.m_MapIndex];
	end,
	---------------------------------------------------------------------
	GetLevelRecord = function(self)
		return IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[self.m_GameDifficulty]);
	end,
	---------------------------------------------------------------------
	GetLevelDataSet = function(self)
		local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[self.m_GameDifficulty]);
		return rec[self.m_MapIndex];
	end,
	---------------------------------------------------------------------
	GetMaxAvailableLevelIndex = function(self)
		local levelSet = IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[self.m_GameDifficulty]);
		for i = LEVEL_AVAIL_MAX, 1, -1 do
			if (levelSet[i]) then
				return i;
			end
		end
	end,
	---------------------------------------------------------------------
	GetMaxUnlockedLevel = function(self)
		local shadowSet = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Shadow");
		for i = LEVEL_AVAIL_MAX, 1, -1 do
			if (shadowSet[i]) then
				return "Map"..i.."_shadow", i;
			end
		end

		local normalSet = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal");
		for i = LEVEL_AVAIL_MAX, 1, -1 do
			if (normalSet[i]) then
				return "Map"..i, i;
			end
		end
		
		return "Map_0", 0;
	end,
	---------------------------------------------------------------------
	GetMaxAvailableTreasure = function(self, treasureType)
		local _, index = self:GetMaxUnlockedLevel();
		local range;
		
		if (treasureType == "gold") then
		-- Level 1 (500m) Treasure
			range = TREASURE_KOBAN_RANGE[self.m_GameDifficulty][index][1];
			--log("GetMaxAvailableTreasure: [gold] "..range[1].." ~ "..range[2])
		else
			range = TREASURE_COIN_RANGE[self.m_GameDifficulty][index][1];
			--log("GetMaxAvailableTreasure: [coin] "..range[1].." ~ "..range[2])
		end
		
		local result = math.random(range[1], range[2]);
		--log("   => "..result)
		
		return result;
	end,
	---------------------------------------------------------------------
	MeetFeedbackCondition = function(self)
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			if (self.m_MapIndex >= 4) then
				return true;
			end
		elseif (self.m_GameDifficulty == GAME_DIFF_SHADOW) then
			return true;
		end
		
		return false;
	end,

	--===================================================================
	-- Lock/Unlock
	--===================================================================

	---------------------------------------------------------------------
	LockAllLevels = function(self)
		for i = 1, LEVEL_AVAIL_MAX do
			local mapIndex = "Map"..i;
			UIManager:GetWidget("EndlessMap", mapIndex):Enable(false);
			UIManager:GetWidgetComponent("EndlessMap", mapIndex, "Sprite"):EnableRender(UM_LOCK, true);
		end
--[[ @ShadowUnlock
		UIManager:GetWidget("EndlessMap", "GameDifficulty"):Enable(false);
		UIManager:GetWidgetComponent("EndlessMap", "GameDifficulty", "Sprite"):EnableRender(UM_LOCK, true);
--]]		
		IOManager:Save();
	end,
	---------------------------------------------------------------------
	UnlockAllLevels = function(self)
		local v1 = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal");
		local v2 = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Shadow");
		
		for i = 1, LEVEL_AVAIL_MAX do
			v1[i] = { Distance = 1500, Coin = 0, Score = 50000, Medal = 2, };
			v2[i] = { Distance = 3000, Coin = 0, Score = 100000, Medal = 3, };
			self:UnlockLevel(i);
		end

		IOManager:SetValue(IO_CAT_CONTENT, "Tutorial", "Completed", true);
--[[ @ShadowUnlock
		self:UnlockGameDiffculty(true);
--]]
		IOManager:Save();
	end,
--[[ @ShadowUnlock	
	---------------------------------------------------------------------
	UnlockGameDiffculty = function(self, enable)		
		UIManager:GetWidgetComponent("EndlessMap", "GameDifficulty", "Sprite"):EnableRender(UM_LOCK, not enable);
	end,
--]]	
	---------------------------------------------------------------------
	UnlockLevel = function(self, level)
		if (level >= 1 and level <= LEVEL_AVAIL_MAX) then
			local mapIndex = "Map"..level;
			UIManager:GetWidget("EndlessMap", mapIndex):Enable(true);
			UIManager:GetWidgetComponent("EndlessMap", mapIndex, "Sprite"):EnableRender(UM_LOCK, false);
			--UIManager:GetWidgetComponent("EndlessMap", mapIndex, "Sprite"):EnableRender(UM_STARBK, true);		
			--log("UnlockLevel : # "..level)
		end
	end,
	---------------------------------------------------------------------
	UnlockFirstLevel = function(self)
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			UIManager:GetWidget("EndlessMap", "Map1"):Enable(true);
			UIManager:GetWidgetComponent("EndlessMap", "Map1", "Sprite"):EnableRender(UM_LOCK, false);
		end
	end,
	---------------------------------------------------------------------
	UnlockNextLevel = function(self)		
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL and self.m_MedalLevel < 2) then
			return;
		end

		if (self.m_GameDifficulty == GAME_DIFF_SHADOW and self.m_MedalLevel < 3) then
			return;
		end

		if (self.m_MapIndex == LEVEL_AVAIL_MAX) then
			if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			-- Special case: Unlock Shadow mode
				local recShadow = IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[GAME_DIFF_SHADOW]);
				if (recShadow[1] == nil) then
					recShadow[1] = { Distance = 0, Coin = 0, Score = 0, Medal = 0, };
					IOManager:Save();
					self.m_WasNewLevelUnlocked = true;
--[[ @ShadowUnlock
					--UIManager:GetWidget("EndlessMap", "GameDifficulty"):Enable(true);
					UIManager:GetWidgetComponent("EndlessMap", "GameDifficulty", "Sprite"):EnableRender(UM_LOCK, false);
--]]					
					self:RepositionMap(LEVEL_DIFFICULTY_INDEX);  -- Reposition to 'Shadow Mode'
					--log("Unlock Shadow Level # 1")
				end
			--	return;
			--elseif (self.m_GameDifficulty == GAME_DIFF_SHADOW) then
			--	return;
			end
			return;
		end

		local level = self.m_MapIndex + 1;
		if (level <= 1 or level > LEVEL_AVAIL_MAX) then
			return;
		end

		local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[self.m_GameDifficulty]);
		if (not rec[level]) then
			rec[level] = { Distance = 0, Coin = 0, Score = 0, Medal = 0, };
			self.m_WasNewLevelUnlocked = true;

			IOManager:Save();
			SaveToCloud();			

			UIManager:GetWidgetComponent("EndlessMap", "Map"..level, "Sprite"):EnableRender(UM_LOCK, false);
			self:RepositionMap(level);
		end
	end,
	---------------------------------------------------------------------	
	UnlockMapByKoban = function(self)
		local level = self.m_MapIndex;
		local cost = MAP_UNLOCK_COST[self.m_GameDifficulty][level];
		--log("UnlockMapByKoban @ Map #"..level.." / cost: "..cost);
		
		if (MoneyManager:HasEnoughKoban(cost)) then
			local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[self.m_GameDifficulty]);		
			rec[level] = { Distance = 0, Coin = 0, Score = 0, Medal = 0, };
			
			MoneyManager:ModifyKoban(-cost, true);
			UIManager:GetWidgetComponent("EndlessMap", "Map"..level, "Sprite"):EnableRender(UM_LOCK, false);
			ShopManager:ShowShopIcon();
		end		
	end,
	---------------------------------------------------------------------
	InitializeMapButtons = function(self)
		for i = 1, LEVEL_MAX do
			local mapIndex = "Map"..i;
			UIManager:GetWidget("EndlessMap", mapIndex):Enable(false);
			UIManager:GetWidgetComponent("EndlessMap", mapIndex, "Sprite"):EnableRender(UM_LOCK, true);
		end

		for index, value in ipairs(self:GetLevelRecord()) do
			self:UnlockLevel(index);
		end
--[[ @ShadowUnlock
		local hasUnlockedShadowLevel = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Shadow")[1];
		self:UnlockGameDiffculty(hasUnlockedShadowLevel);
--]]		
	end,
	---------------------------------------------------------------------
	ResetMapButtons = function(self, index)
		if (index == LEVEL_DIFFICULTY_INDEX) then
--[[ @ShadowUnlock
			UIManager:GetWidget("EndlessMap", "GameDifficulty"):Enable(true);
--]]
			for i = 0, LEVEL_MAX do
				UIManager:GetWidget("EndlessMap", "Map"..i):Enable(false);
			end
		else
--[[ @ShadowUnlock
			UIManager:GetWidget("EndlessMap", "GameDifficulty"):Enable(false);
--]]
			for i = 0, LEVEL_MAX do
				if (i == index) then
					UIManager:GetWidget("EndlessMap", "Map"..i):Enable(true);
					--log("ResetMapButtons OK: Map"..index);
				else
					UIManager:GetWidget("EndlessMap", "Map"..i):Enable(false);
				end
			end
		end
	end,
	---------------------------------------------------------------------
	UpdateAvatarAchievement = function(self, lv)
		if (ACH_AVATAR_PROGRESS[self.m_AvatarIndex]) then
			UpdateAchievement(ACH_AVATAR_PROGRESS[self.m_AvatarIndex], lv, true);
		end
	end,
	---------------------------------------------------------------------
	UpdateMapAchievement = function(self, distance)
		local subjects = ACH_MAP_PROGRESS[self.m_GameDifficulty][self.m_MapIndex];
		if (subjects) then
			for _, id in ipairs(subjects) do
				UpdateAchievement(id, distance, true);
			end
		end
		
		if (self.m_GameDifficulty == GAME_DIFF_SHADOW) then  -- Special achievement or SHADOW MODE
			UpdateAchievement(ACH_SHADOW_GUARDIAN, distance);
		end
		
		local ach = ACH_LONG_DISTANCE[self.m_GameDifficulty][self.m_MapIndex];
		if (ach and HasAchievementDone(ach, distance)) then		
			local value = GameDataManager:GetData("ReviveCount") .. "r";
			local key = "Map" .. self.m_MapIndex;
			if (LevelManager:IsShadowDifficulty()) then
				key = key .. "_shadow";
			end

			GameKit.LogEventWithParameter("DistanceAch", value, key, false);
			--log("DISTANCE ACH COMPLETED : ".. key .. " => " .. value)
		end
	end,
	---------------------------------------------------------------------
	UpdateAchievementAndStatus = function(self, distance)
		self:UpdateMapAchievement(distance);
		self:CheckJadeStatus();
		self:CheckScrollStatus();		
	end,
	---------------------------------------------------------------------
	WasNewLevelUnlocked = function(self)
		--log("self.m_WasNewLevelUnlocked => "..tostring(self.m_WasNewLevelUnlocked))
		return self.m_WasNewLevelUnlocked;
	end,

	--===================================================================
	-- Jade
	--===================================================================

	---------------------------------------------------------------------
	CheckJadeStatus = function(self)
		local jade = AVATAR_LV_UNLOCK_JADE[ self:GetAvatarLevel() ];	
		if (jade) then
			if (IOManager:GetValue(IO_CAT_HACK, "Jade", jade) == nil) then
				--log("Unlock Jade : " .. JADE_DATA_POOL[jade][JE_ID])
				IOManager:SetValue(IO_CAT_HACK, "Jade", jade, 1);
				IOManager:SetValue(IO_CAT_HACK, "Jade", "Equip", jade);
				IOManager:SetValue(IO_CAT_HACK, "Jade", "Unlock", jade);
				--UIManager:GetWidget("JadeUnlock", "Icon"):SetImage(JADE_DATA_POOL[jade][JE_SHOPICON]);            
			end
		end
	end,
	---------------------------------------------------------------------
	GetUnlockedJade = function(self)
		return IOManager:GetValue(IO_CAT_HACK, "Jade", "Unlock");		
	end,
	---------------------------------------------------------------------
	ResetUnlockedJade = function(self)
		local jade = IOManager:GetValue(IO_CAT_HACK, "Jade", "Unlock");
		IOManager:SetValue(IO_CAT_HACK, "Jade", "Unlock", nil);
		return jade;
	end,

	--===================================================================
	-- Scroll
	--===================================================================

	---------------------------------------------------------------------
	CheckScrollStatus = function(self)
		local scroll = AVATAR_LV_UNLOCK_SCROLL[ LevelManager:GetAvatarLevel() ];
		if (scroll) then
			if (IOManager:GetValue(IO_CAT_HACK, "Scroll", scroll) == nil) then
				IOManager:SetValue(IO_CAT_HACK, "Scroll", scroll, 1);
				IOManager:SetValue(IO_CAT_HACK, "Scroll", "Unlock", scroll);
				--UIManager:GetWidget("ScrollUnlock", "Icon"):SetImage(SCROLL_DATA[scroll][SCROLL_T_ICON]);
			end
		end
	end,
	---------------------------------------------------------------------
	GetUnlockedScroll = function(self)
		return IOManager:GetValue(IO_CAT_HACK, "Scroll", "Unlock");
	end,
	---------------------------------------------------------------------
	ResetUnlockedScroll = function(self)
		local scroll = IOManager:GetValue(IO_CAT_HACK, "Scroll", "Unlock");
		IOManager:SetValue(IO_CAT_HACK, "Scroll", "Unlock", nil);
		return scroll;
	end,

	--===================================================================
	-- Launcher
	--===================================================================

	---------------------------------------------------------------------
	StartLauncher = function(self)
		self.m_EnemyMaxDiffLevel = #self.m_CurrentLevel[LEVEL_ENEMY_LAUNCHER];
		--log("MAX DIFF LV : "..self.m_EnemyMaxDiffLevel)
		
		if (self.m_CurrentScene.decorator) then
			self.m_DecoratorLauncher["StateMachine"]:ChangeState("active");
		end
		
		self.m_InnocentPool = RandDeck({ Innocent_None });

		self:ActivateNextDifficulty();

		self:ActivateNextWave();

		if (self.m_IsOnDistanceBoosting) then
			self.m_EnemyLauncher["StateMachine"]:ChangeState("inactive");
		end

		self.m_BossModeChance = IOManager:GetRecord(IO_CAT_CONTENT, "BossChance");

		--log("Boss Chance [START]: "..self.m_BossModeChance.." %")
		--UIManager:GetWidget("InGame", "BossChance"):SetValue(self.m_BossModeChance .. " %");
	end,
	---------------------------------------------------------------------
	BuildRandsetEnemyPool = function(self, pool)
		assert(pool);
		local t = {};
		
		for _, k in ipairs(pool) do
			for i = 1, k[2] do
				table.insert(t, k[1]);
			end
		end
		--log("BuildRandsetEnemyPool: # " .. #t);
		
		self.m_RandsetEnemyPool = RandDeck(t);
	end,
	---------------------------------------------------------------------
	ActivateNextDifficulty = function(self)
		-- Clear modules pool
		for i = 1, #self.m_EnemyModulesPool do
			table.remove(self.m_EnemyModulesPool);
		end

		-- Update modules pool:
		--
		--    0m      500m    1000m   1500m   2000m   2500m   3000m
		--    |       |       |       |       |       |       |
		--    ------------------------------------------------------->
		-- Lv     1     2       3       4       5       6       7
		-- Diff  [1]   [2/3]   [3/4]   [4/5]   [5/6]   [6/7]   [3~8]
		-- Min       1min    2min    3min    4min    5min    6min
  		-- Totally 8 difficulty levels
		--
		if (self.m_EnemyDiffLevel < self.m_EnemyMaxDiffLevel - 1) then
			self.m_EnemyDiffLevel = self.m_EnemyDiffLevel + 1;
		end

		if (self.m_EnemyDiffLevel < self.m_EnemyMaxDiffLevel - 1) then
		-- Difficulty Lv 1~6
			for _, mod in ipairs(self.m_CurrentLevel[LEVEL_ENEMY_LAUNCHER][self.m_EnemyDiffLevel]) do
				table.insert(self.m_EnemyModulesPool, mod);
			end
			--log(" pool insert diff # "..self.m_EnemyDiffLevel)

			if (self.m_EnemyDiffLevel > 1) then
				--log(" pool insert diff # "..self.m_EnemyDiffLevel + 1)
				for _, mod in ipairs(self.m_CurrentLevel[LEVEL_ENEMY_LAUNCHER][self.m_EnemyDiffLevel + 1]) do
					table.insert(self.m_EnemyModulesPool, mod);
				end
			end		
		else  --if (self.m_EnemyDiffLevel == self.m_EnemyMaxDiffLevel - 1) then
		-- Difficulty Lv 7, including all modules from 3rd to 8th
			for i = 3, self.m_EnemyMaxDiffLevel do
				--log(" pool insert diff # "..i)
				for _, mod in ipairs(self.m_CurrentLevel[LEVEL_ENEMY_LAUNCHER][i]) do
					table.insert(self.m_EnemyModulesPool, mod);
				end
			end
		end
--[[ @DEBUG		
		log("ActivateNextDifficulty @ diff # "..self.m_EnemyDiffLevel.." / pool # "..#self.m_EnemyModulesPool)
--]]		
	end,
	---------------------------------------------------------------------
	ActivateBossDifficulty = function(self)
		-- Clear modules pool
		for i = 1, #self.m_EnemyModulesPool do
			table.remove(self.m_EnemyModulesPool);
		end		
	end,
	---------------------------------------------------------------------
	ActivateNextWave = function(self)
		if (self.m_EnemyWaveCount >= ENEMY_WAVE_COUNT_MAX) then
			self.m_EnemyWaveCount = 0;

			if (self:EnterBossMode()) then
				--log("...Entering Boss Mode...")
				self:ActivateBossDifficulty();
				return;
			else
				--log("...Normal Wave...")
				self:ActivateNextDifficulty();
			end
		end

		self.m_EnemyWaveCount = self.m_EnemyWaveCount + 1;
		self.m_EnemyWaveClock["Timer"]:Reset(ENEMY_WAVE_DURATION);
		--log("   Wave @ "..self.m_EnemyWaveCount)
				
		-- Determine enemy module
		self.m_EnemySubWave = 0;
---[[ @RELEASE
		self.m_EnemyModule = RandElement(self.m_EnemyModulesPool);
--]]
--[[ @DEBUG				
		local i = math.random(1, #self.m_EnemyModulesPool);
		self.m_EnemyModule = self.m_EnemyModulesPool[i];
		
		if (self.m_EnemyDiffLevel == self.m_EnemyMaxDiffLevel - 1) then
			UIManager:GetWidget("InGame", "Wave"):SetValue("MAX / m"..i)
		elseif (self.m_EnemyDiffLevel == 1) then
			UIManager:GetWidget("InGame", "Wave"):SetValue("Lv1 / m"..i)
		else
			UIManager:GetWidget("InGame", "Wave"):SetValue("Lv"..self.m_EnemyDiffLevel.."-"..(self.m_EnemyDiffLevel+1).." / m"..i)
		end
--]]		
		self:ActivateNextSubWave();
	end,
	---------------------------------------------------------------------
	ActivateNextSubWave = function(self)
		self.m_EnemySubWave = self.m_EnemySubWave + 1;
		--log("         Sub # "..self.m_EnemySubWave)
		
		if (self.m_EnemySubWave <= #self.m_EnemyModule) then
			local duration = self.m_EnemyModule[self.m_EnemySubWave][1];
			
			if (self.m_EnemySubWave > 1) then
				-- Subtract previous duration to get the duration for current wave
				duration = duration - self.m_EnemyModule[self.m_EnemySubWave - 1][1];
			end

			self.m_EnemyLauncher["StateMachine"]:ChangeState("active_module", duration * 1000);
		else
			self.m_EnemyLauncher["StateMachine"]:ChangeState("inactive");
		end
	end,
	---------------------------------------------------------------------
	LaunchEnemyNormalMode = function(self)
		-- Normal enemy
		for _, enemyType in ipairs(self.m_EnemyModule[self.m_EnemySubWave][2]) do
			EnemyManager:LaunchEnemy(enemyType);
		end

		-- Innocent people
		EnemyManager:LaunchEnemy(self.m_InnocentPool());

		-- Randset Enemy
		if (self.m_ShadowEnemyClock["Timer"]:IsOver()) then
			if (math.random(1, 100) <= self.m_RandsetEnemyChance) then
				EnemyManager:LaunchEnemy(self.m_RandsetEnemyPool());
				self.m_ShadowEnemyClock["Timer"]:Reset();
			end
		end

		self:ActivateNextSubWave();
	end,
	---------------------------------------------------------------------
	LaunchEnemyShadowMode = function(self)
		-- Normal enemy
		for _, enemyType in ipairs(self.m_EnemyModule[self.m_EnemySubWave][2]) do
			EnemyManager:LaunchEnemy(enemyType);
		end

		-- Innocent people
		EnemyManager:LaunchEnemy(self.m_InnocentPool());

		if (self.m_ShadowEnemyClock["Timer"]:IsOver()) then
			if (math.random(1, 100) <= self.m_RandsetEnemyChance) then
			-- Randset enemy
				EnemyManager:LaunchEnemy(self.m_RandsetEnemyPool());
				self.m_ShadowEnemyClock["Timer"]:Reset();
			elseif (math.random(1, 100) <= self.m_ShadowEnemyChance) then
			-- Shadow enemy
				EnemyManager:LaunchEnemy(Enemy_ObjectPaperman);
				self.m_ShadowEnemyClock["Timer"]:Reset();
			end
		end

		self:ActivateNextSubWave();
	end,
	---------------------------------------------------------------------
	LaunchEnemyBossMode = function(self)
		for i = 1, 3 do
			if (math.random(1, 100) <= self.m_RandsetEnemyChance) then
				EnemyManager:LaunchEnemy(self.m_RandsetEnemyPool());
			end
		end
		
		if (self.m_ShadowEnemyClock["Timer"]:IsOver()) then
			if (math.random(1, 100) <= self.m_ShadowEnemyChance) then
				EnemyManager:LaunchEnemy(Enemy_ObjectPaperman);
				self.m_ShadowEnemyClock["Timer"]:Reset();
			end
		end
	end,
	---------------------------------------------------------------------
	LaunchInnocent = function(self)
		EnemyManager:LaunchEnemy(self.m_InnocentPool());
	end,

	--===================================================================
	-- @Boss
	--===================================================================

	---------------------------------------------------------------------
	EnterBossMode_Normal = function(self)
		return false;
	end,
	---------------------------------------------------------------------
	EnterBossMode_Shadow = function(self)
		assert(self.m_CurrentLevel[LEVEL_BOSS_DATA], "EnterBossMode error");
		
		--if (self.m_IsOnDistanceBoosting) then
---[[ @Challenge
		if (self.m_IsOnDistanceBoosting or self.m_IsChallengeMode) then
--]]		
			return false;
		end
	
		--log("Boss chance: "..self.m_BossModeChance)
		if ((math.random(1, 100) <= self.m_BossModeChance) and (self.m_CurrentDistance > 1999)) then
			--log("==================BOSS MODE==================")
			IOManager:SetRecord(IO_CAT_CONTENT, "BossChance", 0);
			self.m_BossModeChance = BOSS_START_CHANCE;
			self.m_IsOnBossMode = true;

			self.m_EnemyWaveClock["Timer"]:Reset(3000);
			self.m_EnemyWaveClock["Timer"]:EnableUpdate(false);
			self.m_EnemyLauncher["StateMachine"]:ChangeState("inactive");
			self.m_BossController["StateMachine"]:ChangeState("enter");
			
			GameDataManager:SetData("ReviveCountBossMode", 0);
			EnemyManager:SetEnemyInBossMode(true);
			return true;
		else
			self.m_BossModeChance = self.m_BossModeChance + (BOSS_MOD_CHANCE[self.m_MapIndex] or 1);
			IOManager:SetRecord(IO_CAT_CONTENT, "BossChance", self.m_BossModeChance);
			--log("... FAILED => boss chace: "..self.m_BossModeChance)
--[[ @DEBUG
			UIManager:GetWidget("InGame", "BossChance"):SetValue(self.m_BossModeChance .. " %");
--]]
			return false;
		end
	end,
	---------------------------------------------------------------------
	ReloadBossTexture = function(self)
		PreloadTexture(self.m_CurrentLevel[LEVEL_BOSS_DATA][BOSS_TEXTURE]);
	end,
	---------------------------------------------------------------------
	ExitBossMode = function(self, boss)
		--log("\\\\\ ExitBossMode /////")
		self.m_EnemyLauncher["StateMachine"]:ChangeState("inactive");
		self.m_BossController["StateMachine"]:ChangeState("wait", "exit");
	end,
	---------------------------------------------------------------------
	IsOnBossMode = function(self)
		return self.m_IsOnBossMode;
	end,
	---------------------------------------------------------------------
	RecoverFromBossMode = function(self)		
		g_UpdateManager:RemoveObject(self.m_BossController, ENEMY_GROUP);

		AudioManager:PlayLevelLoopBgm(self.m_MapIndex);
		AudioManager:DestroyBgmList(GAME_BOSS_BGM);
		
		UIManager:SetUITranslate("BossLifebar", 0, 0);
		UIManager:ToggleUI("BossLifebar");		
		UIManager:EnableWidget("InGame", "DistanceCounter", true);
		
		self.m_EnemyWaveCount = ENEMY_WAVE_COUNT_MAX;
		self.m_BossModeChance = BOSS_START_CHANCE;
		IOManager:SetRecord(IO_CAT_CONTENT, "BossChance", 0);
		IOManager:Save();

		self:EnableDistanceCounter(true);
		self.m_EnemyWaveClock["Timer"]:EnableUpdate(true);
		self.m_EnemyLauncher["StateMachine"]:ChangeState("active_module", 3000); --1000);
		self:ActivateNextWave();

		EnemyManager:SetEnemyInBossMode(false);
		UnloadTexture(self.m_CurrentLevel[LEVEL_BOSS_DATA][BOSS_TEXTURE]);
		--g_TaskManager:Clear();
		
		self.m_BossHuntCount = self.m_BossHuntCount + 1;
		self.m_IsOnBossMode = false;
	end,
	---------------------------------------------------------------------
	ResetFromBossMode = function(self)
		if (self.m_IsOnBossMode) then
		--log("ResetFromBossMode start")
			self.m_IsOnBossMode = false;
			self.m_BossController["StateMachine"]:ChangeState("inactive");
			
			g_UpdateManager:RemoveObject(self.m_BossController, ENEMY_GROUP);

			AudioManager:PlayLevelLoopBgm(self.m_MapIndex);
			AudioManager:DestroyBgmList(GAME_BOSS_BGM);

			UIManager:SetUITranslate("BossLifebar", 0, 0);
			UIManager:ToggleUI("BossLifebar");		
			UIManager:EnableWidget("InGame", "DistanceCounter", true);			

			EnemyManager:SetEnemyInBossMode(false);
			
			g_TaskManager:Clear();
		end
	end,
	---------------------------------------------------------------------
	GetBossScoreFactor = function(self)
		local result = 1;
		if (self.m_BossHuntCount ~= 0) then
			for i = 1, self.m_BossHuntCount do
				result = result * GAME_BOSS_FACTOR;
			end
		end
		
		return result;
	end,
	---------------------------------------------------------------------
	GetBossMaxLife = function(self)
		local life = self.m_CurrentLevel[LEVEL_BOSS_DATA][BOSS_TEMPLATE][ENEMY_TEMPLATE_LIFE];
		return math.ceil(life * ENEMY_SHADOW_LIFE);
	end,
	---------------------------------------------------------------------
	LaunchBoss = function(self)
		AudioManager:PlayBgm(BGM_BOSS_ON);
		
		EnemyManager:LaunchEnemy(self.m_CurrentLevel[LEVEL_BOSS_DATA][BOSS_TEMPLATE]);
		
		self.m_EnemyLauncher["StateMachine"]:ChangeState("active_boss", 2000);
		--log("LaunchBoss [Rand Enemy %] => " .. self.m_RandsetEnemyChance)
	end,
	---------------------------------------------------------------------
	LaunchBossShadowNinjaMinion = function(self, go)		
		local minionPool = {};
		for i = 1, 3 do
			if (math.random(1, 100) > 50) then
				table.insert(minionPool, BossMinion_MirrorNinja_Melee);
			else
				table.insert(minionPool, BossMinion_MirrorNinja_Ranged);
			end
		end
		
		local offsetX = 90;
		local offsetY = 45;
		local x, y = self:GetCenterPos(go);
		x = x - 60;

		self.m_BossMinions = {};
		self.m_BossMinions[1] = EnemyManager:LaunchEnemyWithPosition(minionPool[1], x + offsetX, y - offsetY);
		self.m_BossMinions[2] = EnemyManager:LaunchEnemyWithPosition(minionPool[2], x - offsetX, y - offsetY);
		self.m_BossMinions[3] = EnemyManager:LaunchEnemyWithPosition(minionPool[3], x, y + offsetY);
		
		AudioManager:PlaySfx(SFX_OBJECT_BOOST);
	end,
	---------------------------------------------------------------------
	LaunchBossGiantSpiderMinion = function(self, go)
		for i = 1, 8 do
			g_TaskManager:AddTask(CallbackTask, { LaunchEgg }, math.random(200, 500), 0);
		end
	end,
	---------------------------------------------------------------------
	LaunchBossDevilSamuraiMinion = function(self, go)
		for i = 1, 5 do
			g_TaskManager:AddTask(CallbackTask, { LaunchTrap }, math.random(200, 400), 0);
		end
	end,
	---------------------------------------------------------------------
	AreBossMinionsDead = function(self)
		for i = 1, #self.m_BossMinions do
			if (not self.m_BossMinions[i]["StateMachine"]:IsCurrentState("inactive")) then
				return false;
			end
		end
		return true;
	end,

	--===================================================================
	-- Scrolling
	--===================================================================
	
	---------------------------------------------------------------------
	InitScrollingLayers = function(self)
	    self.m_Backdrop = ObjectFactory:CreateGameObject("StaticBackdrop");		
		self.m_LayerPre = ObjectFactory:CreateGameObject("DynamicBackdrop");
		self.m_LayerMid = ObjectFactory:CreateGameObject("DynamicBackdrop");
		self.m_LayerPost = ObjectFactory:CreateGameObject("DynamicBackdrop");
		self.m_LayerOverlay = ObjectFactory:CreateGameObject("StaticBackdrop");
	end,
	---------------------------------------------------------------------
	ResetScrollingLayers = function(self, factor)
		self.m_LayerPre["Interpolator"]:ResetTarget(0, -SCENE_LAYER_SIZE, self.m_CurrentScene.layer_pre[4] * factor);
		self.m_LayerMid["Interpolator"]:ResetTarget(0, -SCENE_LAYER_SIZE, self.m_CurrentScene.layer_mid[4] * factor);
		self.m_LayerPost["Interpolator"]:ResetTarget(0, -SCENE_LAYER_SIZE, self.m_CurrentScene.layer_post[4] * factor);
	end,
	---------------------------------------------------------------------
	EnableScrollingBackdrop = function(self, enable)
		self.m_ScrollingEnabled = enable;
		
		if (enable) then
			self.m_LayerPre["Interpolator"]:AttachCallback(UpdateLayerPos, ResetLayerPos, self.m_LayerPre);
			self.m_LayerPre["Interpolator"]:SetLooping(true);

			self.m_LayerMid["Interpolator"]:AttachCallback(UpdateLayerPos, ResetLayerPos, self.m_LayerMid);
			self.m_LayerMid["Interpolator"]:SetLooping(true);

			self.m_LayerPost["Interpolator"]:AttachCallback(UpdateLayerPos, ResetLayerPos, self.m_LayerPost);
			self.m_LayerPost["Interpolator"]:SetLooping(true);

			self:ResetScrollingLayers(1);
			
			if (not self.m_InTutorialStage) then
				self:EnableDistanceCounter(true);
					
				-- Initial boost
				if (self.m_IsChallengeMode and (UIManager:GetWidget("InGame", "DistanceCounter"):GetValue() == 0)) then
					self:BoostDistance(1500);
				else
					local boostDistance = IOManager:GetValue(IO_CAT_HACK, "Boost", "Initial");
					if (boostDistance > 0) then
						IOManager:SetValue(IO_CAT_HACK, "Boost", "Initial", 0, true);
						self:BoostDistance(boostDistance);
					end
				end
			end
		else
			self.m_LayerPre["Interpolator"]:Reset();
			self.m_LayerMid["Interpolator"]:Reset();
			self.m_LayerPost["Interpolator"]:Reset();

			self:EnableDistanceCounter(false);
		end
	end,
	---------------------------------------------------------------------
	IsBackdropScrolling = function(self)
		return self.m_ScrollingEnabled;
	end,

	--===================================================================
	-- Boost
	--===================================================================

	---------------------------------------------------------------------
	ShowBoostUI = function(self)
		if ((IOManager:GetValue(IO_CAT_HACK, "Boost", "Initial") > 0) or (self:GetLevelDataSet()["Medal"] < 2)) then
		-- Skip if had initial boost OR not yet reached 3000m
			return;
		end
		
		local cost = MAP_BOOST_COST[self.m_GameDifficulty][self.m_MapIndex] or DEFAULT_MAP_BOOST_COST;		
--[[ @BoostByCoin
		if (MoneyManager:HasEnoughCoin(cost)) then
--]]		
		if (MoneyManager:HasEnoughKoban(cost)) then
			UIManager:GetWidget("Boost", "Cost"):SetValue(cost);
			self.m_BoostSM:ChangeState("show");
		end
	end,
	---------------------------------------------------------------------
	HideBoostUI = function(self)
		if (not self.m_BoostSM:IsCurrentState("inactive")) then
			self.m_BoostSM:ChangeState("reset");
		end
	end,
	---------------------------------------------------------------------
	LogBoostEvent = function(self, hasAction)
		if (hasAction) then
			GameKit.LogEventWithParameter("HeadStart", "YES", self:GetMapName(), false);
		else
			GameKit.LogEventWithParameter("HeadStart", "NO", self:GetMapName(), false);
		end
	end,
	---------------------------------------------------------------------
	BoostDistanceByCoin = function(self)
		local cost = MAP_BOOST_COST[self.m_GameDifficulty][self.m_MapIndex] or DEFAULT_MAP_BOOST_COST;
--[[ @BoostByCoin
		MoneyManager:ModifyCoinWithMotionInGame(-cost);
--]]
		MoneyManager:ModifyKoban(-cost, true);

		self.m_BoostSM:ChangeState("inactive");
    	UIManager:ToggleUI("Boost");

		self:LogBoostEvent(true);
---[[ @RELEASE
		self:BoostDistance(1500);
--]]
--[[ @DEBUG
--		self:BoostDistance(3000);
--]]		
	end,
	---------------------------------------------------------------------
	BoostDistance = function(self, distance)
		self:RemoveAllScrollEffects();
		
		self.m_SpeedEffect:Reload();
		
		self.m_Castle["StateMachine"]:ChangeState("boost", self.m_SpeedEffect);
		self:EnableDistanceCounter(false);
		self:ResetScrollingLayers(0.1);		
		
		self.m_EnemyLauncher["StateMachine"]:ChangeState("inactive");
		self.m_EnemyLauncher["Timer"]:ToggleUpdate();
		self.m_EnemyWaveClock["Timer"]:ToggleUpdate();
		
		self.m_TimeToLeap = distance * TIME_TO_LEAP * 1000;
		--log("TIME to LEAP : "..distance * TIME_TO_LEAP)
		self.m_IsOnDistanceBoosting = true;

		local currentDist = self.m_DistanceCounterWidget:GetValue();
		--log("BoostDistance @ ".. currentDist .." ==> ".. currentDist + distance)
		local interGC = UIManager:GetWidgetComponent("InGame", "DistanceCounter", "Interpolator");
		interGC:ResetTarget(currentDist, currentDist + distance, 3000);
		interGC:AttachCallback(OnBoostDistanceUpdate, OnBoostDistanceEnded, self.m_DistanceCounterWidget);

		EnemyManager:RunawayAllEnemies();		
		
		ScrollManager:EnableScrollButtons(false);
		UIManager:GetWidget("InGame", "Pause"):Enable(false);
		
		AudioManager:PlaySfx(SFX_OBJECT_SPEEDBOOST);
	end,
	---------------------------------------------------------------------
	BoostDistanceEnded = function(self, distance)		
		for i = 1, 20 do  -- NOTE: it is a magic number
			if (self.m_TimeToLeap > 0) then
				self.m_TimeToLeap = self:SkipEnemyWave(self.m_TimeToLeap);
			end
		end

		self.m_IsOnDistanceBoosting = false;

		self.m_SpeedEffect:Unload();
		self.m_Castle["StateMachine"]:ChangeState("inactive");
		self:EnableDistanceCounter(true);
		self:ResetScrollingLayers(1);
		
		self:CheckDistanceEventsForBoost(distance);

		self.m_EnemyLauncher["StateMachine"]:ChangeState("active_module");
		self.m_EnemyLauncher["Timer"]:ToggleUpdate();
		self.m_EnemyWaveClock["Timer"]:ToggleUpdate();

		ScrollManager:EnableScrollButtons(true);
		UIManager:GetWidget("InGame", "Pause"):Enable(true);
	end,
	---------------------------------------------------------------------
	SkipEnemyWave = function(self, timeToLeap)
		local waveTime = self.m_EnemyWaveClock["Timer"]:GetDuration() - self.m_EnemyWaveClock["Timer"]:GetElapsedTime();
		local resultTime = timeToLeap - waveTime;
		--log("timeToLeap : "..timeToLeap)
		--log("waveTime : " .. waveTime)
		--log("resultTime : "..resultTime)
		
		if (resultTime >= 0) then
		--log("leap >>>>>>>>>>>>>>>>")
			self:ActivateNextWave();
		else
		--log("not enough from "..self.m_EnemyWaveClock["Timer"]:GetElapsedTime().." to "..self.m_EnemyWaveClock["Timer"]:GetElapsedTime() + timeToLeap)
			self.m_EnemyWaveClock["Timer"]:SetElapsedTime(self.m_EnemyWaveClock["Timer"]:GetElapsedTime() + timeToLeap);
		end
		
		return resultTime;
	end,

	--===================================================================
	-- Attack
	--===================================================================

	---------------------------------------------------------------------
	AttackCastle = function(self, go)
---[[ @Screenshot
		local enemyTemplate = go["Attribute"]:Get("template");
		AudioManager:PlaySfx(enemyTemplate[ENEMY_TEMPLATE_SFX][ES_ATTACK]);
		
		if (self.m_Life == 0) then
			return false;
		end
		
		if (self.m_Castle["StateMachine"]:IsCurrentState("shield")) then
			self.m_CastleShield["StateMachine"]:ChangeState("hit");
			return false;
		end
		
		-- Special case for Avatar Berserker
		if (self.m_IsAvatarBerserker and self.m_Castle["StateMachine"]:IsCurrentState("berserker")) then
			return false;
		end
		
		if (self.m_Castle["StateMachine"]:IsStateChangeAllowed("dodge")) then
			--log("dodge rate: "..self.m_AvatarDodge[enemyTemplate[ENEMY_TEMPLATE_ATACKTYPE] ].." % => "..enemyTemplate[ENEMY_TEMPLATE_ATACKTYPE])
			local bonusDodgeRate = 0;
			if (self.m_InnocentProtect) then
				bonusDodgeRate = 5;
			elseif (self.m_IsStatusBerserker) then
				bonusDodgeRate = 20;
			end

			if (math.random(1, 100) <= self.m_AvatarDodge[ enemyTemplate[ENEMY_TEMPLATE_ATACKTYPE] ] + bonusDodgeRate) then
				self.m_Castle["StateMachine"]:ChangeState("dodge");
				return;
			end
		end

		if (self.m_InnocentProtect) then
			self.m_Life = math.floor(self.m_Life - go["Attribute"]:Get("power") * 0.5);
		elseif (self.m_IsAvatarBerserker) then
			self.m_Life = math.floor(self.m_Life - go["Attribute"]:Get("power") * 0.75);
		else
			self.m_Life = self.m_Life - go["Attribute"]:Get("power");
		end

		-- Special case for Avatar Berserker
		if (self.m_IsAvatarBerserker) then
			if ((not self.m_IsStatusBerserker) and self.m_Life > 0 and self.m_Life < self.m_MaxLife * 0.3) then
			--log("GOTO berserker")
				self.m_IsStatusBerserker = true;
				self.m_LifeBarWidget:SetValue(self.m_Life);
				self.m_LifeBarNumberWidget:SetValue(self.m_Life);
				self.m_Castle["StateMachine"]:ChangeState("berserker");
				return false;
			end
		end

		local avatarIsDying = false;
		if (self.m_Life > 0) then
			self.m_Castle["StateMachine"]:ChangeState("wounded", self.m_CastleHurtEffect);
		else
			self.m_Life = 0;
			avatarIsDying = true;
			self.m_Castle["StateMachine"]:ChangeState("broken", self.m_CastleHurtEffect);
		end

		self.m_LifeBarWidget:SetValue(self.m_Life);
		self.m_LifeBarNumberWidget:SetValue(self.m_Life);
		AudioManager:PlaySfxInRandom(self.m_AvatarSfx);
		
		return avatarIsDying;
--]]		
	end,
	---------------------------------------------------------------------
	SetAvatarBerserk = function(self, state)
		self.m_IsStatusBerserker = state;
		log("SetAvatarBerserk: "..tostring(state))
		
		if (state) then
			self.m_Castle["Attribute"]:Set("AnimMove", "avatar_berserker2_move");
			self.m_Castle["Sprite"]:SetAnimation("avatar_berserker2_move", true);
			BladeManager:SetCriticalHitFactor(3.0);
			EnemyManager:RemoveAllBullets();
			EnemyManager:PushbackAllEnemies(120);
		else
			self.m_Castle["Attribute"]:Set("AnimMove", "avatar_berserker1_move");
			self.m_Castle["Sprite"]:SetAnimation("avatar_berserker1_move", true);
			BladeManager:SetCriticalHitFactor(DEFAULT_CRITICAL_HIT_FACTOR);
		end
	end,
	---------------------------------------------------------------------
	IsAvatarBerserking = function(self)
		return self.m_Castle["StateMachine"]:IsCurrentState("berserker");
	end,
	---------------------------------------------------------------------
	AttackCastleByInnocent = function(self)
		if (self.m_Life == 0) then
			return;
		end
		
		self.m_Life = 0;
		self.m_LifeBarWidget:SetValue(self.m_Life);
		self.m_LifeBarNumberWidget:SetValue(self.m_Life);
		self.m_Castle["StateMachine"]:ChangeState("broken", self.m_CastleHurtEffect);

		UpdateAchievement(ACH_INNOCENT_HURT);
		GameKit.LogEventWithParameter("AvatarFail", "innocent", "reason", false);
	end,
	---------------------------------------------------------------------
	IsCollidedCastle = function(self, go)
		local x, y = go["Bound"]:GetCenter();
		if (self.m_Castle["Bound"]:IsPickedNonTransformIndie(x, y)) then
			return true;
		end
		return false;
	end,
	---------------------------------------------------------------------
	IsCurrentLifeZero = function(self)
		return (self.m_Life == 0);
	end,
	---------------------------------------------------------------------
	ResetCastlePosition = function(self)
		if (self.m_Castle["Attribute"]:Get("PositionIndex") ~= AVATAR_POS_DEFAULT) then
			local castle = self.m_CurrentScene.castle;
			self.m_Castle["Transform"]:SetTranslate(castle.x, castle.y);
			self.m_Castle["Attribute"]:Set("PositionIndex", AVATAR_POS_DEFAULT);
		end
	end,

	--===================================================================
	-- Castle Clock (for Scrolls)
	--===================================================================

	---------------------------------------------------------------------
	ReloadCastleShield = function(self)	
		self.m_CastleShield:Reload();
		AudioManager:PlaySfx(SFX_SCROLL_SHIELD_ON);
	end,
	---------------------------------------------------------------------
	UnloadCastleShield = function(self)
		self.m_CastleShield:Unload();
		AudioManager:StopSfx(SFX_SCROLL_SHIELD_ON);
	end,
	---------------------------------------------------------------------
	LaunchCastleShield = function(self)
		self.m_CastleShield["Transform"]:SetTranslate(self:GetCastleShieldPos());		
		self.m_Castle["Timer"]:Reset(CASTLE_SCROLL_SHIELD_DURATION);
		self.m_Castle["StateMachine"]:ChangeState("shield", self.m_CastleShield);
	end,
	---------------------------------------------------------------------
	ReloadCastleEffect = function(self)	
		self.m_CastleFullScreenEffect:Reload();
		self.m_CastleFullScreenEffect["Sprite"]:ResetAnimation("scrolleffect_blizzard", true);
	end,
	---------------------------------------------------------------------
	UnloadCastleEffect = function(self)
		self.m_CastleFullScreenEffect:Unload();
    	RemoveFromPostRenderQueue(self.m_CastleFullScreenEffect);
	end,
	---------------------------------------------------------------------
	LaunchCastleEffect = function(self, enchant, duration)
		self.m_CastleFullScreenEffect:Reload();
		self.m_CastleFullScreenEffect["Sprite"]:ResetAnimation("scrolleffect_blizzard", true);	
	    AddToPostRenderQueue(self.m_CastleFullScreenEffect);

		self.m_CastleScrollClock["Timer"]:Reset(duration);
		self.m_CastleScrollClock["StateMachine"]:ChangeState("active", enchant);
		EnemyManager:EnchantAllEnemies(enchant);
	end,
	---------------------------------------------------------------------
	RemoveAllScrollEffects = function(self)
		self:HideBoostUI();

		self.m_CastleScrollClock["StateMachine"]:ChangeState("inactive");
	
		if (self.m_Castle["StateMachine"]:IsCurrentState("shield")) then
			self.m_Castle["StateMachine"]:ChangeState("inactive");
		end
	end,
	---------------------------------------------------------------------
	IsCurrentShieldState = function(self)
		return self.m_Castle["StateMachine"]:IsCurrentState("shield");
	end,
	
	--===================================================================
	-- Combo Effect
	--===================================================================
	---------------------------------------------------------------------
	LaunchComboEffect = function(self, lv)
		self.m_ComboLevel = lv;

		local x, y = self.m_Castle["Transform"]:GetTranslate();
		self.m_CastleComboText["Transform"]:SetTranslate(x - 18, y + 20);
		self.m_CastleComboText["Sprite"]:SetImage("ui_combotext_lv" .. lv);
		self.m_CastleComboText["Motion"]:ResetTarget(x - 18, y - 20);
		self.m_CastleComboText["StateMachine"]:ChangeState("combotext");

    	self.m_CastleComboEffect["Sprite"]:SetAnimation("effect_combo_lv" .. lv, true);
		AudioManager:PlaySfx(SFX_SCROLL_METEOR_HIT);

		if (lv == 1) then
		-- Increase speed
			self.m_CastleComboEffect["StateMachine"]:ChangeState("comboeffect_in");
			self.m_Castle["Sprite"]:SetFrequency(0.8);						
			local com = UIManager:GetWidgetComponent("InGame", "DistanceCounter", "Timer");
			self.m_OldDistCounterSpeed = com:GetDuration();
			com:Reset(self.m_OldDistCounterSpeed * 0.9);

			EnemyManager:PushbackAllEnemies(30);
		elseif (lv == 2) then
		-- Increase drop rate
            self.m_CastleComboEffect["Interpolator"]:ResetTarget(1.0, 1.2, 200);
            self.m_CastleComboEffect["Interpolator"]:AppendNextTarget(1.2, 1.0, 80);
			self.m_OldDropRate = EnemyManager:GetDropRate();
			EnemyManager:SetDropRate(math.floor(self.m_OldDropRate * 1.2));

			EnemyManager:PushbackAllEnemies(60);
		elseif (lv == 3) then
		-- Increase crit rate
            self.m_CastleComboEffect["Interpolator"]:ResetTarget(1.0, 1.2, 200);
            self.m_CastleComboEffect["Interpolator"]:AppendNextTarget(1.2, 1.0, 80);
			self.m_OldCriticalRate = BladeManager:GetCriticalHitFactor();
			BladeManager:SetCriticalHitFactor(self.m_OldCriticalRate * 1.3);

			EnemyManager:PushbackAllEnemies(90);
		end

		--log("=====LaunchComboEffect====")
		--logp(UIManager:GetWidgetComponent("InGame", "DistanceCounter", "Timer"):GetDuration(), self.m_OldDistCounterSpeed * 0.9, "SPED")
		--logp(self.m_OldDropRate, math.floor(self.m_OldDropRate * 1.2), "DROP")
		--logp(self.m_OldCriticalRate, self.m_OldCriticalRate * 1.3, "CRIT")
	end,
	---------------------------------------------------------------------
	RemoveComboEffect = function(self)
		local state = self.m_CastleComboEffect["StateMachine"]:GetCurrentState();
		
		if (state == "comboeffect_in" or state == "comboeffect_on") then
		    AudioManager:PlaySfx(SFX_CHAR_NINJA_ESCAPE);
			self.m_CastleComboEffect["StateMachine"]:ChangeState("comboeffect_out");
			
			if (self.m_ComboLevel >= 1) then
				self.m_Castle["Sprite"]:SetFrequency(1.0);
				UIManager:GetWidgetComponent("InGame", "DistanceCounter", "Timer"):Reset(self.m_OldDistCounterSpeed);
				
				if (self.m_ComboLevel >= 2) then
					EnemyManager:SetDropRate(self.m_OldDropRate);
					
					if (self.m_ComboLevel >= 3) then
						BladeManager:SetCriticalHitFactor(self.m_OldCriticalRate);
					end
				end
			end
		end
	end,
	---------------------------------------------------------------------
	ReloadComboEffect = function(self, go)
		go:Reload();
		local w1, h1 = self.m_Castle["Sprite"]:GetSize();
		local w2, h2 = go["Sprite"]:GetSize();
--		self.m_Castle:AttachLayerObject(go, (w1-w2) * 0.5, (h1-h2), GO_LAYER_PRE);
		self.m_Castle:AttachLayerObject(go, (w1-w2) * 0.5 / APP_UNIT_X, (h1-h2) / APP_UNIT_Y, GO_LAYER_PRE);
	end,
	---------------------------------------------------------------------
	UnloadComboEffect = function(self, go)
		self.m_Castle:DetachLayerObject(go, GO_LAYER_PRE);
    	go:Unload();
	end,
	---------------------------------------------------------------------
	ResetComboEffect = function(self)
		local state = self.m_CastleComboEffect["StateMachine"]:GetCurrentState();
		if ((state == "comboeffect_in") or (state == "comboeffect_on")) then
			self:UnloadComboEffect(self.m_CastleComboEffect);
		end
		
		self.m_CastleComboEffect["StateMachine"]:ChangeState("inactive");
		self.m_CastleComboText["StateMachine"]:ChangeState("inactive");
	end,

	--===================================================================
	-- Decorator
	--===================================================================

	---------------------------------------------------------------------
	LaunchDecorator = function(self, args)
		local obj = self.m_DecoratorPool:ActivateResource();
		if (obj == nil) then
			return;
		end
		
		DecoratorController["launch"](obj, args);
	end,
	---------------------------------------------------------------------
	DeactivateDecorator = function(self, go)
		self.m_DecoratorPool:DeactivateResource(go);
		
		RemoveFromPostRenderQueue(go);
	end,
	---------------------------------------------------------------------
	GetDecoratorList = function(self)
		return self.m_CurrentScene.decorator[2];
	end,

	--===================================================================
	-- Positioning Utility
	--===================================================================

	---------------------------------------------------------------------
	GetCastleShieldPos = function(self)
		local shieldPos = self.m_CurrentScene.shield;
		assert(shieldPos);
		return shieldPos.x, shieldPos.y;
	end,
	---------------------------------------------------------------------
	GetFieldPosX = function(self)
		return self.m_FieldSet.x[1], self.m_FieldSet.x[2];
	end,
	---------------------------------------------------------------------
	GetFieldPosY = function(self)
		return self.m_FieldSet.y[1], self.m_FieldSet.y[2];
	end,
	---------------------------------------------------------------------
	GetRandFieldPos = function(self)
		return math.random(self.m_FieldSet.x[1], self.m_FieldSet.x[2]),
			   math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]);
	end,
	---------------------------------------------------------------------
	GetRandFieldY = function(self)
		return math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]);
	end,
	---------------------------------------------------------------------
	GetEnemyBirthPos = function(self, go)
		return self.m_FieldSet.x[1] - go["Bound"]:GetSize(),
			   math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]);
	end,
	---------------------------------------------------------------------
	GetEnemyTargetPos = function(self, go)
		return self.m_FieldSet.x[2],
			   math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]) - go["Bound"]:GetRadius();
--			   math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]) - go["Bound"]:GetSize() * 0.5;
--			   math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]) - go["Bound"]:GetSize();
	end,
	---------------------------------------------------------------------
	GetRandMidRangedPos = function(self)
		return math.random(self.m_MidRangeSet.x[1], self.m_MidRangeSet.x[2]),
			   math.random(self.m_MidRangeSet.y[1], self.m_MidRangeSet.y[2]);
	end,
	---------------------------------------------------------------------
	GetRandLongRangedPos = function(self)
		return math.random(self.m_LongRangeSet.x[1], self.m_LongRangeSet.x[2]),
			   math.random(self.m_LongRangeSet.y[1], self.m_LongRangeSet.y[2]);
	end,
	---------------------------------------------------------------------
	GetBulletTargetPos = function(self, ox, oy)
		local x, y = self.m_Castle["Bound"]:GetCenter();
		--y = ModifyValueByRandRange(y, 10);
		--return x, y;
		
		local fx = x + 50 * (x - ox);
		local fy = y + 50 * (y - oy);
		return fx, fy;
	end,
	---------------------------------------------------------------------	
	SetEnemyWallMovement = function(self, go)
		local wall = self.m_CurrentScene.wall;
		local x = math.random(wall.x[1], wall.x[2]);
		local y = wall.y;
		
		go["Transform"]:SetTranslate(x, y);	
		go["Motion"]:SetVelocity(400);
		
		local targetX = x;
		local targetY = y;
		for _, offset in ipairs(wall.offset) do
			targetX = targetX + offset[1];
			targetY = targetY + offset[2];
			go["Motion"]:AppendNextTarget(targetX, targetY);
		end
	end,
	---------------------------------------------------------------------	
	SetBossWallMovement = function(self, go)
		local wall = self.m_CurrentScene.wall;
		local x = math.random(wall.x[1], wall.x[2]) - 80;
		local y = wall.y;
		
		go["Transform"]:SetTranslate(x, y);
		go["Motion"]:SetVelocity(300);
		
		local targetX = x;
		local targetY = y;
		for _, offset in ipairs(wall.offset) do
			targetX = targetX + offset[1];
			targetY = targetY + offset[2] - 30;
			go["Motion"]:AppendNextTarget(targetX, targetY);
		end
	end,
	---------------------------------------------------------------------	
	SetEnemyFlyMovement = function(self, go, birth)
		local originY;
		if (birth) then
			originY = math.random(0, 75);
			local w = go["Bound"]:GetSize();
			go["Transform"]:SetTranslate(-w, originY);
		else
			originY = go["Transform"]:GetTranslateY();
		end

        targetX = self.m_FieldSet.x[2] - go["Attribute"]:Get("template")[ENEMY_TEMPLATE_RANGE] + math.random(-15, 15);
		targetY = originY + math.random(-8, 8);

        go["Motion"]:ResetTarget(targetX, targetY);
	end,
	---------------------------------------------------------------------
	SetInnocentPos = function(self, go)
		go["Transform"]:SetTranslate(APP_WIDTH, math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]));

		if (math.random(1, 100) > 50) then
	        go["Motion"]:AppendNextTarget(math.random(self.m_MidRangeSet.x[1], self.m_MidRangeSet.x[2]), math.random(self.m_MidRangeSet.y[1], self.m_MidRangeSet.y[2]));
		end

		go["Motion"]:AppendNextTarget(-go["Bound"]:GetSize(), math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]));
	end,
	---------------------------------------------------------------------
	SetInnocentTarget = function(self, go)
		go["Motion"]:AppendNextTarget(-go["Bound"]:GetSize(), math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]));
	end,
	---------------------------------------------------------------------
	SetInnocentChance = function(self, chance)
		local t = {};
		for i = 1, 100 do
			if (i <= chance) then
				table.insert(t, RandElement(INNOCENT_POOL));
			else
				table.insert(t, Innocent_None);
			end
		end
		
		self.m_InnocentPool = RandDeck(t);

		-- Shadow enemy chance based on innocent chance
		self.m_ShadowEnemyChance = chance;
	end,
	---------------------------------------------------------------------
	SetRandsetEnemyChance = function(self, chance)
		if (chance) then
			--log("SetRandsetEnemyChance: "..chance.." %")
			self.m_RandsetEnemyChance = chance;
		end
	end,
	---------------------------------------------------------------------
	GetCenterPos = function(self, go)
		local w, h = go["Bound"]:GetSize();
		return math.floor((APP_WIDTH - w) * 0.5), math.floor((APP_HEIGHT - h) * 0.5);
	end,
--[[
	---------------------------------------------------------------------
	SetInnocentBornPos = function(self, go)
		go["Transform"]:SetTranslate(APP_WIDTH, math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]));
	end,
	---------------------------------------------------------------------
	SetInnocentTargetPos = function(self, go)
        go["Motion"]:AppendNextTarget(-go["Bound"]:GetSize(), math.random(self.m_FieldSet.y[1], self.m_FieldSet.y[2]));
	end,
	---------------------------------------------------------------------
	SetInnocentJadePos = function(self, go)
        go["Motion"]:AppendNextTarget(math.random(self.m_MidRangeSet.x[1], self.m_MidRangeSet.x[2]), math.random(self.m_MidRangeSet.y[1], self.m_MidRangeSet.y[2]));
	end,
	---------------------------------------------------------------------
	SetInnocentDeadMovement = function(self, go)
		if (self.m_Life > 0) then
			local x, y = go["Transform"]:GetTranslate();
			go["Motion"]:ResetTarget(self.m_FieldSet.x[1] - go["Bound"]:GetSize(), y);
		else
			go["Motion"]:Reset();
		end
	end,
--]]
	--===================================================================
	-- Medal
	--===================================================================
	---------------------------------------------------------------------
	ResetMedal = function(self, enable)
		self.m_MedalLevel = 0;
	end,
	---------------------------------------------------------------------
	GetMedal = function(self)
		return self.m_MedalLevel;
	end,
	---------------------------------------------------------------------
	GetMedalImageName = function(self)
		return MEDAL_ANIM_NAME[self.m_MedalLevel];
	end,
	---------------------------------------------------------------------
	ShowMedal = function(self)	
		self.m_MedalLevel = self.m_MedalLevel + 1;
		--self:GetLevelDataSet()["Medal"] = self.m_MedalLevel;
		--log("ShowMedal # "..self.m_MedalLevel);
		
		if (not self.m_MedalDistanceSM:IsCurrentState("active")) then
			UIManager:ToggleUI("Medal");
		end
		
		self.m_MedalDistanceSM:ChangeState("active", self.m_MedalLevel);
		
		AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
		
		-- Unlock next level and save progress		
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			if (self.m_MapIndex == 1 and self.m_MedalLevel == 2) then
				self:UnlockNextLevel();
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV1);
			elseif (self.m_MapIndex == 2 and self.m_MedalLevel == 2) then
				self:UnlockNextLevel();
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV2);
			elseif (self.m_MapIndex == 3 and self.m_MedalLevel == 3) then
				self:UnlockNextLevel();
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV3);
			elseif (self.m_MapIndex == 4 and self.m_MedalLevel == 3) then
				self:UnlockNextLevel();
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV4);
			elseif (self.m_MapIndex == 5 and self.m_MedalLevel == 3) then
				self:UnlockNextLevel();
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV5);
			end
--[[ @Old Method
			if (self.m_MapIndex == 1) then
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV1);
			elseif (self.m_MapIndex == 2) then
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV2);
			elseif (self.m_MapIndex == LEVEL_AVAIL_MAX) then
				UpdateAchievement(ACH_NORMAL_UNLOCK_LV3);
			end
--]]			
		else -- GAME_DIFF_SHADOW
			if (self.m_MedalLevel == 3) then
				if (not self.m_IsChallengeMode) then
					self:UnlockNextLevel();
				end
			end
		end
	end,

	--===================================================================
	-- Misc
	--===================================================================
	---------------------------------------------------------------------
	EnableDistanceCounter = function(self, enable)
		if (enable) then
			UIManager:GetWidgetComponent("InGame", "DistanceCounter", "StateMachine"):ChangeState("active", self.m_DistanceCounterWidget);
		else
			UIManager:GetWidgetComponent("InGame", "DistanceCounter", "StateMachine"):ChangeState("inactive");
		end
	end,
	---------------------------------------------------------------------
	EnableUpdate = function(self, enable)
		g_UpdateManager:EnableGroup(ENEMY_GROUP, enable);

		self:EnableDistanceCounter(enable);
		
		self.m_Castle["Timer"]:EnableUpdate(enable);
		self.m_CastleScrollClock["Timer"]:EnableUpdate(enable);
		self.m_DecoratorLauncher["Timer"]:EnableUpdate(enable);
	end,
	---------------------------------------------------------------------
	SetEnemyEvents = function(self, events)
		--log("   SPEED UP => "..events[1].." / INNO @ "..events[2].." %")

		-- Enemy base speed
		EnemyManager:SetSpeedFactor(events[1]);
		-- Innocent launch chance
		self:SetInnocentChance(events[2]);
		-- Rand enemy chance
		self:SetRandsetEnemyChance(events[3]);
		
		-- Coin type chance
		if (events[4]) then
			--log("   COIN CHANCE => "..events[3][1].." : "..events[3][2].." : "..events[3][3]);
			for i = 1, DROP_DATA_NUM do
				DROP_COIN_DATA[i][1] = events[4][i];
			end
		end
	end,
	---------------------------------------------------------------------
	CheckDistanceEventsForBoost = function(self, distance)
		local maxDist = 0;
		local maxDistEvent = nil;

		for dist, event in pairs(self.m_LevelEvent) do
			if (distance >= dist and dist > maxDist) then
				maxDist = dist;
				maxDistEvent = event;
			end
		end
		
		if (maxDist) then
			--log("[Dist @ "..distance.." m] ");
			self:SetEnemyEvents(maxDistEvent);
		end
	end,
	---------------------------------------------------------------------
	UpdateDistanceEvents = function(self, distance)
		self.m_CurrentDistance = distance;
		
		if (self.m_LevelEvent[distance]) then
			--log("[Dist @ "..distance.." m] ");
			self:SetEnemyEvents(self.m_LevelEvent[distance]);
		end

		-- Check medal requirement
		if (self.m_MedalLevel < 3) then
			if (distance > MEDAL_DISTANCE[self.m_MedalLevel + 1]) then
				self:ShowMedal();
			end
		end
	end,
	---------------------------------------------------------------------
	ActivateWarningEffect = function(self, go)
		self.m_WarningEffect:Reload();

		local x, y = self.m_Castle["Transform"]:GetTranslate();
		self.m_WarningEffect["Transform"]:SetTranslate(x + 50, y - 10);
		--self.m_WarningEffect["Sprite"]:SetImage("ui_button_equip");
        self.m_WarningEffect["Interpolator"]:AttachUpdateCallback(UpdateGOScale, self.m_WarningEffect["Transform"]);
        self.m_WarningEffect["Interpolator"]:ResetTarget(0.8, 1.3, 150);
        self.m_WarningEffect["Interpolator"]:AppendNextTarget(1.3, 1, 150);
		self.m_WarningEffect["Sprite"]:Animate();

		go["Timer"]:Reset(INNOCENT_WARN_DELAY[self.m_GameDifficulty]);
		
		AudioManager:PlaySfx(SFX_UI_WARNING);

		AddToPostRenderQueue(self.m_WarningEffect);
	end,
	---------------------------------------------------------------------
	DeactivateWarningEffect = function(self)
		RemoveFromPostRenderQueue(self.m_WarningEffect);
		
		self.m_WarningEffect:Unload();
	end,
	---------------------------------------------------------------------
	EnableInnocentProtect = function(self, enable)
		self.m_InnocentProtect = enable;
	end,

	--===================================================================
	-- @Challenge Mode
	--===================================================================
	---------------------------------------------------------------------
	EnterChallengeMap = function(self)
--[[ @Challenge icon in Normal mode
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			GameKit.ShowMessage("text_status", "game_challenge_lock");
			AudioManager:PlaySfx(SFX_UI_BUTTON_2);
			return;
		end
--]]
		local recShadow = IOManager:GetValue(IO_CAT_CONTENT, "Level", GAME_DIFFICULTY[GAME_DIFF_SHADOW]);
		if (recShadow[1] == nil) then
			AudioManager:PlaySfx(SFX_OBJECT_BOOST);
			GameKit.ShowMessage("text_status", "game_shaodw_first");
			return;
		end
		
		local recGC = IOManager:GetRecord(IO_CAT_HACK, "GameCenter");
		if (recGC and recGC["ChallengeLocked"]) then
			GameKit.ShowMessage("text_status", "The Daily Challenge has been banned for abnormal usage.");
			return;
		end

---[[ @RELEASE	
		local hasOpened, timeRemaining = self:IsChallengeOpened();
		if (hasOpened) then
			if (GameKit.HasGameCenterAuthenticated()) then
--]]		
				self:EnterMap(self:GetMaxAvailableLevelIndex(), true);
				AudioManager:PlaySfx(SFX_UI_SWITCH_WEAPON_1);
---[[ @RELEASE	
			else
				GameKit.ShowMessage("text_status", "game_challenge_gc");
				AudioManager:PlaySfx(SFX_UI_BUTTON_2);
			end
		else
			local min = math.ceil(timeRemaining / 60);
			local hr = math.floor(min / 60);
			min = min - hr * 60;
			
			GameKit.ShowMessage(GameKit.GetLocalizedString("game_challenge_title"),
				string.format("%s%d%s%d%s", GameKit.GetLocalizedString("game_challenge_desc"), hr, GameKit.GetLocalizedString("game_challenge_hour"), min, GameKit.GetLocalizedString("game_challenge_min")));
			AudioManager:PlaySfx(SFX_UI_BUTTON_2);
		end
--]]		
	end,
	---------------------------------------------------------------------
	IsChallengeMode = function(self)
		return self.m_IsChallengeMode;
	end,
	---------------------------------------------------------------------
	IsChallengeModeUnlocked = function(self)
		if (IOManager:GetRecord(IO_CAT_CONTENT, "ChallengeMode")) then
			return true;
		end
	end,
	---------------------------------------------------------------------
	IsChallengeOpened = function(self)
		local oldTime = IOManager:GetValue(IO_CAT_CONTENT, "ChallengeMode", "Duration");
		local currentTime = math.floor(GameKit.GetCurrentSystemTime());
		local timeElapsed = currentTime - oldTime;
		if (timeElapsed >= DAILY_CHALLENGE_DURATION) then
			--log("!!! CHALLENGE OPEN !!!")
			return true;
		end

		--log("Ch.Time Elapsed: ".. timeElapsed .." sec / ".. DAILY_CHALLENGE_DURATION .." sec")
		return false, (DAILY_CHALLENGE_DURATION - timeElapsed);
	end,
	---------------------------------------------------------------------
	EnableChallengeMode = function(self, enable)
		if (enable) then
			UIManager:GetWidget("EndlessMap", "Challenge"):SetImage("ui_button_daily");
			CycleGOScale(UIManager:GetWidgetObject("EndlessMap", "Challenge"), 1.0, 1.1, 500);
		else
			UIManager:GetWidget("EndlessMap", "Challenge"):SetImage("ui_button_daily_locked");
			local obj = UIManager:GetWidgetObject("EndlessMap", "Challenge");
			obj["Transform"]:SetScale(1.0);
			obj["Interpolator"]:Reset();
		end
	end,
	---------------------------------------------------------------------
	UpdateChallengeModeStatus = function(self)
		if (self.m_GameDifficulty == GAME_DIFF_NORMAL) then
			self:EnableChallengeMode(false);
		else
			if (IOManager:GetRecord(IO_CAT_CONTENT, "ChallengeMode")) then
			-- Challenge Mode has already opened
---[[ @RELEASE
				self:EnableChallengeMode(self:IsChallengeOpened());
--]]
--[[ @DEBUG
				self:EnableChallengeMode(true);
--]]
			else
				if (IOManager:GetValue(IO_CAT_CONTENT, "Level", "Shadow")[1]) then
				-- Create Challenge Mode data only if Shadow Mode is unlocked
					local currentTime = math.floor(GameKit.GetCurrentSystemTime());
					IOManager:SetRecord(IO_CAT_CONTENT, "ChallengeMode", { Duration = currentTime, Count = 0 }, true);
					self:EnableChallengeMode(false);
				end
			end
		end
	end,

	--===================================================================
	-- Render & Update Routines
	--===================================================================

	---------------------------------------------------------------------
	RenderBackdrop = function(self)
		self.m_Backdrop:Render();
		self.m_LayerPre:Render();
		self.m_LayerMid:Render();

--[[ @BackdropField
		self.m_BackdropField:Render();
--		self.m_BackdropMidRange:Render();
--		self.m_BackdropLongRange:Render();
		self.m_Castle:Render();
--]]
	end,
	---------------------------------------------------------------------
	RenderOverlay = function(self)
		self.m_LayerPost:Render();		
		self.m_LayerOverlay:Render();
--[[		
		for _, obj in ipairs(self.m_LayerOverlay) do
			obj:Render();
		end
--]]		
	end,
	---------------------------------------------------------------------
	Update = function(self)
		-- Enemy launcher
		if (self.m_EnemyWaveClock["Timer"]:IsOver()) then
			self:ActivateNextWave();
		end

		-- Backdrop layers		
		self.m_LayerPre:Update();
		self.m_LayerMid:Update();
		self.m_LayerPost:Update();
	end,
	---------------------------------------------------------------------
	UpdateBackdropLayers = function(self)
		self.m_LayerPre:Update();
		self.m_LayerMid:Update();
		self.m_LayerPost:Update();
	end,
--[[
	---------------------------------------------------------------------
	EnableBackdropShade = function(self)
		self.m_BackdropShade:EnableRender(false);
		g_TaskManager:AddTask(EnableRenderTask, { self.m_BackdropShade, true }, 0, 0);
	end,
	---------------------------------------------------------------------
	RenderBackdropShade = function(self)
		self.m_BackdropShade:Render();
	end,
--]]	
};



-------------------------------------------------------------------------
DECO_TYPE_LEAF = 1;
DECO_TYPE_FIRESPARK = 2;
DECO_TYPE_FOG = 3;
DECO_TYPE_LIGHTNING = 4;
DECO_TYPE_FIREPILLAR = 5;

DecoratorManager =
{
	---------------------------------------------------------------------
	[DECO_TYPE_LEAF] =
	{
		-----------------------------------------------------------------
		initial = function(go)
		end,
		-----------------------------------------------------------------		
		launch = function(go)
			local x, y;
			local dir = math.random(1, 100);
		
			if (dir > 50) then  
			-- Start from NORTH
				x = math.random(30, 480);
				y = 0;
			else  
			-- Start from EAST
				x = 480;
				y = math.random(0, 290);
			end
	
			go["Transform"]:SetTranslate(x, y);
			go["Transform"]:SetScale(math.random(70, 100) * 0.01);
			go["Motion"]:SetVelocity(math.random(DECO_VELOCITY_MIN, DECO_VELOCITY_MAX));
			go["Interpolator"]:ResetTarget(math.random(0, 360), math.random(0, 360), math.random(DECO_ROTATE_DURATION_MIN, DECO_ROTATE_DURATION_MAX));
			go["StateMachine"]:ChangeState("motion");
			
			DecoratorController["move"](go, x, y);
		end,
		-----------------------------------------------------------------		
		move = function(go, x, y)	
			go["Motion"]:ResetTarget(x - math.random(DECO_RANGE_MIN, DECO_RANGE_MAX), y + math.random(DECO_RANGE_MIN, DECO_RANGE_MAX));
		end,
		-----------------------------------------------------------------
		update = function(go)
            if (go["Motion"]:IsDone()) then
                local x, y = go["Transform"]:GetTranslate();

                if (x < 0 or y > 320) then
                    LevelManager:DeactivateDecorator(go);
                else
            		DecoratorController["move"](go, x, y);                    
                end
            else
                go["Transform"]:SetRotateByDegree(go["Interpolator"]:GetValue());
            end		
		end,
	},
--[[
	---------------------------------------------------------------------
	[DECO_TYPE_FIRESPARK] =
	{
		-----------------------------------------------------------------
		initial = function(go)
			LevelManager:LaunchDecorator();
		end,
		-----------------------------------------------------------------		
		launch = function(go)
			local x = -180;  -- x is half the image width
			local y = 320;
	
			go["Transform"]:SetTranslate(x, y);
			go["Motion"]:SetVelocity(math.random(DECO_VELOCITY_MIN, DECO_VELOCITY_MAX));
			go["StateMachine"]:ChangeState("motion");
			
			DecoratorController["move"](go, x, y);
		end,
		-----------------------------------------------------------------		
		move = function(go, x, y)	
			go["Motion"]:ResetTarget(x + math.random(DECO_RANGE_MIN, DECO_RANGE_MAX), y - math.random(DECO_RANGE_MIN, DECO_RANGE_MAX));
		end,
		-----------------------------------------------------------------
		update = function(go)
            if (go["Motion"]:IsDone()) then
                local x, y = go["Transform"]:GetTranslate();

                if (x > 480 or y < -250) then  -- y is about the image height
                    LevelManager:DeactivateDecorator(go);
                else
            		DecoratorController["move"](go, x, y);                    
                end
            end		
		end,
	},
--]]
	---------------------------------------------------------------------
	[DECO_TYPE_FOG] =
	{
		-----------------------------------------------------------------
		initial = function(go)			
			FogIndexGenerator = RandDeck{ 1, 2, 3 };

			LevelManager:LaunchDecorator(1);
			LevelManager:LaunchDecorator(3);
		end,
		-----------------------------------------------------------------		
		launch = function(go, pos)
			local dir = pos or FogIndexGenerator();
			local x = 1000;
			local y;
			
			if (dir == 1) then
				y = math.random(-50, 50);
			elseif (dir == 2) then
				y = 120 + math.random(-50, 50);
			else
				y = 240 + math.random(-50, 50);
			end			
			--log("FOG dir: #"..dir.."  (x, y) = "..x.." / "..y)
		
			go["Transform"]:SetTranslate(x, y);
			go["Transform"]:SetScale(2.0, 1.0);  -- Original image is scaled down in X-axis
			
			go["Motion"]:SetVelocity(math.random(DECO_VELOCITY_MIN, DECO_VELOCITY_MAX));
			go["Motion"]:AppendNextTarget(-1000, y);

			go["StateMachine"]:ChangeState("motion");
		--log("deco @ motion")
		end,
		-----------------------------------------------------------------		
		update = function(go)
            if (go["Motion"]:IsDone()) then
			--log("deco @ done")
				LevelManager:DeactivateDecorator(go);
			end
		end,
	},
	
	---------------------------------------------------------------------
	[DECO_TYPE_LIGHTNING] =
	{
		-----------------------------------------------------------------
		initial = function(go)
		end,
		-----------------------------------------------------------------		
		launch = function(go, pos)			
			local index = math.random(1, 3);
			local decoList = LevelManager:GetDecoratorList();
			
			if (index == 1) then
				go["Transform"]:SetTranslate(280, 0);
				go["Sprite"]:SetAnimation(decoList[1], true);
			elseif (index == 2) then
				go["Transform"]:SetTranslate(129, 27);
				go["Sprite"]:SetAnimation(decoList[2], true);
			else
				go["Transform"]:SetTranslate(1, 27);
				go["Sprite"]:SetAnimation(decoList[3], true);
			end			
			--log("lightning @ launch: "..index)

			go["StateMachine"]:ChangeState("motion");
		end,
		-----------------------------------------------------------------		
		update = function(go)
            if (go["Sprite"]:IsDone()) then
				LevelManager:DeactivateDecorator(go);
			end
		end,
	},

	---------------------------------------------------------------------
	[DECO_TYPE_FIREPILLAR] =
	{
		-----------------------------------------------------------------
		initial = function(go)
		end,
		-----------------------------------------------------------------		
		launch = function(go, pos)
			local dice = math.random(1, 100);
			local decoList = LevelManager:GetDecoratorList();
			go["Sprite"]:SetAnimation(decoList[1], true);
			
			if (dice > 66) then
				go["Transform"]:SetTranslate(30, 170);
			elseif (dice > 33) then
				go["Transform"]:SetTranslate(154, 157);
			else
				go["Transform"]:SetTranslate(383, 183);
			end			

			go["StateMachine"]:ChangeState("motion");
		end,
		-----------------------------------------------------------------		
		update = function(go)
            if (go["Sprite"]:IsDone()) then
				LevelManager:DeactivateDecorator(go);
			end
		end,
	},
};


-------------------------------------------------------------------------
function AttackCastle(go)
	LevelManager:AttackCastle(go);	
end

-------------------------------------------------------------------------
function UpdateCastleLife(value, go)
	go:SetValue(value);
	UIManager:GetWidget("InGame", "LifeBarNumber"):SetValue(value);
end

--------------------------------------------------------------------------------
function OnBoostDistanceUpdate(value, go)
	go:SetValue(value);
	LevelManager:UpdateDistanceEvents(value);
end

--------------------------------------------------------------------------------
function OnBoostDistanceEnded(value)
	LevelManager:BoostDistanceEnded(value);
end

-------------------------------------------------------------------------
function UpdateAvatarLife(value, go)
	go:SetValue(value);
	UIManager:GetWidget("AvatarStat", "LifeBarNumber"):SetValue(value);
end

-------------------------------------------------------------------------
function UpdateAvatarEnergy(value, go)
	go:SetValue(value);
	UIManager:GetWidget("AvatarStat", "EnergyBarNumber"):SetValue(value);
end

--[[
-------------------------------------------------------------------------
function UpdateAvatarExpBar(value, go)
	go:SetValue(value);
end
-------------------------------------------------------------------------
function UpdateExpGain(value, go)
	go:SetValue(value);
end
--]]

-------------------------------------------------------------------------
function UnlockMapByKoban(result)
	if (result == 0) then
		GameKit.LogEventWithParameter("UnlockMapByGold", "NO", LevelManager:GetMapName(), false);
		--log("MAP UNLOCK CANCEL")
		AudioManager:PlaySfx(SFX_OBJECT_BOOST);

		if (LevelManager:IsShadowDifficulty()) then
			GameKit.ShowMessage("game_map_title", "game_shadow_middle");
		--else
		--	GameKit.ShowMessage("game_map_title", "game_map_middle");
		end
	elseif (result == 1) then
		GameKit.LogEventWithParameter("UnlockMapByGold", "YES", LevelManager:GetMapName(), false);
		--log("NEW MAP UNLOCKED !!")
		LevelManager:UnlockMapByKoban();
		AudioManager:PlaySfx(SFX_UI_MONEY_SPEND);
	end
end

-------------------------------------------------------------------------
function UpdateLayerPos(value, go)
    if (go["Attribute"]:Get("LayerLoop")) then
        go["Sprite"]:SetIndieOffset(1, SCENE_LAYER_SIZE + value, 0);
        go["Sprite"]:SetIndieOffset(2, value, 0);
    else
        go["Sprite"]:SetIndieOffset(1, value, 0);
        go["Sprite"]:SetIndieOffset(2, SCENE_LAYER_SIZE + value, 0);
    end
end

-------------------------------------------------------------------------
function ResetLayerPos(value, go)
--log("ResetPos: "..value)
    go["Attribute"]:Set("LayerLoop", not go["Attribute"]:Get("LayerLoop"));
end

--[[
-------------------------------------------------------------------------
function GotoNextStage()
	--log("Goto [2]: "..g_Timer:GetElapsedTime())
	LevelManager:GotoNextStageAfterMoviePlayback();
end
--]]

-------------------------------------------------------------------------
function LaunchEgg()
	local x = math.random(100, 350);
	local y = math.random(110, 170);
	local trap = EnemyManager:LaunchEnemyWithPosition(BossMinion_ObjectSpiderEgg, x, y - APP_HEIGHT);
	if (trap) then
		trap["Motion"]:SetVelocity(900);
		trap["Motion"]:ResetTarget(x, y);
	end
end

-------------------------------------------------------------------------
function LaunchTrap()
	local x = math.random(100, 400);
	local y = math.random(120, 180);
	local trap = EnemyManager:LaunchEnemyWithPosition(BossMinion_ObjectTrap, x, y - APP_HEIGHT);
	if (trap) then
		trap["Motion"]:SetVelocity(900);
		trap["Motion"]:ResetTarget(x, y);
	end
end
