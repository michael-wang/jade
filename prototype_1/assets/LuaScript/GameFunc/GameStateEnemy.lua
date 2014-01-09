--***********************************************************************
-- @file GameStateEnemy.lua
--***********************************************************************

-------------------------------------------------------------------------
EnemyStates =
{
    ---------------------------------------------------------------------
	idle =
	{
	
	},
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
			go["Transform"]:SetTranslate(-999, 0);
			go["Motion"]:Reset();
        end,
    },
    ---------------------------------------------------------------------
    initial =
    {
        OnEnter = function(go, sm)
			sm:UnlockAllStates();
        end,
    
        OnExecute = function(go, sm)
			local skill = go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_BIRTH];
            if (not skill) then
    			go["Transform"]:SetTranslate(LevelManager:GetEnemyBirthPos(go));
            end

			AudioManager:PlaySfx(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_BIRTH]);
            sm:ChangeState(skill or "move");
        end,
    },
    ---------------------------------------------------------------------
    move =
    {
        OnEnter = function(go)
            local targetX, targetY = LevelManager:GetEnemyTargetPos(go);
            local range = go["Attribute"]:Get("template")[ENEMY_TEMPLATE_RANGE];
            targetX = targetX - range + math.random(-15, 15);

            go["Motion"]:ResetTarget(targetX, targetY);

            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_PREATTACK] or "preattack");
            end
        end,
    },
    ---------------------------------------------------------------------
    preattack =
    {
        OnEnter = function(go)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);

			go["Attribute"]:Set("skillUsed", true);
			
            go["Timer"]:Reset(ENEMY_DURATION_ATTACK);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_ATTACK] or "attack");
            end
        end,
    },
    ---------------------------------------------------------------------
    attack =
    {
        OnEnter = function(go)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_ATTACK);
        end,

        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("preattack");
            end
        end,
    },
    ---------------------------------------------------------------------
    die =
    {
        OnEnter = function(go, sm, args)
            sm:LockState("die");

			-- NOTE: Must do RemoveAllEnchants() before go["Motion"]:Reset()
			EnemyKilled(go);
            
            go["Motion"]:Reset();
            go["Timer"]:Reset(SPLIT_DURATION);
            
			if (args == nil) then
			-- Normal status
				SpliteSprite(go);
			else
			-- Special no-split status
				EnemyManager:SetAnimation(go, ENEMY_ANIM_HIT);
			    go["Interpolator"]:ResetTarget(ALPHA_MAX, 0, SPLIT_DURATION);
			    go["Interpolator"]:AttachUpdateCallback(UpdateGOAlpha, go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE));
			end
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
				EnemyManager:LaunchDrop(go);				
                EnemyManager:DeactivateEnemy(go);
            end
        end,
        
        OnExit = function(go, sm, args)
            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
    wounded =
    {
        OnEnter = function(go, sm, isKnockBack)
    		local x, y = go["Transform"]:GetTranslate();
    	    go["Motion"]:SetVelocity(ENEMY_PUSHBACK_VELOCITY);
			
			if (isKnockBack) then
	    	    go["Motion"]:ResetTarget(x - 80, y);
			else
	    	    go["Motion"]:ResetTarget(x - 20, y);
			end

            EnemyManager:SetAnimation(go, ENEMY_ANIM_WOUNDED);

			AudioManager:PlaySfxInRandom(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_WOUNDED]);
        end,
    
        OnExecute = function(go, sm)
			-- For shadows
			if (go["Attribute"]:Get("shadow")) then
	            local x, y = go["Transform"]:GetTranslate();
	            go["Attribute"]:Get("shadow")["Transform"]:SetTranslate(x, y + ENEMY_SHADOW_OFFSET);
			end
		
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                EnemyManager:OnEnemyWounded(go, sm);
            end
        end,
        
        OnExit = function(go)
			EnemyManager:RestoreSpeed(go);
        end,
    },
    ---------------------------------------------------------------------
    stunned =
    {
        OnEnter = function(go, sm)
			local width = go["Bound"]:GetSize();
	        go["Motion"]:ResetTarget(-width * 2, go["Transform"]:GetTranslateY());

            EnemyManager:SetAnimation(go, ENEMY_ANIM_STUN);
        end,
    
        OnExecute = function(go, sm)
			if (go["Motion"]:IsDone()) then
				EnemyManager:RemoveAllEnchants(go, false);
				EnemyManager:DeactivateEnemy(go);
			end
        end,
    },
    ---------------------------------------------------------------------
    pushback =
    {
        OnEnter = function(go, sm, dist)
    		local x, y = go["Transform"]:GetTranslate();
    	    go["Motion"]:ResetTarget(x - dist, y);
    	    go["Motion"]:SetVelocity(ENEMY_PUSHBACK_VELOCITY);

            EnemyManager:SetAnimation(go, ENEMY_ANIM_HIT);
        end,
    
        OnExecute = function(go, sm)
			-- For shadows
			if (go["Attribute"]:Get("shadow")) then
	            local x, y = go["Transform"]:GetTranslate();
	            go["Attribute"]:Get("shadow")["Transform"]:SetTranslate(x, y + ENEMY_SHADOW_OFFSET);
			end
		
            if (go["Motion"]:IsDone()) then
                sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
            end
        end,
        
        OnExit = function(go, sm)
			EnemyManager:SetSpeed(go);
        end,
    },
    ---------------------------------------------------------------------
	pushback_die =
    {
        OnEnter = function(go)
    		local x, y = go["Transform"]:GetTranslate();
    	    go["Motion"]:ResetTarget(x - 100, y);
    	    go["Motion"]:SetVelocity(ENEMY_PUSHBACK_VELOCITY);

            EnemyManager:SetAnimation(go, ENEMY_ANIM_HIT);
        end,
    
        OnExecute = function(go, sm)
			-- For shadows
			if (go["Attribute"]:Get("shadow")) then
	            local x, y = go["Transform"]:GetTranslate();
	            go["Attribute"]:Get("shadow")["Transform"]:SetTranslate(x, y + ENEMY_SHADOW_OFFSET);
			end
		
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("die", true);
            end
        end,
        
        OnExit = function(go)
			EnemyManager:SetSpeed(go);
        end,
    },
    ---------------------------------------------------------------------	
	runaway =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
			
			go["Motion"]:SetVelocity(1000);
	        go["Motion"]:ResetTarget(-go["Bound"]:GetSize(), go["Transform"]:GetTranslateY());
        end,
    
        OnExecute = function(go, sm)
			if (go["Motion"]:IsDone()) then
				EnemyManager:DeactivateEnemy(go);
			end
        end,
        
        OnExit = function(go, sm)
			sm:UnlockState("die");
        end,	
	},

    --===================================================================
    -- Tutorial
    --===================================================================
    ---------------------------------------------------------------------
    tutorial_birth =
    {
        OnEnter = function(go, sm)
			local w, h = go["Bound"]:GetSize();
			local x = -w;
			local y = 130;
			local dist = 270;
			go["Transform"]:SetTranslate(x, y);
            go["Motion"]:ResetTarget(x + dist, y);
			
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        --OnExecute = function(go, sm)
		--end,
        
        OnExit = function(go)
        end,
    },	
    ---------------------------------------------------------------------
    tutorial_defend =
    {
        OnEnter = function(go)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

            AudioManager:PlaySfx(SFX_CHAR_SKILL_BLOCK);
        end,

        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("tutorial_idle");
            end
        end,
        
        OnExit = function(go)
        end,
    },	
    ---------------------------------------------------------------------
    tutorial_assault =
    {
        OnEnter = function(go, sm)			
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ASSAULT);
        end,
    
        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("tutorial_idle");
				AudioManager:PlaySfxInRandom(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_MOVE]);
            end
        end,    
        
        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    tutorial_idle =
    {
        OnEnter = function(go)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        --OnExecute = function(go, sm)
        --end,
        
        OnExit = function(go)
        end,
    },	

    --===================================================================
    -- Bullet
    --===================================================================
    ---------------------------------------------------------------------
    skill_bullet =
    {
        OnEnter = function(go, sm)
			EnemyManager:SetAnimation(go, ENEMY_ANIM_ATTACK);

			AudioManager:PlaySfxInRandom(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_MOVE]);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_PREATTACK] or "preattack");
            end
        end,
    },
    ---------------------------------------------------------------------
    skill_bullet_revenge =
    {
        OnEnter = function(go, sm)
			EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);

            go["Timer"]:Reset(ENEMY_DURATION_ATTACK_SP);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_ATTACK] or "attack");
            end
        end,
    },

    --===================================================================
    -- Substitute
    --===================================================================
    ---------------------------------------------------------------------
    skill_substitute =
    {
        OnEnter = function(go, sm)
			if (EnemyManager:HasEnchants(go)) then
				sm:ChangeState("move");
				return;
			end
		
            sm:LockState("die");
        
            go["Motion"]:Reset();
            go["Timer"]:ResetRandRange(ENEMY_DURATION_SKILL_SUBSTITUTE_MIN, ENEMY_DURATION_SKILL_SUBSTITUTE_MAX);
			
			EnemyManager:EnableEnemyLifebar(go, false);

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
			
			AudioManager:PlaySfx(SFX_CHAR_NINJA_ESCAPE);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone() and go["Timer"]:IsOver()) then
                sm:ChangeState("skill_substitute_exit");
            end
        end,    
        
        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    skill_substitute_exit =
    {
        OnEnter = function(go)
			--go["Transform"]:SetTranslate(LevelManager:GetRandMidRangedPos());
			go["Transform"]:SetTranslate(LevelManager:GetRandLongRangedPos());

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,

        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				EnemyManager:EnableEnemyLifebar(go, true);

				local skill = go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_REVENGE];				
	            if (skill and math.random(1, 100) > 50) then
				    sm:ChangeState(skill);
				else
	                sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
				end
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },

    --===================================================================
    -- Fly
    --===================================================================
    ---------------------------------------------------------------------
    skill_fly =
    {
        OnEnter = function(go, sm)
            LevelManager:SetEnemyFlyMovement(go, false);
			
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            local x, y = go["Transform"]:GetTranslate();
            go["Attribute"]:Get("shadow")["Transform"]:SetTranslate(x, y + ENEMY_SHADOW_OFFSET);

            if (go["Motion"]:IsDone()) then
                sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_PREATTACK] or "preattack");
            end
        end,    
        
        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    skill_invincible_fly =
    {
		OnEnter = function(go)
			go["Attribute"]:Set("invincible", true);
			
            LevelManager:SetEnemyFlyMovement(go, false);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
			AudioManager:PlaySfx(SFX_CHAR_SKILL_INVINCIBLE);
        end,
    
        OnExecute = function(go, sm)
            local x, y = go["Transform"]:GetTranslate();
            go["Attribute"]:Get("shadow")["Transform"]:SetTranslate(x, y + ENEMY_SHADOW_OFFSET);

            if (go["Motion"]:IsDone()) then
				go["Attribute"]:Clear("invincible");
				sm:ChangeState("skill_invincible_exit", false);
            end
        end,
    },
    ---------------------------------------------------------------------
	skill_invincible_enter =
    {
        OnEnter = function(go, sm)
			EnemyManager:EnableEnemyLifebar(go, false);

			go["Attribute"]:Set("invincible", true);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("skill_invincible_move");
            end
        end,    
    },
    ---------------------------------------------------------------------
    skill_invincible_move =
    {
		OnEnter = function(go)
            go["Motion"]:ResetTarget(LevelManager:GetRandLongRangedPos());

            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
			AudioManager:PlaySfx(SFX_CHAR_SKILL_INVINCIBLE);
        end,
    
        OnExecute = function(go, sm)
            local x, y = go["Transform"]:GetTranslate();
            go["Attribute"]:Get("shadow")["Transform"]:SetTranslate(x, y + ENEMY_SHADOW_OFFSET);

            if (go["Motion"]:IsDone()) then
                sm:ChangeState("skill_invincible_exit", true);
            end
        end,
    },
    ---------------------------------------------------------------------
	skill_invincible_exit =
    {
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				go["Attribute"]:Clear("invincible");
				if (args) then
					EnemyManager:EnableEnemyLifebar(go, true);
				end
				
                sm:ChangeState("skill_invincible_preattack");
            end
        end,
    },
    ---------------------------------------------------------------------
    skill_invincible_preattack =
    {
        OnEnter = function(go)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_IDLE);

            go["Timer"]:Reset(ENEMY_DURATION_ATTACK);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("skill_bullet");
            end
        end,
    },

    --===================================================================
    -- Assault
    --===================================================================
    ---------------------------------------------------------------------
    skill_assault =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
            
            go["Transform"]:SetTranslate(LevelManager:GetRandMidRangedPos());

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ASSAULT);
        end,
    
        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");

				AudioManager:PlaySfxInRandom(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_MOVE]);
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
    skill_wall =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
            
            LevelManager:SetEnemyWallMovement(go);
        
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
            
            go["Interpolator"]:AttachUpdateCallback(UpdateGOScale, go["Transform"]);
            go["Interpolator"]:ResetTarget(1.8, 1.0, 500);

			AudioManager:PlaySfxInRandom(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_MOVE]);
            
            AddToPostRenderQueue(go);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("skill_wall_exit");
            end
        end,    
        
        OnExit = function(go, sm)
            RemoveFromPostRenderQueue(go);
            
			EnemyManager:SetSpeed(go);
			
            go["Interpolator"]:Reset();
            go["Transform"]:SetScale(1.0);
        end,
    },
    ---------------------------------------------------------------------
    skill_wall_exit =
    {
        OnEnter = function(go, sm)

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
    skill_digout =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
            
            go["Transform"]:SetTranslate(LevelManager:GetRandLongRangedPos());
			-- Offset adjustment
			go["Transform"]:ModifyTranslate(0, -41);

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ASSAULT);
        end,
    
        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");

				AudioManager:PlaySfxInRandom(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_MOVE]);
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");

			-- Offset adjustment
			go["Transform"]:ModifyTranslate(0, 41);
        end,
    },

    --===================================================================
    -- Explosion
    --===================================================================
    ---------------------------------------------------------------------
    skill_explode_enter =
    {
        OnEnter = function(go, sm)
    		go["Transform"]:SetTranslate(LevelManager:GetEnemyBirthPos(go));
			AudioManager:PlaySfx(SFX_CHAR_NINJA_BOMB);

			sm:ChangeState("move");
		end,

        OnExecute = function(go, sm)
        end,    
        
        OnExit = function(go, sm)
        end,
	},	
    ---------------------------------------------------------------------
    skill_explode =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");

			AudioManager:StopSfx(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_BIRTH]);
			EnemyManager:LaunchBomb(go);

            go["Interpolator"]:AttachUpdateCallback(UpdateGOScaleAndAngle, go["Transform"]);
            go["Interpolator"]:ResetTarget(1.0, ENEMY_SCALE_EXPLODE, ENEMY_DURATION_SKILL_EXPLODE);

    		go["Motion"]:SetVelocity(250);
    		go["Motion"]:AppendNextTarget(500, ModifyValueByRandRange(120, 80));
            
            go["Timer"]:Reset(ENEMY_DURATION_SKILL_EXPLODE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                EnemyManager:DeactivateEnemy(go);
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
            
            go["Motion"]:Reset();
            go["Interpolator"]:Reset();
            go["Transform"]:SetScale(1.0);
            go["Transform"]:SetRotateByDegree(0.0);
        end,
    },
    --===================================================================
    -- Summon
    --===================================================================
    ---------------------------------------------------------------------
    skill_summon_move =
    {
        OnEnter = function(go, sm)
            go["Transform"]:SetTranslate(LevelManager:GetEnemyBirthPos(go));
            go["Motion"]:ResetTarget(LevelManager:GetRandLongRangedPos());

            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("skill_summon");
            end
        end,    
        
        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    skill_summon_wounded =
    {
        OnEnter = function(go, sm)
            if (go["Attribute"]:Get("skillUsed")) then
                sm:ChangeState("move");
            else
                if (math.random(1, 100) > 33) then
                    go["Motion"]:ResetTarget(LevelManager:GetRandMidRangedPos());
                    EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
                else
                    go["Motion"]:Reset();
                    sm:ChangeState("skill_summon");
                end
            end
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("skill_summon");
            end
        end,    
        
        OnExit = function(go, sm)
        end,
    },
    ---------------------------------------------------------------------
    skill_summon =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

			EnemyManager:EnableEnemyLifebar(go, false);

            local x, y = go["Transform"]:GetTranslate();
            EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadShogunSummonee, x + 100, y);
            EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadShogunSummonee, x + 40, y - 50);
            EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadShogunSummonee, x + 40, y + 100);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                go["Attribute"]:Set("skillUsed", true);
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
			EnemyManager:EnableEnemyLifebar(go, true);

            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
    skill_summonee =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
        
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ASSAULT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },
    --===================================================================
    -- Enlarge
    --===================================================================
	---------------------------------------------------------------------
	skill_daruma_enter =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
			local x = math.random(0, 50);
			go["Transform"]:SetTranslate(x, -go["Bound"]:GetRadius());
			go["Motion"]:SetVelocity(600);
			go["Motion"]:ResetTarget(x, LevelManager:GetRandFieldY());
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				sm:ChangeState("skill_daruma_enter_done");
            end
        end,
        
        OnExit = function(go, sm)
			EnemyManager:SetSpeed(go);
        end,	
	},
	---------------------------------------------------------------------
	skill_daruma_enter_done =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("move");
            end
        end,
		
        OnExit = function(go, sm)
			--go["Motion"]:SetVelocity(ENEMY_SPEED[1]);
			EnemyManager:RestoreSpeed(go);
			sm:UnlockState("die");
        end,	
	},
    ---------------------------------------------------------------------
	skill_enlarge =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");
			local scale = go["Transform"]:ModifyScale(0.2);
			--local width, height = go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):GetSize();
			local radius = 70; --math.max(width, height) * 0.5;
			go["Bound"]:SetRadius(radius * scale * 0.6);
			
			AudioManager:PlaySfx(SFX_OBJECT_BOOST);
		--local old = go["Transform"]:GetScale();
		--log("ENLARGE: [old] " .. old .. " => " .. scale)
        end,
    
        OnExecute = function(go, sm)
            sm:ChangeState("move");
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,	
	},
    --===================================================================
    -- Shadow Enemy
    --===================================================================
    ---------------------------------------------------------------------
    skill_shadow_summoner =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
        
			AudioManager:PlaySfx(SFX_CHAR_SKILL_HEAL);
            go["Transform"]:SetTranslate(LevelManager:GetRandLongRangedPos());
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ASSAULT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
				EnemyManager:LaunchEnemyWithPosition(Enemy_ObjectPapermanSumonee, x - 15, y - 15);
				EnemyManager:LaunchEnemyWithPosition(Enemy_ObjectPapermanSumonee, x - 15, y + 15);
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
    skill_shadow_summonee =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
        
			AudioManager:PlaySfx(SFX_CHAR_SKILL_HEAL);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ASSAULT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },
	
    --===================================================================
    -- Spawn
    --===================================================================
    ---------------------------------------------------------------------
	skill_spawn_lv1 =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");

            go["Motion"]:Reset();
			
			EnemyManager:RemoveAllEnchants(go, false);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

		    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
		end,
	
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then				
				local x, y = go["Transform"]:GetTranslate();
				EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadGhostSummoneeLv1, x, y + 10);
				EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadGhostSummoneeLv1, x + 30, y - 10);
				EnemyManager:DeactivateEnemy(go);
			end
		end,

        OnExit = function(go, sm)
            sm:UnlockState("die");
		end,
	},
    ---------------------------------------------------------------------
	skill_spawn_lv2 =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");

            go["Motion"]:Reset();
			
			EnemyManager:RemoveAllEnchants(go, false);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

		    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
		end,
	
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then				
				local x, y = go["Transform"]:GetTranslate();
				EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadGhostSummoneeLv2, x, y + 10);
				EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadGhostSummoneeLv2, x + 30, y - 10);
				EnemyManager:DeactivateEnemy(go);
			end
		end,

        OnExit = function(go, sm)
            sm:UnlockState("die");
		end,
	},
    ---------------------------------------------------------------------
	skill_firespawn_lv1 =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");

            go["Motion"]:Reset();
			
			EnemyManager:RemoveAllEnchants(go, false);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

		    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
		end,
	
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then				
				local x, y = go["Transform"]:GetTranslate();
				EnemyManager:LaunchEnemyWithPosition(Enemy_FireSkullSummoneeLv1, x + 20, y + 15);
				EnemyManager:LaunchEnemyWithPosition(Enemy_FireSkullSummoneeLv1, x - 10, y - 15);
				EnemyManager:DeactivateEnemy(go);
			end
		end,

        OnExit = function(go, sm)
            sm:UnlockState("die");
		end,
	},
    ---------------------------------------------------------------------
	skill_firespawn_lv2 =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");

            go["Motion"]:Reset();
			
			EnemyManager:RemoveAllEnchants(go, false);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

		    AudioManager:PlaySfx(SFX_OBJECT_BOOST);
		end,
	
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then				
				local x, y = go["Transform"]:GetTranslate();
				EnemyManager:LaunchEnemyWithPosition(Enemy_FireSkullSummoneeLv2, x + 20, y + 15);
				EnemyManager:LaunchEnemyWithPosition(Enemy_FireSkullSummoneeLv2, x - 10, y - 15);
				EnemyManager:DeactivateEnemy(go);
			end
		end,

        OnExit = function(go, sm)
            sm:UnlockState("die");
		end,
	},

    --===================================================================
    -- Defend, Dodge, Stumble
    --===================================================================
    ---------------------------------------------------------------------	
	skill_defend =
	{
        OnEnter = function(go, sm)
            --sm:LockState("die");
        
            go["Motion"]:Reset();
			
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

            AudioManager:PlaySfx(SFX_CHAR_SKILL_BLOCK);
        end,

        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,
        
        OnExit = function(go, sm)
            --sm:UnlockState("die");
        end,
	},
    ---------------------------------------------------------------------	
	skill_trap =
	{
        OnEnter = function(go, sm)
--[[		
			if (go["Attribute"]:Get("skillUsed")) then
				sm:ChangeState("move");
				return;
			end
--]]			
            sm:LockState("die");
        
            local x, y = go["Transform"]:GetTranslate();
			go["Motion"]:ResetTarget(x + go["Bound"]:GetSize() * 0.5, y);
			
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);			
			EnemyManager:EnableEnemyLifebar(go, false);
            EnemyManager:LaunchEnemyWithPosition(Enemy_ObjectTrap, x + 70, y + 70);

			AudioManager:PlaySfx(SFX_CHAR_KABUKI_TRAP);
			AudioManager:PlaySfx(SFX_OBJECT_TRAP_SHOW);
        end,

        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,
        
        OnExit = function(go, sm)
			EnemyManager:EnableEnemyLifebar(go, true);
			
            sm:UnlockState("die");
        end,	
	},
    ---------------------------------------------------------------------	
	skill_trap_move =
	{
        OnEnter = function(go, sm)
			if (LevelManager:IsCurrentLifeZero()) then
				go["Motion"]:Reset();
				sm:ChangeState("idle");
			else
				go["Motion"]:ResetTarget(-go["Bound"]:GetSize() * 2, go["Transform"]:GetTranslateY());
			end
        end,

        OnExecute = function(go, sm, args)
            if (go["Motion"]:IsDone()) then
                EnemyManager:DeactivateEnemy(go);
            end
        end,
	},
    ---------------------------------------------------------------------	
	skill_trap_hurt =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
			sm:LockState("skill_trap_hurt");
			
			local x, y = go["Transform"]:GetTranslate();
			go["Transform"]:SetTranslate(x - 9, y - 51);
			
			AudioManager:PlaySfx(SFX_OBJECT_TRAP_ON);
	        EnemyManager:SetAnimation(go, ENEMY_ANIM_HIT);
			LevelManager:AttackCastle(go);
        end,

        OnExecute = function(go, sm, args)
            if (go["Motion"]:IsDone()) then
                EnemyManager:DeactivateEnemy(go);
            end
        end,
        
        OnExit = function(go, sm)
			sm:UnlockAllStates();
        end,	
	},
    --===================================================================
    -- Heal
    --===================================================================
    ---------------------------------------------------------------------	
	skill_heal =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");
			
			if (EnemyManager:HealEnemy(go)) then
	            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_HEAL);
	            AudioManager:PlaySfx(SFX_CHAR_SKILL_HEAL);
			else
                sm:ChangeState("move");
                --sm:ChangeState(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
			end
        end,
    
        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,	
	},

    --===================================================================
    -- Yin-yang Master
    --===================================================================
    ---------------------------------------------------------------------
	skill_yinyang_move =
	{
        OnEnter = function(go, sm)
			go["Motion"]:ResetTarget(LevelManager:GetRandLongRangedPos());
			EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				sm:ChangeState("skill_yinyang_summon");
			end
		end,
	},
    ---------------------------------------------------------------------
	skill_yinyang_summon =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");
			EnemyManager:SetAnimation(go, ENEMY_ANIM_ATTACK);
        end,
    
        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
				EnemyManager:LaunchEnemyWithPosition(Enemy_YinYangSummonee, x + 50, y);
				EnemyManager:LaunchEnemyWithPosition(Enemy_YinYangSummonee, x + 65, y + 20);
				EnemyManager:LaunchEnemyWithPosition(Enemy_YinYangSummonee, x + 80, y + 40);
				EnemyManager:LaunchEnemyWithPosition(Enemy_YinYangSummonee, x + 65, y + 60);
				EnemyManager:LaunchEnemyWithPosition(Enemy_YinYangSummonee, x + 50, y + 80);
				
				AudioManager:PlaySfx(SFX_CHAR_SKILL_HEAL);
                sm:ChangeState("skill_yinyang_wait");
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,	
	},
    ---------------------------------------------------------------------
	skill_yinyang_wait =
	{
        OnEnter = function(go, sm)
			go["Timer"]:Reset(math.random(800, 1800));
			EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
				sm:ChangeState("skill_yinyang_move");
			end
		end,
	},

    --===================================================================
    -- Object
    --===================================================================
    ---------------------------------------------------------------------
    object_explode =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");			
			EnemyManager:LaunchBomb(go);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                EnemyManager:DeactivateEnemy(go);
            end
        end,
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },
	
    --===================================================================
    -- Innocent
    --===================================================================
	---------------------------------------------------------------------
    innocent_warning =
    {
        OnEnter = function(go, sm)
			LevelManager:ActivateWarningEffect(go);			
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
				sm:ChangeState("innocent_flee");
            end
        end,
        
        OnExit = function(go)
			LevelManager:DeactivateWarningEffect();
        end,
    },
	---------------------------------------------------------------------
    innocent_flee =
    {
        OnEnter = function(go, sm)
			LevelManager:SetInnocentPos(go);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
			AudioManager:PlaySfx(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_MOVE]);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				InnocentSafe(go);
            end
        end,
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    innocent_die =
    {
        OnEnter = function(go, sm)			
            sm:LockState("die");
			go["Motion"]:Reset();
			
			InnocentHurt(go);
        end,

        --OnExecute = function(go, sm)
        --end,

        OnExit = function(go, sm, args)		
            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
	innocent_block =
	{
        OnEnter = function(go, sm)
            sm:LockState("die");

            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
			EnemyManager:UpdateCombo();

            AudioManager:PlaySfx(SFX_CHAR_SKILL_BLOCK);
			UpdateAchievement(ACH_NINJA_GRANNY_SPOT);
        end,

        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("innocent_move");
			end
        end,

        OnExit = function(go, sm, args)		
            --sm:UnlockState("die");
        end,	
	},
	---------------------------------------------------------------------
    innocent_move =
    {
        OnEnter = function(go, sm)
			--LevelManager:SetInnocentTarget(go);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,

        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				InnocentSafe(go);
            end
        end,
        
        OnExit = function(go)
        end,
    },
	
    --===================================================================
    -- Monkey
    --===================================================================
    ---------------------------------------------------------------------
    monkey_die =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
			go["Motion"]:Reset();
			
			MonkeyCatched(go);
        end,

        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				EnemyManager:LaunchCoinSet(go);
				EnemyManager:DeactivateEnemy(go);
            end
        end,

        OnExit = function(go, sm, args)		
            sm:UnlockState("die");
        end,
    },
	
    --===================================================================
    -- Boss
    --===================================================================
    ---------------------------------------------------------------------
    boss_wounded =
    {
        OnEnter = function(go, sm, isKnockBack)
    		local x, y = go["Transform"]:GetTranslate();
    	    go["Motion"]:SetVelocity(ENEMY_PUSHBACK_VELOCITY);
			
			if (isKnockBack) then
	    	    go["Motion"]:ResetTarget(x - 40, y);
			else
	    	    go["Motion"]:ResetTarget(x - 10, y);
			end

            EnemyManager:SetAnimation(go, ENEMY_ANIM_WOUNDED);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                EnemyManager:OnBossWounded(go, sm);
            end
        end,
        
        OnExit = function(go)
			EnemyManager:RestoreSpeed(go);
        end,
    },
    ---------------------------------------------------------------------
    boss_die =
    {
        OnEnter = function(go, sm, args)
            sm:LockState("die");

			-- NOTE: Must do RemoveAllEnchants() before go["Motion"]:Reset()
			--EnemyKilled(go);
			BossKilled(go);
            
			-- Special no-split status
			EnemyManager:SetAnimation(go, ENEMY_ANIM_HIT);
			
			local duration = 7000; --5000;
            go["Motion"]:Reset();
            go["Timer"]:Reset(duration);
			go["Interpolator"]:ResetTarget(ALPHA_MAX, 0, duration);
			go["Interpolator"]:AttachUpdateCallback(UpdateGOAlpha, go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE));
			
			-- Shake it!
			go["Motion"]:SetVelocity(1000);
			local x, y = go["Transform"]:GetTranslate(x, y);
			for i = 1, 10 do
				go["Motion"]:AppendNextTarget(x + math.random(-3, 3), y + math.random(-3, 3));
			end			
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                EnemyManager:DeactivateEnemy(go);
			elseif (go["Motion"]:IsDone()) then
				local x, y = go["Transform"]:GetTranslate(x, y);
				for i = 1, 10 do
					go["Motion"]:AppendNextTarget(x + math.random(-3, 3), y + math.random(-3, 3));
				end
            end
        end,
        
        OnExit = function(go, sm, args)
            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
	boss_minion_wait =
	{
        OnExecute = function(go, sm, nextState)
			if (LevelManager:AreBossMinionsDead()) then
				sm:ChangeState(nextState);
			end
		end,
	},

    ---------------------------------------------------------------------
	-- Shadow Ninja
    ---------------------------------------------------------------------
    boss_shadowninja_assault =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
            
            LevelManager:SetBossWallMovement(go);
            EnemyManager:SetAnimation(go, "_assault_enter");
            
            go["Interpolator"]:AttachUpdateCallback(UpdateGOScale, go["Transform"]);
            go["Interpolator"]:ResetTarget(1.8, 1.0, 500);
            
            AddToPostRenderQueue(go);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("boss_shadowninja_assault_exit");
            end
        end,    
        
        OnExit = function(go, sm)
            RemoveFromPostRenderQueue(go);            
			EnemyManager:SetSpeed(go);
			
            go["Interpolator"]:Reset();
            go["Transform"]:SetScale(1.0);
        end,
    },
    ---------------------------------------------------------------------
    boss_shadowninja_assault_exit =
    {
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, "_assault_exit");
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
            sm:UnlockState("die");
        end,
    },
    ---------------------------------------------------------------------
	boss_shadowninja_mirror =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
			go["Transform"]:ModifyTranslate(-12, 7);
            EnemyManager:SetAnimation(go, "_mirror_enter");
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				LevelManager:LaunchBossShadowNinjaMinion(go);
                sm:ChangeState("boss_minion_wait", "boss_shadowninja_assault");
            end
        end,    
        
        OnExit = function(go, sm)
			go["Transform"]:ModifyTranslate(12, -7);
        end,	
	},
    ---------------------------------------------------------------------
	boss_shadowninja_mirror_exit =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
			go["Transform"]:ModifyTranslate(-12, 7);
            EnemyManager:SetAnimation(go, "_mirror_exit");
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
			go["Transform"]:ModifyTranslate(12, -7);
            sm:UnlockState("die");
        end,	
	},
	
    ---------------------------------------------------------------------
	-- Akudaikan
    ---------------------------------------------------------------------
	boss_akudaikan_summon =
	{
		OnEnter = function(go, sm)
			sm:LockState("die");
			EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
			EnemyManager:LaunchMultipleInnocent();
		end,

        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
                sm:ChangeState("move");
            end
		end,
		
		OnExit = function(go, sm)
			sm:UnlockState("die");
		end,
	},

    ---------------------------------------------------------------------
	-- Ghost King
    ---------------------------------------------------------------------
	---------------------------------------------------------------------
    boss_ghostking_enter =
    {
        OnEnter = function(go, sm)
            sm:LockState("die");
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

			go["Transform"]:SetTranslate(100, -150);
			go["Motion"]:SetVelocity(850);
			go["Motion"]:ResetTarget(100, 120);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				LevelManager:ShakeScene();
				AudioManager:PlaySfx(SFX_SCROLL_METEOR_HIT);
                --sm:ChangeState("boss_ghostking_exit");
				sm:ChangeState("move");
            end
        end,    
        
        OnExit = function(go, sm)
			sm:UnlockState("die");
			EnemyManager:RestoreSpeed(go);
        end,
    },
