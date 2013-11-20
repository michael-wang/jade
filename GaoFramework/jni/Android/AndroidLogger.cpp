/*
 * AndroidLogger.cpp
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#include <Android/AndroidLogger.h>
#include <android/log.h>

AndroidLogger::AndroidLogger(GaoConstCharPtr TAG) :
	_TAG (TAG),
	_DO_LOG (TRUE) {
}

AndroidLogger::AndroidLogger(GaoConstCharPtr TAG, GaoBool DO_LOG) :
	_TAG (TAG),
	_DO_LOG (DO_LOG) {
}

AndroidLogger::~AndroidLogger() {
}
