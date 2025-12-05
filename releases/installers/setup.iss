; 脚本名称: setup.iss
; 作用: 将 Flutter 构建产物打包成 Windows 安装程序

; ================= 配置区域 =================
; ⚠️ 确保这里名字正确 (通常是 pubspec.yaml 中的 name 字段)
#define MyAppExeName "omt.exe"
#define MyAppName "OMT Client"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "KayoXu"
#define MyAppURL "https://github.com/KayoXu/omt"

[Setup]
; ================= 全局设置 =================
; ⚠️ AppId 是唯一标识。我已经为你生成了一个新的 GUID，避免冲突。
AppId={{D865F102-4A73-4C92-8079-567890ABCDEF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; 默认安装路径
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}

; === 输出设置 ===
; 结果输出到 build/windows/installer
OutputDir=..\build\windows\installer
OutputBaseFilename=OMT_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

; === 关键：自动更新优化 ===
; 安装前如果检测到应用正在运行，自动尝试关闭它 (避免文件占用报错)
CloseApplications=yes
; 如果需要重启，允许静默重启
RestartApplications=no
; 请求管理员权限
PrivilegesRequired=admin

[Languages]
; 🔴 修复点：直接引用当前目录下的文件，不要加 compiler: 前缀
; (前提是你在 build-windows.yml 里已经下载了这个文件到 installers 目录)
Name: "chinesesimplified"; MessagesFile: "ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; ================= 文件打包逻辑 =================
; Source 路径相对于 setup.iss (在 installers 目录下)

; 1. 主程序 EXE
Source: "..\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; 2. 关键 DLL (包含 Flutter 引擎和 WinSparkle)
Source: "..\build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion

; 3. 数据文件夹
Source: "..\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; 安装完成后运行
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent