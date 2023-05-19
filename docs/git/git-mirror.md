# Git mirror

## Duplicating a repository

1. Open Git Bash.
2. Create a bare clone of the repository. 
3. Mirror-push to the new repository.
4. Remove the temporary local repository you created earlier.

```bash
git clone --bare https://github.com/EXAMPLE-USER/OLD-REPOSITORY.git
cd OLD-REPOSITORY.git
git push --mirror https://github.com/EXAMPLE-USER/NEW-REPOSITORY.git
cd ..
rm -rf OLD-REPOSITORY.git
```
