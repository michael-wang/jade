--***********************************************************************
-- @file GameUI.lua
--***********************************************************************

-------------------------------------------------------------------------
GameUITemplate
{
	name = "MainEntry",
	x = 0,
	y = 0,
--  width = 240,
--  height = 160,
	transparent = true,
--[[
	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_logo_background",
		},
	},
--]]
	widgets =
	{
        {
			--class = "PuzzlePicture",
			class = "PuzzleButton",
			name = "Char1",
			x = 100,
			y = 100,
			doUpdate = true,

			onMouseUp = function()
				UIManager:GetWidgetComponent("MainEntry", "Char1", "Motion"):SetCycling(true);
				UIManager:GetWidgetComponent("MainEntry", "Char1", "Motion"):ResetTarget(480, 0);
				UIManager:GetWidgetComponent("MainEntry", "Char1", "Motion"):AppendNextTarget(0, 0);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "mole",
				},
				
				{
					class = "LinearMotion",
					velocity = 150,
				},
			},			
		},

        {
			class = "PuzzlePicture",
			name = "Char2",
			x = 240,
			y = 160,

			onMouseUp = function()
			log("YA!")
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "mole-boss",
				},
			},			
		},

        {
			class = "PuzzlePicture",
			name = "Char3",
			x = 410,
			y = 0,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "mole-magic",
				},
			},			
		},
--[[			
        {
			class = "PuzzleButton",
			name = "LB#1",
			x = 20,
			y = 20,
			width = 50,
			height = 50,
			
			onMouseUp = function()
			end,
		},
--]]
--[[
        {
			class = "PuzzleButton",
			name = "submit",

			x = 100,
			y = 10,
			width = 50,
			height = 50,

			onMouseUp = function()
				
				local score = math.random(1240000, 1249999);
				log("submit score: "..score.." @ "..g_LeaderboardCategory)
				GameKitManager:SubmitScore(g_LeaderboardCategory, score);
			end,
		},
		
        {
			class = "PuzzleButton",
			name = "ACH",

			x = 10,
			y = 100,
			width = 50,
			height = 50,
			
			onMouseUp = function()
				GameKitManager:ShowAchievements();
			end,
		},

        {
			class = "PuzzleButton",
			name = "submit A#1",

			x = 100,
			y = 100,
			width = 50,
			height = 50,

			onMouseUp = function()
				GameKitManager:SubmitAchievement(g_Ach01, 100);
			end,
		},

        {
			class = "PuzzleButton",
			name = "reset",

			x = 200,
			y = 100,
			width = 50,
			height = 50,

			onMouseUp = function()
				GameKitManager:ResetAchievements();
			end,
		},
--]]
    },
};
