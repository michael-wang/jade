/*
 * This file contains lua scripts in C/C++ char* form, 
 * for I don't know how to access file without using native activity (yet).
 */

#ifndef ANDROIDLUASCRIPT_H_
#define ANDROIDLUASCRIPT_H_

#include <lua.h>
#include <Framework/LuaFunction.hpp>
#include "AndroidGraphicsRenderer.h"
#include "AndroidLogger.h"

namespace AndroidLuaScripts {

const char CORE[] = 
"-- global variables\n \
g_Logger = nil;\n \
g_GraphicsRenderer = nil;\n \
g_GraphicsEngine = nil;\n \
g_UpdateDelegate = nil;\n \
g_RenderDelegate = nil;\n \
\n \
function OnInitialize()\n \
    g_Logger = AndroidLogger();\n \
    g_Logger:Create();\n \
    g_GraphicsRenderer = AndroidGraphicsRenderer();\n \
    g_GraphicsEngine = GraphicsEngine(g_GraphicsRenderer);\n \
end\n \
\n \
function OnSurfaceChanged(w, h)\n \
    g_GraphicsRenderer:OnSurfaceChanged(w, h);\n \
end\n \
function OnUpdate()\n \
	if g_UpdateDelegate ~=nil then\n \
		g_UpdateDelegate();\n \
	else\n \
		g_Logger:Show('g_UpdateDelegate == nil');\n \
	end\n \
end\n \
\n \
function OnRender()\n \
    if g_RenderDelegate == nil then\n \
    	g_Logger:Show('g_RenderDelegate is nil');\n \
    elseif type(g_RenderDelegate) ~= 'function' then\n \
    	g_Logger:Show(g_RenderDelegate);\n \
    else\n \
    	g_Logger:Show(type(g_RenderDelegate));\n \
    	g_RenderDelegate();\n \
    end\n \
end\n \
";

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
		class_<AndroidGraphicsRenderer, Gao::Framework::GraphicsRenderer>("AndroidGraphicsRenderer")
			.def(constructor<>())
			.def("OnSurfaceChanged", &AndroidGraphicsRenderer::OnSurfaceChanged)
	];

}

}

#endif // ANDROIDLUASCRIPT_H_