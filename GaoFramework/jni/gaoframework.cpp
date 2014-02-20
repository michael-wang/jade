#include "com_studioirregular_gaoframework_AbsGameActivity.h"
#include "com_studioirregular_gaoframework_MyGLRenderer.h"
#include "com_studioirregular_gaoframework_NativeInterface.h"
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
  (JNIEnv *env, jobject obj, jint worldWidth, jint worldHeight, jstring luaScriptPath) {    
    LOGD(logger, "ActivityOnCreate")

    WORLD_WIDTH = worldWidth;
    WORLD_HEIGHT = worldHeight;

    app = new AndroidApplication(worldWidth, worldHeight, getJniString(env, luaScriptPath));
    jni = new JniEnv();
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
 * Signature: (II)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_MyGLRenderer_RendererOnSurfaceChanged
  (JNIEnv *env, jobject obj, jint glSurfaceWidth, jint glSurfaceHeight) {
    LOGD(logger, "RendererOnSurfaceChanged w:%d, h:%d", glSurfaceWidth, glSurfaceHeight)

    if (app == NULL) {
        LOGE(logger, "Unexpected AndroidApplication == null.")
        return;
    }

    if (jni == NULL) {
        jni = new JniEnv();
        LOGW(logger, "Unexpected JniEnv == null, reallocate here.")
    }

    if (app->IsInitialized() == FALSE) {
        g_JniEnv->Set(env);

        // app needs logical game world size, not GL surface size.
        app->Initialize();

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
 * Method:    ActivityOnStart
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnStart
  (JNIEnv *env, jobject obj) {

    LOGD(logger, "ActivityOnStart");

    if (jni != NULL && app != NULL) {
        jni->Set(env);

        app->Start();

        jni->Set(NULL);
    }
}

/*
 * Class:     com_studioirregular_gaoframework_AbsGameActivity
 * Method:    ActivityOnStop
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_AbsGameActivity_ActivityOnStop
  (JNIEnv *env, jobject obj) {

    LOGD(logger, "ActivityOnStop");
    
    if (jni != NULL && app != NULL) {
        jni->Set(env);

        app->Stop();

        jni->Set(NULL);
    }
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    ProcessBackKey
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_com_studioirregular_gaoframework_NativeInterface_ProcessBackKey
  (JNIEnv *env, jobject obj) {

    LOGD(logger, "ProcessBackKey");

    jboolean result = FALSE;

    if (jni != NULL && app != NULL) {
        jni->Set(env);

        result = app->ProcessBackKeyPressed();

        jni->Set(NULL);
    }

    return result;
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyAlertDialogResult
 * Signature: (Z)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyAlertDialogResult
  (JNIEnv *env, jobject obj, jboolean value) {

    LOGD(logger, "NotifyAlertDialogResult value:%d", value)

    if (jni != NULL && app != NULL) {
        jni->Set(env);

        app->NotifyAlertDialogResult(value);

        jni->Set(NULL);
    }
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyPlayMovieComplete
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyPlayMovieComplete
  (JNIEnv *env, jobject obj) {
    
    LOGD(logger, "NotifyPlayMovieComplete")

    if (jni != NULL && app != NULL) {
        jni->Set(env);

        app->NotifyPlayMovieComplete();

        jni->Set(NULL);
    }
}

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyBuyResult
 * Signature: (Ljava/lang/String;Z)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyBuyResult
  (JNIEnv *env, jobject obj, jstring id, jboolean success) {

    const char* cId = getJniString(env, id);

    LOGD(logger, "NotifyBuyResult id:%s, success:%d", cId, success)

    if (jni != NULL && app != NULL) {
        jni->Set(env);

        app->NotifyBuyResult(cId, success);

        jni->Set(NULL);
    }
}
