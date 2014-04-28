--***********************************************************************
-- @file Core.lua
--***********************************************************************

--=======================================================================
-- Constants
--=======================================================================
--APP_DEFAULT_TITLE = "Gao Framework";
--APP_DEFAULT_WIDTH = 320;
--APP_DEFAULT_HEIGHT = 480;
--APP_DEFAULT_DEPTH = 32;
--APP_DEFAULT_FULLSCREEN = false;
--APP_DEFAULT_OPENGL = false;

-- SCRIPT_DEFAULT_PATH = "../../Source/LuaScript/";
SCRIPT_DEFAULT_EXT = ".lua";

-- For platform dependent code.
IS_PLATFORM_ANDROID = false;

ASSET_PATH_IMAGE = "./Data/";
ASSET_PATH_FONT = "../../Asset/";
ASSET_PATH_SOUND = "./Data/Script/";

GAME_CORE_FILE = "GameCore"

PREBUILD_FUNC_SCRIPT_NAME = "soul.essence";
PREBUILD_DATA_SCRIPT_NAME = "love.essence";

APP_DEVICE_IPHONE = 1;
APP_DEVICE_IPHONE_RETINA = 2;
APP_DEVICE_IPHONE_TALLER = 3;
APP_DEVICE_IPAD = 4;
APP_DEVICE_IPAD_RETINA = 5;
APP_DEVICE_ANDROID_PHONE = 0x100;
APP_DEVICE_ANDROID_TABLET = 0x200;

PLAIN_DEVICE_SCRIPT_POOL =
{
	[APP_DEVICE_IPHONE] = { "GamePuzzleImg", },
	[APP_DEVICE_IPHONE_RETINA] = { "GamePuzzleImg", },
	[APP_DEVICE_IPHONE_TALLER] = { "GamePuzzleImg_iPhone5", },
	[APP_DEVICE_IPAD] = { "GamePuzzleImg_iPad", },
	[APP_DEVICE_IPAD_RETINA] = { "GamePuzzleImg_iPad", },
	[APP_DEVICE_ANDROID_PHONE] = { "GamePuzzleImg", },
	[APP_DEVICE_ANDROID_TABLET] = { "GamePuzzleImg_iPad", },
};

PREBUILD_DEVICE_SCRIPT_POOL =
{
	[APP_DEVICE_IPHONE] = "iphone.bottle",
	[APP_DEVICE_IPHONE_RETINA] = "iphone.bottle",
	[APP_DEVICE_IPHONE_TALLER] = "iphone5.bottle",
	[APP_DEVICE_IPAD] = "ipad.bottle",
	[APP_DEVICE_IPAD_RETINA] = "ipad.bottle",
};

APP_TESTER_BUILD = false; -- turn off on official release.
APP_DEBUG_MODE = false;
APP_USE_COMPILED_SCRIPT = false;
APP_ASSET_PATH = nil;
APP_LUA_PATH = nil;
APP_IPOD_PLAYING = false;

APP_BASE_X = 320;
APP_BASE_Y = 480;
APP_UNIT_X = 1.0;
APP_UNIT_Y = 1.0;
APP_SCALE_FACTOR = 1;
IS_DEVICE_IPAD = false;



--=======================================================================
-- Script file lists
-- (NOTE: The list will be and *must* be loaded in order)
--=======================================================================

CORE_SCRIPT_FILES =
{
	-- Utility
	"Utility",

	-- Factories/Managers
	"ObjectFactory",
	"StageManager",
	"TaskManager",
    "RoutineManager",
	"PoolManager",

	-- Components
	"ObjectComponent",
	"PuzzleComponent",
	"StateMachineComponent",

	-- UI
	"UIManager",
	"UIPuzzleWidget",
	
	-- IO
    "IOManager",
};

--=======================================================================
-- Globals
--=======================================================================

--g_Logger = nil;
g_Window = nil;
g_GraphicsRenderer = nil;
g_GraphicsEngine = nil;
g_AudioRenderer = nil;
g_AudioEngine = nil;
g_Timer = nil;
g_AppData = nil;
g_AppIsRunning = false;
g_LuaManager = nil;



