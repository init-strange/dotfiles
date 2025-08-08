---- BASIC LSP MAPPINGS (VS CODE STYLE)
vim.keymap.set("n", "K", vim.lsp.buf.hover,{})                 -- show docs
vim.keymap.set("n", "gd", vim.lsp.buf.definition,{})           -- go to def
vim.keymap.set("n", "gr", vim.lsp.buf.references,{})           -- show references
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,{})       -- rename symbol
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,{})  -- code action
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float,{}) -- show error popup
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,{})         -- prev error
vim.keymap.set("n", "]d", vim.diagnostic.goto_next,{})         -- next error

-- Show function signature help in insert mode
vim.keymap.set("i", "<C-s>", function()
  vim.lsp.buf.signature_help()
end, { desc = "Show signature help" })


-- Format buffer (async)
vim.keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Document symbols
vim.keymap.set("n", "<leader>lds", vim.lsp.buf.document_symbol, { desc = "Document symbols" }) -- Document symbols (current file)
vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" }) --Workspace symbols(allfiles inLSP project)

-------------------------------------------------------------------------------------------------------------------------------------

--split movement made easy
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")

--vertical resize using leader - = 
vim.keymap.set("n", "<leader>=", ":resize +2<CR>")
vim.keymap.set("n", "<leader>-", ":resize -2<CR>")
--vertical resize using leader < > 
vim.keymap.set("n", "<leader>,", ":vertical resize -2<CR>")
vim.keymap.set("n", "<leader>.", ":vertical resize +2<CR>")

-- Rearrange splits intuitively
vim.keymap.set("n", "<leader>wh", "<C-w>H", { desc = "Move window to left (vertical)" })
vim.keymap.set("n", "<leader>wk", "<C-w>K", { desc = "Move window to top (horizontal)" })
vim.keymap.set("n", "<leader>wr", "<C-w>r", { desc = "Rotate window layout" })

-- Horizontal split terminal
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", {
  desc = "Terminal in horizontal split",
})
-- Vertical split terminal
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", {
  desc = "Terminal in vertical split",
})

local float_term = require("core.floating-term")
vim.keymap.set("n", "<leader>tf", float_term.toggle, { desc = "Toggle floating terminal" })

-- Terminal mode keymaps (these can still live in keymaps.lua)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal input mode" })
vim.keymap.set("t", "<leader>h", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<leader>j", [[<C-\><C-n><C-w>l]])
vim.keymap.set("t", "<leader>k", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<leader>l", [[<C-\><C-n><C-w>k]])

-------------------------------------------------------------------------------------------------------------------------------------
---move between tabs
-- Navigation
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tb", ":tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Close all other tabs" })
-- Management
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>te", ":tabedit ", { desc = "Edit file in new tab" }) 
vim.keymap.set("n", "<leader>tm", ":tabmove ", { desc = "Move tab to index" })
-- Quick tab creation
vim.keymap.set("n", "<leader>ts", ":tab split<CR>", { desc = "Move current window to new tab" })
--Quick tab switch
for i=1,9 do 
    vim.keymap.set("n" ,"<leader>"..i,function()
        vim.cmd("tabnext"..i)
    end,{desc="Go to tab"..i})
end
-------------------------------------------------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Previous buffer" }) -- Previous buffer
vim.keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Next buffer" }) -- Next buffer
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" }) -- Delete buffer


-- Toggle cmdheight between 1 and 0
vim.keymap.set("n", "<leader>ch", function()
  if vim.o.cmdheight == 1 then
    vim.o.cmdheight = 0
  else
    vim.o.cmdheight = 1
  end
end, { desc = "Toggle cmdheight" })
--
