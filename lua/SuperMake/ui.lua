local ui = require("plenary.popup")
local storage = require("SuperMake.storage")
local helpers = require("SuperMake.helpers")

local winId


local function ShowMenu(opts, cb)
  local height = 10
  local width = 60
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  winId = ui.create(opts, {
    title = "SuperMake",
    highlight = "MyProjectWindow",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
    callback = cb,
  })
  MakeBuf = vim.api.nvim_win_get_buf(winId)
  -- make it so that q closes the window 
  vim.api.nvim_buf_set_keymap(MakeBuf, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent=false })
  vim.api.nvim_buf_set_keymap(MakeBuf, "n", "<esc>", "<cmd>lua CloseMenu()<CR>", { silent=false })
  vim.cmd(
    "autocmd BufLeave <buffer> ++nested ++once silent lua CloseMenu()"
  )
end

function CloseMenu()
  storage.save_content(MakeBuf)
  vim.api.nvim_win_close(winId, true)
end

local function OpenMenu()
  local cb = function(_, _)
    local opts = storage.save_content(MakeBuf)
    local userLine = vim.api.nvim_win_get_cursor(winId)[1]
    if opts[userLine] ~= "" then
      local s = helpers.get_choice(opts, userLine)
      vim.cmd("make -C " .. s)
    end
  end
  local opts = storage.load_content()
  ShowMenu(opts, cb)
end

ui.open = OpenMenu

return ui
