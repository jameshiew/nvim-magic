local random = {}

math.randomseed(os.time())

local A_ORD = 97
local Z_ORD = 122

function random.generate_timestamped_string()
	local s = ''
	for _ = 1, 8 do
		s = s .. string.char(math.random(A_ORD, Z_ORD))
	end
	return os.date('%Y-%m-%d-%H-%M-%S-') .. s
end

return random
