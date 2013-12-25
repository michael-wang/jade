--***********************************************************************
-- @file GameLogic.lua
--***********************************************************************

-------------------------------------------------------------------------
function InitializeGame()
    --###########
    -- Serialization
    --###########
    
    IOManager:Create(IO_MAIN_DATA, true);

    --###########
    -- Object
    --###########

    objPool = {};

    objPool[0] = ObjectFactory:CreateGameObject("Background");
    objPool[0]["Shape"]:SetSize(g_AppData:GetData("Width"), g_AppData:GetData("Height"));
    objPool[0]["Shape"]:SetColor(COLOR_PINK[0], COLOR_PINK[1], COLOR_PINK[2], ALPHA_HALF);

    objPool[1] = ObjectFactory:CreateGameObject("TestObj_00");
    objPool[1]["Sprite"]:SetAlpha(ALPHA_QUARTER);

    objPool[2] = ObjectFactory:CreateGameObject("TestObj_01");
    objPool[2]["Transform"]:ModifyTranslate(50, 50);
    objPool[2]["Sprite"]:SetImage("mole-invincible");
    objPool[2]["Sprite"]:SetAlpha(ALPHA_QUARTER);
    
    objPool[3] = ObjectFactory:CreateGameObject("TestObj_01");
    objPool[3]["Transform"]:ModifyTranslate(100, 100);
    objPool[3]["Sprite"]:SetImage("mole-magic");

    objPool[4] = ObjectFactory:CreateGameObject("TestObj_02");

    objPool[5] = ObjectFactory:CreateGameObject("TestObj_03");

    objPool[6] = ObjectFactory:CreateGameObject("TestObj_04");
    objPool[6]["SpriteGroup"]:SetOffset(1, 0, 0);
    objPool[6]["SpriteGroup"]:SetOffset(2, 0, 50);
    objPool[6]["SpriteGroup"]:SetOffset(3, 0, 100);
    objPool[6]["SpriteGroup"]:SetOffset(4, 0, 150);
--[[
    g_RenderManager:AddGroupObjects(objPool, ROUTINE_GROUP_01);
    g_UpdateManager:AddGroupObjects(objPool, ROUTINE_GROUP_01);
--]]
    for i = 0, 6 do
        g_RenderManager:AddObject(objPool[i], ROUTINE_GROUP_01);
        g_UpdateManager:AddObject(objPool[i], ROUTINE_GROUP_01);
    end

    --###########
    -- Stage
    --###########
    
    StageManager:ChangeStage("MainEntry");
end

-------------------------------------------------------------------------
function InitializeGameKitDelegate()
    g_LeaderboardCategory = "com.monkeypotion.testing.lb1";
    g_Ach01 = "com.monkeypotion.testing.ach1";
end

-------------------------------------------------------------------------
function UpdateRectPosition(x, y)
    for i = 1, 3 do
        if (objPool[i]["Bound"]:IsPicked(x, y)) then
            objPool[i]["Transform"]:ModifyTranslate(x - g_TouchBeganPos[1], y - g_TouchBeganPos[2]);
            return;
        end
    end
end
