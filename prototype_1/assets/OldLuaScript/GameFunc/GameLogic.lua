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

    objPool[1] = ObjectFactory:CreateGameObject("Background");

    objPool[2] = ObjectFactory:CreateGameObject("TestObj_00");
    objPool[2]["Sprite"]:SetAlpha(ALPHA_QUARTER);

    objPool[3] = ObjectFactory:CreateGameObject("TestObj_01");
    objPool[3]["Transform"]:ModifyTranslate(50, 50);
    objPool[3]["Sprite"]:SetImage("mole-invincible");
    objPool[3]["Sprite"]:SetAlpha(ALPHA_QUARTER);
    
    objPool[4] = ObjectFactory:CreateGameObject("TestObj_01");
    objPool[4]["Transform"]:ModifyTranslate(100, 100);
    objPool[4]["Sprite"]:SetImage("mole-magic");

    objPool[5] = ObjectFactory:CreateGameObject("TestObj_02");

    objPool[6] = ObjectFactory:CreateGameObject("TestObj_03");

    objPool[7] = ObjectFactory:CreateGameObject("TestObj_04");
    objPool[7]["SpriteGroup"]:SetOffset(1, 0, 0);
    objPool[7]["SpriteGroup"]:SetOffset(2, 0, 50);
    objPool[7]["SpriteGroup"]:SetOffset(3, 0, 100);
    objPool[7]["SpriteGroup"]:SetOffset(4, 0, 150);

    g_RenderManager:AddGroupObjects(objPool, ROUTINE_GROUP_01);
    g_UpdateManager:AddGroupObjects(objPool, ROUTINE_GROUP_01);

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
    for i = 2, 4 do
        if (objPool[i]["Bound"]:IsPicked(x, y)) then
            objPool[i]["Transform"]:ModifyTranslate(x - g_TouchBeganPos[1], y - g_TouchBeganPos[2]);
            return;
        end
    end
end
