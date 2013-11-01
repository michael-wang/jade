#include "Rectangle.h"
#include <Android/AndroidApplication.h>
#include <android/log.h>

static const char JAVA_CLASS_PATH[]				= "com/studioirregular/gaoframework/Rectangle";
static const char JAVA_CONSTRUCTOR[]			= "(FFFFFFFF)V";
static const char JAVA_METHOD_SET_BOUND[]		= "setBound";
static const char JAVA_METHOD_SET_BOUND_DESC[]	= "(FFFF)V";
static const char JAVA_METHOD_SET_COLOR[]		= "setColor";
static const char JAVA_METHOD_SET_COLOR_DESC[]	= "(FFFF)V";
static const char JAVA_METHOD_SET_TEXTURE[]		= "setTexture";
static const char JAVA_METHOD_SET_TEXTURE_DESC[]= "(Lcom/studioirregular/gaoframework/GLTexture;)V";

static char TAG[] = "native::framework::Rectangle";

Rectangle::Rectangle() :
	javaRef (NULL),
	left (0),
	top (0),
	right (0),
	bottom (0) {

	init(0, 0, 0, 0, 0, 0, 0, 0);
}

Rectangle::Rectangle(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) :
	javaRef (NULL),
	left (left),
	top (top),
	right (right),
	bottom (bottom) {

	init(left, top, right, bottom, red, green, blue, alpha);
}

Rectangle::~Rectangle() {
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

void Rectangle::init(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {
	
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

	jobject obj = env->NewObject(clazz, ctor, left, top, right, bottom, red, green, blue, alpha);
	javaRef = env->NewGlobalRef(obj);
}

GaoVoid Rectangle::SetBound(GaoReal32 l, GaoReal32 t, GaoReal32 r, GaoReal32 b) {

	left = l;
	top = t;
	right = r;
	bottom = b;

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

	jmethodID setBound = env->GetMethodID(clazz, JAVA_METHOD_SET_BOUND, JAVA_METHOD_SET_BOUND_DESC);
	if (setBound == NULL) {
		// Show error msg;
		return;
	}

	env->CallVoidMethod(javaRef, setBound, l, t, r, b);
}

GaoVoid Rectangle::SetColor(GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {
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

	jmethodID setColor = env->GetMethodID(clazz, JAVA_METHOD_SET_COLOR, JAVA_METHOD_SET_COLOR_DESC);
	if (setColor == NULL) {
		// Show error msg;
		return;
	}

	env->CallVoidMethod(javaRef, setColor, red, green, blue, alpha);
}

GaoVoid Rectangle::SetTexture(Gao::Framework::Texture* texture) {
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

	jmethodID setTexture = env->GetMethodID(clazz, JAVA_METHOD_SET_TEXTURE, JAVA_METHOD_SET_TEXTURE_DESC);
	if (setTexture == NULL) {
		// Show error msg;
		return;
	}

	GLTexture* gltexture = dynamic_cast<GLTexture*>(texture);
	jobject javaGLTexture = gltexture->GetJavaReference();
	env->CallVoidMethod(javaRef, setTexture, javaGLTexture);
}

GaoBool Rectangle::IsHit(GaoReal32 x, GaoReal32 y) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"IsHit x:%f, y:%f, left:%f, top:%f, right:%f, bottom:%f", 
		x, y, left, top, right, bottom);
	
	return (left <= x) && (x <= right) && (bottom <= y) && (y <= top);
}
