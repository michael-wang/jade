/*
 * AndroidApplication.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidApplication.h>
#include <android/log.h>
#include <Framework/LuaFunction.hpp>
 #include "AndroidLuaScripts.h"

using namespace Gao::Framework;

AndroidApplication::AndroidApplication() :
	luaManager (new LuaScriptManager()),
	jniEnv (NULL),
	glRenderer (NULL),
	luaCore (NULL),
	luaUpdate (NULL),
	luaRender (NULL) {
}

AndroidApplication::~AndroidApplication() {
	SAFE_DELETE(luaManager);
	jniEnv = NULL;
	glRenderer = NULL;
	SAFE_DELETE(luaCore);
	SAFE_DELETE(luaUpdate);
	SAFE_DELETE(luaRender);
}

GaoBool AndroidApplication::Initialize(char* core, char* updateDelegate, char* renderDelegate) {
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "Initialize");

	if (core == NULL || updateDelegate == NULL || renderDelegate == NULL) {
		__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", 
			"Invalid arguments core:%p, updateDelegate:%p, renderDelegate:%p", 
			core, updateDelegate, renderDelegate);
		return FALSE;
	}

	luaCore = core;
	luaUpdate = updateDelegate;
	luaRender = renderDelegate;

	return OnInitialize();
}

GaoVoid AndroidApplication::RunOnePass() {
	if (IsAppRunning()) {
		OnUpdate();
		OnRender();
	}
}

GaoBool AndroidApplication::OnInitialize() {
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "OnInitialize()");

	luaManager->Create();
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "luaManager Create done!");

	if (!Gao::Framework::RegisterLuaFunctions(luaManager->GetLuaState())) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidApplication", "failed to RegisterLuaFunctions");
		return FALSE;
	}
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "RegisterLuaFunctions done!");

	AndroidLuaScripts::RegisterAndroidClasses(luaManager->GetLuaState());
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "RegisterAndroidClasses done!");

	if (!luaManager->RunFromString(luaCore)) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidApplication", "failed to run luaCore");
		return FALSE;
	}
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "lua luaCore done!");

	CallLua(SCRIPT_ROUTINE_INIT);

	if (!luaManager->RunFromString(luaUpdate)) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidApplication", "failed to run luaUpdate");
		return FALSE;
	}
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "lua luaUpdate done!");

	if (!luaManager->RunFromString(luaRender)) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidApplication", "failed to run luaRender");
		return FALSE;
	}
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "lua luaRender done!");

	return TRUE;
}

GaoVoid AndroidApplication::OnTerminate() {
}

GaoVoid AndroidApplication::OnSurfaceChanged(int width, int height) {
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "OnSurfaceChanged w:%d, h:%d", width, height);

	if (!luaManager->GetFunction(SCRIPT_ROUTINE_SURFACE_CHANGED)) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidApplication", "failed to get lua function: %s", SCRIPT_ROUTINE_SURFACE_CHANGED);
	}

	luaManager->PushValue(width);
	luaManager->PushValue(height);

	if (!luaManager->CallFunction()) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidApplication", "failed to run lua function: %s", SCRIPT_ROUTINE_SURFACE_CHANGED);
	}
}

GaoVoid AndroidApplication::OnUpdate() {
	// if (delegateUpdateCode != NULL) {
	// 	luaManager->RunFromString(delegateUpdateCode);
	// } else {
		CallLua(SCRIPT_ROUTINE_UPDATE);
	// }
}

GaoVoid AndroidApplication::OnRender() {
	// __android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "OnRender code: %s", delegateRenderCode);

	// if (delegateRenderCode != NULL) {
	// 	luaManager->RunFromString(delegateRenderCode);
	// } else {
		CallLua(SCRIPT_ROUTINE_RENDER);
	// }
}

GaoBool AndroidApplication::CallLua(GaoConstCharPtr func) {
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "CallLua: %s", func);

	if (!luaManager->CallFunction(func)) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidApplication", "failed to run lua function: %s", func);
	}

	return TRUE;
}

