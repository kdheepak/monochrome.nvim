local M = {}

local hsluv = require 'monochrome.hsluv'

local Default = { '#EBEBEB', '#101010' }
local Subtle = { '#F1F5F9', '#0A1219' }
local CoolGray = { '#F9FAFB', '#111827' }
local Amplified = { '#FFFFFF', '#000000' }

local colors = {
  bright_red = '#ffc4c4',
  bright_green = '#eff6ab',
  bright_yellow = '#ffe6b5',
  bright_blue = '#c9e6fd',
  bright_purple = '#f7d7ff',
  bright_aqua = '#ddfcf8',
  bright_orange = '#ffd3c2',
  neutral_red = '#eca8a8',
  neutral_green = '#ccd389',
  neutral_yellow = '#efd5a0',
  neutral_blue = '#a5c6e1',
  neutral_purple = '#e1bee9',
  neutral_aqua = '#c7ebe6',
  neutral_orange = '#efb6a0',
  faded_red = '#ec8989',
  faded_green = '#c9d36a',
  faded_yellow = '#ceb581',
  faded_blue = '#8abae1',
  faded_purple = '#db9fe9',
  faded_aqua = '#abebe2',
  faded_orange = '#E69E83',
}

M.colors = colors

-- based on https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/util.lua
function M.hexToRgb(hex_str)
  local hex = '[abcdef0-9][abcdef0-9]'
  local pat = '^#(' .. hex .. ')(' .. hex .. ')(' .. hex .. ')$'
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, 'hex_to_rgb: invalid hex_str: ' .. tostring(hex_str))

  local r, g, b = string.match(hex_str, pat)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

function M.blend(fg, bg, blend)
  local hsl1 = hsluv.hex_to_hsluv(bg)
  local hsl2 = hsluv.hex_to_hsluv(fg)
  local hue_blend, saturation_blend, lightness_blend = unpack(blend)
  local r1, g1, b1 = unpack(hsluv.hsluv_to_rgb(hsl1))
  local r2, g2, b2 = unpack(hsluv.hsluv_to_rgb(hsl2))

  local hue =
      hsluv.rgb_to_hsluv({ r1 + (r2 - r1) * hue_blend, g1 + (g2 - g1) * hue_blend, b1 + (b2 - b1) * hue_blend })[1]

  local _, s1, l1 = unpack(hsl1)
  local _, s2, l2 = unpack(hsl2)
  return hsluv.hsluv_to_hex({ hue, s1 + (s2 - s1) * saturation_blend, l1 + (l2 - l1) * lightness_blend })
end

function M.colorDistance(hs1, hs2)
  local h1, s1 = unpack(hs1)
  local h2, s2 = unpack(hs2)

  local hueDist = M.modularDistance(h1, h2, 360) / 180 * 2.0 - 1.0
  local saturationDist = math.abs(s1 - s2) / 100.0
  return hueDist * saturationDist
end

function M.modularDistance(a, b, m)
  return math.min((a - b) % m, (b - a) % m)
end

function M.invertColor(color)
  if color ~= 'NONE' then
    local hsl = hsluv.hex_to_hsluv(color)
    hsl[3] = 100 - hsl[3]
    if hsl[3] < 40 then
      hsl[3] = hsl[3] + (100 - hsl[3]) * 0.3
    end
    return hsluv.hsluv_to_hex(hsl)
  end
  return color
end

function M.darken(hsl, amount)
  local l = hsl[3] * (1.0 - amount)
  return { hsl[1], hsl[2], l }
end

function M.brighten(hsl, amount)
  local l = hsl[3] + (100.0 - hsl[3]) * amount
  return { hsl[1], hsl[2], l }
end

function M.desaturate(hsl, amount)
  local s = hsl[2] * (1.0 - amount)
  return { hsl[1], s, hsl[3] }
end

function M.saturate(hsl, amount)
  local s = hsl[2] + (100.0 - hsl[2]) * amount
  return { hsl[1], s, hsl[3] }
end

function M.brighten(color, percentage)
  local hsl = hsluv.hex_to_hsluv(color)
  local larpSpace = 100 - hsl[3]
  if percentage < 0 then
    larpSpace = hsl[3]
  end
  hsl[3] = hsl[3] + larpSpace * percentage
  return hsluv.hsluv_to_hex(hsl)
end

function M.darken(hex, amount, bg)
  return M.blend(hex, bg or colors.black, { math.abs(amount), math.abs(amount), math.abs(amount) })
end

