local M = {}

local config = {
  command = 'gotests',
  template = '',
  template_dir = '',
}

local function setup_commands()
  local cmds = {
    {
      name = 'GoTests',
      cmd = function(range)
        require('gotests.autoload').select_tests(config, range.line1, range.line2)
      end,
      opt = {
        range = true,
      }
    },
    {
      name = 'GoTestsAll',
      cmd = function()
        require('gotests.autoload').all_tests(config)
      end,
      opt = {}
    },
    {
      name = 'GoTestsExported',
      cmd = function()
        require('gotests.autoload').exported_tests(config)
      end,
      opt = {}
    },
  }

  for _, cmd in ipairs(cmds) do
    vim.api.nvim_create_user_command(
      cmd.name,
      cmd.cmd,
      cmd.opt
    )
  end
end

function M.setup(user_config)
  --判断插件是否加载
  if vim.fn.exists(vim.g.loaded_vim_gotests) == true then
    return
  end
  config = vim.tbl_deep_extend('force', config, user_config or {})
  if vim.fn.executable(config.command) == nil then
    vim.notify('gotests binary not found.', vim.log.levels.ERROR, {
      title = 'gotests.nvim'
    })
    return
  end

  setup_commands()
end

return M
