//
//  Luabinding.mm
//  Legion
//
//  Created by Lucifer Jheng on 2013/12/30.
//  Copyright (c) 2013年 Monkey Potion. All rights reserved.
//

#include "Luabinding.h"
#include <time.h>
#include <Framework/LuaScriptManager.hpp>
#include "AndroidFileSystem.h"
#include "AndroidLogger.h"
#include "JavaInterface.h"


//==============================================================================================================
// Luabind
//==============================================================================================================

static AndroidLogger logger("native::GameKit", true);

void RegisterGameFunctions(LuaState state)
{
    LOGD(logger, "RegisterGameFunctions")

    using namespace luabind;
    
    module(state, "GameKit")
    [
        def("SetTextTranslate", &SetTextTranslate),
        def("RenderText", &RenderText),
        // System
        def("ShowMessage", &ShowMessage),
        def("ShowMessageChoices", &ShowMessageChoices),
        def("ShowLeaderboardChoices", &ShowLeaderboardChoices),
        def("ShowLoveHateChoices", &ShowLoveHateChoices),
        def("ShowRatingChoices", &ShowRatingChoices),
        def("ShowIAPChoices", &ShowIAPChoices),
        def("OpenURL", &OpenURL),
        def("OpenAppStore", &OpenAppStore),
        def("OpenSelfTwitter", &OpenSelfTwitter),
        def("OpenSelfFacebook", &OpenSelfFacebook),
        def("OpenSelfSinaWeibo", &OpenSelfSinaWeibo),
        def("GiftSelfApp", &GiftSelfApp),
        def("RateSelfApp", &RateSelfApp),
        def("VibrateDevice", &VibrateDevice),
        def("GetLocalizedString", &GetLocalizedString),
        def("GetAppVersion", &GetAppVersion),
        def("GetCurrentSystemTime", &GetCurrentSystemTime),
        def("ScheduleLocalNotification", &ScheduleLocalNotification),
        def("CancelAllLocalNotification", &CancelAllLocalNotification),
        def("IsFileExist", &IsFileExist),
        def("RemoveFile", &RemoveFile),
//        def("GetInterfaceOrientation", &GetInterfaceOrientation),
        // Mail & Social
        def("ComposeMail", &ComposeMail),
        def("ComposeSocialMessageByValuePair", &ComposeSocialMessageByValuePair),
        // Twitter
        def("ComposeTweet", &ComposeTweet),
        def("ComposeTweetByValuePair", &ComposeTweetByValuePair),
        // Facebook
        def("LoginFacebook", &LoginFacebook),
        def("PostFacebookFeed", &PostFacebookFeed),
        def("PostFacebookFeedByValuePair", &PostFacebookFeedByValuePair),
        // Game Center
        def("ShowLeaderboard", &ShowLeaderboard),
        def("ShowAchievements", &ShowAchievements),
        def("SubmitScore", &SubmitScore),
        def("SubmitAchievement", &SubmitAchievement),
        def("ResetAchievements", &ResetAchievements),
        def("HasAchievementCompleted", &HasAchievementCompleted),
        def("HasGameCenterAuthenticated", &HasGameCenterAuthenticated),
        def("GetGameCenterID", &GetGameCenterID),
        def("GetUserLanguage", &GetUserLanguage),
        // Parse
        def("PF_RegisterPlayer", &PF_RegisterPlayer),
        def("PF_GetPlayerGift", &PF_GetPlayerGift),
        def("PF_SendPlayerScore", &PF_SendPlayerScore),
        // Chartboost
        def("ShowInterstitial", &ShowInterstitial),
        // IAP
        def("BuyProduct", &BuyProduct),
        def("RestorePurchases", &RestorePurchases),
        // Media
        def("PlayMovie", &PlayMovie),
        // iCloud
        def("SaveFileToiCloud", &SaveFileToiCloud),
        def("SyncFromiCloud", &SyncFromiCloud),
        // Flurry
        def("LogEvent", &LogEvent),
        def("LogEventEnded", &LogEventEnded),
        def("LogEventWithParameter", &LogEventWithParameter),
        def("LogEventWithLocale", &LogEventWithLocale)
    ];
}

//==============================================================================================================
// Global Functions
//==============================================================================================================

