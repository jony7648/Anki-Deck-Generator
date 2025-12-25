local file = {}
local Util = require "util"

local function os_capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

file.file_is_dir = function(path)
	if os_capture(string.format("test -d %s && echo \"yes\" || echo \"no\"", path)) == "yes" then
		return true
	end

	return false
end

file.path_to_file_name = function(path)
	local char

	for i=#path, 1, -1 do 
		char = path:sub(i,i)

		if char == "/" then
			return path:sub(i+1,#path)
		end
	end

	return path
end

file.copy_file = function(src_path, copy_path)
	local src_file = io.open(src_path, "rb")
	local new_file = io.open(copy_path, "wb")
	local bytes = ""

	if src_file == nil then
		print(src_file, new_file)
		print("Source value is a nil value")
		return
	elseif new_file == nil then
		print("New File is a nil value")
		return
	end

	bytes = src_file:read("*a")
	new_file:write(bytes)
end

file.replace_env_variables = function(src_str)
	local new_str = src_str
	local marker = '$'
	local start_index = 0
	local end_index = 0
	local env_var = ''
	local current_char = ''

	local env_table = {}
	
	--gather enviroment variables
	for i=1,#src_str, 1 do
		current_char = src_str:sub(i,i)

		if current_char == marker then
			start_index = i+1
		elseif start_index ~= 0 and current_char == '/' then
			env_var = src_str:sub(start_index, i-1)
			table.insert(env_table, env_var)
		end
	end

	for i,env_var in ipairs(env_table) do
		new_str = Util.str_replace(new_str, marker .. env_var, os.getenv(env_var))
	end
	
	return new_str
end

file.copy_dir = function(src_path, copy_path, copy_index)
	if copy_index == nil then
		copy_index = -1
	end

	if src_path == copy_path then
		print("Your source and output path's are the same!")
		return
	end

	local file_table = Util.str_split(os_capture("ls " .. src_path), ' ')
	local chapter_table = {}
	local src_file_path
	local new_file_path
	local src_file = nil
	local new_file = nil
	local file_data = nil



	for i,v in ipairs(file_table) do 
		if file.file_is_dir(v) == false then
			table.insert(chapter_table, v)
		end
	end

	for i,v in ipairs(chapter_table) do 
		src_file_path = string.format("%s/%s", src_path, v)
		new_file_path = string.format("%s/%s", copy_path, v)

		if copy_index ~= nil then
			new_file_path = new_file_path .. "_file" .. copy_index
			copy_index = copy_index + 1
		end

		src_file = io.open(src_file_path, "rb")
		new_file = io.open(new_file_path, "wb")

		if src_file ~= nil and new_file ~= nil then
			file_data = src_file:read("*a")
			new_file:write(file_data)

			src_file:close()
			new_file:close()
		end
	end

	return copy_index
end

file.get_cwd = function()
	local cwd = os_capture("pwd")

	return cwd
end

file.get_file_table = function(path)
	local file_table = Util.str_split(os_capture("ls " .. path), ' ')

	for i,file in ipairs(file_table) do
		file_table[i] = path .. "/" .. file
	end


	return file_table
end

file.get_dir_table = function(path)
	local file_table = file.get_file_table(path)
	local dir_table = {}
	local new_path

	for i, v in ipairs(file_table) do
		if file.file_is_dir(v) == true then
			new_path = path .. "/" .. file_table[i]
			table.insert(dir_table, new_path)
		end
	end

	return dir_table
end

return file




