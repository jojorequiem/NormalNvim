local M = {}

function M.setup()
  local root_markers = { ".git", "pom.xml", "mvnw", "gradlew", "build.gradle" }
  local root_dir = require("jdtls.setup").find_root(root_markers)
  if not root_dir then
    vim.notify("JDTLS: no root_dir", vim.log.levels.WARN)
    return
  end

  local lombok_path = "/home/jonathan/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar"
  local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local config_dir = jdtls_path .. "/config_linux"
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

  local cmd = {
    "java",
    "-javaagent:" .. lombok_path,
    "--add-modules=ALL-SYSTEM",
    "-Xms1g",
    "-Xmx2G",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir,
  }

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = {
      java = {
        configuration = {
          annotationProcessing = {
            enabled = true,
          },
        },
      },
    },
    init_options = {
      bundles = {},
    },
  }

  require("jdtls").start_or_attach(config)
end

return M
