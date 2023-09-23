# Connecting to GitHub with SSH

```bash
# Generating a new SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Adding your SSH key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
https://github.com/settings/ssh/new
```
