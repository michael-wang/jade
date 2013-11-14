-- Depends on GameData.lua

GameObjectTemplate
{
	class = "TestObj_02",

	components =
	{
		{
			class = "Transform",
            x = 200,
            y = 200,
		},

		{
			class = "PuzzleAnimation",
			anim = ANIM_OBJECT,
			animating = true,
		},
--[[
		{
			class = "RectangleShape",
            width = 100,
            height = 100,
            color = { 255, 0, 255, 255 },
		},
--]]
		{
			class = "RectangleBound",
            autoSize = true,
            worldTransform = true,
		},
        
        {
            class = "LinearMotion",
            velocity = 300,
        },
	},
};