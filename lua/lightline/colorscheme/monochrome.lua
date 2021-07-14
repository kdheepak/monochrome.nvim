local colors = require('monochrome.colors')

local monochrome = {}

monochrome.normal = {
  a = { { colors.bg, colors.gray7 }, { colors.fg, colors.gray1 } },
  b = { { colors.fg, colors.gray1 } },
  c = { { colors.fg, colors.gray1 }, { colors.bg, colors.fg } },
  error = { { colors.black, colors.bright_red } },
  warning = { { colors.black, colors.bright_yellow } },
}

monochrome.insert = {
  a = { { colors.bg, colors.faded_blue }, { colors.fg, colors.gray1 } },
  b = { { colors.fg, colors.gray1 } },
  c = { { colors.fg, colors.gray1 }, { colors.bg, colors.fg } },
}

monochrome.visual = {
  a = { { colors.bg, colors.faded_yellow }, { colors.fg, colors.gray1 } },
  b = { { colors.fg, colors.gray1 } },
  c = { { colors.fg, colors.gray1 }, { colors.bg, colors.fg } },
}

monochrome.replace = {
  a = { { colors.bg, colors.faded_red }, { colors.fg, colors.gray1 } },
  b = { { colors.fg, colors.gray1 } },
  c = { { colors.fg, colors.gray1 }, { colors.bg, colors.fg } },
}

monochrome.inactive = {
  a = { { colors.fg, colors.fg }, { colors.fg, colors.gray1 } },
  b = { { colors.fg, colors.gray1 } },
  c = { { colors.fg, colors.gray1 }, { colors.fg, colors.fg } },
}

monochrome.tabline = {
  a = { { colors.bg, colors.fg }, { colors.fg, colors.gray1 } },
  b = { { colors.fg, colors.gray1 } },
  c = { { colors.fg, colors.gray1 }, { colors.bg, colors.fg } },
  tabsel = { { colors.bright_blue, colors.fg }, { colors.fg, colors.bg } },
}

return monochrome
