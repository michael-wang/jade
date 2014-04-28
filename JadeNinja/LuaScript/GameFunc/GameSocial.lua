--***********************************************************************
-- @file GameSocial.lua
--***********************************************************************
GAO_SOCIAL_TWITTER = 1;
GAO_SOCIAL_FACEBOOK = 2;
GAO_SOCIAL_SINAWEIBO = 3;

ITC_TOKEN_PREFIX = "com.monkeypotion.jadeninja";

if IS_PLATFORM_ANDROID then
    GC_LEADERBOARD_SCORE = "leaderboard_best_score";
    GC_LEADERBOARD_BOSS = "leaderboard_boss_defeated";
    GC_LEADERBOARD_DISTANCE = "leaderboard_total_distance";
    GC_LEADERBOARD_CHALLENGE = "leaderboard_daily_challenge_distance";
else
    GC_LEADERBOARD_SCORE = "com.monkeypotion.jadeninja.score";
    GC_LEADERBOARD_BOSS = "com.monkeypotion.jadeninja.bosshunt";
    GC_LEADERBOARD_DISTANCE = "com.monkeypotion.jadeninja.distance";
    GC_LEADERBOARD_CHALLENGE = "com.monkeypotion.jadeninja.challenge";  -- Daily Challenge
end
    GC_LEADERBOARD_DEFAULT = GC_LEADERBOARD_DISTANCE;
    GC_ACHEIVEMENT_PREFIX = "com.monkeypotion.jadeninja.ac";

--IAP_PRODUCT_CALLBACK = {};
SEND_LOVE_CALLBACK = {};



--=======================================================================
-- UI Wait states
--=======================================================================

-------------------------------------------------------------------------
UIWaitStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
            UI_WAIT_DELEGATES["active"]();
        	UIManager:ToggleUI("Wait");
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        	UIManager:ToggleUI("Wait");
        end,
    },
    ---------------------------------------------------------------------
    iap =
    {
        OnEnter = function(go)
            UI_WAIT_DELEGATES["iap"]();
        end,

        OnExecute = function(go, sm)
            sm:ChangeState("inactive");
        end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    twitter =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(1000);

            UI_WAIT_DELEGATES["twitter"]();
        	UIManager:ToggleUI("Wait");
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
                ComposeTweet();
            end
        end,

        OnExit = function(go)
            UIManager:ToggleUI("Wait");
        end,
    },
    ---------------------------------------------------------------------
    facebook =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(1000);

            UI_WAIT_DELEGATES["facebook"]();
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
                ComposeFBMessage();
            end
        end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    revive =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(2500);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go)
            ReviveFromIAP();
        end,
    },
};



--=======================================================================
-- Social Manager
--=======================================================================

-------------------------------------------------------------------------
SocialManager =
{
	---------------------------------------------------------------------
    Create = function(self)
        GC_ACH_POOL = IOManager:GetRecord(IO_CAT_CONTENT, "Achievement");
    end,
};

--=======================================================================
-- General Functions
--=======================================================================

-------------------------------------------------------------------------
function OnUIPresentCompleted()
    --log("OnUIPresentCompleted");
	UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("inactive");
end

--=======================================================================
-- Game Center
--=======================================================================

-------------------------------------------------------------------------
function OnGameCenterAuthorizedDelegate(result)
    if (result == true) then
    -- Check data from Parse
        local id = GameKit.GetGameCenterID();
        local rec = IOManager:GetRecord(IO_CAT_HACK, "GameCenter");
        if (rec) then
            if (IOManager:GetValue(IO_CAT_HACK, "GameCenter", id)) then
                CheckUserGiftFromParse();
            else
                log("NEW GC ID: REG NEEDED")
                rec[id] = true;
                local pfID = GameKit.PF_RegisterPlayer();
                IOManager:SetRecord(IO_CAT_HACK, "ParseID", pfID);
                IOManager:Save();
            end
        else
            log("N/A: REG NEEDED")
            local pfID = GameKit.PF_RegisterPlayer();
            IOManager:SetRecord(IO_CAT_HACK, "ParseID", pfID);
            IOManager:SetRecord(IO_CAT_HACK, "GameCenter", { [id]=true, }, true);
        end
    end
end

-------------------------------------------------------------------------
function ShowLeaderboard()
    --log("ShowLeaderboard @ "..GC_LEADERBOARD_DEFAULT);
	UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("active");
    
	GameKit.LogEventWithParameter("Social", "leaderboard", "action", false);

    if IS_PLATFORM_ANDROID then
        GameKit.ShowAllLeaderboards();
    else
        GameKit.ShowLeaderboard(GC_LEADERBOARD_DEFAULT);
    end
