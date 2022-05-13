local inputtoggle

local function Fcitx2en()
    local handle = io.popen("fcitx5-remote")
    if handle == nil then
        vim.notify("fcitx5-remote popen failed")
        return
    end

    local result = tonumber(handle:read("a"))
    handle:close()
    if result == 2 then
        inputtoggle = 1
        os.execute("fcitx5-remote -c")
    end
end

local function Fcitx2zh()
    if inputtoggle == 1 then
        os.execute("fcitx5-remote -o")
    end
    inputtoggle = 0
end

local fcitxAutoSwitch = vim.api.nvim_create_augroup("fcitxautoswitch_cmds", {clear = true})
vim.api.nvim_create_autocmd("InsertLeave",{
    group = fcitxAutoSwitch,
    pattern = "*",
    callback = function()
        Fcitx2en()
    end,
    desc = "Fcitx2en"
})
vim.api.nvim_create_autocmd("InsertEnter",{
    group = fcitxAutoSwitch,
    pattern = "*",
    callback = function()
        Fcitx2zh()
    end,
    desc = "Fcitx2zh"
})
