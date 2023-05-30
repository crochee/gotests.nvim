# gotests.nvim

This is a lua plugin to handle [gotests](https://github.com/cweill/gotests) with Neovim.

## Required

- [gotests](https://github.com/cweill/gotests)

## Installation
gotests-vim requires **gotests** to be available in your `$PATH`.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "crochee/gotests.nvim",
  ft = "go",
  config = function()
    require("gotests").setup()
  end,
},
```