end

-------------------------------------------------------------------------
function ShowAchievements()
    --log("ShowAchievements @ "..ITC_TOKEN_PREFIX);
    UpdateMoneyAchievements();
	UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("active");

	GameKit.LogEventWithParameter("Social", "achievements", "action", false);
	GameKit.ShowAchievements();
end

-------------------------------------------------------------------------
function SubmitScore(score, category)
    if (GC_HAS_AUTHORIZED) then
log("SUBMIT: "..score.." => "..category)    
        assert(score);
        assert(category);
        GameKit.SubmitScore(category, score);
    end
end

-------------------------------------------------------------------------
function SubmitAchievement(ach, percent)
    GameKit.SubmitAchievement(ach, percent);
end

-------------------------------------------------------------------------
function ResetAchievements()
    GameKit.ResetAchievements();
end

-------------------------------------------------------------------------
function UpdateAchievement(id, inc, overwrite, doSave)
--    if (not GC_HAS_AUTHORIZED) then
--        return;
--    end
    
--    if (APP_LITE_VERSION) then
--        return;
--    end

    if IS_PLATFORM_ANDROID then
        local HAS_ANDROID_ACHIEVEMENT = ACH_ANDROID_ID[id];
        if not HAS_ANDROID_ACHIEVEMENT then
            return;
        end
    end

    GC_ACH_POOL[id] = GC_ACH_POOL[id] or { count=0, done=nil, };
    inc = inc or 1;

    local repeatable = GC_ACHEIVEMENT_REPEATABLE[id] or false;
    if IS_PLATFORM_ANDROID then
        repeatable = false;
    end
    local ach = GC_ACH_POOL[id];
    
    if (overwrite) then
        ach["count"] = inc;
    else
        if (ach["done"] and not repeatable) then
            --log("Achievement has completed : "..id)
            return;
        end

        ach["count"] = ach["count"] + inc;
    end
    
    --assert(GC_ACHEIVEMENT_MAX[id], "Achivement Max is nil: "..id)
    local percent;
    local maxCount = GC_ACHEIVEMENT_MAX[id] or 1;
    if (ach["count"] >= maxCount) then
        if (repeatable) then
            ach["count"] = 0;
            ach["done"] = false;
        else
            ach["count"] = maxCount;
            ach["done"] = true;
        end
        percent = 100;
    else
        percent = 100 * ach["count"] / maxCount;
    end
    
    if (GC_HAS_AUTHORIZED) then
        --log("Achievement submit : "..id.." / [pct] "..percent.." / [#] "..ach["count"].." / [inc] "..inc)

        if IS_PLATFORM_ANDROID then
            local androidID = ACH_ANDROID_ID[id];
            local unlock = ACH_UNLOCK_TYPE[id] == true;
            GameKit.SubmitAchievement(androidID, percent, unlock);
        else
            GameKit.SubmitAchievement(GC_ACHEIVEMENT_PREFIX .. id, percent, repeatable);
        end
    end
    
    if (doSave) then
        IOManager:Save();
    end
end

-------------------------------------------------------------------------
function BatchUpdateAchievement(id)
    if (GC_ACH_POOL[id] and GC_ACH_POOL[id]["done"]) then
        --log("--- batch done ---: "..id)
        return;
    end

    assert(GC_ACHEIVEMENT_BATCH_MAX[id], "BatchUpdateAchievement error");
    GC_ACH_BATCH[id] = (GC_ACH_BATCH[id] or 0) + 1;
    --log("BatchAchievement: [id] "..id.." / [#] "..GC_ACH_BATCH[id])

    if (GC_ACH_BATCH[id] >= GC_ACHEIVEMENT_BATCH_MAX[id]) then
        --log("BatchAchievement DONE: [id] "..id.." / [#] "..GC_ACH_BATCH[id])
        UpdateAchievement(id, GC_ACH_BATCH[id]);
        GC_ACH_BATCH[id] = 0;
    end
end

-------------------------------------------------------------------------
function HasAchievementDone(id, value)
    if (GC_ACHEIVEMENT_MAX[id]) then
        if (value >= GC_ACHEIVEMENT_MAX[id]) then
            return true;
        end
    end
    return false;
end

