--***********************************************************************
-- @file GameState.lua
--***********************************************************************

-------------------------------------------------------------------------
BladeStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,
    
        OnExecute = function(go)
            BladeManager:RefreshEnergy();
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("cooldown");            
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active_paused =
    {
        OnEnter = function(go)
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("paused");            
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    paused =
    {
        OnEnter = function(go)
        end,
    
        --OnExecute = function(go, sm)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    cooldown =
    {
        OnEnter = function(go)
            go["Timer"]:Reset();
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
EnemyLauncherStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    active_module =
    {
        OnEnter = function(go, sm, duration)
        --log("EnemyLauncher @ active_module => [duration] "..duration)
            go["Timer"]:Reset(duration);
        end,
        
        OnExecute = function(go)
            if (go["Timer"]:IsOver()) then
                LevelManager:LaunchEnemy();
            end
        end,
    },
    ---------------------------------------------------------------------
    active_boss =
    {
        OnEnter = function(go, sm, duration)
            go["Timer"]:Reset(duration);
        end,
        
        OnExecute = function(go)
            if (go["Timer"]:IsOver()) then
                go["Timer"]:Reset();
                LevelManager:LaunchEnemyBossMode();
            end
        end,
    },
};

-------------------------------------------------------------------------
CoinStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    running =
    {
        OnEnter = function(go)
            local x, y = go["Transform"]:GetTranslate();
            go["Motion"]:SetVelocity(COIN_MOVE_VELOCITY);
            go["Motion"]:AppendNextTarget(-go["Bound"]:GetSize(), y);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                EnemyManager:DeactivateDrop(go);
            end
        end,    
        
        OnExit = function(go)
            go["Motion"]:SetVelocity(COIN_BOUNCE_VELOCITY);
        end,
    },
    ---------------------------------------------------------------------
    coin_moving =
    {
        OnEnter = function(go)
            go["Motion"]:SetVelocity(COIN_BOUNCE_VELOCITY);
            go["Motion"]:ResetTarget(UI_INGAME_COIN_POS[1], UI_INGAME_COIN_POS[2]);

            AddToRenderQueue(go);
        end,
    
        OnExecute = function(go, sm, scrolling)
            if (go["Motion"]:IsDone()) then
                EnemyManager:GainCoin(go);
                EnemyManager:DeactivateDrop(go);
            end
        end,    
        
        --OnExit = function(go)
        --end,
    },
    ---------------------------------------------------------------------
    energyball_moving =
    {
        OnEnter = function(go)
            AddToRenderQueue(go);            
            
            local x, y = go["Transform"]:GetTranslate();
            go["Motion"]:SetVelocity(50);
            go["Motion"]:AppendNextTarget(x, y + 5);
            go["Motion"]:AppendNextTarget(x, y);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("energyball_upper");
            end
        end,    
    },
    ---------------------------------------------------------------------
    energyball_upper =
    {
        OnEnter = function(go)
            local x, y = go["Transform"]:GetTranslate();
            go["Motion"]:SetVelocity(350);--200);
            go["Motion"]:AppendNextTarget(x, UI_INGAME_ENERGYBAR_TARGET[2] + 35 + math.random(-7, 7));            
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("energyball_target");
            end
        end,    
    },
    ---------------------------------------------------------------------
    energyball_target =
    {
        OnEnter = function(go)
            go["Motion"]:SetVelocity(800);--500);
            go["Motion"]:AppendNextTarget(UI_INGAME_ENERGYBAR_TARGET[1], UI_INGAME_ENERGYBAR_TARGET[2]);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                AudioManager:PlaySfx(SFX_SCROLL_SHIELD_HIT);
                BladeManager:HealEnergyPoint(go["Attribute"]:Get("Count"));
                EnemyManager:DeactivateDrop(go);
            end
        end,    
    },
};

-------------------------------------------------------------------------
BulletStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    shoot =
    {
        OnEnter = function(go)
            AddToRenderQueue(go);
        end,
    
        OnExecute = function(go, sm)
            if (LevelManager:IsCollidedCastle(go)) then
                LevelManager:AttackCastle(go["Attribute"]:Get("owner"));
                --AudioManager:PlaySfx(SFX_ENEMY_ATTACK_BULLET_LIGHT);
                EnemyManager:DeactivateBullet(go);
            elseif (go["Motion"]:IsDone()) then
                EnemyManager:DeactivateBullet(go);
            end
        end,
    },
};

