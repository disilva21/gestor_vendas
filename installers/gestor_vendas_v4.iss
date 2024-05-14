; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Gestor de Vendas"
#define MyAppVersion "1.6"
#define MyAppPublisher "EBEL Tecnologia"
#define MyAppURL "https://www.example.com/"
#define MyAppExeName "gestor_vendas.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".myp"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{21442E12-9A47-4A25-ADDC-44E641EAD4EC}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
ChangesAssociations=yes
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Projetos\gestor_vendas\installers
OutputBaseFilename=gestor_vendas
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\file_selector_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\firebase_auth_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\firebase_core_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\flutter_localization_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\flutter_pos_printer_platform_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\geolocator_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\gestor_vendas.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\network_info_plus_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\objectbox.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\objectbox_flutter_libs_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\screen_retriever_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\window_manager_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projetos\gestor_vendas\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

