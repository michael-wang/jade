/*
 * AndroidGraphicsRenderer.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidGraphicsRenderer.h>
#include <Android/AndroidApplication.h>
#include <Android/GLTexture.h>
#include <android/log.h>

static const char JAVA_RENDERER_PATH[]      = "com/studioirregular/gaoframework/MyGLRenderer";
static const char RENDERER_DRAW_RECT_NAME[] = "drawRectangle";
static const char RENDERER_DRAW_RECT_DESCRIPTOR[] = "(IIIIFFFF)V";

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

	return texture;
}

GaoVoid AndroidGraphicsRenderer::DrawRectangle (
	GaoInt16 startX, GaoInt16 startY, GaoInt16 endX, GaoInt16 endY, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {
	// __android_log_print(ANDROID_LOG_INFO, "AndroidGraphicsRenderer", 
	// 	"DrawRectangle left:%d, top:%d, right:%d, bottom:%d, red:%f, green:%f, blue:%f, alpha:%f", 
	// 	startX, startY, endX, endY, red, green, blue, alpha);

	if (g_Application == NULL) {
		return;
	}

	AndroidApplication* app = dynamic_cast<AndroidApplication*>(g_Application);

	JNIEnv* jni  = app->GetJniEnv();
	if (jni == NULL) {
		return;
	}

	jobject* obj = app->GetRenderer();
	if (obj == NULL) {
		return;
	}

	if (drawRectID == NULL) {
		jclass clazz = jni->FindClass(JAVA_RENDERER_PATH);
		drawRectID = jni->GetMethodID(clazz, RENDERER_DRAW_RECT_NAME, RENDERER_DRAW_RECT_DESCRIPTOR);
	}

	if (drawRectID == NULL) {
		return;
	}

	jni->CallVoidMethod(*obj, drawRectID, startX, startY, endX, endY, red, green, blue, alpha);
}