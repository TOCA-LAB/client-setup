#!/usr/bin/bash

declare -A PKG
declare -A GETPKG
declare -A INSTALLERS
declare -A SETUP_TASKS

# ==============================================================================
#
#   Configurations
#
# ==============================================================================

# Variables --------------------------------------------------------------------

# Packages from the system repository 
# You can use any name as the key for the array. Their are use exclusively to 
# organize the packages. 
PKG[DEBUGGERS]="cgdb gdb lldb valgrind"
PKG[SYNC_TOOLS]="syncthing syncthing-gtk rsync"
PKG[SCREENSHOT]="flameshot"
PKG[TEXT_EDITORS]="gedit vim-gui-common neovim neovim-qt emacs emacs-gtk"
PKG[OFFICE_SUITE]="libreoffice foliate okular okular-extra-backends evince pdfarranger zathura zathura-pdf-poppler xournalpp calibre"
PKG[PYTHON_TOOLS]="jupyter ipython3 python3-pip"
PKG[VCS_TOOLS]="git gitg"
PKG[GRAPHIC_EDITORS]="gimp inkscape"
PKG[DIFF_TOOLS]="meld git-delta"
PKG[MEDIA_PLAYERS]="vlc mvp mplayer"
PKG[EMAIL_CLIENTS]="thunderbird neomutt"
PKG[SEARCH_TOOLS]="fzf ripgrep ack"
PKG[LAUNCHERS]="rofi"
PKG[SHELLS]="zsh"
PKG[ARCHIVERS]="unrar rar p7zip-full p7zip-rar"
PKG[FILE_MANAGERS]="lf"
PKG[DOC_TOOLS]="pandoc"
PKG[SSH_TOOLS]="ssh"
PKG[COMPILERS]="clang clang-format build-essential"
PKG[MONITORING]="htop"
PKG[LATEX_TOOLS]="texlive-full texstudio"
PKG[AUTH_TOOLS]="sssd-ad sssd-tools realmd adcli"
PKG[TERMINAL_MULTIPLEXERS]="tmux screen"
PKG[TERMINAL_EMULATORS]="tilix"
PKG[PASSWORD_MANAGERS]="keepassxc"
PKG[UTILS]="tree trash-cli bat exa jq zsh"
PKG[JAVASCRIPT]="nodejs npm"
PKG[AUDIO]="audacity"
PKG[RESEARCH]="nauty"
PKG[RUST]="rust-all cargo"
PKG[SAGEMATH_DEPENDENCIES]="automake bc binutils bzip2 ca-certificates cliquer cmake curl ecl eclib-tools fflas-ffpack flintqs g++ gengetopt gfan gfortran git glpk-utils gmp-ecm lcalc libatomic-ops-dev libboost-dev libbraiding-dev libbz2-dev libcdd-dev libcdd-tools libcliquer-dev libcurl4-openssl-dev libec-dev libecm-dev libffi-dev libflint-dev libfreetype-dev libgc-dev libgd-dev libgf2x-dev libgiac-dev libgivaro-dev libglpk-dev libgmp-dev libgsl-dev libhomfly-dev libiml-dev liblfunction-dev liblrcalc-dev liblzma-dev libm4rie-dev libmpc-dev libmpfi-dev libmpfr-dev libncurses-dev libntl-dev libopenblas-dev libpari-dev libpcre3-dev libplanarity-dev libppl-dev libprimesieve-dev libpython3-dev libqhull-dev libreadline-dev librw-dev libsingular4-dev libsqlite3-dev libssl-dev libsuitesparse-dev libsymmetrica2-dev zlib1g-dev libzmq3-dev libzn-poly-dev m4 make nauty openssl palp pari-doc pari-elldata pari-galdata pari-galpol pari-gp2c pari-seadata patch perl pkg-config planarity ppl-dev python3-setuptools python3-venv r-base-dev r-cran-lattice singular sqlite3 sympow tachyon tar tox xcas xz-utils texlive-latex-extra texlive-xetex latexmk pandoc dvipng"

