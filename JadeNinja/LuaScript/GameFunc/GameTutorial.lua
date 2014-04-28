--***********************************************************************
-- @file GameTutorial.lua
--***********************************************************************

-------------------------------------------------------------------------
TUTORIAL_WAIT_DURATION = 100;

TUTORIAL_DIALOG_POS =
{
	["avatar"] = { 265, 45 },
	["enemy"] = { 140, 30 },
};

TUTORIAL_SLASH_POS = { 285, 125 };
TUTORIAL_SLASH_TARGET = { 205, 205 };

TUTORIAL_SWIPE_POS_SET =
{
	[DEFAULT_HAND_SET] = { 10, 250 + 16 },
	[INVERSE_HAND_SET] = { 380, 250 + 16 },
};

TUTORIAL_SWIPE_TARGET_SET =
{
	[DEFAULT_HAND_SET] = { 90, 250 + 16 },
	[INVERSE_HAND_SET] = { 460, 250 + 16 },
};

TUTORIAL_TAP_POS_SET =
{
	[DEFAULT_HAND_SET] =
	{
		{ 325, 220 + 32 },
		{ 255, 220 + 32 },
	},
	[INVERSE_HAND_SET] =
	{
		{ -30, 220 + 32 },
		{ 40, 220 + 32 },
	},
};

TUTORIAL_SWIPE_POS = TUTORIAL_SWIPE_POS_SET[DEFAULT_HAND_SET];
TUTORIAL_SWIPE_TARGET = TUTORIAL_SWIPE_TARGET_SET[DEFAULT_HAND_SET];
TUTORIAL_TAP_POS = TUTORIAL_TAP_POS_SET[DEFAULT_HAND_SET];

