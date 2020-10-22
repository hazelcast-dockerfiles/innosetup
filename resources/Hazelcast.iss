[Files]
Source: {#DistDir}\*; DestDir: {app}; Flags: recursesubdirs; AfterInstall: AddLogPropertiesPath()

[Setup]
AppName={#MyAppName}
AppId={#MyAppId}
AppVerName={#MyAppName} {#MyAppVersion}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=apache-v2-license.txt
OutputBaseFilename={#MyAppName}_setup_{#MyAppVersion}
VersionInfoVersion={#MyAppVersionWin}
VersionInfoCompany=Hazelcast
VersionInfoDescription=Hazelcast In-Memory Data Grid (IMDG)
AppPublisher=Hazelcast
AppSupportURL=https://hazelcast.org/
AppVersion={#MyAppVersion}
OutputDir={#OutputDir}
;WizardStyle=modern
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayIcon={app}\bin\Hazelcast.exe

[Components]
Name: "main"; Description: "Hazelcast Files"; Types: full custom compact; Flags: fixed
Name: "service"; Description: "Windows Service"; Types: full;

[Icons]
Name: "{group}\Hazelcast {#MyAppVersion}"; Filename: "{app}\bin\Hazelcast.exe"
Name: "{group}\Hazelcast Client Demo"; Filename: "{app}\bin\HazelcastClient.exe"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\bin\prunsrv.exe"; Parameters: "install Hazelcast --DisplayName=""Hazelcast In-Memory Data Grid"" --Jvm=""{app}\jre\bin\server\jvm.dll"" --Startup=auto --Classpath=""{app}\lib\*"" --StartMode=jvm --StartClass=com.hazelcast.internal.HazelcastServiceStarter --StartMethod=start --StopMode=jvm --StopClass=com.hazelcast.internal.HazelcastServiceStarter --StopMethod=stop --LogPath=""{app}\logs"" --LogPrefix=service --StdOutput=auto --StdError=auto ++JvmOptions=""-Djava.util.logging.config.file={app}\bin\logging.properties"""; Components: service
Filename: "{app}\bin\prunsrv.exe"; Parameters: "start Hazelcast"; Components: service

[UninstallRun]
Filename: "{app}\bin\prunsrv.exe"; Parameters: "stop Hazelcast"; Components: service
Filename: "{app}\bin\prunsrv.exe"; Parameters: "delete Hazelcast"; Components: service

[UninstallDelete]
Type: filesandordirs; Name: "{app}\logs"

[Code]
const L4JINI='.l4j.ini';

procedure AddLogPropertiesPath();
var
  fileExt: String;
  pathLen: integer;
  len: integer;
begin
  len := length(L4JINI);
  pathLen := length(CurrentFileName);
  if pathLen>len then begin
    fileExt := copy(CurrentFileName,  pathLen-len+1, len);
    if fileExt = L4JINI then begin
      SaveStringToFile(ExpandConstant(CurrentFileName), '' #13#10 '"-Djava.util.logging.config.file=' 
        + ExpandConstant('{app}') + '\bin\logging.properties"' #13#10, True);
    end;
  end;
end;

//********** Check if application is already installed
function MyAppInstalled: Boolean;
begin
  Result := RegKeyExists(HKEY_LOCAL_MACHINE,
        'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppID}_is1');
end;

//********** If app already installed, uninstall it before setup.
function InitializeSetup(): Boolean;
var
  uninstaller: String;
  oldVersion: String;
  ErrorCode: Integer;
begin
  if not MyAppInstalled then begin
    Result := True;
    Exit;
  end;
  RegQueryStringValue(HKEY_LOCAL_MACHINE,
        'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppID}_is1',
        'DisplayName', oldVersion);
  if (MsgBox(oldVersion + ' is already installed, it has to be uninstalled before installation. Continue?',
          mbConfirmation, MB_YESNO) = IDNO) then begin
        Result := False;
        Exit;
  end;

  RegQueryStringValue(HKEY_LOCAL_MACHINE,
        'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppID}_is1',
        'QuietUninstallString', uninstaller);
  Exec('>', uninstaller, '', SW_SHOW, ewWaitUntilTerminated, ErrorCode);
  if (ErrorCode <> 0) then begin
        MsgBox('Failed to uninstall previous version. . Please run {#MyAppName} uninstaller manually from Start menu or Control Panel and then run installer again.',
         mbError, MB_OK );
        Result := False;
        Exit;
  end;

  Result := True;
end;
