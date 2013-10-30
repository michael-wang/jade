/*
 * AndroidApplication.h
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#ifndef ANDROIDAPPLICATION_H_
#define ANDROIDAPPLICATION_H_

#include <Framework/Application.hpp>
#include <Framework/LuaScriptManager.hpp>
#include <android/asset_manager.h>
#include <jni.h>
#include "Resource.h"

static const char SCRIPT_ROUTINE_INIT[] = "OnInitialize";
static const char SCRIPT_ROUTINE_SURFACE_CHANGED[] = "OnSurfaceChanged";
static const char SCRIPT_ROUTINE_UPDATE[] = "OnUpdate";
static const char SCRIPT_ROUTINE_RENDER[] = "OnRender";


class AndroidApplication : public Gao::Framework::Application {
public:
	static AndroidApplication* Singleton;
	
public:
	AndroidApplication();
	virtual ~AndroidApplication();

	GaoBool Initialize(AAssetManager* am, char* coreLuaName, 
		char* updateLuaName, char* renderLuaName);

	GaoVoid RunOnePass();

	GaoVoid OnSurfaceChanged(int width, int height);
	GaoVoid SetJavaInterface(JNIEnv* jni, jobject ji) {
		jniEnv = jni;
		jInterface = ji;
	}

	JNIEnv* GetJniEnv() {
		return jniEnv;
	}

	jobject GetJavaInterface() {
		return jInterface;
	}

	// touch events
	GaoVoid OnTouchEvent(GaoReal32 x, GaoReal32 y, GaoInt32 action);

protected:
	GaoBool OnInitialize();
	GaoVoid OnTerminate();
	GaoVoid OnUpdate();
	GaoVoid OnRender();

protected:
	Gao::Framework::LuaScriptManager* luaManager;
	AAssetManager* assetManager;

	JNIEnv* jniEnv;
	jobject jInterface;

private:
	GaoBool CallLua(GaoConstCharPtr func);

	char* coreLuaName;
	char* updateLuaName;
	char* renderLuaName;
};

#endif /* ANDROIDAPPLICATION_H_ */
