#include "JavaObject.h"
#include "JniEnv.h"
#include <stdarg.h>

static const bool DO_LOG = false;

JavaObject::JavaObject(const char* classPath, const char* constructor, ...) :
	clazz (g_JniEnv->FindClass(classPath)),
	javaRef (NULL),
	log ("native::framework::JavaObject", DO_LOG) {
	
	LOGD(log, "%s[%p]: classPath:%s, constructor:%s", __func__, this, classPath, constructor)

	jmethodID ctor = NULL;
	if (clazz != NULL) {
		ctor = clazz->GetMethodID(JavaClass::CONSTRUCTOR_METHOD_NAME, constructor);
	} else {
		LOGE(log, "%s[%p]: cannot find class: %s", __func__, this, classPath)
	}

	if (ctor != NULL) {
		va_list args;
		va_start(args, constructor);
		jobject obj = g_JniEnv->NewObject(clazz, ctor, args);
		va_end(args);

		SetJavaRef(obj);

		// fix: local reference table overflow.
		g_JniEnv->DeleteLocalRef(obj);
	} else {
		LOGE(log, "%s[%p]: cannot find constructor with name:%s, descriptor:%s", 
			__func__, this, JavaClass::CONSTRUCTOR_METHOD_NAME, constructor)
	}
}

JavaObject::JavaObject(const char* classPath) :
	clazz (g_JniEnv->FindClass(classPath)),
	javaRef (NULL),
	log ("native::framework::JavaObject", DO_LOG) {

	LOGD(log, "%s[%p]: classPath:%s", __func__, this, classPath)
}

JavaObject::~JavaObject() {

	LOGW(log, "%s[%p]: path:%s, ref:%p", __func__, this, clazz->GetClassPath().c_str(), javaRef)

	SetJavaRef(NULL);
}

void JavaObject::SetJavaRef(jobject ref) {

	LOGD(log, "%s[%p]: ref:%p, old ref:%p", __func__, this, ref, javaRef)

	if (javaRef != NULL) {
		g_JniEnv->DeleteGlobalRef(javaRef);
	}

	if (ref != NULL) {
		javaRef = g_JniEnv->NewGlobalRef(ref);
	} else {
		javaRef = NULL;
	}
}

void JavaObject::CallVoidMethod(const char* name, const char* descriptor, ...) const {
	
	LOGD(log, "%s[%p]: name:%s, descriptor:%s", __func__, this, name, descriptor)

	if (javaRef == NULL) {
		LOGE(log, "%s: javaRef == NULL", __func__);
	}

	jmethodID method = clazz->GetMethodID(name, descriptor);
	if (method == NULL) {
		LOGE(log, "%s[%p]: cannot find method with name:%s, descriptor:%s", 
			__func__, this, name, descriptor)
		return;
	}

	va_list args;
	va_start(args, descriptor);
	g_JniEnv->CallVoidMethod(javaRef, method, args);
	va_end(args);
}

bool JavaObject::CallBooleanMethod(const char* name, const char* descriptor, ...) const {

	LOGD(log, "%s[%p]: name:%s, descriptor:%s", __func__, this, name, descriptor)

	if (javaRef == NULL) {
		LOGE(log, "%s[%p]: javaRef == NULL", __func__, this);
	}

	jmethodID method = clazz->GetMethodID(name, descriptor);
	if (method == NULL) {
		LOGE(log, "%s[%p]: cannot find method with name:%s, descriptor:%s", 
			__func__, this, name, descriptor)
		return false;
	}

	va_list args;
	va_start(args, descriptor);
	bool result = g_JniEnv->CallBooleanMethod(javaRef, method, args);
	va_end(args);

	return result;
}

jobject JavaObject::CallObjectMethod(const char* name, 
	const char* descriptor, ...) const {
	
	LOGD(log, "%s[%p]: name:%s, descriptor:%s", __func__, this, name, descriptor)

	if (javaRef == NULL) {
		LOGE(log, "%s[%p]: javaRef == NULL", __func__, this);
	}

	jmethodID method = clazz->GetMethodID(name, descriptor);
	if (method == NULL) {
		LOGE(log, "%s[%p]: cannot find method with name:%s, descriptor:%s", 
			__func__, this, name, descriptor)
		return NULL;
	}

	va_list args;
	va_start(args, descriptor);
	jobject result = g_JniEnv->CallObjectMethod(javaRef, method, args);
	va_end(args);

	return result;
}

jfloat JavaObject::CallFloatMethod(const char* name, const char* descriptor, ...) const {

	LOGD(log, "%s[%p]: name:%s, descriptor:%s", __func__, this, name, descriptor)

	if (javaRef == NULL) {
		LOGE(log, "%s[%p]: javaRef == NULL", __func__, this);
	}

	jmethodID method = clazz->GetMethodID(name, descriptor);
	if (method == NULL) {
		LOGE(log, "%s[%p]: cannot find method with name:%s, descriptor:%s", 
			__func__, this, name, descriptor)
		return NULL;
	}

	va_list args;
	va_start(args, descriptor);
	jfloat result = g_JniEnv->CallFloatMethod(javaRef, method, args);
	va_end(args);

	return result;
}