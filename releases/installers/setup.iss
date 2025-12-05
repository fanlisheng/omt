; 脚本名称: setup.iss
; 作用: 将 Flutter 构建产物打包成 Windows 安装程序

; ================= 配置区域 =================
; ⚠️ 请确保这里的 AppExeName 和你 pubspec.yaml 里的 name 编译出来的 exe 名字一致
#define MyAppExeName "omt.exe"
#define MyAppName "OMT Client"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "KayoXu"
#define MyAppURL "https://github.com/KayoXu/omt"

[Setup]
; ================= 全局设置 =================
; ⚠️ AppId 是识别应用的唯一 ID。不要与其他应用重复。
; 你可以在 Inno Setup 编辑器里点击 "Tools" -> "Generate GUID" 生成一个新的
AppId={{A1B2C3D4-E5F6-7890-1234-567890ABCDAA}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; 默认安装路径: C:\Program Files\OMT Client
DefaultDirName={autopf}\{#MyAppName}
; 开始菜单文件夹名称
DefaultGroupName={#MyAppName}

; === 输出设置 (配合 GitHub Actions) ===
; 编译后的 setup.exe 放在哪里？(相对于本文件的路径)
; 这里指向 build/windows/installer，方便 CI 上传
OutputDir=..\build\windows\installer
; 安装包文件名
OutputBaseFilename=OMT_Setup
; 压缩算法
Compression=lzma
SolidCompression=yes
; 现代安装向导风格
WizardStyle=modern

; 请求管理员权限 (安装到 Program Files 通常需要)
PrivilegesRequired=admin

[Languages]
; 语言设置，这里包含中文
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
; 允许用户勾选“创建桌面快捷方式”
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; ================= 文件打包逻辑 =================
; 注意: Source 路径是相对于 setup.iss 文件的
; ..\ 代表回退到项目根目录

; 1. 主程序 EXE
Source: "..\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; 2. 必要的 DLL (Flutter 引擎, WinSparkle 等)
; ⚠️ WinSparkle.dll 必须包含在内，否则无法自动更新
Source: "..\build\windows\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion

; 3. 数据文件夹 (字体, 图片资源等)
; 递归包含 data 下的所有子文件夹
Source: "..\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; 创建开始菜单快捷方式
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
; 创建桌面快捷方式
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; 安装完成后允许立即运行
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent