import re

COMMON_COLORS = {
    "white": "#FFFFFF",
    "black": "#000000",
    "red": "#FF0000",
    "green": "#008000",
    "blue": "#0000FF",
    "yellow": "#FFFF00",
    "purple": "#800080",
    "gray": "#808080",
    "cyan": "#00FFFF",
    "magenta": "#FF00FF",
    # Add more colors as needed
}

def is_valid_hex_color(hex_color):
    regex = "^#(?:[0-9a-fA-F]{3}){1,2}$"
    return re.match(regex, hex_color)

def get_color_input():
    while True:
        user_input = input("Enter a color (name or hex code, e.g., 'blue' or '#123ABC'): ").lower()
        
        if user_input in COMMON_COLORS:
            hex_color = COMMON_COLORS[user_input]
            print(f"You entered '{user_input}'. The corresponding hex code is {hex_color}.")
        elif is_valid_hex_color(user_input):
            hex_color = user_input
            print(f"The color you entered is: {hex_color}.")
        else:
            print("Invalid color. Please enter a common color name or a valid hex color code.")
            continue
        
        user_confirmed = input("Is this the color you want? (y/n): ").lower()
        if user_confirmed == 'y':
            # Write the selected color to a file
            with open('accepted_color.data.tmp', 'w') as file:
                file.write(hex_color)
            return hex_color
        else:
            print("Let's try again.")

def main():
    selected_color = get_color_input()
    print(f"You have selected the color: {selected_color}")

if __name__ == "__main__":
    main()