TUTORIAL_BOOKS = {};
TUTORIAL_BOOKS[1] =
{
---[[ @RELEASE
	--------------------------------------------------------------------
	-- Phase #1
	--------------------------------------------------------------------
	-- #1-1 @ Avatar: Let's get out of here!
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("avatar", "ui_tutorial_redword_dialog1");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap");
			end
		end,
	},
	-- #1-0 @ Pause: Hand Gesture
	{
		OnEnter = function(go)
			UIManager:GetWidget("Tutorial", "Screen"):ResetImage("ui_tip_hold");
			StageManager:ChangeStage("TutorialPause");
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
	-- #1-2 @ Pause: Life bar
	{
		OnEnter = function(go)
			UIManager:GetWidget("Tutorial", "Screen"):ResetImage("ui_tutorial_step1");
			StageManager:ChangeStage("TutorialPause");
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
	-- #1-3 @ Launch 1st enemy
	{
		OnEnter = function(go)
			go["Timer"]:Reset(1000);
			EnemyManager:LaunchEnemy(Tutorial_Enemy1);
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #1-4 @ Enemy: Hey you! Stop!
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("enemy", "ui_tutorial_redword_dialog2");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				--return true;
				go["StateMachine"]:ChangeState("tap");
			end
		end,
	},
	-- #1-6 @ Action: Pause for Katana
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (EnemyManager:GetActiveDrop() == nil) then
				UIManager:GetWidget("Tutorial", "Screen"):ResetImage("tutorial_weapon1");
				StageManager:ChangeStage("TutorialPause");
				return true;
			end
		end,
	},
	-- #1-7 @ Pause: Katana
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
	-- #1-8 @ Avatar: Help me
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("avatar", "ui_tutorial_redword_dialog4");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #1-9 @ Action: Slash
	{
		OnEnter = function(go)
			ShowSlashHand();
		end,
		
		OnExecute = function(go, sm)
			if (EnemyManager:IsActiveEnemyState("die")) then
				HideSlashHand();
			elseif (EnemyManager:IsActiveDropState("energyball_upper")) then
				UIManager:GetWidget("Tutorial", "Screen"):ResetImage("ui_tutorial_step2");
				StageManager:ChangeStage("TutorialPause");
				return true;
			end
		end,
	},
	-- #1-10 @ Pause: Energy ball
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
	-- #1-11 @ Action: Energy ball
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (EnemyManager:GetActiveDrop() == nil) then
				UIManager:GetWidget("Tutorial", "Screen"):ResetImage("ui_tutorial_step3");
				StageManager:ChangeStage("TutorialPause");
				return true;
			end
		end,
	},
	-- #1-12 @ Pause: Energy bar
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
--	
	--------------------------------------------------------------------
	-- Phase #2
	--------------------------------------------------------------------
	-- #2-2 @ Launch 2nd enemy
	{
		OnEnter = function(go)
			UIManager:EnableWidget("Tutorial", "Dialog", false);
			go["Timer"]:Reset(1000);
			EnemyManager:LaunchEnemy(Tutorial_Enemy2);
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #2-5 @ Action: Slash (be parried)
	{
		OnEnter = function(go)
			ShowSlashHand();
		end,
		
		OnExecute = function(go, sm)
			if (EnemyManager:IsActiveEnemyState("tutorial_defend")) then
				HideSlashHand();
			elseif (EnemyManager:IsActiveEnemyState("tutorial_idle")) then
				return true;
			end
		end,
	},
	-- #2-6 @ Enemy: Futile attack!
	{
		OnEnter = function(go)
			go["Timer"]:Reset(750);
			TutorialManager:PopDialog("enemy", "ui_tutorial_redword_dialog8");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #2-8 @ Action: Switch to Blade	
	{
		OnEnter = function(go)
			ShowSwipeHand("ui_tutorial_redword_system3");
		end,
		
		OnExecute = function(go, sm)
			if (BladeManager:IsCurrentBlade(WEAPON_TYPE_BLADE)) then
				HideSwipeHand();
				return true;
			end
		end,
	},
	-- #2-9 @ Action: Pause for Blade
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (EnemyManager:GetActiveDrop() == nil) then
				UIManager:GetWidget("Tutorial", "Screen"):ResetImage("tutorial_weapon2");
				StageManager:ChangeStage("TutorialPause");
				return true;
			end
		end,
	},
	-- #2-10 @ Pause: Blade
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
	-- #2-11 @ Action: Slash (success)
	{
		OnEnter = function(go)
			ShowSlashHand();
		end,
		
		OnExecute = function(go, sm)
			if (EnemyManager:IsActiveEnemyState("die")) then
				HideSlashHand();
			elseif (EnemyManager:GetActiveEnemy() == nil) then
				return true;
			end
		end,
	},
--
	--------------------------------------------------------------------
	-- Phase #3
	--------------------------------------------------------------------
	-- #3-1 @ Launch 3rd enemy
	{
		OnEnter = function(go)
			go["Timer"]:Reset(1200);
			
			local x = -75;
			local y = 130;
			local dist = 270;
			local offsetX = 20;
			local offsetY = 35;
			
			local enemy1 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy3, x, y);
			local enemy2 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy3, x - offsetX, y - offsetY);
			local enemy3 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy3, x - offsetX, y + offsetY);
			
            enemy1["Motion"]:ResetTarget(x + dist, y);
			enemy2["Motion"]:ResetTarget(x + dist - offsetX, y - offsetY);
			enemy3["Motion"]:ResetTarget(x + dist - offsetX, y + offsetY);
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #3-2 @ Enemy: Go catch her! => We'll capture you
	{
		OnEnter = function(go)
			--TutorialManager:PopDialog("enemy", "ui_tutorial_redword_dialog10");
			TutorialManager:PopDialog("enemy", "ui_tutorial_redword_dialog3");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #3-4 @ Action: Switch to Spear
	{
		OnEnter = function(go)
			ShowSwipeHand("ui_tutorial_redword_system4");
		end,
		
		OnExecute = function(go, sm)
			if (BladeManager:IsCurrentBlade(WEAPON_TYPE_SPEAR)) then
				HideSwipeHand();
				return true;
			end
		end,
	},
	-- #3-5 @ Action: Pause for Spear
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (EnemyManager:GetActiveDrop() == nil) then
				UIManager:GetWidget("Tutorial", "Screen"):ResetImage("tutorial_weapon3");
				StageManager:ChangeStage("TutorialPause");
				return true;
			end
		end,
	},
	-- #3-6 @ Pause: Spear
	{
		OnEnter = function(go)
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
	-- #3-7 @ Action: Slash
	{
		OnEnter = function(go)
			ShowSlashHand();
		end,
		
		OnExecute = function(go, sm)
			if (EnemyManager:IsActiveEnemiesState("die")) then
				HideSlashHand();
				return true;
			end
		end,
	},
	-- #3-9 @ Launch innocent
	{
		OnEnter = function(go)
			--go["Timer"]:Reset(1000);
			EnemyManager:LaunchEnemy(Tutorial_InnocentWoman);
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #3-10 @ Avatar: Don't hurt innocent people!
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("avatar", "ui_tutorial_redword_dialog12");
		end,
		
		OnExecute = function(go, sm)
			if (EnemyManager:GetActiveEnemy() == nil) then
				return true;
			end
		end,
	},
	-- #3-12 @ Pause: Innocents & Monkey
	{
		OnEnter = function(go)
			UIManager:GetWidget("Tutorial", "Screen"):ResetImage("ui_tutorial_step4");
			StageManager:ChangeStage("TutorialPause");
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap_paused");
			end
		end,
	},
--
	--------------------------------------------------------------------
	-- Phase #4
	--------------------------------------------------------------------
	-- #4-5 @ Launch 5th enemy wave
	{
		OnEnter = function(go)
			go["Timer"]:Reset(1500);
			
			local x = -75;
			local y = 150;
			local dist = 260;
			local offsetX = 40;
			local offsetY = 35;
			
			local enemy1 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy2, x, y);
			local enemy2 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy3, x - offsetX, y - offsetY);
			local enemy3 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy3, x - offsetX, y + offsetY);
			local enemy4 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy4, x - offsetX * 2, y - offsetY * 2);
			local enemy5 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy4, x - offsetX * 2, y + offsetY * 2);
			
            enemy1["Motion"]:ResetTarget(x + dist, y);
			enemy2["Motion"]:ResetTarget(x + dist - offsetX, y - offsetY);
			enemy3["Motion"]:ResetTarget(x + dist - offsetX, y + offsetY);
			enemy4["Motion"]:ResetTarget(x + dist - offsetX * 2, y - offsetY * 2);
			enemy5["Motion"]:ResetTarget(x + dist - offsetX * 2, y + offsetY * 2);
			
			AudioManager:PlaySfx(SFX_CHAR_NINJA_BOMB);
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #4-7 @ Enemy: Don't ever think you can get away
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("enemy", "ui_tutorial_redword_dialog13");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #4-8 @ Avatar: We are finished!
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("avatar", "ui_tutorial_redword_dialog14");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #4-9 @ System: Use Scroll to Protect Her (Action: Scroll of Meteor)
	{
		OnEnter = function(go)
			--ShowTapHand(2);
			ShowTapHand(1);
		end,
		
		OnExecute = function(go, sm)
			if (EnemyManager:IsActiveEnemiesState("die")) then
				return true;
			end
		end,
	},
	-- #4-10 @ Wait
	{
		OnEnter = function(go)
			go["Timer"]:Reset(2000);
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #4-11 @ Avatar: Yeah! We've made our escape!
	{
		OnEnter = function(go)
			go["Timer"]:Reset(1750);
			TutorialManager:PopDialog("avatar", "ui_tutorial_redword_dialog15");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
--]]	
	-- #4-13 @ Avatar: Congratulations!
	{
		OnEnter = function(go)			
			go["Timer"]:Reset(2500);
			AudioManager:PlayBgm(BGM_LEVEL_WIN);
			TutorialManager:Complete();
			TutorialManager:ShowEnding("ui_tutorial_redword_system6");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #4-14 @ Avatar: You are qualified!
	{
		OnEnter = function(go)
			AudioManager:PlaySfx(SFX_UI_BEST_SCORE);
			TutorialManager:ShowEnding("ui_tutorial_redword_system7");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	--======= Tutorial Completed =======--
	{
		OnEnter = function(go)
			go["Timer"]:Reset(2000);
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				--log("Tutorial complete!")
				TutorialManager:EnableJustCompleted(true);				
				StageManager:ChangeStage("PreExitGame");
				
				ChangeMapTitle(nil, 2);
				UIManager:CenterSwipeObjects("EndlessMap", 2);
				
				return true;
			end
		end,
	},
--[[ @TutorialShorten
	-- #1-5 @ Enemy: We'll capture you
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("enemy", "ui_tutorial_redword_dialog3");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				go["StateMachine"]:ChangeState("tap");
			end
		end,
	},
--]]
--[[ @TutorialShorten
	-- #4-1 @ Launch 4th enemy
	{
		OnEnter = function(go)
			go["Timer"]:Reset(2000);
			
			local x = -75;
			local y = 150;
			local dist = 240;
			local offsetX = 30;
			local offsetY = 35;
			
			local enemy1 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy4, x, y);
			local enemy2 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy4, x - offsetX, y - offsetY);
			local enemy3 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy4, x - offsetX, y + offsetY);
			local enemy4 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy4, x - offsetX * 2, y - offsetY * 2);
			local enemy5 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy4, x - offsetX * 2, y + offsetY * 2);
			
            enemy1["Motion"]:ResetTarget(x + dist, y);
			enemy2["Motion"]:ResetTarget(x + dist - offsetX, y - offsetY);
			enemy3["Motion"]:ResetTarget(x + dist - offsetX, y + offsetY);
			enemy4["Motion"]:ResetTarget(x + dist - offsetX * 2, y - offsetY * 2);
			enemy5["Motion"]:ResetTarget(x + dist - offsetX * 2, y + offsetY * 2);
			
			AudioManager:PlaySfx(SFX_CHAR_NINJA_BOMB);
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
	-- #4-2 @ System: Use Scroll to Protect Her (Action: Scroll of Protection)
	{
		OnEnter = function(go)
			ShowTapHand(1);
		end,
		
		OnExecute = function(go, sm)
			if (LevelManager:IsCurrentShieldState()) then
				ScrollManager:EnableScrollButtons(false);
				return true;
			end
		end,
	},
	-- #4-3 @ Action: Enemy bombs
	{
		OnEnter = function(go)
			EnemyManager:ChangeActiveEnemiesState("move");
			AudioManager:PlaySfx(SFX_CHAR_NINJA_BOMB);
		end,
		
		OnExecute = function(go, sm)
			if (EnemyManager:IsActiveEnemiesState("die")) then
				return true;
			end
		end,
	},
	-- #4-4 @ Wait
	{
		OnEnter = function(go)
			go["Timer"]:Reset(1000);
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
--]]
--[[ @TutorialShorten
	-- #4-6 @ Launch 6th enemy wave
	{
		OnEnter = function(go)
			local enemy1 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy5, 270, 115);
			local enemy2 = EnemyManager:LaunchEnemyWithPosition(Tutorial_Enemy5, 270, 185);
			
			EnemyManager:SetAnimation(enemy1, ENEMY_ANIM_SKILL_ASSAULT);
			EnemyManager:SetAnimation(enemy2, ENEMY_ANIM_SKILL_ASSAULT);
		end,
		
		OnExecute = function(go)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
--]]	
--[[ @TutorialShorten
	-- #4-12 @ Avatar:  All our hopes are pinned on you!
	{
		OnEnter = function(go)
			TutorialManager:PopDialog("avatar", "ui_tutorial_redword_dialog16");
		end,
		
		OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				return true;
			end
		end,
	},
--]]
};



