--***********************************************************************
-- @file GameLogic.lua
--***********************************************************************

-------------------------------------------------------------------------
function InitializeGame()

    math.randomseed(os.clock());

    --###########
    -- Object
    --###########
    
    g_RenderQueue = {};
    g_PreRenderQueue = {};
    g_PostRenderQueue = {};

    --###########
    -- Manager
    --###########

    log("=== Starting init managers ===")
    
    IOManager:Create(IO_MAIN_DATA, true);
    if (APP_DEBUG_MODE) then
        IOManager:Dump();
    end
    
    GameDataManager = DataManager:Create();
    
    AudioManager:Create();

    EnemyManager:Create();
    
    BladeManager:Create();
    
    ScrollManager:Create();

    ShopManager:Create();
    
    LevelManager:Create();
    
    MoneyManager:Create();
    
    SocialManager:Create();

    TutorialManager:Create();

    log("=== Ending init managers ===")

    --###########
    -- UI
    --###########
    ResetDropdownUI("JadeUnlock");
    ResetDropdownUI("ScrollUnlock");
    ResetDropdownUI("LevelUnlock");
    ResetDropdownUI("ShopUpgrade");
    
    -- iCloud
    UpdateiCloudButton();

    -- Special case: Credit UI
    local w, h = UIManager:GetWidgetComponent("Info", "Content", "Sprite"):GetSize();
    UI_CREDIT_POS[1] = (SCREEN_UNIT_X - w) * 0.5;
    UI_CREDIT_POS[2] = (SCREEN_UNIT_Y - h * 0.75) * 0.5;
    UIManager:SetWidgetTranslate("Info", "Content", UI_CREDIT_POS[1] + SCREEN_UNIT_X, UI_CREDIT_POS[2]);

    --###########
    -- Filtered textures
    --###########
    InsertFilteredTexture("effect_magic.png");
    InsertFilteredTexture("object.png");
    InsertFilteredTexture("ui_widget.png");
    
    --###########
    -- Stage
    --###########
    StageManager:ChangeStage("Logo");
end

--=======================================================================
-- Serialization delegate
--=======================================================================

-------------------------------------------------------------------------
function ResetDefaultDataDelegate()
    local dataSet = {};
    
    --==================================
    -- Hack
    --==================================
    dataSet[IO_CAT_HACK] = {};
    local ds = dataSet[IO_CAT_HACK];
    
    ds["Money"] = {};
    ds["Money"]["Koban"] = 10;
    ds["Money"]["Coin"] = 200;
    ds["Money"]["TimeStamp"] = 0;

    ds["Weapon"] = {};
    ds["Weapon"][WEAPON_TYPE_KATANA] = 1;
    ds["Weapon"][WEAPON_TYPE_BLADE] = 1;
    ds["Weapon"][WEAPON_TYPE_SPEAR] = 1;

    ds["Scroll"] = {};
    ds["Scroll"][1] = 1;
    ds["Scroll"]["Unlock"] = nil;

    ds["Jade"] = {};
    ds["Jade"]["Equip"] = 0;
    ds["Jade"]["Unlock"] = nil;

    ds["Avatar"] = {};
    ds["Avatar"][1] = 1;
    ds["Avatar"]["Equip"] = 1;
    
    ds["AvatarLv"] = {};
    ds["AvatarLv"][1] = 1;

    ds["AvatarExp"] = {};
    ds["AvatarExp"][1] = 0;
   
    ds["Boost"] = {};
    ds["Boost"]["Initial"] = 0;

    ds["Treasure"] = {};
    ds["Treasure"]["Chance"] = 70;

    ds["Pocket"] = {};
    ds["Pocket"]["Count"] = 0;
    
    --ds["StarterKit"] = nil;
    
--[[ @Paid App Badge
    ds["MonkeyPotion"] = true;
--]]

    --==================================
    -- Content
    --==================================
    dataSet[IO_CAT_CONTENT] = {};
    local ds = dataSet[IO_CAT_CONTENT];
    
    ds["Level"] = {};
    ds["Level"]["Normal"] = {};
    ds["Level"]["Shadow"] = {};
    ds["Level"]["Difficulty"] = GAME_DIFF_NORMAL;
    ds["Level"]["LastEntered"] = 0;

    ds["Tutorial"] = {};
    ds["Tutorial"]["Completed"] = false;
    ds["Tutorial"]["TipShown"] = false;
    ds["Tutorial"]["Count"] = 0;

    ds["Achievement"] = {};

    ds["Feedback"] = {};
    ds["Feedback"]["Rating"] = nil;
    ds["Feedback"]["Showup"] = nil;
    ds["Feedback"]["Distance"] = 0;
    ds["Feedback"]["NextFeedbackDistance"] = FEEDBACK_DISTANCE_INITIAL;
    ds["Feedback"]["GameCount"] = 0;
    ds["Feedback"]["NextFeedbackGameCount"] = FEEDBACK_GAMECOUNT_INITIAL;
    
    --ds["BossChance"] = 0;
    --ds["AdChance_GameStat"] = 0;
    --ds["AdChance_EndlessMap"] = 0;

    --==================================
    -- Option
    --==================================
    dataSet[IO_CAT_OPTION] = {};
    local ds = dataSet[IO_CAT_OPTION];
    
    ds["Audio"] = {};
    ds["Audio"]["Bgm"] = true;
    ds["Audio"]["Sfx"] = true;
    --ds["Audio"]["Vibrate"] = false;
    ds["Handset"] = DEFAULT_HAND_SET;
 
    --==================================
    -- Stat
    --==================================
    dataSet[IO_CAT_STAT] = {};
    dataSet[IO_CAT_STAT]["Player"] = {};

    --==================================
    -- TESTING
    --==================================
    if APP_DEBUG_MODE then
        local ds = dataSet[IO_CAT_HACK];
        
        ds["Weapon"][WEAPON_TYPE_KATANA] = 5;
        ds["Weapon"][WEAPON_TYPE_BLADE] = 5;
        ds["Weapon"][WEAPON_TYPE_SPEAR] = 5;

        ds["Boost"]["Initial"] = 2500;

        ds["Money"]["Koban"] = 500;
        ds["Money"]["Coin"] = 30000;

        for i = 1, SCROLL_MAX do
            ds["Scroll"][i] = 1;
        end

        --for i = 1, JADE_MAX do
        for i = 1, JADE_MAX - 1 do
            ds["Jade"][i] = 1;
        end

        --for i = 1, AVATAR_MAX do
        for i = 1, AVATAR_MAX - 1 do
            ds["Avatar"][i] = 1;
            ds["AvatarLv"][i] = 1;
            ds["AvatarExp"][i] = 0;
        end

        local ds = dataSet[IO_CAT_CONTENT];
        ds["Tutorial"]["Completed"] = true;
        --ds["Level"]["Normal"][1] = { Distance = 100, Coin = 0, Score = 100, Medal = 0, };
        ds["Level"]["Normal"][1] = { Distance = 500, Coin = 0, Score = 100, Medal = 1, };
        
        ds["Level"]["Normal"][1] = { Distance = 3000, Coin = 0, Score = 100000, Medal=3, };
        ds["Level"]["Normal"][2] = { Distance = 3000, Coin = 0, Score = 100000, Medal=3, };
        ds["Level"]["Normal"][3] = { Distance = 3000, Coin = 0, Score = 100000, Medal=3, };
        ds["Level"]["Normal"][4] = { Distance = 3000, Coin = 0, Score = 100000, Medal=3, };
        ds["Level"]["Normal"][5] = { Distance = 3000, Coin = 0, Score = 100000, Medal=3, };
        ds["Level"]["Shadow"][1] = { Distance = 3000, Coin = 0, Score = 1000000, Medal=3, };
        ds["Level"]["Shadow"][1] = { Distance = 3000, Coin = 0, Score = 1000000, Medal=3, };
        ds["Level"]["Shadow"][2] = { Distance = 3000, Coin = 0, Score = 1000000, Medal=3, };
        ds["Level"]["Shadow"][3] = { Distance = 3000, Coin = 0, Score = 1000000, Medal=3, };
        ds["Level"]["Shadow"][4] = { Distance = 3000, Coin = 0, Score = 1000000, Medal=3, };
        ds["Level"]["Shadow"][5] = { Distance = 3000, Coin = 0, Score = 1000000, Medal=3, };
    end

    return dataSet;
end

-------------------------------------------------------------------------
function OnCloudSaveFileReceived(data)
	log("=======OnCloudSaveFileReceived======")
    if (IOManager:GetRecord(IO_CAT_OPTION, "iCloud") ~= true) then
        log("iCloud status : DISABLED")
        return;
    end
    
    --local luabins_data = { luabins.load(data) };
    --assert(luabins_data[1], luabins_data[2]);
    --log("LUABINS [result]: ".. tostring(luabins_data[1]))
    
        --log("[Deserialization] " .. fullPath);
    local fullPath = GaoApp.MakeDocumentPath(IO_ICLOUD_DATA);    
    local file = io.open(fullPath, "r");
        
    if (file) then
        io.input(file);

        local data = file:read("*a");
        assert(data, "Data deserialization error");
        io.close(file);

        local icloud_data = { luabins.load(data) };
        assert(icloud_data[1], icloud_data[2]);
--[[ @DEBUG
        DumpTable(icloud_data[2], "iCloud SAVE");
--]]        
        ResolveConflictForSaveFile(icloud_data[2]);
    end
	--log("=======OnCloudSaveFileReceived END ======")
end

