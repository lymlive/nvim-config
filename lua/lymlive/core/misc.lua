vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
if vim.loop.os_uname().sysname == "Windows NT" then
    vim.g.jsdoc_lehre_path = "~/AppData/Roaming/npm/lehre"
else
    vim.g.jsdoc_lehre_path = "/usr/local/lib/node_modules/lehre"
end
vim.diagnostic.config({
  virtual_text = false,
})