-------------------------------------------------------------------------
function UpdateMoneyAchievements()
    local stat = IOManager:GetRecord(IO_CAT_STAT, "Player");
    local koban = stat[GAME_STAT_KOBAN] or 0;
    local coin = stat[GAME_STAT_COIN] or 0;
    --log("KOBAN : "..koban.." / COIN : "..coin);
    
    UpdateAchievement(ACH_KOBAN_EARNED_LV1, koban, true);
    UpdateAchievement(ACH_KOBAN_EARNED_LV2, koban, true);
    UpdateAchievement(ACH_KOBAN_EARNED_LV3, koban, true);
    UpdateAchievement(ACH_KOBAN_EARNED_LV4, koban, true);

    UpdateAchievement(ACH_COIN_EARNED_LV1, coin, true);
    UpdateAchievement(ACH_COIN_EARNED_LV2, coin, true);
    UpdateAchievement(ACH_COIN_EARNED_LV3, coin, true);
    UpdateAchievement(ACH_COIN_EARNED_LV4, coin, true);
end

-------------------------------------------------------------------------
function HasAchievementCompleted(id)
    return GameKit.HasAchievementCompleted(GC_ACHEIVEMENT_PREFIX .. ACH_MONKEY_POTION);
end

--=======================================================================
-- Gift App
--=======================================================================

-------------------------------------------------------------------------
function GiftSelfApp(feedback)
    log("<<< GiftSelfApp >>>")
	GameKit.LogEventWithParameter("Web", "gift", "action", false);
    if (feedback) then
    	GameKit.LogEventWithParameter("Feedback", "gift", "action", false);
    end
    
	GameKit.GiftSelfApp();
end

--=======================================================================
-- Mail
--=======================================================================

-------------------------------------------------------------------------
function OpenMail(subject, appendInfo)
    UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("active");
	GameKit.LogEventWithParameter("Social", "mail", "action", false);
    local recipient = GameKit.GetLocalizedString("support_mail_recipient");
    GameKit.ComposeMail(subject, recipient, appendInfo);
end

-------------------------------------------------------------------------
function OnMailResultReceived(result)
    log("OnMailResultReceived : "..tostring(result))

    if (result == true) then
        UpdateAchievement(ACH_MAIL_MAN);
    	GameKit.LogEventWithParameter("Social", "sent", "mail", false);
    else
	    UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("inactive");
        GameKit.LogEventWithParameter("Social", "cancel", "mail", false);    
    end
end

--=======================================================================
-- Social Framework
--=======================================================================

-------------------------------------------------------------------------
function ComposeSocialMessage(serviceType)
    local v1 = GameDataManager:GetData("Distance") or 0;
    local v2 = GameDataManager:GetData("Score") or 0;
    GameKit.ComposeSocialMessageByValuePair(serviceType, v1, v2);
end

--=======================================================================
-- Twitter
--=======================================================================

-------------------------------------------------------------------------
function OpenTwitter()
	GameKit.LogEventWithParameter("Social", "twitter", "action", false);
	UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("twitter");
end

-------------------------------------------------------------------------
function ComposeTweet()
    ComposeTweetDelegate();
end

-------------------------------------------------------------------------
function OnTweetResultReceived(result)
    if (result == true) then
    	GameKit.LogEventWithParameter("Social", "sent", "twitter", false);
    else
        GameKit.LogEventWithParameter("Social", "cancel", "twitter", false);    
    end
end

-------------------------------------------------------------------------
function OpenSelfTwitter(feedback)
    log("<<< OpenSelfTwitter >>>")
	GameKit.LogEventWithParameter("Web", "twitter", "action", false);
    if (feedback) then
    	GameKit.LogEventWithParameter("Feedback", "twitter", "action", false);
    end
    
    GameKit.OpenSelfTwitter();
end

-------------------------------------------------------------------------
function OpenSelfSinaWeibo()
    log("<<< OpenSelfSinaWeibo >>>")
	GameKit.LogEventWithParameter("Web", "sina", "action", false);
    GameKit.OpenSelfSinaWeibo();
end

--=======================================================================
-- Facebook
--=======================================================================

-------------------------------------------------------------------------
function OpenFacebook()
	GameKit.LogEventWithParameter("Social", "facebook", "action", false);
	UIManager:ToggleUI("Wait");
	UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("facebook");
end

-------------------------------------------------------------------------
function ComposeFBMessage()
    UIManager:ToggleUI("Wait");

    if (GameKit.LoginFacebook()) then
        PostScoreToFacebookFeed();
    end
end

-------------------------------------------------------------------------
function OnFacebookLogin()
    log("OnFacebookLogin success!"); 
    PostScoreToFacebookFeed();
end

-------------------------------------------------------------------------
function PostScoreToFacebookFeed()    
    ComposeFacebookDelegate();
end

-------------------------------------------------------------------------
function OnFacebookResultReceived(result)
    log("OnFacebookResultReceived : "..tostring(result))

    if (result == true) then
    	GameKit.LogEventWithParameter("Social", "sent", "facebook", false);
    else
        GameKit.LogEventWithParameter("Social", "cancel", "facebook", false);    
    end
