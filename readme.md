## tweaking dotfiles for eternity

_You need to be inside dotfiles dir to perform these commands._

Link each folder to home using stow, for example:

```sh
stow scripts -t ~
```

Or link all using:

```sh
ls -d */ | xargs -I {} stow {} -t ~
```

Unlink using:

```sh
stow -D scripts/ -t ~
```

You can safely ignore warnings about BUG from stow when unlinking.
