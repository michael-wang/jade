g_UpdateDelegate = function()

	local arrEvents = g_JavaInterface:GetTouchEvents();
	local SIZE = arrEvents:GetSize();

	if SIZE > 0 then
		g_Logger:Show("native::lua::g_UpdateDelegate #events:" .. SIZE);

		for i = 0, (SIZE - 1) do
			local touch = arrEvents:GetAt(i);
			-- g_Logger:Show("native::lua::g_UpdateDelegate consume touch: x:" .. touch:GetX() .. 
			-- 	",y:" .. touch:GetY() .. ",action:" .. touch:GetAction());

			process_touch(touch);
		end
	end
	
	arrEvents = nil;
end

function process_touch(touch)

	if touch:IS_ACTION_DOWN() then

		detect_hit(touch:GetX(), touch:GetY());

	elseif touch:IS_ACTION_UP() then

		release_hit(touch:GetX(), touch:GetY());

	else
	end
end

function detect_hit(x, y)

	local glX = x - (g_SurfaceWidth / 2);
	local glY = (g_SurfaceHeight / 2) - y;

	for i = 1, #g_ObjectPool do
		local rect = g_ObjectPool[i];
		if rect:IsHit(glX, glY) then
			g_Logger:Show("native::lua::g_UpdateDelegate TOUCH DOWN on rectangle.");
			g_DraggingObject = rect;
		end
	end
end

function release_hit(x, y)
	
	if g_DraggingObject ~= nil then
		g_Logger:Show("native::lua::g_UpdateDelegate TOUCH UP on rectangle.");
		g_DraggingObject = nil;
	end
end