import os
import shutil
import getpass
import subprocess
import importlib.util
import sys
import stat
import platform
import win32com.client

# List of required packages
REQUIRED_PACKAGES = [
    'pywin32',
]

# Function to check and install missing packages
def check_install_packages():
    installed_packages = {pkg.metadata['Name'].lower() for pkg in importlib_metadata.distributions()}
    missing_packages = [pkg for pkg in REQUIRED_PACKAGES if pkg not in installed_packages]

    if missing_packages:
        print(f"The following required packages are missing: {' '.join(missing_packages)}")
        user_input = input("Do you want to proceed with installing the missing packages? (y/n): ").strip().lower()

        if user_input == 'y':
            print("Attempting to install missing packages...")

            if platform.system() == "Windows":
                install_location = subprocess.check_output([sys.executable, "-m", "site", "--user-site"]).decode().strip()
                print(f"Packages will be installed in the user site-packages directory: {install_location} on Windows.")
            else:
                print(f"Unsupported operating system: {platform.system()}. This script only runs on Windows.")
                sys.exit(1)

            try:
                # Install packages using pip
                subprocess.check_call([sys.executable, "-m", "pip", "install", "--upgrade", *missing_packages])
                print("Packages installed successfully.")
            except subprocess.CalledProcessError:
                print("Failed to install required packages. Please install them manually.")
                sys.exit(1)
        else:
            print("Installation aborted by the user. Please install the missing packages manually.")
            sys.exit(1)

check_install_packages()

# Import pywin32 module (win32com.client) after ensuring it's installed
try:
    import win32com.client
except ImportError:
    print("pywin32 is not installed. Please install it to use the shortcut creation feature.")
    sys.exit(1)

def create_shortcut_for_all_users(exe_path, shortcut_name):
    public_desktop = r"C:\Users\Public\Desktop"
    shortcut_path = os.path.join(public_desktop, f'{shortcut_name}.lnk')

    shell = win32com.client.Dispatch("WScript.Shell")
    shortcut = shell.CreateShortcut(shortcut_path)
    shortcut.TargetPath = exe_path
    shortcut.WorkingDirectory = os.path.dirname(exe_path)
    shortcut.IconLocation = exe_path
    shortcut.save()

    print(f"Shortcut created for all users: {shortcut_path}")

def remove_file_forcibly(file_path):
    if os.path.exists(file_path):
        try:
            os.remove(file_path)
        except PermissionError:
            try:
                os.chmod(file_path, stat.S_IWRITE)
                os.remove(file_path)
            except Exception as e:
                print(f"Failed to remove the file after changing permissions. Error: {e}")
        except Exception as e:
            print(f"An error occurred: {e}")

def copy_folder(src, dest):
    try:
        if os.path.exists(dest):
            shutil.rmtree(dest)
        shutil.copytree(src, dest)
        print(f"Copied {src} to {dest}")
    except Exception as e:
        print(f"Error copying {src} to {dest}: {e}")

def main():
    if platform.system() != "Windows":
        print("This script is only intended to run on Windows.")
        sys.exit(1)

    script_dir = os.path.dirname(os.path.abspath(__file__))
    resPath = os.path.join(script_dir, 'QT_PXPOINT_APP_RES')
    geocoderPath = os.path.join(script_dir, 'qt-pxpoint-geocoder')
    shapesubsetPath = os.path.join(script_dir, 'qt-pxpoint-shapetool')

    # Use system-wide directories instead of user-specific directories
    appsDestPath = r'C:\ProgramData\qt-pxpoint-toolsets'
    geocoderDestPath = os.path.join(appsDestPath, 'qt-pxpoint-geocoder')
    shapesubsetDestPath = os.path.join(appsDestPath, 'qt-pxpoint-shapetool')

    # Create directories for all users if they don't exist
    if os.path.exists(appsDestPath):
        shutil.rmtree(appsDestPath)
        print(f"Removed existing directory: {appsDestPath}")

    os.makedirs(appsDestPath)
    print(f"Created directory: {appsDestPath}")

    copy_folder(resPath, os.path.join(appsDestPath, 'QT_PXPOINT_APP_RES'))
    copy_folder(geocoderPath, geocoderDestPath)
    copy_folder(shapesubsetPath, shapesubsetDestPath)

    # Create shortcuts for all users
    geocoder_exe_path = os.path.join(geocoderDestPath, 'qt-pxpoint-geocoder.exe')
    create_shortcut_for_all_users(geocoder_exe_path, 'qt-pxpoint-geocoder')

    shapesubset_exe_path = os.path.join(shapesubsetDestPath, 'qt-pxpoint-shapetool.exe')
    create_shortcut_for_all_users(shapesubset_exe_path, 'qt-pxpoint-shapetool')

if __name__ == "__main__":
    main()
