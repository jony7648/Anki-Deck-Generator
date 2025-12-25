local Util = require "util"

local Convert = {}

Convert.create_anki_deck = function(info_table)
	local DEFAULT_OUTPUT_FILE_NAME = "output.txt"

	if info_table.output_file == '' then
		info_table.output_file = DEFAULT_OUTPUT_FILE_NAME
	end

	local out_file_ref = io.open(info_table.output_file, "wb")
	
	if out_file_ref == nil then
		return
	end

	local FRONT_INDEX = 1
	local BACK_INDEX = 2
	local IMAGE_INDEX = 3

	local front_entry = ""
	local back_entry = ""
	local image_entry = ""

	local current_entry = ""

	local write_table = {}

	local split_char = ';'

	for i, card in ipairs(info_table.cards) do
		current_entry = ""

		if info_table.base_entry ~= '' then
			card.front = Util.str_replace(info_table.base_entry, "{}", card.front)
		end


		for j,elem in ipairs(card) do 
			current_entry = string.format("%s%s%s", current_entry, elem, split_char)
		end


		print(current_entry)

		table.insert(write_table, current_entry)
	end

	for i,line in ipairs(write_table) do 
		out_file_ref:write(line .. "\n")
	end


	out_file_ref:close()
end


return Convert
