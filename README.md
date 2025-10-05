# docker-wraps-backups-module
Implements module backups for docker wraps environment.

This will provide env-scripts for backups in the docker wraps environment. `env-scripts/not-by-wrap-name/backups`


## Usage
Add `docker-wraps-backups-module` to as submodule to your project:
```bash
git submodule add https://github.com/RomaTk/docker-wraps-backups-module.git modules/<name-you-like>
```

To make wrap working with backups you need to add such command to your wrap in `build.run.after`:
```
source "./env-scripts/not-by-wrap-name/backups/make.sh" && main "$(./envs.sh get name image <wrap-name>)"
```
And to clean backups you can add to `clean`:
```
source "./env-scripts/not-by-wrap-name/backups/clean.sh" && main "$(./envs.sh get name image <wrap-name>)"
```