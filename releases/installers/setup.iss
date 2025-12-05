; 脚本名称: setup.iss
; 作用: 将 Flutter 构建产物打包成 Windows 安装程序
; ⚠️ 注意：此文件包含中文字符，请务必以 UTF-8 with BOM 编码保存，否则会乱码！

; ================= 配置区域 =================
; ⚠️ 确保这里名字正确 (通常是 pubspec.yaml 中的 name 字段)
#define MyAppExeName "omt.exe"
#define MyAppName "运维配置客户端"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "KayoXu"
#define MyAppURL "https://github.com/KayoXu/omt"

[Setup]
; ================= 全局设置 =================
; ⚠️ AppId 是唯一标识。
AppId={{D865F102-4A73-4C92-8079-567890ABCDEF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; 默认安装路径 (注意补全了 \)
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}

; === 图标设置 ===
; 指向 windows/runner/resources/app_icon.ico
SetupIconFile=..\windows\runner\resources\app_icon.ico

; === 输出设置 ===
; 结果输出到 build/windows/installer
OutputDir=..\build\windows\installer
; ⚠️ 安装包文件名 (中文)
OutputBaseFilename="福立盟运维配置客户端"
Compression=lzma
SolidCompression=yes
WizardStyle=modern

; === 关键：自动更新优化 ===
; 安装前如果检测到应用正在运行，自动尝试关闭它
CloseApplications=yes
; 允许静默重启
RestartApplications=no
; 请求管理员权限
PrivilegesRequired=admin

[Languages]
; 引用下载好的中文语言包 (在 installers 目录下)
Name: "chinesesimplified"; MessagesFile: "ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; ================= 文件打包逻辑 =================
; Source 路径相对于 setup.iss (在 installers 目录下)

; 1. 主程序 EXE (注意包含 x64 和 \)
Source: "..\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; 2. 关键 DLL (注意包含 \)
Source: "..\build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion

; 3. 数据文件夹 (注意包含 \)
Source: "..\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

; === VC++ 运行库 ===
; 引用下载好的运行库安装包
Source: "VC_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
; 注意补全了 \
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; === 安装 VC++ 运行库 ===
; 静默安装运行库 (注意补全了 \)
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /passive /norestart"; StatusMsg: "正在检查并安装运行环境(Visual C++)..."; Flags: waituntilterminated

; 启动主程序 (注意补全了 \)
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
```