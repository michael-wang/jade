#include "Resource.h"
#include <GLES/gl.h>
#include <android/asset_manager.h>


Resource::Resource(AAssetManager* assetManager) :
	am (assetManager),
	asset (NULL),
    log ("native::framework::Resource", false) {
}

Resource::~Resource() {
	am = NULL;
	asset = NULL;
}

char* Resource::readAsTextFile(const char* filename) {

	asset = AAssetManager_open(am, filename, AASSET_MODE_BUFFER);
	LOGD(log, "asset:%p", asset)
	if (asset == NULL) {
		return NULL;
	}

	const int FILE_LEN = AAsset_getLength(asset);
	const int RESULT_SIZE = FILE_LEN + 1;
	const int RESULT_LAST = RESULT_SIZE - 1;
	LOGD(log, "FILE_LEN:%d", FILE_LEN)
	char* result = new char[RESULT_SIZE];

	int readCount = AAsset_read(asset, result, FILE_LEN);
	if (readCount != FILE_LEN) {
		LOGE(log, "readCount:%d != FILE_LEN:%d", readCount, FILE_LEN)
		return NULL;
	}

	result[RESULT_LAST] = '\0';

	if (asset != NULL) {
		AAsset_close(asset);
		asset = NULL;
	}

	return result;
}

unsigned char* Resource::loadPngImage(const char* path) {

    LOGD(log, "loadPngImage path:%s", path)

    png_byte lHeader[8];
    png_structp lPngPtr = NULL; png_infop lInfoPtr = NULL;
    png_byte* lImageBuffer = NULL; png_bytep* lRowPtrs = NULL;
    png_int_32 lRowSize; bool lTransparency;
    int32_t lReadCount = 0; size_t bufSize = 0;

    // Opens and checks image signature (first 8 bytes).
    asset = AAssetManager_open(am, path, AASSET_MODE_UNKNOWN);
    if (asset == NULL) goto ERROR;
    LOGD(log, "Checking signature.")
    bufSize = sizeof(lHeader);
    lReadCount = AAsset_read(asset, lHeader, bufSize);
    if (lReadCount != bufSize) {
        goto ERROR;
    }
    if (png_sig_cmp(lHeader, 0, 8) != 0) goto ERROR;

    // Creates required structures.
    LOGD(log, "Creating required structures.")
    lPngPtr = png_create_read_struct(PNG_LIBPNG_VER_STRING,
        NULL, NULL, NULL);
    if (!lPngPtr) goto ERROR;
    lInfoPtr = png_create_info_struct(lPngPtr);
    if (!lInfoPtr) goto ERROR;

    // Prepares reading operation by setting-up a read callback.
    png_set_read_fn(lPngPtr, this, callback_read);
    // Set-up error management. If an error occurs while reading,
    // code will come back here and jump
    if (setjmp(png_jmpbuf(lPngPtr))) goto ERROR;

    // Ignores first 8 bytes already read and processes header.
    png_set_sig_bytes(lPngPtr, 8);
    png_read_info(lPngPtr, lInfoPtr);
    // Retrieves PNG info and updates PNG struct accordingly.
    png_int_32 lDepth, lColorType;
    png_uint_32 lWidth, lHeight;
    png_get_IHDR(lPngPtr, lInfoPtr, &lWidth, &lHeight,
        &lDepth, &lColorType, NULL, NULL, NULL);
    LOGD(log, "png width:%d, height:%d.", lWidth, lHeight)

    // Creates a full alpha channel if transparency is encoded as
    // an array of palette entries or a single transparent color.
    lTransparency = false;
    if (png_get_valid(lPngPtr, lInfoPtr, PNG_INFO_tRNS)) {
        png_set_tRNS_to_alpha(lPngPtr);
        lTransparency = true;
        goto ERROR;
    }
    // Expands PNG with less than 8bits per channel to 8bits.
    if (lDepth < 8) {
        png_set_packing (lPngPtr);
    // Shrinks PNG with 16bits per color channel down to 8bits.
    } else if (lDepth == 16) {
        png_set_strip_16(lPngPtr);
    }
    // Indicates that image needs conversion to RGBA if needed.
//	GLuint mFormat = 0;
    switch (lColorType) {
    case PNG_COLOR_TYPE_PALETTE:
        png_set_palette_to_rgb(lPngPtr);
//        mFormat = lTransparency ? GL_RGBA : GL_RGB;
        break;
    case PNG_COLOR_TYPE_RGB:
//        mFormat = lTransparency ? GL_RGBA : GL_RGB;
        break;
    case PNG_COLOR_TYPE_RGBA:
//        mFormat = GL_RGBA;
        break;
    case PNG_COLOR_TYPE_GRAY:
        png_set_expand_gray_1_2_4_to_8(lPngPtr);
//        mFormat = lTransparency ? GL_LUMINANCE_ALPHA:GL_LUMINANCE;
        break;
    case PNG_COLOR_TYPE_GA:
        png_set_expand_gray_1_2_4_to_8(lPngPtr);
//        mFormat = GL_LUMINANCE_ALPHA;
        break;
    }
    // Validates all tranformations.
    png_read_update_info(lPngPtr, lInfoPtr);

    // Get row size in bytes.
    lRowSize = png_get_rowbytes(lPngPtr, lInfoPtr);
    if (lRowSize <= 0) goto ERROR;
    // Ceates the image buffer that will be sent to OpenGL.
    lImageBuffer = new png_byte[lRowSize * lHeight];
    if (!lImageBuffer) goto ERROR;
    // Pointers to each row of the image buffer. Row order is
    // inverted because different coordinate systems are used by
    // OpenGL (1st pixel is at bottom left) and PNGs (top-left).
    lRowPtrs = new png_bytep[lHeight];
    if (!lRowPtrs) goto ERROR;
    for (int32_t i = 0; i < lHeight; ++i) {
        lRowPtrs[lHeight - (i + 1)] = lImageBuffer + i * lRowSize;
    }
    // Reads image content.
    png_read_image(lPngPtr, lRowPtrs);

    // Frees memory and resources.
    AAsset_close(asset);
    png_destroy_read_struct(&lPngPtr, &lInfoPtr, NULL);
    delete[] lRowPtrs;
    return lImageBuffer;

ERROR:
	LOGE(log, "Error while reading PNG file")
	if (asset != NULL) {
		AAsset_close(asset);
	}
    delete[] lRowPtrs; delete[] lImageBuffer;
    if (lPngPtr != NULL) {
        png_infop* lInfoPtrP = lInfoPtr != NULL ? &lInfoPtr: NULL;
        png_destroy_read_struct(&lPngPtr, lInfoPtrP, NULL);
    }
    return NULL;
}

void Resource::callback_read(png_structp pStruct,
    png_bytep pData, png_size_t pSize) {

    Resource* res = ((Resource*) png_get_io_ptr(pStruct));
    int32_t lReadCount = AAsset_read(res->asset, pData, pSize);
    if (lReadCount != pSize) {
        AAsset_close(res->asset);
        res->asset = NULL;
    }
}