void ShowMessage(const char* title, const char* message)
{
	// UIAlertView* alert= [[UIAlertView alloc]
 //                         initWithTitle:NSLocalizedString([NSString stringWithUTF8String:title], nil)
 //                         message:NSLocalizedString([NSString stringWithUTF8String:message], nil)
 //                         delegate:NULL
 //                         cancelButtonTitle:NSLocalizedString(@"button_ok", nil)
 //                         otherButtonTitles:NULL];
	// [alert show];
    LOGD(logger, "ShowMessage title:%s, message:%s", title, message)

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "ShowMessage: java == NULL")
        return;
    }

    java->ShowMessage(title, message, "button_ok", NULL);
}

void OpenURL(const char* url)
{
    // NSURL* urlString = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
    
    // if ([[UIApplication sharedApplication] canOpenURL:urlString])
    // {
    //     [[UIApplication sharedApplication] openURL:urlString];
    // }
    // else
    // {
    //     NSLog(@"Error opening url: %@", [NSString stringWithUTF8String:url]);
    // }
}

void OpenAppStore(const char* appName)
{
    // NSURL* urlString = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.com/apps/%s", appName]];
    
    // if ([[UIApplication sharedApplication] canOpenURL:urlString])
    // {
    //     [[UIApplication sharedApplication] openURL:urlString];
    // }
    // else
    // {
    //     NSLog(@"Error opening url: %@", [NSString stringWithUTF8String:appName]);
    // }

    LOGD(logger, "OpenAppStore appName:%s", appName)
}

void OpenSelfTwitter()
{
    // NSURL* urlString = [NSURL URLWithString:[NSString stringWithFormat:@"twitter:///user?screen_name=%@", kTwitterAccount]];
    
    // if ([[UIApplication sharedApplication] canOpenURL:urlString])
    // {
    //     [[UIApplication sharedApplication] openURL:urlString];
    // }
    // else
    // {
    //     NSLog(@"Open Twitter from Safari");
    //     NSURL* urlNormal = [NSURL URLWithString:[NSString stringWithFormat:@"http:///twitter.com/%@", kTwitterAccount]];
    //     [[UIApplication sharedApplication] openURL:urlNormal];
    // }
    LOGD(logger, "OpenSelfTwitter")
}

void OpenSelfFacebook()
{
    // NSURL* urlString = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", kFBPageID]];
    
    // if ([[UIApplication sharedApplication] canOpenURL:urlString])
    // {
    //     [[UIApplication sharedApplication] openURL:urlString];
    // }
    // else
    // {
    //     NSLog(@"Open Facebook from Safari");
    //     NSURL* urlNormal = [NSURL URLWithString:[NSString stringWithFormat:@"http:///facebook.com/%@", kFBPageID]];
    //     [[UIApplication sharedApplication] openURL:urlNormal];
    // }
    LOGD(logger, "OpenSelfFacebook")
}

void OpenSelfSinaWeibo()
{
    // NSURL* urlNormal = [NSURL URLWithString:[NSString stringWithFormat:kSinaWeibo]];
    // [[UIApplication sharedApplication] openURL:urlNormal];
    LOGD(logger, "OpenSelfSinaWeibo")
}

void GiftSelfApp()
{
    // NSURL* urlString = [NSURL URLWithString:[NSString stringWithFormat:@"itms-appss://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%@&productType=C&pricingParameter=STDQ&mt=8&ign-mscache=1", kAppStoreID]];
    // [[UIApplication sharedApplication] openURL:urlString];
    LOGD(logger, "GiftSelfApp")
}

void RateSelfApp()
{
    // NSURL* urlString = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kAppStoreID]];
    // [[UIApplication sharedApplication] openURL:urlString];
    LOGD(logger, "RateSelfApp")
}

const char* GetLocalizedString(const char* key)
{
    // NSString* value = NSLocalizedString([NSString stringWithUTF8String:key], nil);
    // return [value UTF8String];
    LOGD(logger, "GetLocalizedString key:%s", key)

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "GetLocalizedString: java == NULL")
        return key;
    }

    return java->GetString(key);
}

const char* GetAppVersion()
{
    // NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // return [appVersion UTF8String];
    LOGD(logger, "GetAppVersion")
    return "Android-1.0.0";
}

