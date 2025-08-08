-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.g.mapleader = ' '
vim.opt.clipboard = "unnamedplus"

vim.g.my_status_extra = "««•---- ❖◈❖◈❖◈❖◈ ----•»»\u{200A}"
vim.opt.laststatus = 2
vim.opt.showmode = true
vim.o.cmdheight = 0

--"❀❀❀❀❀"
--««•---- ❖◈❖◈❖◈❖◈ ----•»»
--"✥✦✥✦✥"
--"❁❁❁❁❁"
--"❃❃❃❃❃"
--"✢✢✢✢✢"
--"✱✱✱✱✱"
--"✲✲✲✲✲"
--"✳✳✳✳✳"
--"✴✴✴✴✴"
--"✶✶✶✶✶"
--"❇❇❇❇❇"
--"❈❈❈❈❈"
--"❊❊❊❊❊"
--"❋❋❋❋❋"
--"✻✻✻✻✻"
--"✼✼✼✼✼"
--"✽✽✽✽✽"
--"✾✾✾✾✾"
--"❂❂❂❂❂"
--"❍❍❍❍❍"
--"❏❏❏❏❏"
vim.opt.statusline = [[ %{exists('*FugitiveHead') && FugitiveHead() !=# '' ? ' ' . FugitiveHead() : ''} %f %m%r %= %{g:my_status_extra} %= %y|%l:%c [Strange][%p%%] ]]