-------------------------------------------------------------------------
function ResolveConflictForSaveFile(cloudData)
--[[
    if (IOManager:GetRecord(IO_CAT_OPTION, "iCloud") ~= true) then
        log("iCloud status : DISABLED => later use")
        GameDataManager:SetData("CloudData", cloudData);
        return;
    end
--]]
    local hack = cloudData[IO_CAT_HACK];
    local cont = cloudData[IO_CAT_CONTENT];
    local stat = cloudData[IO_CAT_STAT];
    
    -- Money
    local recMoney = IOManager:GetRecord(IO_CAT_HACK, "Money");
    local localStamp = recMoney["TimeStamp"] or 0;
    local cloudStamp = hack["Money"]["TimeStamp"] or 0;
    if (localStamp < cloudStamp) then
    log("Money : override")
    log("  => Koban @ "..recMoney["Koban"].." => "..hack["Money"]["Koban"]);
    log("  => Coin @ "..recMoney["Coin"].." => "..hack["Money"]["Coin"]);
        recMoney["Koban"] = hack["Money"]["Koban"];
        recMoney["Coin"] = hack["Money"]["Coin"];
        recMoney["TimeStamp"] = hack["Money"]["TimeStamp"];
        MoneyManager:SetCoin(recMoney["Coin"]);
        MoneyManager:SetKoban(recMoney["Koban"]);
    else
    log("Money : n/a");
    end
    
    -- Avatar
    local recAvatar = IOManager:GetRecord(IO_CAT_HACK, "Avatar");
    local recAvatarLv = IOManager:GetRecord(IO_CAT_HACK, "AvatarLv");
    local recAvatarExp = IOManager:GetRecord(IO_CAT_HACK, "AvatarExp");
    for i = 1, AVATAR_MAX do
        if (recAvatar[i]) then
        log("Avatar #"..i.." : existed")
            local cloudAvLv = hack["AvatarLv"][i] or 0;
            if (recAvatarLv[i] <= cloudAvLv) then
                recAvatarLv[i] = cloudAvLv;
                recAvatarExp[i] = hack["AvatarExp"][i];
            end        
        else
        log("Avatar #"..i.." : override")
            recAvatar[i] = hack["Avatar"][i];
            recAvatarLv[i] = hack["AvatarLv"][i];
            recAvatarExp[i] = hack["AvatarExp"][i];
        end
        
        IOManager:SetValue(IO_CAT_HACK, "Avatar", "Equip", hack["Avatar"]["Equip"]);
    end
    
    -- Jade
    local recJade = IOManager:GetRecord(IO_CAT_HACK, "Jade");
    local needUpdateShopJade = false;
    for i = 1, JADE_MAX do
        local cloudJade = hack["Jade"] or 0;
        if (recJade[i]) then
        log("Jade #"..i.." : existed")
            if (recJade[i] < cloudJade[i]) then
                recJade[i] = cloudJade[i];
                needUpdateShopJade = true;
            end
        else
        log("Jade #"..i.." : override")
            recJade[i] = cloudJade[i];
            needUpdateShopJade = true;
        end
    end
    if (needUpdateShopJade) then
        ShopManager:UpdateJadeItems();
    end
    
    -- Weapon
    local recWeapon = IOManager:GetRecord(IO_CAT_HACK, "Weapon");
    for i = 1, WEAPON_MAX do
        local cloudWeapon = hack["Weapon"];
        if (recWeapon[i] < cloudWeapon[i]) then
        log("Weapon #"..i.." : override")
            recWeapon[i] = cloudWeapon[i];
            needUpdateShopWeapon = true;
        else
        log("Weapon #"..i.." : n/a")
        end        
    end
    if (needUpdateShopWeapon) then
        ShopManager:UpdateWeaponItems();
    end

    -- Scroll
    local recScroll = IOManager:GetRecord(IO_CAT_HACK, "Scroll");
    for i = 2, SCROLL_MAX do
        if (hack["Scroll"][i] == 1) then
        log("Scroll #"..i.." : override")
            recScroll[i] = 1;
        end
    end
    
    -- Starter Kit
    if (hack["StarterKit"] == true) then
        IOManager:SetRecord(IO_CAT_HACK, "StarterKit", true);
    end
    -- Boost
    if (hack["Boost"]["Initial"] == true) then
        IOManager:SetValue(IO_CAT_HACK, "Boost", "Initial", true);
    end
    -- Treasure
    if (IOManager:GetValue(IO_CAT_HACK, "Treasure", "Chance") > hack["Treasure"]["Chance"]) then
        IOManager:SetValue(IO_CAT_HACK, "Treasure", "Chance", hack["Treasure"]["Chance"]);
    end
    -- Pocket
    if (IOManager:GetValue(IO_CAT_HACK, "Pocket", "Count") < hack["Pocket"]["Count"]) then
        IOManager:SetValue(IO_CAT_HACK, "Pocket", "Count", hack["Pocket"]["Count"]);
    end

    -- Tutorial
    local recTut = IOManager:GetRecord(IO_CAT_CONTENT, "Tutorial");
    if (recTut["Completed"] == false) then
        recTut["Completed"] = cont["Tutorial"]["Completed"];
        recTut["TipShown"] = cont["Tutorial"]["TipShown"];
        recTut["Count"] = cont["Tutorial"]["Count"];
    end
    
    -- Level
    local recLv = IOManager:GetRecord(IO_CAT_CONTENT, "Level");
    local diffSet = { "Normal", "Shadow" };
    for i = 1, LEVEL_MAX do
        for j = 1, 2 do  -- Game difficulty
            local diff = diffSet[j];
            local cloudLevel = cont["Level"][diff][i];
            if (cloudLevel) then
                local rec = recLv[diff][i];
                if (rec) then
                log(diff.." Level #"..i.." : existed")
                    if (rec["Distance"] < cloudLevel["Distance"]) then
                        rec["Distance"] = cloudLevel["Distance"];
                    end
                    if (rec["Score"] < cloudLevel["Score"]) then
                        rec["Score"] = cloudLevel["Score"];
                    end
                    if (rec["Medal"] < cloudLevel["Medal"]) then
                        rec["Medal"] = cloudLevel["Medal"];
                    end
                else
                log(diff.." Level #"..i.." : new")
                    recLv[diff][i] = { Distance = cloudLevel["Distance"], Coin = cloudLevel["Coin"], Score = cloudLevel["Score"], Medal = cloudLevel["Medal"], };
                    
                    if (LevelManager:GetGameDifficulty() == j) then
                        UIManager:GetWidgetComponent("EndlessMap", "Map"..i, "Sprite"):EnableRender(UM_LOCK, false);
                    end
                end
            end
        end
    end
    
    -- Stat/Achievements
    local recStat = IOManager:GetRecord(IO_CAT_STAT, "Player");
    local recAch = IOManager:GetRecord(IO_CAT_CONTENT, "Achievement");
    local localStat = recStat[GAME_STAT_PLAY_COUNT] or 0;
    local cloudStat = stat["Player"][GAME_STAT_PLAY_COUNT] or 0;
    if (localStat < cloudStat) then
    log("Stat/Ach ".." : override")
        for k, _ in pairs(stat["Player"]) do
            recStat[k] = v;
        end
        
        for k, v in pairs(cont["Achievement"]) do
            recAch[k] = v;
        end
    else
    log("Stat/Ach ".." : n/a")
    end
    
    IOManager:Save();
    
    AudioManager:PlaySfx(SFX_CHAR_KABUKI_TRAP);
    GameKit.ShowMessage("text_status", "icloud_sync");
end

--=======================================================================
-- Game Resources
--=======================================================================

-------------------------------------------------------------------------
function RegisterLocalNotifications()
    local notifMsgDuration = NOTIF_MSG_NORMAL;
