#ifndef ANDROIDLUAMANAGERWRAPPER_H_
#define ANDROIDLUAMANAGERWRAPPER_H_

#include "AndroidApplication.h"
#include "AndroidLuaManager.h"

/*
 * I don't know how to pass pointer of AndroidLuaManager to lua, and let lua call its 
 * member method. That's why I use this wrapper class to let lua create it, and call 
 * method that eventually call AndroidLuaManager's member method.
 */
class AndroidLuaManagerWrapper {
public:
	AndroidLuaManagerWrapper() :
		log ("native::framework::AndroidLuaManagerWrapper", FALSE) {

		LOGD(log, "Constructor")
	}

	GaoBool RunFromAsset(const char* path) {

		LOGD(log, "RunFromAsset path:%s", path)

		AndroidLuaManager* luaManager = AndroidApplication::Singleton->GetLuaManager();

		if (luaManager == NULL) {
			LOGE(log, "RunFromAsset luaManager == NULL")
			return FALSE;
		}

		std::string strPath = path;
		return luaManager->RunFromAsset(strPath);
	}

private:
	AndroidLogger log;
};

#endif /* ANDROIDLUAMANAGERWRAPPER_H_ */
