#ifndef RESOURCE_H_
#define RESOURCE_H_

#include <android/asset_manager.h>
#include <png.h>
#include "AndroidLogger.h"


class Resource {

public:
	Resource(AAssetManager* assetManager);
	virtual ~Resource();

	char* readAsTextFile(const char* filename);
	unsigned char* loadPngImage(const char* path);

private:
	bool read(void* pBuffer, size_t pCount);

	static void callback_read(png_structp pStruct,
		png_bytep pData, png_size_t pSize);

private:
	AAssetManager* am;
	AAsset*        asset;
	AndroidLogger log;
};

#endif // RESOURCE_H_