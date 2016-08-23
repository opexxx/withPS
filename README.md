# withPS
[![Join the chat at https://gitter.im/withps/Lobby](https://badges.gitter.im/withps/Lobby.svg)](https://gitter.im/withps/Lobby)

## Program prefixing for continuous workflow using a single tool
```
with git
git> add .
git> commit -m "Initial commit"
git> push
```

### Installation
```
(New-Object Net.WebClient).DownloadString("https://cdn.rawgit.com/Acader/withPS/master/withps.ps1") | iex
```
or
```
(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Acader/withPS/master/withps.ps1") | iex
```
or
```
.\withps.ps1 -i
```


### Usage

`with <program>`

Starts an interactive shell with where every command is prefixed using `<program>`
To exit enter `:exit` or press Ctrl + C.

```
$ with git
git> add .
git> commit -a -m "Commited"
git> push
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
gcc -o -output input.c>
<enter>
Compiling...
gcc -o -output input.c>
```

### Unprefixed shell command
To execute a shell command proper prefix line with `!` or `:`
```
git> !echo 'Hello Wolrd'
Hello Wolrd
git> :echo 'Hello Wolrd'
Hello World
```


### Add and drop commands

Add
```
git> +add
git add>
```

Drop
```
git add> -
git>
```

Drop all
```
git add .> --
git>
```

## Flavors

- [Bash](https://github.com/mchav/with)
- [Python 3](https://github.com/renanivo/with)
- [Node.js](https://github.com/KazeFlame/with.js)
