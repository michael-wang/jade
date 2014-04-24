//
//  Luabinding.h
//  Legion
//
//  Created by Lucifer Jheng on 2013/12/30.
//  Copyright (c) 2013年 Monkey Potion. All rights reserved.
//
#include <Framework/LuaScriptDefine.hpp>



void RegisterGameFunctions(LuaState state);

void ShowMessage(const char* title, const char* message);
void OpenURL(const char* url);
void OpenAppStore(const char* appName);
void OpenSelfTwitter();
void OpenSelfFacebook();
void OpenSelfSinaWeibo();
void GiftSelfApp();
void RateSelfApp();
void ScheduleLocalNotification(const char* titleText, float duration);
void CancelAllLocalNotification();
const char* GetLocalizedString(const char* key);
const char* GetAppVersion();
const char* GetCurrentSystemTime();
void VibrateDevice();
void EnableAccelerometer(bool enable);
bool IsGameCenterAvailable();
bool HasGameCenterAuthenticated();
void ShowLeaderboard(const char* identifier);
void ShowLeaderboardForToday(const char* id);
void ShowAllLeaderboards();
void ShowAchievements();
void SubmitScore(const char* category, double score);
void SubmitAchievement(const char* identifier, float percent, bool repeatable);
void ResetAchievements();
bool HasAchievementCompleted(const char* identifier);
void ComposeMail(const char* subject, const char* recipient, bool shouldAppendInfo);
void ComposeSocialMessageByValuePair(int type, unsigned int value1, unsigned int value2);
void ComposeTweet(const char* text, const char* url, bool useSnapshot);
void ComposeTweetByValuePair(unsigned int value1, unsigned int value2);
bool LoginFacebook();
void PostFacebookFeed(const char* name, const char* caption, const char* description, const char* picture);
void PostFacebookFeedByValuePair(unsigned int value1, unsigned int value2, const char* picture);
void BuyProduct(const char* productId, bool showMessage);
void RestorePurchases();
void PlayMovie(const char* fileName, const char* pathName);
int GetInterfaceOrientation();
bool IsFileExist(const char* fileName);
bool RemoveFile(const char* fileName);
void ShowLeaderboardChoices();
void ShowLoveHateChoices();
void ShowRatingChoices();
void ShowIAPChoices();
void ShowMessageChoices(const char* title, const char* desc, const char* action);
const char* GetGameCenterID();
const char* GetUserLanguage();
// Flurry
void LogEvent(const char* eventName, bool timedEvent);
void LogEventEnded(const char* eventName);
void LogEventWithParameter(const char* eventName, const char* value, const char* key, bool timedEvent);
void LogEventWithLocale(const char* eventName, const char* key);
// iCloud
void SaveFileToiCloud(const char* fileName);
void SyncFromiCloud();
// Parse Framework
void PF_RegisterPlayer();
void PF_GetPlayerGift();
void PF_SendPlayerScore(unsigned int score, unsigned int count, unsigned int coin, unsigned int gold, const char* map, const char* avatar, unsigned int koban1, unsigned int koban2, unsigned int koban3, unsigned int koban4);
// Charboost
void ShowInterstitial(const char* location);
// UIKit UILabel
void RenderText();
void SetTextTranslate(int x, int y);
