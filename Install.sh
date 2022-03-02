#!/usr/bin/env bash
#######################################################################
#           THYING THIS SCRIP I COPYED FROM THE HUB                   #
#######################################################################
#!/usr/bin/env bash

set -e

skip_system_packages="${1}"

os_type="$(uname -s)"

apt_packages="curl git iproute2 python3-pip ripgrep tmux zsh"
apt_packages_optional="gnupg htop  rsync  zsh-syntax-highlighting zsh-autosuggestions "


install_asdf_version="v0.8.1"
install_node_version="14.17.3"

###############################################################################
# Detect OS and distro type
###############################################################################

function no_system_packages() {
cat << EOF
System package installation isn't supported with your OS / distro.
Please install any dependent packages on your own. You can view the list at:
    https://github.com/nickjj/dotfiles/blob/master/install
Then re-run the script and explicitly skip installing system packages:
    bash <(curl -sS https://raw.githubusercontent.com/nickjj/dotfiles/master/install) --skip-system-packages
EOF

exit 1
}

case "${os_type}" in
    Linux*)
        os_type="Linux"

        if [ !  -f "/etc/debian_version" ]; then
           [ -z "${skip_system_packages}" ] && no_system_packages
        fi

        ;;
    Darwin*) os_type="macOS";;
    *)
        os_type="Other"

        [ -z "${skip_system_packages}" ] && no_system_packages

        ;;
esac

###############################################################################
# Install packages using your OS' package manager
###############################################################################

function apt_install_packages {
    # shellcheck disable=SC2086
    sudo apt-get update && sudo apt-get install -y ${apt_packages} ${apt_packages_optional}
}



function display_packages {
    if [ "${os_type}" == "Linux" ]; then
        echo "${apt_packages} ${apt_packages_optional}"
    else
        echo "${brew_packages} ${brew_packages_optional}"
    fi
}

if [ -z "${skip_system_packages}" ]; then
cat << EOF
If you choose yes, all of the system packages below will be installed:
$(display_packages)
If you choose no, the above packages will not be installed and this script
will exit. This gives you a chance to edit the list of packages if you don't
agree with any of the decisions.
The packages listed after zsh are technically optional but are quite useful.
Keep in mind if you don't install pwgen you won't be able to generate random
passwords using a custom alias that's included in these dotfiles.
EOF
    while true; do
        read -rp "Do you want to install the above packages? (y/n) " yn
        case "${yn}" in
            [Yy]*)
                if [ "${os_type}" == "Linux" ]; then
                    apt_install_packages
                else
                    brew_install_packages
                fi

                break;;
            [Nn]*) exit 0;;
            *) echo "Please answer y or n";;
        esac
    done
else
    echo "System package installation was skipped!"
fi

###############################################################################
# Clone dotfiles
###############################################################################

read -rep $'\nWhere do you want to clone these dotfiles to [~/.config/.dotfiles]? ' clone_path
clone_path="${clone_path:-"${HOME}/.config/.dotfiles"}"

# Ensure path doesn't exist.
while [ -e "${clone_path}" ]; do
    read -rep $'\nPath exists, try again? (y) ' y
    case "${y}" in
        [Yy]*)

            break;;
        *) echo "Please answer y or CTRL+c the script to abort everything";;
    esac
done

echo

# This is used to locally develop the install script.
if [ "${DEBUG}" == "1" ]; then
    cp -R "${PWD}/." "${clone_path}"
else
    git clone https://github.com/ryucode/.dotfiles "${clone_path}"
fi

###############################################################################
# Create initial directories
###############################################################################

mkdir -p  "${HOME}/.config/.tmux"  \


###############################################################################
# Install Plug (Vim plugin manager)
###############################################################################

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

###############################################################################
# Install tpm (tmux plugin manager)
###############################################################################

rm -rf "${HOME}/.tmux/plugins/tpm"
git clone --depth 1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

###############################################################################
# Install fzf (fuzzy finder on the terminal and used by a Vim plugin)
###############################################################################

rm -rf "${HOME}/.local/share/fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.local/share/fzf" \
  && yes | "${HOME}/.local/share/fzf/install" --bin --no-update-rc

###############################################################################
# Carefully create symlinks
###############################################################################

cat << EOF
-------------------------------------------------------------------------------
ln -fs "${clone_path}/zsh/.zshrc" "${HOME}/.zsh/.zshrc"
ln -fs "${clone_path}/zsh/.aliases" "${HOME}/.zsh.aliases"
ln -fs "${clone_path}/tmux/.tmux.conf" "${HOME}/.tmux/.tmux.conf"
ln -fs "${clone_path}/nvim" "${HOME}/.config/"




-------------------------------------------------------------------------------

EOF

while true; do
  read -rep $'\nReady to continue and apply the symlinks? (y) ' y
  case "${y}" in
      [Yy]*)

          break;;
      *) echo "Please answer y or CTRL+c the script to abort everything";;
  esac
done

ln -fs "${clone_path}/zsh/.zshrc" "${HOME}/.zshrc" \
    && ln -fs "${clone_path}/zsh/.aliases" "${HOME}/.aliases" \
    && ln -fs "${clone_path}/.tmux/.tmux.conf" "${HOME}/.tmux/.tmux.conf" \
    && ln -fs "${clone_path}/nvim/" "${HOME}/.config/" \



###############################################################################
# Install Vim plugins
############################################################################

printf "\n\nInstalling Vim plugins...\n"

nvim -E +PlugInstall +qall || true



###############################################################################
# Install asdf and Node (Node is used for 1 Vim plugin)
###############################################################################

printf "\n\nInstalling asdf %s...\n" "${install_asdf_version}"

rm -rf "${HOME}/.local/share/asdf"
git clone --depth 1 https://github.com/asdf-vm/asdf.git --branch "${install_asdf_version}" \
  "${HOME}/.local/share/asdf"

# shellcheck disable=SC1090
. "${HOME}/.local/share/asdf/asdf.sh"

printf "\n\nInstalling node %s...\n" "${install_node_version}"

"${HOME}/.local/share/asdf/bin/asdf" plugin add nodejs || true
"${HOME}/.local/share/asdf/bin/asdf" install nodejs "${install_node_version}"
"${HOME}/.local/share/asdf/bin/asdf" global nodejs "${install_node_version}"

npm install --unsafe-perm=true --allow-root --global yarn

###############################################################################
# Install tmux plugins
###############################################################################

printf "\n\nInstalling tmux plugins...\n"

export TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins"
"${HOME}/.tmux/plugins/tpm/bin/install_plugins"



##########################################################################
###############################################################################
# Change default shell to zsh
###############################################################################

[ "${os_type}" != "macOS" ] &&  chsh -s "$(command -v zsh)"
. "${HOME}/.zshrc"


###############################################################################
# Done!
###############################################################################

cat << EOF
Everything was installed successfully!
Check out the README file on GitHub to do 1 quick thing manually:
https://github.com/nickjj/dotfiles did-you-install-everything-successfully
You can safely close this terminal.
The next time you open your terminal zsh will be ready to go!

EOF

exit 0
