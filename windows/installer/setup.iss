; Inno Setup Script for OMT Flutter Windows App
; 静默安装 - 运行时加 /VERYSILENT 参数实现完全静默
; 例如: OMT-Setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART

#define MyAppName "OMT"
#define MyAppVersion "1.4.2"
#define MyAppPublisher "成都福立盟环保大数据有限公司"
#define MyAppExeName "omt.exe"
#define MyAppURL "https://github.com/KayoXu/omt"

[Setup]
; 应用程序信息
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}

; 安装目录（在安装程序同级目录创建 omt 文件夹）
DefaultDirName={src}\omt
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
OutputBaseFilename=omt-install-{#MyAppVersion}
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

; 静默安装相关
; 不显示"This will install..." 确认框
AlwaysShowDirOnReadyPage=no
AlwaysShowGroupOnReadyPage=no

[Languages]
; 使用中文语言包
Name: "chinesesimplified"; MessagesFile: "ChineseSimplified.isl"

[Files]
; 复制所有构建产物
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "vc_redist.x64.exe"
; VC++ 运行时安装包（放到临时目录）
Source: "..\..\build\windows\x64\runner\Release\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: ignoreversion deleteafterinstall

[Icons]
; 开始菜单
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
; 桌面快捷方式（默认创建）
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
; 静默安装 VC++ 运行时（在主程序启动前执行）
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "正在安装 Microsoft Visual C++ 运行时..."; Flags: waituntilterminated runhidden
; 安装完成后自动启动应用（静默模式也会执行）
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent runasoriginaluser

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
