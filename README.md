# My use full bash scripts

### How to exclude file when using scp command recursively
rsync -av -e ssh --exclude='*.out' /path/to/source/ user@host:/path/to/dest/