--=======================================================================
-- Core routines (Android)
--=======================================================================

-------------------------------------------------------------------------
function InitializeLuaAndroid(worldWidth, worldHeight, luaScriptPath, debugMode)

	IS_PLATFORM_ANDROID = true;
	APP_ASSET_PATH = "";
	APP_LUA_PATH = luaScriptPath;
	g_LuaManager = AndroidLuaManagerWrapper();
	APP_DEBUG_MODE = debugMode;

	if APP_DEBUG_MODE then
		g_Logger:Show("InitializeLuaAndroid w:" .. worldWidth .. ",h:" .. worldHeight .. ",luaScriptPath:" .. luaScriptPath .. ",debugMode:" .. tostring(debugMode));
	end

	local portrait = (worldWidth < worldHeight);
	local orientation = portrait and 0 or 1;

	local unitX = 1.0;
	local unitY = 1.0;

	if (portrait) then
		unitX = worldWidth / APP_BASE_X;
		unitY = worldHeight / APP_BASE_Y;
	else
		unitX = worldWidth / APP_BASE_Y;
		unitY = worldHeight / APP_BASE_X;
	end
	
	if APP_DEBUG_MODE then
		g_Logger:Show("InitializeLuaAndroid unitX:" .. unitX .. ",unitY:" .. unitY);
	end

	local deviceType = APP_DEVICE_ANDROID_PHONE;
	if (worldWidth > (portrait and APP_BASE_X or APP_BASE_Y)) then
		deviceType = APP_DEVICE_ANDROID_TABLET;
	end

	local result = InitializeLuaIphone(deviceType, worldWidth, worldHeight, orientation, 
		unitX, unitY, true);

	-- Notify java about init done, they got some chore to be done.
	g_JavaInterface:OnNativeInitializeDone();

	return result;
end

--=======================================================================
-- Core routines (iPhone)
--=======================================================================

-------------------------------------------------------------------------
function InitializeLuaIphone(device, width, height, orientation, unitX, unitY, useCompiledScript)
    assert(device);
	assert(width);
	assert(height);
    assert(orientation);
    assert(unitX);
    assert(unitY);

	APP_DEVICE = device;
	SCREEN_UNIT_X = width;
	SCREEN_UNIT_Y = height;
	APP_UNIT_X = unitX;
	APP_UNIT_Y = unitY;

	if ((APP_DEVICE == APP_DEVICE_IPAD) or (APP_DEVICE == APP_DEVICE_IPAD_RETINA)) then
		IS_DEVICE_IPAD = true;
	    APP_SCALE_FACTOR = 2;
	elseif (IS_PLATFORM_ANDROID) then
		if (orientation == 0) then
			APP_SCALE_FACTOR = width / APP_BASE_X;
		else
			APP_SCALE_FACTOR = width / APP_BASE_Y;
		end
	end

	if (orientation == 0) then  -- Portrait mode
		APP_WIDTH = APP_BASE_X;
		APP_HEIGHT = APP_BASE_Y;
	else						-- Landscape mode
		APP_WIDTH = APP_BASE_Y;
		APP_HEIGHT = APP_BASE_X;
	end
	
	PLAIN_DEVICE_SCRIPT_LIST = PLAIN_DEVICE_SCRIPT_POOL[device];
	assert(PLAIN_DEVICE_SCRIPT_LIST);
	if not IS_PLATFORM_ANDROID then
		PREBUILD_DEVICE_SCRIPT_NAME = PREBUILD_DEVICE_SCRIPT_POOL[device];
		assert(PREBUILD_DEVICE_SCRIPT_NAME);
	end

	if (useCompiledScript) then
		APP_USE_COMPILED_SCRIPT = true;
	end
    
    if (not IS_PLATFORM_ANDROID) then
    	APP_ASSET_PATH = GaoApp.GetRootPath();
    	assert(APP_ASSET_PATH);
    	APP_LUA_PATH = APP_ASSET_PATH;
    end

    -- Pre-initialize
	local preInitResult = PreInitialize();
    assert(preInitResult, "App PreInitialize Failed");
	
	-- NOTE: Only plain scripts need to load CORE SCRIPTS
	-- NOTE: Must called before InitializeAppData()
	if (not APP_USE_COMPILED_SCRIPT) then
		LoadScriptList(CORE_SCRIPT_FILES, SCRIPT_CORE_PATH);
	end

    -- Initialize app data
    InitializeAppData();
    
    -- Load game scripts
	if (APP_USE_COMPILED_SCRIPT) then
		if IS_PLATFORM_ANDROID then
			LoadPrecompiledScript(PREBUILD_FUNC_SCRIPT_NAME, APP_LUA_PATH);

	        InitializeAppDataDelegate();
			
			LoadPrecompiledScript(PREBUILD_DATA_SCRIPT_NAME, APP_LUA_PATH);
		else
			dofile(string.format("%s/%s", APP_LUA_PATH, PREBUILD_DEVICE_SCRIPT_NAME));
			dofile(string.format("%s/%s", APP_LUA_PATH, PREBUILD_FUNC_SCRIPT_NAME));

	        InitializeAppDataDelegate();
			
			dofile(string.format("%s/%s", APP_LUA_PATH, PREBUILD_DATA_SCRIPT_NAME));
		end
    else
		-- NOTE: Must called before other scripts
        LoadScript(GAME_CORE_FILE, SCRIPT_FUNC_PATH);
		LoadScriptList(PLAIN_DEVICE_SCRIPT_LIST, SCRIPT_DATA_PATH);

        InitializeAppDataDelegate();
        
        LoadScriptList(GAME_FUNC_FILES, SCRIPT_FUNC_PATH);
        LoadScriptList(GAME_DATA_FILES, SCRIPT_DATA_PATH);
	end
    
    -- Post-initialize
    return PostInitialize();
