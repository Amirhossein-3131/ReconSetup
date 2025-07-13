**ReconSetup**



````markdown
# ReconSetup

**ReconSetup** is a bash script designed to automate the installation and setup of essential reconnaissance tools for external security assessments and bug bounty hunting.

---

## Features

- Updates and upgrades the system packages
- Installs required dependencies like `git`, `gcc`, `snapd`, `make`, `python3-pip`, `pipx`
- Installs Go programming language using snap
- Installs multiple Go-based reconnaissance tools such as `subfinder`, `httpx`, `gau`, `unfurl`, `amass`, and more
- Installs other important tools like `assetfinder`, `massdns`, `Sublist3r`, `bbot`, and `Findomain`
- Optional Telegram notifications for installation progress and status updates

---

## Requirements

- A Debian-based Linux distribution (Ubuntu, Debian, etc.)
- Internet connection
- Optional: Telegram Bot Token and Chat ID (for notifications)

---

## Usage

1. Clone or download the script to your Linux machine.

2. (Optional) Edit the script to add your Telegram Bot Token and Chat ID for notifications:

```bash
TELEGRAM_BOT_TOKEN="your_bot_token_here"
TELEGRAM_CHAT_ID="your_chat_id_here"
````

3. Make the script executable:

```bash
chmod +x reconsetup.sh
```

4. Run the script with sudo:

```bash
sudo ./reconsetup.sh
```

---

## Notes

* The script installs tools globally and requires sudo privileges.
* If you do not want Telegram notifications, leave the `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` empty.
* The script may reboot your system after execution (remove or comment out reboot command if not desired).

