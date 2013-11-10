#include "AndroidAudioResource.h"
#include "AndroidApplication.h"
#include "Java/JniEnv.h"

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
	jobj (JAVA_CLASS_PATH, JAVA_METHOD_CONSTRUCTOR_DESC, type) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "AndroidAudioResource type:%d", type);
}

AndroidAudioResource::~AndroidAudioResource() {
}

GaoBool AndroidAudioResource::Create(AudioType type, GaoString& fileName, GaoBool loop) {

	jstring jstrFileName = g_JniEnv->NewStringUTF(fileName.c_str());
	if (jstrFileName == NULL) {
		return false;
	}

	return jobj.CallBooleanMethod(JAVA_METHOD_CREATE, JAVA_METHOD_CREATE_DESC, jstrFileName, loop);
}

GaoVoid AndroidAudioResource::Play() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Play");

	jobj.CallBooleanMethod(JAVA_METHOD_PLAY, JAVA_METHOD_PLAY_DESC);
}

GaoVoid AndroidAudioResource::Stop() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Stop");

	jobj.CallVoidMethod(JAVA_METHOD_STOP, JAVA_METHOD_STOP_DESC);
}

GaoVoid AndroidAudioResource::Pause() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Pause");

	jobj.CallVoidMethod(JAVA_METHOD_PAUSE, JAVA_METHOD_PAUSE_DESC);
}

GaoVoid AndroidAudioResource::SetLoop(GaoBool looping) {

}

GaoVoid AndroidAudioResource::SetVolume(GaoReal32 volume) {

}

GaoBool AndroidAudioResource::IsPlaying() const {
	return FALSE;
}
