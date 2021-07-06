# Dino Rush

[![cabal](https://github.com/haskell-game-archives/dino-rush/workflows/cabal/badge.svg)](https://github.com/haskell-game-archives/dino-rush/actions?query=workflow%3Acabal)
[![stack](https://github.com/haskell-game-archives/dino-rush/workflows/stack/badge.svg)](https://github.com/haskell-game-archives/dino-rush/actions?query=workflow%3Astack)
[![lint](https://github.com/haskell-game-archives/dino-rush/workflows/lint/badge.svg)](https://github.com/haskell-game-archives/dino-rush/actions?query=workflow%3Alint)
[![format](https://github.com/haskell-game-archives/dino-rush/workflows/format/badge.svg)](https://github.com/haskell-game-archives/dino-rush/actions?query=workflow%3Aformat)
[![dependencies check](https://github.com/haskell-game-archives/dino-rush/actions/workflows/outdated.yml/badge.svg)](https://github.com/haskell-game-archives/dino-rush/actions/workflows/outdated.yml)


![Game Play](https://raw.githubusercontent.com/jxv/dino-rush/master/propaganda/gameplay.gif)

**Blog:** http://jxv.io/blog/2018-02-28-A-Game-in-Haskell.html

**Discussion:** https://www.reddit.com/r/haskell/comments/813yik/a_game_in_haskell_dino_rush/

## OSX build

```
brew install sdl2
brew install sdl2_ttf
brew install sdl2_image
brew install libmikmod
brew install sdl2_mixer
stack build
```

sdl2_mixer must be complied with libmikmod

## Ubuntu build

```
sudo apt install libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libmikmod-dev libsdl2-mixer-dev
stack build
```

## Windows build

```
stack exec -- pacman -S mingw64/mingw-w64-x86_64-pkg-config mingw64/mingw-w64-x86_64-SDL2 mingw64/mingw-w64-x86_64-SDL2_ttf mingw64/mingw-w64-x86_64-SDL2_image mingw64/mingw-w64-x86_64-SDL2_mixer mingw64/mingw-w64-x86_64-libmikmod
stack build
```

## Run

```
stack exec dino-rush
```

## Assets

* Music
    * Goodie (Crack Intro) by Quartex (Oberheim)

* Sound effects were generated by [bfxr](https://www.bfxr.net/)

* Fonts
    * [Computer Speak](https://fontlibrary.org/en/font/computer-speak#Computer%20Speak%20v0.3-Regular) by Shaan Sawrup

* Sprites
    * Dinosaur by [ScissorMarks](https://twitter.com/ScissorMarks)
    * [Water, ground, and rocks](https://opengameart.org/content/basic-map-32x32-by-silver-iv) by [Ivan VOIROL](https://opengameart.org/users/silver-iv)
    * [Lava](https://opengameart.org/content/lpc-terrain-repack) by [William Thompson](http://williamthompsonj.blogspot.de/)
    * [Trees](https://opengameart.org/content/jungle-tree-pack) by [KnoblePersona](https://opengameart.org/users/knoblepersona)
    * [Raven](https://opengameart.org/content/owl-and-raven-sprites) by [Revangle](https://revangale.wordpress.com/)
