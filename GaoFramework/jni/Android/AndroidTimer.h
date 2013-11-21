#ifndef _ANDROIDTIMER_H_
#define _ANDROIDTIMER_H_

#include <Framework/Timer.hpp>
#include "AndroidLogger.h"


class AndroidTimer : public Gao::Framework::Timer {
	
public:
	AndroidTimer();

	virtual ~AndroidTimer();

	virtual GaoVoid Start();

	virtual GaoUInt32 GetElapsedTime() const;

private:
	AndroidLogger log;
};

#endif /* _ANDROIDTIMER_H_ */