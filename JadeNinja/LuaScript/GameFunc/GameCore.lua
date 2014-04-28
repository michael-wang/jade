--***********************************************************************
-- @file GameCore.lua
--***********************************************************************

--=======================================================================
-- Constants
--=======================================================================
APP_NAME = "JadeNinja";
APP_VERSION = "0.1";

GAME_FUNC_FILES =
{
    "GameLogic",
	"GameSocial",
    "GameState",
	"GameStateEnemy",
	"GameStage",
	"GameEnemy",
	"GameBlade",
	"GameScroll",
	"GameShop",
	"GameMoney",
	"GameLevel",
	"GameAudio",
	"GameTutorial",
};

GAME_DATA_FILES =
{
    "GameGlobal",
	"GamePuzzleAnim",
    "GameObject",
	"GameUI",
	"GameAvatarData",
	"GameEnemyData",
	"GameStuffData",
	"GameLevelData",
	"GameSceneData",
	"GameAchievement",
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
function OnEnterBackgroundDelegate()
	--log("OnEnterBackgroundDelegate: stage @ " .. StageManager:GetCurrentStageId())
	RegisterLocalNotifications();

	if (StageManager:IsOnStage("InGame")) then
		PauseGame(true);
	end
end

--[[
-------------------------------------------------------------------------
function OnEnterForegroundDelegate()
	log("OnEnterForegroundDelegate: stage @ " .. StageManager:GetCurrentStageId())
end

-------------------------------------------------------------------------
function OnReceiveLocalNotificationDelegate()
	log("OnReceiveLocalNotificationDelegate: stage @ " .. StageManager:GetCurrentStageId())
end
--]]

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
