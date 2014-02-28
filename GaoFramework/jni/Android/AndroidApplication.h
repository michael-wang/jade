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
#include "AndroidLogger.h"
#include "Resource.h"


class AndroidApplication : public Gao::Framework::Application {
public:
	static AndroidApplication* Singleton;
	
public:
	AndroidApplication(int worldWidth, int worldHeight, char* luaScriptPath);
	virtual ~AndroidApplication();

	GaoBool IsInitialized() {
		return initialized;
	}

	GaoVoid Start();
	GaoVoid Stop();

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
	Gao::Framework::LuaScriptManager* luaManager;

	GaoBool CallLua(GaoConstCharPtr func);

	GaoString luaScriptPath;
	int worldWidth, worldHeight;

	GaoBool running;
	GaoBool initialized;
	AndroidLogger log;
};

#endif /* ANDROIDAPPLICATION_H_ */