const char* GetCurrentSystemTime()
{
    // NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    // return [[NSString stringWithFormat:@"%f", now] UTF8String];
    LOGD(logger, "GetCurrentSystemTime")

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "GetCurrentSystemTime: java == NULL")
        return "0";
    }

    const char* result = java->GetCurrentSystemTime();
    LOGD(logger, "GetCurrentSystemTime result:%s", result)
    return result;
}

void ScheduleLocalNotification(const char* titleText, float duration)
{
    // UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // localNotification.alertBody = NSLocalizedString([NSString stringWithUTF8String:titleText], nil);
    // localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:duration];
    // localNotification.timeZone = [NSTimeZone defaultTimeZone];
    // localNotification.soundName = UILocalNotificationDefaultSoundName;
    // localNotification.applicationIconBadgeNumber = 1;
    
    // [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    LOGD(logger, "ScheduleLocalNotification titleText:%s, duration:%f", titleText, duration)
}

void CancelAllLocalNotification()
{
    // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    LOGD(logger, "CancelAllLocalNotification")
}

void VibrateDevice()
{
    // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    LOGD(logger, "VibrateDevice")
}

bool IsGameCenterAvailable()
{
    // return [g_ViewController isGameCenterAvailable];
    LOGD(logger, "IsGameCenterAvailable")
    return false;
}

bool HasGameCenterAuthenticated()
{
    // return [g_ViewController hasGameCenterAuthenticated];
    LOGD(logger, "HasGameCenterAuthenticated")
    return false;
}

void ShowLeaderboard(const char* identifier)
{
    // assert(identifier);
    // [g_ViewController showLeaderboard:[NSString stringWithUTF8String:identifier]];
    LOGD(logger, "ShowLeaderboard identifier:%s", identifier)
}

void ShowAchievements()
{
    // [g_ViewController showAchievements];
    LOGD(logger, "ShowAchievements")
}

void SubmitScore(const char* category, double score)
{
    // assert(category);
    // assert(score > 0);
    // [g_ViewController submitHighScore:score forCategory:[NSString stringWithUTF8String:category]];
    LOGD(logger, "SubmitScore category:%s, score:%f", category, score)
}

void SubmitAchievement(const char* identifier, float percent, bool repeatable)
{
    // assert(identifier);
    // assert(percent >= 0);
    // [g_ViewController submitAchievement:[NSString stringWithUTF8String:identifier] percentComplete:percent repeatable:repeatable];
    LOGD(logger, "SubmitAchievement identifier:%s, percent:%f, repeatable:%d", identifier, percent, repeatable)
}

void ResetAchievements()
{
    // [g_ViewController resetAchievements];
    LOGD(logger, "ResetAchievements")
}

bool HasAchievementCompleted(const char* identifier)
{
    // return [g_ViewController hasAchievementCompleted:[NSString stringWithUTF8String:identifier]];
    LOGD(logger, "HasAchievementCompleted identifier:%s", identifier)
    return false;
}

const char* GetGameCenterID()
{
    // return [[GKLocalPlayer localPlayer].playerID UTF8String];
    LOGD(logger, "GetGameCenterID")
    return "0";
}

const char* GetUserLanguage()
{
    // return [[[NSLocale preferredLanguages] objectAtIndex:0] UTF8String];
    LOGD(logger, "GetUserLanguage")
    return "zh-Hans";
}

void ComposeMail(const char* subject, const char* recipient, bool shouldAppendInfo)
{
    // if (strcmp(recipient, "") == 0)
    // {
    //     [g_ViewController composeMail:[NSString stringWithUTF8String:subject] recipient:kSupportEmail shouldAppendInfo:shouldAppendInfo];
    // }
    // else
    // {
    //     [g_ViewController composeMail:[NSString stringWithUTF8String:subject] recipient:[NSString stringWithUTF8String:recipient] shouldAppendInfo:shouldAppendInfo];
    // }
    LOGD(logger, "ComposeMail subject:%s, recipient:%s, shouldAppendInfo:%d", subject, recipient, shouldAppendInfo)
}

void ComposeSocialMessageByValuePair(int type, unsigned int value1, unsigned int value2)
{
    // NSString* str = [NSString stringWithFormat:@"%@%d%@%d%@", NSLocalizedString(@"tw_prefix", nil), value1, NSLocalizedString(@"tw_bridge", nil), value2, NSLocalizedString(@"tw_postfix", nil)];
    
    // [g_ViewController composeSocialMessage:type text:str url:kMainSite useSnapshot:YES];
    LOGD(logger, "ComposeSocialMessageByValuePair type:%d, value1:%d, value2:%d", type, value1, value2)
}