end

-------------------------------------------------------------------------
function OpenSelfFacebook(feedback)
    log("<<< OpenSelfFacebook >>>")
	GameKit.LogEventWithParameter("Web", "facebook", "action", false);
    if (feedback) then
        GameKit.LogEventWithParameter("Feedback", "facebook", "action", false);
    end
    
    GameKit.OpenSelfFacebook();
end

--=======================================================================
-- Feedback
--=======================================================================

-------------------------------------------------------------------------
function ShowLeaderboardChoices()
    AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
    OnAlertUIResult = OnAlertUIResultForLeaderboard;
    GameKit.ShowLeaderboardChoices();
end

-------------------------------------------------------------------------
function OnAlertUIResultForLeaderboard(result)
    if (result == 1) then
        ShowLeaderboard();
    end
end

-------------------------------------------------------------------------
function ShowLoveHateChoices()
	APP_VERSION = GameKit.GetAppVersion();
    UIManager:GetUIComponent("SendLove", "Attribute"):Clear("Love");
    AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
    OnAlertUIResult = OnAlertUIResultForLoveHate;
    GameKit.ShowLoveHateChoices();
end

-------------------------------------------------------------------------
function ShowRatingChoices()
    OnAlertUIResult = OnAlertUIResultForRating;
    GameKit.ShowRatingChoices();
end

-------------------------------------------------------------------------
function OpenRatingPage()
    IOManager:SetValue(IO_CAT_CONTENT, "Feedback", "Rating", APP_VERSION, true);
    GameKit.LogEventWithParameter("Feedback", "rating", "action", false);
    GameKit.RateSelfApp();
end

-------------------------------------------------------------------------
function OnAlertUIResultForLoveHate(result)
    if (result == 0) then
    --========================================
    -- UI: SendFeedback
    --========================================
        GameKit.LogEventWithParameter("Feedback", "hate", "Choice", false);
        StageManager:PushStageForPopup("SendFeedback");
    elseif (result == 1) then  
    --========================================
    -- UI: SendLove
    --========================================
        GameKit.LogEventWithParameter("Feedback", "love", "Choice", false);
        
        if (IOManager:GetValue(IO_CAT_CONTENT, "Feedback", "Rating") == APP_VERSION) then
            log("[Rating] Rate Done @ v"..APP_VERSION);
            UIManager:GetWidget("SendLove", "Option1"):SetImage("ui_feedback_button_twitter");
            UIManager:GetWidget("SendLove", "Option2"):SetImage("ui_feedback_button_gift");

            SEND_LOVE_CALLBACK[1] = OpenSelfTwitter;
            SEND_LOVE_CALLBACK[2] = GiftSelfApp;
        else
            log("[Rating] Not Yet @ v"..APP_VERSION);
            UIManager:GetWidget("SendLove", "Option1"):SetImage("ui_feedback_button_dent");
            UIManager:GetWidget("SendLove", "Option2"):SetImage("ui_feedback_button_twitter");
            
            SEND_LOVE_CALLBACK[1] = ShowRatingChoices;
            SEND_LOVE_CALLBACK[2] = OpenSelfTwitter;
        end

        StageManager:PushStageForPopup("SendLove");
        UIManager:GetUIComponent("SendLove", "Attribute"):Set("Love", true);
    else
        assert(false, "Not supported for OnAlertUIResultForLoveHate");
    end
end

-------------------------------------------------------------------------
function OnAlertUIResultForRating(result)
    if (result == 1) then
        OpenRatingPage();
    end
end

-------------------------------------------------------------------------
function SendFeedbackOption1()
    GameKit.LogEventWithParameter("Feedback", "ask", "Hate", false);
    StageManager:PopStageForPopup();
    OpenMail(GameKit.GetLocalizedString("mail_title1"), false);
end

-------------------------------------------------------------------------
function SendFeedbackOption2()
    GameKit.LogEventWithParameter("Feedback", "bug", "Hate", false);
    StageManager:PopStageForPopup();
    OpenMail(GameKit.GetLocalizedString("mail_title2"), true);
end

-------------------------------------------------------------------------
function SendFeedbackSkip()
    GameKit.LogEventWithParameter("Feedback", "skip", "Hate", false);
    StageManager:PopStageForPopup();
end

-------------------------------------------------------------------------
function SendLoveOption1()
    GameKit.LogEventWithParameter("Feedback", "option1", "Love", false);
    StageManager:PopStageForPopup();
    SEND_LOVE_CALLBACK[1](true);
end

