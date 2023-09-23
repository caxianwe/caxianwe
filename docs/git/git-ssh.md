# Connect to GitHub with SSH

## Generating a new SSH key

```bash
# Create SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Check your SSH key
cd ~/.ssh
ls

# Copy the SSH public key to your clipboard.
clip < ~/.ssh/id_ed25519.pub

```

## Add it to the ssh-agent

<https://github.com/settings/ssh/new>

## Use Proxy

1. Create SSH config file

```bash
touch ~/.ssh/config
nano ~/.ssh/config
```

2. Add the following to your SSH config file.

```text
Host github.com
  User git
  ProxyCommand connect -S 127.0.0.1:1080 %h %p
```

Ctrl+X: To save the changes and exit editing.
