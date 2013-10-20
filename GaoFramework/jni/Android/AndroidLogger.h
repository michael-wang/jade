/*
 * AndroidLogger.h
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#ifndef ANDROIDLOGGER_H_
#define ANDROIDLOGGER_H_

#include <Framework/Logger.hpp>


class AndroidLogger : public Gao::Framework::Logger {
public:
	AndroidLogger();
	virtual ~AndroidLogger();

	virtual GaoVoid Show(GaoConstCharPtr text);
};

#endif /* ANDROIDLOGGER_H_ */
