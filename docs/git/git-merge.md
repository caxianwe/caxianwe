# Git Merge

## merge

```bash
git checkout master
git merge devel 
git branch -D devel 
git push origin master
```

## squash merge

```bash
git checkout master
git merge --squash devel
```

## rebase merge

```bash
git checkout devel 
git rebase -i master 
git checkout master 
git merge devel
```