-------------------------------------------------------------------------
function SendLoveOption2()
    GameKit.LogEventWithParameter("Feedback", "option2", "Love", false);
    StageManager:PopStageForPopup();
    SEND_LOVE_CALLBACK[2](true);
end

-------------------------------------------------------------------------
function SendLoveSkip()
    GameKit.LogEventWithParameter("Feedback", "skip", "Love", false);
    StageManager:PopStageForPopup();
end

--=======================================================================
-- Movie
--=======================================================================

-------------------------------------------------------------------------
function PlayMovie(file, movieCallback)
    assert(file);
    assert(movieCallback);
    
	GameKit.PlayMovie(file, "Asset/Video");
    OnMoviePlaybackCompleted = movieCallback;
end

--=======================================================================
-- iCloud
--=======================================================================

-------------------------------------------------------------------------
function ShowiCloudChoices()
    OnAlertUIResult = OnAlertUIResultForiCloud;
    GameKit.ShowMessageChoices("icloud_title", "icloud_desc", "button_ok");    
end

-------------------------------------------------------------------------
function ReadSaveDataFromFile()
    log("<<<<===== ReadSaveDataFromFile =====>>>>>>")
    --ResolveConflictForSaveFile(GameDataManager:GetData("CloudData"));
    OnCloudSaveFileReceived(IO_ICLOUD_DATA)
    GameKit.RemoveFile(IO_ICLOUD_DATA);
    --GameDataManager:SetData("CloudData", nil);

    -- Restore IAB product after sync from cloud, so we avoid potential conflict.
    -- E.g. restore might find thief char is bought before but not in cloud data 
    -- (maybe we didn't got chance to save the state to cloud when player bought it)
    if IS_PLATFORM_ANDROID then
        GameKit.RestorePurchases();
    end
end

-------------------------------------------------------------------------
function OnAlertUIResultForiCloud(result)
    if (result == 1) then
        AudioManager:PlaySfx(SFX_UI_LEVEL_MEDAL);
        IOManager:SetRecord(IO_CAT_OPTION, "iCloud", true, true);
        UIManager:GetWidget("MainEntry", "iCloud"):ChangeState(true);
        
        if (GameKit.IsFileExist(IO_ICLOUD_DATA)) then
            ReadSaveDataFromFile();
        else
            log("Starting sync from iCloud...")
            GameKit.SyncFromiCloud();
        end
--[[
        local cloudData  = GameDataManager:GetData("CloudData");
        if (cloudData) then
            log("<<<<===== Sync From Cloud File =====>>>>>>")
            ResolveConflictForSaveFile(cloudData);
            GameDataManager:SetData("CloudData", nil);
        end
--]]        
    else
        AudioManager:PlaySfx(SFX_UI_BUTTON_1);
        IOManager:SetRecord(IO_CAT_OPTION, "iCloud", false, true);
        UIManager:GetWidget("MainEntry", "iCloud"):ChangeState(false);
    end
end

-------------------------------------------------------------------------
function EnableiCloudSync(state)
    IOManager:SetRecord(IO_CAT_OPTION, "iCloud", state, true);
    
    if (state == true) then
        if (GameKit.IsFileExist(IO_ICLOUD_DATA)) then
            ReadSaveDataFromFile();
        else
            log("Starting sync from iCloud...")
            GameKit.SyncFromiCloud();
        end
    end
end

-------------------------------------------------------------------------
function UpdateiCloudButton()
    UIManager:GetWidget("MainEntry", "iCloud"):ChangeState(IOManager:GetRecord(IO_CAT_OPTION, "iCloud"));
end

-------------------------------------------------------------------------
function SyncFromCloud()
    if (IOManager:GetRecord(IO_CAT_OPTION, "iCloud") == true) then
        GameKit.SyncFromiCloud();
    else
    --log("SyncFromCloud : N/A")
        -- If cloud sync is not turn on, restore purchases here.
        -- If cloud sync is on, restore purchases in ReadSaveDataFromFile.
        if IS_PLATFORM_ANDROID then
            GameKit.RestorePurchases();
        end
    end
end

-------------------------------------------------------------------------
function SaveToCloud()
    if (IOManager:GetRecord(IO_CAT_OPTION, "iCloud") == true) then
        log("SaveToCloud ======>");
        GameKit.SaveFileToiCloud(IO_MAIN_DATA);
    end
end

--=======================================================================
-- Monetizations
--=======================================================================

-------------------------------------------------------------------------
function ShowMessageChoices(title, desc, func)
    assert(func, "Callback function has not been set");
    OnAlertUIResult = func;
    GameKit.ShowMessageChoices(title, desc, "button_unlock");    
end

--=======================================================================
-- Parse
--=======================================================================

-------------------------------------------------------------------------
function SubmitParseScore(score, index)
    local recGC = IOManager:GetRecord(IO_CAT_HACK, "GameCenter");
    if (recGC == nil) then
        return;
    end
    
    if (recGC["NoReportScore"]) then
        log("Submit Score [DC]: Don't Report Score to Parse");
        return;
    end
    
    local count = IOManager:ModifyValue(IO_CAT_CONTENT, "ChallengeMode", "Count", 1);
    local coin = MoneyManager:GetCoin();
    local gold = MoneyManager:GetKoban();
    local map = "Shadow" .. index;
    local avatar = LevelManager:GetAvatarID();
    log("Submit Score [DC]: " .. score .. "m / map: " .. map .. " / " .. count .." times / avatar: " .. avatar)
    
    local pocket = IOManager:GetRecord(IO_CAT_HACK, "Pocket");
    local koban1 = pocket["Koban1"] or 0;
    local koban2 = pocket["Koban2"] or 0;
    local koban3 = pocket["Koban3"] or 0;
    local koban4 = pocket["Koban4"] or 0;
    log("Koban [DC] #1: " .. koban1 .. " / #2: " .. koban2 .. " / #3: " .. koban3 .. " / #4: " .. koban4)
    
    GameKit.PF_SendPlayerScore(score, count, coin, gold, map, avatar, koban1, koban2, koban3, koban4);
end

-------------------------------------------------------------------------
function CheckUserGiftFromParse()
    local result = false;
    local lastTime = IOManager:GetValue(IO_CAT_HACK, "GameCenter", "lastTime") or 0;
    local currentTime = math.floor(GameKit.GetCurrentSystemTime());
    --log("current: "..currentTime.." / last: "..lastTime.." => "..currentTime - lastTime)

    if (lastTime) then
        if (currentTime - lastTime > DURATION_PARSE_UPDATE) then
--[[ @DEBUG
        if (currentTime - lastTime > 10) then
--]]
            result = true;
        end
    else
        result = true;
    end

    if (result) then    
        log("...Retrieving Data from PARSE...")
        IOManager:SetValue(IO_CAT_HACK, "GameCenter", "lastTime", currentTime, true);
        GameKit.PF_GetPlayerGift();
    end
end

-------------------------------------------------------------------------
function OnCheckGift(gold, coin, gift, dcLocked, noReportScore, message)
    --log("GOLD : "..gold.." / COIN : "..coin.." / GIFT : "..tostring(gift).." / DCLock : "..tostring(dcLocked).." / NoReport : "..tostring(noReportScore))
    IOManager:SetValue(IO_CAT_HACK, "GameCenter", "ChallengeLocked", dcLocked);
    IOManager:SetValue(IO_CAT_HACK, "GameCenter", "NoReportScore", noReportScore);
    
    if (coin > 0) then
        MoneyManager:ModifyCoin(coin);
        GameKit.ShowMessage("text_status", "You just got ".. coin .." coins from Master Tao!");
        AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);
    end
    
    if (gold > 0) then
        MoneyManager:ModifyKoban(gold);
        GameKit.ShowMessage("text_status", "You just got ".. gold .." golds from Master Tao!");
        AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);
    end
    
    if (gift == true) then
        ProceedPaidGift();
    end
    
    if (message) then
        GameKit.ShowMessage("text_status", message);
        AudioManager:PlaySfx(SFX_CHAR_KABUKI_TRAP);
    end
    
    IOManager:Save();