-------------------------------------------------------------------------
CastleStates =
{
    ---------------------------------------------------------------------
    initial =
    {
        OnEnter = function(go, sm)
            AddToRenderQueue(go);
            sm:ChangeState("inactive");
        end,
    },
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation(go["Attribute"]:Get("AnimMove"), true);
        end,
    },
    ---------------------------------------------------------------------
    wounded =
    {
        OnEnter = function(go, sm, args)
            sm:LockState("wounded");
            sm:LockState("dodge");
    		AddToPostRenderQueue(args);
            
            go["Sprite"]:SetAnimation(go["Attribute"]:Get("AnimHurt"), true);
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,
        
        OnExit = function(go, sm, args)
            sm:UnlockAllStates();
    		RemoveFromPostRenderQueue(args);
        end,
    },
    ---------------------------------------------------------------------
    broken =
    {
        OnEnter = function(go, sm, args)
        --log("broken @ enter")
            sm:LockState("wounded");
            sm:LockState("broken");
            sm:LockState("dodge");
    		AddToPostRenderQueue(args);

            LevelManager:AvatarPreFail();
            go["Sprite"]:SetAnimation(go["Attribute"]:Get("AnimFail"), true);
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("countdown");
            end
        end,
        
        OnExit = function(go, sm, args)
        --log("broken @ exit")
    		RemoveFromPostRenderQueue(args);
        end,
    },
    ---------------------------------------------------------------------
    countdown =
    {
    },
    ---------------------------------------------------------------------
    revive =
    {
        OnEnter = function(go, sm, args)
        --log("revive @ enter")
    	    AddToPostRenderQueue(args);
            
            --local x, y = go["Transform"]:GetTranslate();
    		--args["Transform"]:SetTranslate(x + REVIVE_EFFECT_OFFSET[1], y + REVIVE_EFFECT_OFFSET[2]);
            args["Sprite"]:Animate();

            LevelManager:ResetCastlePosition();
            UIManager:GetUI("InGame"):LockAllButtons();            
        end,

        OnExecute = function(go, sm, args)
            if (args["Sprite"]:IsDone()) then
        		RemoveFromPostRenderQueue(args);
                LevelManager:ReviveAvatar();
                EnemyManager:UnlockPushbackStatus();
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm)
        --log("revive @ exit")
            sm:UnlockAllStates();
            UIManager:GetUI("InGame"):UnlockAllButtons();
        end,
    },
    ---------------------------------------------------------------------
    shield =
    {
        OnEnter = function(go, sm, args)
            go["Sprite"]:ResetAnimation(go["Attribute"]:Get("AnimMove"), true);
            
    	    AddToPostRenderQueue(args);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
    	    RemoveFromPostRenderQueue(args);
            
            LevelManager:UnloadCastleShield();
        end,
    },
    ---------------------------------------------------------------------
    boost =
    {
        OnEnter = function(go, sm, args)
            -- Rearrange render layers for avatar & boost effect
            RemoveFromRenderQueue(go);
    	    AddToPostRenderQueue(args);
    	    AddToPostRenderQueue(go);

    		go["Sprite"]:SetFrequency(0.2);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm, args)
    		go["Sprite"]:SetFrequency(1.0);

    	    RemoveFromPostRenderQueue(go);
    	    RemoveFromPostRenderQueue(args);
    	    AddToRenderQueue(go);
        end,
    },
    ---------------------------------------------------------------------
    dodge =
    {
        OnEnter = function(go, sm, args)
            sm:LockState("dodge");
            sm:LockState("wounded");

			BladeManager:ShowDodgeEffect();

            go["Motion"]:SetVelocity(400);
            
            local x, y = go["Transform"]:GetTranslate();
            local index = go["Attribute"]:Get("PositionIndex");
            local newIndex = AVATAR_POS_DEFAULT;
            
            if (index == AVATAR_POS_DEFAULT) then
                if (math.random(1, 100) > 50) then
                    newIndex = AVATAR_POS_UPPER;
                else
                    newIndex = AVATAR_POS_LOWER;
                end
            end
                        
            if (index == AVATAR_POS_UPPER) then
                go["Motion"]:ResetTarget(x, y + AVATAR_DODGE_DIST);
            elseif (index == AVATAR_POS_LOWER) then
                go["Motion"]:ResetTarget(x, y - AVATAR_DODGE_DIST);
            else -- index == AVATAR_POS_DEFAULT
                if (newIndex == AVATAR_POS_UPPER) then
                    go["Motion"]:ResetTarget(x, y - AVATAR_DODGE_DIST);
                else
                    go["Motion"]:ResetTarget(x, y + AVATAR_DODGE_DIST);
                end
            end

            go["Attribute"]:Set("PositionIndex", newIndex);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
            sm:UnlockAllStates();
            
            go["Motion"]:SetVelocity(200);
            EnemyManager:DodgeAllEnemies();
        end,
    },
    ---------------------------------------------------------------------
    berserker =
    {
        OnEnter = function(go, sm, args)
            sm:LockState("dodge");
            sm:LockState("wounded");

            go["Sprite"]:SetAnimation("avatar_berserker1_skill_enter", true);
            AudioManager:PlaySfx(SFX_SCROLL_METEOR_EXIT);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                LevelManager:SetAvatarBerserk(true);
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
            sm:UnlockAllStates();
        end,
    },
};

-------------------------------------------------------------------------
CastleShieldStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("scrolleffect_energyshield", true);
        end,
    
        --OnExecute = function(go)
        --end,
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    hit =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("scrolleffect_energyshield_hit", true);
            AudioManager:PlaySfx(SFX_SCROLL_SHIELD_HIT);
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
CastleComboEffectStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    comboeffect_in =
    {
        OnEnter = function(go)
            LevelManager:ReloadComboEffect(go);
--[[
            go["Sprite"]:SetBlendingMode(GraphicsEngine.BLEND_FADEOUT);            
            go["Interpolator"]:AttachUpdateCallback(UpdateGOAlpha, go["Sprite"]);
            go["Interpolator"]:ResetTarget(ALPHA_ZERO, ALPHA_MAX, 1000)
--]]
            go["Interpolator"]:ResetTarget(1.0, 1.2, 200);
            go["Interpolator"]:AppendNextTarget(1.2, 1.0, 80);            
            go["Fade"]:ResetTarget(ALPHA_QUARTER, ALPHA_MAX, 700);
        end,

        OnExecute = function(go, sm)
--            if (go["Interpolator"]:IsDone()) then
            if (go["Fade"]:IsDone()) then
                sm:ChangeState("comboeffect_on");
            end
        end,
    },
    ---------------------------------------------------------------------
    comboeffect_on =
    {
        OnEnter = function(go)
            go["Sprite"]:SetBlendingMode(GraphicsEngine.BLEND_WHITEOUT);
        end,
    },
    ---------------------------------------------------------------------
    comboeffect_out =
    {
        OnEnter = function(go)
            go["Sprite"]:SetBlendingMode(GraphicsEngine.BLEND_FADEOUT);
--            go["Interpolator"]:ResetTarget(ALPHA_MAX, ALPHA_ZERO, 1000)
            go["Fade"]:ResetTarget(ALPHA_MAX, ALPHA_ZERO, 700)
        end,
    
        OnExecute = function(go, sm)
--            if (go["Interpolator"]:IsDone()) then
            if (go["Fade"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,
        
        OnExit = function(go)
            LevelManager:UnloadComboEffect(go);

            go["Sprite"]:SetAlpha(ALPHA_MAX);
        end,
    },
};

-------------------------------------------------------------------------
CastleComboTextStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    combotext =
    {
        OnEnter = function(go, sm)
    		go:Reload();
    		AddToPostRenderQueue(go);
            
            go["Timer"]:Reset();
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,
        
        OnExit = function(go)
            RemoveFromPostRenderQueue(go);
            go:Unload();
        end,
    },
};

--[[
-------------------------------------------------------------------------
BlockStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
            AddToRenderQueue(go);
        end,
    
        OnExecute = function(go, sm)
        end,    
        
        OnExit = function(go)
            EnemyManager:RestoreBlock(go);
        end,
    },
};
--]]

-------------------------------------------------------------------------
EnemyEffectStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                EnemyManager:DeactivateEffect(go);
            end
        end,    
        
        OnExit = function(go)
        end,
    },
--[[    
    ---------------------------------------------------------------------
    smoke_enter =
    {
        OnEnter = function(go)
            go["Transform"]:SetScale(2.0);
            AddToRenderQueue(go);
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("smoke_on");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    smoke_on =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("effect_smokebomb_on", true);
            go["Timer"]:Reset();

            AudioManager:PlaySfx();
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("smoke_exit");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    smoke_exit =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("effect_smokebomb_exit", true);
        end,
    
        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                go["Transform"]:SetScale(1.0);
                EnemyManager:DeactivateEffect(go);
            end
        end,    
        
        OnExit = function(go)
            AudioManager:StopSfx();
        end,
    },
--]]    
};

