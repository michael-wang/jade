#include "com_studioirregular_gaoframework_AbsGameActivity.h"
#include "com_studioirregular_gaoframework_MyGLRenderer.h"
#include <android/asset_manager_jni.h>
#include <android/log.h>
#include <Android/AndroidApplication.h>
#include <string>


static const char TAG[] = "native::gaoframework";

AndroidApplication* app;

// NOTICE: do not handle non-ascii code.
static char* getJniString(JNIEnv* env, jstring jstr) {

  	const char* bytes = env->GetStringUTFChars(jstr, NULL);
  	std::string* str = new std::string(bytes);

  	char* chars = new char[str->length() + 1];
  	std::strcpy (chars, str->c_str());

  	delete str;
  	env->ReleaseStringUTFChars(jstr, bytes);

  	return chars;
}

/*
 * Class:     com_studioirregular_gaoframework_AbsGameActivity
 * Method:    ActivityOnCreate
 * Signature: (Lcom/studioirregular/gaoframework/JavaInterface;
 *             Landroid/content/res/AssetManager;
 *             Ljava/lang/String;
 *             Ljava/lang/String;
 *             Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnCreate
  (JNIEnv *env, jobject obj, jobject javaInterface, jobject am, jstring jLuaCore, jstring jLuaUpdate, 
    jstring jLuaRender) {    
    __android_log_print(ANDROID_LOG_INFO, TAG, "ActivityOnCreate");

    app = new AndroidApplication();

    app->SetJavaInterface(env, javaInterface);

    app->Initialize(
      AAssetManager_fromJava(env, am),
      getJniString(env, jLuaCore),
      getJniString(env, jLuaUpdate),
      getJniString(env, jLuaRender));

    app->SetJavaInterface(NULL, NULL);
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    ActivityOnDestroy
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnDestroy
  (JNIEnv *env, jobject obj) {
    __android_log_print(ANDROID_LOG_INFO,TAG, "ActivityOnDestroy");

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
    __android_log_print(ANDROID_LOG_INFO, TAG, 
      "RendererOnSurfaceChanged w:%d, h:%d", width, height);

    app->OnSurfaceChanged(width, height);
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    RendererOnDrawFrame
 * Signature: ("Lcom/studioirregular/gaoframework/JavaInterface;")V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_MyGLRenderer_RendererOnDrawFrame
  (JNIEnv *env, jobject obj, jobject javaInterface) {

    app->SetJavaInterface(env, javaInterface);

    app->RunOnePass();
    
    app->SetJavaInterface(NULL, NULL);
}

/*
 * Class:     com_studioirregular_gaoframework_AbsGameActivity
 * Method:    ActivityOnResume
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnResume
  (JNIEnv *env, jobject obj) {

    __android_log_print(ANDROID_LOG_INFO, TAG, "ActivityOnResume");

    if (app != NULL) {
        app->SetJavaInterface(env, NULL);
        app->Resume();
        app->SetJavaInterface(NULL, NULL);
    }
}

/*
 * Class:     com_studioirregular_gaoframework_AbsGameActivity
 * Method:    ActivityOnPause
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnPause
  (JNIEnv *env, jobject obj) {

    __android_log_print(ANDROID_LOG_INFO, TAG, "ActivityOnPause");
    
    if (app != NULL) {
        app->SetJavaInterface(env, NULL);
        app->Pause();
        app->SetJavaInterface(NULL, NULL);
    }
}
