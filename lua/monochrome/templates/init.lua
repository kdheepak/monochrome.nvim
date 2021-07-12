local M = {}
local iterm2 = require 'monochrome.templates.iterm2'

local config = {}

local function renderColor(name)
  return iterm2.format(config.colors[name])
end

local function writeFile(name, content)
  local f = io.open(name, 'w')
  f:write(content)
  f:close()
end

local function openTemplate(path)
  local f = io.open(path, 'r')
  if f then
    local content = f:read('*all')
    f:close()
    return content
  else
    print('[ERROR]no template at ' .. path)
    return nil
  end
end

local CURRENT_FOLDER = debug.getinfo(1, 'S').source:sub(2):match('(.*[/\\])')

function M.render(path, name)
  config.colors = require'monochrome'.colors
  local tpl = openTemplate(CURRENT_FOLDER .. name .. '.tpl')
  if tpl then
    print('=> Writing file ' .. path)
    -- LuaFormatter off
    writeFile(path,
      tpl
        :gsub('{{>(.-)}}', renderColor)
    )
    -- LuaFormatter on
  end
end

return M
