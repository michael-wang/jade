/*
 * AndroidApplication.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Framework/LuaFunction.hpp>
#include "AndroidApplication.h"
#include "AndroidLuaScripts.h"
#include "Resource.h"
#include "JavaInterface.h"
#include "AndroidLogger.h"

using namespace Gao::Framework;

static const char INIT_LOGGER_SCRIPT[]  = "/LuaScript/Core/init_logger.lua";
static const char CORE_SCRIPT[]         = "/LuaScript/Core/Core.lua";
static const char SCRIPT_ROUTINE_INIT[] = "InitializeLuaAndroid";
static const char SCRIPT_ROUTINE_SURFACE_CHANGED[] = "OnSurfaceChanged";
static const char SCRIPT_ROUTINE_UPDATE[] = "UpdateMain";
static const char SCRIPT_ROUTINE_RENDER[] = "RenderMain";
static const char SCRIPT_ROUTINE_TOUCH[]  = "OnTouch";
static const char SCRIPT_ROUTINE_PAUSE[]  = "Pause";
static const char SCRIPT_ROUTINE_ONTERMINATE[]= "Terminate";

AndroidApplication* AndroidApplication::Singleton = NULL;


AndroidApplication::AndroidApplication() :
	luaManager (new LuaScriptManager()),
	running (TRUE),
	log ("native::framework::AndroidApplication", false),
	worldWidth (0),
	worldHeight (0) {

	LOGD(log, "Constructor")

	AndroidApplication::Singleton = dynamic_cast<AndroidApplication*>(g_Application);
}

AndroidApplication::~AndroidApplication() {

	LOGD(log, "Descructor")

	SAFE_DELETE(luaManager);
}

GaoBool AndroidApplication::Initialize(char* asset, int width, int height) {

	if (asset == NULL) {
		LOGE(log, "Initialize: invalid argument asset: NULL")
		return FALSE;
	}

	LOGD(log, "Initialize asset:%s, worldWidth:%d, worldHeight:%d", asset, width, height)

	assetPath = asset;
	worldWidth = width;
	worldHeight = height;

	return OnInitialize();
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

	std::string luaScript(assetPath);
	luaScript += INIT_LOGGER_SCRIPT;
	LOGD(log, "luaScript:%s", luaScript.c_str());
	luaManager->RunFromFullPathFile(luaScript);

	std::string core(assetPath);
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
	luaManager->PushValue(assetPath);
	LOGD(log, "before call function: %s", SCRIPT_ROUTINE_INIT);
	if (!luaManager->CallFunction()) {
		LOGE(log, "Failed to run lua function: %s", SCRIPT_ROUTINE_INIT);
	}

	return TRUE;
}

GaoVoid AndroidApplication::OnTerminate() {

	LOGD(log, "OnTerminate")

	CallLua(SCRIPT_ROUTINE_ONTERMINATE);
}

GaoVoid AndroidApplication::OnUpdate() {
	CallLua(SCRIPT_ROUTINE_UPDATE);
}

GaoVoid AndroidApplication::OnRender() {
	CallLua(SCRIPT_ROUTINE_RENDER);
}

GaoVoid AndroidApplication::OnPause(GaoBool onPause) {
	LOGD(log, "OnPause %d", onPause)

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