end

--=======================================================================
-- In App Purchase
--=======================================================================

-------------------------------------------------------------------------
function BuyProduct(id, func, showMessage)
    assert(id);
    assert(func);
        
    UIManager:ToggleUI("Wait");
	UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("iap");

    --log("[In App Purchase] BuyProduct : [id] "..id);
    GameKit.LogEventWithParameter("IAP", id, "product", false);    
    GameKit.BuyProduct(id, showMessage);
    
    IAP_PRODUCT_CALLBACK[id] = func;
end

-------------------------------------------------------------------------
function OnPurchaseConfirmed(result, id, device)
    --log("OnPurchaseConfirmed: [result] "..tostring(result).." [device] "..tostring(device));
    UIManager:ToggleUI("Wait");    

    if (result == true) then
    -- Purchase success
        GameKit.LogEventWithParameter("IAP", tostring(device), "device", false);
        GameKit.LogEventWithParameter("IAP", "yes", "result", false);
        IAP_PRODUCT_CALLBACK[id](id, true);
    else
    -- Purchase failed
        GameKit.LogEventWithParameter("IAP", "no", "result", false);
        --GameKit.ShowMessage("text_status", "iap_error");
        
        if (StageManager:IsOnStage("RevivePause")) then
            StageManager:ChangeStage("GameCountdown");
        end
    end
