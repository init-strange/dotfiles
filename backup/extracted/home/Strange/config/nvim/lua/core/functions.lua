
-------------------------------------------------------------------------------------------------------------------------------------

--vim.api.nvim_create_user_command("LspRestart", function()
--  for _, client in pairs(vim.lsp.get_clients()) do
--    client.stop()
--  end
--  vim.cmd("edit")
--end, {})
-- Stop all active LSP clients
--
-- Stop all active LSP clients
vim.api.nvim_create_user_command("LspStopAll", function()
  for _, client in pairs(vim.lsp.get_clients()) do
    client.stop()
  end
  print("All LSP clients stopped.")
end, {})

-- Start LSP clients for all loaded buffers
vim.api.nvim_create_user_command("LspStartAll", function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("edit") -- triggers LSP attach
      end)
    end
  end
  print("LSP started for all buffers.")
end, {})

-- Restart all LSP clients (delayed to avoid race condition)
vim.api.nvim_create_user_command("LspRestartAll", function()
  vim.cmd("LspStopAll")
  vim.defer_fn(function()
    vim.cmd("LspStartAll")
  end, 300) -- wait 300ms before starting
end, {})

-- NewProject 
local project_root = "~/init-strange/projects/playground"
vim.api.nvim_create_user_command("NewProject", function(opts)
  local name = opts.args
  if name == "" then
    print("Usage: :NewProject <project-name>")
    return
  end
  local dir = vim.fn.expand(project_root .. "/" .. name)
  vim.fn.mkdir(dir, "p")
  vim.cmd("cd " .. dir)
  vim.cmd("enew")
end, { nargs = 1, complete = "dir" })

