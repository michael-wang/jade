texture = nil;

g_RenderDelegate = function()
	if texture == nil then
		texture = g_GraphicsEngine:CreateTexture("JadeNinja.png");
	end

	g_GraphicsRenderer:DrawRectangle(-256, 255, 255, -256, 0.63671875, 0.76953125, 0.22265625, 1.0, texture);
end