void ComposeTweet(const char* text, const char* url, bool useSnapshot)
{
    // [g_ViewController composeTweet:[NSString stringWithUTF8String:text] url:[NSString stringWithUTF8String:url] useSnapshot:useSnapshot];
    LOGD(logger, "ComposeTweet text:%s, url:%s, useSnapshot:%d", text, url, useSnapshot)
}

void ComposeTweetByValuePair(unsigned int value1, unsigned int value2)
{
    // NSString* str = [NSString stringWithFormat:@"%@%d%@%d%@", NSLocalizedString(@"tw_prefix", nil), value1, NSLocalizedString(@"tw_bridge", nil), value2, NSLocalizedString(@"tw_postfix", nil)];
    
    // [g_ViewController composeTweet:str url:kMainSite useSnapshot:YES];
    LOGD(logger, "ComposeTweetByValuePair value1:%d, value2:%d", value1, value2)
}

bool LoginFacebook()
{
// #ifdef GAO_USE_FACEBOOK
//     return [g_ViewController loginFacebook];
// #else
//     return FALSE;
// #endif
    LOGD(logger, "LoginFacebook")
    return false;
}

void PostFacebookFeed(const char* name, const char* caption, const char* description, const char* picture)
{
// #ifdef GAO_USE_FACEBOOK
//     [g_ViewController postFacebookFeed:[NSString stringWithUTF8String:name]
//                                caption:[NSString stringWithUTF8String:caption]
//                            description:[NSString stringWithUTF8String:description]
//                                picture:[NSString stringWithUTF8String:picture]];
// #endif
    LOGD(logger, "PostFacebookFeed name:%s, caption:%s, description:%s, picture:%s", name, caption, description, picture)
}

void PostFacebookFeedByValuePair(unsigned int value1, unsigned int value2, const char* picture)
{
// #ifdef GAO_USE_FACEBOOK
//     NSString* str = [NSString stringWithFormat:@"%@%d%@%d%@", NSLocalizedString(@"fb_prefix", nil), value1, NSLocalizedString(@"fb_bridge", nil), value2, NSLocalizedString(@"fb_postfix", nil)];
    
//     [g_ViewController postFacebookFeed:NSLocalizedString(@"fb_appname", nil)
//                                caption:NSLocalizedString(@"fb_caption", nil)
//                            description:str
//                                picture:[NSString stringWithUTF8String:picture]];
// #endif
    LOGD(logger, "PostFacebookFeedByValuePair value1:%d, value2:%d, picture:%s", value1, value2, picture)
}

void PlayMovie(const char* fileName, const char* pathName)
{
    // [g_ViewController showMovieViewController:[NSString stringWithUTF8String:fileName] directory:[NSString stringWithUTF8String:pathName]];
    LOGD(logger, "PlayMovie fileName:%s, pathName:%s", fileName, pathName)

    // temp solution
    // GaoString file = fileName;
    // GaoString ENTERING = "jade";
    // GaoString BOSS = "boss";
    // if (file.compare(0, ENTERING.size(), ENTERING) == 0) {
    //     g_ScriptManager->CallFunction("OnOPMoviePlaybackCompleted");
    // } else if (file.compare(0, BOSS.size(), BOSS) == 0) {
    //     g_ScriptManager->CallFunction("OnBossMoviePlaybackCompleted");
    // } else {
    //     LOGE(logger, "PlayMovie unexpected fileName:%s", fileName)
    // }

//    g_ScriptManager->CallFunction("OnMoviePlaybackCompleted");

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "PlayMovie: java == NULL")
        return;
    }

    java->PlayMovie(fileName);
}

void LogEvent(const char* eventName, bool timedEvent)
{
// #ifdef GAO_USE_FLURRY_ANALYTICS
//     [Flurry logEvent:[NSString stringWithUTF8String:eventName] timed:timedEvent];
// #endif
    LOGD(logger, "LogEvent eventName:%s, timedEvent:%d", eventName, timedEvent)
}

