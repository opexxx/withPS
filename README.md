# withPS
[![Join the chat at https://gitter.im/withps/Lobby](https://badges.gitter.im/withps/Lobby.svg)](https://gitter.im/withps/Lobby)

withPS is a PowerShell version of the bash script [with](https://github.com/mchav/with)

Program prefixing for continuous workflow using a single tool
Usable with PowerShell and CMD

### Installation
#### From PowerShell
1. Open Powershell
2. Enter: `(Invoke-WebRequest https://raw.githubusercontent.com/Acader/withPS/master/installer.cmd).content | cmd`
3. Restart your comupter.

#### Or the old way
1. Clone this repository
2. Execute install.cmd
3. Restart your comupter



### Usage

`with <program>`

Starts an interactive shell with where every command is prefixed using `<program>`.

See `with -h` for mor help

For example:
```
$ with git
git: add .
git: commit -a -m "Commited"
git: push
```


Can also be used for compound commands.
```
$ with java Primes
java Primes> 1
2
java Primes> 4
7
```

And to repeat commands:
```
$ with gcc -o output input.c
gcc -o -output input.c:
<enter>
Compiling...
gcc -o -output input.c:
```


To execute a shell command proper prefix line with `:` or `!`


`git: :dir` or `git: !dir`

You can also drop and add different commands.

```
with git
git: +add
git add: <some file>
git add: -
git: +add test.txt
git add test.txt: --
git:
```

To exit use `:exit` or press Ctrl + C.

