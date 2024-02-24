#!/bin/bash
# This script is used to change the color of the Yaru theme and generate a new
# theme with the new color.
#

# Install prerequisites:
echo "Installing prerequisites..."
sudo apt-get install -y libgtk-3-dev git meson sassc inkscape xvfb

# Check if the installation was successful
if [ $? -ne 0 ]; then
    echo "Failed to install prerequisites. Aborting script."
    exit 1
fi

# Check if the Ubuntu Yaru theme was previously installed and ask the user to
# confirm the deletion of the previous theme. If the user does not confirm the
# deletion, the script will be aborted.
echo "Checking if the Ubuntu Yaru theme was previously installed..."
if [ -d $HOME/.local/share/themes/Yaru ]; then
	echo "The Ubuntu Yaru theme was previously installed. Do you want to delete it? (y/n)"
	read deleteYaru
	if [ $deleteYaru = "n" ]; then
		echo "The script was aborted."
		exit 1
	fi
fi
rm -rf $HOME/.local/share/themes/Yaru

# Clone the Yaru repository:
echo "Cloning the Yaru repository..."
git clone https://github.com/ubuntu/yaru.git
cd yaru

 Prepare the environment:
echo "Preparing the environment..."
meson "build" --prefix=$HOME/.local

# Change the color of the theme:
echo "Changing the accent color of the theme..."

cd common

cp ../../askForColor.py .
python3 askForColor.py
sed -i "s/#0073E5/$(cat accepted_color.data.tmp)/g" accent-colors.scss.in
rm accepted_color.data.tmp
rm askForColor.py
cd ../

# Render the icons:
echo "Rendering the icons..."
ninja -C "build" render-icons-blue

# Install the theme:
echo "Installing the theme..."
ninja -C "build" install

# Check if the theme was previosly installed and ask the user to confirm the
# deletion of the previous theme. If the user does not confirm the deletion,
# the script will be aborted.
echo "Checking if the theme was previously installed..."
if [ -d $HOME/.local/share/themes/Yaru-chromatizer ]; then
	echo "The theme was previously installed. Do you want to delete it? (y/n)"
	read deleteTheme
	if [ $deleteTheme = "n" ]; then
		echo "The script was aborted."
		exit 1
	fi
fi
rm -rf $HOME/.local/share/themes/Yaru-chromatizer
rm -rf $HOME/.local/share/themes/Yaru-chromatizer-dark

# Check for the icons as well:
echo "Checking if the icons were previously installed..."
if [ -d $HOME/.local/share/icons/Yaru-chromatizer ]; then
	echo "The icons were previously installed. Do you want to delete them? (y/n)"
	read deleteIcons
	if [ $deleteIcons = "n" ]; then
		echo "The script was aborted."
		exit 1
	fi
fi
rm -rf $HOME/.local/share/icons/Yaru-chromatizer
rm -rf $HOME/.local/share/icons/Yaru-chromatizer-dark

# Rename the theme and the icons:
mv $HOME/.local/share/themes/Yaru-blue/ $HOME/.local/share/themes/Yaru-chromatizer/
mv $HOME/.local/share/themes/Yaru-blue-dark/ $HOME/.local/share/themes/Yaru-chromatizer-dark/

mv $HOME/.local/share/icons/Yaru-blue/ $HOME/.local/share/icons/Yaru-chromatizer/

# Remove the other themes and icons:
rm -rf $HOME/.local/share/themes/Yaru-bark
rm -rf $HOME/.local/share/themes/Yaru-bark-dark
rm -rf $HOME/.local/share/themes/Yaru-dark
rm -rf $HOME/.local/share/themes/Yaru-magenta
rm -rf $HOME/.local/share/themes/Yaru-magenta-dark
rm -rf $HOME/.local/share/themes/Yaru-olive
rm -rf $HOME/.local/share/themes/Yaru-olive-dark
rm -rf $HOME/.local/share/themes/Yaru-prussiangreen
rm -rf $HOME/.local/share/themes/Yaru-prussiangreen-dark
rm -rf $HOME/.local/share/themes/Yaru-purple
rm -rf $HOME/.local/share/themes/Yaru-purple-dark
rm -rf $HOME/.local/share/themes/Yaru-red
rm -rf $HOME/.local/share/themes/Yaru-red-dark
rm -rf $HOME/.local/share/themes/Yaru-sage
rm -rf $HOME/.local/share/themes/Yaru-sage-dark
rm -rf $HOME/.local/share/themes/Yaru-viridian
rm -rf $HOME/.local/share/themes/Yaru-viridian-dark

rm -rf $HOME/.local/share/icons/Yaru-bark
rm -rf $HOME/.local/share/icons/Yaru-bark-dark
rm -rf $HOME/.local/share/icons/Yaru-dark
rm -rf $HOME/.local/share/icons/Yaru-magenta
rm -rf $HOME/.local/share/icons/Yaru-magenta-dark
rm -rf $HOME/.local/share/icons/Yaru-olive
rm -rf $HOME/.local/share/icons/Yaru-olive-dark
rm -rf $HOME/.local/share/icons/Yaru-prussiangreen
rm -rf $HOME/.local/share/icons/Yaru-prussiangreen-dark
rm -rf $HOME/.local/share/icons/Yaru-purple
rm -rf $HOME/.local/share/icons/Yaru-purple-dark
rm -rf $HOME/.local/share/icons/Yaru-red
rm -rf $HOME/.local/share/icons/Yaru-red-dark
rm -rf $HOME/.local/share/icons/Yaru-sage
rm -rf $HOME/.local/share/icons/Yaru-sage-dark
rm -rf $HOME/.local/share/icons/Yaru-viridian
rm -rf $HOME/.local/share/icons/Yaru-viridian-dark

rm -rf $HOME/.local/share/themes/Yaru

# Move the cursors to the correct directory:
mkdir -p $HOME/.local/share/icons/Yaru-chromatizer
mv $HOME/.local/share/icons/Yaru/cursors $HOME/.local/share/icons/Yaru-chromatizer
mv $HOME/.local/share/icons/Yaru/cursor.theme $HOME/.local/share/icons/Yaru-chromatizer
rm -rf $HOME/.local/share/icons/Yaru

# Change the theme name in the index.theme file:
sed -i 's/Yaru-blue-dark/Yaru-chromatizer-dark/g' ~/.local/share/themes/Yaru-chromatizer-dark/index.theme
sed -i 's/Yaru-blue/Yaru-chromatizer/g' ~/.local/share/themes/Yaru-chromatizer/index.theme
sed -i 's/Yaru-blue/Yaru-chromatizer/g' ~/.local/share/icons/Yaru-chromatizer/index.theme
sed -i 's/Yaru/Yaru-chromatizer/g' ~/.local/share/icons/Yaru-chromatizer/cursor.theme

# Ask the user if they want to enable the theme:
echo "Do you want to enable the theme? (y/n)"
read enableTheme

if [ $enableTheme = "n" ]; then
	echo "The script was aborted."
	exit 1
fi

echo "Enabling the theme..."
gsettings set org.gnome.desktop.interface icon-theme Yaru-chromatizer
gsettings set org.gnome.desktop.interface cursor-theme Yaru-chromatizer

# Ask the user whether they want dark mode or not:
echo "Do you want to enable dark mode? (y/n)"
read darkMode

if [ $darkMode = "y" ]; then
	gsettings set org.gnome.desktop.interface gtk-theme Yaru-chromatizer-dark
else
	gsettings set org.gnome.desktop.interface gtk-theme Yaru-chromatizer
fi

# Remove the Yaru repository:
echo "Removing the Yaru repository..."
cd ..
rm -rf yaru

