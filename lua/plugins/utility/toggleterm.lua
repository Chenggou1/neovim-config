local utils = require("core.utils")

-- 解析合适的工作目录（优先 neo-tree 当前根目录）
local function resolve_desired_cwd()
  local manager = utils.safe_require("neo-tree.sources.manager")
  if manager and type(manager.get_state) == "function" then
    local state = manager.get_state("filesystem")
    if state then
      local path = state.path or state.cwd
      if type(path) == "string" and path ~= "" then
        return path
      end
      if state.tree and state.tree.root and state.tree.root.path then
        return state.tree.root.path
      end
    end
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then
    local root = utils.find_project_root(file)
    if root and root ~= "" then
      return root
    end
    return vim.fn.fnamemodify(file, ":p:h")
  end

  return vim.loop.cwd()
end

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
        require("toggleterm").setup({
            size = 15,
            open_mapping = [[<C-\>]],
            hide_numbers = true,
            shade_terminals = true,
            start_in_insert = true,
            persist_size = true,
            direction = "horizontal",
            close_on_exit = true,
            shell = utils.get_preferred_shell(),
        })

        -- 初始化终端管理器
        local term_manager = require("core.term_manager")
        term_manager.setup_autocmds()

        -- 设置键位绑定
        local keys_mod = utils.safe_require("core.keymaps.toggleterm")
        if keys_mod and type(keys_mod.setup) == "function" then
            keys_mod.setup(term_manager, resolve_desired_cwd)
        end
    end,
}
