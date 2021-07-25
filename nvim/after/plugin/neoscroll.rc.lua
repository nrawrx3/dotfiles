if false then
    return
end

require('neoscroll').setup({
    easing_function = "quadratic", -- Default easing function
    -- Set any other options as needed
    hide_cursor = true,          -- hide cursor while scrolling
    stop_eof = true,             -- stop at <eof> when scrolling downwards
    use_local_scrolloff = false, -- use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- the cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,        -- default easing function
    pre_hook = nil,              -- function to run before the scrolling animation starts
    post_hook = nil,              -- function to run after the scrolling animation ends

})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
-- Use the "sine" easing function
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '350', [['sine']]}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '350', [['sine']]}}
-- Use the "circular" easing function
t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']]}}
t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']]}}
-- Pass "nil" to disable the easing animation (constant scrolling speed)
t['<C-y>'] = {'scroll', {'-0.10', 'false', '100', nil}}
t['<C-e>'] = {'scroll', { '0.10', 'false', '100', nil}}
-- When no easing function is provided the default easing function (in this case "quadratic") will be used
t['zt']    = {'zt', {'300'}}
t['zz']    = {'zz', {'300'}}
t['zb']    = {'zb', {'300'}}

require('neoscroll.config').set_mappings(t)
