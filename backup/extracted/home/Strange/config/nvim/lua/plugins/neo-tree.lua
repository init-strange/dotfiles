
--Neo tree plugins
vim.keymap.set("n", "<leader>N", function()
  require("neo-tree.command").execute({
    toggle = true,
    position = "left",
    dir = vim.fn.getcwd(), -- always open at root
  })
end, { desc = "Neo-tree at project root (cwd)" })

vim.keymap.set("n", "<leader>n", function()
  local ok, _ = pcall(require("neo-tree.command").execute, {
    toggle = true,
    reveal = true,
    position = "left",
    dir = nil, -- don't change root
  })
  if not ok then
    vim.notify("File not under Neo-tree root. Won’t change root.", vim.log.levels.WARN)
  end
end, { desc = "Reveal file in Neo-tree (no root change)" })
-------------------------------------------------------------------------------------------------------------------------------------
