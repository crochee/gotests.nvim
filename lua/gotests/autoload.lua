local M = {}

local function range(from, to)
  local step = 1
  return function(_, lastvalue)
        local nextvalue = lastvalue + step
        if step > 0 and nextvalue <= to or step < 0 and nextvalue >= to or
            step == 0
        then
          return nextvalue
        end
      end, nil, from - step
end

local function join(config)
  local tmpl = ''
  if config.template ~= '' then
    tmpl = '-template ' .. vim.fn.shellescape(config.template)
  end
  if config.template_dir ~= '' then
    tmpl = tmpl .. ' -template_dir ' .. vim.fn.shellescape(config.template_dir)
  end
  return tmpl
end

function M.select_tests(config, first, last)
  -- search function names
  local matchstr = vim.fn.matchstr
  local getline = vim.fn.getline
  local funcMatch = ''

  for lineno in range(first, last) do
    local funcName = matchstr(getline(lineno), [[^func\s*\(([^)]\+)\)\=\s*\zs\w\+\ze(]])
    if funcName ~= '' then
      funcMatch = funcMatch .. '|' .. funcName
    end
  end

  if funcMatch ~= '' then
    funcMatch = string.sub(funcMatch, 2)
  else
    vim.notify('No function selected!', vim.log.levels.WARN, { title = 'gotests' })
    return
  end

  local file = vim.fn.expand('%')
  local out = vim.fn.system(config.command ..
  ' -w -only ' ..
  vim.fn.shellescape(funcMatch) .. ' ' .. join(config) .. ' ' .. vim.fn.shellescape(file))

  vim.notify(out, vim.log.levels.INFO, { title = 'gotests' })
end

function M.all_tests(config)
  local file = vim.fn.expand('%')
  local out = vim.fn.system(config.command ..
  ' -w -all ' .. join(config) .. ' ' .. vim.fn.shellescape(file))
  vim.notify(out, vim.log.levels.INFO, { title = 'gotests' })
end

function M.exported_tests(config)
  local file = vim.fn.expand('%')
  local out = vim.fn.system(config.command ..
  ' -w -exported ' .. join(config) .. ' ' .. vim.fn.shellescape(file))
  vim.notify(out, vim.log.levels.INFO, { title = 'gotests' })
end

return M
