sound_playing = false;
-- waiting for audio loading.
sound_delay = 0;
DELAY_IN_MS = 60; -- wait for 60 frames.

g_UpdateDelegate = function()

	-- generate rectangle object
	if #g_ObjectPool == 0 then
		g_ObjectPool[1] = Rectangle(-256, 255, 255, -256, 0.63671875, 0.76953125, 0.22265625, 1.0);
		g_ObjectPool[1]:SetTexture(g_GraphicsEngine:CreateTexture("image/JadeNinja.png"));
	end

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

	if sound_playing == false then
		sound_delay = sound_delay + 1;
		if sound_delay >= DELAY_IN_MS then
			g_AudioEngine:Play(g_Sounds["guest_01_sound_s1.wav"]);
			sound_playing = true;
		end
	end
	
	arrEvents = nil;
end

function process_touch(touch)

	if touch:IS_ACTION_DOWN() then

		detect_hit(touch:GetX(), touch:GetY());

	elseif touch:IS_ACTION_MOVE() then

		drag_object(touch:GetX(), touch:GetY());

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
			
			g_Dragging.object = rect;
			g_Dragging.offsetX = rect:GetLeft() - glX;
			g_Dragging.offsetY = rect:GetTop() - glY;

			g_Logger:Show("native::lua::g_UpdateDelegate HIT left:" .. rect:GetLeft() .. ",glX:" .. glX .. ",offsetX:" .. g_Dragging.offsetX);
		end
	end
end

function drag_object(x, y)

	if g_Dragging.object == nil then
		return;
	end

	local glX = x - (g_SurfaceWidth / 2);
	local glY = (g_SurfaceHeight / 2) - y;

	local newLeft = glX + g_Dragging.offsetX;
	local newTop = glY + g_Dragging.offsetY;
	g_Logger:Show("native::lua::g_UpdateDelegate drag_object left:" .. g_Dragging.object:GetLeft() .. ",glX:" .. glX .. ",newLeft:" .. newLeft);

	g_Dragging.object:MoveTo(newLeft, newTop);
end

function release_hit(x, y)

	if g_DraggingObject ~= nil then
		g_Logger:Show("native::lua::g_UpdateDelegate TOUCH UP on rectangle.");
		g_Dragging.object = nil;
	end
end