local Util = {}

Util.os_capture = function(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

Util.in_range = function(number, min, max)
	if tonumber(number) > max or tonumber(number) < min then
		return false
	end

	return true
end

Util.str_replace = function(str, targ_sub_str, rep_sub_str)
	local new_str = str
	local peak_len = #targ_sub_str
	local peak_index = peak_len
	local iter_sub_str = ""

	local iteration = 1
	while iteration <= #str do
		peak_index = iteration + peak_len

		iter_sub_str = str:sub(iteration, peak_index - 1)

		if iter_sub_str == targ_sub_str then
			new_str = str:sub(1, iteration-1)
			new_str = new_str .. rep_sub_str
			new_str = new_str .. str:sub(peak_index, #str)
			iteration = iteration + #rep_sub_str
			break
		else
			iteration = iteration + 1
		end
	end

	return new_str
end

Util.str_strip = function(str)
	--remove spaces from start
	if str:sub(1,1) == ' ' then
		for i=2, #str, 1 do
			if str:sub(i,i) ~= ' ' then
				str = str:sub(i,#str)
				break
			end
		end
	end

	--remove spaces from end
	if str:sub(#str, #str) == ' ' then
		for i=#str - 1, 1, -1 do 
			if str:sub(i,i) ~= ' ' then
				str = str:sub(1,i)
				break
			end
		end
	end

	return str
end

Util.str_split = function(str, split_char)
	local new_table = {}

	local start_pos = 0

	for i=1, #str, 1 do
		local char = string.sub(str, i,i)

		if char == split_char then
			local sub_str = Util.str_strip(string.sub(str, start_pos, i-1))
			start_pos = i+1
			table.insert(new_table, sub_str)
		elseif i == #str then
			local sub_str = Util.str_strip(string.sub(str, start_pos, i))
			table.insert(new_table, sub_str)
		end
	end

	return new_table
end

Util.choose_from_table = function(src_table, max_per_screen)
	local DEFAULT_MAX_PER_SCREEN = 10
	local viewing_table = true
	local start_pos = 0
	local stop_pos = 0
	local current_elem = nil
	local user_choice = ""

	if max_per_screen == nil then
		max_per_screen = DEFAULT_MAX_PER_SCREEN
	end


	while viewing_table do
		stop_pos = #start_pos + max_per_screen

		if start_pos < 1 then
			start_pos = 1
		end
		if end_pos > #src_table then
			stop_pos = #src_table
		end

		for i=start_pos, stop_pos, 1 do 
			current_elem = src_table[i]

			print(i .. ": " .. current_elem)
		end

		print("Choice")
		user_choice = io.read()
	end
end

return Util
