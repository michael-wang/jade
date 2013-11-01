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

using namespace Gao::Framework;

AndroidApplication* AndroidApplication::Singleton = NULL;

static char TAG[] = "native::framework::AndroidApplication";

AndroidApplication::AndroidApplication() :
	luaManager (new LuaScriptManager()),
	assetManager (NULL),
	jniEnv (NULL),
	jInterface (NULL),
	coreLuaName (NULL),
	updateLuaName (NULL),
	renderLuaName (NULL) {

	AndroidApplication::Singleton = dynamic_cast<AndroidApplication*>(g_Application);
}

AndroidApplication::~AndroidApplication() {
	SAFE_DELETE(luaManager);
	jniEnv = NULL;
	jInterface = NULL;
	SAFE_DELETE(coreLuaName);
	SAFE_DELETE(updateLuaName);
	SAFE_DELETE(renderLuaName);
}

GaoBool AndroidApplication::Initialize(AAssetManager* am, 
	char* core, char* update, char* render) {
	__android_log_print(ANDROID_LOG_INFO, TAG, 
		"Initialize core:%s, update:%s, render:%s", core, update, render);

	assetManager = am;

	if (core == NULL || update == NULL || render == NULL) {
		__android_log_print(ANDROID_LOG_INFO, TAG, 
			"Invalid arguments core:%p, update:%p, render:%p", 
			core, update, render);
		return FALSE;
	}

	coreLuaName = core;
	updateLuaName = update;
	renderLuaName = render;

	return OnInitialize();
}

GaoVoid AndroidApplication::RunOnePass() {
	if (IsAppRunning()) {
		OnUpdate();
		OnRender();
	}
}

GaoBool AndroidApplication::OnInitialize() {
	__android_log_print(ANDROID_LOG_INFO, TAG, "OnInitialize()");

	luaManager->Create();
	__android_log_print(ANDROID_LOG_INFO, TAG, "luaManager Create done!");

	if (!Gao::Framework::RegisterLuaFunctions(luaManager->GetLuaState())) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to RegisterLuaFunctions");
		return FALSE;
	}
	__android_log_print(ANDROID_LOG_INFO, TAG, "RegisterLuaFunctions done!");

	AndroidLuaScripts::RegisterAndroidClasses(luaManager->GetLuaState());
	__android_log_print(ANDROID_LOG_INFO, TAG, "RegisterAndroidClasses done!");

	Resource* res = new Resource(assetManager);

	char* lua = res->readAsTextFile(coreLuaName);
	__android_log_print(ANDROID_LOG_INFO, TAG, "core lua:%s", lua);
	if (!luaManager->RunFromString(lua)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run %s", coreLuaName);
		return FALSE;
	}
	__android_log_print(ANDROID_LOG_INFO, TAG, "lua luaCore done!");

	CallLua(SCRIPT_ROUTINE_INIT);

	lua = res->readAsTextFile(updateLuaName);
	__android_log_print(ANDROID_LOG_INFO, TAG, "update lua:%s", lua);

	if (!luaManager->RunFromString(lua)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run %s", updateLuaName);
		return FALSE;
	}
	__android_log_print(ANDROID_LOG_INFO, TAG, "lua luaUpdate done!");

	lua = res->readAsTextFile(renderLuaName);
	__android_log_print(ANDROID_LOG_INFO, TAG, "update lua:%s", lua);

	if (!luaManager->RunFromString(lua)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run %s", renderLuaName);
		return FALSE;
	}

	return TRUE;
}

GaoVoid AndroidApplication::OnTerminate() {
}

GaoVoid AndroidApplication::OnSurfaceChanged(int width, int height) {
	__android_log_print(ANDROID_LOG_INFO, TAG, "OnSurfaceChanged w:%d, h:%d", width, height);

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

GaoBool AndroidApplication::CallLua(GaoConstCharPtr func) {
//	__android_log_print(ANDROID_LOG_INFO, TAG, "CallLua: %s", func);

	if (!luaManager->CallFunction(func)) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "failed to run lua function: %s", func);
	}

	return TRUE;
}