end

-------------------------------------------------------------------------
function PreInitialize()
	-- Create Logger
	if (not IS_PLATFORM_ANDROID) then
	    g_Logger = EaglLogger();
		g_Logger:Create();
	else
		-- Run init_logger.lua before Core.lua
		-- For Android I create logger before Core.lua, so we can log Core.lua error.
	end

    -- Create Window
	g_Window = Window();
    
	-- Initialize config
	if (IS_PLATFORM_ANDROID) then
		InitializeConfigAndroid();
	else
		InitializeConfigIphone();
	end

	-- Create GraphicsRenderer & GraphicsEngine
	if (IS_PLATFORM_ANDROID) then
		g_GraphicsRenderer = AndroidGraphicsRenderer();
		g_GraphicsEngine = GraphicsEngine(g_GraphicsRenderer);
		g_GraphicsEngine:SetBasePath(IMAGE_PATH, FONT_PATH);
	else
		g_GraphicsRenderer = EaglGraphicsRenderer(APP_WIDTH, APP_HEIGHT);
		g_GraphicsEngine = GraphicsEngine(g_GraphicsRenderer);
		g_GraphicsEngine:SetBasePath(IMAGE_PATH, FONT_PATH);
	end

	-- Create AudioRenderer & AudioEngine
	if (IS_PLATFORM_ANDROID) then
	    g_AudioRenderer = AndroidAudioRenderer();
		g_AudioEngine = AudioEngine(g_AudioRenderer);
		g_AudioEngine:SetBasePath(AUDIO_PATH, AUDIO_PATH);
	else
	    g_AudioRenderer = EaglOalAudioRenderer();
		g_AudioEngine = AudioEngine(g_AudioRenderer);
		g_AudioEngine:SetBasePath(AUDIO_PATH, AUDIO_PATH);
	end

    g_AudioEngine:SetGlobalVolumes(AudioEngine.AUDIO_NORMAL, 1.0);
	g_AudioEngine:SetGlobalVolumes(AudioEngine.AUDIO_STREAMING, 1.0);
    
	--g_AudioRenderer:CreateMicrophone();
	if (not IS_PLATFORM_ANDROID) then
    	APP_IPOD_PLAYING = g_AudioRenderer:IsIpodPlaying();
    end

    -- Create GlyphFontRenderer
	-- NOTE: Must be called after InitializeConfigIphone()
	if (APP_DEBUG_MODE) then
		g_FontRenderer = GlyphFontRenderer();
		if IS_PLATFORM_ANDROID then
			g_FontRenderer:Create(APP_ASSET_PATH .. "/Asset/Font/Font.FontInfo", g_GraphicsEngine:CreateSprite("font.png"));
		else
			g_FontRenderer:Create(APP_ASSET_PATH .. "/Asset/Font/Font.FontInfo", g_GraphicsEngine:CreateSprite("Font.png"));
		end
		log("FontRenderer creation done")
	else
		log = function() end
		logp = function() end
	end
    
    -- Create Timer
    if (IS_PLATFORM_ANDROID) then
    	g_Timer = AndroidTimer();
    else
    	g_Timer = EaglTimer();
    end
    g_Timer:Start();

	return true;
