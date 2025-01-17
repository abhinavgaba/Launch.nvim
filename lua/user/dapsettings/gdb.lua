require("dap").adapters.gdb = {
  type = "executable",
  command = "gdb-oneapi",
  args = { "-i", "dap" },
}

require("dap").configurations.c = {
  {
    name = "gdb",
    type = "gdb",
    request = "launch",
    -- program = "/usr/bin/gdb",
    program = function()
      return vim.fn.input {
        prompt = "Path to Debuggable Executable: ",
        default = vim.fn.getcwd() .. "/",
        completion = "file",
      }
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = true,
    console = "integratedTerminal",
  },
}