---[[ @Challenge
    if (LevelManager:IsChallengeModeUnlocked()) then
        local hasOpened, timeRemaining = LevelManager:IsChallengeOpened();
        if (hasOpened) then
            --log("[Opened] Notif Time: "..DAILY_CHALLENGE_DURATION.." sec")
            GameKit.ScheduleLocalNotification("notif_challenge", DAILY_CHALLENGE_DURATION);
        else
            --log("Notif Time: "..timeRemaining.." sec")
            GameKit.ScheduleLocalNotification("notif_challenge", timeRemaining);
        end
        notifMsgDuration = NOTIF_MSG_CHALLENGE;
    end
--]]
    assert(#notifMsgDuration <= NOTIF_MSG_MAX_COUNT * 2);
    
    local t = {};
    for i = 1, NOTIF_MSG_MAX_COUNT do
        t[i] = i;
    end

    local msgBoss;
    local bossKilledCount = IOManager:GetValue(IO_CAT_STAT, "Player", GAME_STAT_BOSS_KILL);
    if (bossKilledCount ~= nil and bossKilledCount > 0) then
        msgBoss = string.format("%s%d%s", GameKit.GetLocalizedString(NOTIF_MSG_BOSS_P1), bossKilledCount, GameKit.GetLocalizedString(NOTIF_MSG_BOSS_P2));
    else
        msgBoss = NOTIF_MSG_NO_BOSS;
    end

    for i = 1, #notifMsgDuration do
        local msg;
        if (i % 2 == 0) then
            msg = msgBoss;
        else
            local index = math.random(1, #t);
            local value = table.remove(t, index);
            msg = NOTIF_MSG_PREFIX .. value;
        end

        --log("msg ["..i.."] "..msg.." @ time: "..notifMsgDuration[i])
        GameKit.ScheduleLocalNotification(msg, notifMsgDuration[i]);
    end

    GameKit.ScheduleLocalNotification(NOTIF_MSG_BYE, DURATION_DAY_LAST);
end

-------------------------------------------------------------------------
function ResetGameResource()
    EnemyManager:Reset();
    LevelManager:Reset();
    AudioManager:Reset();
    
    g_RenderQueue = {};
    g_PreRenderQueue = {};
    g_PostRenderQueue = {};

    CollectGarbage("collect");
end

-------------------------------------------------------------------------
function ReloadGameResource()
    --log("\n=====ReloadGameResource=====")
    
    LevelManager:Reload();
	EnemyManager:Reload();
	BladeManager:Reload();
    ScrollManager:Reload();
    
    --log("=====ReloadGameResource=====\n")
end

-------------------------------------------------------------------------
function UnloadGameResource()
    --log("\n=====UnloadGameResource=====")

    LevelManager:Unload();
	EnemyManager:Unload();
	BladeManager:Unload();
    ScrollManager:Unload();

    --log("=====UnloadGameResource=====\n")
end

-------------------------------------------------------------------------
function PauseGame(doPause)
    if (doPause) then
        StageManager:PushStage("GamePause");
    else
        StageManager:PopStage();
        
        if (not TutorialManager:IsInProcessing()) then
            StageManager:ChangeStage("PreResumeGame");
        end
    end
end

-------------------------------------------------------------------------
function EnterEndlessMap()
    AudioManager:PlaySfx(SFX_UI_SWITCH_WEAPON_2);
    UIManager:GetWidgetComponent("MainEntry", "Play", "StateMachine"):ChangeState("inactive");
    UIManager:GetWidgetComponent("MainEntry", "Hand", "StateMachine"):ChangeState("reset");

    ShopManager:ShowShopIcon();
    LevelManager:RepositionMap();
    LevelManager:UpdateChallengeModeStatus();
    
    StageManager:ChangeStageWithMotion("MainEntry", "EndlessMap", 0, -APP_HEIGHT);
end

-------------------------------------------------------------------------
function EnterGame()
    log("\n***********EnterGame************")
    
    ReloadGameResource();

    BladeManager:Reset();
    
    LevelManager:Start();

    --ListCurrentUsedTextures("EnterGame");
end

-------------------------------------------------------------------------
function ExitGame()
    LevelManager:Stop();
    
    UnloadGameResource();
    
    g_TaskManager:Clear();
    
    --log("\n***********ExitGame************")
    --ListCurrentUsedTextures("ExitGame");
end

-------------------------------------------------------------------------
function ExitGameFromPauseMenu()
    TutorialManager:Exit();
    
    ResetGameResource();
    StageManager:ChangeStage("PreEndlessMap");
    
    ExitGame();
end

-------------------------------------------------------------------------
function ExitGameFromGameOver()
    ExitGame();
	StageManager:ChangeStage("PreAvatarStat");
end

-------------------------------------------------------------------------
function GotoScrollSelect()
    ResetGameResource();
    LevelManager:EnterMapAgain();
end

-------------------------------------------------------------------------
function GotoMapSelect()
    ResetGameResource();
	StageManager:ChangeStage("PostGameStat", "PreEndlessMap");
end

-------------------------------------------------------------------------
function GotoShop()
    ResetGameResource();
	StageManager:ChangeStage("PostGameStat", "ShopOpenDoor");
end

--=======================================================================
-- @Misc
--=======================================================================

-------------------------------------------------------------------------
function SwitchGamePauseUI(enable)
    UIManager:EnableWidget("GamePause", "Resume", enable);
    UIManager:EnableWidget("GamePause", "Exit", enable);
    UIManager:EnableWidget("GamePause", "Bgm", enable);
    UIManager:EnableWidget("GamePause", "Sfx", enable);
    --UIManager:EnableWidget("GamePause", "Vibrate", enable);
    --UIManager:GetWidgetComponent("GamePause", "Backdrop", "Sprite"):EnableRender(2, enable);
    UIManager:EnableWidget("GamePause", "Backdrop", enable);

    UIManager:EnableWidget("GamePause", "Message", not enable);
    UIManager:EnableWidget("GamePause", "Yes", not enable);
    UIManager:EnableWidget("GamePause", "No", not enable);
end

-------------------------------------------------------------------------
function ToggleMainMenuGears()
    local state = not GameDataManager:GetData("GearState");
    GameDataManager:SetData("GearState", state);
    
    if (state) then
        UIManager:GetWidgetComponent("MainEntry", "Gear", "Sprite"):SetAnimation("ui_mainmenu_gear_on", true);
        UIManager:ToggleWidgetGroup("MainEntry", "GearOptions", true);
    else
        UIManager:GetWidgetComponent("MainEntry", "Gear", "Sprite"):SetAnimation("ui_mainmenu_gear_off", true);
        UIManager:ToggleWidgetGroup("MainEntry", "GearOptions", false);
    end
end

-------------------------------------------------------------------------
function ChangeMapTitle(go, args)
    --log("ChangeMapTitle @ "..args)
    if (go) then
        AudioManager:PlaySfx(SFX_UI_BUTTON_3);
    end
    LevelManager:ResetMapButtons(args - 1);

    if (args >= 1 and args <= LEVEL_DIFFICULTY_INDEX) then
        UIManager:GetWidget("EndlessMap", "Title"):SetImage("ui_map_title".. args - 1);
        UIManager:EnableWidget("EndlessMap", "Title", true);
        
        if (go) then
            local interGC = UIManager:GetWidgetComponent("EndlessMap", "Title", "Interpolator");
            interGC:ResetTarget(0.9, 1.1, 100);
            interGC:AppendNextTarget(1.1, 1.0, 75);
        end
    else
        UIManager:EnableWidget("EndlessMap", "Title", false);
    end
end

-------------------------------------------------------------------------
function PopupUI(name)
	local interGC = UIManager:GetUIComponent(name, "Interpolator");
	interGC:ResetTarget(0.8, 1.05, 350);
	interGC:AppendNextTarget(1.05, 1.0, 150);
	interGC:AppendNextTarget(1.0, 1.01, 70);
	interGC:AppendNextTarget(1.01, 1.0, 70);
	interGC:AttachUpdateCallback(UpdateScaleAndAlpha, UIManager:GetUI(name));

	AudioManager:PlaySfx(SFX_OBJECT_BOOST);
end

-------------------------------------------------------------------------
function UpdateScaleAndAlpha(value, ui)
	ui:ScaleAllWidgets(value);
	ui:SetAllWidgetsAlpha((value - 0.8) * 5);	
end

--[[
-------------------------------------------------------------------------
function OnMoviePlaybackCompleted()
    --log("OnMoviePlaybackCompleted");
    g_TaskManager:AddTask(TimeDelayTask, 1000, 0);
    g_TaskManager:AddTask(StageChangeTask, "PreInGameDoorTutorial", 0, 1000);
end
--]]
-------------------------------------------------------------------------
function OnOPMoviePlaybackCompleted()
    g_TaskManager:AddTask(TimeDelayTask, 1000, 0);
    g_TaskManager:AddTask(StageChangeTask, "PreInGameDoorTutorial", 0, 1000);
end

-------------------------------------------------------------------------
function OnBossMoviePlaybackCompleted()
    --log("OnBossMoviePlaybackCompleted!")
	LevelManager:ToggleDifficulty();
	SwitchDayNightDoor();
    SwitchDayNightMap();
    LevelManager:InitializeMapButtons();
    LevelManager:RepositionMaxAvailableMap();
    
    g_TaskManager:AddTask(TimeDelayTask, 1000, 0);
    g_TaskManager:AddTask(CallbackTask, { BossMovieCallback }, 0, 1000);
end

-------------------------------------------------------------------------
function BossMovieCallback()
    UIManager:ToggleUI("Door");
    StageManager:ChangeStage("PreEndlessMap");
end

--=======================================================================
-- @Day & Night
--=======================================================================

-------------------------------------------------------------------------
function ShowLogoChar1()
	UIManager:EnableWidget("MainEntry", "Char1", true);
	UIManager:GetWidgetComponent("MainEntry", "Char1", "Sprite"):ResetAnimation("ui_logo_char1_enter", true);
end

-------------------------------------------------------------------------
function ShowLogoChar2()
	UIManager:GetWidgetComponent("MainEntry", "Char2", "Motion"):ResetTarget(141, 102);
end

-------------------------------------------------------------------------
function ShowLogoChar3()
	UIManager:GetWidgetComponent("MainEntry", "Char3", "Motion"):ResetTarget(10, 114);
end

--------------------------------------------------------------------------------
function SwitchDayNightUI()
	if (LevelManager:GetGameDifficulty() == GAME_DIFF_NORMAL) then
		UIManager:GetUIComponent("MainEntry", "Sprite"):ResetImage("ui_logo_background");
		UIManager:GetWidgetComponent("MainEntry", "Roof", "Sprite"):ResetImage("ui_logo_roof");

		UIManager:EnableWidget("MainEntry", "Char1", true);
		UIManager:GetWidgetComponent("MainEntry", "Char1", "Sprite"):ResetAnimation("ui_logo_char1_show", true);
		UIManager:GetWidgetComponent("MainEntry", "Char2", "Sprite"):ResetImage("ui_logo_char2");
		UIManager:GetWidgetComponent("MainEntry", "Char3", "Sprite"):ResetImage("ui_logo_char3");

        UIManager:EnableWidget("EndlessMap", "Challenge", false);
	else
		UIManager:GetUIComponent("MainEntry", "Sprite"):ResetImage("ui_logo_background_night");
		UIManager:GetWidgetComponent("MainEntry", "Roof", "Sprite"):ResetImage("ui_logo_roof_night");

		UIManager:EnableWidget("MainEntry", "Char1", false);
		UIManager:GetWidgetComponent("MainEntry", "Char1", "Sprite"):ResetAnimation("ui_mainmenu_gear_off", true);
		UIManager:GetWidgetComponent("MainEntry", "Char2", "Sprite"):ResetImage("ui_logo_char2_night");
		UIManager:GetWidgetComponent("MainEntry", "Char3", "Sprite"):ResetImage("ui_logo_char3_night");

        UIManager:EnableWidget("EndlessMap", "Challenge", true);
	end
	
	SwitchDayNightDoor();
	SwitchDayNightMap();
end

--------------------------------------------------------------------------------
function SwitchDayNightDoor()
    local doorLeft, doorRight;    
	if (LevelManager:GetGameDifficulty() == GAME_DIFF_NORMAL) then
        doorLeft = "ui_door_left";
        doorRight = "ui_door_right";
	else
        doorLeft = "ui_door_left_night";
        doorRight = "ui_door_right_night";
	end
    
    for _, ui in ipairs(DOOR_OBSERVERS) do
        UIManager:GetWidgetComponent(ui, "DoorLeft", "Sprite"):ResetImage(doorLeft);
        UIManager:GetWidgetComponent(ui, "DoorRight", "Sprite"):ResetImage(doorRight);
    end
end

--------------------------------------------------------------------------------
function SwitchDayNightMap()
	local sprite = UIManager:GetWidgetComponent("EndlessMap", "GameDifficulty", "Sprite");
	
	if (LevelManager:GetGameDifficulty() == GAME_DIFF_NORMAL) then
		UIManager:GetUIComponent("EndlessMap", "Sprite"):ResetImage("ui_map_background");
		sprite:EnableRender(1, true);
		sprite:EnableRender(3, true);
		sprite:EnableRender(4, false);
		sprite:EnableRender(5, false);		
	else
		UIManager:GetUIComponent("EndlessMap", "Sprite"):ResetImage("ui_map_background_night");
		sprite:EnableRender(1, false);
		sprite:EnableRender(3, false);
		sprite:EnableRender(4, true);
		sprite:EnableRender(5, true);
	end
end

--=======================================================================
-- @Event
--=======================================================================

-------------------------------------------------------------------------
function CoinEarned(count)
    assert(count > 0);
    --log("CoinEarned: # "..count)
    AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);
    MoneyManager:ModifyCoin(count);

    UpdateGameStat(GAME_STAT_COIN, count);
    UpdateAchievement(ACH_COIN_EARNED_LV1, count);
    UpdateAchievement(ACH_COIN_EARNED_LV2, count);
    UpdateAchievement(ACH_COIN_EARNED_LV3, count);
    UpdateAchievement(ACH_COIN_EARNED_LV4, count);
end

-------------------------------------------------------------------------
function KobanEarned(count)
    assert(count > 0);
    --log("KobanEarned: # "..count)
    MoneyManager:ModifyKoban(count, true);
    AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);

    UpdateGameStat(GAME_STAT_KOBAN, count);
    UpdateAchievement(ACH_KOBAN_EARNED_LV1, count);
    UpdateAchievement(ACH_KOBAN_EARNED_LV2, count);
    UpdateAchievement(ACH_KOBAN_EARNED_LV3, count);
    UpdateAchievement(ACH_KOBAN_EARNED_LV4, count);
