import os
import subprocess
import urllib.request

# Define the variables
QT_INSTALLER_URL = "https://download.qt.io/official_releases/online_installers/qt-unified-windows-x64-online.exe"
QT_INSTALLER_NAME = "qt-unified-windows-x64-online.exe"
INSTALL_DIR = "C:\\Qt"
QT_VERSION = "6.7.2"
QT_COMPONENT = "qt.qt6.672.win64_msvc2019_64"
SCRIPT_PATH = os.path.join(os.getenv('TEMP'), "qt_install_script.qs")

# Function to download the Qt installer
def download_qt_installer():
    print("Downloading Qt Online Installer...")
    try:
        urllib.request.urlretrieve(QT_INSTALLER_URL, QT_INSTALLER_NAME)
        print("Download completed successfully.")
    except Exception as e:
        print(f"Failed to download the Qt Online Installer: {e}")
        exit(1)

# Function to create the silent installation script
def create_install_script():
    print("Creating the silent installation script...")
    script_content = f"""
function Controller() {{
    installer.autoAcceptLicense = true;
    installer.setInstallationDirectory("{INSTALL_DIR}");
    installer.addOperation("ComponentSelection", "{QT_COMPONENT}");
    installer.setRunMode(installer.RunModeSilent);
}}
"""
    try:
        with open(SCRIPT_PATH, "w") as script_file:
            script_file.write(script_content)
        print(f"Silent installation script created at {SCRIPT_PATH}")
    except Exception as e:
        print(f"Failed to create the silent installation script: {e}")
        exit(1)

# Function to run the Qt installer silently
def run_qt_installer():
    print("Running the Qt Online Installer silently...")
    installer_command = [QT_INSTALLER_NAME, "--silent", "--platform", "minimal", "--script", SCRIPT_PATH]
    try:
        subprocess.run(installer_command, check=True)
        print(f"Qt {QT_VERSION} installation completed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Qt {QT_VERSION} installation failed: {e}")
        exit(1)

# Function to clean up the installer and script
def cleanup():
    print("Cleaning up...")
    try:
        os.remove(QT_INSTALLER_NAME)
        os.remove(SCRIPT_PATH)
        print("Cleanup completed.")
    except Exception as e:
        print(f"Failed to clean up: {e}")

if __name__ == "__main__":
    # Download the Qt installer
    download_qt_installer()

    # Create the silent installation script
    create_install_script()

    # Run the Qt installer
    run_qt_installer()

    # Cleanup the downloaded files
    cleanup()