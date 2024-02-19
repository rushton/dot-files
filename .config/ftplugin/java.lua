local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = '/Users/nrushton/.cache/jdtls/workspaces/' .. project_name

local config = {
    cmd = { '/opt/homebrew/bin/jdtls', "-data", workspace_dir, "--jvm-arg=" .. "-javaagent:" .. os.getenv("HOME") .. "/lombok-1.18.30.jar" },
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' })
}
require('jdtls').start_or_attach(config)