end

-------------------------------------------------------------------------
function ScrollUsed()
    UpdateGameStat(GAME_STAT_SCROLL_USE);
    BatchUpdateAchievement(ACH_SCROLL_USE_COUNT_LV1);
    BatchUpdateAchievement(ACH_SCROLL_USE_COUNT_LV2);
    BatchUpdateAchievement(ACH_SCROLL_USE_COUNT_LV3);
end

-------------------------------------------------------------------------
function JadeTriggered()
    UpdateGameStat(GAME_STAT_JADE_TRIGGER);
    BatchUpdateAchievement(ACH_JADE_TRIGGER_LV1);
    BatchUpdateAchievement(ACH_JADE_TRIGGER_LV2);
    BatchUpdateAchievement(ACH_JADE_TRIGGER_LV3);
    
    AudioManager:PlaySfx(SFX_OBJECT_JADE);
end

-------------------------------------------------------------------------
function InnocentSafe(go)
    UpdateGameStat(GAME_STAT_INNOCENT_SAFE);
	EnemyManager:DeactivateEnemy(go);
end

-------------------------------------------------------------------------
function InnocentHurt(go)
    UpdateGameStat(GAME_STAT_INNOCENT_HURT);
    UpdateAchievement(ACH_INNOCENT_HURT_LV1);
    UpdateAchievement(ACH_INNOCENT_HURT_LV2);
    UpdateAchievement(ACH_INNOCENT_HURT_LV3);

    EnemyManager:SetAnimation(go, ENEMY_ANIM_DEAD);
    LevelManager:AttackCastleByInnocent();
	AudioManager:PlaySfx(SFX_OBJECT_NO_ENERGY);
end

-------------------------------------------------------------------------
function MonkeyCatched(go)
    UpdateGameStat(GAME_STAT_MONKEY_CATCH);
    UpdateAchievement(ACH_MONKEY_CATCH_LV1);
    UpdateAchievement(ACH_MONKEY_CATCH_LV2);
    UpdateAchievement(ACH_MONKEY_CATCH_LV3);

    EnemyManager:SetAnimation(go, ENEMY_ANIM_DEAD);
    AudioManager:PlaySfx(SFX_CHAR_NINJA_ESCAPE);
end

-------------------------------------------------------------------------
function EnemyKilled(go)
    BladeManager:UpdateWeaponStat();
    UpdateGameStat(GAME_STAT_ENEMY_KILL);
    
    local template = go["Attribute"]:Get("template");
    if (ACH_ENEMY_TYPE_FUNC[ template[ENEMY_TEMPLATE_TYPE] ]) then
        ACH_ENEMY_TYPE_FUNC[ template[ENEMY_TEMPLATE_TYPE] ]();
    end

    AudioManager:StopSfx(template[ENEMY_TEMPLATE_SFX][ES_BIRTH]);
    AudioManager:PlaySfxInRandom(template[ENEMY_TEMPLATE_SFX][ES_WOUNDED]);
    EnemyManager:RemoveAllEnchants(go, false);
    EnemyManager:UpdateCombo();
end

-------------------------------------------------------------------------
function BossKilled(go)
    EnemyManager:UpdateCombo();
    EnemyManager:LaunchBossDrop(go);
    
    local ach = ACH_BOSS_PROGRESS[LevelManager:GetMapIndex()];
    if (ach) then
        UpdateAchievement(ach);
    end
    UpdateGameStat(GAME_STAT_BOSS_KILL);

    -- Must be called after UpdateGameStat()
    SubmitScore(IOManager:GetValue(IO_CAT_STAT, "Player", GAME_STAT_BOSS_KILL), GC_LEADERBOARD_BOSS);
    
    GameKit.LogEventWithParameter("BossFight", "win", "result", false);
    GameKit.LogEventWithParameter("BossFight", "win", "boss #" .. LevelManager:GetMapIndex(), false);
end

-------------------------------------------------------------------------
function UpdateGameStat(id, value)
    IOManager:ModifyValue(IO_CAT_STAT, "Player", id, (value or 1));
    --local v = IOManager:ModifyValue(IO_CAT_STAT, "Player", id, (value or 1));
    --log("[Stat] " .. id .. " => " .. v);
end

-------------------------------------------------------------------------
function UpdateHistoryUI()
    local rec = IOManager:GetRecord(IO_CAT_STAT, "Player");
    for _, v in ipairs(GAME_STAT_SUBJECTS) do
        UIManager:GetWidget("History", v):SetValue(rec[v] or 0);
    end
end

--=======================================================================
-- @Stat
--=======================================================================

-------------------------------------------------------------------------
function DetermineKobanCount()
    local diff = LevelManager:GetGameDifficulty();
    assert(TREASURE_KOBAN_RANGE[diff]);
    local range = TREASURE_KOBAN_RANGE[diff][LevelManager:GetMapIndex()][LevelManager:GetMedal()];
    assert(range);
    
    local result = math.random(range[1], range[2]);
    --log("DetermineKobanCount: [min] "..range[1].."  [max] "..range[2].."  => "..result)
    return result;
end

-------------------------------------------------------------------------
function DetermineCoinCount()
    local diff = LevelManager:GetGameDifficulty();
    assert(TREASURE_COIN_RANGE[diff]);
    local range = TREASURE_COIN_RANGE[diff][LevelManager:GetMapIndex()][LevelManager:GetMedal()];
    assert(range);
    
    local result = math.random(range[1], range[2]);
    --log("DetermineCoinCount: [min] "..range[1].."  [max] "..range[2].."  => "..result)
    return result;
end

-------------------------------------------------------------------------
function DetermineBoostType()
    local diff = LevelManager:GetGameDifficulty();
    assert(TREAUSRE_BOOST_CHANCE[diff]);
    local medal = LevelManager:GetMedal() or 1;
    local range = TREAUSRE_BOOST_CHANCE[diff][medal];
    assert(range);
    --log(string.format("BOOST [1] %d / [2] %d / [3] %d", range[1], range[2], range[3]))

    local dice = math.random(1, 100);
    for i = 1, 3 do
        if (dice <= range[i]) then
            return i;
        end
    end
    
    assert(false, "DetermineBoostType error");
