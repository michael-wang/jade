/*
 * AndroidApplication.h
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#ifndef ANDROIDAPPLICATION_H_
#define ANDROIDAPPLICATION_H_

#include <android/asset_manager.h>
#include <Framework/Application.hpp>
#include <jni.h>
#include "AndroidLogger.h"
#include "AndroidLuaManager.h"
#include "Resource.h"


class AndroidApplication : public Gao::Framework::Application {
public:
	static AndroidApplication* Singleton;
	
public:
	AndroidApplication(int worldWidth, int worldHeight, char* luaScriptPath, AAssetManager* am, GaoBool debugMode);
	virtual ~AndroidApplication();

	GaoBool IsInitialized() {
		return initialized;
	}

	AndroidLuaManager* GetLuaManager() {
		return luaManager;
	}

	GaoVoid Start();
	GaoVoid Stop();
	GaoVoid Pause();
	GaoVoid Resume();

	GaoVoid RunOnePass();

	GaoBool ProcessBackKeyPressed();
	GaoVoid NotifyAlertDialogResult(GaoBool value);
	GaoVoid NotifyPlayMovieComplete();
	GaoVoid NotifyBuyResult(GaoConstCharPtr id, GaoBool success);
	GaoVoid NotifyPurchaseRestored(GaoConstCharPtr id);
	GaoVoid NotifyUIPresented();
	GaoVoid NotifySendMailResult(GaoBool value);
	GaoVoid NotifyStateLoadedFromCloud();
	GaoVoid NotifyGameServiceConnectionStatus(GaoBool connected);

protected:
	virtual GaoBool OnInitialize();
	virtual GaoVoid OnTerminate();
	virtual GaoVoid OnUpdate();
	virtual GaoVoid OnRender();
	virtual GaoBool IsAppRunning();

protected:
	AndroidLuaManager* luaManager;

	GaoBool CallLua(GaoConstCharPtr func);

	GaoString luaScriptPath;
	int worldWidth, worldHeight;

	GaoBool running;
	GaoBool initialized;
	AndroidLogger log;

	GaoBool debugMode;
};

#endif /* ANDROIDAPPLICATION_H_ */
