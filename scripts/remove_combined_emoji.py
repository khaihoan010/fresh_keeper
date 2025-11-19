#!/usr/bin/env python3
"""
Script to remove combined emoji decorations from premium icons
Converts '💎🍓💎' to '🍓', '✨🥑✨' to '🥑', etc.
"""
import re

def extract_base_emoji(emoji_str):
    """Extract the base emoji from combined decorations"""
    # Decoration characters to remove
    decorations = ['💎', '⭐', '👑', '✨', '🌟', '💫', '🔥', '🎁', '🌈']

    # Remove all decoration characters
    result = emoji_str
    for dec in decorations:
        result = result.replace(dec, '')

    # If result is empty or only has decorations, try to find the middle character
    if not result.strip():
        # Try to find the middle character from original string
        chars = [c for c in emoji_str if c not in decorations]
        if chars:
            return chars[0]
        return emoji_str  # Fallback to original

    return result.strip()

def process_file():
    file_path = '/home/user/fresh_keeper/lib/config/product_icons.dart'

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Pattern to match emoji field: emoji: 'xxx',
    pattern = r"(emoji: ')([^']+)(')"

    def replace_emoji(match):
        prefix = match.group(1)
        emoji = match.group(2)
        suffix = match.group(3)

        # Check if this emoji has decorations
        has_decoration = any(dec in emoji for dec in ['💎', '⭐', '👑', '✨', '🌟', '💫', '🔥', '🎁', '🌈'])

        if has_decoration and len(emoji) > 1:
            # Extract base emoji
            base_emoji = extract_base_emoji(emoji)
            print(f"Replacing: '{emoji}' → '{base_emoji}'")
            return f"{prefix}{base_emoji}{suffix}"

        return match.group(0)  # No change

    # Replace all emoji patterns
    new_content = re.sub(pattern, replace_emoji, content)

    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

    print("\n✅ Removed combined emoji decorations!")

if __name__ == '__main__':
    process_file()
