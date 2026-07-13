return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "ahmedkhalf/project.nvim" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- 设置标题
		dashboard.section.header.val = {
			"",
			"         .--------._",
			"         (`--'       `-.",
			"          `.______      `.",
			"       ___________`__     \\",
			"    ,-'           `-.\\     |",
			"   //                \\|    |\\",
			"  (`  .'~~~~~---\\     \\'   | |",
			"   `-'           )     \\   | |",
			"      ,---------' - -.  `  . '",
			"    ,'             `%`\\`     |",
			"   /                      \\  |",
			"  /     \\-----.         \\    \\",
			" /|  ,_/      '-._        \\   |",
			"(-'  /           /         \\  |",
			",`--<           |        \\  \\ |",
			"\\ |  \\         /%%        \\  \\|",
			" |/   \\____---'--`%        \\  \\",
			" |    '           `         \\  \\",
			" |                           \\  |",
			"  `--.__                      \\ |",
			"        `---._______           \\|",
			"                    `-.         |",
			"                       `._____.'",
			"",
		}

		-- 设置菜单按钮
		dashboard.section.buttons.val = {
			dashboard.button("l", "󰒲  插件管理", ":Lazy<CR>"),
			dashboard.button("q", "󰩈  退出", ":qa<CR>"),
		}

		-- 创建最近项目 section
		local function get_recent_projects()
			local projects_section = {
				type = "group",
				val = {},
				opts = { spacing = 0 },
			}

			local function is_excluded_project(project_path)
				local home = vim.fn.expand("~")
				local excluded_prefixes = {
					home .. "/.local/share/nvim/mason/",
					home .. "/.rustup/",
				}

				for _, prefix in ipairs(excluded_prefixes) do
					if vim.startswith(project_path, prefix) then
						return true
					end
				end

				return false
			end

			local function read_recent_projects()
				local history_file = vim.fn.stdpath("data") .. "/project_nvim/project_history"
				local root_markers = { ".git", "pyproject.toml", "package.json", "Makefile", "CMakeLists.txt" }
				local history = {}
				local recent_projects = {}
				local seen = {}

				if vim.fn.filereadable(history_file) == 1 then
					for line in io.lines(history_file) do
						if line ~= "" then
							table.insert(history, line)
						end
					end
				end

				for i = #history, 1, -1 do
					local project_path = history[i]
					local normalized_path = vim.fn.fnamemodify(project_path, ":p"):gsub("/$", "")
					local root = vim.fs.root(normalized_path, root_markers)
					if root and root ~= "" then
						normalized_path = root:gsub("/$", "")
					end
					if seen[normalized_path] == nil
						and vim.fn.isdirectory(normalized_path) == 1
						and not is_excluded_project(normalized_path)
					then
						seen[normalized_path] = true
						table.insert(recent_projects, normalized_path)
					end
				end

				return recent_projects
			end

			local recent_projects = read_recent_projects()

			local function find_readme(project_path)
				local preferred_files = {
					"README.md",
					"README.MD",
					"README",
					"readme.md",
					"readme",
				}

				for _, filename in ipairs(preferred_files) do
					local path = project_path .. "/" .. filename
					if vim.fn.filereadable(path) == 1 then
						return path
					end
				end

				local matches = vim.fn.glob(project_path .. "/[Rr][Ee][Aa][Dd][Mm][Ee]*", false, true)
				table.sort(matches)
				for _, path in ipairs(matches) do
					if vim.fn.filereadable(path) == 1 then
						return path
					end
				end

				return nil
			end

			local function open_project(project_path)
				local alpha_buf = vim.api.nvim_get_current_buf()
				vim.schedule(function()
					-- 切换工作目录
					vim.cmd("cd " .. vim.fn.fnameescape(project_path))

					-- 先保留一个普通编辑窗口，避免只剩 neo-tree 时触发退出。
					if vim.api.nvim_buf_is_valid(alpha_buf) and vim.api.nvim_get_current_buf() == alpha_buf then
						local readme = find_readme(project_path)
						if readme then
							vim.cmd("edit " .. vim.fn.fnameescape(readme))
						else
							vim.cmd("enew")
						end
					end

					if vim.api.nvim_buf_is_valid(alpha_buf) then
						pcall(vim.api.nvim_buf_delete, alpha_buf, { force = true })
					end

					-- 直接打开 neo-tree 到新目录
					vim.cmd("Neotree close")
					vim.cmd("Neotree dir=" .. vim.fn.fnameescape(project_path))
				end)
			end

			-- 如果有项目，显示标题
			if #recent_projects > 0 then
				table.insert(projects_section.val, {
					type = "text",
					val = "  最近项目",
					opts = {
						position = "center",
						hl = "AlphaHeader",
					},
				})

				table.insert(projects_section.val, {
					type = "padding",
					val = 1,
				})

				-- 添加最近 5 个项目
				local max_projects = 5
				for i, project_path in ipairs(recent_projects) do
					if i > max_projects then
						break
					end

					-- 提取项目名称（取路径的最后一部分）
					local project_name = vim.fn.fnamemodify(project_path, ":t")
					local display_text = string.format("%d.  %s", i, project_name)
					local selected_project_path = project_path

					local button = {
						type = "button",
						val = display_text,
						on_press = function()
							open_project(selected_project_path)
						end,
						opts = {
							position = "center",
							shortcut = tostring(i),
							cursor = 3,
							width = 40,
							align_shortcut = "right",
							hl_shortcut = "Keyword",
							keymap = {
								"n",
								tostring(i),
								function()
									open_project(selected_project_path)
								end,
								{ noremap = true, silent = true, nowait = true },
							},
						},
					}

					table.insert(projects_section.val, button)
				end
			else
				-- 如果没有项目，只显示提示（不显示标题）
				table.insert(projects_section.val, {
					type = "text",
					val = "暂无最近项目",
					opts = {
						position = "center",
						hl = "Comment",
					},
				})
			end

			return projects_section
		end

		-- 设置页脚
		dashboard.section.footer.val = {
			"",
			"    Code is cheap, show me your talk.",
			"",
			"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
			"",
		}

		-- 设置布局（调整 padding 让面板居中）
		dashboard.config.layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			get_recent_projects(),
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		-- 应用配置
		alpha.setup(dashboard.config)

		-- 在进入 alpha buffer 时禁用某些设置
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.opt_local.foldenable = false
			end,
		})

		-- 添加快捷键重新打开启动面板
		vim.keymap.set("n", "<leader>o", function()
			require("alpha").start()
		end, { desc = "打开启动面板", noremap = true, silent = true })
	end,
}
