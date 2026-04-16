-- Rust 开发支持
-- 依赖: 需手动安装 rust-analyzer: rustup component add rust-analyzer
return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = "rust", -- 仅在打开 Rust 文件时加载
}
