--***********************************************************************
-- @file PoolManager.lua
--***********************************************************************

PoolManager =
{
    --
    -- Fields
    --
	m_InactivePool = nil,
	m_ActivePool = nil,
	m_TemplateName = nil,
	m_Capacity = 0,

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
    Create = function(self, templateName, capacity, defaultState)
		assert(templateName, "[PoolManager] Template name error");
		assert(capacity, "[PoolManager] Pool capacity error");
	
        -- Create component
        local o = self:Instance
		{
			m_InactivePool = {},
			m_ActivePool = {},
			m_TemplateName = templateName,
			m_Capacity = capacity,
			m_DefaultState = defaultState,
		};

		for i = 1, capacity do
			o.m_InactivePool[i] = ObjectFactory:CreateGameObject(templateName);						
		end

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------------
	ActivateResource = function(self)
		if (#self.m_InactivePool > 0) then
			local resource = table.remove(self.m_InactivePool);
			table.insert(self.m_ActivePool, resource);
--[[ @DEBUG
			log(string.format("[%s] active# %d / inactive# %d", self.m_TemplateName, #self.m_ActivePool, #self.m_InactivePool));
--]]
			return resource;
		else
			if (APP_DEBUG_MODE) then
				log("[PoolManager] Lack of resource: "..self.m_TemplateName);
			end
		end
	end,
    ---------------------------------------------------------------------
	DeactivateResource = function(self, go)
		assert(go);
		
		for index, res in ipairs(self.m_ActivePool) do
			if (go == res) then
				table.remove(self.m_ActivePool, index);
--[[ @Insert it to tail
				table.insert(self.m_InactivePool, go);
--]]
---[[ @Insert it to head
				table.insert(self.m_InactivePool, 1, go);
--]]				

				if (self.m_DefaultState) then
					res["StateMachine"]:ChangeState(self.m_DefaultState);
				end
--[[ @DEBUG
				log(string.format("[%s] active# %d / inactive# %d", self.m_TemplateName, #self.m_ActivePool, #self.m_InactivePool));
--]]
				return;
			end
		end

		assert(false, "[PoolManager] DeactivateResource error: "..self.m_TemplateName);
	end,
    ---------------------------------------------------------------------
	ResetPool = function(self)
		for i = #self.m_ActivePool, 1, -1 do
			local res = table.remove(self.m_ActivePool);
			table.insert(self.m_InactivePool, res);

			if (self.m_DefaultState) then
				res["StateMachine"]:ChangeState(self.m_DefaultState);
			end
		end
		
		assert(#self.m_ActivePool == 0);
		assert(#self.m_InactivePool == self.m_Capacity);
	end,
    ---------------------------------------------------------------------
	GetInactivePool = function(self)
		return self.m_InactivePool;
	end,
    ---------------------------------------------------------------------
	GetActivePool = function(self)
		return self.m_ActivePool;
	end,
    ---------------------------------------------------------------------
	IsInactivePoolEmpty = function(self)
		if (#self.m_InactivePool == 0) then
			return true;
		end
		return false;
	end,
    ---------------------------------------------------------------------
	IsActivePoolEmpty = function(self)
		if (#self.m_ActivePool == 0) then
			return true;
		end
		return false;
	end,
};


