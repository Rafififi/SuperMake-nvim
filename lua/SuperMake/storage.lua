local M = {}

local data_dir = vim.fn.stdpath("data") .. "/SuperMake"
vim.fn.mkdir(data_dir, "p")

local file_names = {
  "Makefile",
  "Rules.mk"
}

local function FindFiles()
  local filesString = "-name " .. file_names[1] .. " "
  for i = 2, #file_names do
    filesString = filesString .. "-o -name " .. file_names[i]
  end
  vim.cmd("!find . " .. filesString .. " | xargs dirname > " .. M.get_storage_path())
end

function M.get_storage_path()
  local cwd = vim.fn.getcwd()
  local hash = vim.fn.sha256(cwd)
  return data_dir .. "/" .. hash .. ".txt"
end

function M.save_content(buffer)
  local opts = vim.api.nvim_buf_get_lines(buffer, 0, -1, true)
  vim.fn.writefile(opts, M.get_storage_path())
  return opts
end

function M.load_content()
  if vim.fn.filereadable(M.get_storage_path()) == 1 then
    return vim.fn.readfile(M.get_storage_path())
  end
  FindFiles()
  return M.load_content()
end

return M
