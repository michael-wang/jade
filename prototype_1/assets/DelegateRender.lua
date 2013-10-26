rect = nil;

g_RenderDelegate = function()
	if rect == nil then
		rect = Rectangle(-256, 255, 255, -256, 0.63671875, 0.76953125, 0.22265625, 1.0);
		rect:SetTexture(g_GraphicsEngine:CreateTexture("JadeNinja.png"));
	end

	g_GraphicsRenderer:Draw(rect);
end