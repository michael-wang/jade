/*
 * AndroidGraphicsRenderer.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidGraphicsRenderer.h>
#include <Android/AndroidApplication.h>
#include <android/log.h>
#include "JavaInterface.h"

static const char TAG[]                 = "native::framework::AndroidGraphicsRenderer";
static const char JAVA_INTERFACE_PATH[] = "com/studioirregular/gaoframework/JavaInterface";


using namespace Gao::Framework;

AndroidGraphicsRenderer::AndroidGraphicsRenderer() :
	width(0), height(0), drawRectID(NULL) {
}

AndroidGraphicsRenderer::~AndroidGraphicsRenderer() {
}

GaoVoid AndroidGraphicsRenderer::OnSurfaceChanged(GaoInt32 w, GaoInt32 h) {
	__android_log_print(ANDROID_LOG_INFO, TAG, "OnSurfaceChanged w:%d, h:%d", w, h);

	width = w;
	height = h;
}

Texture* AndroidGraphicsRenderer::CreateTexture(GaoString& fileName) {
	__android_log_print(ANDROID_LOG_INFO, TAG, "CreateTexture fileName:%s", 
		fileName.c_str());

	GLTexture* texture = new GLTexture();

	if (!texture->Create(fileName)) {
		delete texture;
		texture = NULL;
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"CreateTexture texture->Create failed.");
	}

	__android_log_print(ANDROID_LOG_INFO, TAG, "CreateTexture texture:%p", texture);
	return texture;
}

GaoVoid AndroidGraphicsRenderer::Draw(Rectangle* rect) {

	JavaInterface* ji = JavaInterface::GetSingletonPointer();

	if (ji == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"Draw: cannot get JavaInterface::GetSingletonPointer.");
		return;
	}

	ji->Draw(rect);
}
