-- Initialize logger before running Core.lua, so we can get error message when something goes wrong.
function init()
	g_Logger = LuaLogger();
	g_JavaInterface = JavaInterface();
	g_Logger:Create(g_JavaInterface:GetLogFilePath());
end