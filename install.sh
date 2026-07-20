#!/data/data/com.termux/files/usr/bin/bash

create_folders() {
    mkdir -p "$HOME/.cache"
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/.local/state"
}

request_storage_permission() {
    echo "==================================================="
    echo "Requesting storage permission."
    echo "==================================================="
    termux-setup-storage
    echo "==================================================="
    echo "Requested storage permission."
}

update_upgrade_packages() {
    echo "==================================================="
    echo "Updating and upgrading packages."
    echo "==================================================="
    apt update -y && apt upgrade -y
    echo "==================================================="
    echo "Updated and upgraded packages."
}

install_apt_packages() {
    echo "==================================================="
    echo "Installing apt packages."
    echo "==================================================="
    while IFS= read -r package || [ -n "$package" ]; do
        [ -z "$package" ] && continue
        if ! dpkg -s "$package" &>/dev/null; then
            ((attempted_packages++))
            if apt install -y "$package"; then
                ((installed_packages++))
            else
                no_install_apt_packages+=("$package")
            fi
        fi
    done <"install/apt.txt"
    echo "==================================================="
    echo "Finished installing apt packages."
    echo "$installed_packages/$attempted_packages installed."
}

install_uv_packages() {
    echo "==================================================="
    echo "Installing uv packages."
    echo "==================================================="
    # Note: Command below gives installed uv packages.
    # uv tool list --show-extras |
    #   command grep -E '^[a-z]' |
    #   command sed -E 's/ v[^ ]+//; s/ \[extras: ([^]]+)\]/[\1]/; s/, +/,/g'
    while IFS= read -r package || [ -n "$package" ]; do
        [ -z "$package" ] && continue
        ((attempted_packages++))
        if uv tool install "$package"; then
            ((installed_packages++))
        else
            no_install_uv_packages+=("$package")
        fi
    done <"install/uv.txt"
    echo "==================================================="
    echo "Finished installing uv packages."
    echo "$installed_packages/$attempted_packages installed."
}

clear_apt_cache() {
    echo "==================================================="
    echo "Clearing apt cache."
    echo "==================================================="
    apt clean
    apt autoclean
    echo "==================================================="
    echo "Cleared apt cache."
}

removing_unnecessary_dependencies() {
    echo "==================================================="
    echo "Removing unnecessary dependencies."
    echo "==================================================="
    apt autoremove -y
    echo "==================================================="
    echo "Removed unnecessary dependencies."
}

create_symlinks() {
    echo "==================================================="
    echo "Creating symlinks."

    # ~ #
    for item in "$(pwd)/home/".*; do
        item_name="$(basename "$item")"
        [ "$item_name" = "." ] && continue
        [ "$item_name" = ".." ] && continue
        [ "$item_name" = ".config" ] && continue
        ln -sfnv "$item" "$HOME/$item_name"
    done

    # config #
    for item in "$(pwd)/home/.config/"*; do
        item_name="$(basename "$item")"
        [ "$item_name" = "termux" ] && continue
        ln -sfnv "$item" "$HOME/.config/$item_name"
    done
    mkdir -p "$HOME/.config/termux"
    ln -sfnv "$(pwd)/home/.config/termux/"* "$HOME/.config/termux"
    # # # # # #

    echo "==================================================="
    echo "Created symlinks."
}

no_install_array() {
    declare -a no_install_apt_packages=()
    declare -a no_install_uv_packages=()
}

reset_package_count() {
    declare -gi installed_packages=0
    declare -gi attempted_packages=0
}

no_install_packages_to_txt() {
    mkdir -p no_install
    printf "%s\n" "${no_install_apt_packages[@]}" >no_install/apt.txt
    printf "%s\n" "${no_install_uv_packages[@]}" >no_install/uv.txt
    echo "==================================================="
    echo "Script has finished running. Packages that couldn't be installed were written into text files in the no_install folder."
    echo "==================================================="
}

if [[ $# -gt 0 ]]; then
    "$@"
    exit
fi

request_storage_permission

create_folders

no_install_array

reset_package_count

update_upgrade_packages

install_apt_packages

clear_apt_cache

removing_unnecessary_dependencies

create_symlinks

reset_package_count

install_uv_packages

no_install_packages_to_txt
