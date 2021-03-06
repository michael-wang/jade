/*
 * This file contains lua scripts in C/C++ char* form, 
 * for I don't know how to access file without using native activity (yet).
 */

#ifndef ANDROIDLUASCRIPT_H_
#define ANDROIDLUASCRIPT_H_

#include <lua.h>
#include <Framework/LuaFunction.hpp>
#include <Android/AndroidAudioRenderer.h>
#include <Android/AndroidAudioResource.h>
#include <Android/AndroidFileSystem.h>
#include <Android/AndroidGraphicsRenderer.h>
#include <Android/AndroidLuaManagerWrapper.h>
#include <Android/AndroidSprite.h>
#include <Android/AndroidTimer.h>
#include <Android/AndroidTransform.h>
#include <Android/GLTexture.h>
#include <Android/GlyphFontRenderer.h>
#include <Android/JavaInterface.h>
#include <Android/LuaLogger.h>
#include <Android/TouchEvent.h>
#include <jni.h>

namespace AndroidLuaScripts {

GaoVoid RegisterAndroidClasses(LuaState state) {
	AndroidLogger log ("native::framework::AndroidLuaScripts", false);
	LOGD(log, "RegisterAndroidClasses")
	
	using namespace luabind;

	module(state)
	[
		class_<AndroidLuaManagerWrapper>("AndroidLuaManagerWrapper")
			.def(constructor<>())
			.def("RunFromAsset", &AndroidLuaManagerWrapper::RunFromAsset)
			.def("RunFromFullPathFile", &AndroidLuaManagerWrapper::RunFromFullPathFile)
	];

	module(state)
	[
		class_<JavaInterface>("JavaInterface")
			.def(constructor<>())
			.def("OnNativeInitializeDone", &JavaInterface::OnNativeInitializeDone)
			.def("GetTouchEvents", &JavaInterface::GetTouchEvents)
			.def("GetLogFilePath", &JavaInterface::GetLogFilePath)
	];

    module(state, "GaoApp")
    [
        def("MakeDocumentPath", &AndroidFileSystem::MakeDocumentPath)
    ];

	module(state)
	[
		class_<LuaLogger, Gao::Framework::Logger>("LuaLogger")
			.def(constructor<>())
	];

	module(state)
	[
		class_<AndroidTimer, Gao::Framework::Timer>("AndroidTimer")
			.def(constructor<>())
			.def("Start", &AndroidTimer::Start)
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

	module(state)
	[
		class_<AndroidSprite, Gao::Framework::Sprite>("AndroidSprite")
			.def(constructor<>())
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

	module(state)
	[
		class_<AndroidTransform, Gao::Framework::Transform>("AndroidTransform")
			.def(constructor<>())
	];

	module(state)
	[
		class_<GlyphFontRenderer>("GlyphFontRenderer")
			.def(constructor<>())
			.def("Create", &GlyphFontRenderer::Create)
			.def("Draw", &GlyphFontRenderer::Draw)
	];
}

}

#endif // ANDROIDLUASCRIPT_H_