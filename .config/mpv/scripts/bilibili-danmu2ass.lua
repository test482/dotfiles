local utils = require("mp.utils")

function is_bilibili_video(url)
	-- avoid live.bilibili.com
	return string.match(url, "^https://www%.bilibili%.com/") or string.match(url, "^https://bilibili%.com/")
end

function assprocess()
	local video_url = mp.get_property("path")

	if is_bilibili_video(video_url) then
		-- danmu2ass 1.0.1 only support bv url, av url will return (-400) request error
		local video_id = string.match(video_url, "video/([bB][vV][%a%d]+)")

		if not video_id then
			return
		end

		local ass_dir = utils.join_path(os.getenv("XDG_RUNTIME_DIR") or "/tmp", "danmu2ass")
		if not utils.file_info(ass_dir) then
			os.execute("/usr/bin/mkdir -p " .. ass_dir)
		end

		local ass_path = string.format("%s/%s.ass", ass_dir, video_id)

		-- https://github.com/gwy15/danmu2ass
		local command = { "danmu2ass", "--no-web", video_url, "-o", ass_path }
		mp.msg.info(table.concat(command, " "))

		if mp.command_native({ name = "subprocess", args = command, capture_stdout = false, capture_stderr = true, playback_only = false }) then
			mp.commandv("sub-add", ass_path)

			-- 把没有 60 fps 的视频的帧率上采样至 60 fps
			-- https://github.com/THMonster/Revda/wiki/2-进阶用法#录制
			local fps = mp.get_property_number("container-fps")
			if fps and fps < 60 then
				mp.commandv("set", "vf", 'lavfi="fps=fps=60:round=down"')
			end
		end
	end
end

mp.register_event("file-loaded", assprocess)
