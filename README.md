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

## Windows

Scripts live in `setup-scripts/windows` and use [winget](https://learn.microsoft.com/windows/package-manager/winget/),
so install "App Installer" from the Microsoft Store first if `winget` is
missing. Each script is standalone and safe to re-run: packages that are already
installed and up to date are skipped rather than treated as failures.

| Script | What it does |
| --- | --- |
| `shell.ps1` | PowerShell 7, starship, and the starship init line in the PowerShell 7 profile |
| `dev-tools.ps1` | Python 3.12, GNU make, k9s, helm, Azure CLI, plus `kubectl` and `kubelogin` via `az aks install-cli` |
| `docker-desktop.ps1` | Docker Desktop (chocolatey, not winget) |
| `git-cred-manager.ps1` | Git Credential Manager config (OAuth for Azure Repos and GitHub) |
| `setup-git.ps1` | Global git config, prompts for name and email |

Installers that write to the machine PATH need elevation, so expect UAC prompts.
The scripts refresh PATH in-process where a later step depends on it, but open a
new shell afterwards to pick up the changes everywhere else.

`shell.ps1` appends `Invoke-Expression (&starship init powershell)` to the
PowerShell 7 profile (`$PROFILE.CurrentUserCurrentHost` as reported by `pwsh`,
which handles OneDrive-redirected Documents). It only appends when that line is
absent, so re-running it will not duplicate the entry. Windows PowerShell 5.1
uses a separate profile and is left alone.
