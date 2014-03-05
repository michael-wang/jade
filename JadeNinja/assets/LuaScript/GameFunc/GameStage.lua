--***********************************************************************
-- @file GameStage.lua
--***********************************************************************

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "Logo",
    ui = "MainEntry",
	
	OnEnter = function()		
		--=========
		-- UI
		--=========
		SwitchDayNightUI();
		
		UIManager:ToggleWidgetGroup("MainEntry", "Buttons", false);
		UIManager:EnableWidget("MainEntry", "Char1", false);
		UIManager:GetUI("MainEntry"):LockAllButtons();

		--=========
		-- Task
		--=========
	    g_TaskManager:AddTask(CallbackTask, { ShowLogoChar3, nil, nil, nil }, 400, 500);
	    g_TaskManager:AddTask(CallbackTask, { ShowLogoChar2, nil, nil, nil }, 200, 0);

		if (LevelManager:GetGameDifficulty() == GAME_DIFF_NORMAL) then
			g_TaskManager:AddTask(CallbackTask, { ShowLogoChar1, nil, nil, nil }, 400, 0);
		end

		--=========
		-- Audio
		--=========
		if (AudioManager:IsBgmSettingOn()) then
			AudioManager:PlayBgm(BGM_MAIN_MENU_ENTER);
		else
			AudioManager:SetBgm(BGM_MAIN_MENU_ON);
			g_TaskManager:AddTask(StageChangeTask, "MainEntry", 0, 0);
		end
	end,

	OnExit = function()
		UIManager:ToggleWidgetGroup("MainEntry", "Buttons", true);
		UIManager:GetUI("MainEntry"):UnlockAllButtons();

	    SyncFromCloud();
    
		-- Special case: China SNS
		if (GameKit.GetUserLanguage() == "zh-Hans") then
			UIManager:GetWidget("MainEntry", "Twitter"):SetImage("ui_mainmenu_sina");
			UIManager:GetWidget("GameStat", "Twitter"):SetImage("ui_stat_sina");
		end
		
		InitAd();
		--ListCurrentUsedTextures("MainEntry");
	end,

	Update = function()
		if (AudioManager:IsBgmSettingOn() and AudioManager:IsCurrentBgmDone()) then
			AudioManager:PlayBgm(BGM_MAIN_MENU_ON);
			StageManager:ChangeStage("MainEntry");
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "MainEntry",
    ui = "MainEntry",
	
	OnEnter = function()
		SwitchDayNightUI();

		UIManager:SetWidgetTranslate("MainEntry", "Char2", 141, 102);
		UIManager:SetWidgetTranslate("MainEntry", "Char3", 10, 114);
		UIManager:GetWidgetComponent("MainEntry", "Play", "StateMachine"):ChangeState("blink");

		--CheckPaidGift();  -- v2.0 gift
		
		if (IOManager:GetRecord(IO_CAT_OPTION, "iCloud") == nil) then
			ShowiCloudChoices();
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "Info",
    ui = "Info",
	
	OnEnter = function()
		GameKit.LogEvent("UI_Info", true);

        UIManager:GetWidgetComponent("Info", "Content", "Sprite"):SetImage("credit_00");
		UIManager:GetWidgetComponent("Info", "Content", "Attribute"):Set("Page", 0);
		UIManager:GetWidgetComponent("Info", "Content", "StateMachine"):ChangeState("move_begin");
	end,

	OnExit = function()
	    UIManager:SetWidgetTranslate("Info", "Content", UI_CREDIT_POS[1] + SCREEN_UNIT_X, UI_CREDIT_POS[2]);
		UIManager:GetWidgetComponent("Info", "Content", "Attribute"):Set("Page", 0);

		GameKit.LogEventEnded("UI_Info");
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "History",
    ui = "History",
	
	OnEnter = function()
		GameKit.LogEvent("UI_History", true);
	end,

	OnExit = function()
		GameKit.LogEventEnded("UI_History");
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "EndlessMap",
    ui = "EndlessMap",
	
	OnEnter = function()
--[[ @Paid App Badge
		UpdateAchievement(ACH_MONKEY_POTION);
--]]
--[[ @Chartboost
		ProceedAd();
--]]		
	end,

	OnExit = function()
