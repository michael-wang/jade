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

static const char INIT_LOGGER_SCRIPT[]  = "Core/init_logger.lua";
static const char CORE_SCRIPT[]         = "Core/Core.lua";
static const char SCRIPT_ROUTINE_INIT[] = "InitializeLuaAndroid";
static const char SCRIPT_ROUTINE_SURFACE_CHANGED[] = "OnSurfaceChanged";
static const char SCRIPT_ROUTINE_UPDATE[] = "UpdateMain";
static const char SCRIPT_ROUTINE_RENDER[] = "RenderMain";
static const char SCRIPT_ROUTINE_TOUCH[]  = "OnTouch";
static const char SCRIPT_ROUTINE_START[] = "AndroidStart";
static const char SCRIPT_ROUTINE_STOP[]  = "AndroidStop";
static const char SCRIPT_ROUTINE_ONTERMINATE[]= "Terminate";
static const char SCRIPT_ROUTINE_PROCESS_BACK_KEY_PRESSED[] = "ProcessBackKey";
static const char SCRIPT_ROUTINE_NOTIFY_DIALOG_RESULT[] = "OnAlertUIResult";
static const char SCRIPT_ROUTINE_NOTIFY_PLAY_MOVIE_COMPLETE[] = "OnMoviePlaybackCompleted";

AndroidApplication* AndroidApplication::Singleton = NULL;


AndroidApplication::AndroidApplication(int width, int height, char* luaScript) :
	luaManager (new LuaScriptManager()),
	running (FALSE),
	log ("native::framework::AndroidApplication", FALSE),
	worldWidth (width),
	worldHeight (height),
	luaScriptPath (luaScript),
	initialized (FALSE) {

	LOGD(log, "Constructor w:%d, h:%d, luaScript:%s", width, height, luaScript)

	AndroidApplication::Singleton = dynamic_cast<AndroidApplication*>(g_Application);
}

AndroidApplication::~AndroidApplication() {

	LOGD(log, "Descructor")

	SAFE_DELETE(luaManager);
}

GaoVoid AndroidApplication::Start() {

	LOGD(log, "Start")

	if (running) {
		LOGW(log, "Start: already running.")
		return;
	}

	running = TRUE;

	if (!initialized) {
		LOGW(log, "Start skipt for not initialized.")
		return;
	}

	if (!luaManager->CallFunction(SCRIPT_ROUTINE_START)) {
		LOGE(log, "Failed to call:%s", SCRIPT_ROUTINE_START)
	}
}

GaoVoid AndroidApplication::Stop() {

	LOGD(log, "Stop")

	if (!running) {
		LOGW(log, "Stop: already not running.")
		return;
	}

	running = FALSE;

	if (!initialized) {
		LOGW(log, "Stop skipt for not initialized.")
		return;
	}

	if (!luaManager->CallFunction(SCRIPT_ROUTINE_STOP)) {
		LOGE(log, "Failed to call:%s", SCRIPT_ROUTINE_STOP)
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
	luaScript += INIT_LOGGER_SCRIPT;
	LOGD(log, "luaScript:%s", luaScript.c_str());
	luaManager->RunFromFullPathFile(luaScript);

	std::string core(luaScriptPath);
	core += CORE_SCRIPT;
	LOGD(log, "core:%s", core.c_str());
	if (!luaManager->RunFromFullPathFile(core)) {
		LOGE(log, "failed to run %s", core.c_str())
		return FALSE;
	}

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_INIT)) {
		LOGE(log, "Cannot find lua function: %s", SCRIPT_ROUTINE_INIT)
		return false;
	}
	luaManager->PushValue(worldWidth);
	luaManager->PushValue(worldHeight);
	luaManager->PushValue(luaScriptPath);
	LOGD(log, "before call function: %s", SCRIPT_ROUTINE_INIT);
	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run lua function: %s", SCRIPT_ROUTINE_INIT);
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
