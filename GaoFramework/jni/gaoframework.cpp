#include "com_studioirregular_gaoframework_AbsGameActivity.h"
#include "com_studioirregular_gaoframework_MyGLRenderer.h"
#include <android/asset_manager_jni.h>
#include <android/log.h>
#include <Android/AndroidApplication.h>
#include <Android/AndroidLogger.h>
#include <Android/Java/JniEnv.h>
#include <string>


static const char TAG[] = "native::gaoframework";

static AndroidApplication* app;
static JniEnv* jni;
static AndroidLogger logger(TAG, false);

static int WORLD_WIDTH = 0;
static int WORLD_HEIGHT = 0;

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
 * Signature: (IILjava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnCreate
  (JNIEnv *env, jobject obj, jint worldWidth, jint worldHeight, jstring assetFolder) {    
    LOGD(logger, "ActivityOnCreate")

    WORLD_WIDTH = worldWidth;
    WORLD_HEIGHT = worldHeight;

    app = new AndroidApplication();
    jni = new JniEnv();

    // g_JniEnv->Set(env);

    // app->Initialize(getJniString(env, assetFolder));

    // g_JniEnv->Set(NULL);
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    ActivityOnDestroy
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnDestroy
  (JNIEnv *env, jobject obj) {
    LOGD(logger, "ActivityOnDestroy")

    g_JniEnv->Set(env);

    app->Terminate();

    // g_JniEnv->Set(NULL);

    SAFE_DELETE(app);
    SAFE_DELETE(jni);
}

/*
 * Class:     com_studioirregular_gaoframework_MyGLRenderer
 * Method:    RendererOnSurfaceCreated
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_MyGLRenderer_RendererOnSurfaceCreated
  (JNIEnv *, jobject) {

    LOGD(logger, "RendererOnSurfaceCreated")
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    RendererOnSurfaceChanged
 * Signature: (IILjava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_MyGLRenderer_RendererOnSurfaceChanged
  (JNIEnv *env, jobject obj, jint glSurfaceWidth, jint glSurfaceHeight, jstring assetFolder) {
    LOGD(logger, "RendererOnSurfaceChanged w:%d, h:%d", glSurfaceWidth, glSurfaceHeight)

    if (app == NULL) {
        app = new AndroidApplication();
        LOGE(logger, "Unexpected AndroidApplication == null, reallocate here.")
    }

    if (jni == NULL) {
        jni = new JniEnv();
        LOGE(logger, "Unexpected JniEnv == null, reallocate here.")
    }

    if (app->IsInitialized() == FALSE) {
        g_JniEnv->Set(env);

        // app needs logical game world size, not GL surface size.
        app->Initialize(getJniString(env, assetFolder), WORLD_WIDTH, WORLD_HEIGHT);

        g_JniEnv->Set(NULL);
    }
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    RendererOnDrawFrame
 * Signature: ("Lcom/studioirregular/gaoframework/JavaInterface;")V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_MyGLRenderer_RendererOnDrawFrame
  (JNIEnv *env, jobject obj) {

    g_JniEnv->Set(env);

    app->RunOnePass();
    
    g_JniEnv->Set(NULL);
}

/*
 * Class:     com_studioirregular_gaoframework_AbsGameActivity
 * Method:    ActivityOnResume
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnResume
  (JNIEnv *env, jobject obj) {

    LOGD(logger, "ActivityOnResume");

    if (jni != NULL && app != NULL) {
        jni->Set(env);

        app->Resume();

        jni->Set(NULL);
    }
}

/*
 * Class:     com_studioirregular_gaoframework_AbsGameActivity
 * Method:    ActivityOnPause
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnPause
  (JNIEnv *env, jobject obj) {

    LOGD(logger, "ActivityOnPause");
    
    if (jni != NULL && app != NULL) {
        jni->Set(env);

        app->Pause();

        jni->Set(NULL);
    }
}