end

-------------------------------------------------------------------------
function PostInitialize()
    ShowMemoryUsage("Core");

	if (InitializeDelegate() ~= false) then        
		g_AppIsRunning = true;
	else
		g_AppIsRunning = false;
	end

    local seed = os.time();
    math.randomseed(seed);
    g_AppData:SetData("RandomSeed", seed);
    --log("RandomSeed: " .. seed);
    
    ShowMemoryUsage("Game");
    
    if (g_AppData:GetData("MWDebug")) then
        InitializeMWCounter();
    end

    if (g_AppData:GetData("FTDebug")) then
        InitializeFTCounter();
    end
		
	return g_AppIsRunning;
end

-------------------------------------------------------------------------
function InitializeConfigIphone()
	-- Determine app configuration
	if (g_Window:GetAppConfig() ~= Window.CONFIG_DEBUG) then
		APP_DEBUG_MODE = false;
	end

	-- Setup paths
	local rootPath = "/Asset/";
	
	SCRIPT_PATH = APP_ASSET_PATH .. "/LuaScript/";
	SCRIPT_CORE_PATH = SCRIPT_PATH .. "Core/";
	SCRIPT_FUNC_PATH = SCRIPT_PATH .. "GameFunc/";
	SCRIPT_DATA_PATH = SCRIPT_PATH .. "GameData/";

	IMAGE_PATH = rootPath .. ASSET_PATH_IMAGE;
	FONT_PATH = rootPath .. ASSET_PATH_FONT;
	AUDIO_PATH = rootPath .. ASSET_PATH_SOUND;
	SCRIPT_FILE_EXT = SCRIPT_DEFAULT_EXT;
end

-------------------------------------------------------------------------
function InitializeConfigAndroid()
	
	SCRIPT_CORE_PATH = APP_LUA_PATH .. "Core/";
	SCRIPT_FUNC_PATH = APP_LUA_PATH .. "GameFunc/";
	SCRIPT_DATA_PATH = APP_LUA_PATH .. "GameData/";

	IMAGE_PATH = "";
	FONT_PATH = "";
	AUDIO_PATH = "";
	SCRIPT_FILE_EXT = SCRIPT_DEFAULT_EXT;
end

-------------------------------------------------------------------------
function InitializeAppData()
    g_AppData = DataManager:Create();

	if (APP_NAME ~= nil and APP_VERSION ~= nil) then
		APP_TITLE = string.format("%s  v%s", APP_NAME, APP_VERSION);
        g_AppData:SetData("Title", APP_TITLE);
		g_Window:SetTitle(APP_TITLE);
	end
    
    g_AppData:SetData("Width", APP_WIDTH);
    g_AppData:SetData("Height", APP_HEIGHT);
    g_AppData:SetData("UnitX", APP_UNIT_X);
    g_AppData:SetData("UnitY", APP_UNIT_Y);
    
    g_AppData:SetData("UseCompiledScript", APP_USE_COMPILED_SCRIPT);
    g_AppData:SetData("DebugMode", APP_DEBUG_MODE);
    g_AppData:SetData("ResourcePath", APP_ASSET_PATH);
    g_AppData:SetData("IsIpodPlaying", APP_IPOD_PLAYING);

    g_AppData:SetData("WorldTranslateX", 0);
    g_AppData:SetData("WorldTranslateY", 0);

    --g_AppData:Dump();