-------------------------------------------------------------------------
EnemyLifebarStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
            go:ToggleUpdate();
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
            go:ToggleUpdate();
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go, sm, args)
            go["Shape"]:SetSize(3, args, ENEMY_BAR_SIZE[2]);
            go["Timer"]:Reset();
        end,
    
        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
        		go["Shape"]:SetSize(2, args, ENEMY_BAR_SIZE[2]);
                sm:ChangeState("inactive");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
};
--[[
-------------------------------------------------------------------------
SceneShakerStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
            go["Transform"]:SetTranslate(0, 0);
            
            go["Motion"]:ResetTarget(math.random(-10, 10), math.random(-10, 10));
            go["Motion"]:AppendNextTarget(math.random(-10, 10), math.random(-10, 10));
            go["Motion"]:AppendNextTarget(math.random(-10, 10), math.random(-10, 10));
            go["Motion"]:AppendNextTarget(math.random(-10, 10), math.random(-10, 10));
            --go["Motion"]:AppendNextTarget(math.random(-10, 10), math.random(-10, 10));
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                LevelManager:SetScenePosition(0, 0);
                sm:ChangeState("inactive");
            else
                LevelManager:SetScenePosition(go["Transform"]:GetTranslate());
            end
        end,    
        
        OnExit = function(go)
        end,
    },
};
--]]
-------------------------------------------------------------------------
SceneDecoratorStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    motion =
    {
        OnEnter = function(go)
            AddToPostRenderQueue(go);
        end,
    
        OnExecute = function(go, sm)
            DecoratorController["update"](go);
        end,    
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
SceneDecoratorLauncherStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        --log("DecoLauncher @ inactive")
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
        --log("DecoLauncher @ active")
    		g_UpdateManager:AddObject(go, BACKDROP_GROUP);
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                LevelManager:LaunchDecorator();
                go["Timer"]:ResetRandRange();
            end
        end,    
        
        OnExit = function(go)
    		g_UpdateManager:RemoveObject(go, BACKDROP_GROUP);
        end,
    },
};

