return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional but recommended
    keys = {
        {
            "-", -- press `-` to open oil in current directory
            function() require("oil").open() end,
            desc = "Open parent directory (oil.nvim)",
        },
    },
    opts = {
        default_file_explorer = true, -- Hijack netrw
        view_options = {
            show_hidden = false,
        },
        float = {
            padding = 2,
            max_width = 80,
            max_height = 40,
        },
        keymaps = {
            ["h"] = "actions.parent",
        },
    },
}
