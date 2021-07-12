local colors = require('monochrome').colors

local monochrome = {}

monochrome.normal = {
  left = { { colors.bg, colors.fg }, { colors.fg, colors.gray1 } },
  middle = { { colors.fg, colors.gray1 } },
  right = { { colors.fg, colors.gray1 }, { colors.bg, colors.fg } },
  error = { { colors.black, colors.bright_red } },
  warning = { { colors.black, colors.bright_yellow } },
}

monochrome.insert = { left = { { colors.bg, colors.faded_blue }, { colors.fg, colors.gray1 } } }

monochrome.visual = { left = { { colors.bg, colors.faded_yellow }, { colors.fg, colors.gray1 } } }

monochrome.replace = { left = { { colors.bg, colors.faded_red }, { colors.fg, colors.gray1 } } }

monochrome.inactive = {
  left = { { colors.fg, colors.fg }, { colors.fg, colors.gray1 } },
  middle = { { colors.fg, colors.gray1 } },
  right = { { colors.fg, colors.gray1 }, { colors.fg, colors.fg } },
}

monochrome.tabline = {
  left = { { colors.bg, colors.fg }, { colors.fg, colors.gray1 } },
  middle = { { colors.fg, colors.gray1 } },
  right = { { colors.fg, colors.gray1 }, { colors.bg, colors.fg } },
  tabsel = { { colors.bright_blue, colors.fg }, { colors.fg, colors.bg } },
}

return monochrome
