g_RenderDelegate = function()
	for i = 1, #g_ObjectPool do
		g_GraphicsRenderer:Draw(g_ObjectPool[i]);
	end
end