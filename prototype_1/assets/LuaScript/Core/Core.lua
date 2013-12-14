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

--SCRIPT_DEFAULT_PATH = "../../Source/LuaScript/";
SCRIPT_DEFAULT_EXT = ".lua";

--ASSET_PATH_RELEASE = "./Data/";
--ASSET_PATH_DEBUG = "../../Asset/";
--ASSET_PATH_SCRIPT = "./Data/Script/";
ASSET_PATH_IMAGE = "Image/";
ASSET_PATH_FONT = "Font/";
ASSET_PATH_SOUND = "Sound";

GAME_CORE_FILE = "GameCore"

PREBUILD_FUNC_SCRIPT_NAME = "soul.essence";
PREBUILD_DATA_SCRIPT_NAME = "love.essence";

-- APP_DEVICE_IPHONE = 1;
-- APP_DEVICE_IPHONE_RETINA = 2;
-- APP_DEVICE_IPHONE_TALLER = 3;
-- APP_DEVICE_IPAD = 4;
-- APP_DEVICE_IPAD_RETINA = 5;
APP_DEVICE_ANDROID_PHONE = 1;

-- PLAIN_DEVICE_SCRIPT_POOL =
-- {
-- 	[APP_DEVICE_IPHONE] = { "GamePuzzleImg", },
-- 	[APP_DEVICE_IPHONE_RETINA] = { "GamePuzzleImg", },
-- 	[APP_DEVICE_IPHONE_TALLER] = { "GamePuzzleImg_iPhone5", },
-- 	[APP_DEVICE_IPAD] = { "GamePuzzleImg_iPad", },
-- 	[APP_DEVICE_IPAD_RETINA] = { "GamePuzzleImg_iPad", },
-- };
PLAIN_DEVICE_SCRIPT_POOL =
{
	[APP_DEVICE_ANDROID_PHONE] = { "GamePuzzleImg", },
};


-- PREBUILD_DEVICE_SCRIPT_POOL =
-- {
-- 	[APP_DEVICE_IPHONE] = "iphone.bottle",
-- 	[APP_DEVICE_IPHONE_RETINA] = "iphone.bottle",
-- 	[APP_DEVICE_IPHONE_TALLER] = "iphone5.bottle",
-- 	[APP_DEVICE_IPAD] = "ipad.bottle",
-- 	[APP_DEVICE_IPAD_RETINA] = "ipad.bottle",
-- };
PREBUILD_DEVICE_SCRIPT_POOL =
{
	[APP_DEVICE_ANDROID_PHONE] = "android.bottle",
};


APP_DEBUG_MODE = true;
APP_USE_COMPILED_SCRIPT = false;
-- APP_IPHONE_RESOURCE_PATH = nil;
APP_ASSET_PATH = nil;
-- APP_IPOD_PLAYING = false;

APP_BASE_X = 320;
APP_BASE_Y = 480;
APP_UNIT_X = 1.0;
APP_UNIT_Y = 1.0;
APP_SCALE_FACTOR = 1;
-- IS_DEVICE_IPAD = false;



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

-- g_JavaInterface = nil;
-- g_Logger = nil;
g_Window = nil;
g_GraphicsRenderer = nil;
g_GraphicsEngine = nil;
g_AudioRenderer = nil;
g_AudioEngine = nil;
g_Timer = nil;
g_AppData = nil;
g_AppIsRunning = false;

GaoApp = {
    MakeDocumentPath = function(fileName)
        return "/sdcard/Download/" .. fileName;
    end
}


--=======================================================================
-- Core routines (iPhone)
--=======================================================================

