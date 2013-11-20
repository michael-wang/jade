#ifndef LUALOGGER_H_
#define LUALOGGER_H_

#include <Framework/Logger.hpp>
#include <android/log.h>


class LuaLogger : public Gao::Framework::Logger {

public:
	LuaLogger() {
	}

	virtual ~LuaLogger() {
	}

	virtual GaoVoid Show(GaoConstCharPtr text) {
		__android_log_print(ANDROID_LOG_DEBUG, "native::gaoframework", text, NULL);
	}
};

#endif /* LUALOGGER_H_ */