-------------------------------------------------------------------------
ComboStates =
{
    ---------------------------------------------------------------------
    hide =
    {
        OnEnter = function(go)
            UIManager:EnableWidget("InGame", "Combo", false);
        end,
    
        OnExecute = function(go)
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    show =
    {
        OnEnter = function(go)
            UIManager:EnableWidget("InGame", "Combo", true);

            go["Interpolator"]:AttachUpdateCallback(UpdateGOScale, UIManager:GetWidgetComponent("InGame", "Combo", "Transform"));
            go["Interpolator"]:ResetTarget(1, 1.5, 125);
            go["Interpolator"]:AppendNextTarget(1.5, 1, 125);
            go["Timer"]:Reset();

            UIManager:GetWidgetComponent("InGame", "Combo", "Sprite"):SetAlpha(ALPHA_MAX);        
        end,
    
        OnExecute = function(go, sm)        
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("fade");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    fade =
    {
        OnEnter = function(go)
            go["Interpolator"]:AttachUpdateCallback(UpdateGOAlpha, UIManager:GetWidgetComponent("InGame", "Combo", "Sprite"));
            go["Interpolator"]:ResetTarget(ALPHA_MAX, 0, 1000);
        end,
    
        OnExecute = function(go, sm)
            if (go["Interpolator"]:IsDone()) then
                EnemyManager:ResetCombo();
            end
        end,    
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
TextEffectStates =
{
    ---------------------------------------------------------------------
    hide =
    {
        OnEnter = function(go, sm, args)
            UIManager:EnableWidget("InGame", args, false);
        end,
    
        --OnExecute = function(go)
        --end,
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    show =
    {
        OnEnter = function(go, sm, args)
            UIManager:EnableWidget("InGame", args, true);

            go["Interpolator"]:AttachUpdateCallback(UpdateGOScale, UIManager:GetWidgetComponent("InGame", args, "Transform"));
                
            local scale = TEXT_EFFECT_SCALE[args] or 1;
            go["Interpolator"]:ResetTarget(1, scale, 125);
            go["Interpolator"]:AppendNextTarget(scale, 1, 125);
            go["Timer"]:Reset();

            UIManager:GetWidgetComponent("InGame", args, "Sprite"):SetAlpha(ALPHA_MAX);        
        end,
    
        OnExecute = function(go, sm, args)        
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("fade", args);
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    fade =
    {
        OnEnter = function(go, sm, args)
            go["Interpolator"]:AttachUpdateCallback(UpdateGOAlpha, UIManager:GetWidgetComponent("InGame", args, "Sprite"));
            go["Interpolator"]:ResetTarget(ALPHA_MAX, 0, 300);
        end,
    
        OnExecute = function(go, sm, args)
            if (go["Interpolator"]:IsDone()) then
                sm:ChangeState("hide", args);
            end
        end,    
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
CountdownTextEffectStates =
{
    ---------------------------------------------------------------------
    done =
    {
        OnEnter = function(go)
            --go:ToggleRenderAndUpdate();
        end,
    
        --OnExecute = function(go)
        --end,
        
        OnExit = function(go)
            --go:ToggleRenderAndUpdate();
        end,
    },
    ---------------------------------------------------------------------
    show_ready =
    {
        OnEnter = function(go, sm)
        --log("enter @ show_ready")
            --go:Reload();
            
            go["Transform"]:SetTranslate(167, 135);
            go["Sprite"]:SetImage("ui_stat_ready");
            go["Timer"]:Reset(1500);
            
            go["Interpolator"]:AttachUpdateCallback(UpdateGOScale, UIManager:GetWidgetComponent("GameCountdown", "LevelText", "Transform"));
            go["Interpolator"]:ResetTarget(1, 1.5, 200);
            go["Interpolator"]:AppendNextTarget(1.5, 1, 200);            
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("show_go");
            end
        end,    
        
        OnExit = function(go)
        --log("exit @ show_ready")
        end,
    },
    ---------------------------------------------------------------------
    show_go =
    {
        OnEnter = function(go, sm)            
        --log("enter @ show_go")
            go["Transform"]:SetTranslate(188, 136);
            go["Sprite"]:SetImage("ui_stat_go");
            go["Timer"]:Reset(1000);

            go["Interpolator"]:AttachUpdateCallback(UpdateGOScale, UIManager:GetWidgetComponent("GameCountdown", "LevelText", "Transform"));
            go["Interpolator"]:ResetTarget(1, 1.5, 200);
            go["Interpolator"]:AppendNextTarget(1.5, 1, 200);
        end,
    
        OnExecute = function(go, sm)        
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("done");
            end
        end,    
        
        OnExit = function(go)
        --log("exit @ show_go")
        end,
    },
    ---------------------------------------------------------------------
    silent_gameover =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslate(5000, 5000);
            go["Timer"]:Reset(1000);
            
            AudioManager:CreateBgmList(GAME_STAT_BGM);
            AudioManager:PlayBgm(BGM_LEVEL_FAIL);  
            BladeManager:ResetBlade();
        end,

        OnExecute = function(go, sm)        
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("done");
            end
        end,
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
EnemyEnchantStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go, sm)
            go:ToggleRenderAndUpdate();
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm)
            go:ToggleRenderAndUpdate();

            go["Sprite"]:SetAlpha(ALPHA_MAX);
        end,
    },
    ---------------------------------------------------------------------
    freeze =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, JADE_EFFECT_ENEMY_FREEZE);

            go["Sprite"]:SetAlpha(ALPHA_QUARTER);
            go["Timer"]:Reset(ENCHANT_FREEZE_DURATION);

            EnemyManager:SetHalfSpeed(args);

            args["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(2.5);

			args["Attribute"]:Set("stateFreezed", true);

            if (args["Motion"]:IsOnMotion()) then
                args["StateMachine"]:ChangeState(args["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
            end
            
            BatchUpdateAchievement(ACH_FREEZE_COUNT_LV1);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
            EnemyManager:SetSpeed(args);

            args["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(1);
            
			args["Attribute"]:Clear("stateFreezed");

            if (args["Attribute"]:Get("life") > 0 and args["Motion"]:IsOnMotion()) then
                args["StateMachine"]:ChangeState(args["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
            end
        end,
    },
    ---------------------------------------------------------------------
    freeze_scroll =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, JADE_EFFECT_ENEMY_FREEZE);

            go["Sprite"]:SetAlpha(ALPHA_QUARTER);
            
            EnemyManager:SetHalfSpeed(args);

            args["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(2.5);

            if (args["Motion"]:IsOnMotion()) then
                args["StateMachine"]:ChangeState(args["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
            end
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm, args)
            EnemyManager:SetSpeed(args);

            args["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(1);

            if (args["Attribute"]:Get("life") > 0 and args["Motion"]:IsOnMotion()) then
                args["StateMachine"]:ChangeState(args["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
            end
        end,
    },
    ---------------------------------------------------------------------
    stun =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, JADE_EFFECT_ENEMY_STUN);

            go["Timer"]:Reset(ENCHANT_STUN_DURATION);
            
			args["Attribute"]:Set("stateStunned", true);
            
            BatchUpdateAchievement(ACH_STUN_COUNT_LV1);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
            --EnemyManager:SetSpeed(args);

			args["Attribute"]:Clear("stateStunned");            

            if (args["Attribute"]:Get("life") > 0) then
                args["StateMachine"]:ChangeState(args["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
            end
        end,
    },
    ---------------------------------------------------------------------
    heal =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, ENEMY_EFFECT_HEAL);

            go["Sprite"]:SetAlpha(ALPHA_QUARTER);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,
    },
    ---------------------------------------------------------------------
    heal_boss =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, ENEMY_EFFECT_HEAL);

            go["Sprite"]:SetAlpha(ALPHA_QUARTER);
            go["Transform"]:SetScale(2.0);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
            go["Transform"]:SetScale(1.0);
        end,
    },
    ---------------------------------------------------------------------
    cask_wounded =
    {
        OnEnter = function(go, sm, args)
            local id = EFFECT_OBJECTS[ args["Attribute"]:Get("template")[ENEMY_TEMPLATE_LOOK] ];
            if (id) then
                SetEnemyEnchant(args, go, id);
            end
            --SetEnemyEnchant(args, go, ENEMY_EFFECT_CASK);
            go["Sprite"]:SetAlpha(ALPHA_QUARTER);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
        end,
    },
--[[    
    ---------------------------------------------------------------------
    parry_break =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, JADE_EFFECT_PARRY_BREAK);

            go["Sprite"]:SetAlpha(ALPHA_QUARTER);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    poison =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, JADE_EFFECT_ENEMY_POISON);

            go["Timer"]:Reset(ENCHANT_POISON_DURATION);
            
            go["Attribute"]:Set("poison", ENCHANT_POISON_COUNT);
        end,

        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
                local count = go["Attribute"]:Modify("poison", -1);                
                if (count > 0) then
                    EnemyManager:HurtEnemyByPoison(args);
                    go["Timer"]:Reset(ENCHANT_POISON_DURATION);
                else
                    sm:ChangeState("inactive");
                end
            end
        end,

        OnExit = function(go, sm, args)
        end,
    },
    ---------------------------------------------------------------------
    poison_scroll =
    {
        OnEnter = function(go, sm, args)
            SetEnemyEnchant(args, go, JADE_EFFECT_ENEMY_POISON);

            go["Timer"]:Reset(ENCHANT_POISON_DURATION);
        end,

        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
                EnemyManager:HurtEnemyByPoison(args);
                go["Timer"]:Reset(ENCHANT_POISON_DURATION);
            end
        end,

        OnExit = function(go, sm, args)
        end,
    },
--]]    
};

-------------------------------------------------------------------------
DistanceCounterStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go, sm)
            go["Timer"]:Reset();
        end,

        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
                go["Timer"]:Reset();
                LevelManager:UpdateDistanceEvents(args:ModifyValue(1));
            end
        end,
    },
};

-------------------------------------------------------------------------
ShopSellerStates =
{
    ---------------------------------------------------------------------
    idle =
    {
        OnEnter = function(go, sm)
            go["Sprite"]:SetAnimation("ui_shop_seller_idle", true);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    buy =
    {
        OnEnter = function(go, sm)
            go["Sprite"]:SetAnimation("ui_shop_seller_buy", true);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("idle");
            end
        end,

        OnExit = function(go, sm)
        end,
    },
};

-------------------------------------------------------------------------
UIPlayButtonStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
            go:EnableRender(false);
        end,

        OnExecute = function(go, sm)
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    blink =
    {
        OnEnter = function(go)
            go:EnableRender(true);
            go["Sprite"]:SetAlpha(ALPHA_MAX);
            go["Fade"]:ResetTarget(ALPHA_MAX, ALPHA_HALF, 500);
        	go["Fade"]:AppendNextTarget(ALPHA_HALF, ALPHA_MAX, 500);
        	go["Fade"]:SetCycling(true);
            
            CycleGOScale(go, 0.95, 1.1, 500);
        end,

--        OnExecute = function(go, sm)
--        end,

        OnExit = function(go, sm)
        end,
    },
};

-------------------------------------------------------------------------
ScrollPreEffectBackdropStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
            --go:EnableRender(false);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm)
            --go:EnableRender(true);
        end,
    },
    ---------------------------------------------------------------------
    enter =
    {
        OnEnter = function(go, sm, args)
            if (args) then
                go["Transform"]:SetTranslate(480, 51 + 107);
                go["Motion"]:AppendNextTarget(0, 51 + 107);
            else
                go["Transform"]:SetTranslate(-480, 52);
                go["Motion"]:AppendNextTarget(0, 52);
            end
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                ScrollManager:StartMagicCircle();
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm)
        end,
    },
};

