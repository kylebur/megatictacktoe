import os
import json
import subprocess

def generate_all_assets():
    square_src = "/Users/kyle/.gemini/antigravity/brain/adbbaa91-2ff6-4b9d-b5e2-54e0c11ccccc/clean_app_icon_1788281538488.jpg"
    wide_src = "/Users/kyle/.gemini/antigravity/brain/adbbaa91-2ff6-4b9d-b5e2-54e0c11ccccc/clean_imessage_banner_1788281554194.jpg"

    # Exact Apple Xcode iMessage Template Schema
    specs = [
        # Settings / Small
        {"idiom": "iphone", "size": "29x29", "scale": "2x", "w": 58, "h": 58, "filename": "icon_58x58.png"},
        {"idiom": "iphone", "size": "29x29", "scale": "3x", "w": 87, "h": 87, "filename": "icon_87x87.png"},
        {"idiom": "ipad", "size": "29x29", "scale": "2x", "w": 58, "h": 58, "filename": "icon_58x58_ipad.png"},
        # iPhone Messages Drawer
        {"idiom": "iphone", "size": "60x45", "scale": "2x", "w": 120, "h": 90, "filename": "icon_120x90.png"},
        {"idiom": "iphone", "size": "60x45", "scale": "3x", "w": 180, "h": 135, "filename": "icon_180x135.png"},
        # iPad Messages Drawer
        {"idiom": "ipad", "size": "67x50", "scale": "2x", "w": 134, "h": 100, "filename": "icon_134x100.png"},
        {"idiom": "ipad", "size": "74x55", "scale": "2x", "w": 148, "h": 110, "filename": "icon_148x110.png"},
        # Transcript Universal
        {"size": "27x20", "idiom": "universal", "scale": "2x", "platform": "ios", "w": 54, "h": 40, "filename": "icon_54x40.png"},
        {"size": "27x20", "idiom": "universal", "scale": "3x", "platform": "ios", "w": 81, "h": 60, "filename": "icon_81x60.png"},
        {"size": "32x24", "idiom": "universal", "scale": "2x", "platform": "ios", "w": 64, "h": 48, "filename": "icon_64x48.png"},
        {"size": "32x24", "idiom": "universal", "scale": "3x", "platform": "ios", "w": 96, "h": 72, "filename": "icon_96x72.png"},
        # Marketing Universal
        {"size": "1024x768", "idiom": "ios-marketing", "scale": "1x", "platform": "ios", "w": 1024, "h": 768, "filename": "icon_1024x768.png"}
    ]

    targets = ["MegaTicTacToe", "MegaTicTacToeMessagesExtension"]

    for target in targets:
        stickers_dir = os.path.join(target, "Assets.xcassets", "iMessage App Icon.stickersiconset")
        os.makedirs(stickers_dir, exist_ok=True)

        images_json = []
        for s in specs:
            out_file = os.path.join(stickers_dir, s["filename"])
            cmd = f'sips -z {s["h"]} {s["w"]} -s format png "{wide_src}" --out "{out_file}"'
            subprocess.run(cmd, shell=True, check=True)

            entry = {}
            if "idiom" in s: entry["idiom"] = s["idiom"]
            if "size" in s: entry["size"] = s["size"]
            if "scale" in s: entry["scale"] = s["scale"]
            if "platform" in s: entry["platform"] = s["platform"]
            entry["filename"] = s["filename"]
            images_json.append(entry)

        with open(os.path.join(stickers_dir, "Contents.json"), "w") as f:
            json.dump({"images": images_json, "info": {"author": "xcode", "version": 1}}, f, indent=2)

        # Standard AppIcon
        appicon_dir = os.path.join(target, "Assets.xcassets", "AppIcon.appiconset")
        os.makedirs(appicon_dir, exist_ok=True)
        out_app = os.path.join(appicon_dir, "icon_1024.png")
        cmd_app = f'sips -z 1024 1024 -s format png "{square_src}" --out "{out_app}"'
        subprocess.run(cmd_app, shell=True, check=True)

        with open(os.path.join(appicon_dir, "Contents.json"), "w") as f:
            json.dump({
                "images": [{
                    "filename": "icon_1024.png",
                    "idiom": "universal",
                    "platform": "ios",
                    "size": "1024x1024"
                }],
                "info": {"author": "xcode", "version": 1}
            }, f, indent=2)

        with open(os.path.join(target, "Assets.xcassets", "Contents.json"), "w") as f:
            json.dump({"info": {"author": "xcode", "version": 1}}, f, indent=2)

    print("Successfully generated official Apple template asset catalogs!")

if __name__ == "__main__":
    generate_all_assets()
