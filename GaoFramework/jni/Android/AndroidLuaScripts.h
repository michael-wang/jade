/*
 * This file contains lua scripts in C/C++ char* form, 
 * for I don't know how to access file without using native activity (yet).
 */

#ifndef ANDROIDLUASCRIPT_H_
#define ANDROIDLUASCRIPT_H_

#include <lua.h>
#include <Framework/LuaFunction.hpp>
#include <Android/AndroidApplication.h>
 #include <Android/AndroidAudioRenderer.h>
 #include <Android/AndroidAudioResource.h>
#include <Android/AndroidGraphicsRenderer.h>
#include <Android/AndroidLogger.h>
#include <Android/GLTexture.h>
#include <Android/JavaInterface.h>
#include <Android/Rectangle.h>
#include <Android/TouchEvent.h>
#include <jni.h>

namespace AndroidLuaScripts {

static const char TAG[] = "native::framework::AndroidLuaScripts";

GaoVoid RegisterAndroidClasses(LuaState state) {
	__android_log_print(ANDROID_LOG_INFO, TAG, "RegisterAndroidClasses");
	using namespace luabind;

	module(state)
	[
		class_<JavaInterface>("JavaInterface")
			.def(constructor<>())
			.def("GetTouchEvents", &JavaInterface::GetTouchEvents)
	];

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
			.def("Draw", (void(AndroidGraphicsRenderer::*)(Rectangle*))&AndroidGraphicsRenderer::Draw)
	];

	module(state)
	[
		class_<Rectangle>("Rectangle")
			.def(constructor<>())
			.def(constructor<GaoReal32,GaoReal32,GaoReal32,GaoReal32,GaoReal32,GaoReal32,GaoReal32,GaoReal32>())
			.def("SetBound", &Rectangle::SetBound)
			.def("SetColor", &Rectangle::SetColor)
			.def("SetTexture", &Rectangle::SetTexture)
			.def("IsHit", &Rectangle::IsHit)
			.def("MoveTo", &Rectangle::MoveTo)
			.def("GetLeft", &Rectangle::GetLeft)
			.def("GetTop", &Rectangle::GetTop)
			.def("GetRight", &Rectangle::GetRight)
			.def("GetBottom", &Rectangle::GetBottom)
	];

	module(state)
	[
		class_<TouchEvent>("TouchEvent")
			.def("GetX", &TouchEvent::GetX)
			.def("GetY", &TouchEvent::GetY)
			.def("GetAction", &TouchEvent::GetAction)
			.def("IS_ACTION_DOWN", &TouchEvent::IS_ACTION_DOWN)
			.def("IS_ACTION_MOVE", &TouchEvent::IS_ACTION_MOVE)
			.def("IS_ACTION_UP", &TouchEvent::IS_ACTION_UP)
	];

	module(state)
	[
		class_<TouchEventArray>("TouchEventArray")
			.def(constructor<>())
			.def("GetSize",   &TouchEventArray::GetSize)
			.def("GetAt",     &TouchEventArray::GetAt)
			.def("RemoveAll", (void(TouchEventArray::*)())&TouchEventArray::RemoveAll)
	];

	module(state)
	[
		class_<AndroidAudioRenderer, Gao::Framework::AudioRenderer>("AndroidAudioRenderer")
			.def(constructor<>())
	];

	module(state)
	[
		class_<AndroidAudioResource, Gao::Framework::AudioResource>("AndroidAudioResource")
			.def(constructor<AudioType>())
	];
}

}

#endif // ANDROIDLUASCRIPT_H_