local Util = require "util"
local FileUtil = require "file_util"
local Parser = {}

local InfoTable = require "info_table"

Parser.get_key_from_text = function(src_str, lower)
	local char = ''
	local value_index_offset = 2

	if src_str == nil then
		return {}
	end

	local key = ''
	local value = ''

	for i=1, #src_str, 1 do
		char = src_str:sub(i,i)

		if char == ":" then
			key = src_str:sub(1, i-1)
			value = src_str:sub(i + value_index_offset, #src_str)
			break
		end
	end

	if key == nil or value == nil then
		key = ''
		value = ''
	elseif lower then
		key:lower()
		value:lower()
	end

	return {key = key, value = value}
end

Parser.parse_text_file = function(file_path)
	local file_ref = nil
	local file_data_table = {}
	local start_line = 0
	local empty_check = nil

	local info_table = {
		base_entry = "",
		output_file = "",
		header = {},
		cards = {}
	}

	file_ref = io.open(file_path, "r")

	if file_ref == nil then
		return {}
	end

	file_data_table = Util.str_split(file_ref:read("*a"), '\n')

	file_ref:close()
	file_ref = nil

	for i,v in ipairs(file_data_table) do
		local line_dict = Parser.get_key_from_text(v)
		start_line = i+1

		if Util.str_strip(v) == '' then
			break
		end

		
		info_table[line_dict.key] = line_dict.value
		--[[
		if line_dict.key == "base_entry" then
			info_table.base_entry = line_dict.value
		elseif line_dict.key == "output_file" then
			info_table.output_file = line_dict.value
		end
		--]]
	end

	for i=start_line, #file_data_table, 1 do 
		local line_data = file_data_table[i]


		empty_check = next(info_table.header)

		if empty_check == nil then
			line_data:lower()
		end

		if line_data == nil then
			goto continue
		end
			
		local card_data = Util.str_split(line_data, ';')


		if empty_check == nil then
			info_table.header = card_data
			goto continue
		end

		table.insert(info_table.cards, card_data)

		::continue::
	end

	return info_table
end

Parser.get_config_table = function(config_path)
	local file_ref = io.open(config_path, "r")		
	local file_data_table = {}
	local line_table = {}
	local config_table = {
		output_flie = "",
		create_from_dir = "",
		collection_dir = "",
	}

	if file_ref == nil then
		return {}
	end

	file_data_table = Util.str_split(file_ref:read("*a"), '\n')
	file_ref:close()
	file_ref = nil

	for i,line in ipairs(file_data_table) do
		line_table = Parser.get_key_from_text(line)

		if line_table.key == "collection_dir" then
			line_table.value = FileUtil.replace_env_variables(line_table.value)
		end

		config_table[line_table.key] = line_table.value
	end

	print(config_table.output_file)

	return config_table
end

Parser.get_info_from_image_dir = function(image_dir)
	local file_table = FileUtil.get_file_table(image_dir)
	local iter_path = ""
	local iter_extension = ""

	local info_table = InfoTable.new()

	local iteration = 1
	while iteration <= #file_table do
		iter_path  = file_table[iteration]

		iter_extension = iter_path:sub(#iter_path - 2, #iter_path)

		if iter_extension ~= "png" and iter_extension ~= "jpg" then
			table.remove(file_table, iteration)
			iteration = iteration - 1
		end

		
		iteration = iteration + 1
	end

	for i,file in ipairs(file_table) do
		info_table:new_image_card(file)
	end

	return info_table
end

return Parser
