-- Initialize logger before running Core.lua, so we can get error message when something goes wrong.
g_Logger = LuaLogger();
g_JavaInterface = JavaInterface();
g_Logger:Create(g_JavaInterface:GetLogFilePath());