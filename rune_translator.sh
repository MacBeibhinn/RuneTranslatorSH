#!/bin/bash
current_version="1.0.0" # Used for checking for updates
# Show zenity dialog to input text
result=$(echo "Hello world..." | zenity --text-info --title="Enter text" --editable)
# Check if "Cancel" is clicked
if [ $? -ne 0 ]; then
    echo "Canceled the translation."
    exit 1
fi

# Function to replace characters
translateToElderFuthark() {
    # Translation for this script was taken from Wikipedia (https://en.wikipedia.org/wiki/Elder_Futhark) and is based on the transliterations shown on that page so translations may not be accurate and some letters may not be translated, adjust to your needs by editing the command below (s/letter/rune/g, semicolon to break between):
    echo "$result" | sed 's/f/ᚠ/g; s/u/ᚢ/g; s/þ/ᚦ/g; s/a/ᚨ/g; s/r/ᚱ/g; s/k/ᚲ/g; s/g/ᚷ/g; s/w/ᚹ/g; s/h/ᚺ/g; s/n/ᚾ/g; s/i/ᛁ/g; s/j/ᛃ/g; s/p/ᛈ/g; s/ï/ᛇ/g; s/z/ᛉ/g; s/s/ᛊ/g; s/t/ᛏ/g; s/b/ᛒ/g; s/e/ᛖ/g; s/m/ᛗ/g; s/l/ᛚ/g; s/ŋ/ᛜ/g; s/d/ᛞ/g; s/o/ᛟ/g; s/ /-/g'
}

# Function to check for updates
check_for_updates() {
    # Get the directory, name, and path of the current script
    script_dir="$(dirname "$(realpath "$0")")"
    script_name="$(basename "$0")"
    script_path="$script_dir/$script_name"
    # URL of the new script and version file to download
    new_script_url="https://raw.githubusercontent.com/MacBeibhinn/RuneTranslatorSH/main/rune_translator.sh"  # Don't change this unless you know what you are doing
    version_url="https://raw.githubusercontent.com/MacBeibhinn/RuneTranslatorSH/main/Version"  # URL for the version file
    # Download the new version from the version file
    new_version=$(curl -s "$version_url")
    # Check if the versions are different
    if [ "$current_version" != "$new_version" ]; then
        notify-send "New version available. Downloading..."
        # Download the new script
        curl -o "$script_path" "$new_script_url"
        # Check if the download was successful
        if [ $? -eq 0 ]; then
            # Set execute permissions on the new script, required for running the file
            chmod +x "$script_path"
            notify-send "Script updated successfully."
        else
            notify-send "Failed to download the new script."
        fi
    else
        notify-send "No updates available. The script is up to date."
    fi
}

# Show a list with rune scripts to translate to, add more options if needed ("Elder Futhark" "Check for updates" "Option 3" "Option 4"..., no break between options)
selected_option=$(zenity --list --title="Select rune script" --column="Translate to..." "Elder Futhark" "Check for updates")
# Handle option selection
if [ $? -eq 0 ]; then
    case $selected_option in
        "Elder Futhark") # Handle the Elder Futhark option
            # Preserve the old result value and replace the current value to set the text to lowercase (rune characters typically don't use uppercases, setting all characters to lowercase is also easier to catch)
            resultOld="$result"
            result=${result,,}
            # Replace the text with the translation
            replace_text=$(translateToElderFuthark $result) # Replace "translateToElderFuthark" with any other function, feel free to copy/paste "translateToElderFuthark()" for adding more options
            # Show zenity dialog with translated text
            echo "---------------------------English---------------------------
$resultOld
-----------------------$selected_option-----------------------
$replace_text" | zenity --text-info --text="${result}" --title="Translation" --editable
            ;;
        "Check for updates") # Check for official updates to the script, will replace the current one so save any changes to a new script file if you don't want to lose anything, scripts generally should have executable permissions so ensure any new files you create have the required permissions set
            check_for_updates
            ;;
        "Option 3") # Replace with name of option
            notify-send "You selected Option 2"
            ;;
        "Option 4") # Replace with name of option
            notify-send "You selected Option 3"
            ;;
        *) # Default
            echo "No valid option selected."
            ;;
    esac
else
    echo "Canceled the translation."
fi
