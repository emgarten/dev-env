# dev-env

A collection of scripts for setting up development environments.

Many of these scripts run official installer scripts from the web, read through them first and use at your own risk.

## Linux

Scripts live in `setup-scripts/linux`. Run them from that directory.

### Run order

`dev-tools.sh` installs the prerequisites the other scripts assume are present
(`curl`, `git`, `python3`, `build-essential`), so run it first. `fish-starship.sh`
sets fish as the login shell, and `nvm.sh` needs fish present to configure it,
so run `nvm.sh` last:

```bash
./dev-tools.sh        # prerequisites, includes curl
./fish-starship.sh    # fish + starship + fisher plugins
./nvm.sh              # nvm, Node LTS, defaults for bash and fish
```

`nvm.sh` is safe to re-run and can also be run on its own if fish is not wanted.

On Fedora use `fedora-update.sh` and `fish-starship-fedora.sh`. There is no
Fedora equivalent of `dev-tools.sh` yet, so make sure `curl` is installed before
running `nvm.sh`.

### Node and nvm

`nvm.sh` installs the POSIX [nvm](https://github.com/nvm-sh/nvm) into `~/.nvm`
and writes its init block to `~/.bashrc`. It deliberately overrides the
installer's profile detection, which otherwise falls back to `~/.profile` once
fish is the login shell, leaving nvm unavailable in interactive bash shells.

fish cannot source nvm, so `fish-starship.sh` installs
[nvm.fish](https://github.com/jorgebucaran/nvm.fish) via
[fisher](https://github.com/jorgebucaran/fisher) instead. `conf.d/00-nvm.fish`
points its `nvm_data` at `~/.nvm/versions/node`, the layout the POSIX nvm
already uses, so both shells share the same installed Node versions.

The two implementations track the default version separately: bash uses
`nvm alias default` and fish uses the `nvm_default_version` universal variable.
`nvm.sh` sets both.

> **Warning**
> `fisher remove jorgebucaran/nvm.fish` runs `rm -rf $nvm_data`. With the shared
> configuration that deletes every installed Node version, including the ones
> bash uses. Erase `nvm_data` before removing the plugin.