local utils = require("mp.utils")

local function is_bilibili_video(url)
	-- avoid live.bilibili.com
	return string.match(url, "^https?://w?w?w?%.?bilibili%.com/") -- bilibili.com & www.bilibili.com
		or string.match(url, "^https?://b23%.tv/")
end

local function b23_to_bv(b23url)
	local res = mp.command_native {
		name = "subprocess",
		args = {
			"curl", "--location", "--silent", "--fail", "--globoff",
			string.format("https://b23.wtf/api?full=%s&status=200", b23url)
		},
		capture_stdout = true,
		playback_only = false,
	}

	if res.status ~= 0 then
		return nil
	end

	return res.stdout:gsub("%s+$", "")
end

local function call_danmu_downloader(video_url, ass_path)
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

function bilibili_video_assprocess()
	local video_url = mp.get_property("path")

	if is_bilibili_video(video_url) then
		-- convert b23.tv short url to bv url
		if string.match(video_url, "^https://b23%.tv/") then
			video_url = b23_to_bv(video_url) or video_url
			mp.msg.info(string.format("converted b23.tv url to: %s", video_url))
		end

		-- danmu2ass 1.0.1 only support bv url, av url will return (-400) request error
		local video_id = string.match(video_url, "video/([bB][vV]%w+)")
		if not video_id then
			return
		end

		local video_p_num = string.match(video_url, "%?p=(%d+)")

		-- e.g. BV1q2w3e4r5t BV1q2w3e4r5t_p1 BV1q2w3e4r5t_p2
		local ass_filename
		if video_p_num then
			ass_filename = string.format("%s_p%s", video_id, video_p_num)
		else
			ass_filename = video_id
		end

		local ass_dir = utils.join_path(os.getenv("XDG_RUNTIME_DIR") or "/tmp", "danmu2ass")
		if not utils.file_info(ass_dir) then
			os.execute("/usr/bin/mkdir -p " .. ass_dir)
		end

		local ass_path = string.format("%s/%s.ass", ass_dir, ass_filename)

		call_danmu_downloader(video_url, ass_path)
	end
end

mp.register_event("file-loaded", bilibili_video_assprocess)
