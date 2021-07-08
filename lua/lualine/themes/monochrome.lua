local colors = require'monochrome'.colors
return {
  normal = {
    a = { fg = colors.bg, bg = colors.gray7, gui = 'bold' },
    b = { fg = colors.gray7, bg = colors.gray1 },
    c = { fg = colors.gray7, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.faded_blue, gui = 'bold' },
    b = { fg = colors.gray7, bg = colors.gray1 },
    c = { fg = colors.gray7, bg = colors.bg },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.faded_yellow, gui = 'bold' },
    b = { fg = colors.gray7, bg = colors.gray1 },
    c = { fg = colors.gray7, bg = colors.bg },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.faded_red, gui = 'bold' },
    b = { fg = colors.gray7, bg = colors.gray1 },
    c = { fg = colors.gray7, bg = colors.bg },
  },
  command = {
    a = { fg = colors.bg, bg = colors.faded_green, gui = 'bold' },
    b = { fg = colors.gray7, bg = colors.gray1 },
    c = { fg = colors.gray7, bg = colors.bg },
  },
  inactive = {
    a = { fg = colors.gray7, bg = colors.fg, gui = 'bold' },
    b = { fg = colors.gray7, bg = colors.gray1 },
    c = { fg = colors.gray7, bg = colors.bg },
  },
}