end

-------------------------------------------------------------------------
function OnPurchaseRestored(result, id)
    if (result == true) then
    -- Purchase success
    --log("OK")
        IAP_RESTORE_CALLBACK[id](id);
        -- AudioManager:PlaySfx(SFX_UI_MONEY_GAIN);
    --else
    --log("no no")    
    end
end

-------------------------------------------------------------------------
function ShowIAPChoices()
    OnAlertUIResult = OnAlertUIResultForIAP;
    GameKit.ShowIAPChoices();
end

-------------------------------------------------------------------------
function OnAlertUIResultForIAP(result)
    if (result == 0) then
        ReviveInactionFromIAP();
    elseif (result == 1) then
        local obj = IAP_ITEM_CALLBACK[9999];
        if (obj) then
            BuyProduct(obj[1], obj[2], false);
        end
    end
end



--=======================================================================
-- Delegates
--=======================================================================

-------------------------------------------------------------------------
function OnBoughtKoban1(id)
    if (id == "com.monkeypotion.jadeninja.newkoban1") then
        GameKit.LogEventWithLocale("IAP_Country", "newkoban1");
        LogPocket(1);
        KobanEarned(TREASURE_COUNT[1]);
        ShopManager:CompleteIAP(true);
    end
end

-------------------------------------------------------------------------
function OnBoughtKoban2(id)
    if (id == "com.monkeypotion.jadeninja.newkoban2") then
        GameKit.LogEventWithLocale("IAP_Country", "newkoban2");
        LogPocket(2);
        KobanEarned(TREASURE_COUNT[2]);
        ShopManager:CompleteIAP(true);
    end
end

-------------------------------------------------------------------------
function OnBoughtKoban3(id)
    if (id == "com.monkeypotion.jadeninja.newkoban3") then
        GameKit.LogEventWithLocale("IAP_Country", "newkoban3");
        LogPocket(3);
        KobanEarned(TREASURE_COUNT[3]);
        ShopManager:CompleteIAP(true);
    end
end

-------------------------------------------------------------------------
function OnBoughtKoban4(id)
    if (id == "com.monkeypotion.jadeninja.newkoban4") then
        GameKit.LogEventWithLocale("IAP_Country", "newkoban4");
        LogPocket(4);
        KobanEarned(TREASURE_COUNT[4]);
        ShopManager:CompleteIAP(true);
    end
end

-------------------------------------------------------------------------
function OnBoughtKobanRevival(id)
    --log("OnBoughtKobanRevival id:" .. id);
    if (id == "com.monkeypotion.jadeninja.newkoban1") then
        GameKit.LogEventWithLocale("IAP_Country", "newkoban1_revival");
        LogPocket(1);
        KobanEarned(TREASURE_COUNT[1] + 1);

        if not IS_PLATFORM_ANDROID then
            UIManager:ToggleUI("Wait");
            UIManager:GetWidgetComponent("Wait", "Content", "StateMachine"):ChangeState("revive");
        end
        ReviveFromIAP();
    end
end

-------------------------------------------------------------------------
function OnBoughtStarterKit(id, firstBuy)
    if (id == "com.monkeypotion.jadeninja.starterkit") then
        if (firstBuy) then
            GameKit.LogEventWithLocale("IAP_Country", "starterkit");
        end
        --LogPocket(5);
        ShopManager:BuyStarterKitByDollar(firstBuy);
    end
end

-------------------------------------------------------------------------
function OnBoughtChar1(id, firstBuy)
    if (id == "com.monkeypotion.jadeninja.avatar1") then
        if (firstBuy) then
            GameKit.LogEventWithLocale("IAP_Country", "avatar1");
            GameKit.LogEventWithParameter("NonCon_IAP", "avatar1", "product", false);
        end
        ShopManager:BuyAvatarByDollar(2, firstBuy);
    end
end

-------------------------------------------------------------------------
function OnBoughtChar2(id, firstBuy)
    if (id == "com.monkeypotion.jadeninja.avatar2") then
        if (firstBuy) then
            GameKit.LogEventWithLocale("IAP_Country", "avatar2");
            GameKit.LogEventWithParameter("NonCon_IAP", "avatar2", "product", false);
        end
        ShopManager:BuyAvatarByDollar(1, firstBuy);
    end
end

-------------------------------------------------------------------------
function OnBoughtJade1(id, firstBuy)
    if (id == "com.monkeypotion.jadeninja.jade1") then
        if (firstBuy) then
            GameKit.LogEventWithLocale("IAP_Country", "jade1");
            GameKit.LogEventWithParameter("NonCon_IAP", "jade1", "product", false);
        end
        ShopManager:BuyJadeByDollar(1, firstBuy);
    end
