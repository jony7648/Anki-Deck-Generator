local FileUtil = require "file_util"
local Util = require "util"
local Parser = require "parser"
local Convert = require "convert"



local input_path = "conf.txt"

local info_table = Parser.parse_text_file(input_path)
Convert.create_anki_deck(info_table)
