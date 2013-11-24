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

APP_ASSET_PATH = nil;

SCRIPT_DEFAULT_EXT = ".lua";

ASSET_PATH_SCRIPT = "/lua/";
ASSET_PATH_IMAGE = "image/";
-- ASSET_PATH_FONT = "Font/";
ASSET_PATH_SOUND = "sound";

GAME_CORE_FILE = "GameCore"

-- PREBUILD_FUNC_SCRIPT_NAME = "soul.essence";
-- PREBUILD_DATA_SCRIPT_NAME = "love.essence";

APP_DEVICE_ANDROID_PHONE = 1;

PLAIN_DEVICE_SCRIPT_POOL =
{
	[APP_DEVICE_ANDROID_PHONE] = { "GamePuzzleImg", },
};

PREBUILD_DEVICE_SCRIPT_POOL =
{
	[APP_DEVICE_ANDROID_PHONE] = "iphone.bottle",
};

APP_DEBUG_MODE = true;
APP_USE_COMPILED_SCRIPT = false;

-- APP_IPOD_PLAYING = false;

APP_BASE_X = 320;
APP_BASE_Y = 480;
APP_UNIT_X = 1.0;
APP_UNIT_Y = 1.0;



--=======================================================================
-- Script file lists
-- (NOTE: The list will be and *must* be loaded in order)
--=======================================================================

CORE_SCRIPT_FILES =
{
	-- Utility
	-- "Utility",

	-- Factories/Managers
	"ObjectFactory",
	-- "StageManager",
	-- "TaskManager",
 --    "RoutineManager",
	-- "PoolManager",

	-- Components
	"ObjectComponent",
	"PuzzleComponent",
	-- "StateMachineComponent",

	-- UI
	-- "UIManager",
	-- "UIPuzzleWidget",
	
	-- IO
    -- "IOManager",
};

--=======================================================================
-- Globals
--=======================================================================

g_JavaInterface = nil;
g_Logger = nil;
-- g_Window = nil;
g_GraphicsRenderer = nil;
g_GraphicsEngine = nil;
g_AudioRenderer = nil;
g_AudioEngine = nil;
g_Timer = nil;
g_AppIsRunning = false;

g_AppData = 
{
	SetData = function (self, key, value)
		self[key] = value;
	end,

	GetData = function (self, key)
		return self[key];
	end,

	Dump = function (self)
		g_Logger:Show("g_AddData:");
		for k, _ in pairs(self) do
			g_Logger:Show(k);
		end
	end,
};



--=======================================================================
-- Core routines (Android)
--=======================================================================

-------------------------------------------------------------------------
function InitializeLuaAndroid(width, height)
    
	device = APP_DEVICE_ANDROID_PHONE;
	-- PLAIN_DEVICE_SCRIPT_LIST = PLAIN_DEVICE_SCRIPT_POOL[device];
	-- assert(PLAIN_DEVICE_SCRIPT_LIST);
	-- PREBUILD_DEVICE_SCRIPT_NAME = PREBUILD_DEVICE_SCRIPT_POOL[device];
	-- assert(PREBUILD_DEVICE_SCRIPT_NAME);

	APP_WIDTH = width;
	APP_HEIGHT = height;
	APP_UNIT_X = 1.0;
	APP_UNIT_Y = 1.0;
    
    -- Pre-initialize
	local preInitResult = PreInitialize();
    g_Logger:Show("PreInitialize done.");
    assert(preInitResult, "App PreInitialize Failed");
	
	-- NOTE: Only plain scripts need to load CORE SCRIPTS
	-- NOTE: Must called before InitializeAppData()
	if (not APP_USE_COMPILED_SCRIPT) then
		LoadScriptList(CORE_SCRIPT_FILES, SCRIPT_CORE_PATH);
        g_Logger:Show("LoadScriptList CORE_SCRIPT_FILES done.");
	end

    -- Initialize app data
    InitializeAppData();
    g_Logger:Show("InitializeAppData done.");
    
    -- Load game scripts
	if (APP_USE_COMPILED_SCRIPT) then
		dofile(string.format("%s/%s", APP_ASSET_PATH, PREBUILD_DEVICE_SCRIPT_NAME));
		dofile(string.format("%s/%s", APP_ASSET_PATH, PREBUILD_FUNC_SCRIPT_NAME));

        InitializeAppDataDelegate();
		
		dofile(string.format("%s/%s", APP_ASSET_PATH, PREBUILD_DATA_SCRIPT_NAME));
    else
		-- NOTE: Must called before other scripts
        LoadScript(GAME_CORE_FILE, SCRIPT_FUNC_PATH);
		-- LoadScriptList(PLAIN_DEVICE_SCRIPT_LIST, SCRIPT_DATA_PATH);

        InitializeAppDataDelegate();
        g_Logger:Show("InitializeAppDataDelegate done.");
        
        LoadScriptList(GAME_FUNC_FILES, SCRIPT_FUNC_PATH);
        LoadScriptList(GAME_DATA_FILES, SCRIPT_DATA_PATH);
	end
    
    -- Post-initialize
    return PostInitialize();
