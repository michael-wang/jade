/*
 * AndroidGraphicsRenderer.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidGraphicsRenderer.h>
#include <Android/AndroidApplication.h>
#include <android/log.h>

static const char JAVA_INTERFACE_PATH[]			= "com/studioirregular/gaoframework/JavaInterface";
static const char JAVA_DRAW_RECT_NAME[] 		= "drawRectangle";
static const char JAVA_DRAW_RECT_DESCRIPTOR[]	= "(IIIIFFFFLcom/studioirregular/gaoframework/GLTexture;)V";

using namespace Gao::Framework;

AndroidGraphicsRenderer::AndroidGraphicsRenderer() :
	width(0), height(0), drawRectID(NULL) {
}

AndroidGraphicsRenderer::~AndroidGraphicsRenderer() {
}

GaoVoid AndroidGraphicsRenderer::OnSurfaceChanged(GaoInt32 w, GaoInt32 h) {
	__android_log_print(ANDROID_LOG_INFO, "AndroidGraphicsRenderer", "OnSurfaceChanged w:%d, h:%d", w, h);

	width = w;
	height = h;
}

Texture* AndroidGraphicsRenderer::CreateTexture(GaoString& fileName) {
	__android_log_print(ANDROID_LOG_INFO, "AndroidGraphicsRenderer", "CreateTexture fileName:%s", fileName.c_str());

	GLTexture* texture = new GLTexture();

	if (!texture->Create(fileName)) {
		delete texture;
		texture = NULL;
		__android_log_print(ANDROID_LOG_ERROR, "AndroidGraphicsRenderer", "CreateTexture texture->Create failed.");
	}

	__android_log_print(ANDROID_LOG_INFO, "AndroidGraphicsRenderer", "CreateTexture texture:%p", texture);
	return texture;
}

GaoVoid AndroidGraphicsRenderer::DrawRectangle (
	GaoInt16 startX, GaoInt16 startY, GaoInt16 endX, GaoInt16 endY, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha,
	Texture* texture) {

//	__android_log_print(ANDROID_LOG_INFO, "AndroidGraphicsRenderer", "DrawRectangle texture:%p", texture);

	AndroidApplication* app = AndroidApplication::Singleton;
	if (app == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, "AndroidGraphicsRenderer", 
			"DrawRectangle: AndroidApplication::Singleton == NULL");
	}

	JNIEnv* jni  = app->GetJniEnv();
	if (jni == NULL) {
		return;
	}

	jobject javaInterface = app->GetJavaInterface();
	if (javaInterface == NULL) {
		return;
	}

	if (drawRectID == NULL) {
		jclass clazz = jni->FindClass(JAVA_INTERFACE_PATH);
		drawRectID = jni->GetMethodID(clazz, JAVA_DRAW_RECT_NAME, JAVA_DRAW_RECT_DESCRIPTOR);
	}

	if (drawRectID == NULL) {
		return;
	}

	GLTexture* gltexture = dynamic_cast<GLTexture*>(texture);
	jni->CallVoidMethod(javaInterface, drawRectID, startX, startY, endX, endY, 
		red, green, blue, alpha, gltexture->GetJavaReference());
}