--***********************************************************************
-- @file IOManager.lua
--***********************************************************************

--=======================================================================
-- Globals
--=======================================================================
IO_MAIN_DATA = "footprint.journey";
IO_ICLOUD_DATA = "cloud.sav";

IO_CAT_HACK = "Hack";
IO_CAT_CONTENT = "Content";
IO_CAT_OPTION = "Option";
IO_CAT_STAT = "Stat";



--=======================================================================
-- IOManager
--=======================================================================

IOManager =
{
    --
    -- Fields
    --
    m_FullPath,
    m_DataSet,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    Create = function(self, fileName, doLoading)
		if (fileName) then
			self.m_FullPath = GaoApp.MakeDocumentPath(fileName);
			
			if (doLoading) then
				self:DeserializeFile(self.m_FullPath);
			end
		else
			self.m_FullPath = GaoApp.MakeDocumentPath(IO_MAIN_DATA);
			self:DeserializeFile(self.m_FullPath);
		end
    end,
    ---------------------------------------------------------------
    SerializeFile = function(self, fullPath, dataSet)
        assert(luabins, "Luabins initialization error");
        log("[Serialization] " .. fullPath);
    
        local file = io.open(fullPath, "w");
        if (file) then
            io.output(file);
            
            local result = luabins.save(dataSet);
            assert(result);
            
            file:write(result);
            io.flush();
            io.close(file);
    
            log("    <<<<<<< write data to file");
        else
            log("Data serialization error");
        end
    end,
    ---------------------------------------------------------------    
    DeserializeFile = function(self, fullPath)
        assert(luabins, "Luabins initialization error");
        log("[Deserialization] " .. fullPath);
    
        local file = io.open(fullPath, "r");
        local result;
        
        if (file) then
            io.input(file);
    
            local data = file:read("*a");
            assert(data, "Data deserialization error");
            io.close(file);
           
            local luabins_data = { luabins.load(data) };
            assert(luabins_data[1], luabins_data[2]);
            
            result = luabins_data[2];
            assert(result, "Error occurred at DeserializeFile");
            log("    existed data parsed >>>>>>>");
        else
            result = ResetDefaultDataDelegate();
            assert(result, "Error occurred at DeserializeFile");
            log("    new data rebuilt >>>>>>>");

            self:SerializeFile(fullPath, result);
        end
                
        self.m_DataSet = result;
        
        return result;
    end,
    ---------------------------------------------------------------
    Save = function(self)
        self:SerializeFile(self.m_FullPath, self.m_DataSet);
    end,
    ---------------------------------------------------------------
    Load = function(self)
        self:DeserializeFile(self.m_FullPath);
    end,
    ---------------------------------------------------------------
    SetRecord = function(self, category, record, value, doSaving)
        self.m_DataSet[category][record] = value;
        
        if (doSaving) then
            self:SerializeFile(self.m_FullPath, self.m_DataSet);
        end
    end,
    ---------------------------------------------------------------    
    GetRecord = function(self, category, record)
        return self.m_DataSet[category][record];
    end,
    ---------------------------------------------------------------
    SetValue = function(self, category, record, data, value, doSaving)
        assert(self.m_DataSet[category][record], "SetValue error [record]: "..record);
        self.m_DataSet[category][record][data] = value;
        
        if (doSaving) then
            self:SerializeFile(self.m_FullPath, self.m_DataSet);
        end
    end,
    ---------------------------------------------------------------    
    GetValue = function(self, category, record, data)
        assert(self.m_DataSet[category], "GetValue error [category]: "..category);
        assert(self.m_DataSet[category][record], "GetValue error [record]: "..record);
        return self.m_DataSet[category][record][data];
    end,
    ---------------------------------------------------------------
    ModifyValue = function(self, category, record, data, value, doSaving)
        assert(self.m_DataSet[category], "ModifyValue error [category]: "..category);
        assert(self.m_DataSet[category][record], "ModifyValue error [record]: "..record);
        
        local rec = self.m_DataSet[category][record];
        rec[data] = (rec[data] or 0) + value;
        
        if (doSaving) then
            self:SerializeFile(self.m_FullPath, self.m_DataSet);
        end
        
        return rec[data];
    end,
    ---------------------------------------------------------------
    Dump = function(self)
        DumpTable(self.m_DataSet, "IOManager");
    end,
};

-------------------------------------------------------------------------
function ResetDefaultDataDelegate()
    log("No default delegate for IO");
    return {};
end

