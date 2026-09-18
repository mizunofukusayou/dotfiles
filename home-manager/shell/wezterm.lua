-- ~/.wezterm.lua として保存
local wezterm = require("wezterm")
local config = {}

-- 最新の構成ビルダーを使用（利用可能な場合）
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- --- 見た目の設定 ---
-- カラースキーム（配色）の設定
config.color_scheme = "Gruvbox Material Dark"

-- フォントの設定
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"BIZ UDGothic",
})
config.font_size = 18.0

-- ウィンドウ内の余白設定
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- --- タブバーの設定 ---
-- シンプルなタブバーを使用する
config.use_fancy_tab_bar = false
-- タブが1つだけの場合はタブバーを隠す
config.hide_tab_bar_if_only_one_tab = true

-- --- キーバインドの設定 ---
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
