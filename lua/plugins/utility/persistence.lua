return {
	"folke/persistence.nvim",
	lazy = false,
	opts = {
		-- 同一目录共用一个会话，不按 Git 分支拆分。
		branch = false,
	},
	config = function(_, opts)
		-- 只恢复普通文件及必要的编辑布局。
		-- 不保存空白窗口、帮助页、终端和本地选项；Neo-tree 的开关状态在下方单独处理。
		vim.opt.sessionoptions = {
			"buffers",
			"curdir",
			"folds",
			"tabpages",
			"winsize",
		}

		require("persistence").setup(opts)

		local state_group = vim.api.nvim_create_augroup("persistence_extra_state", { clear = true })

		local function neo_tree_state_file()
			return require("persistence").current() .. ".neo-tree"
		end

		vim.api.nvim_create_autocmd("User", {
			group = state_group,
			pattern = "PersistenceSavePre",
			callback = function()
				local is_open = false
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype == "neo-tree" then
						is_open = true
						break
					end
				end

				local state_file = neo_tree_state_file()
				if is_open then
					vim.fn.writefile({ "open" }, state_file)
				elseif vim.fn.filereadable(state_file) == 1 then
					vim.fn.delete(state_file)
				end
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			group = state_group,
			pattern = "PersistenceLoadPost",
			callback = function()
				if vim.fn.filereadable(neo_tree_state_file()) == 0 then
					return
				end

				-- 让 session 先恢复并聚焦原文件，再打开文件树。
				vim.schedule(function()
					vim.cmd("Neotree show")
				end)
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("persistence_auto_restore", { clear = true }),
			pattern = "VeryLazy",
			once = true,
			nested = true,
			callback = function()
				-- 显式指定文件时尊重启动参数，不加载已有会话。
				if vim.fn.argc() ~= 0 then
					return
				end

				-- VeryLazy 在 Alpha 等启动插件初始化完成后触发。
				require("persistence").load()
			end,
		})
	end,
}