end

-------------------------------------------------------------------------
function DetermineTreasureResult()
    local treasureType, treasureCount;
    local kobanChance = IOManager:GetValue(IO_CAT_HACK, "Treasure", "Chance");
    local bonusChance = LevelManager:GetAvatarKobanBonusChance() + LevelManager:GetDistanceKobanBonusChance();
    --local bonusChance = LevelManager:GetAvatarKobanBonusChance();
    --log("Koban Chance: "..kobanChance.." % / Bonus: "..bonusChance)

    if (math.random(1, 100) <= kobanChance + bonusChance) then
    -- Koban        
        treasureType = TREASURE_TYPE_KOBAN;
        treasureCount = DetermineKobanCount();
        --if (LevelManager:IsChallengeMode()) then
            --log("gold 2x => "..treasureCount * 2)
            --treasureCount = treasureCount;-- * 2;
        --end

        UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):SetImage(2, "ui_stat_koban");
        UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):EnableRender(1, true);

        if (kobanChance > TREAUSRE_KOBAN_FINAL_CHANCE) then
            IOManager:SetValue(IO_CAT_HACK, "Treasure", "Chance", kobanChance - TREAUSRE_KOBAN_FACTOR);
            --log("  Chance: "..kobanChance.." => "..kobanChance - TREAUSRE_KOBAN_FACTOR)
        end
    else
        if (LevelManager:IsChallengeMode()) then
            treasureType = TREASURE_TYPE_COIN;
            treasureCount = DetermineCoinCount(); -- * 2;
            --log("coin 2x => "..treasureCount * 2)
        
            UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):SetImage(2, "ui_stat_coin");
            UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):EnableRender(1, true);
        else
            if (math.random(1, 100) <= TREAUSRE_BOOST_DICE) then
            -- Boost
                local boostType = DetermineBoostType();
                treasureType = TREASURE_TYPE_BOOST;
                treasureCount = TREAUSRE_BOOST_DISTANCE[boostType];
                    
                --log("Boost Dist: "..treasureCount.." m")
                UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):SetImage(2, "ui_stat_speedboost"..boostType);
                UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):EnableRender(1, false);
            else
            -- Coin        
                treasureType = TREASURE_TYPE_COIN;
                treasureCount = DetermineCoinCount();
        
                UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):SetImage(2, "ui_stat_coin");
                UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):EnableRender(1, true);
            end
        end
    end
--[[ @DEBUG
            local boostType = DetermineBoostType();
            treasureType = TREASURE_TYPE_BOOST;
            treasureCount = TREAUSRE_BOOST_DISTANCE[boostType];
                
            --log("Boost Dist: "..treasureCount.." m")
            UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):SetImage(2, "ui_stat_speedboost"..boostType);
            UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Sprite"):EnableRender(1, false);
--]]
    UIManager:SetWidgetTranslate("TreasureSelect", "TreasureResult", TREASURE_RESULT_POS[treasureType][1], TREASURE_RESULT_POS[treasureType][2]);
    
    return treasureType, treasureCount;
end

-------------------------------------------------------------------------
function PickTreasureBox(index)
    local candidate = { 1, 2, 3 };
    for _, v in ipairs(candidate) do
        UIManager:GetWidget("TreasureSelect", "Box"..v):Enable(false);
    end
    table.remove(candidate, index);
    
    local level = LevelManager:GetMedal();
    for _, v in ipairs(candidate) do
        UIManager:GetWidgetComponent("TreasureSelect", "Box"..v, "Sprite"):SetAnimation(TREASURE_ANIM[level][TREASURE_ANIM_CLOSE], true);
    end

    local interGC = UIManager:GetWidgetComponent("TreasureSelect", "Box"..index, "Interpolator");
    interGC:AttachCallback(UpdateTreasureBoxScale, UpdateTreasureBoxDone, UIManager:GetWidgetObject("TreasureSelect", "Box"..index));
    interGC:ResetTarget(0.8, 1.1, 100);
    interGC:AppendNextTarget(1.1, 1.0, 75);
end

-------------------------------------------------------------------------
function UpdateTreasureBoxScale(value, go)
    go["Transform"]:SetScale(value);
end

-------------------------------------------------------------------------
function UpdateTreasureBoxDone(value, go)
    -- NOTE: HACK for prevent doing it twice
    if (value ~= 1) then
        return;
    end
    
    go["Sprite"]:SetAnimation(TREASURE_ANIM[ LevelManager:GetMedal() ][TREASURE_ANIM_OPEN], true);
    go["Motion"]:ResetTarget(TREASURE_ORIGIN[1] - 30, TREASURE_ORIGIN[2]);
    
    local treasureType, count = DetermineTreasureResult();

    UIManager:EnableWidget("TreasureSelect", "TreasureResult", true);
    UIManager:SetWidgetTranslate("TreasureSelect", "TreasureResult", APP_WIDTH, TREASURE_RESULT_POS[treasureType][2]);
    UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Motion"):ResetTarget(TREASURE_RESULT_POS[treasureType][1], TREASURE_RESULT_POS[treasureType][2]);
    UIManager:GetWidgetComponent("TreasureSelect", "TreasureResult", "Motion"):AttachCompleteCallback(UpdateTreasureResultDone);
    
    if (treasureType ~= TREASURE_TYPE_BOOST) then
        UIManager:EnableWidget("TreasureSelect", "TreasureNum", true);
        UIManager:GetWidget("TreasureSelect", "TreasureNum"):SetValue(count);

        UIManager:SetWidgetTranslate("TreasureSelect", "TreasureNum", APP_WIDTH + TREASURE_NUM_OFFSET, TREASURE_RESULT_POS[treasureType][2]);
        UIManager:GetWidgetComponent("TreasureSelect", "TreasureNum", "Motion"):ResetTarget(TREASURE_RESULT_POS[treasureType][1] + TREASURE_NUM_OFFSET, TREASURE_RESULT_POS[treasureType][2]);
    else
        UIManager:EnableWidget("TreasureSelect", "TreasureNum", false);
    end
    
    GameDataManager:SetData("TreasureType", treasureType);
    GameDataManager:SetData("TreasureCount", count);
end

-------------------------------------------------------------------------
function ShowTreasureDoubler()
    UIManager:EnableWidget("TreasureSelect", "Doubler", true);
    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
end

-------------------------------------------------------------------------
function UpdateTreasureResultDone()
    local treasureType = GameDataManager:GetData("TreasureType");
    local count = GameDataManager:GetData("TreasureCount");

    if (LevelManager:IsChallengeMode()) then
        --log("count: "..count.." => 2x: ".. count * 2)
        count = count * 2;
        UIManager:SetWidgetTranslate("TreasureSelect", "Doubler", TREASURE_DOUBLER_OFFSET[treasureType], TREASURE_RESULT_POS[treasureType][2]);
        g_TaskManager:AddTask(CallbackTask, { ShowTreasureDoubler }, 0, 750);
    end
    
    g_TaskManager:AddTask(StageChangeTask, "PostTreasureSelect", 0, 2000);

    if (treasureType == TREASURE_TYPE_COIN) then
        CoinEarned(count);
    elseif (treasureType == TREASURE_TYPE_KOBAN) then
        KobanEarned(count);
    elseif (treasureType == TREASURE_TYPE_BOOST) then
        --log("BOOST INIT : "..count)
        IOManager:SetValue(IO_CAT_HACK, "Boost", "Initial", count);
        AudioManager:PlaySfx(SFX_OBJECT_JADE);
    end

    GameDataManager:SetData("TreasureType", 0);
    GameDataManager:SetData("TreasureCount", 0);    
end

-------------------------------------------------------------------------
function ShowTreasureSelect()    
	StageManager:ChangeStage("PreTreasureSelect");
end

-------------------------------------------------------------------------
function ShowGameStat()    
	StageManager:ChangeStage("PreGameStat");
end

-------------------------------------------------------------------------
function GotoGameStat()    
	StageManager:ChangeStage("GameStat");

    local mapIndex = LevelManager:GetMapIndex() or 1;
    local levelRec = LevelManager:GetLevelRecord()[mapIndex];

    -- Avatar
    UIManager:GetWidget("GameStat", "Avatar"):ResetImage(LevelManager:GetAvatarStatImage());
    UIManager:EnableWidget("GameStat", "Avatar", true);
    
    -- Title
    UIManager:GetWidgetComponent("GameStat", "StatText", "Sprite"):SetImage(2, "ui_stat_title_0"..mapIndex);
    UIManager:EnableWidget("GameStat", "StatText", true);
    
    -- Distance
    local distance =  UIManager:GetWidget("InGame", "DistanceCounter"):GetValue();
    
    UIManager:GetWidget("GameStat", "DistanceNum"):SetValue(distance);
    if (levelRec["Distance"] < distance) then
        levelRec["Distance"] = distance;
    end
    
    -- Coin
    local coin = EnemyManager:GetCoin();
    UIManager:GetWidget("GameStat", "CoinGetNum"):SetValue(coin);
    if (levelRec["Coin"] < coin) then
        levelRec["Coin"] = coin;
    end
    
    -- Score (+ ReviveCount)
    local factors = LevelManager:GetScoreFactors();
    local score = distance * factors[1] + coin * factors[2] + GameDataManager:GetData("ReviveCount");
    
    -- Boss factor
    --log("Boss factor: "..LevelManager:GetBossScoreFactor().." score: "..score.." => "..score * LevelManager:GetBossScoreFactor())
    score = math.floor(score * LevelManager:GetBossScoreFactor());
    SubmitScore(score, GC_LEADERBOARD_SCORE);

    GameDataManager:SetData("Distance", distance);
    GameDataManager:SetData("Score", score);

    g_TaskManager:AddTask(CallbackTask, { AccumStatScore, nil, nil, score }, 1000, 200);
    
    local medal = LevelManager:GetMedal();
    if (levelRec["Medal"] < medal) then
        levelRec["Medal"] = medal;
    end

    local isBestScore = false;
    if (levelRec["Score"] < score) then
        isBestScore = true;
        levelRec["Score"] = score;
        g_TaskManager:AddTask(CallbackTask, { ShowBestScoreEffect, nil, nil, nil }, 2000, 300);
    else
        UIManager:GetWidget("GameStat", "BestScoreNum"):SetValue(levelRec["Score"]);
        g_TaskManager:AddTask(CallbackTask, { ShowBestScoreRecord, nil, nil, nil }, 0, 300);
    end
    GameDataManager:SetData("BestScore", isBestScore);
    GameDataManager:SetData("ShowAd", false);
