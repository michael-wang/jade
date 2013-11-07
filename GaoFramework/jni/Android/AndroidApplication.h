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


class AndroidApplication : public Gao::Framework::Application {
public:
	static AndroidApplication* Singleton;
	
public:
	AndroidApplication();
	virtual ~AndroidApplication();

	GaoBool Initialize(AAssetManager* am, char* coreLuaName, 
		char* updateLuaName, char* renderLuaName);

	GaoVoid Pause();
	GaoVoid Resume();

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

protected:
	virtual GaoBool OnInitialize();
	virtual GaoVoid OnTerminate();
	virtual GaoVoid OnUpdate();
	virtual GaoVoid OnRender();
	virtual GaoVoid OnPause(GaoBool onPause);
	virtual GaoBool IsAppRunning();

protected:
	Gao::Framework::LuaScriptManager* luaManager;
	AAssetManager* assetManager;

	JNIEnv* jniEnv;
	jobject jInterface;

	GaoBool CallLua(GaoConstCharPtr func);

	char* coreLuaName;
	char* updateLuaName;
	char* renderLuaName;

	GaoBool running;
};

#endif /* ANDROIDAPPLICATION_H_ */
