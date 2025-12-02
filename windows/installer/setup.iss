; Inno Setup Script for OMT Flutter Windows App
; 静默安装 - 用户双击即可完成安装，无需任何交互

#define MyAppName "OMT"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "OMT Team"
#define MyAppURL "https://github.com/your-repo/omt"
#define MyAppExeName "omt.exe"

[Setup]
; 应用程序信息
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; 安装目录（安装到安装程序所在目录）
DefaultDirName={src}\{#MyAppName}
DefaultGroupName={#MyAppName}

; 禁用所有向导页面（实现静默安装）
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableFinishedPage=yes
DisableWelcomePage=yes

; 不需要管理员权限（因为安装到当前目录）
PrivilegesRequired=lowest

; 输出设置
OutputDir=..\..\build\installer
OutputBaseFilename=OMT-Setup-{#MyAppVersion}
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
Compression=lzma2/max
SolidCompression=yes

; 关闭旧版本（如果正在运行）
CloseApplications=force
RestartApplications=no

; 覆盖安装设置
UsePreviousAppDir=yes
UsePreviousGroup=yes
UsePreviousTasks=yes

; 无界面设置
Uninstallable=yes
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; 复制所有构建产物
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; 开始菜单
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
; 桌面快捷方式（默认创建）
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
; 安装完成后自动启动应用
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
// 强制静默安装模式
function InitializeSetup(): Boolean;
begin
  Result := True;
end;

// 跳过所有向导页面
function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := True;
end;
