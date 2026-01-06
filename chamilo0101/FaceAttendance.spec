# -*- mode: python ; coding: utf-8 -*-
# PyInstaller spec file for Face Recognition Attendance System

import sys
import os
from PyInstaller.utils.hooks import collect_data_files, collect_submodules

block_cipher = None

# Collect all necessary data files
datas = [
    ('Logo', 'Logo'),
    ('known_faces', 'known_faces'),
    ('attendance_records', 'attendance_records'),
]

# Collect mediapipe data files (models)
datas += collect_data_files('mediapipe')

# Hidden imports for all dependencies
hiddenimports = [
    'face_recognition',
    'face_recognition_models',
    'dlib',
    'mediapipe',
    'cv2',
    'numpy',
    'pandas',
    'openpyxl',
    'PySide6',
    'PySide6.QtCore',
    'PySide6.QtGui', 
    'PySide6.QtWidgets',
    'json',
    'threading',
    'collections',
]

# Add mediapipe submodules
hiddenimports += collect_submodules('mediapipe')

# Determine icon based on platform
if sys.platform == 'win32':
    icon_file = 'Logo/icon.ico' if os.path.exists('Logo/icon.ico') else None
elif sys.platform == 'darwin':
    icon_file = 'Logo/icon.icns' if os.path.exists('Logo/icon.icns') else 'Logo/logo1.png'
else:
    icon_file = 'Logo/logo1.png'

a = Analysis(
    ['app_main.py'],
    pathex=[],
    binaries=[],
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'tkinter',
        'matplotlib',
        'scipy',
        'PIL.ImageTk',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='FaceAttendance',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=icon_file,
)

# For macOS, create .app bundle
if sys.platform == 'darwin':
    app = BUNDLE(
        exe,
        name='FaceAttendance.app',
        icon='Logo/icon.icns' if os.path.exists('Logo/icon.icns') else 'Logo/logo1.png',
        bundle_identifier='com.faceattendance.app',
        info_plist={
            'NSCameraUsageDescription': 'This app needs camera access for face recognition.',
            'NSHighResolutionCapable': 'True',
            'CFBundleShortVersionString': '1.0.0',
            'CFBundleVersion': '1.0.0',
            'NSRequiresAquaSystemAppearance': 'False',
        },
    )