--[[ @Chartboost
		ExitAd();
--]]		
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreEndlessMap",
	ui = "EndlessMap",
	
	OnEnter = function()
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("opening_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("opening_right");

		ShopManager:ShowShopIcon();
		LevelManager:UpdateChallengeModeStatus();

		AudioManager:CreateBgmList(GAME_MENU_BGM);
		AudioManager:PlayBgm(BGM_MAIN_MENU_ON);
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("opened_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("opened_right")) then
			StageManager:ChangeStage("EndlessMap");
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostEndlessMap",
	ui = "EndlessMap",
	
	OnEnter = function()
		local index = LevelManager:GetMapIndex();
		local interGC = LevelManager:GetMapTargetInterGC();
        interGC:ResetTarget(1.0, 0.9, 250);
        interGC:AppendNextTarget(0.9, 1.05, 75);
        interGC:AppendNextTarget(1.05, 1.0, 75);
		
		UIManager:GetUI("EndlessMap"):LockAllButtons();
		UIManager:GetUI("EndlessMap"):EnableSwipe(false);
	end,

	OnExit = function()
		UIManager:GetUI("EndlessMap"):UnlockAllButtons();
		UIManager:GetUI("EndlessMap"):EnableSwipe(true);
	end,

	Update = function()
		if (LevelManager:GetMapTargetInterGC():IsDone()) then
			StageManager:ChangeStage(LevelManager:GetNextStage());
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostEndlessMapToMovie",
	ui = "EndlessMap",
	
	OnEnter = function()
	-- The same process with 'PostEndlessMap' except the target stage
		local index = LevelManager:GetMapIndex();
		local interGC = LevelManager:GetMapTargetInterGC();
        interGC:ResetTarget(1.0, 0.9, 250);
        interGC:AppendNextTarget(0.9, 1.05, 75);
        interGC:AppendNextTarget(1.05, 1.0, 75);
		
		UIManager:GetUI("EndlessMap"):LockAllButtons();
		UIManager:GetUI("EndlessMap"):EnableSwipe(false);
	end,

	OnExit = function()
		UIManager:GetUI("EndlessMap"):UnlockAllButtons();
		UIManager:GetUI("EndlessMap"):EnableSwipe(true);
	end,

	Update = function()
		if (LevelManager:GetMapTargetInterGC():IsDone()) then
			StageManager:ChangeStage("MoviePlaybackDoorClose");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "MoviePlaybackDoorClose",
	ui = "EndlessMap",
	
	OnEnter = function()
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			AudioManager:ToggleCurrentBgm(false);
			StageManager:ChangeStage("MoviePlayback");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "MoviePlayback",
	ui = "MoviePlayback",
	
	OnEnter = function()
		--PlayMovie("jade.m4v", OnOPMoviePlaybackCompleted);
		PlayMovie(LevelManager:GetTargetMovie());
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostEndlessMapToGame",
	ui = "EndlessMap",
	
	OnEnter = function()
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			
			AudioManager:ToggleCurrentBgm(false);
			ScrollManager:Reset();
			ScrollManager:Complete();
			StageManager:ChangeStage("PreInGameDoor");
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostEndlessMapToScroll",
	ui = "EndlessMap",
	
	OnEnter = function()
	--log("enter @ PostEndlessMapToScroll")
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()
	--log("exit @ PostEndlessMapToScroll")
--[[	
		UIManager:ToggleUI("Door");
--]]		
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			StageManager:ChangeStage("PreScrollSelect");
			AudioManager:ToggleCurrentBgm(false);
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "EndlessMapCloseDoor",
	ui = "EndlessMap",
	
	OnEnter = function(state)
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
		
		GameDataManager:SetData("DooringNextStage", state);
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			StageManager:ChangeStage(GameDataManager:GetData("DooringNextStage"));
			GameDataManager:SetData("DooringNextStage", nil);
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "GameDifficulty",
	ui = "EndlessMap",
	
	OnEnter = function()
		LevelManager:ToggleDifficulty();
		SwitchDayNightDoor();
		
		UIManager:ToggleUI("Door");
		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()	
		LevelManager:InitializeMapButtons();
		--LevelManager:RepositionMap(1);
		LevelManager:RepositionMaxAvailableMap();

		UIManager:ToggleUI("Door");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			
			SwitchDayNightMap();
			StageManager:ChangeStage("PreEndlessMap");
		end
	end,

	Render = function()
	end,
};

---------------------------------------------------------------------------
GameStageTemplate
{
    id = "ShopCloseDoor",
	ui = "Shop",
	
	OnEnter = function()
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
		UIManager:ToggleUI("ShopCategory");
		UIManager:ToggleUI("ShopInfo");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			StageManager:ChangeStage("PreEndlessMap");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ShopOpenDoor",
	ui = "Shop",
	
	OnEnter = function()
		UIManager:ToggleUI("ShopInfo");
		UIManager:ToggleUI("ShopCategory");
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("opening_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("opening_right");

		ShopManager:Reset();
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
		ShowFeedbackUI();
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("opened_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("opened_right")) then
			AudioManager:StopBgm();
			StageManager:ChangeStage("Shop");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "Shop",
    ui = "Shop",
	
	OnEnter = function()
		GameKit.LogEvent("UI_Shop", true);
	end,

	OnExit = function()
		GameKit.LogEventEnded("UI_Shop");
		MoneyManager:ResetMotion("Shop");
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ShopUpgrade",
	ui = "Shop",
    
	OnEnter = function()
		OpenDropdownUI("ShopUpgrade");
		ShopManager:UpdateUpgradeUI();
		UIManager:ToggleUI("ShopUpgrade");
	end,

	OnExit = function()
	end,

	TouchEnded = function(x, y)
		if (UIManager:GetUIComponent("ShopUpgrade", "Motion"):IsDone()) then
			AudioManager:PlaySfx(SFX_UI_BUTTON_2);
			StageManager:ChangeStage("ShopUpgradeExit");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ShopUpgradeExit",
	ui = "Shop",
    
	OnEnter = function()
		CloseDropdownUI("ShopUpgrade");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetUIComponent("ShopUpgrade", "Motion"):IsDone()) then
			UIManager:ToggleUI("ShopUpgrade");
			StageManager:ChangeStage("Shop");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "LevelUnlock",
	ui = "GameStat",
    
	OnEnter = function()
		OpenDropdownUI("LevelUnlock");
		UIManager:ToggleUI("LevelUnlock");

		local index = LevelManager:GetMapIndex() + 1;
		if (index <= LEVEL_AVAIL_MAX) then
			UIManager:GetUIComponent("LevelUnlock", "Sprite"):SetImage(1, "ui_map_level"..index);
			UIManager:GetUIComponent("LevelUnlock", "Sprite"):EnableRender(2, false);
			UIManager:EnableWidget("LevelUnlock", "Go", true);
			UIManager:EnableWidget("LevelUnlock", "GoShadow", false);
		else
		-- Unlock Shadow mode
			UIManager:GetUIComponent("LevelUnlock", "Sprite"):SetImage(1, "ui_map_shadow");
			UIManager:GetUIComponent("LevelUnlock", "Sprite"):EnableRender(2, true);
			UIManager:EnableWidget("LevelUnlock", "Go", false);
			UIManager:EnableWidget("LevelUnlock", "GoShadow", true);
		end
		
		AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
	end,

	OnExit = function()
	end,

	TouchEnded = function(x, y)
		if (UIManager:GetUIComponent("LevelUnlock", "Motion"):IsDone()) then
			AudioManager:PlaySfx(SFX_UI_BUTTON_2);
			StageManager:ChangeStage("LevelUnlockExit");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "LevelUnlockExit",
	ui = "GameStat",

	OnEnter = function()
		CloseDropdownUI("LevelUnlock");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetUIComponent("LevelUnlock", "Motion"):IsDone()) then		
			UIManager:ToggleUI("LevelUnlock");
			StageManager:ChangeStage("UnlockSkip");
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "UnlockSkip",
	ui = "GameStat",
    
	OnEnter = function()
		ShowStatButtons();
	end,

	OnExit = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreScrollSelect",
	ui = "ScrollSelect",
	
	OnEnter = function(state)
	--log("enter @ PreScrollSelect")
	    g_TaskManager:AddTask(StageChangeTask, "ScrollSelectPerform", 0, 300);
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
		--UIManager:GetUIObject("ScrollSelect"):Reload();
		UIManager:GetWidgetObject("ScrollSelect", "DoorLeft"):Reload();
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ScrollSelectPerform",
    ui = "ScrollSelect",
	
	OnEnter = function()
	--log("enter @ ScrollSelectPerform")
		if (LevelManager:GetUnlockedJade() or LevelManager:GetUnlockedScroll()) then
			ScrollManager:Reset(true);
		else
			ScrollManager:Reset(false);
		end
		
		UIManager:GetUI("ScrollSelect"):LockAllWidgets(true);
	end,

	OnExit = function()
		UIManager:GetUI("ScrollSelect"):LockAllWidgets(false);
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("ScrollSelect", "Scroll1", "Motion"):IsDone()) then
			if (LevelManager:IsChallengeMode()) then
				if (IOManager:GetValue(IO_CAT_CONTENT, "ChallengeMode", "Count") < 4) then
					StageManager:ChangeStage("ChallengeRule");
				else
					StageManager:ChangeStage("ScrollSelectAction");
					ShowFeedbackUI();
				end
			else		
				-- NOTE: assume that Scroll Unlock & Jade Unlock won't happen at the same time
				if (LevelManager:GetUnlockedJade()) then
					StageManager:ChangeStage("JadeUnlock");
				elseif (LevelManager:GetUnlockedScroll()) then
					StageManager:ChangeStage("ScrollUnlock");
				else
					StageManager:ChangeStage("ScrollSelectAction");
					ShowFeedbackUI();
				end
			end
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ScrollSelectAction",
    ui = "ScrollSelect",
	
	OnEnter = function()
	--log("enter @ ScrollSelectAction")
		ScrollManager:ShowScrollButtons();
	end,

	OnExit = function()
		MoneyManager:ResetMotion("ScrollSelect");
		--ListCurrentUsedTextures("ScrollSelectAction");
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ChallengeRule",
    ui = "ScrollSelect",
	
	OnEnter = function()
		AudioManager:PlaySfx(SFX_CHAR_KABUKI_TRAP);
		UIManager:ToggleUI("ChallengeRule");
	end,

	OnExit = function()
		AudioManager:PlaySfx(SFX_OBJECT_TRAP_ON);
		UIManager:ToggleUI("ChallengeRule");
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ScrollUnlock",
    ui = "ScrollSelect",

	OnEnter = function()
		OpenDropdownUI("ScrollUnlock");

		local scroll = LevelManager:GetUnlockedScroll();
		UIManager:GetWidget("ScrollUnlock", "Icon"):SetImage(SCROLL_DATA[scroll][SCROLL_T_ICON]);
		UIManager:ToggleUI("ScrollUnlock");

		AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
	end,

	OnExit = function()
	end,
--[[
	TouchEnded = function(x, y)
		if (UIManager:GetUIComponent("ScrollUnlock", "Motion"):IsDone()) then
			AudioManager:PlaySfx(SFX_UI_BUTTON_2);
			StageManager:ChangeStage("ScrollUnlockExit");
		end
	end,
--]]	
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "ScrollUnlockExit",
	ui = "ScrollSelect",
    
	OnEnter = function()
		CloseDropdownUI("ScrollUnlock");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetUIComponent("ScrollUnlock", "Motion"):IsDone()) then
			ScrollManager:SwitchCategory(SCROLL_CAT_SCROLL, true);
			ScrollManager:UpdateTargetScroll(LevelManager:ResetUnlockedScroll());
			
			UIManager:ToggleUI("ScrollUnlock");
			
			StageManager:ChangeStage("ScrollSelectAction");
			ShowFeedbackUI();
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "JadeUnlock",
    ui = "ScrollSelect",
	
	OnEnter = function()
		OpenDropdownUI("JadeUnlock");
		
		local jade = LevelManager:GetUnlockedJade();
		UIManager:GetWidget("JadeUnlock", "Icon"):SetImage(JADE_DATA_POOL[jade][JE_SHOPICON]);
		UIManager:ToggleUI("JadeUnlock");

		AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
	end,

	OnExit = function()
	end,
