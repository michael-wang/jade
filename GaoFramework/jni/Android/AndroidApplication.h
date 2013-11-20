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
#include "Resource.h"


class AndroidApplication : public Gao::Framework::Application {
public:
	static AndroidApplication* Singleton;
	
public:
	AndroidApplication();
	virtual ~AndroidApplication();

	GaoBool Initialize(char* coreLuaName, char* updateLuaName, char* renderLuaName);

	GaoVoid Pause();
	GaoVoid Resume();

	GaoVoid RunOnePass();

	GaoVoid OnSurfaceChanged(int width, int height);

protected:
	virtual GaoBool OnInitialize();
	virtual GaoVoid OnTerminate();
	virtual GaoVoid OnUpdate();
	virtual GaoVoid OnRender();
	virtual GaoVoid OnPause(GaoBool onPause);
	virtual GaoBool IsAppRunning();

protected:
	Gao::Framework::LuaScriptManager* luaManager;

	GaoBool CallLua(GaoConstCharPtr func);

	GaoString coreLuaName;
	GaoString updateLuaName;
	GaoString renderLuaName;

	GaoBool running;
};

#endif /* ANDROIDAPPLICATION_H_ */
