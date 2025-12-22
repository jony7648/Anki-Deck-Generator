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

file.path_to_dir_name = function(path)
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

	local err_message = "Source file is a nil value"

	local bytes = src_file:read("*a")


	if src_file ~= nil and new_file ~= nil then
		new_file:write(bytes)
		return
	end

	print(err_message)

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


file.get_dir_table = function(path)
	local file_table = Util.str_split(os_capture("ls " .. path), ' ')
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




