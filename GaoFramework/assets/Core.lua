-- global variables
g_Logger = nil;
g_GraphicsRenderer = nil;
g_GraphicsEngine = nil;
-- delegate functions
g_UpdateDelegate = nil;
g_RenderDelegate = nil;

function OnInitialize()
    g_Logger = AndroidLogger();
    g_Logger:Create();
    g_GraphicsRenderer = AndroidGraphicsRenderer();
    g_GraphicsEngine = GraphicsEngine(g_GraphicsRenderer);
end

function OnSurfaceChanged(w, h)
    g_GraphicsRenderer:OnSurfaceChanged(w, h);
end

function OnUpdate()
	if g_UpdateDelegate ~=nil then
		g_UpdateDelegate();
	else
		g_Logger:Show('g_UpdateDelegate == nil');
	end
end

function OnRender()
    if g_RenderDelegate ~= nil then
        g_RenderDelegate();
    else
        g_Logger:Show('g_RenderDelegate is nil');
    end
end