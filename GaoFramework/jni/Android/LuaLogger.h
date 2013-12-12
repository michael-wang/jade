#ifndef LUALOGGER_H_
#define LUALOGGER_H_

#include <Framework/Logger.hpp>
#include <android/log.h>
#include "AndroidLogger.h"


class LuaLogger : public Gao::Framework::Logger {

public:
	LuaLogger() :
		log ("native::framework::LuaLogger", true) {
		LOGD(log, "Constructor")
	}

	virtual ~LuaLogger() {
		LOGD(log, "Destructor")
	}

	/* 
	 * Prevent using FileSystem's MakeFullPath (append resource root path).
	 * On Android, resource path usually does not easy to access, 
	 * but in logger's case, we should make it easily accessible.
	 * So I request user to pass full log file path here.
	 */
	virtual GaoBool Create(GaoString& fileFullPath) {
		LOGD(log, "Create: %s", fileFullPath.c_str())

		m_FileName = fileFullPath;

		// Overwrite the original file
		FILE* file = fopen(m_FileName.c_str(), "wt");

		if (file != NULL)
		{
			fclose(file);
			return TRUE;
		}

		return FALSE;
	}

	virtual GaoVoid Show(GaoConstCharPtr text) {
		__android_log_print(ANDROID_LOG_DEBUG, "native::gaoframework", text, NULL);
	}

private:
	AndroidLogger log;
};

#endif /* LUALOGGER_H_ */