local M = {}

-- TODO(build-system): 将 <leader>m 提升为跨语言的项目构建接口。
-- 保留稳定动作（prepare/build/run/clean/target/profile/args），并为
-- CMake、Cargo、uv 分别提供显式适配器；不支持的动作必须明确提示。
-- 在该模块落地前，现有映射仍直接调用 CMake 命令。
M.keys = {
	{ "<leader>mg", "<cmd>CMakeGenerate<CR>", desc = "CMake 生成/配置" },
	{ "<leader>mb", "<cmd>CMakeBuild<CR>", desc = "CMake 构建" },
	{ "<leader>mr", "<cmd>CMakeRun<CR>", desc = "CMake 运行" },
	{ "<leader>mA", "<cmd>CMakeTargetSettings<CR>", desc = "目标设置（参数+环境变量）" },
	{ "<leader>mc", "<cmd>CMakeClean<CR>", desc = "CMake 清理" },
	{ "<leader>mt", "<cmd>CMakeSelectBuildTarget<CR>", desc = "选择构建目标" },
	{ "<leader>ml", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "选择运行目标" },
	{ "<leader>mp", "<cmd>CMakeSelectBuildPreset<CR>", desc = "选择构建预设" },
}

return M
