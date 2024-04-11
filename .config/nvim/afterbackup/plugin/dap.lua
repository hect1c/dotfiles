local status_ok, dap = pcall(require, "dap")
if not status_ok then return end

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {
        os.getenv("HOME") .. "/Code/vscode-chrome-debug/out/src/chromeDebug.js",
        "45635"
    }
}
dap.configurations.typescript = {
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        debugServer = 45635,
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}
