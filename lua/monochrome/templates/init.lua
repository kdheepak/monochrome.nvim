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

function M.generate_iterm2_script(path)
  local colors = require'monochrome'.colors
  local iterm2_codes = {
    fg = colors.fg,
    bg = colors.bg,
    selbg = colors.fg,
    selfg = colors.bg,
    curbg = colors.bg,
    curfg = colors.neutral_blue,
    black = colors.black,
    red = colors.faded_red,
    green = colors.faded_green,
    yellow = colors.faded_yellow,
    blue = colors.faded_blue,
    magenta = colors.faded_purple,
    cyan = colors.faded_aqua,
    white = colors.white,
    br_black = colors.gray1,
    br_red = colors.bright_red,
    br_green = colors.bright_green,
    br_yellow = colors.bright_yellow,
    br_blue = colors.bright_blue,
    br_magenta = colors.bright_purple,
    br_cyan = colors.bright_aqua,
    br_white = colors.gray9,
  }
  local content = ''
  for key, value in pairs(iterm2_codes) do
    local s = [[\033]1337;SetColors=]] .. key .. '=' .. string.gsub(value, '#', '') .. [[\a]]
    s = 'echo -ne "' .. s .. '"\n'
    content = content .. s
  end
  writeFile(path, content)
end

function M.generate_bashenv_script(path)
  local colors = require'monochrome'.colors
  local content = ''
  for key, value in pairs(colors) do
    local s = [[export ]] .. key:upper() .. [[=]] .. value .. '\n'
    content = content .. s
  end
  writeFile(path, content)
end

function M.render(path)
  config.colors = require'monochrome'.colors
  local tpl = openTemplate(CURRENT_FOLDER .. 'iterm2.tpl')
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
