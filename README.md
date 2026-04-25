# SuperMake-nvim
Tool to make running Makefiles easier in neovim

use `<leader>m` to pull up make window

On first use in a directory, it will auto populate with directories with Makefiles in them

Press `enter` on a target and it will build it

```
target: file
    - arg1
    - -j4
```
selecting any part of this will make the target in that file passing in arg1 and -j4

