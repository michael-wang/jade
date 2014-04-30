USE_LUAJIT = true;

LUA_COMPILER = "../../tools/lua/luac";
LUAJIT = "../../tools/luajit/luajit";

CLEAN_TEMP_FILES = true;
OUTPUT_PATH = "../assets/AUl";

-- Modify list table should also update corresponding entry in SOURCE_LISTS.
BUILD_TARGETS = {
	{
		list_source = "Android/init_logger.lua",
		source_path = "Android",
		output_path = OUTPUT_PATH,
		output_name = "bootstrap.go",
	},

	{
		list_source = "Core/Core.lua",
		source_path = "Core",
		output_path = OUTPUT_PATH,
		output_name = "monkey.potion",
	},

	{
		list_source = "GameFunc/GameCore.lua",
		source_path = "GameFunc",
		output_path = OUTPUT_PATH,
		output_name = "soul.essence",
	},

	{
		list_source = "GameFunc/GameCore.lua",
		source_path = "GameData",
		output_path = OUTPUT_PATH,
		output_name = "love.essence"
	},
};

-- Call me after read FILELIST_SOURCE_FILES
function GET_SOURCE_NAME_LIST(index)
	SOURCE_LISTS = {
		-- { [optional] source list table, [optional] append source }
		{ {},                "init_logger" },
		{ CORE_SCRIPT_FILES, "Core" },
		{ GAME_FUNC_FILES,   "GameCore" },
		{ GAME_DATA_FILES,   "GamePuzzleImg" },
	};

	return SOURCE_LISTS[index][1], SOURCE_LISTS[index][2];
end

-- Append to file name in SOURCE_LISTS.
SOURCE_FILE_EXTENSION = "lua";
OUTPUT_SOURCE_FILE_EXTENSION = "lua";

-- Return table of source file names.
function BuildSourceFileList(fileListSource, sourceFolder, sourceListIndex)
	print("    BuildSourceFileList fileListSource:" .. fileListSource .. ", sourceFolder:" .. sourceFolder .. ", index:" .. tostring(sourceListIndex));

	print("        dofile: " .. fileListSource);
	dofile(fileListSource);

	local sourceNameList, appendSource = GET_SOURCE_NAME_LIST(sourceListIndex);

	if (appendSource ~= nil) then
		table.insert(sourceNameList, 1, appendSource);
	end

	local sourceFullPathList = {};
	for _, name in ipairs(sourceNameList) do
		local fullPath = string.format("%s/%s.%s", sourceFolder, name, SOURCE_FILE_EXTENSION);
		table.insert(sourceFullPathList, fullPath);
	end

	return sourceFullPathList;
end

function WriteToSingleFile(sourceFullPathList, outputFullPath)
	print("    WriteToSingleFile outputFullPath:" .. outputFullPath);

	local outputFile = io.open(outputFullPath, "w");
	io.output(outputFile);
	print("        Creating " .. outputFullPath);

	local lineCount = 0;

	for _, source in ipairs(sourceFullPathList) do
		print("        Writing: " .. source);

		for line in io.lines(source) do
			io.write(line .. "\n");
			lineCount = lineCount + 1;
		end
	end

	-- Close output file
	io.flush();
	io.close(outputFile);
	print(string.format("        Total lines: %d", lineCount));
end

function Compile(source, output)
	print("    Compile source:" .. source .. ", output:" .. output);

	local command;
	if USE_LUAJIT then
		command = LUAJIT .. " -b -t raw " .. source .. " " .. output;
	else
		command = LUA_COMPILER .. " -s -o " .. output .. " " .. source;
	end
	print(command);
	os.execute(command);
end

function Build()
	print("Build start.");

	for index, target in ipairs(BUILD_TARGETS) do
		local sourceFullPathList = BuildSourceFileList(target.list_source, target.source_path, index);

		local singleSourceFullPath = string.format("%s/%s.%s", target.output_path, target.output_name, OUTPUT_SOURCE_FILE_EXTENSION);
		WriteToSingleFile(sourceFullPathList, singleSourceFullPath);

		local outputFullPath = string.format("%s/%s", target.output_path, target.output_name);
		Compile(singleSourceFullPath, outputFullPath);

		if CLEAN_TEMP_FILES then
			os.remove(singleSourceFullPath);
		end

		print("=================================================================================");
	end

	print("Build complete.");
end

Build();