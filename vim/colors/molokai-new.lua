
-- Molokai colorscheme rewritten in Lua for Neovim 0.11+
-- Author: originally by Tomas Restrepo <tomas@winterdom.com>; Lua port by ChatGPT (2025)
-- This file should be placed in your runtime path under `colors/molokai.lua`
-- so that `:colorscheme molokai` loads it.
-- It honours the legacy `g:molokai_original` variable (0 = dark‑gray background, 1 = classic).  

local M = {}

-- Helper ---------------------------------------------------------------------
local function hi(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

---Apply the highlight definitions.
---@param opts table|nil optional user overrides
function M.setup(opts)
  opts = opts or {}

  -- Respect termguicolors for best fidelity
  if vim.fn.has("termguicolors") == 1 and not vim.o.termguicolors then
    vim.o.termguicolors = true
  end
  vim.o.background = "dark"

  local original = vim.g.molokai_original == 1

  ---------------------------------------------------------------------------
  -- Palette -----------------------------------------------------------------
  ---------------------------------------------------------------------------
  local C = {
    black       = "#000000",
    bg0         = original and "#272822" or "#1B1D1E",
    bg1         = original and "#3E3D32" or "#293739",
    bg2         = original and "#3B3A32" or "#232526",
    white       = "#F8F8F2",
    gray        = original and "#75715E" or "#465457",
    lightgray   = "#BCBCBC",
    yellow      = "#E6DB74",
    orange      = "#FD971F",
    red         = "#F92672",
    magenta     = "#AE81FF",
    cyan        = "#66D9EF",
    green       = "#A6E22E",
    diff_add_bg    = "#13354A",
    diff_change_bg = "#4C4745",
    diff_delete_fg = "#960050",
    diff_delete_bg = "#1E0010",
  }

  ---------------------------------------------------------------------------
  -- Highlight groups --------------------------------------------------------
  ---------------------------------------------------------------------------
  local H = {
    -- UI basics
    Normal         = { fg = C.white, bg = C.bg0 },
    Comment        = { fg = original and "#75715E" or "#7E8E91" },
    CursorLine     = { bg = C.bg1 },
    CursorLineNr   = { fg = C.orange },
    CursorColumn   = { bg = C.bg1 },
    ColorColumn    = { bg = C.bg2 },
    LineNr         = { fg = original and C.lightgray or C.gray, bg = C.bg2 },
    NonText        = { fg = C.gray },
    SpecialKey     = { fg = C.gray },

    -- Syntax -----------------------------------------
    Boolean        = { fg = C.magenta },
    Character      = { fg = C.yellow },
    Number         = { fg = C.magenta },
    String         = { fg = C.yellow },
    Conditional    = { fg = C.red,     bold = true },
    Constant       = { fg = C.magenta, bold = true },
    Debug          = { fg = "#BCA3A3", bold = true },
    Define         = { fg = C.cyan },
    Delimiter      = { fg = "#8F8F8F" },
    Exception      = { fg = C.green,   bold = true },
    Float          = { fg = C.magenta },
    Function       = { fg = C.green },
    Identifier     = { fg = C.orange },
    Keyword        = { fg = C.red,     bold = true },
    Label          = { fg = C.yellow },
    Macro          = { fg = "#C4BE89", italic = true },
    Operator       = { fg = C.red },
    PreCondit      = { fg = C.green,   bold = true },
    PreProc        = { fg = C.green },
    Repeat         = { fg = C.red,     bold = true },
    Statement      = { fg = C.red,     bold = true },
    StorageClass   = { fg = C.orange,  italic = true },
    Structure      = { fg = C.cyan },
    Tag            = { fg = C.red,     italic = true },
    Title          = { fg = "#ef5939" },
    Todo           = { fg = "#FFFFFF", bg = "NONE", bold = true },
    Type           = { fg = C.cyan },
    Typedef        = { fg = C.cyan },

    -- UI widgets -------------------------------------
    Directory      = { fg = C.green, bold = true },
    Error          = { fg = C.yellow, bg = C.diff_delete_bg },
    ErrorMsg       = { fg = C.red,    bg = "#232526", bold = true },
    IncSearch      = { fg = "#C4BE89", bg = C.black },
    MatchParen     = { fg = C.black,  bg = C.orange, bold = true },
    ModeMsg        = { fg = C.yellow },
    MoreMsg        = { fg = C.yellow },
    Pmenu          = { fg = C.cyan, bg = C.black },
    PmenuSel       = { bg = "#808080" },
    PmenuSbar      = { bg = "#080808" },
    PmenuThumb     = { fg = C.cyan },
    Question       = { fg = C.cyan },
    Search         = { fg = C.black, bg = "#FFE792" },
    SignColumn     = { fg = C.green, bg = "#232526" },
    SpecialChar    = { fg = C.red, bold = true },
    SpecialComment = { fg = "#7E8E91", bold = true },
    SpellBad       = { undercurl = true, sp = "#FF0000" },
    SpellCap       = { undercurl = true, sp = "#7070F0" },
    SpellLocal     = { undercurl = true, sp = "#70F0F0" },
    SpellRare      = { undercurl = true, sp = "#FFFFFF" },
    StatusLine     = { fg = "#455354", bg = C.white },
    StatusLineNC   = { fg = "#808080", bg = "#080808" },
    Underlined     = { fg = "#808080", underline = true },
    VertSplit      = { fg = "#808080", bg = "#080808", bold = true },
    WinSeparator   = { fg = "#808080", bg = "#080808", bold = true },
    Visual         = { bg = "#403D3D" },
    VisualNOS      = { bg = "#403D3D" },
    WarningMsg     = { fg = "#FFFFFF", bg = "#333333", bold = true },
    WildMenu       = { fg = C.cyan, bg = C.black },
    TabLineFill    = { fg = "#1B1D1E", bg = "#1B1D1E" },
    TabLine        = { fg = "#808080", bg = "#1B1D1E" },

    -- Diff -------------------------------------------
    DiffAdd        = { bg = C.diff_add_bg },
    DiffChange     = { fg = "#89807D", bg = C.diff_change_bg },
    DiffDelete     = { fg = C.diff_delete_fg, bg = C.diff_delete_bg },
    DiffText       = { bg = C.diff_change_bg, bold = true, italic = true },
  }

  -- Allow users to override any group via opts.highlights table
  if opts.highlights then
    for group, spec in pairs(opts.highlights) do
      H[group] = spec
    end
  end

  for group, spec in pairs(H) do
    hi(group, spec)
  end

  if opts.terminal ~= false then
    local term = {
      -- These mirror the original molokai values so :terminal has the same palette
      [0]  = "#1B1D1E", -- black
      [1]  = C.red,
      [2]  = C.green,
      [3]  = C.yellow,
      [4]  = C.cyan,
      [5]  = C.magenta,
      [6]  = "#56B7C2", -- aqua
      [7]  = C.white,
      [8]  = "#505354", -- bright black / gray
      [9]  = C.red,
      [10] = C.green,
      [11] = C.yellow,
      [12] = C.cyan,
      [13] = C.magenta,
      [14] = "#66D9EF", -- bright aqua
      [15] = C.white,
    }
    for i = 0, 15 do
      vim.g["terminal_color_" .. i] = term[i]
    end
  end
end

-- Load immediately if sourced as a colorscheme
if vim.g.colors_name == nil or vim.g.colors_name == "molokai" then
  M.setup()
  vim.g.colors_name = "molokai"
end

return M
