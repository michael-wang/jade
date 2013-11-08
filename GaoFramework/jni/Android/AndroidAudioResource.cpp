#include "AndroidAudioResource.h"
#include "AndroidApplication.h"

static const char TAG[] = "native::framework::AndroidAudioResource";

static const char JAVA_CLASS_PATH[]				= "com/studioirregular/gaoframework/AudioResource";
static const char JAVA_METHOD_CONSTRUCTOR_DESC[]= "(I)V";
static const char JAVA_METHOD_CREATE[]			= "Create";
static const char JAVA_METHOD_CREATE_DESC[]		= "(Ljava/lang/String;Z)Z";
static const char JAVA_METHOD_PLAY[]			= "Play";
static const char JAVA_METHOD_PLAY_DESC[]		= "()Z";
static const char JAVA_METHOD_PAUSE[]			= "Pause";
static const char JAVA_METHOD_PAUSE_DESC[]		= "()V";
static const char JAVA_METHOD_STOP[]			= "Stop";
static const char JAVA_METHOD_STOP_DESC[]		= "()V";


AndroidAudioResource::AndroidAudioResource(AudioType type) :
	jniHelper (JAVA_CLASS_PATH) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "AndroidAudioResource type:%d", type);

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();

	jobject obj = jniHelper.NewObject(env, JAVA_METHOD_CONSTRUCTOR_DESC, type);
	if (obj != NULL) {
		javaRef = env->NewGlobalRef(obj);
	}

	jniHelper.AddMethod(env, JMETHOD_CREATE, JAVA_METHOD_CREATE, JAVA_METHOD_CREATE_DESC);
	jniHelper.AddMethod(env, JMETHOD_PLAY,   JAVA_METHOD_PLAY,   JAVA_METHOD_PLAY_DESC);
	jniHelper.AddMethod(env, JMETHOD_PAUSE,  JAVA_METHOD_PAUSE,  JAVA_METHOD_PAUSE_DESC);
	jniHelper.AddMethod(env, JMETHOD_STOP,   JAVA_METHOD_STOP,   JAVA_METHOD_STOP_DESC);
}

AndroidAudioResource::~AndroidAudioResource() {
	if (javaRef != NULL) {
		if (AndroidApplication::Singleton != NULL) {
			JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();

			if (env != NULL) {
				env->DeleteGlobalRef(javaRef);
				javaRef = NULL;
			} else {
				// Show error msg;
			}
		} else {
			// Show error msg;
		}
	} else {
		// Show error msg;
	}
}

GaoBool AndroidAudioResource::Create(AudioType type, GaoString& fileName, GaoBool loop) {
	if (AndroidApplication::Singleton == NULL) {
		// Show error msg;
		return FALSE;
	}

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();
	if (env == NULL) {
		// Show error msg;
		return FALSE;
	}

	jstring jstrFileName = env->NewStringUTF(fileName.c_str());
	return env->CallBooleanMethod(javaRef, jniHelper.GetMethod(JMETHOD_CREATE), 
		jstrFileName);
}

GaoVoid AndroidAudioResource::Play() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Play");

	if (AndroidApplication::Singleton == NULL) {
		// Show error msg;
		return;
	}

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();
	if (env == NULL) {
		// Show error msg;
		return;
	}

	env->CallBooleanMethod(javaRef, jniHelper.GetMethod(JMETHOD_PLAY));
}

GaoVoid AndroidAudioResource::Stop() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Stop");

	if (AndroidApplication::Singleton == NULL) {
		// Show error msg;
		return;
	}

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();
	if (env == NULL) {
		// Show error msg;
		return;
	}

	env->CallVoidMethod(javaRef, jniHelper.GetMethod(JMETHOD_STOP));
}

GaoVoid AndroidAudioResource::Pause() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Pause");

	if (AndroidApplication::Singleton == NULL) {
		// Show error msg;
		return;
	}

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();
	if (env == NULL) {
		// Show error msg;
		return;
	}

	env->CallVoidMethod(javaRef, jniHelper.GetMethod(JMETHOD_PAUSE));
}

GaoVoid AndroidAudioResource::SetLoop(GaoBool looping) {

}

GaoVoid AndroidAudioResource::SetVolume(GaoReal32 volume) {

}

GaoBool AndroidAudioResource::IsPlaying() const {
	return FALSE;
}
