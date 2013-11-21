/*
 * AndroidLogger.h
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#ifndef ANDROIDLOGGER_H_
#define ANDROIDLOGGER_H_

#include <Framework/DataType.hpp>
#include <android/log.h>


#define LOGD(logger, ...) if (logger.DO_LOG()) {__android_log_print(ANDROID_LOG_DEBUG, logger.TAG(), __VA_ARGS__);}
#define LOGW(logger, ...) if (logger.DO_LOG()) {__android_log_print(ANDROID_LOG_WARN,  logger.TAG(), __VA_ARGS__);}
#define LOGE(logger, ...) if (logger.DO_LOG()) {__android_log_print(ANDROID_LOG_ERROR, logger.TAG(), __VA_ARGS__);}

class AndroidLogger {
public:
	AndroidLogger(GaoConstCharPtr TAG);
	AndroidLogger(GaoConstCharPtr TAG, GaoBool DO_LOG);
	virtual ~AndroidLogger();

	GaoConstCharPtr TAG() const {
		return _TAG;
	}

	GaoBool DO_LOG() const {
		return _DO_LOG;
	}

protected:
	GaoConstCharPtr _TAG;
	GaoBool _DO_LOG;
};

#endif /* ANDROIDLOGGER_H_ */
