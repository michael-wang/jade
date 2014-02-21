/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class com_studioirregular_gaoframework_NativeInterface */

#ifndef _Included_com_studioirregular_gaoframework_NativeInterface
#define _Included_com_studioirregular_gaoframework_NativeInterface
#ifdef __cplusplus
extern "C" {
#endif

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    ProcessBackKey
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_com_studioirregular_gaoframework_NativeInterface_ProcessBackKey
  (JNIEnv *, jobject);

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyAlertDialogResult
 * Signature: (Z)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyAlertDialogResult
  (JNIEnv *, jobject, jboolean);

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyPlayMovieComplete
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyPlayMovieComplete
  (JNIEnv *, jobject);

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyBuyResult
 * Signature: (Ljava/lang/String;Z)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyBuyResult
  (JNIEnv *, jobject, jstring, jboolean);

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyPurchaseRestored
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyPurchaseRestored
  (JNIEnv *, jobject, jstring);

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifyUIPresented
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifyUIPresented
  (JNIEnv *, jobject);

/*
 * Class:     com_studioirregular_gaoframework_NativeInterface
 * Method:    NotifySendMailResult
 * Signature: (Z)V
 */
JNIEXPORT void JNICALL Java_com_studioirregular_gaoframework_NativeInterface_NotifySendMailResult
  (JNIEnv *, jobject, jboolean);

#ifdef __cplusplus
}
#endif
#endif
