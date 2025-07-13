#!/bin/bash

# Optional Telegram Bot Token and Chat ID for notifications
TELEGRAM_BOT_TOKEN=""  # e.g. 6072709717:AAEgCbWT3zQ760HMfKVlFid05UhCRzQREe0
TELEGRAM_CHAT_ID=""    # e.g. -1001686463549

# Logging function: prints to terminal and sends Telegram message if credentials are set
log_and_report() {
    MESSAGE="$1"
    echo "$MESSAGE"
    if [[ -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]]; then
        curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
             -d chat_id="${TELEGRAM_CHAT_ID}" \
             -d text="$MESSAGE" > /dev/null
    fi
}

log_and_report "Script execution started."

# Update and upgrade system
if sudo apt update && sudo apt upgrade -y; then
    log_and_report "[✔️] System updated and upgraded successfully."
else
    log_and_report "[❌] Failed to update or upgrade system."
fi

# Install required packages
packages=("git" "gcc" "snapd" "coreutils" "make" "python3-pip" "pipx")
for package in "${packages[@]}"; do
    if sudo apt install -y "$package"; then
        log_and_report "[✔️] Installed $package successfully."
    else
        log_and_report "[❌] Failed to install $package."
        exit 1
    fi
done

# Install Go using snap
if sudo snap install go --classic; then
    log_and_report "[✔️] Go installed successfully."
else
    log_and_report "[❌] Failed to install Go."
    exit 1
fi

# List of Go tools to install
go_tools=(
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
    "github.com/projectdiscovery/httpx/cmd/httpx"
    "github.com/s0md3v/smap/cmd/smap"
    "github.com/lc/gau/v2/cmd/gau"
    "github.com/tomnomnom/unfurl"
    "github.com/projectdiscovery/alterx/cmd/alterx"
    "github.com/projectdiscovery/shuffledns/cmd/shuffledns"
    "github.com/owasp-amass/amass/v4/..."
)

for tool in "${go_tools[@]}"; do
    if GO111MODULE=on go install "$tool"@latest; then
        binary_name=$(basename "$tool")
        sudo cp ~/go/bin/"$binary_name" /usr/bin/
        log_and_report "[✔️] Installed $binary_name successfully."
    else
        log_and_report "[❌] Failed to install $tool."
        exit 1
    fi
done

# Install assetfinder
if go install -v github.com/tomnomnom/assetfinder@latest && sudo cp ~/go/bin/assetfinder /usr/bin/; then
    log_and_report "[✔️] Assetfinder installed successfully."
else
    log_and_report "[❌] Failed to install Assetfinder."
    exit 1
fi

# Install Massdns
if git clone https://github.com/blechschmidt/massdns.git && cd massdns && sudo apt install make -y && make && sudo make install; then
    log_and_report "[✔️] Massdns installed successfully."
else
    log_and_report "[❌] Failed to install Massdns."
    exit 1
fi
cd ..

# Install Sublist3r
if git clone https://github.com/aboul3la/Sublist3r.git && cd Sublist3r && pip3 install -r requirements.txt; then
    log_and_report "[✔️] Sublist3r installed successfully."
else
    log_and_report "[❌] Failed to install Sublist3r."
    exit 1
fi
cd ..

# Install Amass
if go install -v github.com/owasp-amass/amass/v4/...@master && sudo cp ~/go/bin/amass /usr/bin/; then
    log_and_report "[✔️] Amass installed successfully."
else
    log_and_report "[❌] Failed to install Amass."
    exit 1
fi

# Install bbot with pipx
if pipx install bbot; then
    pipx ensurepath
    log_and_report "[✔️] Bbot installed successfully."
else
    log_and_report "[❌] Failed to install Bbot."
    exit 1
fi

# Install Findomain
if wget https://github.com/Findomain/Findomain/releases/download/9.0.4/findomain-linux.zip && \
   sudo apt install -y unzip && \
   unzip findomain-linux.zip && \
   chmod +x findomain && \
   sudo mv findomain /usr/local/bin/ && \
   rm -f findomain-linux.zip; then
    log_and_report "[✔️] Findomain installed successfully."
else
    log_and_report "[❌] Failed to install Findomain."
    exit 1
fi

log_and_report "Script execution finished successfully."
