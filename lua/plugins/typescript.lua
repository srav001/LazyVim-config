local tsgo_filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
}

local ts_project_root_markers = {
	"pnpm-workspace.yaml",
	"pnpm-lock.yaml",
	"package-lock.json",
	"yarn.lock",
	"bun.lockb",
	"tsconfig.json",
	"jsconfig.json",
	"package.json",
	".git",
}

local oxc_supported = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"json",
	"jsonc",
	"vue",
	"svelte",
	"astro",
}

local package_sections = {
	"dependencies",
	"devDependencies",
	"optionalDependencies",
	"peerDependencies",
}

local function project_root_from_dir(dirname)
	return vim.fs.root(dirname, ts_project_root_markers)
end

local function find_tsgo_root(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" then
		return nil
	end

	local bin = vim.fs.find("node_modules/.bin/tsgo", {
		path = vim.fs.dirname(filename),
		upward = true,
		stop = vim.env.HOME,
	})[1]
	if not bin then
		return nil
	end

	return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(bin)))
end

local function vtsls_root_dir(bufnr, on_dir)
	if find_tsgo_root(bufnr) then
		return
	end

	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" then
		return
	end

	local root = project_root_from_dir(vim.fs.dirname(filename))
	if root then
		on_dir(root)
	end
end

local ts_settings = {
	updateImportsOnFileMove = { enabled = "always" },
	suggest = { completeFunctionCalls = true },
	inlayHints = {
		enumMemberValues = { enabled = true },
		functionLikeReturnTypes = { enabled = false },
		parameterNames = {
			enabled = "literals",
			suppressWhenArgumentMatchesName = true,
		},
		parameterTypes = { enabled = true },
		propertyDeclarationTypes = { enabled = true },
		variableTypes = { enabled = false },
	},
}

local function repo_root_from_ctx(ctx)
	return project_root_from_dir(ctx.dirname)
end

local function repo_root(_, ctx)
	return repo_root_from_ctx(ctx)
end

local function read_root_package_json(ctx)
	local root = repo_root_from_ctx(ctx)
	if not root then
		return nil
	end

	local package_json = root .. "/package.json"
	if vim.fn.filereadable(package_json) ~= 1 then
		return nil
	end

	local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))
	if not ok or type(data) ~= "table" then
		return nil
	end

	return data
end

local function root_package_has(ctx, package_name)
	local package_json = read_root_package_json(ctx)
	if not package_json then
		return false
	end

	for _, section in ipairs(package_sections) do
		local dependencies = package_json[section]
		if type(dependencies) == "table" and dependencies[package_name] ~= nil then
			return true
		end
	end

	return false
end

local function should_use_repo_oxfmt(_, ctx)
	return root_package_has(ctx, "oxfmt")
end

local function should_use_repo_vp_fmt(_, ctx)
	return not root_package_has(ctx, "oxfmt") and root_package_has(ctx, "vite-plus")
end

local function add_formatter(formatters, formatter)
	for _, existing in ipairs(formatters) do
		if existing == formatter then
			return
		end
	end

	table.insert(formatters, formatter)
end

return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}

			opts.servers.vtsls = opts.servers.vtsls or {}
			opts.servers.vtsls.enabled = true
			opts.servers.vtsls.root_dir = vtsls_root_dir

			opts.servers.tsgo = {
				enabled = true,
				mason = false,
				filetypes = tsgo_filetypes,
				settings = { typescript = ts_settings, javascript = ts_settings },
				single_file_support = false,
				cmd = function(dispatchers, config)
					local bin = config.root_dir .. "/node_modules/.bin/tsgo"
					return vim.lsp.rpc.start({ bin, "--lsp", "--stdio" }, dispatchers, { cwd = config.root_dir })
				end,
				root_dir = function(bufnr, on_dir)
					local root = find_tsgo_root(bufnr)
					if root then
						on_dir(root)
					end
				end,
			}

			opts.servers.oxlint = opts.servers.oxlint or {}
			opts.servers.oxfmt = { enabled = false }
		end,
	},
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"oxlint",
				--"oxfmt"
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			local util = require("conform.util")

			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters = opts.formatters or {}

			opts.formatters.repo_oxfmt = {
				command = util.from_node_modules("oxfmt"),
				args = { "--stdin-filepath", "$FILENAME" },
				stdin = true,
				cwd = repo_root,
				require_cwd = true,
				condition = should_use_repo_oxfmt,
			}

			opts.formatters.repo_vp_fmt = {
				command = util.from_node_modules("vp"),
				args = { "fmt", "--stdin-filepath", "$FILENAME" },
				stdin = true,
				cwd = repo_root,
				require_cwd = true,
				condition = should_use_repo_vp_fmt,
			}

			for _, ft in ipairs(oxc_supported) do
				opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
				add_formatter(opts.formatters_by_ft[ft], "repo_oxfmt")
				add_formatter(opts.formatters_by_ft[ft], "repo_vp_fmt")
			end
		end,
	},
}
