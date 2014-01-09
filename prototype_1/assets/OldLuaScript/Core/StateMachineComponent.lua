--***********************************************************************
-- @file StateMachineComponent.lua
--***********************************************************************

--=======================================================================
-- StateMachineComponent
--=======================================================================

StateMachineComponent =
{
    --
    -- Fields
    --
	m_Owner = nil,
	m_StatesSet = nil,
	m_CurrentState = nil,
    m_CurrentStateName = nil,
    m_CurrentStateArgs = nil,
	m_PreviousState = nil,
	m_PreviousStateName = nil,
	m_LockedStates = nil,

    --
    -- Private Methods
    --
    ---------------------------------------------------------------------
    Instance = function(self, o)
        o = o or {};
        setmetatable(o, self);
        self.__index = self;
        return o;
    end,
    ---------------------------------------------------------------------
    Create = function(self, t, go)
        assert(t.states, "Game object has no state set: " .. go:GetClass());
        
        -- Create component
        local o = self:Instance
		{
			m_Owner = go,
			m_StatesSet = t.states,
			m_LockedStates = {},
		};

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);
        
        if (t.initial ~= nil) then
            o:ChangeState(t.initial);
        end

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------------
	ChangeState = function(self, state, args)
        assert(self.m_StatesSet[state] ~= nil, "State does not existed: " .. state);

        if (self.m_LockedStates[state]) then
            return false;
        end

		if (self.m_CurrentState ~= nil) then
			self.m_PreviousState = self.m_CurrentState;
			self.m_PreviousStateName = self.m_CurrentStateName;

			if (self.m_CurrentState["OnExit"] ~= nil) then
				self.m_CurrentState["OnExit"](self.m_Owner, self, self.m_CurrentStateArgs);
			end
		end

		self.m_CurrentState = self.m_StatesSet[state];
        self.m_CurrentStateName = state;
        self.m_CurrentStateArgs = args;

		if (self.m_CurrentState["OnEnter"] ~= nil) then
			self.m_CurrentState["OnEnter"](self.m_Owner, self, self.m_CurrentStateArgs);
		end

		return true;
	end,
    ---------------------------------------------------------------------
	ResetStateSet = function(self, stateSet, initialState)
		assert(stateSet, "State set error");
		
		self:UnlockAllStates();
		
		self.m_StatesSet = stateSet;
		self.m_CurrentState = nil;
		
		if (initialState) then
			self:ChangeState(initialState);
		end
	end,
    ---------------------------------------------------------------------
	LockState = function(self, state)
        assert(state);        
        self.m_LockedStates[state] = true;
	end,
    ---------------------------------------------------------------------
	UnlockState = function(self, state)
        assert(state);
        self.m_LockedStates[state] = nil;
	end,
    ---------------------------------------------------------------------
	UnlockAllStates = function(self)
        for state, _ in pairs(self.m_LockedStates) do
            self.m_LockedStates[state] = nil;
        end
	end,
    ---------------------------------------------------------------------
    RevertPreviousState = function(self, args)
        if (self.m_PreviousStateName) then
            self:ChangeState(self.m_PreviousStateName, args);
        end
    end,
    ---------------------------------------------------------------------
    GetCurrentState = function(self)
        return self.m_CurrentStateName;
    end,
    ---------------------------------------------------------------------
    GetCurrentStateArgs = function(self)
        return self.m_CurrentStateArgs;
    end,
    ---------------------------------------------------------------------
    GetPreviousState = function(self)
        return self.m_PreviousStateName;
    end,
    ---------------------------------------------------------------------
	IsCurrentState = function(self, state)
		return (self.m_CurrentStateName == state);
	end,
    ---------------------------------------------------------------------
	IsPreviousState = function(self, state)
		return (self.m_PreviousStateName == state);
	end,
    ---------------------------------------------------------------------
    IsStateChangeAllowed = function(self, state)
        if (self.m_LockedStates[state]) then
            return false;
        end
        return true;
    end,

    --
    -- Events
    --
    ---------------------------------------------------------------------
	OnUpdate = function(self)
		if (self.m_CurrentState ~= nil and self.m_CurrentState["OnExecute"] ~= nil) then
			self.m_CurrentState["OnExecute"](self.m_Owner, self, self.m_CurrentStateArgs);
		end
	end,
};



--=======================================================================
-- Register game component templates
--=======================================================================

ObjectFactory:AddGameComponentTemplate(StateMachineComponent, "StateMachine");


