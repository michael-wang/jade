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
#include <jni.h>

static const char SCRIPT_ROUTINE_INIT[] = "OnInitialize";
static const char SCRIPT_ROUTINE_SURFACE_CHANGED[] = "OnSurfaceChanged";
static const char SCRIPT_ROUTINE_UPDATE[] = "OnUpdate";
static const char SCRIPT_ROUTINE_RENDER[] = "OnRender";


class AndroidApplication : public Gao::Framework::Application {
public:
	AndroidApplication();
	virtual ~AndroidApplication();

	GaoBool Initialize(char* core, char* updateDelegate, char* renderDelegate);

	GaoVoid RunOnePass();

	GaoVoid OnSurfaceChanged(int width, int height);
	GaoVoid SetGLContext(JNIEnv* jni, jobject* renderer) {
		jniEnv = jni;
		glRenderer = renderer;
	}

	JNIEnv* GetJniEnv() {
		return jniEnv;
	}

	jobject* GetRenderer() {
		return glRenderer;
	}

protected:
	GaoBool OnInitialize();
	GaoVoid OnTerminate();
	GaoVoid OnUpdate();
	GaoVoid OnRender();

protected:
	Gao::Framework::LuaScriptManager* luaManager;

private:
	GaoBool CallLua(GaoConstCharPtr func);

	JNIEnv*  jniEnv;
	jobject* glRenderer;

	char* luaCore;
	char* luaUpdate;
	char* luaRender;
};

#endif /* ANDROIDAPPLICATION_H_ */
