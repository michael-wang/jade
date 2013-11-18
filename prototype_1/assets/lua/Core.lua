-- delegate functions
g_UpdateDelegate = nil;
g_RenderDelegate = nil;

-- global variables
g_JavaInterface = nil;
g_Logger = nil;
g_GraphicsRenderer = nil;
g_GraphicsEngine = nil;
g_AudioRenderer = nil;
g_AudioEngine = nil;

g_SurfaceWidth = 0;
g_SurfaceHeight = 0;

-- drawing objects
g_ObjectPool = {};
g_Dragging = {};
g_Dragging.object = nil;
g_Dragging.offsetX = 0; -- touch point relative to upper left of rect.
g_Dragging.offsetY = 0;

-- audio object
g_Sounds = {};
g_Music = {};

function OnInitialize()
    g_Logger = AndroidLogger();
    
    g_JavaInterface = JavaInterface();
    local logFilePath = g_JavaInterface:GetLogFilePath();

    g_Logger:Show(logFilePath);
    g_Logger:Create(logFilePath);
    
    g_GraphicsRenderer = AndroidGraphicsRenderer();
    g_GraphicsEngine = GraphicsEngine(g_GraphicsRenderer);
    g_AudioRenderer = AndroidAudioRenderer();
    g_AudioEngine = AudioEngine(g_AudioRenderer);

    g_Sounds["guest_01_sound_s1.wav"] = g_AudioEngine:CreateAudio(AudioEngine.AUDIO_NORMAL, "sound/guest_01_sound_s1.wav", true);
    g_Music["bgm_game.mp3"] = g_AudioEngine:CreateAudio(AudioEngine.AUDIO_STREAMING, "bgm_game.mp3", true);
    g_Music["bgm_game.mp3"]:Play();

    -- g_Logger:Show([[before dofile: "./GameData.lua"]]);
    -- local result = dofile("./GameData.lua");
    -- g_Logger:Show([[after dofile("GameData.lua"):]] .. result);
end

function OnSurfaceChanged(w, h)
    g_SurfaceWidth = w;
    g_SurfaceHeight = h;

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

function OnTouch(x, y, action)
    g_Logger:Show("native::lua::OnTouch x:" .. x .. ",y:" .. y .. ",action:" .. action);
    
    touch = {};
    touch["x"] = x;
    touch["y"] = y;
    touch["action"] = action;

    g_TouchEventsPool[#g_TouchEventsPool + 1] = touch;
end

function OnPause()
    g_Logger:Show("native::lua::OnPause");

    for k, v in pairs(g_Music) do
        g_AudioEngine:Pause(v);
    end
end

function OnResume()
    g_Logger:Show("native::lua::OnResume");

    for k, v in pairs(g_Music) do
        g_AudioEngine:Play(v);
    end
end

function OnTerminate()
    g_Logger:Show("native::lua::OnTerminate");

    for k, v in pairs(g_Music) do
        g_AudioEngine:Stop(v);
    end
end