--[[ @Old Methods
-------------------------------------------------------------------------
function DeserializeFile(id, fileName)
    log("[Deserialization] " .. fileName);

    local fullPath = GaoApp.MakeDocumentPath(fileName);
    local file = io.open(fullPath, "r");
    local dataSet;
    
    if (file) then
        io.close(file);
        dataSet = dofile(fullPath);
        log("  => existed data parsed: " .. fileName);
    else
        dataSet = ResetDefaultDataDelegate(id);
        log("  => new data rebuilt: " .. fileName);
    end
    
    assert(dataSet, "DeserializeFile error");
    return dataSet;
end

-------------------------------------------------------------------------
function ResetDefaultDataDelegate(file)
end

-------------------------------------------------------------------------
function SerializeFile(fileName, name, data)
    log("[Serialization] " .. fileName);

    local fullPath = GaoApp.MakeDocumentPath(fileName);
	local file = io.open(fullPath, "w");
    
    if (file) then
        io.output(file);

        log("  => write data to file: " .. fileName);
        log(">>>>>>>>>>>>>>>>>>>>>>>>>>");
        WriteData(name, data);
        WriteLine("return " .. name .. ";");
        log("<<<<<<<<<<<<<<<<<<<<<<<<<<");
        log(" ");

        io.flush();
        io.close(file);
    else
        log("  => failed to open file: " .. fullPath);
    end
end

-------------------------------------------------------------------------
function WriteData(name, data, comma, depth)
    depth = depth or 0;

    local prefix = "";
    for i = 1, depth do
        prefix = prefix .. "  ";
    end
    
    if (depth == 0) then
        WriteLine(string.format("%s = {", name));
    else
        local nameType = type(name);
        if (nameType == "number") then
            WriteLine(string.format("%s[%s] = {", prefix, name));
        elseif (nameType == "string") then
            WriteLine(string.format("%s[\"%s\"] = {", prefix, name));
        else
            assert(false, "Key type not supported: " .. ktype);
        end
    end

    depth = depth + 1;

    local prefix = "";
    for i = 1, depth do
        prefix = prefix .. "  ";
    end
    
    for key, value in pairs(data) do
        local ktype = type(key);
        local vtype = type(value);

        -- Data value
        local valueString;
        if (vtype == "number" or vtype == "boolean") then
            valueString = tostring(value);
        elseif (vtype == "string") then
            valueString = string.format("\"%s\"", value);
        elseif (vtype == "table") then
            WriteData(key, value, true, depth);
        else
            assert(false, "Value type not supported: " .. vtype);
        end

        -- Data key
        if (ktype == "number")  then
            if (vtype ~= "table") then
                WriteLine(string.format("%s[%s] = %s,", prefix, key, valueString));
            end
        elseif (ktype == "string") then
            if (vtype ~= "table") then
                WriteLine(string.format("%s[\"%s\"] = %s,", prefix, key, valueString));
            end
        else
            assert(false, "Key type not supported: " .. ktype);
        end
    end
    
    if (comma) then
        WriteLine(prefix .. "},");
    else
        WriteLine("}");
    end
end

-------------------------------------------------------------------------
function WriteLine(str)
    io.write(str .. "\n");

    log(str .. "\n");
end

-------------------------------------------------------------------------
function DumpData(data, name)
    name = name or "<table>"
    log(name .. " = {");
    
    for key, value in pairs(data) do
        if (type(value) == "table") then
            log(key .. " = {");
            DumpData(value);
            log("  }");
        else
            log("  " .. key .. " = " .. tostring(value));
        end
    end
    
    log("}");
end
--]]

--=======================================================================
-- Input
--=======================================================================

-------------------------------------------------------------------------
--[[
function OnDeviceShake()
    if (DeviceShakeDelegate ~= nil) then
        DeviceShakeDelegate();
    end
end
--]]

-------------------------------------------------------------------------
function OnDeviceAccelerate(x, y)
    log(string.format("[Acc Meter] x: %f  y: %f", x, y));
end

-------------------------------------------------------------------------
function OnEnterBackground()
    if (OnEnterBackgroundDelegate) then
        OnEnterBackgroundDelegate();
    end
end

-------------------------------------------------------------------------
function OnEnterForeground()
    if (OnEnterForegroundDelegate) then
        OnEnterForegroundDelegate();
    end
end

-------------------------------------------------------------------------
function OnReceiveLocalNotification()
    if (OnReceiveLocalNotificationDelegate) then
        OnReceiveLocalNotificationDelegate();
    end
end

-------------------------------------------------------------------------
function OnReceiveMemoryWarning()
    if (g_AppData:GetData("MWDebug")) then
        --ShowMemoryUsage("Warning!");
        --GaoApp.ShowMessage("Warning!", string.format("Lua Memory Usage: %.f KB", collectgarbage("count")));
    
        g_MemoryWarningCount = g_MemoryWarningCount + 1;
        g_MemoryWarningGO["StateMachine"]:ChangeState("show");
    end
end

--=======================================================================
-- Game Center
--=======================================================================

-------------------------------------------------------------------------
function OnGameCenterInitialized(result)
	if (OnGameCenterInitializedDelegate) then
		OnGameCenterInitializedDelegate(result);
	end
end

-------------------------------------------------------------------------
function OnGameCenterAuthorized(result)
    GC_HAS_AUTHORIZED = result;
    log("GC Authorized: [result] "..tostring(result));
	if (OnGameCenterAuthorizedDelegate) then
		OnGameCenterAuthorizedDelegate(result);
	end
end

-------------------------------------------------------------------------
function OnGameCenterScoreSubmitted(result)
    log("GC Score Submit: [result] "..tostring(result));
	if (OnGameCenterScoreSubmittedDelegate) then
		OnGameCenterScoreSubmittedDelegate(result);
	end
end

-------------------------------------------------------------------------
function OnGameCenterAchievementSubmitted(result, percent)
    log(string.format("GC Achievement Submit: [result] %s [pct] %.2f", tostring(result), percent));
	if (OnGameCenterAchievementSubmittedDelegate) then
		OnGameCenterAchievementSubmittedDelegate(result, percent);
	end
end

-------------------------------------------------------------------------
function OnGameCenterAchievementReset(result)
    log("GC Achievement Reset: [result] "..tostring(result));
	if (OnGameCenterAchievementResetDelegate) then
		OnGameCenterAchievementResetDelegate(result);
	end
end
