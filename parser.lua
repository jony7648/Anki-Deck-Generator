local Util = require "util"
local Parser = {}

Parser.get_key_from_text = function(src_str, lower)
	local char = ''
	local value_index_offset = 2

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

	if key == '' then
		return {}
	end

	if lower then
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

		if line_dict.key == "base_entry" then
			info_table.base_entry = line_dict.value
		elseif line_dict.key == "output_file" then
			info_table.output_file = line_dict.value
		end
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

Parser.get_info_from_image_dir = function()

end

return Parser
