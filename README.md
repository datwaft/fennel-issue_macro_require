# Issue

The issue is that when the `--no-compiler-sandbox` flag and the `--globals "*"` flag is set, if you require an utils module from a macro module the following error is displayed:

```console
foo@bar:~/repro$ fennel --no-compiler-sandbox --globals "*" init.fnl
Compile error in init.fnl:7
  Compile error in ./macro-utils.fnl:9
  symbols may only be used at compile time

      (= `fn (. x 1))
          ^^
* Try moving this to inside a macro if you need to manipulate symbols/lists.
* Try using square brackets instead of parens to construct a table.
```

**Note:** the stack traceback was omitted for brevity.

Before version `1.0.0` (i.e. `0.10.0`), this issue wasn't present.

This use case would be, for example, if you have an auxiliary function that is used in multiple macro modules (and that function requires the use of symbols or other macro-only functionality), so you try to apply the DRY principle and share an auxiliary macro module that contains that function.

---

**Note:** this issue was found using the Neovim plugin [hotpot.nvim](https://github.com/rktjmp/hotpot.nvim) which transpiles Fennel code, letting you use Fennel to configure Neovim. These are the options that reproduce the issue using this plugin:

```lua
macros = {
  env = "_COMPILER",
  allowedGlobals = false,
  compilerEnv = _G, -- If you comment this the error stops
},
```

The issue in the [hotpot.nvim](https://github.com/rktjmp/hotpot.nvim) repository can be found [here](https://github.com/rktjmp/hotpot.nvim/issues/48).

## How to reproduce the issue

**Note:** you must have Docker installed on your computer.

Execute the following terminal command:

```shell
docker build -t fennel-issue . && docker run -it fennel-issue
```

After that execute the reproduction example:

```shell
cd repro
fennel --no-compiler-sandbox --globals "*" init.fnl
```

## Expected results

The following output is expected using the [hotpot.nvim](https://github.com/rktjmp/hotpot.nvim) Neovim plugin:

```
These lines should print "Hello"
================================

Hello
Hello
These lines should print "Bye"
==============================

Bye
Bye
Bye
```

In the case of using normal Fennel with the flags previously specified, the following output is expected (as this was the output on version `0.10.0`):

```
Compile error in init.fnl:7
  Compile error in ./macro-utils.fnl:7
  unknown identifier in strict mode: list?

    (list? x)
     ^^^^^
* Try looking to see if there's a typo.
* Try using the _G table instead, eg. _G.list? if you really want a global.
* Try moving this code to somewhere that list? is in scope.
* Try binding list? as a local in the scope of this code.
```

This is the expected output because I don't know the exact corresponding flags to the compiler flags used with [hotpot.nvim](https://github.com/rktjmp/hotpot.nvim).

## Current results

The following error is displayed:

```log
Compile error in init.fnl:7
  Compile error in ./macro-utils.fnl:9
  symbols may only be used at compile time

      (= `fn (. x 1))
          ^^
* Try moving this to inside a macro if you need to manipulate symbols/lists.
* Try using square brackets instead of parens to construct a table.
stack traceback:
        [C]: in function 'error'
        /usr/local/bin/fennel:3362: in function 'assert-compile'
        /usr/local/bin/fennel:2210: in function 'assert_compile'
        /usr/local/bin/fennel:3208: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        /usr/local/bin/fennel:1697: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        /usr/local/bin/fennel:1573: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        /usr/local/bin/fennel:1573: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        ...
        /usr/local/bin/fennel:2020: in function 'require-macros'
        src/fennel/macros.fnl:288: in function <src/fennel/macros.fnl:283>
        [C]: in function 'xpcall'
        /usr/local/bin/fennel:2656: in function 'macroexpand_2a'
        /usr/local/bin/fennel:2836: in function 'compile1'
        /usr/local/bin/fennel:3067: in function 'compile-string'
        /usr/local/bin/fennel:4756: in function </usr/local/bin/fennel:4753>
        [C]: in function 'xpcall'
        /usr/local/bin/fennel:5396: in function </usr/local/bin/fennel:5390>
        [C]: at 0x56549cb8e020

(import-macros {: if-fn-hello-else-bye} :macro-module)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Try moving this to inside a macro if you need to manipulate symbols/lists.
* Try using square brackets instead of parens to construct a table.
Compile error in init.fnl:7
  Compile error in ./macro-utils.fnl:9
  symbols may only be used at compile time

      (= `fn (. x 1))
          ^^
* Try moving this to inside a macro if you need to manipulate symbols/lists.
* Try using square brackets instead of parens to construct a table.
stack traceback:
        [C]: in function 'error'
        /usr/local/bin/fennel:3362: in function 'assert-compile'
        /usr/local/bin/fennel:2210: in function 'assert_compile'
        /usr/local/bin/fennel:3208: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        /usr/local/bin/fennel:1697: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        /usr/local/bin/fennel:1573: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        /usr/local/bin/fennel:1573: in function 'special'
        /usr/local/bin/fennel:2680: in function 'compile1'
        ...
        /usr/local/bin/fennel:2020: in function 'require-macros'
        src/fennel/macros.fnl:288: in function <src/fennel/macros.fnl:283>
        [C]: in function 'xpcall'
        /usr/local/bin/fennel:2656: in function 'macroexpand_2a'
        /usr/local/bin/fennel:2836: in function 'compile1'
        /usr/local/bin/fennel:3067: in function 'compile-string'
        /usr/local/bin/fennel:4756: in function </usr/local/bin/fennel:4753>
        [C]: in function 'xpcall'
        /usr/local/bin/fennel:5396: in function </usr/local/bin/fennel:5390>
        [C]: at 0x56549cb8e020

(import-macros {: if-fn-hello-else-bye} :macro-module)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Try moving this to inside a macro if you need to manipulate symbols/lists.
* Try using square brackets instead of parens to construct a table.
```
