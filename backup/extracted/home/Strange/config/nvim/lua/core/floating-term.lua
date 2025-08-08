local M = {}

local float_term = {
  buf = nil,
  win = nil,
}

function M.toggle()
  if float_term.win and vim.api.nvim_win_is_valid(float_term.win) then
    vim.api.nvim_win_close(float_term.win, true)
    if float_term.buf and vim.api.nvim_buf_is_valid(float_term.buf) then
      vim.api.nvim_buf_delete(float_term.buf, { force = true })
    end
    float_term.buf = nil
    float_term.win = nil
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "terminal")

  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.5)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
border = { "+", "-", "+", "|", "+", "-", "+", "|" }
  })

  vim.fn.termopen(vim.o.shell)
  vim.cmd("startinsert")
  float_term.buf = buf
  float_term.win = win
end

return M