--[[
	TouchEnded = function(x, y)	
		if (UIManager:GetUIComponent("JadeUnlock", "Motion"):IsDone()) then
			AudioManager:PlaySfx(SFX_UI_BUTTON_2);
			StageManager:ChangeStage("JadeUnlockExit");
		end
	end,
--]]	
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "JadeUnlockExit",
    ui = "ScrollSelect",
    
	OnEnter = function()
		CloseDropdownUI("JadeUnlock");
	end,

	OnExit = function()
	end,
	
	Update = function()
		if (UIManager:GetUIComponent("JadeUnlock", "Motion"):IsDone()) then			
			ScrollManager:SwitchCategory(SCROLL_CAT_JADE, true);
			ScrollManager:UpdateTargetScroll(LevelManager:ResetUnlockedJade());
			
			UIManager:GetWidget("ScrollSelect", "Category"):Reselect(2);
			UIManager:ToggleUI("JadeUnlock");
			
			StageManager:ChangeStage("ScrollSelectAction");
			ShowFeedbackUI();
		end
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostScrollSelect",
    ui = "ScrollSelect",
	
	OnEnter = function()
		ScrollManager:ExitOnMotion();
		UIManager:GetUI("ScrollSelect"):LockAllWidgets(true);
	end,

	OnExit = function()
		UIManager:GetUI("ScrollSelect"):LockAllWidgets(false);
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("ScrollSelect", "Scroll1", "Motion"):IsDone()) then
			StageManager:ChangeStage("PreInGameDoor");
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostScrollSelectExit",
    ui = "ScrollSelect",
	
	OnEnter = function()
		ScrollManager:RefundAllScroll();
		ScrollManager:ExitOnMotion();
		UIManager:GetUI("ScrollSelect"):LockAllWidgets(true);
	end,

	OnExit = function()
		UIManager:GetUI("ScrollSelect"):LockAllWidgets(false);
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("ScrollSelect", "Scroll1", "Motion"):IsDone()) then
			StageManager:ChangeStage("PreEndlessMap");
			AudioManager:CreateBgmList(GAME_MENU_BGM);
			AudioManager:PlayBgm(BGM_MAIN_MENU_ON);
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreInGameDoor",
	ui = "InGame",
    
	OnEnter = function()
	--log("enter @ PreInGameDoor")
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("opening_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("opening_right");

		EnterGame();
	end,

	OnExit = function()
	--log("exit @ PreInGameDoor")		
		UIManager:ToggleUI("Door");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("opened_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("opened_right")) then
			StageManager:ChangeStage("PreInGameDynamicScene");
		end
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreInGameDynamicScene",
	ui = "InGame",

	OnEnter = function()
	--log("PreInGameDynamicScene @ enter")
		UIManager:GetWidgetComponent("GameCountdown", "LevelText", "StateMachine"):ChangeState("show_ready");
		UIManager:ToggleUI("GameCountdown");
	end,

	OnExit = function()
	--log("PreInGameDynamicScene @ exit")
		UIManager:ToggleUI("GameCountdown");
	end,

	Update = function()
		LevelManager:UpdateAvatarStartRunning();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreInGameBgm",
	ui = "InGame",
    
	OnEnter = function()
	--log("PreInGameBgm @ enter")
	end,

	OnExit = function()
	end,

	TouchBegan = function(x, y)
		BladeManager:ResetStatus(x, y);
  	end,

	TouchMoved = function(x, y)
		BladeManager:Attack(x, y);
	end,

	TouchEnded = function(x, y)
		BladeManager:SwitchWeapon(x, y);
	end,

	Update = function()
		LevelManager:UpdateAvatarForBgm();
		
		UpdateGameObjects();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "InGame",
	ui = "InGame",
    
	OnEnter = function()
	--log("InGame @ enter")
	end,

	OnExit = function()
	end,

	TouchBegan = function(x, y)
		BladeManager:ResetStatus(x, y);
  	end,

	TouchMoved = function(x, y)
		BladeManager:Attack(x, y);
	end,

	TouchEnded = function(x, y)
		BladeManager:SwitchWeapon(x, y);
	end,

	Update = function()
		UpdateGameObjects();
	end,

	Render = function()
		RenderGameObjects();
--[[ @Weapon Slot Range
		BladeManager.m_WeaponInv:Render();
--]]
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "RevivePause",
	ui = "InGame",
    
	OnEnter = function()
		AudioManager:PlaySfx(SFX_UI_BUTTON_3);
	    UIManager:GetUIComponent("Revive", "StateMachine"):ChangeState("inactive");
	    UIManager:ToggleUI("Revive");
		EnableUpdateGameObjects(false);
		
        ShowIAPChoices();
	end,

	OnExit = function()
		EnableUpdateGameObjects(true);
	end,

	Update = function()
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "GamePause",
	ui = "InGame",
    
	OnEnter = function()
		LevelManager:HideBoostUI();
		SwitchGamePauseUI(true);		
		
		EnableUpdateGameObjects(false);
		UIManager:ToggleUI("GamePause");
	end,

	OnExit = function()
		EnableUpdateGameObjects(true);
		UIManager:ToggleUI("GamePause");
	end,

	Update = function()
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreResumeGame",
	ui = "InGame",

	OnEnter = function()
		EnemyManager:ResetCombo();
		BladeManager:ResetCriticalHit();
		
		EnableUpdateGameObjects(false);
		UIManager:GetWidgetComponent("GameCountdown", "LevelText", "StateMachine"):ChangeState("show_ready");
		UIManager:ToggleUI("GameCountdown");
	end,

	OnExit = function()
		EnableUpdateGameObjects(true);
		UIManager:ToggleUI("GameCountdown");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("GameCountdown", "LevelText", "StateMachine"):IsCurrentState("done")) then
			StageManager:ChangeStage("InGame");
		end
	end,

	Render = function()
		RenderGameObjects();
		
		DrawFullscreenMask(0, 0, SCREEN_UNIT_X, SCREEN_UNIT_Y, 0.1, 0.1, 0.1, ALPHA_THREEQUARTER);
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreExitGame",
	ui = "InGame",
    
	OnEnter = function()
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			ExitGameFromPauseMenu();
		end
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreGameScroll",
	ui = "InGame",
    
	OnEnter = function()
		UIManager:ToggleUI("PreGameScroll");
		ScrollManager:EnterStage();
	end,

	OnExit = function()
		UIManager:ToggleUI("PreGameScroll");
	end,

	Update = function()
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "GameScroll",
	ui = "InGame",
    
	OnEnter = function()
		UIManager:ToggleUI("GameScroll");
		ScrollManager:StartScrollEffect();
	end,

	OnExit = function()
		ScrollManager:ExitStage();
		UIManager:ToggleUI("GameScroll");
	end,

	Update = function()
		ScrollManager:UpdateScroll();
	end,

	Render = function()
		RenderGameObjects();
		ScrollManager:RenderScroll();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "GameRevive",
	ui = "InGame",
    
	OnEnter = function()
	--log("GameRevive @ enter")		
		UIManager:ToggleUI("Revive");
		UIManager:GetUIComponent("Revive", "StateMachine"):ChangeState("show");
	end,

	OnExit = function()
	--log("GameRevive @ exit")
	end,

	Update = function()
		UpdateGameObjects();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "GameCountdown",
	ui = "InGame",
    
	OnEnter = function()
	--log("GameCountdown @ enter")
		UIManager:GetWidgetComponent("GameCountdown", "LevelText", "StateMachine"):ChangeState("silent_gameover");
		UIManager:ToggleUI("GameCountdown");
	end,

	OnExit = function()
	--log("GameCountdown @ exit")
		UIManager:ToggleUI("GameCountdown");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("GameCountdown", "LevelText", "StateMachine"):IsCurrentState("done")) then
			StageManager:ChangeStage("PreGameStatDoor");
		end			
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreGameStatDoor",
	ui = "InGame",
    
	OnEnter = function()
	--log("PreGameStatDoor @ enter")
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			ExitGameFromGameOver();			
		end
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreAvatarStat",
	ui = "AvatarStat",
	
	OnEnter = function(state)
		LevelManager:ResetAvatarStat();
		--ListCurrentUsedTextures("AvatarStat");
	end,

	OnExit = function()
		UIManager:ToggleUI("Door");
		UIManager:GetWidgetObject("AvatarStat", "DoorLeft"):Reload();
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "AvatarExp",
	ui = "AvatarStat",
    
	OnEnter = function()
		LevelManager:EnterAccumExpState();
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetUIComponent("AvatarStat", "StateMachine"):IsCurrentState("inactive")) then
			if (LevelManager:GetMedal() > 0) then
				ShowTreasureSelect();
			else
				ShowGameStat();
			end
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreTreasureSelect",
	ui = "TreasureSelect",
    
	OnEnter = function()
		UIManager:ToggleWidgetGroup("TreasureSelect", "AllWidgets", false);
		UIManager:GetWidgetComponent("TreasureSelect", "Background", "StateMachine"):ChangeState("opening");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("TreasureSelect", "Background", "StateMachine"):IsCurrentState("idle")) then
			StageManager:ChangeStage("TreasureSelect");
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "TreasureSelect",
	ui = "TreasureSelect",
    
	OnEnter = function()
		local level = LevelManager:GetMedal();
		
		for i = 1, 3 do
			local w = "Box"..i;
			UIManager:EnableWidget("TreasureSelect", w, true);
			UIManager:GetWidget("TreasureSelect", w):Enable(true);
	        UIManager:GetWidgetComponent("TreasureSelect", w, "Sprite"):SetAnimation(TREASURE_ANIM[level][TREASURE_ANIM_IDLE], true);
			UIManager:SetWidgetTranslate("TreasureSelect", w, TREASURE_ORIGIN[1] + TREASURE_OFFSET * (i - 1), TREASURE_ORIGIN[2]);

			if (i <= level) then
				UIManager:GetWidgetComponent("TreasureSelect", "Medal", "Sprite"):SetImage(i, "ui_stat_medal_02");
			else
				UIManager:GetWidgetComponent("TreasureSelect", "Medal", "Sprite"):SetImage(i, "ui_stat_medal_01");
			end			
		end
		UIManager:EnableWidget("TreasureSelect", "Medal", true);
		UIManager:EnableWidget("TreasureSelect", "TreasureText", true);

		if (level == 3) then
			UIManager:GetWidgetComponent("TreasureSelect", "Medal", "Sprite"):SetImage(4, "ui_stat_reached_3000m");
		elseif (level == 2) then
			UIManager:GetWidgetComponent("TreasureSelect", "Medal", "Sprite"):SetImage(4, "ui_stat_reached_1500m");
		else -- level == 1
			UIManager:GetWidgetComponent("TreasureSelect", "Medal", "Sprite"):SetImage(4, "ui_stat_reached_500m");
		end
		
		AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
	    --ListCurrentUsedTextures("TreasureSelect");
	end,

	OnExit = function()
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostTreasureSelect",
	ui = "TreasureSelect",
    
	OnEnter = function()
		UIManager:ToggleWidgetGroup("TreasureSelect", "AllWidgets", false);
		UIManager:GetWidgetComponent("TreasureSelect", "Background", "StateMachine"):ChangeState("close_wait");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("TreasureSelect", "Background", "StateMachine"):IsCurrentState("inactive")) then
			ShowGameStat();
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreGameStat",
	ui = "GameStat",
    
	OnEnter = function()
		UIManager:ToggleWidgetGroup("GameStat", "AllWidgets", false);
		UIManager:GetWidgetComponent("GameStat", "Background", "StateMachine"):ChangeState("opening");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("GameStat", "Background", "StateMachine"):IsCurrentState("idle")) then
			GotoGameStat();
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "GameStat",
	ui = "GameStat",
    
	OnEnter = function()
		--ListCurrentUsedTextures("GameStat");
	end,

	OnExit = function()
	end,

	Update = function()
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostGameStat",
	ui = "GameStat",
    
	OnEnter = function()
		UIManager:ToggleWidgetGroup("GameStat", "AllWidgets", false);
		UIManager:GetWidgetComponent("GameStat", "Background", "StateMachine"):ChangeState("close_wait");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("GameStat", "Background", "StateMachine"):IsCurrentState("inactive")) then
			StageManager:ChangeStage(StageManager:GetStageState());
			--ListCurrentUsedTextures("PostGameStat");
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PostEndlessMapToTutorial",
	ui = "EndlessMap",
	
	OnEnter = function()
		UIManager:ToggleUI("Door");

		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("closing_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("closing_right");
	end,

	OnExit = function()
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("closed_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("closed_right")) then
			AudioManager:ToggleCurrentBgm(false);
			StageManager:ChangeStage("PreInGameDoorTutorial");
		end
	end,

	Render = function()
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "PreInGameDoorTutorial",
	ui = "InGame",
    
	OnEnter = function()
	--log("enter @ PreInGameDoorTutorial")
		--UIManager:ToggleUI("Door");
		UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):ChangeState("opening_left");
		UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):ChangeState("opening_right");
		
		UIManager:EnableWidget("InGame", "DistanceCounter", false);

		EnterGame();
	end,

	OnExit = function()
	--log("exit @ PreInGameDoorTutorial")		
		UIManager:ToggleUI("Door");
	end,

	Update = function()
		if (UIManager:GetWidgetComponent("Door", "DoorLeft", "StateMachine"):IsCurrentState("opened_left") and
			UIManager:GetWidgetComponent("Door", "DoorRight", "StateMachine"):IsCurrentState("opened_right")) then
			StageManager:ChangeStage("TutorialBegin");
		end
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "TutorialBegin",
	ui = "InGame",
    
	OnEnter = function()
	--log("enter @ TutorialBegin")
		UIManager:GetWidgetComponent("GameCountdown", "LevelText", "StateMachine"):ChangeState("show_ready");
		UIManager:ToggleUI("GameCountdown");
		TutorialManager:PreStart();
	end,

	OnExit = function()
	--log("exit @ TutorialBegin")
		TutorialManager:Start();
		UIManager:ToggleUI("GameCountdown");
	end,

	Update = function()
		LevelManager:UpdateAvatarTutorial();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "TutorialWait",
	ui = "InGame",
    
	OnEnter = function()
	--log("..... TutorialWait .....")
	end,

	OnExit = function()
	--log("TutorialWait <<<<<< exit")
	end,

	Update = function()
		TutorialManager:Update();
		UpdateGameObjectsTutorial();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "TutorialAction",
	ui = "InGame",
    
	OnEnter = function()
	--log("TutorialAction >>> enter")
	end,

	OnExit = function()
	--log("TutorialAction exit")
	end,

	TouchBegan = function(x, y)
		BladeManager:ResetStatus(x, y);
  	end,

	TouchMoved = function(x, y)
		BladeManager:Attack(x, y);
	end,

	TouchEnded = function(x, y)
		BladeManager:SwitchWeapon(x, y);
	end,

	Update = function()
		TutorialManager:Update();
		UpdateGameObjectsTutorial();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "TutorialPause",
	ui = "InGame",
    
	OnEnter = function()
	--log("TutorialPause >>> enter")
		AudioManager:PlaySfx(SFX_OBJECT_JADE);
		UIManager:ToggleWidgetGroup("Tutorial", "AllWidgets", false);
		UIManager:EnableWidget("Tutorial", "Screen", true);
	end,

	OnExit = function()
	--log("TutorialPause exit")
	end,

	Update = function()
		TutorialManager:Update();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "TutorialTap",
	ui = "InGame",
    
	OnEnter = function()
	--log("TutorialTap >>> enter")
		UIManager:EnableWidget("Tutorial", "Continue", true);
	end,

	OnExit = function()
	--log("TutorialTap exit")
		UIManager:EnableWidget("Tutorial", "Continue", false);
	end,

	TouchBegan = function(x, y)
  	end,

	TouchMoved = function(x, y)
	end,

	TouchEnded = function(x, y)
		AudioManager:PlaySfx(SFX_UI_BUTTON_3);
		TutorialManager:Activate();
	end,

	Update = function()
		UpdateGameObjectsTutorial();
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "TutorialTapPaused",
	ui = "InGame",
    
	OnEnter = function()
	--log("TutorialTapPaused >>> enter")
		UIManager:EnableWidget("Tutorial", "Continue", true);
	end,

	OnExit = function()
	--log("TutorialTapPaused exit")
		UIManager:EnableWidget("Tutorial", "Continue", false);
		UIManager:EnableWidget("Tutorial", "Screen", false);
	end,

	TouchBegan = function(x, y)
  	end,

	TouchMoved = function(x, y)
	end,

	TouchEnded = function(x, y)
		AudioManager:PlaySfx(SFX_UI_BUTTON_3);
		TutorialManager:Activate();
	end,

	Update = function()
	end,

	Render = function()
		RenderGameObjects();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "SendFeedback",
	ui = "SendFeedback",
    
	OnEnter = function()
		PopupUI("SendFeedback");
	end,

	OnExit = function()
	end,

	TouchEnded = function(x, y)
		AudioManager:PlaySfx(SFX_UI_BUTTON_2);
		StageManager:PopStageForPopup();
	end,
};

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "SendLove",
	ui = "SendLove",
    
	OnEnter = function()
		PopupUI("SendLove");
	end,

	OnExit = function()
	end,

	TouchEnded = function(x, y)
		AudioManager:PlaySfx(SFX_UI_BUTTON_2);
		StageManager:PopStageForPopup();
	end,
};

--[[
--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "Gift",
	ui = "MainEntry",
    
	OnEnter = function()
        CycleGORotate(UIManager:GetWidgetObject("Gift", "AvatarShine"), 0, 1, 3000);
		AudioManager:PlaySfx(SFX_UI_BEST_SCORE);
		
		local x, y = UIManager:GetUITranslate("Gift");
		UIManager:SetWidgetTranslate("Gift", "Action", -x, -y);		
        UIManager:ToggleUI("Gift");
	end,

	OnExit = function()
        UIManager:ToggleUI("Gift");
	end,
};
--]]
