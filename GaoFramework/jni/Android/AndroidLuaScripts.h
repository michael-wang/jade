/*
 * This file contains lua scripts in C/C++ char* form, 
 * for I don't know how to access file without using native activity (yet).
 */

#ifndef ANDROIDLUASCRIPT_H_
#define ANDROIDLUASCRIPT_H_

#include <lua.h>
#include <Framework/LuaFunction.hpp>
#include <Android/AndroidGraphicsRenderer.h>
#include <Android/GLTexture.h>
#include <Android/AndroidLogger.h>

namespace AndroidLuaScripts {

GaoVoid RegisterAndroidClasses(LuaState state) {
	__android_log_print(ANDROID_LOG_INFO, "AndroidApplication", "RegisterAndroidClasses");
	using namespace luabind;

	module(state)
	[
		class_<AndroidLogger, Gao::Framework::Logger>("AndroidLogger")
			.def(constructor<>())
	];

	module(state)
	[
		class_<GLTexture, Gao::Framework::Texture>("GLTexture")
			.def(constructor<>())
	];

	module(state)
	[
		class_<AndroidGraphicsRenderer, Gao::Framework::GraphicsRenderer>("AndroidGraphicsRenderer")
			.def(constructor<>())
			.def("OnSurfaceChanged", &AndroidGraphicsRenderer::OnSurfaceChanged)
			.def("DrawRectangle", &AndroidGraphicsRenderer::DrawRectangle)
	];

}

}

#endif // ANDROIDLUASCRIPT_H_