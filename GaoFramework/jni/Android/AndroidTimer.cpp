#include "AndroidTimer.h"
#include <time.h>


AndroidTimer::AndroidTimer() :
	log ("native::framework::AndroidTimer", false) {
	LOGD(log, "Constructor");
}

AndroidTimer::~AndroidTimer() {
	LOGD(log, "Destructor");
}

GaoVoid AndroidTimer::Start() {
	LOGD(log, "Start");

	m_CurrentTime = GetElapsedTime();
	m_DeltaTime = 0;
	m_LastTime = m_CurrentTime;
}

GaoUInt32 AndroidTimer::GetElapsedTime() const {
	struct timespec result;
	clock_gettime(CLOCK_REALTIME, &result);
	LOGD(log, "GetElapsedTime sec:%ld, nano:%ld", result.tv_sec, result.tv_nsec)
	return result.tv_sec * 1000 + result.tv_nsec / 1000000;
}