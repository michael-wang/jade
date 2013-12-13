--***********************************************************************
-- @file RoutineManager.lua
--***********************************************************************

--=======================================================================
-- RoutineManager
--=======================================================================

ROUTINE_GROUP_01 = 1;
ROUTINE_GROUP_02 = 2;
ROUTINE_GROUP_03 = 3;
ROUTINE_GROUP_04 = 4;
ROUTINE_GROUP_05 = 5;
ROUTINE_GROUP_06 = 6;
ROUTINE_GROUP_07 = 7;
ROUTINE_GROUP_08 = 8;
ROUTINE_GROUP_09 = 9;
ROUTINE_GROUP_10 = 10;
ROUTINE_GROUP_11 = 11;
ROUTINE_GROUP_12 = 12;
ROUTINE_GROUP_13 = 13;
ROUTINE_GROUP_14 = 14;
ROUTINE_GROUP_15 = 15;

ROUTINE_GROUP_MIN = ROUTINE_GROUP_01;
ROUTINE_GROUP_MAX = ROUTINE_GROUP_15;



RoutineManager =
{
    --
    -- Fields
    --
    m_RoutineName,
    m_GroupSet,
    m_GroupSetDisabled,

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
    Create = function(self, routineName)
        local o = self:Instance
		{
			m_RoutineName = routineName,
            m_GroupSet = {},
            m_GroupSetDisabled = {},
		};
		
        -- Determine rendering route
        if (g_AppData:GetData("DebugMode")) then
            o.AddObject = o.AddObject_Debug;
			o.AddGroupObjects = o.AddGroupObjects_Debug;
        else
            o.AddObject = o.AddObject_Release;
			o.AddGroupObjects = o.AddGroupObjects_Release;
        end		

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    GetGroup = function(self, groupIndex)
        self.m_GroupSet[groupIndex] = self.m_GroupSet[groupIndex] or {};
        return self.m_GroupSet[groupIndex];
    end,
    ---------------------------------------------------------------
    AddObject_Debug = function(self, obj, groupIndex)
        assert(groupIndex);
        assert(groupIndex >= ROUTINE_GROUP_MIN);
        assert(groupIndex <= ROUTINE_GROUP_MAX);
        
		local group = self:GetGroup(groupIndex);

        for _, existedObj in ipairs(group) do
            if (obj == existedObj) then
				assert(false, "Duplicated object at group #"..groupIndex);
			end
        end

        table.insert(self:GetGroup(groupIndex), obj);
    end,
    ---------------------------------------------------------------
    AddObject_Release = function(self, obj, groupIndex)
        table.insert(self:GetGroup(groupIndex), obj);
    end,
    ---------------------------------------------------------------    
    AddGroupObjects_Debug = function(self, objList, groupIndex)
        assert(groupIndex);
        assert(groupIndex >= ROUTINE_GROUP_MIN);
        assert(groupIndex <= ROUTINE_GROUP_MAX);
        assert(type(objList) == "table");
        
        local group = self:GetGroup(groupIndex);

        for _, existedObj in ipairs(group) do
			for _, obj in ipairs(objList) do
				if (obj == existedObj) then
					assert(false, "Duplicated object at group #"..groupIndex);
				end
			end
        end

        for _, obj in ipairs(objList) do
            table.insert(group, obj);
        end
    end,
    ---------------------------------------------------------------    
    AddGroupObjects_Release = function(self, objList, groupIndex)
        local group = self:GetGroup(groupIndex);
        for _, obj in ipairs(objList) do
            table.insert(group, obj);
        end
    end,
    ---------------------------------------------------------------
	RemoveObject = function(self, obj, groupIndex)        
        assert(groupIndex);
        assert(groupIndex >= ROUTINE_GROUP_MIN);
        assert(groupIndex <= ROUTINE_GROUP_MAX);
        
        local objIndex = self:GetObjectIndex(obj, groupIndex);
        if (objIndex) then
            return table.remove(self:GetGroup(groupIndex), objIndex);
        end
	end,
    ---------------------------------------------------------------
	RemoveGroupObjects = function(self, objList, groupIndex)        
        assert(groupIndex);
        assert(groupIndex >= ROUTINE_GROUP_MIN);
        assert(groupIndex <= ROUTINE_GROUP_MAX);
        assert(type(objList) == "table");

        local group = self:GetGroup(groupIndex);
        for _, obj in ipairs(objList) do
            local objIndex = self:GetObjectIndex(obj, groupIndex);
            if (objIndex) then
                table.remove(group, objIndex);
            end
        end
	end,
    ---------------------------------------------------------------
	RemoveObjectByIndex = function(self, objIndex, groupIndex)
        return table.remove(self:GetGroup(groupIndex), objIndex);
    end,
    ---------------------------------------------------------------
	RemoveGroup = function(self, groupIndex)
        local group = self:GetGroup(groupIndex);
        
        for i = 1, #group do
            table.remove(group);
        end
        assert(#group == 0);
	end,
    ---------------------------------------------------------------
	EnableGroup = function(self, groupIndex, enable)
        assert(self.m_GroupSetDisabled);
        self.m_GroupSetDisabled[groupIndex] = not enable;
	end,
    ---------------------------------------------------------------
	MoveObjectToFirst = function(self, obj, groupIndex)
        local objIndex = self:GetObjectIndex(obj, groupIndex);

        if (objIndex) then
            local group = self:GetGroup(groupIndex);
            table.insert(group, 1, table.remove(group, objIndex));
        end
    end,
    ---------------------------------------------------------------
	MoveObjectToLast = function(self, obj, groupIndex)
        local objIndex = self:GetObjectIndex(obj, groupIndex);

        if (objIndex) then
            local group = self:GetGroup(groupIndex);
            table.insert(group, table.remove(group, objIndex));
        end
    end,
    ---------------------------------------------------------------
    GetObjectIndex = function(self, obj, groupIndex)
        for index, target in ipairs(self:GetGroup(groupIndex)) do
            if (obj == target) then
                return index;
            end
        end
    end,
    ---------------------------------------------------------------
	Clear = function(self)
        self.m_GroupSet = {};
	end,
    ---------------------------------------------------------------    
    Execute = function(self)
        for index = ROUTINE_GROUP_MIN, ROUTINE_GROUP_MAX do
            if (self.m_GroupSet[index] ~= nil and not self.m_GroupSetDisabled[index]) then
                for _, obj in ipairs(self.m_GroupSet[index]) do
                    obj[self.m_RoutineName](obj);
                end
            end
        end
    end,
};


