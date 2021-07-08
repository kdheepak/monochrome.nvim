local colors = require('monochrome').colors

local monochrome = {}

monochrome.normal = {
  left = { { colors.bg, colors.gray7 }, { colors.gray7, colors.gray1 } },
  middle = { { colors.gray7, colors.gray1 } },
  right = { { colors.gray7, colors.gray1 }, { colors.bg, colors.gray7 } },
  error = { { colors.black, colors.bright_red } },
  warning = { { colors.black, colors.bright_yellow } },
}

monochrome.insert = { left = { { colors.bg, colors.faded_blue }, { colors.gray7, colors.gray1 } } }

monochrome.visual = { left = { { colors.bg, colors.faded_yellow }, { colors.gray7, colors.gray1 } } }

monochrome.replace = { left = { { colors.bg, colors.faded_red }, { colors.gray7, colors.gray1 } } }

monochrome.inactive = {
  left = { { colors.gray7, colors.fg }, { colors.gray7, colors.gray1 } },
  middle = { { colors.gray7, colors.gray1 } },
  right = { { colors.gray7, colors.gray1 }, { colors.gray7, colors.fg } },
}

monochrome.tabline = {
  left = { { colors.bg, colors.gray7 }, { colors.gray7, colors.gray1 } },
  middle = { { colors.gray7, colors.gray1 } },
  right = { { colors.gray7, colors.gray1 }, { colors.bg, colors.gray7 } },
  tabsel = { { colors.bright_blue, colors.gray7 }, { colors.gray7, colors.bg } },
}

return monochrome