-------------------------------------------------------------------------
GameObjectTemplate
{
	class = "TutorialObject",

	components =
	{
        {
            class = "StateMachine",
            states =
			{
				inactive =
				{
					OnEnter = function(go, sm, args)
					end,
			
					OnExit = function(go, sm, args)
					end,
				},

				wait =
				{
					OnEnter = function(go, sm, args)
					--log("tut wait @ enter")
						go["Timer"]:Reset(TUTORIAL_WAIT_DURATION);
					end,
			
					OnExecute = function(go, sm)
						if (go["Timer"]:IsOver()) then
							sm:ChangeState("active");
						end
					end,
			
					OnExit = function(go, sm, args)
					--log("tut wait @ exit")
					end,
				},

				tap =
				{
					OnEnter = function(go, sm, args)
						StageManager:ChangeStage("TutorialTap");
					end,
			
					--OnExecute = function(go, sm)
					--end,
			
					OnExit = function(go, sm, args)
						StageManager:ChangeStage("TutorialWait");
					end,				
				},

				tap_paused =
				{
					OnEnter = function(go, sm, args)
						StageManager:ChangeStage("TutorialTapPaused");
					end,
			
					--OnExecute = function(go, sm)
					--end,
			
					OnExit = function(go, sm, args)
						StageManager:ChangeStage("TutorialWait");
					end,				
				},

				active =
				{
					OnEnter = function(go, sm, args)
						TutorialManager:EnterNextStep();
					end,
			
					OnExecute = function(go, sm)
						TutorialManager:Execute();
					end,
			
					OnExit = function(go, sm, args)
						TutorialManager:ExitCurrentStep();
					end,				
				},
			},
        },
		
		{
			class = "Timer",
			duration = TUTORIAL_WAIT_DURATION,
		},
	},
};


