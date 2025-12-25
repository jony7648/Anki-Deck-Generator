local FileUtil = require "file_util"

local InfoTable = {}
local Card = {}

local new_image_card = function(self, image_path, front)
	local card = Card.new()

	
	card.image_name = FileUtil.path_to_file_name(image_path)
	card.image_path = image_path
	card.back = card.image_name

	if front == nil then
		card.front = card.image
	else
		card.front = front
	end


	table.insert(self.cards, card)
end

local create_anki_deck = function(self)
	local file_ref = io.open("output.txt", "w")
	local write_line = ""
	local card_front = ''
	local image_front = ""
	
	if file_ref == nil then
		return
	end

	for i,card in ipairs(self.cards) do
		card_front = ''

		if card.front ~= nil and card.front ~= '' then
			print("Nugs")
			card_front = card.front
		end

		print(card.image_path)
		if card.image_name ~= '' and card.image_path ~= '' then
			FileUtil.copy_file(card.image_path, self.options_table.collection_dir .. "/" .. card.image_name)

			image_front = string.format("<br><img src=\"%s\">", card.image_name)
			card_front = card_front .. image_front

		end


		write_line = string.format("%s;%s", card_front, card.back)

		file_ref:write(write_line .. "\n")
	end

	file_ref:close()
end



Card.new = function()
	local self = {}
	self.front = ""
	self.back = ""
	self.image_name = ""
	self.image_path = ""
	return self
end

InfoTable.new = function() 
	local self = {}
	self.base_entry = ""
	self.output_file = ""
	self.header = {}
	self.cards = {}
	self.options_table = {}

	self.new_image_card = new_image_card
	self.create_anki_deck = create_anki_deck
	self.set_options_table = function(self, options_table) self.options_table = options_table end

	return self
end


return InfoTable


