/*
 * AndroidApplication.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <android/log.h>
#include <Framework/LuaFunction.hpp>
#include "AndroidApplication.h"
#include "AndroidLuaScripts.h"
#include "Resource.h"
#include "JavaInterface.h"
#include "AndroidLogger.h"

using namespace Gao::Framework;

static const char SCRIPT_ROUTINE_INIT[] = "OnInitialize";
static const char SCRIPT_ROUTINE_SURFACE_CHANGED[] = "OnSurfaceChanged";
static const char SCRIPT_ROUTINE_UPDATE[] = "OnUpdate";
static const char SCRIPT_ROUTINE_RENDER[] = "OnRender";
static const char SCRIPT_ROUTINE_TOUCH[]  = "OnTouch";
static const char SCRIPT_ROUTINE_ONPAUSE[] = "OnPause";
static const char SCRIPT_ROUTINE_ONRESUME[]= "OnResume";
static const char SCRIPT_ROUTINE_ONTERMINATE[]= "OnTerminate";

AndroidApplication* AndroidApplication::Singleton = NULL;

static char TAG[] = "native::framework::AndroidApplication";

AndroidApplication::AndroidApplication() :
	luaManager (new LuaScriptManager()),
	running (TRUE) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Constructor");
	AndroidApplication::Singleton = dynamic_cast<AndroidApplication*>(g_Application);
}

AndroidApplication::~AndroidApplication() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Descructor");

	SAFE_DELETE(luaManager);
}

GaoBool AndroidApplication::Initialize(char* core, char* update, char* render) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"Initialize core:%s, update:%s, render:%s", core, update, render);

	if (core == NULL || update == NULL || render == NULL) {
		__android_log_print(ANDROID_LOG_DEBUG, TAG, 
			"Invalid arguments core:%p, update:%p, render:%p", 
			core, update, render);
		return FALSE;
	}

	coreLuaName = core;
	updateLuaName = update;
	renderLuaName = render;

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
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "OnInitialize()");

	luaManager->Create();

	if (!Gao::Framework::RegisterLuaFunctions(luaManager->GetLuaState())) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to RegisterLuaFunctions");
		return FALSE;
	}

	AndroidLuaScripts::RegisterAndroidClasses(luaManager->GetLuaState());

	if (!luaManager->RunFromFullPathFile(coreLuaName)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run %s", coreLuaName.c_str());
		return FALSE;
	}

	// LuaState L = luaManager->GetLuaState();
	// if (luaL_loadfile(L, coreLuaName.c_str()) != 0) {
	// 	__android_log_print(ANDROID_LOG_ERROR, TAG, "FAILED to luaL_loadfile, msg:%s", luaL_checkstring(L, lua_gettop(L)));
	// } else {
	// 	__android_log_print(ANDROID_LOG_DEBUG, TAG, "SUCCESS to luaL_loadfile(%s)", coreLuaName.c_str());
	// }

	// if (lua_pcall(L, 0, LUA_MULTRET, 0) != 0) {
	// 	__android_log_print(ANDROID_LOG_ERROR, TAG, "FAILED to lua_pcall, msg:%s", luaL_checkstring(L, lua_gettop(L)));
	// } else {
	// 	__android_log_print(ANDROID_LOG_DEBUG, TAG, "SUCCESS to lua_pcall");
	// }

	CallLua(SCRIPT_ROUTINE_INIT);

	if (!luaManager->RunFromFullPathFile(updateLuaName)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run %s", updateLuaName.c_str());
		return FALSE;
	}

	if (!luaManager->RunFromFullPathFile(renderLuaName)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run %s", renderLuaName.c_str());
		return FALSE;
	}

	return TRUE;
}

GaoVoid AndroidApplication::OnTerminate() {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "OnTerminate");

	CallLua(SCRIPT_ROUTINE_ONTERMINATE);
}

GaoVoid AndroidApplication::OnSurfaceChanged(int width, int height) {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "OnSurfaceChanged w:%d, h:%d", width, height);

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_SURFACE_CHANGED)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to get lua function: %s", SCRIPT_ROUTINE_SURFACE_CHANGED);
	}

	luaManager->PushValue(width);
	luaManager->PushValue(height);

	if (!luaManager->CallFunction()) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run lua function: %s", SCRIPT_ROUTINE_SURFACE_CHANGED);
	}
}

GaoVoid AndroidApplication::OnUpdate() {
	CallLua(SCRIPT_ROUTINE_UPDATE);
}

GaoVoid AndroidApplication::OnRender() {
	CallLua(SCRIPT_ROUTINE_RENDER);
}

GaoVoid AndroidApplication::OnPause(GaoBool onPause) {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "OnPause %d", onPause);

	if (onPause) {
		CallLua(SCRIPT_ROUTINE_ONPAUSE);
	} else {
		CallLua(SCRIPT_ROUTINE_ONRESUME);
	}
}

GaoBool AndroidApplication::IsAppRunning() {
	return running;
}

GaoBool AndroidApplication::CallLua(GaoConstCharPtr func) {
//	__android_log_print(ANDROID_LOG_DEBUG, TAG, "CallLua: %s", func);

	if (!luaManager->CallFunction(func)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run lua function: %s", func);
	}

	return TRUE;
}

