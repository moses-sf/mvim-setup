return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-calc",
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/cmp-look",
		"simrat39/rust-tools.nvim",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		vim.opt.completeopt = "menu,menuone,noselect"

		local cmp = require("cmp")
		cmp.setup({
			mapping = cmp.mapping.preset.insert({ -- Preset: ^n, ^p, ^y, ^e, you know the drill..
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
			}),
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{ name = "path" },
				}, {
					{ name = "buffer", keyword_length = 3 },
			}),
		})
		-- Setup buffer-local keymaps / options for LSP buffers
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
		local lsp_attach = function(client, buf)
			-- Example maps, set your own with vim.api.nvim_buf_set_keymap(buf, "n", <lhs>, <rhs>, { desc = <desc> })
			-- or a plugin like which-key.nvim
			-- <lhs>        <rhs>                        <desc>
			-- "K"          vim.lsp.buf.hover            "Hover Info"
			-- "<leader>qf" vim.diagnostic.setqflist     "Quickfix Diagnostics"
			-- "[d"         vim.diagnostic.goto_prev     "Previous Diagnostic"
			-- "]d"         vim.diagnostic.goto_next     "Next Diagnostic"
			-- "<leader>e"  vim.diagnostic.open_float    "Explain Diagnostic"
			-- "<leader>ca" vim.lsp.buf.code_action      "Code Action"
			-- "<leader>cr" vim.lsp.buf.rename           "Rename Symbol"
			-- "<leader>fs" vim.lsp.buf.document_symbol  "Document Symbols"
			-- "<leader>fS" vim.lsp.buf.workspace_symbol "Workspace Symbols"
			-- "<leader>gq" vim.lsp.buf.formatting_sync  "Format File"

			vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
			vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
			vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
		end

		-- Setup rust_analyzer via rust-tools.nvim
		require("rust-tools").setup({
			server = {
				capabilities = capabilities,
				on_attach = lsp_attach,
			}
		})

		-- Keymaps for Luasnip
		local ls = require("luasnip")
		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		vim.keymap.set("i", "<C-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end)
	end
}
