# REPLet - the Mudlet Lua REPL

This package replicates the functionality of the `lua` alias inside its own UserWindow.

It comes with a single alias, `replet`, which opens the REPLet console. From there, you can execute arbitrary Lua code and see the results in the console.

Once you have the console open, type `usage` within the console to see extra commands that REPLet comes with, in addition to executing code.

By default, adds `recho(msg)`, `rcecho(msg)` etc to allow for easy c/d/h/echoing directly to the console. Also adds rdisplay, which works like display() but prints to the REPLet console. If this covers over functions you already have and want to use in the console, use `addEchos false` in the REPLet console's command line.

## Why REPLet?

REPL is an acronym which stands for `Read Execute Print Loop` and is the term for interactive code runners like this. So I squashed it together with Mudlet to make REPLet.
