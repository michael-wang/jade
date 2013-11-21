--***********************************************************************
-- @file GameLogic.lua
--***********************************************************************

-------------------------------------------------------------------------
function InitializeGame()
    --###########
    -- Serialization
    --###########
    
    -- IOManager:Create(IO_MAIN_DATA, true);

    --###########
    -- Object
    --###########

    objPool = {};

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
    -- g_RenderManager:AddObject(objPool[1], ROUTINE_GROUP_01);
    -- g_UpdateManager:AddObject(objPool[1], ROUTINE_GROUP_01);

    --###########
    -- Stage
    --###########
    
    -- StageManager:ChangeStage("MainEntry");
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
