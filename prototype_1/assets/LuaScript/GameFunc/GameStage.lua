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

        if (objPool[2]["Motion"]:IsOnMotion()) then
        	objPool[2]["Motion"]:AppendNextTarget(x, y);
        else
        	objPool[2]["Motion"]:AppendFirstTarget(x, y);
        end
		
		objPool[5]["Transform"]:SetTranslate(x, y);
		objPool[5]["Sprite"]:Animate();

	    objPool[7]["SpriteGroup"]:SetOffset(1, 0, 0);
	    objPool[7]["SpriteGroup"]:SetOffset(2, 50, 0);
	    objPool[7]["SpriteGroup"]:SetOffset(3, 100, 0);
	    objPool[7]["SpriteGroup"]:SetOffset(4, 150, 0);
  	end,

	TouchMoved = function(x, y)
        UpdateRectPosition(x, y);
        
        g_TouchBeganPos[1] = x;
        g_TouchBeganPos[2] = y;
	end,

	-- Experiment to slide the background into two parts.
	TouchEnded = function(x, y)
		g_RenderManager:RemoveObject(objPool[1], ROUTINE_GROUP_01);
		g_UpdateManager:RemoveObject(objPool[1], ROUTINE_GROUP_01);

		-- SplitObjectUp
		local o = ObjectFactory:CreateGameObject("Background");

		g_RenderManager:AddObject(o, ROUTINE_GROUP_01);
		g_UpdateManager:AddObject(o, ROUTINE_GROUP_01);
		g_RenderManager:MoveObjectToFirst(o, ROUTINE_GROUP_01);
		g_UpdateManager:MoveObjectToFirst(o, ROUTINE_GROUP_01);

		local sprite = o["Sprite"];
		local img = sprite.m_PuzzleImage;
		local hw = img.size[1] / 2;
		local hh = img.size[2] / 2;
		local dxf = 0.2;

		sprite:SetQuadVertices(
			-hw, -hh, 
			-hw,  hh, 
			 hw*dxf, -hh, 
			 -hw*dxf,  hh);

		local left = img.uv[1];
		local top = img.uv[2];
		local right = (left + img.uv[3]) / 2;
		local bottom = (top + img.uv[4]);
		local tdx = (img.uv[3] - img.uv[1]) * dxf;
		sprite:SetQuadTexCoords(
			left, top, 
			left, bottom,
			right + tdx, top,
			right - tdx, bottom);

		o["Motion"]:AppendFirstTarget(-100, 40);

		-- SplitObjectDown
		local o = ObjectFactory:CreateGameObject("Background");

		g_RenderManager:AddObject(o, ROUTINE_GROUP_01);
		g_UpdateManager:AddObject(o, ROUTINE_GROUP_01);
		g_RenderManager:MoveObjectToFirst(o, ROUTINE_GROUP_01);
		g_UpdateManager:MoveObjectToFirst(o, ROUTINE_GROUP_01);

		local sprite = o["Sprite"];
		local img = sprite.m_PuzzleImage;

		sprite:SetQuadVertices(
			 hw*dxf, -hh, 
			 -hw*dxf,  hh, 
			 hw,  -hh, 
			 hw,  hh);

		local left = (img.uv[1] + img.uv[3]) / 2;
		local top = img.uv[2];
		local right = img.uv[3];
		local bottom = img.uv[4];
		sprite:SetQuadTexCoords(
			left + tdx, top, 
			left - tdx, bottom,
			right, top,
			right, bottom);

		o["Motion"]:AppendFirstTarget(100, -40);
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