void LogEventEnded(const char* eventName)
{
// #ifdef GAO_USE_FLURRY_ANALYTICS
//     [Flurry endTimedEvent:[NSString stringWithUTF8String:eventName] withParameters:nil];
// #endif
    LOGD(logger, "LogEventEnded eventName:%s", eventName)
}

void LogEventWithParameter(const char* eventName, const char* value, const char* key, bool timedEvent)
{
// #ifdef GAO_USE_FLURRY_ANALYTICS
//     NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                           [NSString stringWithUTF8String:value],
//                           [NSString stringWithUTF8String:key], nil];
//     [Flurry logEvent:[NSString stringWithUTF8String:eventName] withParameters:dict timed:timedEvent];
// #endif
    LOGD(logger, "LogEventEnded eventName:%s, value:%s, key:%s, timedEvent:%d", eventName, value, key, timedEvent)
}

void LogEventWithLocale(const char* eventName, const char* key)
{
// #ifdef GAO_USE_FLURRY_ANALYTICS
//     NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                           [[NSLocale currentLocale] localeIdentifier],
//                           [NSString stringWithUTF8String:key], nil];
//     [Flurry logEvent:[NSString stringWithUTF8String:eventName] withParameters:dict timed:FALSE];
// #endif
    LOGD(logger, "LogEventWithLocale eventName:%s, key:%s", eventName, key)
}

void BuyProduct(const char* productId, bool showMessage)
{
// #ifdef GAO_USE_IAP
//     [[MKStoreManager sharedManager] buyFeature:[NSString stringWithUTF8String:productId]
//                                     onComplete:^(NSString* purchasedFeature, NSData* data)
//      {
//          NSLog(@"IAP Succeeded: %@", purchasedFeature);
//          [g_ViewController onReceivePurchaseResult:YES productId:purchasedFeature showMessage:showMessage];
//      }
//                                    onCancelled:^
//      {
//          NSLog(@"IAP Failed: transaction cancelled");
//          [g_ViewController onReceivePurchaseResult:NO productId:@"" showMessage:showMessage];
//      }];
// #endif
    LOGD(logger, "BuyProduct productId:%s, showMessage:%d", productId, showMessage)

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "BuyProduct: java == NULL")
        return;
    }

    java->BuyProduct(productId);
}

void RestorePurchases()
{
// #ifdef GAO_USE_IAP
//     [[MKStoreManager sharedManager] restorePurchases:^(NSString* purchasedFeature, NSData* data)
//      {
//          NSLog(@"IAP Restored: %@", purchasedFeature);
//          [g_ViewController onReceiveRestoreResult:YES productId:purchasedFeature];
//      }
//                                           onComplete:^()
//      {
//          ShowMessage("text_status", "iap_restore");
//      }
//                                              onError:^(NSError *error)
//      {
//          NSLog(@"IAP Restore attempt failed: %@", error);
//      }];
// #endif
    LOGD(logger, "RestorePurchases")

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "RestorePurchases: java == NULL")
        return;
    }

    java->ToastMessage("debug_iap_restore_not_ready");
}

bool IsFileExist(const char* fileName)
{
    // NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString* documentsDirectory = [paths objectAtIndex:0];
    // if (!documentsDirectory)
    // {
    //     NSLog(@"Documents directory not found!");
    //     return false;
    // }
    
    // NSString* fileNameStr = [NSString stringWithUTF8String:fileName];
    // NSString* fullPath = [documentsDirectory stringByAppendingPathComponent:fileNameStr];
    
    // return [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    LOGD(logger, "IsFileExist fileName:%s", fileName)

    AndroidFileSystem fs = AndroidFileSystem();
    GaoConstCharPtr path = fs.MakeDocumentPath(fileName);

    JavaInterface* java = JavaInterface::GetSingletonPointer();
    if (java == NULL) {
        LOGE(logger, "IsFileExist: java == NULL")
        return false;
    }

    bool result = java->IsFileExist(path);
    LOGD(logger, "IsFileExist result:%d", result)

    return result;
}