--[[	
	---------------------------------------------------------------------
	boss_ghostking_exit =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("move");
            end
        end,
        
        OnExit = function(go, sm)
			sm:UnlockState("die");
        end,
	},
--]]	
	---------------------------------------------------------------------
	boss_ghostking_summon =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_SUMMON_ENTER);
			AudioManager:PlaySfx(SFX_OBJECT_BOOST);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
	            EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadGhostSummoneeLv1, x + 110, y);
	            EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadGhostSummoneeLv1, x + 50, y - 50);
	            EnemyManager:LaunchEnemyWithPosition(Enemy_UndeadGhostSummoneeLv1, x + 50, y + 100);
				sm:ChangeState("move");
            end
        end,
        
        OnExit = function(go, sm)
			sm:UnlockState("die");
        end,
	},

    ---------------------------------------------------------------------
	-- Giant Spider
    ---------------------------------------------------------------------
    ---------------------------------------------------------------------
	boss_giantspider_enter =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

			go["Transform"]:SetTranslate(100, -150);
			go["Motion"]:SetVelocity(750);
			go["Motion"]:ResetTarget(100, 120);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				LevelManager:ShakeScene();
				AudioManager:PlaySfx(SFX_SCROLL_METEOR_HIT);
				sm:ChangeState("boss_giantspider_skill_exit");
			end
        end,
	},
	---------------------------------------------------------------------
	boss_giantspider_skill_exit =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("move");
            end
        end,
		
        OnExit = function(go, sm)
			sm:UnlockState("die");
			EnemyManager:RestoreSpeed(go);
		end,
	},
	---------------------------------------------------------------------
	boss_giantspider_jump_out =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
            EnemyManager:SetAnimation(go, "_jump");
        end,

        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("boss_giantspider_jump_move");
            end
        end,
	},
    ---------------------------------------------------------------------
	boss_giantspider_jump_move =
	{
        OnEnter = function(go, sm)
			local x, y = go["Transform"]:GetTranslate();
			go["Motion"]:SetVelocity(750);
			go["Motion"]:ResetTarget(x, y - APP_HEIGHT);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
                sm:ChangeState("boss_giantspider_drop_egg");
            end
        end,
	},
    ---------------------------------------------------------------------
	boss_giantspider_drop_egg =
	{
        OnEnter = function(go, sm)
			go["Timer"]:ResetRandRange(4500, 5500);
			LevelManager:LaunchBossGiantSpiderMinion(go);
        end,
    
        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
                sm:ChangeState("boss_giantspider_jump_in");
            end
        end,    
	},
    ---------------------------------------------------------------------
	boss_giantspider_jump_in =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

			local x, y = LevelManager:GetRandLongRangedPos();
			go["Transform"]:SetTranslate(x, y - APP_HEIGHT);
			go["Motion"]:ResetTarget(x, y);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				LevelManager:ShakeScene();
				AudioManager:PlaySfx(SFX_SCROLL_METEOR_HIT);
                sm:ChangeState("boss_giantspider_skill_exit");
            end
        end,    
	},
    ---------------------------------------------------------------------
	boss_giantspider_trap_drop =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				AudioManager:PlaySfx(SFX_OBJECT_BOOST);
	            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
				sm:ChangeState("skill_trap_move");
            end
        end,    
        
        OnExit = function(go, sm)
			EnemyManager:RestoreSpeed(go);
			sm:UnlockState("die");
        end,	
	},
    ---------------------------------------------------------------------	
	boss_giantspider_trap_hit =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
			sm:LockState("boss_giantspider_trap_hit");
			
			local x, y = go["Transform"]:GetTranslate();
			go["Transform"]:SetTranslate(x - 9, y - 51);
			
			AudioManager:PlaySfx(SFX_OBJECT_TRAP_ON);
	        EnemyManager:SetAnimation(go, ENEMY_ANIM_HIT);
        end,

        OnExecute = function(go, sm, args)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
				local offsetX = 25;
				local offsetY = 25;
				EnemyManager:LaunchEnemyWithPosition(BossMinion_MiniSpider, x + offsetX, y + offsetY);
				EnemyManager:LaunchEnemyWithPosition(BossMinion_MiniSpider, x - offsetX, y - offsetY);
				EnemyManager:LaunchEnemyWithPosition(BossMinion_MiniSpider, x - offsetX, y + offsetY);
				EnemyManager:LaunchEnemyWithPosition(BossMinion_MiniSpider, x + offsetX, y - offsetY);
                --EnemyManager:DeactivateEnemy(go);
				sm:ChangeState("skill_trap_move");
            end
        end,
        
        --OnExit = function(go, sm)
		--	sm:UnlockAllStates();
        --end,	
	},

    ---------------------------------------------------------------------
	-- Devil Samurai
    ---------------------------------------------------------------------
	---------------------------------------------------------------------
	boss_devilsamurai_skill_enter =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);

			go["Transform"]:SetTranslate(50, -150);
			go["Motion"]:SetVelocity(850);
			go["Motion"]:ResetTarget(50, 90);
			go["Attribute"]:Set("invincible", true);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				LevelManager:ShakeScene();
				AudioManager:PlaySfx(SFX_SCROLL_METEOR_HIT);
				sm:ChangeState("boss_devilsamurai_skill_exit");
            end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_skill_exit =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("boss_devilsamurai_summon_move");
            end
        end,
		
        OnExit = function(go, sm)
			sm:UnlockState("die");
			EnemyManager:RestoreSpeed(go);
		end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_jump_out =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
            EnemyManager:SetAnimation(go, "_jump");
        end,

        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("boss_devilsamurai_jump_move", nextState);
            end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_jump_move =
	{
        OnEnter = function(go, sm)
			EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
			
			local x, y = go["Transform"]:GetTranslate();
			go["Motion"]:SetVelocity(850);
			go["Motion"]:ResetTarget(x, y - APP_HEIGHT);
			go["Attribute"]:Set("invincible", true);			
			go["Timer"]:ResetRandRange(2000, 4000);
        end,

        OnExecute = function(go, sm)
            if (go["Timer"]:IsOver()) then
				local x = 0;
				local y = go["Transform"]:GetTranslateY();
				local nextState;
				
				if (math.random(1, 100) > 40) then
				-- Melee attack
					x = math.random(220, 270);
					nextState = "boss_devilsamurai_attack";
				else
				-- Ranged summon
					x = math.random(0, 100);
					nextState = "boss_devilsamurai_summon_enter";
				end
				
				go["Transform"]:SetTranslate(x, y);
				go["Motion"]:ResetTarget(x, y + APP_HEIGHT);
				
				sm:ChangeState("boss_devilsamurai_jump_in", nextState);
            end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_jump_in =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
        end,
    
        OnExecute = function(go, sm, nextState)
            if (go["Motion"]:IsDone()) then
				LevelManager:ShakeScene();
---[[
				LevelManager:LaunchBossDevilSamuraiMinion();
--]]
				AudioManager:PlaySfx(SFX_SCROLL_METEOR_HIT);
				sm:ChangeState("boss_devilsamurai_jump_exit", nextState);
            end
        end,
		
        OnExit = function(go, sm)
			sm:UnlockState("die");
			EnemyManager:RestoreSpeed(go);
		end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_jump_exit =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm, nextState)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState(nextState, true);
            end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_action =
	{
        OnEnter = function(go, sm)
		--log("boss action")
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
			
			local dice = math.random(1, 100);
			if (dice <= 20) then
				sm:ChangeState("boss_devilsamurai_idle");
			elseif (dice <= 60) then
				sm:ChangeState("boss_devilsamurai_attack_move");
			else
				sm:ChangeState("boss_devilsamurai_summon_move");
			end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_idle =
	{
        OnEnter = function(go, sm)
		--log("boss idle")
			go["Timer"]:ResetRandRange(1000, 3000);
        end,
    
        OnExecute = function(go, sm)
			if (go["Timer"]:IsOver()) then
				sm:ChangeState("boss_devilsamurai_action");
			end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_summon_move =
	{
        OnEnter = function(go, sm)
			local x = math.random(-30, 70);
			local y = math.random(60, 100)
			go["Motion"]:ResetTarget(x, y);

            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				sm:ChangeState("boss_devilsamurai_summon_enter");
			end
        end,
        
        OnExit = function(go, sm)
        end,		
	},
	---------------------------------------------------------------------
	boss_devilsamurai_summon_enter =
	{
        OnEnter = function(go, sm, speedup)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_SUMMON_ENTER);

			if (speedup) then
			--log("speed @ up")
				go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(0.5);
			end
        end,
    
        OnExecute = function(go, sm, speedup)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
				if (speedup) then
					EnemyManager:LaunchEnemyWithPosition(Enemy_SpeedFireSkull, x + 100, y + 85);
				else
					EnemyManager:LaunchEnemyWithPosition(Enemy_FireSkullSummoneeLv1, x + 100, y + 85);
				end
				AudioManager:PlaySfx(SFX_OBJECT_BOOST);
				sm:ChangeState("boss_devilsamurai_summon_on", speedup);
			end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_summon_on =
	{
        OnEnter = function(go, sm)
		--log("boss sum_on")
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_SUMMON_ON);
			go["Attribute"]:Set("invincible", false);
        end,
    
        OnExecute = function(go, sm, speedup)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
				if (speedup) then
					EnemyManager:LaunchEnemyWithPosition(Enemy_SpeedFireSkull, x + 80, y + 105);
				else
		            EnemyManager:LaunchEnemyWithPosition(Enemy_FireSkullSummoneeLv1, x + 80, y + 105);
				end
				AudioManager:PlaySfx(SFX_OBJECT_BOOST);
				sm:ChangeState("boss_devilsamurai_summon_on2", speedup);
			end
        end,
		
		OnExit = function(go)
			go["Attribute"]:Set("invincible", true);
		end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_summon_on2 =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_SUMMON_ON);
			go["Attribute"]:Set("invincible", false);
        end,
    
        OnExecute = function(go, sm, speedup)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
				if (speedup) then
					EnemyManager:LaunchEnemyWithPosition(Enemy_SpeedFireSkull, x + 70, y + 65);
				else
		            EnemyManager:LaunchEnemyWithPosition(Enemy_FireSkullSummoneeLv1, x + 70, y + 65);
				end
				AudioManager:PlaySfx(SFX_OBJECT_BOOST);
				sm:ChangeState("boss_devilsamurai_summon_exit", speedup);
			end
        end,
		
		OnExit = function(go)
			go["Attribute"]:Set("invincible", true);
		end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_summon_exit =
	{
        OnEnter = function(go, sm)
		--log("boss sum_exit")
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_SUMMON_EXIT);
			go["Attribute"]:Set("invincible", false);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("boss_devilsamurai_action");
			end
        end,
		
		OnExit = function(go, sm, speedup)
			if (speedup) then
			--log("speed @ restore")
				go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(1.0);
			end

			go["Attribute"]:Set("invincible", true);
		end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_attack_move =
	{
        OnEnter = function(go, sm)
            local x, y = LevelManager:GetEnemyTargetPos(go);
            x = x - go["Attribute"]:Get("template")[ENEMY_TEMPLATE_RANGE] + math.random(-20, 20);
			y = math.random(60, 100);
            go["Motion"]:ResetTarget(x, y);
            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				if (math.random(1, 100) > 20) then
	                sm:ChangeState("preattack");
				else
	                sm:ChangeState("boss_devilsamurai_action");
				end
            end
        end,
	},
	---------------------------------------------------------------------
	boss_devilsamurai_attack =
	{
        OnEnter = function(go, sm, speedup)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_ATTACK);
			go["Transform"]:ModifyTranslate(29, -27);
			go["Attribute"]:Set("invincible", false);
			
			if (speedup) then
				go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(0.5);
			end
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				sm:ChangeState("boss_devilsamurai_action");				
            end
        end,
        
        OnExit = function(go, sm, speedup)
			if (speedup) then
				go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetFrequency(1.0);
			end

			go["Transform"]:ModifyTranslate(-29, 27);
			go["Attribute"]:Set("invincible", true);
        end,	
	},
    ---------------------------------------------------------------------
	boss_devilsamurai_trap_drop =
	{
        OnEnter = function(go, sm)
			sm:LockState("die");
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
        end,
    
        OnExecute = function(go, sm)
            if (go["Motion"]:IsDone()) then
				AudioManager:PlaySfx(SFX_OBJECT_BOOST);
                sm:ChangeState("boss_devilsamurai_trap_drop_exit");
            end
        end,    
        
        OnExit = function(go, sm)
			EnemyManager:RestoreSpeed(go);
        end,	
	},
    ---------------------------------------------------------------------
	boss_devilsamurai_trap_drop_exit =
	{
        OnEnter = function(go, sm)
            EnemyManager:SetAnimation(go, ENEMY_ANIM_SKILL_EXIT);
        end,
    
        OnExecute = function(go, sm)
            if (go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):IsDone()) then
				local x, y = go["Transform"]:GetTranslate();
				go["Transform"]:SetTranslate(x + 9, y + 51);
	            EnemyManager:SetAnimation(go, ENEMY_ANIM_MOVE);				
				sm:ChangeState("skill_trap_move");
            end
        end,    
        
        OnExit = function(go, sm)
			sm:UnlockState("die");
        end,
	},
};
