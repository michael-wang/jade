#include "AndroidAudioResource.h"
#include "AndroidApplication.h"

static const char JAVA_CLASS_PATH[]				= "com/studioirregular/gaoframework/AudioResource";
static const char JAVA_CONSTRUCTOR[]			= "()V";
static const char JAVA_METHOD_CREATE[]			= "Create";
static const char JAVA_METHOD_CREATE_DESC[]		= "(Ljava/lang/String;Z)Z";
static const char JAVA_METHOD_PLAY[]			= "Play";
static const char JAVA_METHOD_PLAY_DESC[]		= "()Z";


AndroidAudioResource::AndroidAudioResource() {
	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();

	jclass clazz = env->FindClass(JAVA_CLASS_PATH);
	if (clazz == NULL) {
		// Show error msg;
		return;
	}

	jmethodID ctor = env->GetMethodID(clazz, "<init>", JAVA_CONSTRUCTOR);
	if (ctor == NULL) {
		// Show error msg;
		return;
	}

	jobject obj = env->NewObject(clazz, ctor);
	javaRef = env->NewGlobalRef(obj);
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

	jclass clazz = env->FindClass(JAVA_CLASS_PATH);
	if (clazz == NULL) {
		// Show error msg;
		return FALSE;
	}

	jmethodID create = env->GetMethodID(clazz, JAVA_METHOD_CREATE, JAVA_METHOD_CREATE_DESC);
	if (create == NULL) {
		// Show error msg;
		return FALSE;
	}

	jstring jstrFileName = env->NewStringUTF(fileName.c_str());

	return env->CallBooleanMethod(javaRef, create, jstrFileName);
}

GaoVoid AndroidAudioResource::Play() {
	if (AndroidApplication::Singleton == NULL) {
		// Show error msg;
		return;
	}

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();
	if (env == NULL) {
		// Show error msg;
		return;
	}

	jclass clazz = env->FindClass(JAVA_CLASS_PATH);
	if (clazz == NULL) {
		// Show error msg;
		return;
	}

	jmethodID play = env->GetMethodID(clazz, JAVA_METHOD_PLAY, JAVA_METHOD_PLAY_DESC);
	if (play == NULL) {
		// Show error msg;
		return;
	}

	jboolean success = env->CallBooleanMethod(javaRef, play);
}

GaoVoid AndroidAudioResource::Stop() {

}

GaoVoid AndroidAudioResource::Pause() {

}

GaoVoid AndroidAudioResource::SetLoop(GaoBool looping) {

}

GaoVoid AndroidAudioResource::SetVolume(GaoReal32 volume) {

}

GaoBool AndroidAudioResource::IsPlaying() const {
	return FALSE;
}