-------------------------------------------------------------------------
ScrollPreEffectStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go, sm, args)
            go:EnableRender(false);
            args:EnableRender(false);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm, args)
            go:EnableRender(true);
            args:EnableRender(true);
        end,
    },
    ---------------------------------------------------------------------
    enter =
    {
        OnEnter = function(go, sm, args)
    		go["Transform"]:SetScale(MAGIC_CIRCLE_SCALE);
    		go["Interpolator"]:AttachUpdateCallback(UpdateRotateScaleMCOuter, go["Transform"]);
    		go["Interpolator"]:ResetTarget(0, 1, MAGIC_CIRCLE_DURATION);

    		args["Transform"]:SetScale(MAGIC_CIRCLE_SCALE);
    		args["Interpolator"]:AttachUpdateCallback(UpdateRotateScaleMCInner, args["Transform"]);
    		args["Interpolator"]:ResetTarget(0, 1, MAGIC_CIRCLE_DURATION);
            args["Sprite"]:EnableRender(2, false);
            
            AudioManager:PlaySfx(SFX_SCROLL_CIRCLE);
        end,

        OnExecute = function(go, sm, args)
            if (go["Interpolator"]:IsDone()) then
                sm:ChangeState("exit", args);
            end
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    exit =
    {
        OnEnter = function(go, sm, args)
            args["Sprite"]:EnableRender(2, true);

            go["Timer"]:Reset();

            AudioManager:PlaySfx(SFX_SCROLL_SYMBOL);
        end,

        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive", args);
            end
        end,

        OnExit = function(go, sm)
            StageManager:PopStage();
            StageManager:PushStage("GameScroll");
        end,
    },
};

-------------------------------------------------------------------------
DoorStates =
{
    opened_left =
    {
        OnEnter = function(go)
            go["Transform"]:SetTranslateEx(DOOR_OPEN_LEFT_POS);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    opened_right =
    {
        OnEnter = function(go)
            go["Transform"]:SetTranslateEx(DOOR_OPEN_RIGHT_POS);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    opening_left =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslateEx(DOOR_CLOSE_LEFT_POS);
            go["Motion"]:ResetTarget(DOOR_CLOSE_LEFT_POS[1] + 5, DOOR_CLOSE_LEFT_POS[2]);
            go["Motion"]:AppendNextTarget(DOOR_OPEN_LEFT_POS[1], DOOR_OPEN_LEFT_POS[2]);
            
            AudioManager:PlayDoorSfx(true);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("opened_left");
            end
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    opening_right =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslateEx(DOOR_CLOSE_RIGHT_POS);
            go["Motion"]:ResetTarget(DOOR_CLOSE_RIGHT_POS[1] - 5, DOOR_CLOSE_RIGHT_POS[2]);
            go["Motion"]:AppendNextTarget(DOOR_OPEN_RIGHT_POS[1], DOOR_OPEN_RIGHT_POS[2]);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("opened_right");
            end
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    closed_left =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslateEx(DOOR_CLOSE_LEFT_POS);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    closed_right =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslateEx(DOOR_CLOSE_RIGHT_POS);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    closing_left =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslateEx(DOOR_OPEN_LEFT_POS);
            go["Motion"]:ResetTarget(DOOR_CLOSE_LEFT_POS[1], DOOR_CLOSE_LEFT_POS[2]);

            AudioManager:PlayDoorSfx(false);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("shake", "closed_left");
            end
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    closing_right =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslateEx(DOOR_OPEN_RIGHT_POS);
            go["Motion"]:ResetTarget(DOOR_CLOSE_RIGHT_POS[1], DOOR_CLOSE_RIGHT_POS[2]);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("shake", "closed_right");
            end
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    shake =
    {
        OnEnter = function(go, sm)
            go["Shaker"]:Shake();
        end,

        OnExecute = function(go, sm, args)
            if (go["Shaker"]:IsDone()) then
                sm:ChangeState("delay", args);
            end
        end,

        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    delay =
    {
        OnEnter = function(go, sm)
            go["Timer"]:Reset();
        end,

        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState(args);
            end
        end,

        OnExit = function(go, sm)
        end,
    },
};

-------------------------------------------------------------------------
CastleScrollClock =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go, sm, args)
    		g_UpdateManager:AddObject(go, BACKDROP_GROUP);

            EnemyManager:SetLaunchEnchant(args);
            --ScrollManager:AddEffectsToRenderQueue();
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go, sm, args)
            EnemyManager:RemoveAllEnemiesEnchant(args);
            EnemyManager:SetLaunchEnchant(nil);
            --ScrollManager:RemoveEffectsFromRenderQueue();
            LevelManager:UnloadCastleEffect();
    		AudioManager:StopSfx(SFX_SCROLL_FREEZE);

    		g_UpdateManager:RemoveObject(go, BACKDROP_GROUP);
        end,
    },
};

-------------------------------------------------------------------------
UIStatStates =
{
    inactive =
    {
        OnEnter = function(go)
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    idle =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("ui_stat_background_idle", true);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    opening =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("ui_stat_background_open", true);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("idle");
            end
        end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    close_wait =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("ui_stat_background_close", true);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("wait");
            end
        end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    close_wait_open =
    {
        OnEnter = function(go)
            go["Sprite"]:SetAnimation("ui_stat_background_close", true);
        end,

        OnExecute = function(go, sm)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("wait", true);
            end
        end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    wait =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(300);
        end,

        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
                if (args) then
                    sm:ChangeState("opening");
                else
                    sm:ChangeState("inactive");
                end
            end
        end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    delay =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(1000);
        end,
    
        OnExecute = function(go, sm, args)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState(args);
            end
        end,    
    },
    ---------------------------------------------------------------------
    exp =
    {
        OnEnter = function(go, sm, initial)
            LevelManager:AccumulateExp(initial);
        end,
    
        OnExecute = function(go, sm)
            if (UIManager:GetWidgetComponent("AvatarStat", "ExpBar", "Interpolator"):IsDone()) then
                if (UIManager:GetWidget("AvatarStat", "ExpBar"):GetValue() >= LevelManager:GetMaxExp()) then
                    sm:ChangeState("delay", "levelup");
                else
                    sm:ChangeState("delay", "inactive");
                end
            end
        end,    
    },
    ---------------------------------------------------------------------
    levelup =
    {
        OnEnter = function(go)
            LevelManager:LevelUpAvatar();
        end,
    
        OnExecute = function(go, sm)
            if (UIManager:GetWidgetComponent("AvatarStat", "AvatarLv", "Interpolator"):IsDone()) then
                sm:ChangeState("delay", "maxup");
            end
        end,    
    },
    ---------------------------------------------------------------------
    maxup =
    {
        OnEnter = function(go)            
            LevelManager:AccumulateMaxLifeAndEnergy();
        end,
    
        OnExecute = function(go, sm)
            if (UIManager:GetWidgetComponent("AvatarStat", "EnergyBar", "Interpolator"):IsDone()) then
                LevelManager:ReaccumulateExp(sm);
            end
        end,    
    },
    ---------------------------------------------------------------------
    maxlevel =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(1800);
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,    
    },
};