bool RemoveFile(const char* fileName)
{
    // NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString* documentsDirectory = [paths objectAtIndex:0];
    // if (!documentsDirectory)
    // {
    //     NSLog(@"Documents directory not found!");
    //     return false;
    // }
    
    // NSString* fileNameStr = [NSString stringWithUTF8String:fileName];
    // NSString* fullPath = [documentsDirectory stringByAppendingPathComponent:fileNameStr];
    // NSError* error;
    
    // return [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
    LOGD(logger, "RemoveFile fileName:%s", fileName)
    
    AndroidFileSystem fs = AndroidFileSystem();
    GaoConstCharPtr path = fs.MakeDocumentPath(fileName);

    JavaInterface* java = JavaInterface::GetSingletonPointer();
    if (java == NULL) {
        LOGE(logger, "RemoveFile: java == NULL")
        return false;
    }

    bool result = java->RemoveFile(path);
    LOGD(logger, "RemoveFile result:%d", result)

    return result;
}

int GetInterfaceOrientation()
{
    // UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // switch (orientation)
    // {
    //     case UIInterfaceOrientationLandscapeRight:
    //         return 1;
    //     case UIInterfaceOrientationLandscapeLeft:
    //         return 2;
    //     case UIInterfaceOrientationPortrait:
    //         return 3;
    //     case UIInterfaceOrientationPortraitUpsideDown:
    //         return 4;
    //     default:
    //         return 0;
    // }
    LOGD(logger, "GetInterfaceOrientation")
    return 2;
}

void ShowLeaderboardChoices()
{
	// UIAlertView* alert = [[UIAlertView alloc]
 //                          initWithTitle:NSLocalizedString(@"gc_title", nil)
 //                          message:NSLocalizedString(@"gc_desc", nil)
 //                          delegate:g_ViewController
 //                          cancelButtonTitle:NSLocalizedString(@"rate_no", nil)
 //                          otherButtonTitles:NSLocalizedString(@"rate_yes", nil), nil];
	// [alert show];
    LOGD(logger, "ShowLeaderboardChoices")

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "ShowLeaderboardChoices: java == NULL")
        return;
    }

    java->ShowMessage("gc_title", "gc_desc", "rate_yes", "rate_no");
}

void ShowLoveHateChoices()
{
	// UIAlertView* alert = [[UIAlertView alloc]
 //                          initWithTitle:NSLocalizedString(@"feedback_title", nil)
 //                          message:[NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"feedback_prefix", nil), NSLocalizedString(@"app_name", nil), NSLocalizedString(@"feedback_postfix", nil)]
 //                          delegate:g_ViewController
 //                          cancelButtonTitle:NSLocalizedString(@"feedback_hate", nil)
 //                          otherButtonTitles:NSLocalizedString(@"feedback_love", nil), nil];
	// [alert show];
    LOGD(logger, "ShowLoveHateChoices")

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "ShowLoveHateChoices: java == NULL")
        return;
    }

    GaoVector<GaoString> values;
    values.push_back("feedback_prefix");
    values.push_back("app_name");
    values.push_back("feedback_postfix");

    java->ShowDialogWithFormat("feedback_title", "feedback_love", "feedback_hate", "%s%s%s", values);
}

void ShowRatingChoices()
{
	// UIAlertView* alert = [[UIAlertView alloc]
 //                          initWithTitle:NSLocalizedString(@"rate_title", nil)
 //                          message:NSLocalizedString(@"rate_desc", nil)
 //                          delegate:g_ViewController
 //                          cancelButtonTitle:NSLocalizedString(@"rate_no", nil)
 //                          otherButtonTitles:NSLocalizedString(@"rate_yes", nil), nil];
	// [alert show];
    LOGD(logger, "ShowRatingChoices")

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "ShowRatingChoices: java == NULL")
        return;
    }

    java->ShowMessage("rate_title", "rate_desc", "rate_yes", "rate_no");
}

void ShowIAPChoices()
{
	// UIAlertView* alert = [[UIAlertView alloc]
 //                          initWithTitle:NSLocalizedString(@"iap_title", nil)
 //                          message:NSLocalizedString(@"iap_desc", nil)
 //                          delegate:g_ViewController
 //                          cancelButtonTitle:NSLocalizedString(@"button_cancel", nil)
 //                          otherButtonTitles:NSLocalizedString(@"button_ok", nil), nil];
	// [alert show];
    LOGD(logger, "ShowIAPChoices")

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "ShowIAPChoices: java == NULL")
        return;
    }

    java->ShowMessage("iap_title", "iap_desc", "button_ok", "button_cancel");
}