end

-------------------------------------------------------------------------
function OnRestoreStarterKit(id)
    ShopManager:SerializeAvatar(AVATAR_THIEF);
    IOManager:SetRecord(IO_CAT_HACK, "StarterKit", true);
end

-------------------------------------------------------------------------
function OnRestoreChar1(id)
    ShopManager:SerializeAvatar(AVATAR_THIEF);
end

-------------------------------------------------------------------------
function OnRestoreChar2(id)
    ShopManager:SerializeAvatar(AVATAR_WARLORD);
end

-------------------------------------------------------------------------
function OnRestoreJade1(id)
    ShopManager:SerializeJade(JADE_EFFECT_INNO_PROTECT);
end

-------------------------------------------------------------------------
IAP_ITEM_CALLBACK =
{
	-- Consumables
	[9999] = { "com.monkeypotion.jadeninja.newkoban1", OnBoughtKobanRevival, },
	[9101] = { "com.monkeypotion.jadeninja.newkoban1", OnBoughtKoban1, },
	[9102] = { "com.monkeypotion.jadeninja.newkoban2", OnBoughtKoban2, },
	[9103] = { "com.monkeypotion.jadeninja.newkoban3", OnBoughtKoban3, },
	[9104] = { "com.monkeypotion.jadeninja.newkoban4", OnBoughtKoban4, },
	-- Non-Consumables
	[9201] = { "com.monkeypotion.jadeninja.starterkit", OnBoughtStarterKit, },
	[3105] = { "com.monkeypotion.jadeninja.avatar1", OnBoughtChar1, },
	[3106] = { "com.monkeypotion.jadeninja.avatar2", OnBoughtChar2, },
	[4001] = { "com.monkeypotion.jadeninja.jade1", OnBoughtJade1, },
};

IAP_PRODUCT_CALLBACK =
{
	-- Consumables
    ["com.monkeypotion.jadeninja.newkoban1"] = OnBoughtKobanRevival;
    ["com.monkeypotion.jadeninja.newkoban1"] = OnBoughtKoban1;
    ["com.monkeypotion.jadeninja.newkoban2"] = OnBoughtKoban2;
    ["com.monkeypotion.jadeninja.newkoban3"] = OnBoughtKoban3;
    ["com.monkeypotion.jadeninja.newkoban4"] = OnBoughtKoban4;
	-- Non-Consumables
    ["com.monkeypotion.jadeninja.starterkit"] = OnBoughtStarterKit;
    ["com.monkeypotion.jadeninja.avatar1"] = OnBoughtChar1;
    ["com.monkeypotion.jadeninja.avatar2"] = OnBoughtChar2;
    ["com.monkeypotion.jadeninja.jade1"] = OnBoughtJade1;
};

IAP_RESTORE_CALLBACK =
{
    ["com.monkeypotion.jadeninja.starterkit"] = OnRestoreStarterKit;
    ["com.monkeypotion.jadeninja.avatar1"] = OnRestoreChar1;
    ["com.monkeypotion.jadeninja.avatar2"] = OnRestoreChar2;
    ["com.monkeypotion.jadeninja.jade1"] = OnRestoreJade1;
};

-------------------------------------------------------------------------
UI_WAIT_DELEGATES =
{
    ---------------------------------------------------------------------
    active = function()
    end,
    ---------------------------------------------------------------------
    iap = function()
    end,
    ---------------------------------------------------------------------
    twitter = function()
    end,
    ---------------------------------------------------------------------
    facebook = function()
    end,
};

-------------------------------------------------------------------------
function OnGameCenterAchievementSubmittedDelegate(result, percent)
    if (percent == 100) then
        --log("  Achievement Completed!")
        AudioManager:PlaySfx(SFX_UI_ACH);
    end
end

-------------------------------------------------------------------------
function ComposeTweetDelegate()
    local v1 = GameDataManager:GetData("Distance") or 0;
    local v2 = GameDataManager:GetData("Score") or 0;
    GameKit.ComposeTweetByValuePair(v1, v2);
end

-------------------------------------------------------------------------
function ComposeFacebookDelegate()
    local avatar = LevelManager:GetAvatarName() or "avatar_ninjagirl";
    local v1 = GameDataManager:GetData("Distance") or 0;
    local v2 = GameDataManager:GetData("Score") or 0;
    local pic = "http://www.jadeninja.com/fb/" .. avatar .. ".png";
    GameKit.PostFacebookFeedByValuePair(v1, v2, pic);
end