--[[
MEDAL_EFFECT_POS =
{
    { 113, -19 },
    { 138, -19 },
    { 163, -19 },
};
MEDAL_OFFSET = { 87, 19 };
-------------------------------------------------------------------------
UIMedalEffectStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------    
    active =
    {
        OnEnter = function(go, sm, args)
            go["Transform"]:SetTranslateEx(MEDAL_EFFECT_POS[args]);
    		go["Sprite"]:ResetAnimation("ui_medal1", true);
        end,

        OnExecute = function(go, sm, args)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("finish", args);
            end
        end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------    
    finish =
    {
        OnEnter = function(go, sm, args)
            local pos = MEDAL_EFFECT_POS[args];
            go["Transform"]:SetTranslate(pos[1] + MEDAL_OFFSET[1], pos[2] + MEDAL_OFFSET[2]);
    		go["Sprite"]:ResetAnimation("ui_medal2", true);
        end,

        OnExecute = function(go, sm, args)
            if (go["Sprite"]:IsDone()) then
        		UIManager:GetWidgetComponent("InGame", "Medal", "Sprite"):SetImage(args, "ui_medal_02");
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go)
        end,
    },
};
--]]

-------------------------------------------------------------------------
UIMedalDistanceStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------    
    active =
    {
        OnEnter = function(go, sm, args)
--[[        
            UIManager:GetWidgetComponent("Medal", "MedalEffect", "StateMachine"):ChangeState("active", args);
--]]
    		go["Sprite"]:ResetAnimation(LevelManager:GetMedalImageName(), true);
        end,

        OnExecute = function(go, sm, args)
            if (go["Sprite"]:IsDone()) then
                sm:ChangeState("inactive");
        		UIManager:ToggleUI("Medal");
            end
        end,

        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
UIReviveStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    show =
    {
        OnEnter = function(go)
            BladeManager:DeactivateEnergyTip();

            UIManager:EnableWidget("Revive", "Clock", false);
            UIManager:GetWidget("Revive", "Action"):Enable(false);
            
			go["Transform"]:SetTranslate(UI_REVIVE_POS[1], UI_REVIVE_POS[2] + REVIVE_UI_OFFSET);
            go["Timer"]:Reset(REVIVE_DELAY_DURAION);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("motion");
--[[ @Challenge No Revival
                if (LevelManager:IsChallengeMode()) then
                    sm:ChangeState("inactive");

                    UIManager:ToggleUI("Revive");
                    StageManager:ChangeStage("GameCountdown");
                else
                    sm:ChangeState("motion");
                end
--]]
            end
        end,
    },
    ---------------------------------------------------------------------
    motion =
    {
        OnEnter = function(go)
			go["Motion"]:ResetTarget(UI_REVIVE_POS[1], UI_REVIVE_POS[2]);
            AudioManager:PlaySfx(SFX_UI_START_GAME);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("active");
            end
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
            local widget = UIManager:GetWidget("Revive", "Clock");
            widget:SetValue(100);
            
            local interGC = UIManager:GetWidgetComponent("Revive", "Clock", "Interpolator");
            interGC:AttachUpdateCallback(UpdateWidgetNumber, widget);
            interGC:ResetTarget(100, 0, REVIVE_WAIT_DURAION);
            
            UIManager:GetWidget("Revive", "Action"):Enable(true);
            UIManager:EnableWidget("Revive", "Clock", true);

            go["Timer"]:Reset(REVIVE_WAIT_DURAION);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                UIManager:GetWidget("Revive", "Action"):Enable(false);
                UIManager:EnableWidget("Revive", "Clock", false);
                sm:ChangeState("leave");
            end
        end,
    },
    ---------------------------------------------------------------------
    leave =
    {
        OnEnter = function(go)
            go["Motion"]:ResetTarget(UI_REVIVE_POS[1], UI_REVIVE_POS[2] + REVIVE_UI_OFFSET);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go)
            ReviveInaction(true);
        end,
    },
--[[    
    ---------------------------------------------------------------------
    challenge =
    {
        OnEnter = function(go)
            BladeManager:DeactivateEnergyTip();

            UIManager:EnableWidget("Revive", "Clock", false);
            UIManager:GetWidget("Revive", "Action"):Enable(false);
            
			go["Transform"]:SetTranslate(UI_REVIVE_POS[1], UI_REVIVE_POS[2] + REVIVE_UI_OFFSET);
            go["Timer"]:Reset(REVIVE_DELAY_DURAION);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("inactive");
            end
        end,

        OnExit = function(go)
            UIManager:ToggleUI("Revive");
            StageManager:ChangeStage("GameCountdown");
        end,
    },
--]]    
--[[    
    ---------------------------------------------------------------------
    revive =
    {
        OnEnter = function(go, sm)
            sm:ChangeState("inactive");
            UIManager:ToggleUI("Revive");
        end,

        --OnExecute = function(go, sm)
        --end,

        --OnExit = function(go)
        --end,
    },
--]]
};

-------------------------------------------------------------------------
UIBoostStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go, sm)
            sm:LockState("inactive");
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm)
    		UIManager:ToggleUI("Boost");
            sm:UnlockState("inactive");
        end,
    },
    ---------------------------------------------------------------------
    show =
    {
        OnEnter = function(go)
            UIManager:GetWidget("Boost", "Action"):Enable(false);
            
			go["Transform"]:SetTranslate(UI_BOOST_POS[1] + UI_BOOST_OFFSET, UI_BOOST_POS[2]);
            go["Motion"]:ResetTarget(UI_BOOST_POS[1], UI_BOOST_POS[2]);
            
            AudioManager:PlaySfx(SFX_OBJECT_JADE);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("active");
            end
        end,

        OnExit = function(go)            
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
            UIManager:GetWidget("Boost", "Action"):Enable(true);

            go["Timer"]:Reset(BOOST_WAIT_DURAION);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                LevelManager:LogBoostEvent(false);
                sm:ChangeState("leave");
            end
        end,

        OnExit = function(go)            
            UIManager:GetWidget("Boost", "Action"):Enable(false);
        end,
    },
    ---------------------------------------------------------------------
    leave =
    {
        OnEnter = function(go)
            go["Motion"]:ResetTarget(UI_BOOST_POS[1] + UI_BOOST_OFFSET, UI_BOOST_POS[2]);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("reset");
            end
        end,
    },
    ---------------------------------------------------------------------
    reset =
    {
        OnEnter = function(go, sm)
			go["Transform"]:SetTranslate(UI_BOOST_POS[1] + UI_BOOST_OFFSET, UI_BOOST_POS[2]);
            go["Motion"]:Reset();
            sm:ChangeState("inactive");
            UIManager:ToggleUI("Boost");
        end,
    },
};