end

-------------------------------------------------------------------------
function PreInitialize()
	g_Logger = LuaLogger();
	g_JavaInterface = JavaInterface();
	g_Logger:Create(g_JavaInterface:GetLogFilePath());

    -- Create Window
	-- g_Window = Window();
    
	-- Initialize config
	InitializeConfigAndroid();

	-- Create GraphicsRenderer & GraphicsEngine
	g_GraphicsRenderer = AndroidGraphicsRenderer();
	g_GraphicsEngine = GraphicsEngine(g_GraphicsRenderer);
	-- g_GraphicsEngine:SetBasePath(IMAGE_PATH, FONT_PATH);

	-- Create AudioRenderer & AudioEngine
    g_AudioRenderer = AndroidAudioRenderer();
	g_AudioEngine = AudioEngine(g_AudioRenderer);
	-- g_AudioEngine:SetBasePath(AUDIO_PATH, AUDIO_PATH);

    g_AudioEngine:SetGlobalVolumes(AudioEngine.AUDIO_NORMAL, 1.0);
	g_AudioEngine:SetGlobalVolumes(AudioEngine.AUDIO_STREAMING, 1.0);
    
    -- Create GlyphFontRenderer
	-- NOTE: Must be called after InitializeConfigAndroid()
	if (APP_DEBUG_MODE) then
		-- g_FontRenderer = GlyphFontRenderer();
		-- g_FontRenderer:Create(APP_ASSET_PATH .. "/Asset/Font/Font.FontInfo", g_GraphicsEngine:CreateSprite("Font.png"));
		-- log("FontRenderer creation done")
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
    g_Logger:Show("native::lua::PostInitialize");

    -- ShowMemoryUsage("Core");

	if (InitializeDelegate() ~= false) then        
		g_AppIsRunning = true;
	else
		g_AppIsRunning = false;
	end

    local seed = os.time();
    math.randomseed(seed);
    g_AppData:SetData("RandomSeed", seed);
    --log("RandomSeed: " .. seed);
    
    -- ShowMemoryUsage("Game");
    
    -- if (g_AppData:GetData("MWDebug")) then
    --     InitializeMWCounter();
    -- end

    -- if (g_AppData:GetData("FTDebug")) then
    --     InitializeFTCounter();
    -- end
		
	return g_AppIsRunning;
end

-------------------------------------------------------------------------
function InitializeConfigAndroid()
    g_Logger:Show("native::lua::InitializeConfigAndroid");
	-- Determine app configuration
	-- if (g_Window:GetAppConfig() ~= Window.CONFIG_DEBUG) then
	-- 	APP_DEBUG_MODE = false;
	-- end

	-- Setup paths
	APP_ASSET_PATH = g_JavaInterface:GetAssetFileFolder();
	
	SCRIPT_PATH = APP_ASSET_PATH .. ASSET_PATH_SCRIPT;
	SCRIPT_CORE_PATH = SCRIPT_PATH;
	SCRIPT_FUNC_PATH = SCRIPT_PATH;
	SCRIPT_DATA_PATH = SCRIPT_PATH;

	IMAGE_PATH = "";
	FONT_PATH = "";
	AUDIO_PATH = "";
	SCRIPT_FILE_EXT = SCRIPT_DEFAULT_EXT;
end