void ShowMessageChoices(const char* title, const char* desc, const char* action)
{
	// UIAlertView* alert = [[UIAlertView alloc]
 //                          initWithTitle:NSLocalizedString([NSString stringWithUTF8String:title], nil)
 //                          message:NSLocalizedString([NSString stringWithUTF8String:desc], nil)
 //                          delegate:g_ViewController
 //                          cancelButtonTitle:NSLocalizedString(@"button_cancel", nil)
 //                          otherButtonTitles:NSLocalizedString([NSString stringWithUTF8String:action], nil), nil];
	// [alert show];
    LOGD(logger, "ShowMessageChoices title:%s, desc:%s, action:%s", title, desc, action)

    JavaInterface* java = JavaInterface::GetSingletonPointer();

    if (java == NULL) {
        LOGE(logger, "ShowMessageChoices: java == NULL")
        return;
    }

    java->ShowMessage(title, desc, action, "button_cancel");
}

void SaveFileToiCloud(const char* fileName)
{
    // NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString* documentsDirectory = [paths objectAtIndex:0];
    // if (!documentsDirectory)
    // {
    //     NSLog(@"Documents directory not found!");
    //     return;
    // }
    
    // NSString* fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithUTF8String:fileName]];
    // NSData* data = [[NSFileManager defaultManager] contentsAtPath:fullPath];
    // [[NSUbiquitousKeyValueStore defaultStore] setData:data forKey:@"footprint"];
    
    // BOOL result = [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    // NSLog(@"SYNC result: %d / SIZE: %d", result, data.length);
    LOGD(logger, "SaveFileToiCloud fileName:%s", fileName)

    // JavaInterface* java = JavaInterface::GetSingletonPointer();
    // if (java != NULL) {
    //     java->ToastMessage("debug_cloud_save_not_ready");
    // }
}

void SyncFromiCloud()
{
// #ifdef GAO_USE_ICLOUD
//     [[NSUbiquitousKeyValueStore defaultStore] synchronize];
// #endif
    LOGD(logger, "SyncFromiCloud")

    // JavaInterface* java = JavaInterface::GetSingletonPointer();
    // if (java != NULL) {
    //     java->ToastMessage("debug_cloud_save_not_ready");
    // }
}

void PF_RegisterPlayer()
{
// #ifdef GAO_USE_PARSE
//     PFQuery *query = [PFQuery queryWithClassName:@"GCPlayer"];
//     [query whereKey:@"playerID" equalTo:[GKLocalPlayer localPlayer].playerID];
//     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//         if (!error)
//         {
//             if ([objects count] == 0)
//             {
//                 PFObject *obj = [PFObject objectWithClassName:@"GCPlayer"];
//                 [obj setObject:[GKLocalPlayer localPlayer].playerID forKey:@"playerID"];
//                 [obj setObject:[GKLocalPlayer localPlayer].alias forKey:@"alias"];
//                 [obj saveEventually];
//             }
//             else
//             {
//                 NSLog(@"PlayerID has existed: %@", [GKLocalPlayer localPlayer].playerID);
//             }
//         }
//         else
//         {
//             NSLog(@"Error: %@ %@", error, [error userInfo]);
//         }
//     }];
// #endif
    LOGD(logger, "PF_RegisterPlayer")
}

