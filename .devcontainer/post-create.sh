#!/bin/bash
set -e

echo "=== [1/5] Updating package list ==="
sudo apt update

echo "=== [2/5] Installing required packages (QEMU, OVMF, utils) ==="
sudo apt install -y \
    wget curl git nano net-tools \
    qemu-system-x86 ovmf \
    qemu-utils \
    qemu-kvm \
    libvirt-clients \
    libvirt-daemon-system \
    bridge-utils \
    virtinst \
    whois \
    unzip zip p7zip-full p7zip-rar \
    dosfstools ntfs-3g \
    tzdata \
    htop tmux screen vim \
    neofetch

# Если не нужен Python/Node – можно убрать, но они уже есть в features

echo "=== [3/5] Adding user to KVM group and enabling modules ==="
sudo adduser $USER kvm 2>/dev/null || true
sudo modprobe kvm 2>/dev/null || true
sudo modprobe kvm-intel 2>/dev/null || true
sudo modprobe kvm-amd 2>/dev/null || true

echo "=== [4/5] Installing Docker Compose standalone ==="
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== [5/5] EXTREME CLEANUP: removing all bloatware ==="

# --- Удаляем все локали, кроме английской и русской ---
sudo find /usr/share/locale -mindepth 1 -maxdepth 1 -type d ! -name "en_US" ! -name "ru_RU" -exec rm -rf {} + 2>/dev/null || true
sudo find /usr/share/locale -type f -name "*.mo" ! -path "*en_US*" ! -path "*ru_RU*" -delete 2>/dev/null || true

# --- Удаляем всю документацию, man-страницы, примеры ---
sudo rm -rf /usr/share/doc /usr/share/man /usr/share/info /usr/share/gtk-doc /usr/share/help /usr/share/gnome/help 2>/dev/null || true
sudo rm -rf /usr/local/share/doc /usr/local/share/man 2>/dev/null || true

# --- Удаляем предустановленные большие пакеты (Azure, AWS, GCP, если они есть) ---
sudo apt remove -y --purge azure-cli google-cloud-sdk awscli 2>/dev/null || true
sudo apt autoremove -y --purge

# --- Чистим кэш пакетов ---
sudo apt clean
sudo apt autoclean

# --- Удаляем временные файлы, кэш пользователя, логи ---
rm -rf /tmp/* ~/tmp/* ~/.cache/* ~/.wget-hsts 2>/dev/null || true
sudo rm -rf /var/tmp/* 2>/dev/null || true
sudo journalctl --rotate 2>/dev/null || true
sudo journalctl --vacuum-time=1s 2>/dev/null || true
sudo rm -f /var/log/*.gz /var/log/*.old /var/log/*.1 2>/dev/null || true
sudo find /var/log -type f -name "*.log" -exec truncate -s 0 {} \; 2>/dev/null || true

# --- Удаляем кэш VS Code (все версии) ---
rm -rf ~/.vscode-server ~/.vscode-remote ~/.config/Code ~/.cache/vscode 2>/dev/null || true
sudo rm -rf /root/.vscode-server /root/.vscode-remote 2>/dev/null || true

# --- Удаляем кэш языковых инструментов ---
rm -rf ~/.npm ~/.cache/pip ~/.cache/yarn ~/.composer ~/.gem ~/.cache/go-build 2>/dev/null || true

# --- Если есть Docker – чистим его полностью ---
if command -v docker &> /dev/null; then
    docker system prune -a -f --volumes
    docker volume prune -f
    docker network prune -f
    docker image prune -a -f
    docker builder prune -a -f
fi

# --- Удаляем старые ядра (если есть) ---
sudo apt autoremove --purge -y

# --- Обнуляем историю команд (экономит немного места) ---
cat /dev/null > ~/.bash_history 2>/dev/null || true
cat /dev/null > ~/.zsh_history 2>/dev/null || true

# --- Создаём алиасы для удобства ---
echo "alias ll='ls -la'" >> ~/.bashrc
echo "alias qemu='qemu-system-x86_64'" >> ~/.bashrc
echo "alias docker-compose='docker compose'" >> ~/.bashrc

# --- Создаём папку для общих файлов (если нет) ---
mkdir -p /workspaces/codespaces-blank/shared_files
chmod 777 /workspaces/codespaces-blank/shared_files

# --- Делаем исполняемыми .bat-скрипты (для Windows) ---
chmod +x /workspaces/codespaces-blank/oem_automation/*.bat 2>/dev/null || true
chmod +x /workspaces/codespaces-blank/shared_files/*.bat 2>/dev/null || true

# --- Устанавливаем часовой пояс ---
sudo timedatectl set-timezone Europe/Moscow 2>/dev/null || echo "Timezone not set"

echo "=== CLEANUP COMPLETE! ==="
df -h /
du -sh /workspaces/codespaces-blank 2>/dev/null || echo "Workspaces folder not found"
