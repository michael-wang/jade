/*
 * AndroidGraphicsRenderer.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidApplication.h>
#include <Android/AndroidGraphicsRenderer.h>
#include <Android/AndroidSprite.h>
#include "JavaInterface.h"


static const char JAVA_INTERFACE_PATH[] = "com/studioirregular/gaoframework/JavaInterface";


using namespace Gao::Framework;

AndroidGraphicsRenderer::AndroidGraphicsRenderer() :
	width(0), height(0), drawRectID(NULL),
	log ("native::framework::AndroidGraphicsRenderer", false) {
}

AndroidGraphicsRenderer::~AndroidGraphicsRenderer() {
}

GaoVoid AndroidGraphicsRenderer::OnSurfaceChanged(GaoInt32 w, GaoInt32 h) {
	LOGD(log, "OnSurfaceChanged w:%d, h:%d", w, h)

	width = w;
	height = h;
}

Texture* AndroidGraphicsRenderer::CreateTexture(GaoString& fileName) {
	LOGD(log, "CreateTexture fileName:%s", fileName.c_str())

	GLTexture* texture = new GLTexture();

	if (!texture->Create(fileName)) {
		delete texture;
		texture = NULL;
		LOGE(log, "CreateTexture texture->Create failed.")
	}

	LOGD(log, "CreateTexture texture:%p", texture)
	return texture;
}

Sprite* AndroidGraphicsRenderer::CreateSprite(Transform* transform, 
	Texture* texture) {
	
	LOGD(log, "CreateSprite transform:%p, texture:%p", transform, texture)

	Sprite* sprite = new AndroidSprite();

	if (!sprite->Create(transform, texture)) {
		SAFE_DELETE(sprite);
		LOGE(log, "CreateSprite: failed to create sprite.");
	}

	return sprite;
}

GaoVoid AndroidGraphicsRenderer::Draw(Rectangle* rect) {

	JavaInterface* ji = JavaInterface::GetSingletonPointer();

	if (ji == NULL) {
		LOGE(log, "Draw: cannot get JavaInterface::GetSingletonPointer.")
		return;
	}

	ji->Draw(rect);
}
