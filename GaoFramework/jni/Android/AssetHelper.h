#ifndef ASSETHELPER_H_
#define ASSETHELPER_H_

#include <android/asset_manager.h>
#include <android/log.h>

class AssetHelper {

public:
	AssetHelper(AAssetManager* assetManager) :
		am (assetManager) {}

	~AssetHelper() {
		am = NULL;
	}

	char* readAsTextFile(const char* filename) {
		AAsset* ass = AAssetManager_open(am, filename, AASSET_MODE_BUFFER);
		__android_log_print(ANDROID_LOG_INFO, "AssetHelper", "ass:%p", ass);
		if (ass == NULL) {
			return NULL;
		}

		const int SIZE = AAsset_getLength(ass) + 1;
		__android_log_print(ANDROID_LOG_INFO, "AssetHelper", "SIZE:%d", SIZE);
		char* result = new char[SIZE];

		int len = AAsset_read(ass, result, SIZE - 1);
		result[SIZE - 1] = '\0';
		__android_log_print(ANDROID_LOG_INFO, "AssetHelper", "read len:%d", len);

		if (len <= 0) {
			result = NULL;
		}

		if (ass != NULL) {
			AAsset_close(ass);
			ass = NULL;
		}

		return result;
	}

private:
	AAssetManager* am;
};

#endif // ASSETHELPER_H_