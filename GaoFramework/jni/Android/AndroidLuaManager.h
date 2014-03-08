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

		AndroidLogger logger("AndroidLuaManager");
		LOGD(logger, "%s: path:%s", __func__, path.c_str())

		AAsset* asset = AAssetManager_open(assetManager, path.c_str(), AASSET_MODE_UNKNOWN);

		int len = AAsset_getLength(asset);
		LOGD(logger, "len:%d", len)

		char* buf = new char[len + 1];
		int readCount = AAsset_read(asset, (void*) buf, len);
		buf[len] = '\0';	// mark end of string.
		AAsset_close(asset);

		if (len != readCount) {
			LOGE(logger, "read count:%d != file length:%d", readCount, len);
			return FALSE;
		}

		return RunFromString(buf);
	}

private:
	AndroidLogger log;
	AAssetManager* assetManager;
};

#endif /* ANDROIDLUAMANAGER_H_ */