-------------------------------------------------------------------------
JadeStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    trigger =
    {
        OnEnter = function(go)
            JadeTriggered();

            go["Interpolator"]:ResetTarget(1.0, 1.2, 250);
            go["Interpolator"]:AppendNextTarget(1.2, 0.95, 250);
            go["Interpolator"]:AppendNextTarget(0.95, 1.0, 100);
            go["Fade"]:ResetTarget(ALPHA_QUARTER, ALPHA_MAX, 600);
        end,
    
        OnExecute = function(go, sm)
            if (go["Interpolator"]:IsDone()) then
                sm:ChangeState("inactive");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
ScrollCooldownStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    freeze =
    {
        OnEnter = function(go)
    		UIManager:GetWidget("InGame", "Scroll"..go["Attribute"]:Get("Index")):Enable(false);
    		go["Sprite"]:EnableRender(2, true);
        end,
        
        OnExit = function(go)
    		go["Sprite"]:EnableRender(2, false);
        end,
    },
    ---------------------------------------------------------------------
    cooldown =
    {
        OnEnter = function(go, sm, cooldown)
        --log("cooldown")        
            local width, height = go["Sprite"]:GetSize();
            --log("cd duration : "..ScrollManager:GetCooldownDuration())
			go["Interpolator"]:AttachCallback(UpdateScrollCooldown, EndScrollCooldown, go);
            --go["Interpolator"]:ResetTarget(height, 0, ScrollManager:GetCooldownDuration());
            go["Interpolator"]:ResetTarget(height, 0, cooldown);
			go["Interpolator"]:SetCycling(false);

    		go["Sprite"]:EnableRender(2, true);
        end,
        
        OnExit = function(go)
    		go["Sprite"]:EnableRender(2, false);
        end,
    },
    ---------------------------------------------------------------------
    restore =
    {
        OnEnter = function(go)
            go["Interpolator"]:AttachCallback(UpdateGOScale, nil, go["Transform"]);
            go["Interpolator"]:ResetTarget(0.7, 1.3, 175);
            go["Interpolator"]:AppendNextTarget(1.3, 1.0, 175);
			go["Interpolator"]:SetCycling(false);

            AudioManager:PlaySfx(SFX_OBJECT_BOOST);
        end,
    
        OnExecute = function(go, sm)
            if (go["Interpolator"]:IsDone()) then
                ScrollManager:RestoreScroll(go["Attribute"]:Get("Index"));
                sm:ChangeState("active");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
			go["Interpolator"]:AttachUpdateCallback(UpdateScrollSlot, go);
			go["Interpolator"]:ResetTarget(ALPHA_MAX, ALPHA_HALF, 400);
			go["Interpolator"]:AppendNextTarget(ALPHA_HALF, ALPHA_MAX, 400);
			go["Interpolator"]:SetCycling(true);
        end,
    
        --OnExecute = function(go, sm)
        --end,    
        
        OnExit = function(go)
            go["Interpolator"]:Reset();
            go["Transform"]:SetScale(1.0);
            go["Sprite"]:SetAlpha(ALPHA_MAX);
        end,
    },    
};

-------------------------------------------------------------------------
UICreditStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    move_begin =
    {
        OnEnter = function(go)
            go["Transform"]:SetTranslate(UI_CREDIT_POS[1] + SCREEN_UNIT_X, UI_CREDIT_POS[2]);
            go["Timer"]:Reset(500);
        end,
    
        OnExecute = function(go, sm, nextState)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("move_in");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    move_in =
    {
        OnEnter = function(go)
            local page = go["Attribute"]:Modify("Page", 1);
            go["Sprite"]:SetImage("credit_0"..page);
            go["Motion"]:ResetTarget(UI_CREDIT_POS[1], UI_CREDIT_POS[2]);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("move_wait");
            end
        end,    
        
        OnExit = function(go)
        end,
    }, 
    ---------------------------------------------------------------------
    move_wait =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(2500);
        end,
    
        OnExecute = function(go, sm, nextState)
            if (go["Timer"]:IsOver()) then
                local page = go["Attribute"]:Get("Page");

                if (page == UI_CREDIT_PAGE_MAX) then
                    --UpdateAchievement(ACH_MONKEY_POTION);
                    sm:ChangeState("inactive");
                else
                    sm:ChangeState("move_out");
                end
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    move_out =
    {
        OnEnter = function(go)
            local x, y = go["Transform"]:GetTranslate();
            go["Motion"]:ResetTarget(x - SCREEN_UNIT_X * 0.5, y);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("move_begin");
            end
        end,    
        
        OnExit = function(go)
        end,
    }, 
};

--[[

-------------------------------------------------------------------------
WeaponSlotStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)
            go["Interpolator"]:AttachCallback(UpdateGOScale, nil, go["Transform"]);
            go["Interpolator"]:ResetTarget(0.9, 1.5, 175);
            go["Interpolator"]:AppendNextTarget(1.5, 1.0, 175);
			go["Interpolator"]:SetCycling(false);
        end,
    
        OnExecute = function(go, sm)
            if (go["Interpolator"]:IsDone()) then
                sm:ChangeState("cycle");
            end
        end,    
    },
    ---------------------------------------------------------------------
    cycle =
    {
        OnEnter = function(go)
			go["Interpolator"]:AttachUpdateCallback(UpdateWeaponSlot, go);
			go["Interpolator"]:ResetTarget(ALPHA_MAX, ALPHA_HALF, 300);
			go["Interpolator"]:AppendNextTarget(ALPHA_HALF, ALPHA_MAX, 300);
			go["Interpolator"]:SetCycling(true);
        end,
        
        OnExit = function(go)
            go["Interpolator"]:Reset();
            go["Transform"]:SetScale(1.0);
            go["Sprite"]:SetAlpha(ALPHA_MAX);
        end,
    },    
};
-------------------------------------------------------------------------
UIWeaponSlotStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    active =
    {
        --OnEnter = function(go)
        --end,
    
        OnExecute = function(go, sm, index)
            if (go["Motion"]:IsDone()) then
                UIManager:MoveWidgetToLast("InGame", "Weapon"..index);
                BladeManager:ChangeWeapon(index);
                sm:ChangeState("inactive");
            end
        end,    
        
        --OnExit = function(go)
        --end,
    },
};
--]]