--[[    
    local hasLevelUnlocked = LevelManager:UpdateAchievementAndStatus(distance);
    GameDataManager:SetData("LevelUnlocked", hasLevelUnlocked);
--]]
    LevelManager:UpdateAchievementAndStatus(distance);
    
    if (LevelManager:IsChallengeMode()) then
        SubmitParseScore(distance, mapIndex);
        --SubmitScore(score, GC_LEADERBOARD_CHALLENGE);
        SubmitScore(distance, GC_LEADERBOARD_CHALLENGE);
        IOManager:Save();

        g_TaskManager:AddTask(CallbackTask, { ShowChallengeModeLeaderboard, nil, nil, nil }, 0, 0);    
        g_TaskManager:AddTask(CallbackTask, { ShowStatButtons, nil, nil, nil }, 0, 1000);
    else
        if (LevelManager:WasNewLevelUnlocked()) then
            g_TaskManager:AddTask(CallbackTask, { ShowLevelUnlockUI, nil, nil, nil }, 0, 0);
        else
            g_TaskManager:AddTask(CallbackTask, { ShowAdForGameStat, nil, nil, nil }, 0, 0);
            g_TaskManager:AddTask(CallbackTask, { ShowStatButtons, nil, nil, nil }, 0, 0);
        end
        
        if (distance >= 500) then
            IOManager:ModifyValue(IO_CAT_CONTENT, "Ad", "CurrentGameCount", 1);
        end
    
        CheckFeedbackCondition(distance, isBestScore);    
        LogStatEvents(mapIndex, distance, coin, score);
    
        IOManager:Save();
        SaveToCloud();
    end
end

-------------------------------------------------------------------------
function SkipGameStat()
    if (not g_TaskManager:IsDone()) then
        g_TaskManager:Clear();
        AudioManager:PlayBgm(BGM_LEVEL_WIN);
        
    	UIManager:ToggleWidgetGroup("GameStat", "SkipWidgets", true);
        UIManager:GetWidget("GameStat", "ScoreNum"):SetValue(GameDataManager:GetData("Score"));
        UIManager:GetWidgetComponent("GameStat", "ScoreNum", "Interpolator"):Reset();

        if (GameDataManager:GetData("BestScore")) then
            ShowBestScoreEffect();
        else
            ShowBestScoreRecord();
        end
        
        if (LevelManager:IsChallengeMode()) then
            ShowChallengeModeLeaderboard();
            ShowStatButtons();
        elseif (LevelManager:WasNewLevelUnlocked()) then
            ShowLevelUnlockUI();
        else
            ShowStatButtons();
        end
    end
end

-------------------------------------------------------------------------
function CheckFeedbackCondition(distance, isBestScore)
    local rec = IOManager:GetRecord(IO_CAT_CONTENT, "Feedback");
    --log("ShowFeedback: "..rec["Distance"].." m => "..rec["Distance"] + distance.." m");
    
    rec["Distance"] = rec["Distance"] + distance;
    
    if (isBestScore) then
        rec["GameCount"] = rec["GameCount"] + 2;
    else
        rec["GameCount"] = rec["GameCount"] + 1;
    end

    local dataSet = LevelManager:GetLevelDataSet();
    if (dataSet["ShowFeedback"] == true) then
        if (rec["Distance"] >= rec["NextFeedbackDistance"] and rec["GameCount"] >= rec["NextFeedbackGameCount"]) then
            rec["Showup"] = true;

            rec["Distance"] = 0;
            rec["NextFeedbackDistance"] = rec["NextFeedbackDistance"] * 2;
            if (rec["NextFeedbackDistance"] > FEEDBACK_DISTANCE_MAX) then
                rec["NextFeedbackDistance"] = FEEDBACK_DISTANCE_MAX;
            end

            rec["GameCount"] = 0;
            rec["NextFeedbackGameCount"] = rec["NextFeedbackGameCount"] + FEEDBACK_GAMECOUNT_INITIAL;
            if (rec["NextFeedbackGameCount"] > FEEDBACK_GAMECOUNT_MAX) then
                rec["NextFeedbackGameCount"] = FEEDBACK_GAMECOUNT_MAX;
            end
            --log("ShowFeedback: SHOW @ "..newDist.." m / NextFeedbackDistance: "..rec["NextFeedbackDistance"]);
        end
    else
        if (distance > 3000) then
            dataSet["ShowFeedback"] = true;
            rec["Distance"] = 0;
            rec["GameCount"] = 0;

            if (LevelManager:MeetFeedbackCondition()) then
                rec["Showup"] = true;
            else
                rec["Showup"] = false;
            end
        end
    end
end

--[[
-------------------------------------------------------------------------
function ShowStatSubject(subject)
    UIManager:EnableWidget("GameStat", subject, true);
    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
end
--]]

-------------------------------------------------------------------------
function AccumStatScore(score)
    UIManager:EnableWidget("GameStat", "DistanceNum", true);
    UIManager:EnableWidget("GameStat", "CoinGetNum", true);
    UIManager:EnableWidget("GameStat", "ScoreNum", true);
    UIManager:GetWidgetComponent("GameStat", "ScoreNum", "Interpolator"):ResetTarget(0, score, 750);    
    
    AudioManager:PlaySfx(SFX_UI_STAT_ACCUM);
    AudioManager:PlayBgm(BGM_LEVEL_WIN);
end

-------------------------------------------------------------------------
function ShowBestScoreEffect()
    UIManager:EnableWidget("GameStat", "BestScoreEffect", true);
    UIManager:GetWidgetComponent("GameStat", "BestScoreEffect", "Sprite"):Animate();
    AudioManager:PlaySfx(SFX_UI_BEST_SCORE);
end

-------------------------------------------------------------------------
function ShowBestScoreRecord()
    UIManager:EnableWidget("GameStat", "BestScoreText", true);
    UIManager:EnableWidget("GameStat", "BestScoreNum", true);
    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
end

-------------------------------------------------------------------------
function ShowStatButtons()
	UIManager:ToggleWidgetGroup("GameStat", "ButtonWidgets", true);
    
    if (LevelManager:IsChallengeMode()) then
        UIManager:EnableWidget("GameStat", "Again", false);
        UIManager:EnableWidget("GameStat", "Shop", false);
    else
        UIManager:EnableWidget("GameStat", "Exit", false);
        ShopManager:ShowShopButton();
        ShowFeedbackUI();
    end
    
    g_TaskManager:Clear();
    --ListCurrentUsedTextures("GameStat");
end

-------------------------------------------------------------------------
function ShowLevelUnlockUI()
    StageManager:ChangeStage("LevelUnlock");
    g_TaskManager:Clear();
end

-------------------------------------------------------------------------
function ShowFeedbackUI()
    if ((not GameDataManager:GetData("ShowAd")) and IOManager:GetValue(IO_CAT_CONTENT, "Feedback", "Showup")) then        
        if (IOManager:GetValue(IO_CAT_CONTENT, "Feedback", "NoVirgin")) then
            if (math.random(1, 100) <= 30) then
                ShowLoveHateChoices();
            else
                ShowLeaderboardChoices();
            end
        else
            IOManager:SetValue(IO_CAT_CONTENT, "Feedback", "NoVirgin", true);
            ShowLoveHateChoices();
        end
        IOManager:SetValue(IO_CAT_CONTENT, "Feedback", "Showup", false, true);
    end
end

-------------------------------------------------------------------------
function ShowChallengeModeLeaderboard()
    GameKit.ShowLeaderboardForToday(GC_LEADERBOARD_CHALLENGE);
end

--=======================================================================
-- @Gift
--=======================================================================

--[[ v2.0 gift
-------------------------------------------------------------------------
function ProceedPaidGift()
    local x, y = UIManager:GetUITranslate("Gift");
    UIManager:SetWidgetTranslate("Gift", "Action", -x, -y);
    UIManager:ToggleUI("Gift");
    CycleGORotate(UIManager:GetWidgetObject("Gift", "AvatarShine"), 0, 1, 3000);            
    AudioManager:PlaySfx(SFX_UI_BEST_SCORE);
end

-------------------------------------------------------------------------
function CheckPaidGift()
    if (HasAchievementCompleted(ACH_MONKEY_POTION)) then
        if (IOManager:GetValue(IO_CAT_HACK, "Avatar", AVATAR_THIEF) == nil) then
            ProceedPaidGift();
        end
    end
end

-------------------------------------------------------------------------
function GetPaidGift()
    IOManager:SetValue(IO_CAT_HACK, "Avatar", AVATAR_THIEF, 1);
    IOManager:SetValue(IO_CAT_HACK, "AvatarLv", AVATAR_THIEF, 1);
    IOManager:SetValue(IO_CAT_HACK, "AvatarExp", AVATAR_THIEF, 0);
    IOManager:SetValue(IO_CAT_HACK, "Avatar", "Equip", AVATAR_THIEF, true);
    UIManager:ToggleUI("Gift");
    AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);
end
--]]