-------------------------------------------------------------------------
function InitializeAppData()
 --    g_AppData = DataManager:Create();

	-- if (APP_NAME ~= nil and APP_VERSION ~= nil) then
	-- 	APP_TITLE = string.format("%s  v%s", APP_NAME, APP_VERSION);
 --        g_AppData:SetData("Title", APP_TITLE);
	-- 	g_Window:SetTitle(APP_TITLE);
	-- end
    
    g_AppData:SetData("Width", APP_WIDTH);
    g_AppData:SetData("Height", APP_HEIGHT);
    g_AppData:SetData("UnitX", APP_UNIT_X);
    g_AppData:SetData("UnitY", APP_UNIT_Y);
    
    g_AppData:SetData("UseCompiledScript", APP_USE_COMPILED_SCRIPT);
    g_AppData:SetData("DebugMode", APP_DEBUG_MODE);
    -- g_AppData:SetData("ResourcePath", APP_ASSET_PATH);
    -- g_AppData:SetData("IsIpodPlaying", APP_IPOD_PLAYING);

    g_AppData:SetData("WorldTranslateX", 0);
    g_AppData:SetData("WorldTranslateY", 0);

    -- g_AppData:Dump();
end

-------------------------------------------------------------------------
function TerminateLuaAndroid()
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
function MainLoopAndroid()
	g_Timer:Update();

	UpdateDelegate();
	RenderDelegate();
end

-------------------------------------------------------------------------
-- function MainLoopIphoneFTDebug()
-- 	g_Timer:Update();

-- 	UpdateDelegate();
-- 	RenderDelegate();

--     g_LastFTUpdateTime = g_LastFTUpdateTime + g_Timer:GetDeltaTime();    
--     if (g_LastFTUpdateTime > 1000) then
--         g_FTCounter = g_Timer:GetDeltaTime();
--         g_FTCounter = 1000 / g_FTCounter;
--         g_LastFTUpdateTime = 0; 
--     end
    
--     -- g_FontRenderer:Draw(g_AppData:GetData("Width") - 72, 0, string.format("FPS: %.1f", g_FTCounter));
-- end

-------------------------------------------------------------------------
function OnResume()
	PauseDelegate(false);
end

function OnPause()
	PauseDelegate(true);
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
    g_Logger:Show("native::lua::LoadScript:" .. string.format("%s%s%s", path, name, SCRIPT_FILE_EXT));
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
-- function InitializeMWCounter()
--     -- assert(g_FontRenderer ~= nil);
--     assert(g_MemoryWarningGO == nil);

--     MWCounterkStates =
--     {
--         hide =
--         {
--             OnEnter = function(go)
--             end,
        
--             OnExecute = function(go)
--             end,    
            
--             OnExit = function(go)
--             end,
--         },

--         show =
--         {
--             OnEnter = function(go)
--                 go["Timer"]:Reset();
                
--                 UIManager:GetWidget("MWCounter", "Text"):SetValue(string.format("MW #%d: [Lua] %.f KB", g_MemoryWarningCount, collectgarbage("count")));
--                 UIManager:ToggleUI("MWCounter");
                
--                 g_UpdateManager:AddObject(g_MemoryWarningGO, ROUTINE_GROUP_10);
--             end,
        
--             OnExecute = function(go)
--                 if (go["Timer"]:IsOver()) then
--                     go["StateMachine"]:ChangeState("hide");
--                 end
--             end,    
            
--             OnExit = function(go)
--                 g_UpdateManager:RemoveObject(g_MemoryWarningGO, ROUTINE_GROUP_10);

--                 UIManager:ToggleUI("MWCounter");
--             end,
--         },
--     };

--     GameObjectTemplate
--     {
--         class = "MWCounter",
        
--         components =
--         {
--             {
--                 class = "Transform",
--             },

--             {
--                 class = "Timer",
--                 duration = 3000,
--             },
            
--             {
--                 class = "StateMachine",
--                 states = MWCounterkStates,
--                 initial = "hide",
--             },        
--         },    
--     };
    
--     GameUITemplate
--     {
--         name = "MWCounter",

--         width = 1,
--         height = 1,
--         transparent = true,

--         widgets =
--         {
--             {
--                 class = "PuzzleText",
--                 name = "Text",
--             },
--         },
--     };
    
--     g_MemoryWarningGO = ObjectFactory:CreateGameObject("MWCounter");
--     g_MemoryWarningCount = 0;
-- end

-------------------------------------------------------------------------
-- function InitializeFTCounter()
--     g_FTCounter = 0;
--     g_LastFTUpdateTime = 0;
    
--     MainLoopIphone = MainLoopIphoneFTDebug;
-- end


