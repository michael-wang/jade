#ifndef ANDROIDLUAMANAGER_H_
#define ANDROIDLUAMANAGER_H_

#include <Framework/LuaScriptManager.hpp>
#include <Framework/Logger.hpp>
#include <android/asset_manager.h>

class AndroidLuaManager : public Gao::Framework::LuaScriptManager {

public:
	AndroidLuaManager (AAssetManager* am) :
		log ("native::framework::AndroidLuaManager", FALSE),
		assetManager(am),
		LuaScriptManager() {
	}

	GaoBool RunFromAsset(GaoString& path) {

		LOGD(log, "%s: path:%s", __func__, path.c_str())

		AAsset* asset = AAssetManager_open(assetManager, path.c_str(), AASSET_MODE_UNKNOWN);
		if (asset == NULL) {
			LOGE(log, "RunFromAsset no such asset:%s", path.c_str())
			return FALSE;
		}

		int len = AAsset_getLength(asset);
		LOGD(log, "len:%d", len)

		char* buf = new char[len];
		int readCount = AAsset_read(asset, (void*) buf, len);
		AAsset_close(asset);
		LOGD(log, "readCount:%d", readCount)

		if (len != readCount) {
			LOGE(log, "read count:%d != file length:%d", readCount, len);
			return FALSE;
		}

		LuaState L = GetLuaState();
		int error = luaL_loadbuffer(L, buf, len, path.c_str());
		LOGD(log, "error:%d", error)
		if (error) {
			LOGE(log, "Failed to load:%s, error: %s", path.c_str(), luaL_checkstring(L, lua_gettop(L)))
			return FALSE;
		}

		error = lua_pcall(L, 0, 0, 0);
		LOGD(log, "error:%d", error)
		if (error) {
			LOGE(log, "Failed to run:%s, error: %s", path.c_str(), luaL_checkstring(L, lua_gettop(L)))
			return FALSE;
		}

		return TRUE;
	}

private:
	AndroidLogger log;
	AAssetManager* assetManager;
};

#endif /* ANDROIDLUAMANAGER_H_ */