local FileUtil = require "file_util"
local Util = require "util"
local Parser = require "parser"
local Convert = require "convert"

local cwd = Util.os_capture("pwd")

local config_path = "config.cfg"
local image_dir_path = cwd .. "/image_dir"
local input_path = "cards.txt"

local info_table = {}
local config_table = {}


config_table = Parser.get_config_table(config_path)
info_table = Parser.get_info_from_image_dir(image_dir_path)

info_table:set_options_table(config_table)
info_table:create_anki_deck()
--Convert.create_anki_deck(info_table)


--Convert.create_anki_deck(info_table)