--[[ v1.1 gift
-------------------------------------------------------------------------
function CheckForStartupBonus()
    if (IOManager:GetValue(IO_CAT_CONTENT, "Feedback", "Rating") == "1.1") then
        UIManager:ToggleUI("KobanGift");
    end
end
--]]

--=======================================================================
-- @Revive
--=======================================================================

-------------------------------------------------------------------------
function LogEventForRevive(revived)
    local choice = "NO";
    if (revived) then
        choice = "YES";
        GameKit.LogEventWithParameter("Money", "revive", "KobanUsage", false);
        
        if (LevelManager:IsOnBossMode()) then
            GameKit.LogEventWithParameter("Revive", "boss", "mode", false);
        else
            GameKit.LogEventWithParameter("Revive", "normal", "mode", false);
        end
    end

    GameKit.LogEventWithParameter("Revive", choice, "action", false);

    local distance =  UIManager:GetWidget("InGame", "DistanceCounter"):GetValue();
    for _, v in ipairs(FA_REVIVE_DIST) do
        if (distance < v) then
            GameKit.LogEventWithParameter("Revive", choice, v .. "m", false);
            return;
        end
    end
    
    GameKit.LogEventWithParameter("Revive", choice, "above all", false);
end

-------------------------------------------------------------------------
function ReviveGame(toggle)
    local cost = UIManager:GetWidget("Revive", "Cost"):GetValue();
    
    if (not MoneyManager:HasEnoughKoban(cost)) then
        StageManager:ChangeStage("RevivePause");
        return;
    end

    if (toggle) then
        UIManager:GetUIComponent("Revive", "StateMachine"):ChangeState("inactive");
        UIManager:ToggleUI("Revive");
    end

    MoneyManager:ModifyKoban(-cost, true);

    UpdateGameStat(GAME_STAT_REVIVE);
    UpdateAchievement(ACH_REVIVE_COUNT_LV1);
    UpdateAchievement(ACH_REVIVE_COUNT_LV2);
    UpdateAchievement(ACH_REVIVE_COUNT_LV3);
    
    LogEventForRevive(true);
    
    EnemyManager:CleanupFromRevive();
    LevelManager:Revive();
end

-------------------------------------------------------------------------
function ReviveInaction(toggle)
    LogEventForRevive(false);
    AudioManager:PlaySfx(SFX_UI_BUTTON_2);

    if (toggle) then
        --UIManager:GetUIComponent("Revive", "StateMachine"):ChangeState("inactive");    
        UIManager:ToggleUI("Revive");
    end
    
    StageManager:ChangeStage("GameCountdown");
end

-------------------------------------------------------------------------
function ReviveFromIAP()
    --log("ReviveFromIAP !!!!!");
    UIManager:ToggleUI("Wait");
    StageManager:ChangeStage("InGame");
    ReviveGame(false);
    GameKit.LogEventWithParameter("Revive", "YES", "IAP", false);
end

-------------------------------------------------------------------------
function ReviveInactionFromIAP()
    --log("Revive NO FromIAP");
    ReviveInaction(false);
    GameKit.LogEventWithParameter("Revive", "NO", "IAP", false);
end

--=======================================================================
-- @Flurry Stat
--=======================================================================

-------------------------------------------------------------------------
function LogPocketSubject(key, postfix, value)
    if (POCKET_SET_DATA[key] and postfix and value) then
        for _, v in ipairs(POCKET_SET_DATA[key]) do
            if (value <= v) then
                --log("POCKET [" .. key .. "] : " .. v .. postfix);
                GameKit.LogEventWithParameter("Pocket", v .. postfix, key, false);
                return;
            end
        end
    end
end

-------------------------------------------------------------------------
function LogPocket(subject)
    IOManager:ModifyValue(IO_CAT_HACK, "Pocket", "Koban"..subject, 1);
    local count = IOManager:ModifyValue(IO_CAT_HACK, "Pocket", "Count", 1);
    
    if (count == 1) then
        --log("Virgin Pocket!")
        GameKit.LogEventWithParameter("Pocket", "new koban #" .. subject, "Virgin", false);

        local map = LevelManager:GetMaxUnlockedLevel();
        --log("  [MAP AVAIL] => "..map)
        GameKit.LogEventWithParameter("Pocket", map, "Map", false);

        LogPocketSubject("Koban", "g", MoneyManager:GetKoban());
        LogPocketSubject("Coin", "s", MoneyManager:GetCoin());
    end
    
    --log("  [TOTAL BUY] => "..count)
    GameKit.LogEventWithParameter("Pocket", count .. " buy", "Total", false);
end

-------------------------------------------------------------------------
function LogGameStat(name, value, key, postfix)
    if (FA_SET_DATA[key] == nil) then
        --log("LogGameStat error: [key] "..key);
        return;
    end
    
    for _, v in ipairs(FA_SET_DATA[key]) do
        if (value < v) then
            --log("FA [" .. key .. "] : " .. v .. postfix);
            GameKit.LogEventWithParameter(name, v .. postfix, key, false);
            return;
        end
    end
    
    --log("FA [" .. key .. "] : " .. value .. postfix.." <above all>");
    GameKit.LogEventWithParameter(name, "above all", key, false);
end

-------------------------------------------------------------------------
function LogStatEvents(mapIndex, distance, coin, score)
	UpdateGameStat(GAME_STAT_PLAY_COUNT);
	UpdateGameStat(GAME_STAT_DISTANCE, distance);
	UpdateGameStat(GAME_STAT_COIN, coin);

    --log("DISTANCE: "..IOManager:GetValue(IO_CAT_STAT, "Player", GAME_STAT_DISTANCE).." m")
    SubmitScore(IOManager:GetValue(IO_CAT_STAT, "Player", GAME_STAT_DISTANCE), GC_LEADERBOARD_DISTANCE);

    UpdateAchievement(ACH_COIN_EARNED_LV1, coin);
    UpdateAchievement(ACH_COIN_EARNED_LV2, coin);
    UpdateAchievement(ACH_COIN_EARNED_LV3, coin);
    UpdateAchievement(ACH_COIN_EARNED_LV4, coin);

    local event = "Map"..mapIndex;
    if (LevelManager:IsShadowDifficulty()) then
        event = event .. "_shadow";
    end    
    --log("LogStatEvents : "..event)
    LogGameStat(event, distance, "distance", "m");
    LogGameStat(event, coin, "coin", "s");
    LogGameStat(event, score, "score", "p");
end

--=======================================================================
-- @Ad
--=======================================================================

-------------------------------------------------------------------------
AD_BANNER_CALLBACK =
{
	[1] = function()
        GameKit.OpenAppStore("bonniesbrunch2");
    end,
    
	[2] = function()  -- Burn The Corn
        GameKit.OpenURL("http://goo.gl/Q0g40");
    end,
};

-------------------------------------------------------------------------
function InitAd()
    local ad = IOManager:GetRecord(IO_CAT_CONTENT, "Ad");
    if (ad == nil) then
        local t =
        {
            CurrentGameCount = 0,
            NextGameCount = 3,
--[[ @DEBUG
            NextGameCount = 0,
--]]
            CurrentShowAdCount = 0,
            NextGetCoinCount = 0,
            GameStat = 10,
            Virgin = true,
        };
        IOManager:SetRecord(IO_CAT_CONTENT, "Ad", t, true);
    end
end

-------------------------------------------------------------------------
function ProceedAd()
    if (IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal")[1] == nil) then
        return;
    end
    
    if (GameDataManager:GetData("AdBanner")) then
        GameDataManager:SetData("AdBanner", false);
        UIManager:ToggleUI("Ad");
    end

    local rec = IOManager:GetRecord(IO_CAT_CONTENT, "Ad");    
    if (rec["CurrentGameCount"] >= rec["NextGameCount"]) then
        -- Show Ad
--[[        
        local x = math.random(0, 400);--160);
        local y = math.random(15, 30);
        log("=> SHOW AD CHAR @ x="..x..", y="..y)
        UIManager:SetWidgetTranslate("EndlessMap", "AdChar", x, y);
--]]        
        UIManager:SetWidgetTranslate("EndlessMap", "AdChar", 5, 15);
        UIManager:GetWidgetComponent("EndlessMap", "AdChar", "Sprite"):SetAnimation("ad_cat_show", true);
        UIManager:GetWidgetComponent("EndlessMap", "AdChar", "Transform"):SetScale(1.2);
        UIManager:EnableWidget("EndlessMap", "AdChar", true);
        CycleGOAlpha(UIManager:GetWidgetObject("EndlessMap", "AdChar"), ALPHA_MAX, ALPHA_QUARTER, 2000);
        
        -- Determine the target ad
        if (rec["CurrentShowAdCount"] >= rec["NextGetCoinCount"]) then
            local newNextCoinCount = math.random(5, 7); --math.random(6, 8);
            log("NextGetCoinCount: "..newNextCoinCount)
            rec["NextGetCoinCount"] = newNextCoinCount;
            rec["CurrentShowAdCount"] = 0;
            AD_ACTION_FUNC = GainAdCoin;
        else
            rec["CurrentShowAdCount"] = rec["CurrentShowAdCount"] + 1;

            if (math.random(1, 100) > 85) then --80) then