-------------------------------------------------------------------------
TutorialManager =
{
	m_MainObject = nil,
	m_CurrentTutorial = nil,
	m_CurrentStep = nil,
	m_StepCount = 0,
	m_InProcessingTutorial = false,
	m_JustCompleted = false,
	
	---------------------------------------------------------------------
    Create = function(self)
--[[	
		self.m_MainObject = ObjectFactory:CreateGameObject("TutorialObject");
--]]
		local transGC = UIManager:GetWidgetComponent("Tutorial", "Dialog", "Transform");
		UIManager:GetWidgetComponent("Tutorial", "Dialog", "Interpolator"):AttachUpdateCallback(UpdateGOScale, transGC);
		
		CycleGOScale(UIManager:GetWidgetObject("Tutorial", "Continue"), 1.0, 1.1, 750);
		CycleGOScale(UIManager:GetWidgetObject("Tutorial", "Message"), 1.0, 1.1, 750);

		log("TutorialManager creation done");
    end,
	---------------------------------------------------------------------
	PreStart = function(self)
		--self.m_MainObject["StateMachine"]:ChangeState("inactive");
		
		UIManager:ToggleWidgetGroup("Tutorial", "AllWidgets", false);
		UIManager:ToggleUI("Tutorial");

		ScrollManager:EnableScrollButtons(false);
	end,
	---------------------------------------------------------------------
    Start = function(self)
		self.m_CurrentTutorial = TUTORIAL_BOOKS[1];
		self.m_CurrentStep = self.m_CurrentTutorial[1];
		self.m_StepCount = 1;
		self.m_InProcessingTutorial = true;

		self.m_MainObject = ObjectFactory:CreateGameObject("TutorialObject");
		self.m_MainObject["StateMachine"]:ChangeState("active");
		
		EnemyManager:SetEnemyInTutorial(true);
		ScrollManager:SetScrollInTutorial(true);
		BladeManager:EnableWeaponAttack(true);
		BladeManager:EnableWeaponSwitch(false);
		
		local count = IOManager:ModifyValue(IO_CAT_CONTENT, "Tutorial", "Count", 1);
		--log("Tutorial count # "..count)
		if (count == 1) then
	        GameKit.LogEventWithParameter("Tutorial", "1 time", "Count", false);
		elseif (count < 10) then
	        GameKit.LogEventWithParameter("Tutorial", tostring(coint) .. " times", "Count", false);
		else
	        GameKit.LogEventWithParameter("Tutorial", "above all", "Count", false);
		end
		
		UIManager:GetWidgetComponent("Tutorial", "Hand", "StateMachine"):ChangeState("inactive");
		--log("TutorialManager START")
    end,
	---------------------------------------------------------------------
    Exit = function(self)
		if (self.m_InProcessingTutorial) then
			self.m_InProcessingTutorial = false;
			
			EnemyManager:SetEnemyInTutorial(false);
			ScrollManager:SetScrollInTutorial(false);
			BladeManager:EnableWeaponAttack(true);
			BladeManager:EnableWeaponSwitch(true);
			
			UIManager:ToggleUI("Tutorial");
			--log("<<<<<<<<<<<< TutorialManager EXIT >>>>>>>>>>>")
		end
	end,
	---------------------------------------------------------------------
	IsInProcessing = function(self)
		return self.m_InProcessingTutorial;
	end,
	---------------------------------------------------------------------
	EnableJustCompleted = function(self, enable)
		self.m_JustCompleted = enable;
	end,
	---------------------------------------------------------------------
	HasJustCompleted = function(self)
		return self.m_JustCompleted;
	end,
	---------------------------------------------------------------------
	Complete = function(self)
		UIManager:ToggleWidgetGroup("Tutorial", "AllWidgets", false);
		UpdateAchievement(ACH_TUTORIAL_COMPLETED);

		if (IOManager:GetValue(IO_CAT_CONTENT, "Tutorial", "Completed") ~= true) then
			IOManager:SetValue(IO_CAT_CONTENT, "Tutorial", "Completed", true);

			local rec = IOManager:GetValue(IO_CAT_CONTENT, "Level", "Normal");
			rec[1] = { Distance = 0, Coin = 0, Score = 0, Medal = 0, };
			IOManager:Save();
			
			LevelManager:RepositionMap(1);
			LevelManager:UnlockFirstLevel();  --UnlockLevel(1);
		end
	end,
	---------------------------------------------------------------------
	EnterNextStep = function(self)
		--log("    => step # "..self.m_StepCount - 1)
		self.m_MainObject["Timer"]:Reset(1000);
		
		if (self.m_CurrentStep["OnEnter"]) then
			self.m_CurrentStep["OnEnter"](self.m_MainObject);
		end
	end,
	---------------------------------------------------------------------
	ExitCurrentStep = function(self)
		if (m_CurrentStep and self.m_CurrentStep["OnExit"]) then
			self.m_CurrentStep["OnExit"](self.m_MainObject);
		end
	end,
	---------------------------------------------------------------------
    Execute = function(self)
		if (self.m_CurrentStep["OnExecute"](self.m_MainObject)) then
			self:GotoNextStep();
		end
    end,
	---------------------------------------------------------------------
	GotoNextStep = function(self)
		self.m_StepCount = self.m_StepCount + 1;
		self.m_CurrentStep = self.m_CurrentTutorial[self.m_StepCount];
	
		if (self.m_CurrentStep == nil) then
			--log("All tutorial steps are completed")
			self.m_MainObject["StateMachine"]:ChangeState("inactive");
		else
			--log("Tutorial step [exit] # "..self.m_StepCount);
			self.m_MainObject["StateMachine"]:ChangeState("wait");
		end
	end,
	---------------------------------------------------------------------
	Activate = function(self)
		self:GotoNextStep();
		self.m_MainObject["StateMachine"]:ChangeState("active");
	end,
	---------------------------------------------------------------------
	PopDialog = function(self, who, image, doSlash)
		if (who == "enemy") then
			AudioManager:PlaySfxInRandom(SFX_CHAR_NINJA_SKILL);
		else
			AudioManager:PlaySfx(SFX_OBJECT_BOOST);
		end
		
		local pos = TUTORIAL_DIALOG_POS[who];
		assert(pos);
		UIManager:SetWidgetTranslate("Tutorial", "Dialog", pos[1], pos[2]);
		UIManager:EnableWidget("Tutorial", "Dialog", true);
		UIManager:GetWidget("Tutorial", "Dialog"):SetImage(image);
		
		local interGC = UIManager:GetWidgetComponent("Tutorial", "Dialog", "Interpolator");
		interGC:ResetTarget(0.05, 1.1, 350);
		interGC:AppendNextTarget(1.1, 1.0, 150);
	end,
	---------------------------------------------------------------------
	ShowMessage = function(self, image)
		UIManager:EnableWidget("Tutorial", "Message", true);
		UIManager:GetWidget("Tutorial", "Message"):SetImage(image);
	end,
	---------------------------------------------------------------------
	ShowEnding = function(self, image, index)
	
		UIManager:EnableWidget("Tutorial", "Ending", true);
		UIManager:GetWidget("Tutorial", "Ending"):SetImage(image);
		
		local gc = UIManager:GetWidgetComponent("Tutorial", "Ending", "Interpolator");
        gc:ResetTarget(0.9, 1.1, 200);
        gc:AppendNextTarget(1.1, 1, 200);
		gc:AttachUpdateCallback(UpdateGOScale, UIManager:GetWidgetComponent("Tutorial", "Ending", "Transform"));
	end,
	---------------------------------------------------------------------
	Update = function(self)
		self.m_MainObject:Update();
	end,
};



