# Install NIX on any Linux distribution

Installing NIX on Linux requires one line and sudo permissions for the user.

On most distributions use the daemon install method:


```shell
sh <(curl -L https://nixos.org/nix/install) --daemon
```

It enables multi-user support and plays nicely into further home configuration.

On distributions using SELinux (Fedora, CentOS) you might either have to disable it (I don't care for it) or use the single user installer (this can result in some problems with shell configuration and other duplicate packages):

```shell
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

Do read up on the [website](https://nixos.org/download.html) for more info on the installers.

Most of the time, NIX becomes available, so close current shell and open a new one. Type:

```shell
nix --version
```

Now you're set! You can use nix in your shell. To enable new nix commands and flakes, which are super useful and used everywhere, enable them by following the instructions:

```shell
mkdir -p /home/$USER/.config/nix
echo "experimental-features = \"flakes nix-command\"" > /home/$USER/.config/nix/nix.conf
```

You can try new nix commands by running:

```shell
nix run nixpkgs#hello
```

This command will download current state of NIX store, parse it and run `hello` package. Running hello will download all of its dependencies and run the main executable. It should print `"Hello, world!"`.