void PF_GetPlayerGift()
{
// #ifdef GAO_USE_PARSE
//     PFQuery *query = [PFQuery queryWithClassName:@"GCPlayer"];
//     [query whereKey:@"playerID" equalTo:[GKLocalPlayer localPlayer].playerID];
//     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//         if (!error)
//         {
//             NSLog(@"Successfully retrieved %d PFObject", objects.count);
//             for (PFObject *object in objects)
//             {
//                 int gold = [[object objectForKey:@"gold"] intValue];
//                 int coin = [[object objectForKey:@"coin"] intValue];
//                 BOOL gift = [[object objectForKey:@"gift"] boolValue];
//                 BOOL challengeLocked = [[object objectForKey:@"dailyChallengeLock"] boolValue];
//                 BOOL noReport = [[object objectForKey:@"dailyChallengeNoReport"] boolValue];
//                 NSString* message = [object objectForKey:@"message"];
                
//                 NSLog(@"%@ : [gold] %d [coin] %d [gift] %d [dcLock] %d [noReport] %d [message] %@", object.objectId, gold, coin, gift, challengeLocked, noReport, message);
                
//                 [g_ViewController onCheckGift:gold coin:coin gift:gift dcLocked:challengeLocked noReport:(BOOL)noReport message:message];
                
//                 // Updating object's values
//                 BOOL hasDirty = NO;
//                 if (gold != 0)
//                 {
//                     hasDirty = YES;
//                     [object setObject:[NSNumber numberWithInt:0] forKey:@"gold"];
//                 }
//                 if (coin != 0)
//                 {
//                     hasDirty = YES;
//                     [object setObject:[NSNumber numberWithInt:0] forKey:@"coin"];
//                 }
//                 if (gift)
//                 {
//                     hasDirty = YES;
//                     [object setObject:[NSNumber numberWithBool:NO] forKey:@"gift"];
//                 }
//                 if (message)
//                 {
//                     hasDirty = YES;
//                     [object removeObjectForKey:@"message"];
//                 }
                
//                 if (hasDirty)
//                 {
//                     [object saveEventually];
//                 }
                
//                 return;
//             }
//         }
//         else
//         {
//             NSLog(@"Error: %@ %@", error, [error userInfo]);
//         }
//     }];
// #endif
    LOGD(logger, "PF_GetPlayerGift")
}

void PF_SendPlayerScore(unsigned int score, unsigned int count, unsigned int coin, unsigned int gold, const char* map, const char* avatar, unsigned int koban1, unsigned int koban2, unsigned int koban3, unsigned int koban4)
{
// #ifdef GAO_USE_PARSE
//     PFQuery *query = [PFQuery queryWithClassName:@"GCPlayer"];
//     [query whereKey:@"playerID" equalTo:[GKLocalPlayer localPlayer].playerID];
//     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//         if (!error)
//         {
//             NSLog(@"Successfully retrieved %d PFObject", objects.count);
//             for (PFObject *object in objects)
//             {
//                 [object setObject:[NSNumber numberWithInt:score] forKey:@"DC_Score"];
//                 [object setObject:[NSNumber numberWithInt:count] forKey:@"DC_Count"];
//                 [object setObject:[NSNumber numberWithInt:coin] forKey:@"DC_Coin"];
//                 [object setObject:[NSNumber numberWithInt:gold] forKey:@"DC_Gold"];
//                 [object setObject:[NSString stringWithUTF8String:map] forKey:@"DC_Map"];
//                 [object setObject:[NSString stringWithUTF8String:avatar] forKey:@"DC_Avatar"];
//                 [object setObject:[NSNumber numberWithInt:koban1] forKey:@"Pocket_Koban1"];
//                 [object setObject:[NSNumber numberWithInt:koban2] forKey:@"Pocket_Koban2"];
//                 [object setObject:[NSNumber numberWithInt:koban3] forKey:@"Pocket_Koban3"];
//                 [object setObject:[NSNumber numberWithInt:koban4] forKey:@"Pocket_Koban4"];
                
//                 [object setObject:[[NSLocale currentLocale] localeIdentifier] forKey:@"Locale"];
//                 [object saveInBackground];
//                 return;
//             }
//         }
//         else
//         {
//             NSLog(@"Error: %@ %@", error, [error userInfo]);
//         }
//     }];
// #endif
    LOGD(logger, "PF_SendPlayerScore score:%d, count:%d, coin:%d, gold:%d, map%s, avatar:%s, koban1:%d, koban2:%d, koban3:%d, koban4:%d", score, count, coin, gold, map, avatar, koban1,koban2, koban3, koban4)
}

void ShowInterstitial(const char* location)
{
// #ifdef GAO_USE_CHARTBOOST
//     [[Chartboost sharedChartboost] showInterstitial];
// //    [[Chartboost sharedChartboost] showInterstitial:[NSString stringWithUTF8String:location]];
//     [[Chartboost sharedChartboost] cacheInterstitial];
// #endif
    LOGD(logger, "ShowInterstitial location:%s", location)
}

void SetTextTranslate(int x, int y)
{
    // [g_ViewController setTextTranslate:x y:y];
    LOGD(logger, "SetTextTranslate x:%d, y:%d", x, y)
}

void RenderText()
{
    // [g_ViewController renderText];
    LOGD(logger, "RenderText")
}