-------------------------------------------------------------------------
UITutorialHandStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
        --log("hand @ inactive")
        	UIManager:EnableWidget("Tutorial", "Hand", false);
        end,
    
        --OnExecute = function(go)
        --end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    slash =
    {
        OnEnter = function(go)
        --log("hand @ slash")
        	UIManager:EnableWidget("Tutorial", "Hand", true);
        	UIManager:GetWidget("Tutorial", "Hand"):SetImage("ui_tutorial_hand_slash");
            go["Transform"]:SetTranslateEx(TUTORIAL_SLASH_POS);
            go["Motion"]:ResetTarget(TUTORIAL_SLASH_TARGET[1], TUTORIAL_SLASH_TARGET[2]);
        end,
    
        OnExecute = function(go, sm, index)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("wait", "slash");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    swipe =
    {
        OnEnter = function(go)
        --log("hand @ swipe")
        	UIManager:EnableWidget("Tutorial", "Hand", true);
        	UIManager:GetWidget("Tutorial", "Hand"):SetImage("ui_tutorial_hand_slash");
            go["Transform"]:SetTranslateEx(TUTORIAL_SWIPE_POS);
            go["Motion"]:ResetTarget(TUTORIAL_SWIPE_TARGET[1], TUTORIAL_SWIPE_TARGET[2]);
        end,
    
        OnExecute = function(go, sm, index)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("wait", "swipe");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    tap =
    {
        OnEnter = function(go, sm, index)
        --log("hand @ swipe")
            local pos = TUTORIAL_TAP_POS[index];
        	UIManager:EnableWidget("Tutorial", "Hand", true);
        	UIManager:GetWidget("Tutorial", "Hand"):SetImage("ui_tutorial_arrow");
            go["Transform"]:SetTranslateEx(pos);
            
            go["Motion"]:SetVelocity(50);
            go["Motion"]:SetCycling(true);
            go["Motion"]:ResetTarget(pos[1] + 20, pos[2]);
            go["Motion"]:AppendNextTarget(pos[1], pos[2]);
        end,
    
        OnExecute = function(go, sm, index)
        end,    
        
        OnExit = function(go)
            go["Motion"]:SetVelocity(150);
            go["Motion"]:SetCycling(true);
        end,
    },
    ---------------------------------------------------------------------
    wait =
    {
        OnEnter = function(go)
        --log("hand @ wait")
            go["Timer"]:Reset();
        end,
    
        OnExecute = function(go, sm, state)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState(state);
            end
        end,    
        
        OnExit = function(go)
        end,
    },
};

-------------------------------------------------------------------------
UIHandStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    show =
    {
        OnEnter = function(go)
            go["Sprite"]:EnableRender(2, true);
            go["Sprite"]:SetAlpha(2, ALPHA_HALF);
            
            go["Timer"]:Reset(2500);
            go["Interpolator"]:ResetTarget(ALPHA_HALF, ALPHA_MAX, 800);
        end,
    
        OnExecute = function(go, sm)
            go["Sprite"]:SetAlpha(2, go["Interpolator"]:GetValue());
            
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("hide");
            end
        end,    
    },
    ---------------------------------------------------------------------
    hide =
    {
        OnEnter = function(go)
            go["Timer"]:Reset(800);
            go["Interpolator"]:ResetTarget(ALPHA_MAX, ALPHA_HALF, 800);
        end,

        OnExecute = function(go, sm)
            go["Sprite"]:SetAlpha(2, go["Interpolator"]:GetValue());
            
            if (go["Timer"]:IsOver()) then
                go["Sprite"]:EnableRender(2, false);
                sm:ChangeState("inactive");
            end
        end,    
    },
    ---------------------------------------------------------------------
    reset =
    {
        OnEnter = function(go, sm)
            go["Sprite"]:EnableRender(2, false);
            sm:ChangeState("inactive");
        end,
    },
};

-------------------------------------------------------------------------
BossControllerStates =
{
    ---------------------------------------------------------------------
    inactive =
    {
    },
    ---------------------------------------------------------------------
    enter =
    {
        OnEnter = function(go)
            g_UpdateManager:AddObject(go, ENEMY_GROUP);

            AudioManager:SetCurrentBgmVolumeCallback(go);
            go["Interpolator"]:ResetTarget(1.0, 0.1, 5000); --4000);
            
            AudioManager:CreateBgmList(GAME_BOSS_BGM);
        end,
    
        OnExecute = function(go, sm)
            if (go["Interpolator"]:IsDone()) then
                LevelManager:ReloadBossTexture();
                sm:ChangeState("lifebar_moving");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    lifebar_moving =
    {
        OnEnter = function(go)
            local x, y = UIManager:GetUITranslate("BossLifebar");
            UIManager:SetUITranslate("BossLifebar", x, y + 100);
            UIManager:GetUIComponent("BossLifebar", "Motion"):ResetTarget(x, y);
            UIManager:ToggleUI("BossLifebar");            
            UIManager:EnableWidget("BossLifebar", "BossBarFire", false);
            
            UIManager:GetWidget("BossLifebar", "BossBar"):SetMaxValue(LevelManager:GetBossMaxLife());
            UIManager:GetWidget("BossLifebar", "BossBar"):SetValue(0);
            
    		UIManager:EnableWidget("InGame", "DistanceCounter", false);
            LevelManager:EnableDistanceCounter(false);
        end,
    
        OnExecute = function(go, sm)
            if (UIManager:GetUIComponent("BossLifebar", "Motion"):IsDone()) then
                sm:ChangeState("wait", "lifebar_fire");
            end
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    wait =
    {    
        OnEnter = function(go)
            go["Timer"]:Reset(750);
        end,
    
        OnExecute = function(go, sm, nextState)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState(nextState);
            end
        end,
    },
    ---------------------------------------------------------------------
    lifebar_fire =
    {    
        OnEnter = function(go)
            UIManager:EnableWidget("BossLifebar", "BossBarFire", true);
            AudioManager:PlaySfx(SFX_CHAR_NINJA_ESCAPE);
        end,
    
        OnExecute = function(go, sm)
            if (UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Interpolator"):IsDone()) then
                sm:ChangeState("wait", "lifebar_accum");
            end
        end,    
    },
    ---------------------------------------------------------------------
    lifebar_accum =
    {    
        OnEnter = function(go)
            --log("Boss Max Life: "..LevelManager:GetBossMaxLife());
            UIManager:EnableWidget("BossLifebar", "BossBarFire", true);
            UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Interpolator"):ResetTarget(0, LevelManager:GetBossMaxLife(), 800);
            AudioManager:PlaySfx(SFX_UI_STAT_ACCUM);
        end,
    
        OnExecute = function(go, sm)
            if (UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Interpolator"):IsDone()) then
                sm:ChangeState("launch");
            end
        end,    
     },
    ---------------------------------------------------------------------
    launch =
    {
        OnEnter = function(go)
            AudioManager:PlayBgm(BGM_BOSS_ENTER);
        end,

        OnExecute = function(go, sm)
            if (AudioManager:IsCurrentBgmDone()) then
                LevelManager:LaunchBoss();
                sm:ChangeState("idle");
            end
        end,    
    },
    ---------------------------------------------------------------------
    idle =
    {
    },
    ---------------------------------------------------------------------
    exit =
    {
        OnEnter = function(go)
            AudioManager:SetCurrentBgmVolumeCallback(go);
            
            -- NOTE: Timer must be greater than Interpolator time
            local bgmFadeTime = 5500; --4000;
            local shakeTime = 6000; --5000;
            assert(bgmFadeTime < shakeTime);

            go["Interpolator"]:ResetTarget(1.0, 0.1, bgmFadeTime);
            go["Timer"]:Reset(shakeTime);
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("finish");
            else
                if (UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Shaker"):IsDone()) then
                    UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Shaker"):Shake();
                end
            end
        end,
        
        OnExit = function(go)
            UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Shaker"):Reset();
            UIManager:EnableWidget("BossLifebar", "BossBarFire", false);
        end,
    },
    ---------------------------------------------------------------------
    finish =
    {
        OnEnter = function(go)
            local x, y = UIManager:GetUITranslate("BossLifebar");
            UIManager:GetUIComponent("BossLifebar", "Motion"):ResetTarget(x, y + 100);
        end,

        OnExecute = function(go, sm)
            if (UIManager:GetUIComponent("BossLifebar", "Motion"):IsDone()) then
                LevelManager:RecoverFromBossMode();
                sm:ChangeState("inactive");
            end
        end,    
    },
};