end

-------------------------------------------------------------------------
function TerminateLuaIphone()
end

-------------------------------------------------------------------------
function Terminate()
	return TerminateDelegate();
end

-------------------------------------------------------------------------
function UpdateMain()
	g_Timer:Update();

	if IS_PLATFORM_ANDROID then

		-- For touch events
	    local arrEvents = g_JavaInterface:GetTouchEvents();
	    local SIZE = arrEvents:GetSize();
	    if SIZE > 0 then
	        for i = 0, (SIZE - 1) do
	            local touch = arrEvents:GetAt(i);
	            ProcessTouch(touch);
	        end
	    end
	end

	UpdateDelegate();
end

-------------------------------------------------------------------------
function RenderMain()
	RenderDelegate();
end

-------------------------------------------------------------------------
function MainLoopIphone()
	g_Timer:Update();

	UpdateDelegate();
	RenderDelegate();
end

-------------------------------------------------------------------------
function MainLoopIphoneFTDebug()
	g_Timer:Update();

	UpdateDelegate();
	RenderDelegate();

    g_LastFTUpdateTime = g_LastFTUpdateTime + g_Timer:GetDeltaTime();    
    if (g_LastFTUpdateTime > 1000) then
        g_FTCounter = g_Timer:GetDeltaTime();
        g_FTCounter = 1000 / g_FTCounter;
        g_LastFTUpdateTime = 0; 
    end
    
    g_FontRenderer:Draw(g_AppData:GetData("Width") - 72, 0, string.format("FPS: %.1f", g_FTCounter));
end

-------------------------------------------------------------------------
function Pause(onPause)
	PauseDelegate(onPause);
end

-------------------------------------------------------------------------
-- OK for non-GL thread.
function AndroidStart()
	if APP_DEBUG_MODE then
		g_Logger:Show("AndroidStart");
	end
end

-------------------------------------------------------------------------
-- OK for non-GL thread.
function AndroidStop()
	if APP_DEBUG_MODE then
		g_Logger:Show("AndroidStop");
	end
end

-------------------------------------------------------------------------
-- Only for GL thread (for it could do drawing).
function AndroidResume()
	if APP_DEBUG_MODE then
		g_Logger:Show("AndroidResume");
	end

	if (StageManager:IsOnStage("InGame")) then
		-- game state already paused on AndroidPause, here is for drawing pause UI.
		-- The reason we do drawing here, is because AndroidPause cannot be called from GL thread.
		-- Detail: at the moment system call activity onPause, GL thread could be suspended.
		-- Which means no more onDrawFrame will be called, therefore no change to ask gl renderer to call AndroidPause.
		PauseGame(true);
	end
end

-------------------------------------------------------------------------
-- OK for non-GL thread.
function AndroidPause()
	if APP_DEBUG_MODE then
		g_Logger:Show("AndroidPause");
	end

	if (StageManager:IsOnStage("InGame")) then
		EnableUpdateGameObjects(false);
	end
end

-------------------------------------------------------------------------
-- Android: touch event.
function ProcessTouch(touch)

    -- g_Logger:Show("process_touch event:" .. touch:GetAction() .. ",x:" .. touch:GetX() .. ",y:" .. touch:GetY());

    if touch:IS_ACTION_DOWN() then

        TouchBegan(touch:GetX(), touch:GetY());

    elseif touch:IS_ACTION_MOVE() then

        TouchMoved(touch:GetX(), touch:GetY());

    elseif touch:IS_ACTION_UP() then

        TouchEnded(touch:GetX(), touch:GetY());

    else

        g_Logger:Show("process_touch: unknown touch event:" .. touch:GetAction());

    end
end

-------------------------------------------------------------------------
-- For Android platform, back key is used to control game stage flow.
-- Return true if consumed, false if not.

function ProcessBackKey()

	return UIManager:ProcessBack();
end

--=======================================================================
-- Delegate templates
--=======================================================================

-------------------------------------------------------------------------
function InitializeDelegate()
end

-------------------------------------------------------------------------
function InitializeAppDataDelegate()
end

-------------------------------------------------------------------------
function TerminateDelegate()
end

