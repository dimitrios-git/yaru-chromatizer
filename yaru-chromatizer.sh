#!/bin/bash
# This script is used to change the color of the Yaru theme and generate a new
# theme with the new color.
#
# Clone the Yaru repository:
echo "Cloning the Yaru repository..."
git clone git@github.com:ubuntu/yaru.git
cd yaru

# Install the dependencies:
echo "Installing the dependencies..."
./bootstrap.sh --development

# Prepare the environment:
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

# Clean the environment:
echo "Cleaning the environment..."
mv $HOME/.local/share/themes/Yaru-blue $HOME/.local/share/themes/Yaru-chromatizer
mv $HOME/.local/share/themes/Yaru-blue-dark $HOME/.local/share/themes/Yaru-chromatizer-dark

mv $HOME/.local/share/icons/Yaru-blue $HOME/.local/share/icons/Yaru-chromatizer
mv $HOME/.local/share/icons/Yaru-blue-dark $HOME/.local/share/icons/Yaru-chromatizer-dark

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

mkdir -p $HOME/.local/share/icons/Yaru-chromatizer
mv $HOME/.local/share/icons/Yaru/cursors $HOME/.local/share/icons/Yaru-chromatizer
mv $HOME/.local/share/icons/Yaru/cursor.theme $HOME/.local/share/icons/Yaru-chromatizer
rm -rf $HOME/.local/share/icons/Yaru

sed -i 's/Yaru-blue-dark/Yaru-chromatizer-dark/g' ~/.local/share/themes/Yaru-chromatizer-dark/index.theme 
sed -i 's/Yaru-blue/Yaru-chromatizer/g' ~/.local/share/themes/Yaru-chromatizer/index.theme 
sed -i 's/Yaru-blue-dark/Yaru-chromatizer-dark/g' ~/.local/share/icons/Yaru-chromatizer-dark/index.theme 
sed -i 's/Yaru-blue/Yaru-chromatizer/g' ~/.local/share/icons/Yaru-chromatizer/index.theme 
sed -i 's/Yaru/Yaru-chromatizer/g' ~/.local/share/icons/Yaru-chromatizer/cursor.theme 

# Enable the theme:
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

