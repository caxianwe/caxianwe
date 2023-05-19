# Git push

## delete all branches but keeping others like "develop" and "master"

```bash
git branch | grep -v "develop" | grep -v "master" | xargs git branch -D
```
