#include "GLTexture.h"
#include <Android/AndroidApplication.h>
#include <android/log.h>


static const char JAVA_CLASS_PATH[]				= "com/studioirregular/gaoframework/GLTexture";
static const char JAVA_INTERFACE_PATH[]			= "com/studioirregular/gaoframework/JavaInterface";
static const char JAVA_LOAD_TEXTURE_NAME[]		= "loadTexture";
static const char JAVA_LOAD_TEXTURE_DESCRIPTOR[]= "(Lcom/studioirregular/gaoframework/GLTexture;Ljava/lang/String;)Z";

GLTexture::GLTexture() :
	javaRef (NULL) {

	if (AndroidApplication::Singleton == NULL) {
		// Show error msg;
		return;
	}

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();

	jclass clazz = env->FindClass(JAVA_CLASS_PATH);
	if (clazz == NULL) {
		// Show error msg;
		return;
	}

	jmethodID ctor = env->GetMethodID(clazz, "<init>", "()V");
	if (ctor == NULL) {
		// Show error msg;
		return;
	}

	jobject obj = env->NewObject(clazz, ctor);
	javaRef = env->NewGlobalRef(obj); 
}

GLTexture::~GLTexture() {
	Unload();

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

GaoBool GLTexture::Create(GaoString& fileName) {
	__android_log_print(ANDROID_LOG_INFO, "GLTexture", "Create fileName:%s", fileName.c_str());

	if (AndroidApplication::Singleton == NULL) {
		// Show error msg;
		return FALSE;
	}

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();
	if (env == NULL) {
		// Show error msg;
		return FALSE;
	}

	jobject javaInterface = AndroidApplication::Singleton->GetJavaInterface();
	if (javaInterface == NULL) {
		// Show error msg;
		return FALSE;
	}

	jclass clazzJavaInterface = env->FindClass(JAVA_INTERFACE_PATH);
	if (clazzJavaInterface == NULL) {
		// Show error msg;
		return FALSE;
	}

	jmethodID loadTexture = env->GetMethodID(clazzJavaInterface, JAVA_LOAD_TEXTURE_NAME, JAVA_LOAD_TEXTURE_DESCRIPTOR);
	if (loadTexture == NULL) {
		// Show error msg;
		return FALSE;
	}

	jstring jfilename = env->NewStringUTF(fileName.c_str());
	jboolean success = env->CallBooleanMethod(javaInterface, loadTexture, javaRef, jfilename);

	return success;
}

GaoBool GLTexture::Reload() {
	return FALSE;
}

GaoVoid GLTexture::Unload() {
}
