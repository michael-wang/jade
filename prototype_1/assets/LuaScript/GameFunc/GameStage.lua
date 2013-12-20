--***********************************************************************
-- @file GameStage.lua
--***********************************************************************

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "MainEntry",
---[[	
    ui = "MainEntry",
--]]	
	OnEnter = function()
	end,

	OnExit = function()
	end,

	TouchBegan = function(x, y)
        g_TouchBeganPos[1] = x;
        g_TouchBeganPos[2] = y;

        objPool[1]["Motion"]:AppendFirstTarget(x, y);
		
		objPool[4]["Transform"]:SetTranslate(x, y);
		objPool[4]["Sprite"]:Animate();

	    objPool[6]["SpriteGroup"]:SetOffset(1, 0, 0);
	    objPool[6]["SpriteGroup"]:SetOffset(2, 50, 0);
	    objPool[6]["SpriteGroup"]:SetOffset(3, 100, 0);
	    objPool[6]["SpriteGroup"]:SetOffset(4, 150, 0);
  	end,

	TouchMoved = function(x, y)
        UpdateRectPosition(x, y);
        
        g_TouchBeganPos[1] = x;
        g_TouchBeganPos[2] = y;
	end,

	TouchEnded = function(x, y)
	end,

	Update = function()
	end,

	Render = function()
--[[	
		g_GraphicsEngine:DrawRectangle(0, 0, 100, 200, 1, 0, 0, 0.25);
		g_GraphicsEngine:DrawRectangle(50, 0, 150, 100, 0, 1, 0, 1);
		g_GraphicsEngine:DrawRectangle(100, 100, 150, 150, 0, 0, 1, 1);
		
		g_GraphicsEngine:DrawCircle(200, 50, 50, COLOR_PURPLE[1], COLOR_PURPLE[2], COLOR_PURPLE[3], ALPHA_THREEQUARTER);
	
		if (APP_DEBUG_MODE) then
			g_FontRenderer:Draw(0, 0, "Monkey Potion");
		end
--]]		
	end,
};