-------------------------------------------------------------------------
function ProcessInputDelegate()
end

-------------------------------------------------------------------------
function UpdateDelegate()
end

-------------------------------------------------------------------------
function RenderDelegate()
end

-------------------------------------------------------------------------
function PauseDelegate(onPause)
end

-------------------------------------------------------------------------
function OnEnterBackgroundDelegate()
end

-------------------------------------------------------------------------
function OnReceiveLocalNotificationDelegate()
end

--=======================================================================
-- Script loading routines
--=======================================================================

-------------------------------------------------------------------------
function LoadScript(name, path)
    assert(name);
    assert(path);

    local file = string.format("%s%s%s", path, name, SCRIPT_FILE_EXT);

    if IS_PLATFORM_ANDROID then
    	if APP_DEBUG_MODE then
    		-- g_Logger:Show("LoadScript file:" .. file);
    		g_LuaManager:RunFromFullPathFile(file);
    	else
    		g_LuaManager:RunFromAsset(file);
    	end
    else
    	dofile(file);    
	end
end

-------------------------------------------------------------------------
function LoadPrecompiledScript(name, path)
    assert(name);
    assert(path);

	local file = string.format("%s%s", path, name);

	if APP_DEBUG_MODE then
		g_LuaManager:RunFromFullPathFile(file);
	else
		g_LuaManager:RunFromAsset(file);
	end
end

-------------------------------------------------------------------------
function LoadScriptList(scriptList, scriptPath)
	assert(scriptList);
	assert(scriptPath);
	for _, scriptName in pairs(scriptList) do
		--log("Loading script : "..scriptName);
		LoadScript(scriptName, scriptPath);
	end
end

--=======================================================================
-- Debug functionality
--=======================================================================

-------------------------------------------------------------------------
function log(msg)
	print(msg);
	-- g_Logger:Show(msg);
end

-------------------------------------------------------------------------
function logp(x, y, title)
	local msg = "[" .. (title or "#") .. "] " .. x .. " , " .. y;
	print(msg);
	-- g_Logger:Show(msg);
end

-------------------------------------------------------------------------
function InitializeMWCounter()
    assert(g_FontRenderer ~= nil);
    assert(g_MemoryWarningGO == nil);

    MWCounterkStates =
    {
        hide =
        {
            OnEnter = function(go)
            end,
        
            OnExecute = function(go)
            end,    
            
            OnExit = function(go)
            end,
        },

        show =
        {
            OnEnter = function(go)
                go["Timer"]:Reset();
                
                UIManager:GetWidget("MWCounter", "Text"):SetValue(string.format("MW #%d: [Lua] %.f KB", g_MemoryWarningCount, collectgarbage("count")));
                UIManager:ToggleUI("MWCounter");
                
                g_UpdateManager:AddObject(g_MemoryWarningGO, ROUTINE_GROUP_10);
            end,
        
            OnExecute = function(go)
                if (go["Timer"]:IsOver()) then
                    go["StateMachine"]:ChangeState("hide");
                end
            end,    
            
            OnExit = function(go)
                g_UpdateManager:RemoveObject(g_MemoryWarningGO, ROUTINE_GROUP_10);

                UIManager:ToggleUI("MWCounter");
            end,
        },
    };

    GameObjectTemplate
    {
        class = "MWCounter",
        
        components =
        {
            {
                class = "Transform",
            },

            {
                class = "Timer",
                duration = 3000,
            },
            
            {
                class = "StateMachine",
                states = MWCounterkStates,
                initial = "hide",
            },        
        },    
    };
    
    GameUITemplate
    {
        name = "MWCounter",

        width = 1,
        height = 1,
        transparent = true,

        widgets =
        {
            {
                class = "PuzzleText",
                name = "Text",
            },
        },
    };
    
    g_MemoryWarningGO = ObjectFactory:CreateGameObject("MWCounter");
    g_MemoryWarningCount = 0;
end

-------------------------------------------------------------------------
function InitializeFTCounter()
    g_FTCounter = 0;
    g_LastFTUpdateTime = 0;
    
    MainLoopIphone = MainLoopIphoneFTDebug;
end


