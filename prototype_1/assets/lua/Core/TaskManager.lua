--***********************************************************************
-- @file TaskManager.lua
--***********************************************************************

--=======================================================================
-- TaskManager
--=======================================================================

TASK_FUNC = 1;
TASK_ARGS = 2;
TASK_DURATION = 3;
TASK_DELAY = 4;

TASK_DEFAULT_DURATION = 0;
TASK_DEFAULT_DELAY = 0;



TaskManager =
{
    --
    -- Fields
    --
	m_TasksQueue = nil,
	m_CurrentTask = nil,
	m_AccumTime = 0,

    --
    -- Private Methods
    --
    ---------------------------------------------------------------
    Instance = function(self, o)
        o = o or {};
        setmetatable(o, self);
        self.__index = self;
        return o;
    end,
    ---------------------------------------------------------------
    Create = function(self)
        -- Create component
        local o = self:Instance
		{
			m_TasksQueue = {},
			m_AccumTime = 0;
		};

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	AddTask = function(self, func, args, duration, delay)
		table.insert(self.m_TasksQueue,
			{
				[TASK_FUNC] = func,
				[TASK_ARGS] = args,
				[TASK_DURATION] = duration or TASK_DEFAULT_DURATION,
				[TASK_DELAY] = delay or TASK_DEFAULT_DELAY,
			}
		);
	end,
    ---------------------------------------------------------------
	Clear = function(self)
        for i = 1, #self.m_TasksQueue do
            table.remove(self.m_TasksQueue);
        end
		self.m_CurrentTask = nil;
		self.m_AccumTime = 0;
	end,
    ---------------------------------------------------------------
    IsDone = function(self)
        if (self.m_CurrentTask == nil and #self.m_TasksQueue == 0) then
            return true;
        end
        return false;
    end,
    ---------------------------------------------------------------
	Update = function(self)
		if (table.maxn(self.m_TasksQueue) == 0) then
			return;
		end

		-- Accumulate time
		self.m_AccumTime = self.m_AccumTime + g_Timer:GetDeltaTime();

		if (self.m_CurrentTask == nil) then
			if (self.m_AccumTime > self.m_TasksQueue[1][TASK_DELAY]) then
				self.m_AccumTime = 0;
				self.m_CurrentTask = self.m_TasksQueue[1];

				if (self.m_CurrentTask[TASK_FUNC]["OnEnter"] ~= nil) then
					self.m_CurrentTask[TASK_FUNC]["OnEnter"](self.m_CurrentTask[TASK_ARGS]);
				end
			end
		else
			-- Check if Func's lifetime is due
			if (self.m_AccumTime > self.m_CurrentTask[TASK_DURATION]) then
				table.remove(self.m_TasksQueue, 1);

				if (self.m_CurrentTask[TASK_FUNC]["OnExit"] ~= nil) then
					self.m_CurrentTask[TASK_FUNC]["OnExit"](self.m_CurrentTask[TASK_ARGS]);
				end

				self.m_CurrentTask = nil;
				self.m_AccumTime = 0;
				
				self:Update();
			else
				if (self.m_CurrentTask[TASK_FUNC]["OnUpdate"] ~= nil) then
					self.m_CurrentTask[TASK_FUNC]["OnUpdate"](self.m_CurrentTask[TASK_ARGS]);
				end
			end
		end
	end,
};



--=====================
-- Game tasks
--=====================

-------------------------------------------------------------------------
TimeDelayTask =
{
};

-------------------------------------------------------------------------
EnableRenderTask =
{
    OnEnter = function(args)
        args[1]:EnableRender(args[2]);
    end,
};

-------------------------------------------------------------------------
ToggleRenderTask =
{
    OnEnter = function(args)
        args:ToggleRender();
    end,

    OnExit = function(args)
        args:ToggleRender();
    end,
};

-------------------------------------------------------------------------
LinearMotionTask =
{
    OnEnter = function(args)
        args[1]:AppendNextTarget(args[2], args[3]);
    end,
};

-------------------------------------------------------------------------
InterpolateTask =
{
    OnEnter = function(args)
        args[1]:AppendNextTarget(args[2], args[3], args[4]);
    end,
};

-------------------------------------------------------------------------
FadeTask =
{
    OnEnter = function(args)
        args[1]:AppendNextTarget(args[2], args[3], args[4]);
    end,
};

-------------------------------------------------------------------------
AudioTask =
{
    OnEnter = function(args)
		g_AudioEngine:Play(args);
    end,
};

-------------------------------------------------------------------------
StateChangeTask =
{
    OnEnter = function(args)
        args[1]:ChangeState(args[2], args[3]);
    end,
};

-------------------------------------------------------------------------
StageChangeTask =
{
    OnEnter = function(args)
        StageManager:ChangeStage(args);
    end,
};

-------------------------------------------------------------------------
StagePushTask =
{
    OnEnter = function(args)
        StageManager:PushStage(args);
    end,
};

-------------------------------------------------------------------------
StagePopTask =
{
    OnEnter = function(args)
        StageManager:PopStage();
    end,
};

-------------------------------------------------------------------------
CallbackTask =
{
    OnEnter = function(args)
        if (args[1] ~= nil) then
            --log("callback [1]");        
            args[1](args[4]);
        end
    end,

    OnUpdate = function(args)
        if (args[2] ~= nil) then
            --log("callback [2]");        
            args[2](args[4]);
        end
    end,

    OnExit = function(args)
        if (args[3] ~= nil) then
            --log("callback [3]");        
            args[3](args[4]);
        end
    end,
};

--=====================
-- UI tasks
--=====================

-------------------------------------------------------------------------
UIToggleTask =
{
    OnEnter = function(args)
        UIManager:ToggleUI(args);
    end,
};

-------------------------------------------------------------------------
UIEnableWidgetTask =
{
    OnEnter = function(args)
        UIManager:EnableWidget(args[1], args[2], args[3]);
    end,
};

-------------------------------------------------------------------------
UIToggleWidgetTask =
{
    OnEnter = function(args)
        UIManager:EnableWidget(args[1], args[2], args[3]);
    end,

    OnExit = function(args)
        UIManager:EnableWidget(args[1], args[2], not args[3]);
    end,
};

-------------------------------------------------------------------------
UIActivateTask =
{
	OnEnter = function(args)
	--log("UIActivateTask")
		UIManager:ActivateUI(args);
	end,
};

-------------------------------------------------------------------------
UIDeactivateTask =
{
	OnEnter = function(args)
	--log("UIDeactivateTask")
		UIManager:DeactivateUI(args);
	end,
};

-------------------------------------------------------------------------
UIFadeTask =
{
    OnEnter = function(args)
	--log("UIFadeTask: "..args[1].." -> "..args[2].." @ "..args[3])
		g_FadeFrameUI["Interpolator"]:ResetTarget(args[1], args[2], args[3]);
    end,

    OnUpdate = function(args)
		g_FadeFrameUI:Update();
	end,

    OnExit = function(args)
		g_FadeFrameUI["Shape"]:SetAlpha(args[2]);
	end,
};

-------------------------------------------------------------------------
UIFadeCycleTask =
{
    OnEnter = function(args)
	--log("UIFadeTask: "..args[1].." -> "..args[2].." @ "..args[3])
		g_FadeFrameUI["Interpolator"]:ResetTarget(args[1], args[2], args[3]);
		g_FadeFrameUI["Interpolator"]:AppendNextTarget(args[2], args[1], args[3]);
    end,

    OnUpdate = function(args)
		g_FadeFrameUI:Update();
	end,

    OnExit = function(args)
		g_FadeFrameUI["Shape"]:SetAlpha(args[1]);
	end,
};

-------------------------------------------------------------------------
UIMotionTask =
{
    OnEnter = function(args)
	--log("UIMotionTask")
        args[1]:ResetTarget(args[2], args[3]);
    end,
};

-------------------------------------------------------------------------
UIScaleTask =
{
    OnEnter = function(args)
        args[2]:ResetTarget(args[3], args[4], args[5]);
    end,

    OnUpdate = function(args)
	--log("UIScaleTask: "..args[2]:GetValue())
		args[1]:ScaleAllWidgets(args[2]:GetValue());
	end,

    OnExit = function(args)
		args[1]:ScaleAllWidgets(args[4]);
	end,
};



--[[

XXXTask =
{
    OnEnter = function(args)
    end,

    OnUpdate = function(args)
    end,

    OnExit = function(args)
    end,
};

--]]
