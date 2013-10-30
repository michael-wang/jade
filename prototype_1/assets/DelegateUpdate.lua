g_UpdateDelegate = function()
	if #g_TouchEventsPool > 0 then
		g_Logger:Show("native::lua::g_UpdateDelegate consume #touch:" .. #g_TouchEventsPool .. " touch events.");
		g_TouchEventsPool = {};
	end
end