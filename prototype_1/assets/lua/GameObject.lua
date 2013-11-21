
GameObjectTemplate
{
	class = "TestObj_00",

	components =
	{
		{
			class = "Transform",
            --x = UI_POS[1],
            --y = UI_POS[2],
			x = 0,
			y = 0,
		},
		
		{
			class = "PuzzleSprite",
			image = "mole",
			blendMode = GraphicsEngine.BLEND_FADEOUT,
		},
--[[
		{
			class = "RectangleBound",
            autoSize = true,
			debug = true,
		},
--]]
---[[
		{
			class = "CircleBound",
            autoSize = true,
			debug = true,
		},
--]]        
        {
            class = "LinearMotion",
            velocity = 300,
        },
	},
};

GameObjectTemplate
{
	class = "TestObj_01",

	components =
	{
		{
			class = "Transform",
            x = UI_POS[1],
            y = UI_POS[2],
		},
--[[
		{
			class = "RectangleShape",
            width = 100,
            height = 100,
            color = { 255, 0, 0, 255 },
		},
--]]
---[[
		{
			class = "PuzzleSprite",
			image = "mole",
			--blendMode = GraphicsEngine.BLEND_WHITEOUT,
		},
--]]		
		{
			class = "RectangleBound",
            autoSize = true,
		},
        
        {
            class = "LinearMotion",
            velocity = 300,
        },
	},
};


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

GameObjectTemplate
{
	class = "TestObj_03",

	components =
	{
		{
			class = "Transform",
            x = 0,
            y = 280,
		},
		
		{
			class = "PuzzleCompositeSprite",
			images =
			{
				{ "coin1" },
				{ "coin2", true, 32, 0 },
				{ "coin3", true, 64, 0 },
				{ "coin4", true, 96, 0 },
				{ "coin5", true, 128, 0 },
			},
		},
	},
};

GameObjectTemplate
{
	class = "TestObj_04",

	components =
	{
		{
			class = "Transform",
            x = 0,
            y = 320,
		},
		
		{
			class = "PuzzleSpriteGroup",
			sprites =
			{
				{ name="PuzzleSprite", image="hammer-speed_lv41" },
				{ name="PuzzleSprite", image="hammer-speed_lv42" },
				{ name="PuzzleSprite", image="hammer-speed_lv43" },
				{ name="PuzzleSprite", image="hammer-speed_lv44" },
			},
		},
	},
};