function M.lighten(hex, amount, fg)
  return M.blend(hex, fg or colors.white, { math.abs(amount), math.abs(amount), math.abs(amount) })
end

local function range(from, to, step)
  local t = {}

  for value = from, to, step do
    t[#t + 1] = value
  end

  return t
end

function M.colorize(fg, bg)
  -- https://github.com/anotherglitchinthematrix/monochrome/blob/master/src/base.js
  local first = hsluv.hex_to_hsluv(bg)[3]
  local last = hsluv.hex_to_hsluv(fg)[3]
  first = math.floor(first)
  last = math.ceil(last)
  local palette = {}
  for i, v in pairs(range(first, last, math.floor((last - first) / 10))) do
    palette['gray' .. tostring(i - 1)] = hsluv.hsluv_to_hex({ 0, 0, v })
  end
  palette['gray10'] = nil
  palette['gray0'] = nil
  palette['white'] = hsluv.hsluv_to_hex({ 0, 0, hsluv.hex_to_hsluv(hsluv.hsluv_to_hex({ 0, 0, last }))[3] })
  palette['black'] = hsluv.hsluv_to_hex({ 0, 0, hsluv.hex_to_hsluv(hsluv.hsluv_to_hex({ 0, 0, first }))[3] })
  palette['bg'] = palette['black']
  palette['fg'] = palette['white']
  palette['bg_alt'] = M.blend(palette['bg'], palette['gray1'], { 0.5, 0.5, 0.5 })
  palette['fg_alt'] = M.blend(palette['fg'], palette['gray9'], { 0.5, 0.5, 0.5 })
  return palette
end

function M.terminal_color()
  vim.g.terminal_color_0 = colors.black
  vim.g.terminal_color_1 = colors.green
  vim.g.terminal_color_2 = colors.orange
  vim.g.terminal_color_3 = colors.green
  vim.g.terminal_color_4 = colors.green
  vim.g.terminal_color_5 = colors.green
  vim.g.terminal_color_6 = colors.green
  vim.g.terminal_color_7 = colors.green
  vim.g.terminal_color_8 = colors.black
  vim.g.terminal_color_9 = colors.green
  vim.g.terminal_color_10 = colors.red
  vim.g.terminal_color_11 = colors.green
  vim.g.terminal_color_12 = colors.green
  vim.g.terminal_color_13 = colors.green
  vim.g.terminal_color_14 = colors.green
  vim.g.terminal_color_15 = colors.green
end

function M.highlight(group, color)
  if color.link then
    vim.api.nvim_command('highlight! link ' .. group .. ' ' .. color.link)
  else
    local style = color.style and 'gui=' .. color.style or color.preserve and '' or ' gui=NONE cterm=NONE'
    local fg = color.fg and 'guifg=' .. color.fg or color.preserve and '' or 'guifg=NONE ctermfg=NONE'
    local bg = color.bg and 'guibg=' .. color.bg or color.preserve and '' or 'guibg=NONE ctermbg=NONE'
    local sp = color.sp and 'guisp=' .. color.sp or color.preserve and '' or 'guisp=NONE'
    vim.api.nvim_command('highlight ' .. group .. ' ' .. style .. ' ' .. fg .. ' ' .. bg .. ' ' .. sp)
  end
end

function M.load_syntax()
  local syntax = {

    Normal = { fg = colors.white, bg = colors.black },
    Terminal = { fg = colors.white, bg = colors.black },
    Visual = { fg = colors.black, bg = colors.white },
    VisualNOS = { fg = colors.black, bg = colors.white },

    -- This is a comment
    SpecialComment = { fg = colors.gray6, style = 'bold,italic' },
    -- TODO: this is a todo comment
    Todo = { fg = colors.purple, style = 'bold' },

    LineNr = { fg = colors.gray3 },
    CursorLineNr = { fg = colors.gray7, bg = colors.bg_alt },

    Cursor = { fg = colors.black, bg = colors.white },
    lCursor = { fg = colors.black, bg = colors.white },
    CursorIM = { fg = colors.black, bg = colors.white },
    CursorColumn = { fg = colors.white },

    CursorLine = { bg = colors.bg_alt },

    ColorColumn = { bg = colors.bg_alt },
    Conceal = { fg = colors.gray1 },

    IncSearch = { fg = colors.black, bg = colors.bright_blue, style = 'bold' },
    Search = { fg = colors.black, bg = colors.faded_blue },

    Pmenu = { fg = colors.white, bg = colors.gray1 },
    PmenuSel = { fg = colors.gray1, bg = colors.white },
    PmenuSbar = { fg = colors.white, bg = colors.gray1 },
    PmenuThumb = { fg = colors.black, bg = colors.gray9 },

    SpellBad = { fg = colors.orange, style = 'underline' },
    SpellCap = {},
    SpellLocal = {},
    SpellRare = {},

    ModeMsg = {},
    MoreMsg = {},
    StatusLine = {},
    StatusLineNC = {},

    MatchParen = { style = 'bold' },

    VertSplit = { fg = colors.black, bg = colors.black },

    TSAnnotation = {},
    TSAttribute = {},
    TSBoolean = { fg = colors.white },
    TSCharacter = { fg = colors.white },
    TSComment = { fg = colors.gray2, style = 'italic' },
    TSConditional = { fg = colors.gray4 },
    TSConstant = { fg = colors.gray8 },
    TSConstBuiltin = { fg = colors.gray3 },
    TSConstMacro = {},
    TSConstructor = { fg = colors.gray8 },
    TSError = { style = 'underline,italic' },
    TSException = { style = 'underline,bold' },
    TSField = { fg = colors.gray5 },
    TSFloat = { fg = colors.white },
    TSFunction = { fg = colors.gray6 },
    TSFuncBuiltin = { fg = colors.gray4 },
    TSFuncMacro = { fg = colors.gray6 },
    TSInclude = { fg = colors.gray7 },
    TSKeyword = { fg = colors.gray4 },
    TSKeywordFunction = { fg = colors.gray4 },
    TSKeywordOperator = { fg = colors.gray4 },
    TSKeywordReturn = { fg = colors.gray4 },
    TSLabel = { fg = colors.white },
    TSMethod = { fg = colors.gray6 },
    TSNamespace = { fg = colors.gray4 },
    TSNone = { fg = colors.gray3 },
    TSNumber = { fg = colors.white },
    TSOperator = { fg = colors.gray8 },
    TSParameter = { fg = colors.gray7 },
    TSParameterReference = { fg = colors.gray7 },
    TSProperty = { fg = colors.gray5 },
    TSPunctDelimiter = { fg = colors.gray8 },
    TSPunctBracket = { fg = colors.gray8 },
    TSPunctSpecial = { fg = colors.gray8 },
    TSRepeat = { fg = colors.gray4 },
    TSString = { fg = colors.white },
    TSStringRegex = { fg = colors.white },
    TSStringEscape = { fg = colors.white },
    TSSymbol = { fg = colors.white },
    TSTag = { fg = colors.white },
    TSTagDelimiter = {},
    TSText = { fg = colors.white },
    TSStrong = { style = 'bold' },
    TSEmphasis = { style = 'italic' },
    TSUnderline = { style = 'underline' },
    TSStrike = { style = 'strikethrough' },
    TSTitle = {},
    TSLiteral = { fg = colors.white },
    TSURI = {},
    TSMath = {},
    TSTextReference = {},
    TSEnvironment = {},
    TSEnvironmentName = {},
    TSNote = { style = 'bold' },
    TSWarning = { style = 'bold' },
    TSDanger = { style = 'bold' },
    TSType = { fg = colors.gray4 },
    TSTypeBuiltin = { fg = colors.gray4 },
    TSVariable = { fg = colors.gray8 },
    TSVariableBuiltin = { fg = colors.gray8 },

    Bold = { link = 'TSStrong' },
    Boolean = { link = 'TSBoolean' },
    Character = { link = 'TSCharacter' },
    Comment = { link = 'TSComment' },
    Conditional = { link = 'TSConditional' },
    Constant = { link = 'TSConstant' },
    Define = { link = 'TSConstBuiltin' },
    Delimiter = { link = 'TSPunctDelimiter' },
    Error = { link = 'TSError' },
    Exception = { link = 'TSException' },
    Float = { link = 'TSFloat' },
    Function = { link = 'TSFunction' },
    Identifier = { link = 'TSVariable' },
    Include = { link = 'TSInclude' },
    Italic = { link = 'TSEmphasis' },
    Keyword = { link = 'TSKeyword' },
    Label = { link = 'TSLabel' },
    Macro = { link = 'TSFuncMacro' },
    Number = { link = 'TSNumber' },
    Operator = { link = 'TSOperator' },
    Repeat = { link = 'TSRepeat' },
    SpecialChar = { link = 'TSStringEscape' },
    String = { link = 'TSString' },
    Structure = { link = 'TSAnnotation' },
    Field = { link = 'TSProperty' },
    Tag = { link = 'TSTag' },
    Title = { link = 'TSTitle' },
    Type = { link = 'TSType' },
    Underlined = { link = 'TSUnderline' },
    asciidocAttributeEntry = { link = 'TSAttribute' },
    cIncluded = { link = 'TSConstructor' },
    healthError = { link = 'TSDanger' },
    healthWarning = { link = 'TSWarning' },
    rubySymbol = { link = 'TSSymbol' },
    xmlNamespace = { link = 'TSNamespace' },

    Directory = {},
    EndOfBuffer = {},
    ErrorMsg = { style = 'reverse' },
    FoldColumn = {},
    Folded = {},
    NonText = { fg = colors.green },
    Question = {},
    SignColumn = {},
    SpecialKey = {},
    Substitute = { fg = colors.orange, style = 'bold,reverse' },
    TabLine = {},
    TabLineFill = {},
    TabLineSel = { style = 'reverse' },
    WarningMsg = {},
    WildMenu = { style = 'reverse' },
    Ignore = {},
    PreProc = {},
    Special = {},
    ToolbarLine = { bg = colors.black },
    ToolbarButton = { style = 'bold' },
    qfLineNr = {},
    Whitespace = { fg = colors.gray1 },
    PmenuSelBold = {},
    NormalFloat = {},
    QuickFixLine = {},
    Debug = {},
    debugBreakpoint = {},
    PreCondit = {},
    Statement = { link = 'Function' },
    Typedef = { fg = colors.gray7 },
  }
  return syntax
end

function M.load_plugin_syntax()
  local plugin_syntax = {

    DashboardShortCut = { fg = colors.fg, bg = colors.bg },
    DashboardHeader = { fg = colors.fg, bg = colors.bg },
    DashboardCenter = { fg = colors.fg, bg = colors.bg },
    DashboardFooter = { fg = colors.fg, bg = colors.bg },

    ALEError = { fg = colors.orange },
    ALEWarning = { fg = colors.orange },
    ALEInfo = { fg = colors.orange },
    ALEErrorSign = { fg = colors.orange },
    ALEWarningSign = { fg = colors.orange },
    ALEInfoSign = { fg = colors.orange },

    DiffAdd = { fg = colors.neutral_green },
    DiffChange = { fg = colors.neutral_blue },
    DiffDelete = { fg = colors.neutral_red },
    DiffText = { fg = colors.neutral_blue },

    GitSignsAdd = { fg = colors.neutral_green },
    GitSignsDelete = { fg = colors.neutral_red },
    GitSignsChange = { fg = colors.neutral_blue },
    GitSignsChangeNr = { fg = colors.neutral_yellow },
    GitSignsChangeLn = { fg = colors.neutral_yellow },
    GitSignsChangeDelete = { fg = colors.neutral_orange },

    SignifySignAdd = { fg = colors.neutral_green },
    SignifySignChange = { fg = colors.neutral_yellow },
    SignifySignDelete = { fg = colors.neutral_red },

    GitGutterAdd = { fg = colors.neutral_green },
    GitGutterChange = { fg = colors.neutral_yellow },
    GitGutterChangeDelete = { fg = colors.neutral_orange },
    GitGutterDelete = { fg = colors.neutral_red },

    LspDiagnosticsVirtualTextError = { fg = colors.faded_red },
    LspDiagnosticsSignError = { fg = colors.faded_red },
    LspDiagnosticsFloatingError = { fg = colors.faded_red },
    LspDiagnosticsVirtualTextWarning = { fg = colors.faded_yellow },
    LspDiagnosticsSignWarning = { fg = colors.faded_yellow },
    LspDiagnosticsFloatingWarning = { fg = colors.faded_yellow },
    LspDiagnosticsVirtualTextInformation = { fg = colors.faded_blue },
    LspDiagnosticsSignInformation = { fg = colors.faded_blue },
    LspDiagnosticsFloatingInformation = { fg = colors.faded_blue },
    LspDiagnosticsVirtualTextHint = { fg = colors.fg },
    LspDiagnosticsSignHint = { fg = colors.fg },
    LspDiagnosticsFloatingHint = { fg = colors.fg },
    LspDiagnosticsUnderlineError = { bg = colors.bg, style = 'undercurl', sp = colors.faded_red },
    LspDiagnosticsUnderlineWarning = { bg = colors.bg, style = 'undercurl', sp = colors.faded_yellow },
    LspDiagnosticsUnderlineInformation = { bg = colors.bg, style = 'undercurl', sp = colors.faded_blue },
    LspDiagnosticsUnderlineHint = { bg = colors.bg, style = 'undercurl', sp = colors.fg },

    gitCommitBranch = {},
    gitCommitDiscardedFile = {},
    gitCommitDiscardedType = {},
    gitCommitHeader = {},
    gitCommitSelectedFile = {},
    gitCommitSelectedType = {},
    gitCommitUntrackedFile = {},
    gitEmail = {},

    NERDTreeGitStatusDirDirty = {},
    NERDTreeGitStatusModified = {},
    NERDTreeGitStatusRenamed = {},
    NERDTreeGitStatusStaged = {},
    NERDTreeGitStatusUntracked = {},
    NERDTreeClosable = {},
    NERDTreeCWD = {},
    NERDTreeDir = {},
    NERDTreeDirSlash = {},
    NERDTreeExecFile = {},
    NERDTreeFile = {},
    NERDTreeFlags = {},
    NERDTreeHelp = {},
    NERDTreeLinkDir = {},
    NERDTreeLinkFile = {},
    NERDTreeLinkTarget = {},
    NERDTreeOpenable = {},
    NERDTreePart = {},
    NERDTreePartFile = {},
    NERDTreeUp = {},

    markdownBold = { style = 'bold' },
    markdownCode = {},
    markdownCodeDelimiter = {},
    markdownError = {},
    markdownH1 = { style = 'bold' },
    markdownUrl = { fg = colors.bright_blue },
    markdownFootnote = { link = 'TSNote' },
    markdownLinkText = { link = 'TSURI' },
    markdownLinkTextDelimiter = { fg = colors.gray4 },
    markdownLinkDelimiter = { fg = colors.gray4 },

    mkdDelimiter = {},
    mkdLineBreak = {},
    mkdListItem = {},
    mkdCodeStart = { fg = colors.gray4 },
    mkdCodeEnd = { fg = colors.gray4 },
    mkdURL = { fg = colors.bright_blue },

    NvimTreeFolderName = { fg = colors.gray9 },
    NvimTreeRootFolder = { fg = colors.white },
    NvimTreeSpecialFile = {},

    TelescopeBorder = { fg = colors.gray5 },
    TelescopePromptBorder = { fg = colors.gray8 },
    TelescopeMatching = {},
    TelescopeSelection = { style = 'bold' },
    TelescopeSelectionCaret = { fg = colors.white },
    TelescopeMultiSelection = { style = 'italic' },

    BufferCurrent = { fg = colors.fg, bg = colors.bg },
    BufferCurrentMod = { fg = colors.fg, bg = colors.bg, style = 'italic' },
    BufferCurrentSign = { fg = colors.fg, bg = colors.bg },
    BufferVisible = { fg = colors.gray7, bg = colors.bg },
    BufferVisibleMod = { fg = colors.gray7, bg = colors.bg, style = 'italic' },
    BufferVisibleSign = { fg = colors.gray7, bg = colors.bg },
    BufferInactive = { fg = colors.gray3, bg = colors.bg_alt },
    BufferInactiveMod = { fg = colors.gray3, bg = colors.bg_alt, style = 'italic' },
    BufferInactiveSign = { fg = colors.gray3, bg = colors.bg_alt },
  }
  return plugin_syntax
end

local async_load_plugin

async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
  M.terminal_color()
  local syntax = M.load_plugin_syntax()
  for group, tables in pairs(syntax) do
    M.highlight(group, tables)
  end
  async_load_plugin:close()
end))

function M.colorscheme()
  vim.api.nvim_command('hi clear')
  if vim.fn.exists('syntax_on') then
    vim.api.nvim_command('syntax reset')
  end
  vim.o.termguicolors = true
  vim.g.colors_name = 'monochrome'
  local color_style
  if vim.g.monochrome_style == 'default' then
    color_style = Default
  elseif vim.g.monochrome_style == 'subtle' then
    color_style = Subtle
  elseif vim.g.monochrome_style == 'amplified' then
    color_style = Amplified
  elseif vim.g.monochrome_style == 'coolgray' then
    color_style = CoolGray
  else
    color_style = Default
  end

  local fg, bg = unpack(color_style)
  if vim.o.background == 'light' then
    bg, fg = fg, bg
  end

  for k, v in pairs(M.colorize(fg, bg)) do
    colors[k] = v
  end
  local syntax = M.load_syntax()
  for group, tables in pairs(syntax) do
    M.highlight(group, tables)
  end
  async_load_plugin:send()
end

function M.reset()
  package.loaded['monochrome'] = nil
  require'monochrome'.colorscheme()
end

return M
