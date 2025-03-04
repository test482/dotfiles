local utils = require("mp.utils")

function is_bilibili_video(url)
	-- avoid live.bilibili.com
	return string.match(url, "^https://www%.bilibili%.com/") or string.match(url, "^https://bilibili%.com/")
end

function assprocess()
	local url = mp.get_property("path")
	if is_bilibili_video(url) then
		local ass_path = "/tmp/bilibili.ass"
		-- https://github.com/gwy15/danmu2ass
		local command = "danmu2ass --no-web " .. url .. " -o " .. ass_path
		mp.msg.info(command)
		local handle = io.popen(command)
		handle:close()
		mp.commandv("sub-add", ass_path)
		-- 把没有 60 fps 的视频的帧率上采样至 60 fps
		-- https://github.com/THMonster/Revda/wiki/2-进阶用法#录制
		mp.commandv("set", "vf", 'lavfi="fps=fps=60:round=down"')
	end
end

mp.register_event("file-loaded", assprocess)
