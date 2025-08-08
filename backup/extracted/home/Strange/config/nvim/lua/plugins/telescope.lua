local builtin = require("telescope.builtin")

local  compact_preview = {
    width = 0.5,         -- 50% of screen width
    height = 0.4,        -- 40% of screen height
    prompt_position = "top", -- optional
  }
local wide_preview = {
    width = 0.95,
    height = 0.85,
    preview_width = 0.6,
}
local reader_preview = {
    width = 0.95,
    height = 0.85,
    preview_width = 0.8,
}
local themes = vim.fn.getcompletion("", "color")

local function set_transparency()
    vim.cmd [[
        hi Normal       guibg=NONE ctermbg=NONE
        hi NormalNC     guibg=NONE ctermbg=NONE
        hi EndOfBuffer  guibg=NONE
        hi FloatBorder  guibg=NONE
        hi NormalFloat  guibg=NONE
    ]]
    vim.cmd [[
        hi StatusLine    guibg=NONE guifg=#ffffff
        hi StatusLineNC  guibg=NONE guifg=#888888
        hi StatusLine    guibg=NONE ctermbg=NONE
        hi StatusLineNC  guibg=NONE ctermbg=NONE
        hi TabLine       guibg=NONE ctermbg=NONE
        hi TabLineFill   guibg=NONE ctermbg=NONE
        hi TabLineSel    guibg=NONE ctermbg=NONE
        hi WinSeparator  guibg=NONE guifg=Grey
    ]]
end
---| Color | Code      |
---| ----- | --------- |
---| White | `#ffffff` |
---| Grey  | `#888888` |
---| Green | `#a7c080` |
---| Cyan  | `#59cbf0` |
---| Red   | `#ff5555` |

-- Set default theme
---| THEMES   | THEMES  |
-----------------------------------------
---|carbonfox | Industry|
---|torte     | elflord |
---|ron       |         |
---|quit      |         |
---|sorbet    |         |
---|blue      |         |
---|slate     |         |
---|murphy    |         |

local default_theme = "sorbet"
local ok = pcall(vim.cmd.colorscheme, default_theme)
if ok then
  set_transparency()
else
  vim.notify("Default colorscheme not found: " .. default_theme, vim.log.levels.ERROR)
end

-- Telescope fuzzy theme picker with live preview
vim.keymap.set("n", "<leader>ft", function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local previewed = nil

pickers.new({}, {
  prompt_title = "Select Colorscheme",
  finder = finders.new_table {
    results = themes,
  },
  sorter = conf.generic_sorter({}),
  layout_strategy = "center",
  layout_config = compact_preview,
  attach_mappings = function(prompt_bufnr, map)
    local function preview_theme()
      local selection = action_state.get_selected_entry()
      if selection and selection[1] ~= previewed then
        local ok = pcall(vim.cmd.colorscheme, selection[1])
        if ok then
          set_transparency()
          previewed = selection[1]
        end
      end
    end

    map("i", "<C-n>", function()
      actions.move_selection_next(prompt_bufnr)
      preview_theme()
    end)

    map("i", "<C-p>", function()
      actions.move_selection_previous(prompt_bufnr)
      preview_theme()
    end)

    map("n", "j", function()
      actions.move_selection_next(prompt_bufnr)
      preview_theme()
    end)

    map("n", "k", function()
      actions.move_selection_previous(prompt_bufnr)
      preview_theme()
    end)

    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      actions.close(prompt_bufnr)
      local ok = pcall(vim.cmd.colorscheme, selection[1])
      if ok then
        set_transparency()
      else
        vim.notify("Colorscheme not found: " .. selection[1], vim.log.levels.WARN)
      end
    end)

    return true
  end,
}):find()
end, { desc = "Fuzzy pick theme" })
-------------------------------------------------------------------------------------------------------------------------------------

-- Fuzzy find files, including hidden files
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files({ hidden = true })
end, { desc = "Find files (including hidden)" })

vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").live_grep({
    layout_config = reader_preview,})
end)

-- Recently opened files
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {  desc = "Recently opened files" })

-- Open buffers (already open files)
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Open buffers" })

-- DOTFILES
vim.keymap.set("n", "<leader>fd", function()
  builtin.find_files({
    prompt_title = "Dotfiles",
    cwd = vim.fn.expand("~/.config"),
    hidden = true,
    no_ignore = true,
    layout_config = reader_preview,
    previewer = true,
  })
end, { desc = "Find dotfiles with preview" })

-- Fuzzy help (:help)
vim.keymap.set("n", "<leader>fh", function()
  require("telescope.builtin").help_tags({
    layout_config = wide_preview,
    previewer = true,
  })
end, { desc = "Fuzzy help (:help)" })

-- Fuzzy man pages
vim.keymap.set("n", "<leader>fm", function()
  require("telescope.builtin").man_pages({
    sections = { "ALL" },
    layout_config = wide_preview,
  })
end, { desc = "Fuzzy man pages" })

--Fuzzy nvim commandss history
vim.keymap.set("n", "<leader>fc", function()
  require("telescope.builtin").command_history({
    layout_strategy = "horizontal",
    layout_config = wide_preview,
  })
end, { desc = "Fuzzy command history" })
--Fuzzy nvim commandss
vim.keymap.set("n", "<leader>fC", function()
  require("telescope.builtin").commands({
    layout_strategy = "horizontal",
    layout_config = wide_preview,
  })
end, { desc = "Fuzzy Neovim commands" })

vim.keymap.set("n", "<leader>fe", function()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = true,
    initial_mode = "normal",
    layout_strategy = "horizontal",
    layout_config = wide_preview,
  })
end, { desc = "Telescope File Browser" })