--[[ @DEBUG            
if (math.random(1, 100) > 1) then
--]]
                --log("=> AD BANNER")
                AD_ACTION_FUNC = ShowAdBanner;
                GameKit.LogEventWithParameter("Ad", "AdBanner", "Content", false);
            else
                --log("=> AD CHARTBOOST")
                AD_ACTION_FUNC = ShowAdChartboost;
                GameKit.LogEventWithParameter("Ad", "Chartboost", "Content", false);
            end
        end

        -- Determine next game count required
        local newCount = math.random(2, 4); --math.random(3, 5);
--[[ @DEBUG            
local newCount = 0;
--]]
        --log("NEXT GAME COUNT: "..newCount)
        IOManager:SetValue(IO_CAT_CONTENT, "Ad", "NextGameCount", newCount);
        IOManager:SetValue(IO_CAT_CONTENT, "Ad", "CurrentGameCount", 0);
        IOManager:Save();
    --else
    --    log("NO AD: [cur] "..rec["CurrentGameCount"].." / [next] "..rec["NextGameCount"])
    end
end

-------------------------------------------------------------------------
function ExitAd()
    if (GameDataManager:GetData("AdBanner")) then
        GameDataManager:SetData("AdBanner", false);
        UIManager:ToggleUI("Ad");
    end

    if (UIManager:GetWidgetEnable("EndlessMap", "AdChar")) then
        GameKit.LogEventWithParameter("Ad", "miss", "AdChar", false);
    end
end

-------------------------------------------------------------------------
function PerformAdCharAction()
    AudioManager:PlaySfx(SFX_CHAR_NINJA_ESCAPE);

    UIManager:GetWidgetComponent("EndlessMap", "AdChar", "Interpolator"):Reset();
    local gc = UIManager:GetWidgetComponent("EndlessMap", "AdChar", "Sprite");
	gc:AttachCallback("ad_cat_out", 4, ShowAd);
    gc:SetAnimation("ad_cat_out", true);
    gc:SetAlpha(ALPHA_MAX);
end

-------------------------------------------------------------------------
function ShowAd()
    GameKit.LogEventWithParameter("Ad", "click", "AdChar", false);
    
    if (AD_ACTION_FUNC) then
        AD_ACTION_FUNC();
    end
    UIManager:EnableWidget("EndlessMap", "AdChar", false);
end

-------------------------------------------------------------------------
function ShowAdBanner()
    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
    UIManager:ToggleUI("Ad");
    
    local adIndex = 1;
    if (math.random(1, 100) > 50) then
        adIndex = 2;
    end
    --log("AdBanner @ "..adIndex)
    
    if (adIndex == 1) then
        GameKit.LogEventWithParameter("AdBanner", "BonniesBrunch2", "show", false);
    else
        GameKit.LogEventWithParameter("AdBanner", "BurnTheCorn", "show", false);
    end
    
    UIManager:GetWidget("Ad", "Banner"):SetImage("ad_banner_0" .. adIndex);
    UIManager:GetWidgetComponent("Ad", "Banner", "Attribute"):Set("AdIndex", adIndex);
    
    local x, y = UIManager:GetWidgetTranslate("Ad", "Banner", "Transform");
    UIManager:GetWidgetComponent("Ad", "Banner", "Transform"):SetTranslate(x, APP_HEIGHT);
    UIManager:GetWidgetComponent("Ad", "Banner", "Motion"):ResetTarget(x, 270);

    GameDataManager:SetData("AdBanner", true);
end

-------------------------------------------------------------------------
function ShowAdChartboost()
    GameKit.ShowInterstitial("Default");
end

-------------------------------------------------------------------------
function GainAdCoin()
    local virgin = false;
    if (IOManager:GetValue(IO_CAT_CONTENT, "Ad", "Virgin")) then
        virgin = true;
        IOManager:SetValue(IO_CAT_CONTENT, "Ad", "Virgin", false);
    end
    
    if (virgin or (math.random(1, 100) > 90)) then
        --log("GAIN KOBAN")
        local gold = LevelManager:GetMaxAvailableTreasure("gold");
        MoneyManager:ModifyKoban(gold);
        GameKit.LogEventWithParameter("Ad", "Gold", "Content", false);
        GameKit.ShowMessage("text_status", GameKit.GetLocalizedString("ad_gold") .. gold .. GameKit.GetLocalizedString("ad_money_post"));
    else
        --log("GAIN COIN")
        local coin = LevelManager:GetMaxAvailableTreasure();
        MoneyManager:ModifyCoin(coin);
        GameKit.LogEventWithParameter("Ad", "Coin", "Content", false);
        GameKit.ShowMessage("text_status", GameKit.GetLocalizedString("ad_coin") .. coin .. GameKit.GetLocalizedString("ad_money_post"));
    end

    AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);
    IOManager:Save();
end

-------------------------------------------------------------------------
function ShowAdForGameStat()
    local adChance = IOManager:GetValue(IO_CAT_CONTENT, "Ad", "GameStat");    
    if (adChance) then
        if (math.random(1, 100) <= adChance) then
        --log("!!! ShowAd !!!")
            GameDataManager:SetData("ShowAd", true);
            GameKit.ShowInterstitial("Default");
            --IOManager:SetValue(IO_CAT_CONTENT, "Ad", "GameStat", 10, true);
            IOManager:SetValue(IO_CAT_CONTENT, "Ad", "GameStat", 20, true);
        else
        --log("ShowAd failed => ".. (adChance + 10) .." %")
            --IOManager:SetValue(IO_CAT_CONTENT, "Ad", "GameStat", adChance + 5, true);
            IOManager:SetValue(IO_CAT_CONTENT, "Ad", "GameStat", adChance + 10, true);
        end
    end
end

--=======================================================================
-- @Game Object
--=======================================================================

-------------------------------------------------------------------------
function EnableUpdateGameObjects(enable)
    for _, group in ipairs(GAME_OBJECT_GROUPS) do
        g_UpdateManager:EnableGroup(group, enable);
    end
end

--=======================================================================
-- @Render & Update
--=======================================================================

-------------------------------------------------------------------------
function AddToRenderQueue(go)
    table.insert(g_RenderQueue, go);
end

-------------------------------------------------------------------------
function RemoveFromRenderQueue(go)
    for index, obj in ipairs(g_RenderQueue) do
        if (go == obj) then
            return table.remove(g_RenderQueue, index);
        end
    end
    
    assert(false, "RemoveFromRenderQueue error");
end

-------------------------------------------------------------------------
function AddToPreRenderQueue(go)
    table.insert(g_PreRenderQueue, go);
end

-------------------------------------------------------------------------
function RemoveFromPreRenderQueue(go)
    for index, obj in ipairs(g_PreRenderQueue) do
        if (go == obj) then
            return table.remove(g_PreRenderQueue, index);
        end
    end
    
    assert(false, "RemoveFromPreRenderQueue error");
end

-------------------------------------------------------------------------
function AddToPostRenderQueue(go)
    table.insert(g_PostRenderQueue, go);
end

-------------------------------------------------------------------------
function RemoveFromPostRenderQueue(go)
    for index, obj in ipairs(g_PostRenderQueue) do
        if (go == obj) then
            return table.remove(g_PostRenderQueue, index);
        end
    end
    
    assert(false, "RemoveFromPostRenderQueue error");
end

-------------------------------------------------------------------------
function SortGameObject(go1, go2)
    return (go1["Bound"]:GetRelativeHeight() < go2["Bound"]:GetRelativeHeight());
end

-------------------------------------------------------------------------
function SortGameObjectReversed(go1, go2)
    return (go1["Bound"]:GetRelativeHeight() > go2["Bound"]:GetRelativeHeight());
end

-------------------------------------------------------------------------
function UpdateGameObjects()
    -- Game objects @ pre layer
    for _, go in ipairs(g_PreRenderQueue) do
        go:Update();
    end
    
    -- Game objects
    table.sort(g_RenderQueue, SortGameObject);

    for _, go in ipairs(g_RenderQueue) do
        go:Update();
    end

    -- Game objects @ post layer
    for _, go in ipairs(g_PostRenderQueue) do
        go:Update();
    end
  
    LevelManager:Update();
end

-------------------------------------------------------------------------
function UpdateGameObjectsTutorial()
    -- Game objects @ pre layer
    for _, go in ipairs(g_PreRenderQueue) do
        go:Update();
    end
    
    -- Game objects
    table.sort(g_RenderQueue, SortGameObject);

    for _, go in ipairs(g_RenderQueue) do
        go:Update();
    end

    -- Game objects @ post layer
    for _, go in ipairs(g_PostRenderQueue) do
        go:Update();
    end
  
    LevelManager:UpdateBackdropLayers();
end

-------------------------------------------------------------------------
function RenderGameObjects()
    -- Backdrop
    LevelManager:RenderBackdrop();

    -- Game objects @ pre layer
    for _, go in ipairs(g_PreRenderQueue) do
        go:Render();
    end
    
    -- Game objects
    for _, go in ipairs(g_RenderQueue) do
        go:Render();
    end
    
    -- Backdrop overlay
    LevelManager:RenderOverlay();

    -- Game objects @ post layer
    for _, go in ipairs(g_PostRenderQueue) do
        go:Render();
    end

    -- Blade
	BladeManager:Render();
end
