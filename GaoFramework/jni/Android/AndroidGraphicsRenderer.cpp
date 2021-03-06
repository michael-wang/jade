/*
 * AndroidGraphicsRenderer.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidApplication.h>
#include <Android/AndroidGraphicsRenderer.h>
#include <Android/AndroidSprite.h>
#include <Android/AndroidTransform.h>
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

Transform* AndroidGraphicsRenderer::CreateTransform() {

	LOGD(log, "CreateTransform")

	return new AndroidTransform();
}

Texture* AndroidGraphicsRenderer::CreateTexture(GaoString& fileName) {
	LOGD(log, "CreateTexture fileName:%s", fileName.c_str())

	return _createTexture(fileName, false);
}

Texture* AndroidGraphicsRenderer::CreateFilteredTexture(GaoString& fileName) {
	
	LOGD(log, "CreateFilteredTexture fileName:%s", fileName.c_str())

	return _createTexture(fileName, true);
}

Texture* AndroidGraphicsRenderer::CreateSpecialTexture(GaoInt32 width, GaoInt32 height) {

	LOGD(log, "CreateSpecialTexture w:%d, h:%d", width, height)

	return NULL;
}

GaoBool AndroidGraphicsRenderer::IsSpecialTextureValid() const {

	LOGD(log, "IsSpecialTextureValid")

	return false;
}

Texture* AndroidGraphicsRenderer::_createTexture(GaoString& fileName, GaoBool filtered) {
	GLTexture* texture = new GLTexture();
	GaoString path = m_ImageBasePath + fileName;

	if (!texture->Create(path, filtered)) {
		delete texture;
		texture = NULL;
		LOGE(log, "_createTexture texture->Create failed.")
	}

	LOGD(log, "_createTexture texture:%p", texture)
	return texture;
}

GaoBool AndroidGraphicsRenderer::ReloadTexture(Texture* texture) {
	LOGD(log, "ReloadTexture")

	GaoBool result = false;

	GLTexture* gltex = dynamic_cast<GLTexture*>(texture);
	if (gltex != NULL) {
		result = gltex->Reload();
	}

	return result;
}

GaoVoid AndroidGraphicsRenderer::UnloadTexture(Texture* texture) {
	LOGD(log, "UnloadTexture")

	GLTexture* glt = dynamic_cast<GLTexture*>(texture);
	if (glt != NULL) {
		glt->Unload();
	}
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

GaoVoid AndroidGraphicsRenderer::DrawRectangle(
	GaoInt16 left, GaoInt16 top, GaoInt16 right, GaoInt16 bottom, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {

	LOGD(log, "DrawRectangle left:%d, top:%d, right:%d, bottom:%d", 
		left, top, right, bottom)
	
	JavaInterface* ji = JavaInterface::GetSingletonPointer();

	if (ji != NULL) {
		ji->DrawRectangle(left, top, right, bottom, red, green, blue, alpha);
	}
}

GaoVoid AndroidGraphicsRenderer::DrawCircle(
	GaoInt16 centerX, GaoInt16 centerY, GaoInt16 radius, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {

	LOGD(log, "DrawCircle x:%d, y:%d, radius:%d", centerX, centerY, radius)

	JavaInterface* ji = JavaInterface::GetSingletonPointer();

	if (ji != NULL) {
		ji->DrawCircle(centerX, centerY, radius, red, green, blue, alpha);
	}
}