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
 --    "GameState",
	"GameStage",
};

GAME_DATA_FILES =
{	
    "GameGlobal",
	"GamePuzzle",
    "GameObject",
	-- "GameUI",
};



--=======================================================================
-- Delegates
--=======================================================================

-------------------------------------------------------------------------
function InitializeDelegate()
    -- Create essential managers
    -- g_RenderManager = RoutineManager:Create("Render");
    -- g_UpdateManager = RoutineManager:Create("Update");
    -- g_TaskManager = TaskManager:Create();
    -- g_UIManager = UIManager:Create();

    -- Do game related initialization
    InitializeGame();
end

-------------------------------------------------------------------------
function InitializeAppDataDelegate()
    -- Setup App Flags
	if (APP_DEBUG_MODE) then
		-- g_AppData:SetData("UIShowColor", true);
		-- g_AppData:SetData("UIShowText", true);
		-- g_AppData:SetData("UIDebug", true);
		-- g_AppData:SetData("MWDebug", true);
		--g_AppData:SetData("FTDebug", true);
		--g_AppData:SetData("GOShowPick", true);
	end
end

-------------------------------------------------------------------------
bootstrap = false;
function UpdateDelegate()
    -- g_TaskManager:Update();
    -- g_UpdateManager:Execute();
    
    -- StageManager:Update();
    -- UIManager:Update();

    local arrEvents = g_JavaInterface:GetTouchEvents();
    local SIZE = arrEvents:GetSize();
    if SIZE > 0 then
        for i = 0, (SIZE - 1) do
            local touch = arrEvents:GetAt(i);
            ProcessTouch(touch);
        end
    end

    for _, obj in pairs(objPool) do
        obj:Update();
    end
end

-------------------------------------------------------------------------
function RenderDelegate()
    -- g_RenderManager:Execute();
    
    -- StageManager:Render();
    -- UIManager:Render();

    -- g_GraphicsEngine:DrawRectangle(0, 0, 256, -256, 0.63671875, 0.76953125, 0.22265625, 1.0);

    for _, obj in pairs(objPool) do
        obj:Render();
    end

end

-------------------------------------------------------------------------
function PauseDelegate(onPause)
end

--=======================================================================
-- Input Delegates
--=======================================================================

-------------------------------------------------------------------------
function TouchBegan(x, y)
    -- if (not UIManager:TouchBegan(x, y)) then
    --     StageManager:TouchBegan(x, y);
    -- end

    g_TouchBeganPos[1] = x;
    g_TouchBeganPos[2] = y;
    
    objPool[4]["Transform"]:SetTranslate(x, y);
    objPool[4]["Sprite"]:Animate();

    objPool[6]["SpriteGroup"]:SetOffset(1, 0, 0);
    objPool[6]["SpriteGroup"]:SetOffset(2, 50, 0);
    objPool[6]["SpriteGroup"]:SetOffset(3, 100, 0);
    objPool[6]["SpriteGroup"]:SetOffset(4, 150, 0);
end

-------------------------------------------------------------------------
function TouchMoved(x, y)
    -- StageManager:TouchMoved(x, y);
    -- UIManager:TouchMoved(x, y);

    UpdateRectPosition(x, y);
    
    g_TouchBeganPos[1] = x;
    g_TouchBeganPos[2] = y;
end

-------------------------------------------------------------------------
function TouchEnded(x, y)
    -- if (not UIManager:TouchEnded(x, y)) then
    --     StageManager:TouchEnded(x, y);
    -- end
end

function ProcessTouch(touch)
    local x = touch:GetX();
    local y = touch:GetY();

    if touch:IS_ACTION_DOWN() then

        TouchBegan(x, y);

    elseif touch:IS_ACTION_MOVE() then

        TouchMoved(x, y);

    elseif touch:IS_ACTION_UP() then

        TouchEnded(x, y);

    else
    end
end