-------------------------------------------------------------------------
function ShowSlashHand()
	TutorialManager:ShowMessage("ui_tutorial_redword_system2");
	UIManager:GetWidgetComponent("Tutorial", "Hand", "StateMachine"):ChangeState("slash");
	BladeManager:EnableWeaponAttack(true);
	StageManager:ChangeStage("TutorialAction");
end

-------------------------------------------------------------------------
function HideSlashHand()
	UIManager:EnableWidget("Tutorial", "Message", false);
	UIManager:GetWidgetComponent("Tutorial", "Hand", "StateMachine"):ChangeState("inactive");
	UIManager:EnableWidget("Tutorial", "Dialog", false);
	BladeManager:EnableWeaponAttack(false);
end

-------------------------------------------------------------------------
function ShowSwipeHand(image)
	TutorialManager:ShowMessage(image);
	UIManager:GetWidgetComponent("Tutorial", "Hand", "StateMachine"):ChangeState("swipe");
	BladeManager:EnableWeaponSwitch(true);
	BladeManager:EnableWeaponAttack(false);
	StageManager:ChangeStage("TutorialAction");
end

-------------------------------------------------------------------------
function HideSwipeHand()
	UIManager:EnableWidget("Tutorial", "Message", false);
	UIManager:GetWidgetComponent("Tutorial", "Hand", "StateMachine"):ChangeState("inactive");
	BladeManager:EnableWeaponSwitch(false);
	BladeManager:EnableWeaponAttack(true);
end

-------------------------------------------------------------------------
function ShowTapHand(index)
	TutorialManager:ShowMessage("ui_tutorial_redword_system5");
	UIManager:GetWidget("InGame", "Scroll"..index):Enable(true);
	UIManager:GetWidgetComponent("InGame", "Scroll"..index, "Sprite"):EnableRender(2, false);
	UIManager:GetWidgetComponent("InGame", "Scroll"..index, "StateMachine"):ChangeState("active");
	UIManager:GetWidgetComponent("Tutorial", "Hand", "StateMachine"):ChangeState("tap", index);
	StageManager:ChangeStage("TutorialAction");
end

-------------------------------------------------------------------------
function HideTapHand()
	UIManager:EnableWidget("Tutorial", "Dialog", false);
	UIManager:EnableWidget("Tutorial", "Message", false);
	UIManager:GetWidgetComponent("InGame", "Scroll1", "Interpolator"):Reset();
	UIManager:GetWidgetComponent("InGame", "Scroll2", "Interpolator"):Reset();
	UIManager:GetWidgetComponent("Tutorial", "Hand", "StateMachine"):ChangeState("inactive");
end
