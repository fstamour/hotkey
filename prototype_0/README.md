# First protoype

## Log (kind of)

### Around the 6th of January 2017
Tried quickly how we could pass from a high-level description (list of symbols)
of a key event (here modeled after AutoHotKey) to a string representation usable
by the target software (ahk).

## Notes about the code

It is in lisp, I doubt it is readily loadable. It is really short and crude.
But it got 2 unit-tests already :tada:.

The next steps for it to be slightly more than a dump of code:
* Make a system definition file (.asd)
* Separate the code in multiple files already:
    * One file for the package description.
    * One for the tests
    * One for the code.
    * One for the utilities.

## Ideas

Maybe try the same in python, at least it would be in a popular language. And
I wouldn't loose too much interactivity if I use notebooks.
