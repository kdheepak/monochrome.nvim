local colors = require 'monochrome.colors'
return {
  normal = {
    a = { fg = colors.bg, bg = colors.gray7, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.faded_blue, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.faded_yellow, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.faded_red, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  command = {
    a = { fg = colors.bg, bg = colors.faded_green, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  inactive = {
    a = { fg = colors.white, bg = colors.fg, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.white, bg = colors.bg },
  },
}
