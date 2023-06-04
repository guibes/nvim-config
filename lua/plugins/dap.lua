local present, dap = pcall(require, "dap")
if not present then
  return
end

-- dap-install configurations
local dap_install = require("dap-install")
dap_install.setup({
  installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})
local dap_install = require("dap-install")
local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

for _, debugger in ipairs(dbg_list) do
  dap_install.config(debugger)
end

-- vscode-js-debug (js-debug-adapter in Mason)
require('dap-vscode-js').setup({
    debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
    debugger_cmd = {'js-debug-adapter'},
    adapters = {
        'pwa-node',
        'pwa-chrome',
        'pwa-msedge',
        'node-terminal',
        'pwa-extensionHost',
    },
})

-- add configuration for typescript and javascript
for _, language in ipairs({'typescript', 'javascript'}) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require'dap.utils'.pick_process,
        cwd = "${workspaceFolder}",
      }
    }
end


dap.defaults.fallback.terminal_win_cmd = "ToggleTerm"
vim.fn.sign_define("DapBreakpoint", { text = "● ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "● ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "● ", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→ ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointReject", { text = "●", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
