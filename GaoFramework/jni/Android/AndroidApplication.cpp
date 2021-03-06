/*
 * AndroidApplication.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Framework/LuaFunction.hpp>
#include "AndroidApplication.h"
#include "AndroidLogger.h"
#include "AndroidLuaScripts.h"
#include "JavaInterface.h"
#include "LuaBinding.h"
#include "Resource.h"

using namespace Gao::Framework;

static const char BOOTSTRAP_SCRIPT[]  = "bootstrap.go";
static const char BOOTSTRAP_INIT[]    = "init";
static const char CORE_SCRIPT[]       = "monkey.potion";
static const char SCRIPT_ROUTINE_INIT[] = "InitializeLuaAndroid";
static const char SCRIPT_ROUTINE_SURFACE_CHANGED[] = "OnSurfaceChanged";
static const char SCRIPT_ROUTINE_UPDATE[] = "UpdateMain";
static const char SCRIPT_ROUTINE_RENDER[] = "RenderMain";
static const char SCRIPT_ROUTINE_TOUCH[]  = "OnTouch";
static const char SCRIPT_ROUTINE_ANDROID_START[] = "AndroidStart";
static const char SCRIPT_ROUTINE_ANDROID_STOP[]  = "AndroidStop";
static const char SCRIPT_ROUTINE_ANDROID_PAUSE[] = "AndroidPause";
static const char SCRIPT_ROUTINE_ANDROID_RESUME[] = "AndroidResume";
static const char SCRIPT_ROUTINE_ONTERMINATE[]= "Terminate";
static const char SCRIPT_ROUTINE_PROCESS_BACK_KEY_PRESSED[] = "ProcessBackKey";
static const char SCRIPT_ROUTINE_NOTIFY_DIALOG_RESULT[] = "OnAlertUIResult";
static const char SCRIPT_ROUTINE_NOTIFY_PLAY_MOVIE_COMPLETE[] = "OnMoviePlaybackCompleted";
static const char SCRIPT_ROUTINE_NOTIFY_BUY_RESULT[] = "OnPurchaseConfirmed";
static const char SCRIPT_ROUTINE_NOTIFY_PURCHASE_RESTORED[] = "OnPurchaseRestored";
static const char SCRIPT_ROUTINE_NOTIFY_UI_PRESENTED[] = "OnUIPresentCompleted";
static const char SCRIPT_ROUTINE_NOTIFY_SEND_MAIL_RESULT[] = "OnMailResultReceived";
static const char SCRIPT_ROUTINE_NOTIFY_GAME_SERVICE_CONNECTION_STATUS[] = "OnGameCenterAuthorized";

AndroidApplication* AndroidApplication::Singleton = NULL;


AndroidApplication::AndroidApplication(int width, int height, char* luaScript, AAssetManager* am, GaoBool debug) :
	luaManager (new AndroidLuaManager(am)),
	running (FALSE),
	log ("native::framework::AndroidApplication", FALSE),
	worldWidth (width),
	worldHeight (height),
	luaScriptPath (luaScript),
	initialized (FALSE),
	debugMode (debug) {

	LOGD(log, "Constructor w:%d, h:%d, luaScript:%s", width, height, luaScript)

	AndroidApplication::Singleton = dynamic_cast<AndroidApplication*>(g_Application);
}

AndroidApplication::~AndroidApplication() {

	LOGD(log, "Descructor")

	SAFE_DELETE(luaManager);
}

GaoVoid AndroidApplication::Start() {

	LOGD(log, "Start")

	if (!initialized) {
		LOGD(log, "Start skipt for not initialized.")
		return;
	}

	if (!luaManager->CallFunction(SCRIPT_ROUTINE_ANDROID_START)) {
		LOGE(log, "Failed to call:%s", SCRIPT_ROUTINE_ANDROID_START)
	}
}

GaoVoid AndroidApplication::Stop() {

	LOGD(log, "Stop")

	if (!initialized) {
		LOGW(log, "Stop skipt for not initialized.")
		return;
	}

	if (!luaManager->CallFunction(SCRIPT_ROUTINE_ANDROID_STOP)) {
		LOGE(log, "Failed to call:%s", SCRIPT_ROUTINE_ANDROID_STOP)
	}
}

GaoVoid AndroidApplication::Pause() {

	LOGD(log, "Pause")

	running = FALSE;

	if (initialized) {

		if (!luaManager->CallFunction(SCRIPT_ROUTINE_ANDROID_PAUSE)) {
			LOGE(log, "Failed to call:%s", SCRIPT_ROUTINE_ANDROID_PAUSE)
		}
	}
}

GaoVoid AndroidApplication::Resume() {

	LOGD(log, "Resume")

	running = TRUE;

	if (initialized) {

		if (!luaManager->CallFunction(SCRIPT_ROUTINE_ANDROID_RESUME)) {
			LOGE(log, "Failed to call:%s", SCRIPT_ROUTINE_ANDROID_RESUME)
		}
	}
}

GaoVoid AndroidApplication::RunOnePass() {

	OnUpdate();
	OnRender();
}

GaoBool AndroidApplication::OnInitialize() {
	
	LOGD(log, "OnInitialize()")

	luaManager->Create();

	if (!Gao::Framework::RegisterLuaFunctions(luaManager->GetLuaState())) {
		LOGE(log, "failed to RegisterLuaFunctions")
		return FALSE;
	}

	AndroidLuaScripts::RegisterAndroidClasses(luaManager->GetLuaState());
	RegisterGameFunctions(luaManager->GetLuaState());

	std::string luaScript(luaScriptPath);
	luaScript += BOOTSTRAP_SCRIPT;
	LOGD(log, "luaScript:%s", luaScript.c_str());
	if (debugMode) {
		if (!luaManager->RunFromFullPathFile(luaScript)) {
			LOGE(log, "Failed to run %s", luaScript.c_str());
		}
	} else {
		if (!luaManager->RunFromAsset(luaScript)) {
			LOGE(log, "Failed to run %s", luaScript.c_str());
		}
	}

	if (!luaManager->CallFunction(BOOTSTRAP_INIT)) {
		LOGE(log, "Failed to run lua function: %s", BOOTSTRAP_INIT)
		return FALSE;
	}

	std::string core(luaScriptPath);
	core += CORE_SCRIPT;
	LOGD(log, "core:%s", core.c_str());
	if (debugMode) {
		if (!luaManager->RunFromFullPathFile(core)) {
			LOGE(log, "failed to run %s", core.c_str())
			return FALSE;
		}
	} else {
		if (!luaManager->RunFromAsset(core)) {
			LOGE(log, "failed to run %s", core.c_str())
			return FALSE;
		}
	}

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_INIT)) {
		LOGE(log, "Cannot find lua function: %s", SCRIPT_ROUTINE_INIT)
		return FALSE;
	}
	luaManager->PushValue(worldWidth);
	luaManager->PushValue(worldHeight);
	luaManager->PushValue(luaScriptPath);
	luaManager->PushValue(debugMode);
	LOGD(log, "before call function: %s", SCRIPT_ROUTINE_INIT);
	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run lua function: %s", SCRIPT_ROUTINE_INIT)
		return FALSE;
	}

	initialized = TRUE;

	return TRUE;
}

GaoVoid AndroidApplication::OnTerminate() {

	LOGD(log, "OnTerminate")

	if (!initialized) {
		LOGE(log, "OnTerminated skipt for not initialized.")
		return;
	}

	CallLua(SCRIPT_ROUTINE_ONTERMINATE);
}

GaoVoid AndroidApplication::OnUpdate() {

	// LOGD(log, "OnUpdate")

	CallLua(SCRIPT_ROUTINE_UPDATE);
}

GaoVoid AndroidApplication::OnRender() {

	// LOGD(log, "OnRender")

	CallLua(SCRIPT_ROUTINE_RENDER);
}

GaoBool AndroidApplication::IsAppRunning() {
	return running;
}

GaoBool AndroidApplication::CallLua(GaoConstCharPtr func) {
	// LOGD(log, "CallLua: %s", func);

	if (!luaManager->CallFunction(func)) {
		LOGE(log, "failed to run lua function: %s", func)
	}

	return TRUE;
}

GaoBool AndroidApplication::ProcessBackKeyPressed() {

	LOGD(log, "ProcessBackKeyPressed")

	GaoBool result = FALSE;

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_PROCESS_BACK_KEY_PRESSED)) {
		LOGE(log, "ProcessBackKeyPressed: cannot find lua function: %s", 
			SCRIPT_ROUTINE_PROCESS_BACK_KEY_PRESSED)
		return result;
	}

	luaManager->CallFunction();
	luaManager->GetValueAt(1, result);

	return result;
}

GaoVoid AndroidApplication::NotifyAlertDialogResult(GaoBool value) {

	LOGD(log, "NotifyAlertDialogResult value:%d", value)

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_NOTIFY_DIALOG_RESULT)) {
		LOGE(log, "Cannot find lua function:%s", SCRIPT_ROUTINE_NOTIFY_DIALOG_RESULT)
		return;
	}

	int valueForLua = value ? 1 : 0;

	luaManager->PushValue(valueForLua);
	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run Lua function:%s", SCRIPT_ROUTINE_NOTIFY_DIALOG_RESULT)
	}
}

GaoVoid AndroidApplication::NotifyPlayMovieComplete() {

	LOGD(log, "NotifyPlayMovieComplete")

	luaManager->CallFunction(SCRIPT_ROUTINE_NOTIFY_PLAY_MOVIE_COMPLETE);
}

GaoVoid AndroidApplication::NotifyBuyResult(GaoConstCharPtr id, GaoBool success) {
	
	LOGD(log, "NotifyBuyResult id:%s, success:%d", id, success)

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_NOTIFY_BUY_RESULT)) {
		LOGE(log, "Cannot find lua function:%s", SCRIPT_ROUTINE_NOTIFY_BUY_RESULT)
		return;
	}

	luaManager->PushValue(success);
	luaManager->PushValue(id);

	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run Lua function:%s", SCRIPT_ROUTINE_NOTIFY_BUY_RESULT)
	}
}

GaoVoid AndroidApplication::NotifyPurchaseRestored(GaoConstCharPtr id) {

	LOGD(log, "NotifyPurchaseRestored id:%s", id)

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_NOTIFY_PURCHASE_RESTORED)) {
		LOGE(log, "Cannot find lua function:%s", SCRIPT_ROUTINE_NOTIFY_PURCHASE_RESTORED)
		return;
	}

	luaManager->PushValue(true);
	luaManager->PushValue(id);

	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run Lua function:%s", SCRIPT_ROUTINE_NOTIFY_PURCHASE_RESTORED)
	}
}

GaoVoid AndroidApplication::NotifyUIPresented() {

	LOGD(log, "NotifyUIPresented")

	if (!luaManager->CallFunction(SCRIPT_ROUTINE_NOTIFY_UI_PRESENTED)) {
		LOGE(log, "Failed to call Lua function:%s", SCRIPT_ROUTINE_NOTIFY_UI_PRESENTED)
	}
}

GaoVoid AndroidApplication::NotifySendMailResult(GaoBool value) {
	
	LOGD(log, "NotifySendMailResult value:%d", value)

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_NOTIFY_SEND_MAIL_RESULT)) {
		LOGE(log, "Cannot find lua function:%s", SCRIPT_ROUTINE_NOTIFY_SEND_MAIL_RESULT)
		return;
	}

	luaManager->PushValue(value);

	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run Lua function:%s", SCRIPT_ROUTINE_NOTIFY_SEND_MAIL_RESULT)
	}
}

GaoVoid AndroidApplication::NotifyStateLoadedFromCloud() {

	LOGD(log, "NotifyStateLoadedFromCloud")

	if (!luaManager->CallFunction("ReadSaveDataFromFile")) {
		LOGE(log, "Failed to run lua function: ReadSaveDataFromFile")
	}
}

GaoVoid AndroidApplication::NotifyGameServiceConnectionStatus(GaoBool connected) {

	LOGD(log, "NotifyGameServiceConnected connected:%d", connected)

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_NOTIFY_GAME_SERVICE_CONNECTION_STATUS)) {
		LOGE(log, "Cannot find lua function:%s", SCRIPT_ROUTINE_NOTIFY_GAME_SERVICE_CONNECTION_STATUS)
		return;
	}

	luaManager->PushValue(connected);

	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run lua function: %s", SCRIPT_ROUTINE_NOTIFY_GAME_SERVICE_CONNECTION_STATUS)
	}
}