# Packages to be downloaded from the web
# The name in the key of the array is used only to print the name in screen.
GETPKG["Google Chrome"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
GETPKG["Visual Studio Code"]="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
GETPKG["Obsidian"]="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/obsidian_1.8.10_amd64.deb"
GETPKG["Balena Etcher"]="https://github.com/balena-io/etcher/releases/download/v2.1.4/balena-etcher_2.1.4_amd64.deb"
GETPKG["TikZit"]="https://github.com/tikzit/tikzit/releases/download/v0.14.3/tikzit-0.14.3-amd64.deb"
GETPKG["Oracle Java"]="https://download.oracle.com/java/24/latest/jdk-24_linux-x64_bin.deb"


#  Functions for installing apps -----------------------------------------------

install_zotero(){
  if [ ! -d /opt/Zotero_linux-x86_64 ]; then
    echo "🔹 Installing Zotero..."
    wget -c "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64" -O /tmp/zotero.tar.bz2
    tar -xjf /tmp/zotero.tar.bz2 -C /opt
    rm /tmp/zotero.tar.bz2
    ln -sf /opt/Zotero_linux-x86_64/zotero /usr/local/bin/zotero
  fi
}

INSTALLERS+=(install_zotero)

install_spotify() {
  if ! command -v spotify >/dev/null 2>&1; then
    echo "🔹 Installing Spotify..."
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
    apt-get update && apt-get install -y spotify-client
  fi
}

INSTALLERS+=(install_spotify)

install_lazygit(){
  if ! command -v lazygit >/dev/null 2>&1; then
    echo "🔹 Installing Lazygit..."
    echo "Instalando Lazygit..."
    wget -qO-  https://github.com/jesseduffield/lazygit/releases/download/v0.54.2/lazygit_0.54.2_linux_x86_64.tar.gz  | tar -xz -C /tmp
    install /tmp/lazygit /usr/local/bin/
  fi
}

INSTALLERS+=(install_lazygit)


install_gurobi() {
  echo "🔹 Installing Gurobi..."
  wget -c https://packages.gurobi.com/12.0/gurobi12.0.3_linux64.tar.gz -O /tmp/gurobi.tar.gz
  tar -xzf /tmp/gurobi.tar.gz -C /opt
  rm -rf /tmp/gurobi.tar.gz 

  echo 'export GUROBI_HOME=/opt/gurobi1200/linux64/' >> /etc/environment
  echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"' >> /etc/environment
  echo 'export GRB_LICENSE_FILE=$HOME/.gurobi.lic' >> /etc/environment 
}

INSTALLERS+=(install_gurobi)

install_sagemath() {
  echo "🔹 Installing Sagemath..."
  cd /opt/
  git clone --branch master https://github.com/sagemath/sage.git
  cd sage
  make configure
  ./configure
  MAKE="make -j8" make
  ln -sf $(pwd)/sage /usr/local/bin
}

INSTALLERS+=(install_sagemath)


# ------------------------------------------------------------------------------
#
#  Settings functions
#
# ------------------------------------------------------------------------------

enable_ssh() {
  msg "Enabling ssh-server"
  apt install -y openssh-server
  systemctl enable ssh
  systemctl start ssh
}

SETUP_TASKS+=(enable_ssh)


config_java() {
    echo "🔹Configuring Oracle Java" 
    update-alternatives --install /usr/bin/java java "/usr/lib/jvm/java-17-openjdk-amd64/bin/java" 1
    update-alternatives --set java "/usr/lib/jvm/java-17-openjdk-amd64/bin/java"
    echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> /etc/environment
    echo 'export PATH=$PATH:${JAVA_HOME}/bin' >> /etc/environment
}

SETUP_TASKS+=(config_java)


create_toca_admin_user() {
  if ! id "toca-admin" >/dev/null 2>&1; then

    usermod -p '$6$I4.AEGsHjqIRCAra$w8jTpk30UljqQxo.mnlJH3ns029VexHyLYcAFbiBEFcEVWFBs0BRIFIt1yAOvxzSYxu1qJ5Bqg1twYnvBZcLJ.' toca-admin
    usermod -aG sudo toca-admin

    SSH_DIR="/home/toca-admin/.ssh"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    # Install public key 
    cat << 'EOF' > "$SSH_DIR/authorized_keys"
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSRyQHPVGi/YfcIS4Xep7O4sDXgFlVlLDEbnkoygKyL
    EOF

    chmod 600 "$SSH_DIR/authorized_keys"
    chown -R toca-admin:toca-admin "$SSH_DIR"
  fi
}

SETUP_TASKS+=(create_toca_admin_user)

# XXX preciso verificar se existe um usuário chamado toca-admin

# ------------------------------------------------------------------------------
#
#  Helper functions and global variables
#
# ------------------------------------------------------------------------------

ALL_PACKAGES="${PKG[*]}"

msg() {
  echo -e "\033[1;34m⇒\033[0;0m $1"
}

install_deb() {
  wget -c "$1" -O /tmp/package.deb
  dpkg -i /tmp/package.deb || apt-get install -f -y
  rm -f /tmp/package.deb
}

download_deb_and_install() {
    local url="$1"
    local tmpfile
    tmpfile=$(mktemp)
    wget -q --show-progress -O "$tmpfile" "$url"
    dpkg -i "$tmpfile" || apt-get install -f -y
    rm -f "$tmpfile"
}

print_banner() {
  echo '                    ___           ___           ___     '
  echo '                   /\  \         /\__\         /\  \    '
  echo '      ___         /::\  \       /:/  /        /::\  \   '
  echo '     /\__\       /:/\:\  \     /:/  /        /:/\:\  \  '
  echo '    /:/  /      /:/  \:\  \   /:/  /  ___   /:/ /::\  \ '
  echo '   /:/__/      /:/__/ \:\__\ /:/__/  /\__\ /:/_/:/\:\__\'
  echo '  /::\  \      \:\  \ /:/  / \:\  \ /:/  / \:\/:/  \/__/'
  echo ' /:/\:\  \      \:\  /:/  /   \:\  /:/  /   \::/__/     '
  echo ' \/__\:\  \      \:\/:/  /     \:\/:/  /     \:\  \     '
  echo '      \:\__\      \::/  /       \::/  /       \:\__\    '
  echo '       \/__/       \/__/         \/__/         \/__/    '
}

# ------------------------------------------------------------------------------
#
#  Main program
#
# ------------------------------------------------------------------------------

print_banner()

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be exectured as root or using sudo." >&2
  exit 1
fi

if [ "$USER" != "toca-admin" ]; then
  echo "The user 'toca-admin' does not exist! You must create it before running this script." >&2
  exit 1
fi

msg "Updating system packages"
apt update

msg "Installing packages from system's repository"
apt install -y $ALL_PACKAGES

msg "Installing packages from web"
for name in "${!GETPKG[@]}"; do
  echo "🔹 Instaling: $name"
  download_deb_and_install "${DEB_PACKAGES[$name]}"
done

msg "Installing Snaps"
snap install telegram-desktop

msg "Installing apps from source"
for func in "${INSTALLERS[@]}"; do
    "$func"
done

msg "Setting configurations"
for func in "${SETUP_TASKS[@]}"; do
    "$func"
done


# # Adicionar máquina ao Active Directory
# echo "=== Adicionando máquina ao AD ==="
# read -p "Digite o domínio AD (ex: exemplo.local): " AD_DOMAIN
# read -p "Digite o usuário AD com permissão para ingressar: " AD_USER
#
# realm join --user="$AD_USER" "$AD_DOMAIN"
# if [ $? -eq 0 ]; then
#     echo "Máquina adicionada ao AD com sucesso."
# else
#     echo "Falha ao adicionar ao AD."
# fi

