#include "com_studioirregular_gaoframework_AbsGameActivity.h"
#include "com_studioirregular_gaoframework_MyGLRenderer.h"
#include <android/log.h>
#include <Android/AndroidApplication.h>
#include <string>


AndroidApplication* app;

// NOTICE: do not handle non-ascii code.
char* getJniString(JNIEnv* env, jstring jstr) {

  	const char* bytes = env->GetStringUTFChars(jstr, NULL);
  	std::string* str = new std::string(bytes);

  	char* chars = new char[str->length() + 1];
  	std::strcpy (chars, str->c_str());

  	delete str;
  	env->ReleaseStringUTFChars(jstr, bytes);

  	return chars;
}
/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    ActivityOnCreate
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnCreate
  (JNIEnv *env, jobject obj, jstring jLuaCore, jstring jLuaUpdate, jstring jLuaRender) {
	__android_log_print(ANDROID_LOG_INFO, "gaoframework", "ActivityOnCreate");

	app = new AndroidApplication();
	app->Initialize(
		getJniString(env, jLuaCore),
		getJniString(env, jLuaUpdate),
		getJniString(env, jLuaRender));
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    ActivityOnDestroy
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnDestroy
  (JNIEnv *env, jobject obj) {
	__android_log_print(ANDROID_LOG_INFO, "gaoframework", "ActivityOnDestroy");

	app->Terminate();
	SAFE_DELETE(app);
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    RendererOnSurfaceChanged
 * Signature: (II)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_MyGLRenderer_RendererOnSurfaceChanged
  (JNIEnv *env, jobject obj, jint width, jint height) {
	__android_log_print(ANDROID_LOG_INFO, "gaoframework", "RendererOnSurfaceChanged w:%d, h:%d", width, height);

	app->OnSurfaceChanged(width, height);
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    RendererOnDrawFrame
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_MyGLRenderer_RendererOnDrawFrame
  (JNIEnv *env, jobject obj) {
  	app->SetGLContext(env, &obj);
  	app->RunOnePass();
}
