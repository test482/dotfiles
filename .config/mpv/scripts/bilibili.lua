local utils = require("mp.utils")

function is_bilibili(url)
	return string.match(url, "bilibili%.com")
end

function assprocess()
	local url = mp.get_property("path")
	if is_bilibili(url) then
		local ass_path = "/tmp/bilibili.ass"
		-- https://github.com/gwy15/danmu2ass
		local command = "danmu2ass --no-web " .. url .. " -o " .. ass_path
		mp.msg.info(command)
		local handle = io.popen(command)
		handle:close()
		mp.commandv("sub-add", ass_path)
		-- 把没有 60 fps 的视频的帧率上采样至 60 fps
		-- https://github.com/THMonster/Revda/wiki/2-%E8%BF%9B%E9%98%B6%E7%94%A8%E6%B3%95#%E5%BD%95%E5%88%B6
		mp.commandv("set", "vf", "lavfi=\"fps=fps=60:round=down\"")
	end
end

mp.register_event("file-loaded", assprocess)
