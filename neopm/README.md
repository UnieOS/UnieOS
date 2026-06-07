# NeoPM
NeoPM is the [UnieOS package manager](https://unieos.github.io), based on the apt package manager 
## Help with NeoPM
NeoPM is a friendly package manager based on the apt (for Debian GNU/Linux)
Usage
### Commands
install: Install a package 
Example:
```bash
neopm install neofetch
```
remove: Removes a package
Example:
```bash
neopm remove n
```
search: Search a package on repositories 
Example:
```bash
neopm search nano
```
autoremove: Autoremove orphan packages
Example:
```bash
neopm autoremove
```
help: Shows help message
Example:
```bash
neopm help
```
### Flags
-v:Verbose
Shows detailed version of commands 
Example:
```bash
neopm -v install vlc
```
Local install: (not a flag), but, if neopm detects a path after an install, he installs the package from that path.
