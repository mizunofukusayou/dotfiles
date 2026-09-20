-- ~/.wezterm.lua として保存
local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.automatically_reload_config = true
config.use_ime = true

----------------------------------------------------
--  見た目の設定
----------------------------------------------------
-- フォントの設定
config.font = wezterm.font_with_fallback({
	-- "Klee-Medium",
	"JetBrains Mono",
	"BIZ UDGothic",
	-- "Klee-Demibold",
	-- { family = "Klee", weight = "Demibold" },
	-- "YuMincho",
})

-- フォントサイズ
config.font_size = 18.0

-- ウィンドウ内の余白設定
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- 立ち上げ時のウィンドウサイズ
config.initial_cols = 230
config.initial_rows = 80

-- タブバーの角をとる
config.use_fancy_tab_bar = true

-- タブバーの背景透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブが1つだけの場合はタブバーを隠す
config.hide_tab_bar_if_only_one_tab = true

-- タブバーの +, x を消す
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

-- アクティブタブに色をつける
-- タブの左右の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end
	local edge_foreground = background

	-- タブのタイトルをカレントディレクトリにする
	local cwd = tab.active_pane.current_working_dir.file_path:match("([^/]+)/?$")
	local title = "   " .. wezterm.truncate_left(cwd, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

----------------------------------------------------
-- キーバインドの設定
----------------------------------------------------
config.keys = {
	-- Cmd + T で新しいタブを作成
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	-- Cmd + W で現在のタブを閉じる
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = true }) },

	-- ペイン分割 (Split)
	-- Cmd + d で左右に分割
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Cmd + Shift + d で上下に分割
	{ key = "D", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- ペインの移動 (Activate)
	-- Cmd + 矢印キーで隣のペインに移動
	{ key = "LeftArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },

	-- ペインを閉じる
	-- Cmd + x で現在のペインを閉じる
	{ key = "x", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- Cmd + y で現在のペインの最後の出力をクリップボードにコピー
	{
		key = "y",
		mods = "CMD",
		action = wezterm.action_callback(function(window, pane)
			local zones = pane:get_semantic_zones("Output")
			if #zones == 0 then
				return
			end
			local last_zone = zones[#zones]
			local text = pane:get_text_from_semantic_zone(last_zone)
			if text then
				window:copy_to_clipboard(text, "Clipboard")
			end
		end),
	},
}

-- # MacOSでOptionキーをMetaキーとして使用する
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

return config
