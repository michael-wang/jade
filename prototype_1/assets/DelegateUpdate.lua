g_UpdateDelegate = function()

	local arrEvents = g_JavaInterface:GetTouchEvents();
	local SIZE = arrEvents:GetSize();

	if SIZE > 0 then
		g_Logger:Show("native::lua::g_UpdateDelegate #events:" .. SIZE);

		for i = 0, (SIZE - 1) do
			local touch = arrEvents:GetAt(i);
			-- g_Logger:Show("native::lua::g_UpdateDelegate consume touch: x:" .. touch:GetX() .. 
			-- 	",y:" .. touch:GetY() .. ",action:" .. touch:GetAction());
		end
	end
	
	arrEvents = nil;
end