/*
 * AndroidLogger.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidLogger.h>
#include <android/log.h>

AndroidLogger::AndroidLogger() {
}

AndroidLogger::~AndroidLogger() {
}

GaoVoid AndroidLogger::Show(GaoConstCharPtr text) {
	__android_log_print(ANDROID_LOG_INFO, "gaoframework", text, NULL);
}