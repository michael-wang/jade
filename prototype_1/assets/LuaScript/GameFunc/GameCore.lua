--***********************************************************************
-- @file GameCore.lua
--***********************************************************************

--=======================================================================
-- Constants
--=======================================================================
APP_NAME = "Gao Framework";
APP_VERSION = "1.0";

GAME_FUNC_FILES =
{	
    "GameLogic",
    "GameState",
	"GameStage",
};

GAME_DATA_FILES =
{	
	"GamePuzzleAnim",
	"GameGlobal",
    "GameObject",
	"GameUI",
};



--=======================================================================
-- Delegates
--=======================================================================

-------------------------------------------------------------------------
function InitializeDelegate()
    -- Create essential managers
    g_RenderManager = RoutineManager:Create("Render");
    g_UpdateManager = RoutineManager:Create("Update");
    g_TaskManager = TaskManager:Create();
    g_UIManager = UIManager:Create();

    -- Do game related initialization
    InitializeGame();
end

-------------------------------------------------------------------------
function InitializeAppDataDelegate()
    -- Setup App Flags
	if (APP_DEBUG_MODE) then
		g_AppData:SetData("UIShowColor", true);
		g_AppData:SetData("UIShowText", true);
		g_AppData:SetData("UIDebug", true);
		g_AppData:SetData("MWDebug", true);
		--g_AppData:SetData("FTDebug", true);
		--g_AppData:SetData("GOShowPick", true);
	end
end

-------------------------------------------------------------------------
function UpdateDelegate()
    g_TaskManager:Update();
    g_UpdateManager:Execute();
    
    StageManager:Update();
    UIManager:Update();
end

-------------------------------------------------------------------------
function RenderDelegate()
    g_RenderManager:Execute();
    
    StageManager:Render();
    UIManager:Render();
end

-------------------------------------------------------------------------
function PauseDelegate(onPause)
end

--=======================================================================
-- Input Delegates
--=======================================================================

-------------------------------------------------------------------------
function TouchBegan(x, y)
    if (not UIManager:TouchBegan(x, y)) then
        StageManager:TouchBegan(x, y);
    end
end

-------------------------------------------------------------------------
function TouchMoved(x, y)
    StageManager:TouchMoved(x, y);
    UIManager:TouchMoved(x, y);
end

-------------------------------------------------------------------------
function TouchEnded(x, y)
    if (not UIManager:TouchEnded(x, y)) then
        StageManager:TouchEnded(x, y);
    end
end


