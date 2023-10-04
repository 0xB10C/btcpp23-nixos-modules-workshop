cat << EOF > /home/vscode/.ssh/config
Host vm
  hostname 127.0.0.1
  port 2222
  user root
  IdentityFile /home/vscode/.ssh/id_ed25519
  StrictHostKeyChecking accept-new
EOF

chown vscode:vscode /home/vscode/.ssh/config