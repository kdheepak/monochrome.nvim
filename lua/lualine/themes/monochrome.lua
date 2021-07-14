local colors = require 'monochrome.colors'
return {
  normal = {
    a = { fg = colors.black, bg = colors.neutral_green, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.black, bg = colors.faded_blue, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  visual = {
    a = { fg = colors.black, bg = colors.faded_yellow, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  replace = {
    a = { fg = colors.black, bg = colors.faded_red, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  command = {
    a = { fg = colors.black, bg = colors.faded_aqua, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  inactive = {
    a = { fg = colors.white, bg = colors.fg, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.white, bg = colors.bg },
  },
}
