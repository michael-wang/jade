g_RenderDelegate = function()
	if #g_ObjectPool == 0 then
		g_ObjectPool[1] = Rectangle(-256, 255, 255, -256, 0.63671875, 0.76953125, 0.22265625, 1.0);
		g_ObjectPool[1]:SetTexture(g_GraphicsEngine:CreateTexture("JadeNinja.png"));
	end

	for i = 1, #g_ObjectPool do
		g_GraphicsRenderer:Draw(g_ObjectPool[i]);
	end
end