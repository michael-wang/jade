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
static const char SCRIPT_ROUTINE_PAUSE[]  = "Pause";
static const char SCRIPT_ROUTINE_ONTERMINATE[]= "Terminate";
static const char SCRIPT_ROUTINE_NOTIFY_BACK_PRESSED[] = "NotifyBackPressed";

AndroidApplication* AndroidApplication::Singleton = NULL;


AndroidApplication::AndroidApplication(int width, int height, char* luaScript) :
	luaManager (new LuaScriptManager()),
	running (TRUE),
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

GaoVoid AndroidApplication::Pause() {

	running = FALSE;
	OnPause(TRUE);
}

GaoVoid AndroidApplication::Resume() {

	running = TRUE;
	OnPause(FALSE);
}

GaoVoid AndroidApplication::RunOnePass() {
	if (IsAppRunning()) {
		OnUpdate();
		OnRender();
	}
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

GaoVoid AndroidApplication::OnPause(GaoBool onPause) {
	LOGD(log, "OnPause %d", onPause)

	if (!initialized) {
		LOGE(log, "OnPause(%d) skipt for not initialized.", onPause)
		return;
	}

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_PAUSE)) {
		LOGE(log, "Cannot find lua function:%s", SCRIPT_ROUTINE_PAUSE)
		return;
	}

	luaManager->PushValue(onPause);
	luaManager->CallFunction();
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

GaoVoid AndroidApplication::NotifyBackPressed() {

	LOGD(log, "NotifyBackPressed")

	luaManager->CallFunction(SCRIPT_ROUTINE_NOTIFY_BACK_PRESSED);
}