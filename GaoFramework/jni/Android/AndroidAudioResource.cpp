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
	jni (JAVA_CLASS_PATH) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "AndroidAudioResource type:%d", type);

	jobject obj = jni.NewObject(JAVA_METHOD_CONSTRUCTOR_DESC, type);

	if (obj != NULL) {

		javaRef = jni.NewGlobalRef(obj);
	}

	jni.CacheMethod(JMETHOD_CREATE, JAVA_METHOD_CREATE, JAVA_METHOD_CREATE_DESC);
	jni.CacheMethod(JMETHOD_PLAY,   JAVA_METHOD_PLAY,   JAVA_METHOD_PLAY_DESC);
	jni.CacheMethod(JMETHOD_PAUSE,  JAVA_METHOD_PAUSE,  JAVA_METHOD_PAUSE_DESC);
	jni.CacheMethod(JMETHOD_STOP,   JAVA_METHOD_STOP,   JAVA_METHOD_STOP_DESC);
}

AndroidAudioResource::~AndroidAudioResource() {
	if (javaRef != NULL) {

		jni.DeleteGlobalRef(javaRef);
	} else {
		// Show error msg;
	}
}

GaoBool AndroidAudioResource::Create(AudioType type, GaoString& fileName, GaoBool loop) {

	jstring jstrFileName = jni.NewStringUTF(fileName.c_str());
	if (jstrFileName == NULL) {
		return false;
	}

	return jni.CallBooleanMethod(javaRef, JMETHOD_CREATE, jstrFileName);
}

GaoVoid AndroidAudioResource::Play() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Play");

	jni.CallBooleanMethod(javaRef, JMETHOD_PLAY);
}

GaoVoid AndroidAudioResource::Stop() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Stop");

	jni.CallVoidMethod(javaRef, JMETHOD_STOP);
}

GaoVoid AndroidAudioResource::Pause() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Pause");

	jni.CallVoidMethod(javaRef, JMETHOD_PAUSE);
}

GaoVoid AndroidAudioResource::SetLoop(GaoBool looping) {

}

GaoVoid AndroidAudioResource::SetVolume(GaoReal32 volume) {

}

GaoBool AndroidAudioResource::IsPlaying() const {
	return FALSE;
}