-------------------------------------------------------------------------
-- function InitializeLuaIphone(device, width, height, orientation, unitX, unitY, useCompiledScript)
function InitializeLuaAndroid(width, height, assetPath)
    -- assert(device);
	assert(width);
	assert(height);
	assert(assetPath);
    -- assert(orientation);
    -- assert(unitX);
    -- assert(unitY);

    device = APP_DEVICE_ANDROID_PHONE;
    portrait = (width < height) and true or false;
    unitX = portrait and (width / APP_BASE_X) or (width / APP_BASE_Y);
    unitY = portrait and (height / APP_BASE_Y) or (height / APP_BASE_X);
    useCompiledScript = false;
    
	-- APP_DEVICE = device;
	SCREEN_UNIT_X = width;
	SCREEN_UNIT_Y = height;
	APP_UNIT_X = unitX;
	APP_UNIT_Y = unitY;

	-- if ((APP_DEVICE == APP_DEVICE_IPAD) or (APP_DEVICE == APP_DEVICE_IPAD_RETINA)) then
	-- 	IS_DEVICE_IPAD = true;
	--     APP_SCALE_FACTOR = 2;
	-- end

	if (portrait) then  -- Portrait mode
		APP_WIDTH = APP_BASE_X;
		APP_HEIGHT = APP_BASE_Y;
	else						-- Landscape mode
		APP_WIDTH = APP_BASE_Y;
		APP_HEIGHT = APP_BASE_X;
	end

	PLAIN_DEVICE_SCRIPT_LIST = PLAIN_DEVICE_SCRIPT_POOL[device];
	assert(PLAIN_DEVICE_SCRIPT_LIST);
	PREBUILD_DEVICE_SCRIPT_NAME = PREBUILD_DEVICE_SCRIPT_POOL[device];
	assert(PREBUILD_DEVICE_SCRIPT_NAME);

	if (useCompiledScript) then
		APP_USE_COMPILED_SCRIPT = true;
	end
    
    -- APP_IPHONE_RESOURCE_PATH = GaoApp.GetRootPath();
    -- assert(APP_IPHONE_RESOURCE_PATH);
    APP_ASSET_PATH = assetPath;

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
		dofile(string.format("%s/%s", APP_ASSET_PATH, PREBUILD_DEVICE_SCRIPT_NAME));
		dofile(string.format("%s/%s", APP_ASSET_PATH, PREBUILD_FUNC_SCRIPT_NAME));

        InitializeAppDataDelegate();
		
		dofile(string.format("%s/%s", APP_ASSET_PATH, PREBUILD_DATA_SCRIPT_NAME));
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
	-- g_JavaInterface = JavaInterface();

	-- -- Create Logger
 --    g_Logger = LuaLogger();
	-- g_Logger:Create(g_JavaInterface:GetLogFilePath());

    -- Create Window
	g_Window = Window();
    
	-- Initialize config
	InitializeConfigAndroid();

	-- Create GraphicsRenderer & GraphicsEngine
	g_GraphicsRenderer = AndroidGraphicsRenderer();
	g_GraphicsEngine = GraphicsEngine(g_GraphicsRenderer);
	g_GraphicsEngine:SetBasePath(IMAGE_PATH, FONT_PATH);

	-- Create AudioRenderer & AudioEngine
    g_AudioRenderer = AndroidAudioRenderer();
	g_AudioEngine = AudioEngine(g_AudioRenderer);
	g_AudioEngine:SetBasePath(AUDIO_PATH, AUDIO_PATH);

    g_AudioEngine:SetGlobalVolumes(AudioEngine.AUDIO_NORMAL, 1.0);
	g_AudioEngine:SetGlobalVolumes(AudioEngine.AUDIO_STREAMING, 1.0);
    
	--g_AudioRenderer:CreateMicrophone();
    -- APP_IPOD_PLAYING = g_AudioRenderer:IsIpodPlaying();

    -- Create GlyphFontRenderer
	-- NOTE: Must be called after InitializeConfigAndroid()
	if (APP_DEBUG_MODE) then
		g_FontRenderer = GlyphFontRenderer();
		g_FontRenderer:Create(APP_ASSET_PATH .. "/Font/Font.FontInfo", g_GraphicsEngine:CreateSprite("Font.png"));
		log("FontRenderer creation done")
	else
		log = function() end
		logp = function() end
	end
    
    -- Create Timer
    g_Timer = AndroidTimer();
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
function InitializeConfigAndroid()
	-- Determine app configuration
	if (g_Window:GetAppConfig() ~= Window.CONFIG_DEBUG) then
		APP_DEBUG_MODE = false;
	end

	-- Setup paths
	-- local rootPath = "/Asset/";
	local rootPath = APP_ASSET_PATH .. "/";
	
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
    -- g_AppData:SetData("IsIpodPlaying", APP_IPOD_PLAYING);

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
    dofile(string.format("%s%s%s", path, name, SCRIPT_FILE_EXT));    
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
end

-------------------------------------------------------------------------
function logp(x, y, title)
	print("[" .. (title or "#") .. "] " .. x .. " , " .. y);
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

