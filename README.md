# dev-env

A collection of scripts for setting up development environments.

Many of these scripts run official installer scripts from the web, read through them first and use at your own risk.

## Linux

Scripts live in `setup-scripts/linux`. Run them from that directory.

### Run order

`dev-tools.sh` installs the prerequisites the other scripts assume are present
(`curl`, `git`, `python3`, `build-essential`), so run it first. `fish-starship.sh`
sets fish as the login shell, and `nvm.sh` needs fish present to configure it,
so run `nvm.sh` last. `copilot-cli.sh` configures fish too when it is there, so
it also belongs after `fish-starship.sh`:

```bash
./dev-tools.sh        # prerequisites, includes curl
./fish-starship.sh    # fish + starship + fisher plugins
./nvm.sh              # nvm, Node LTS, defaults for bash and fish
./copilot-cli.sh      # GitHub Copilot CLI, PATH for bash and fish
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

### Copilot CLI

`copilot-cli.sh` runs the official install script from
[github/copilot-cli](https://github.com/github/copilot-cli), which drops the
binary in `~/.local/bin` for a non-root install. It is safe to re-run.

Two things are handled around that install rather than left to the installer:

- It creates `~/.local/bin` and puts it on `PATH` before the install runs. The
  installer only offers to edit a profile when `copilot` is missing from `PATH`
  afterwards, and that prompt reads from `/dev/tty`, so this keeps the script
  from stopping to ask a question mid-setup.
- It writes the `PATH` entry for bash and fish itself. This is the same problem
  `nvm.sh` works around: the installer picks a profile from `$SHELL`, which stops
  matching bash once `fish-starship.sh` makes fish the login shell. Ubuntu's
  stock `~/.profile` is no help either, since it only adds `~/.local/bin` when
  that directory already exists at login, and fish never reads `~/.profile`.

fish gets the entry through `fish_add_path -U`, and bash through a guarded block
appended to `~/.bashrc`. Both are skipped when already present.

## Windows

Scripts live in `setup-scripts/windows` and use [winget](https://learn.microsoft.com/windows/package-manager/winget/),
so install "App Installer" from the Microsoft Store first if `winget` is
missing. Run them in any order and as many times as you like: packages that are
already installed and up to date are skipped rather than treated as failures.
Each script dot-sources `common.ps1` from its own directory, so keep the folder
intact rather than copying a single script out of it.

| Script | What it does |
| --- | --- |
| `shell.ps1` | PowerShell 7, starship, and the starship init line in the PowerShell 7 profile |
| `dev-tools.ps1` | Python 3.12, GNU make, Azure CLI |
| `copilot-cli.ps1` | GitHub Copilot CLI (winget pulls in PowerShell 7, which it requires) |
| `k8s-tools.ps1` | helm, k9s, plus `kubectl` and `kubelogin` via `az aks install-cli` |
| `docker-desktop.ps1` | Docker Desktop (chocolatey, not winget) |
| `git-cred-manager.ps1` | Git Credential Manager config (OAuth for Azure Repos and GitHub) |
| `setup-git.ps1` | Global git config, prompts for name and email |
| `common.ps1` | Shared winget helpers, dot-sourced by the scripts above rather than run directly |

`k8s-tools.ps1` installs the Azure CLI as well, since `az aks install-cli` is
what provides `kubectl` and `kubelogin`. That overlaps with `dev-tools.ps1` and
is a no-op when the CLI is already there. `copilot-cli.ps1` overlaps with
`shell.ps1` in the same way: the Copilot CLI package depends on PowerShell 7, so
winget installs it if `shell.ps1` has not already.

Installers that write to the machine PATH need elevation, so expect UAC prompts.
The scripts refresh PATH in-process where a later step depends on it, but open a
new shell afterwards to pick up the changes everywhere else.

`shell.ps1` appends `Invoke-Expression (&starship init powershell)` to the
PowerShell 7 profile (`$PROFILE.CurrentUserCurrentHost` as reported by `pwsh`,
which handles OneDrive-redirected Documents). It only appends when that line is
absent, so re-running it will not duplicate the entry. Windows PowerShell 5.1
uses a separate profile and is left alone.
