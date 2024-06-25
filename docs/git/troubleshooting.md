# Troubleshooting

## fatal: unable to access ... Recv failure: Connection was reset

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
git config --global user.name "yourusername"
git config --global user.email "youremail"
```

## clone large git repository

<https://stackoverflow.com/questions/34389446/how-do-i-download-a-large-git-repository>

```bash
git config --global core.compression 0
git clone --depth 1 <repo_URI>
git fetch --unshallow 
# or if it's still too much, get only last 25 commits
git fetch --depth=25
git pull --all
```
