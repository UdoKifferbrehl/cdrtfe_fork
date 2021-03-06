{ f_filesystem.pas: Dateisystemfunktionen

  Copyright (c) 2004-2012 Oliver Valencia
  Copyright (c) 2002-2004 Oliver Valencia, Oliver Kutsche

6  letzte �nderung  16.04.2012

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.

  f_filesystem.pas stellt Funktionen zum Dateisystem zur Verf�gung:
    * Dateinamen/CD-Label �berpr�fen
    * Datei-/Ordnergr��e ermitteln
    * Laufwerksliste erstellen
    * Datei im Suchpfad finden
    * Laufwerk auf eingelegtes Medium pr�fen
    * Laufwerk/Volume dismounten
    * Auswahldialoge f�r Ordner
    * Funktionen, um bestimmte Ordner zu finden
    * Infos �ber Laufwerke (Name, Dateisystem, Seriennummer, ...)
    * Zugriff auf Datei pr�fen
    * Dateiversion
    * Ziel einer Verkn�pfung


  exportierte Funktionen/Prozeduren:

    CDLabelIsValid(const VolID: string):Boolean
    ChooseDir(const Caption, StartFolder: string; const OwnerHandle: HWnd): string
    ChooseMultipleFolders(const Caption, Title, ColCaption, OkCaption, CancelCaption: string; const OwnerHandle: HWnd; PathList: TStringList; const StartFolder: string): string
    DismountVolume(Drive: string): Boolean
    DriveEmpty(const Drive: Integer): Boolean
    FileAccess(const Name: string; const OpenMode, ShareMode: Word): Boolean;
    FilenameIsValid(const Name: string):Boolean
    FileSystemIsFAT(const Path: string): Boolean
    FindInSearchPath(const Name: string): string
    GetDirSize(Verzeichnis: string): Longint
    GetDriveList(const DriveType: Cardinal; DriveList: TStringList): Byte
    GetDragQueryFileList(Handle: THandle; List: TStringList; const WmDrpFiles: Boolean)
    GetFileSize(const Filename: string): Longint
    GetFileVersionNumbers(const Filename: string; var V1, V2, V3, V4: Word): Boolean
    GetFileVersionString(const FileName: string): string
    GetFreeSpaceDisk(Drive: string): Int64
    GetLastDirFromPath(Path: string; const Delimiter: Char):string
    GetShellFolder(ID: Integer): string
    GetShellLinkTarget(const LinkName: string): string
    GetVolumeInfo(var VolInfo: TVolumeInfo)
    IsUNCPath(const Path: string): Boolean
    MakeFileNameValid(Name: string): string

}

unit f_filesystem;

{$I directives.inc}

interface

uses Forms, Windows, Classes, SysUtils, ShlObj, ShellAPI, FileCtrl, ActiveX,
     Registry, JclShell;

const {IDs f�r spezielle Ordner}
      CSIDL_DESKTOP              = $0000;
      CSIDL_APPDATA              = $001A; {Application Data, new for NT4}
      CSIDL_LOCAL_APPDATA        = $001C; {user\Local Settings\Application Data}
      CSIDL_COMMON_APPDATA       = $0023; {All Users\Application Data}
      CSIDL_SYSTEM               = $0025;
      CSIDL_WINDOWS              = $0024;

type {Datentype f�r Laufwerksinfos}
     TVolumeInfo = record
       Drive             : string;
       Name              : string;
       FileSystem        : string;
       SerialNum         : Integer;
       MaxComponentLength: Integer;
     end;

     PInt64 = ^Int64;
     function _GetDiskFreeSpaceEx(lpPath: PChar; lpFreeBytesAvailableToCaller,
                                  lpTotalNumberOfBytes,
                                  lpTotalNumberOfFreeBytes: PInt64): BOOL; stdcall;

function CDLabelIsValid(const VolID: string):Boolean;
function ChooseDir(const Caption, StartFolder: string; const OwnerHandle: HWnd): string;
function ChooseMultipleFolders(const Caption, Title, ColCaption, OkCaption, CancelCaption: string; const OwnerHandle: HWnd; PathList: TStringList; const StartFolder: string): string;
function DismountVolume(const Drive: string): Boolean; 
function DriveEmpty(const Drive: Integer): Boolean;
function FileAccess(const Name: string; const OpenMode, ShareMode: Word): Boolean;
function FilenameIsValid(const Name: string): Boolean;
function FileSystemIsFAT(const Path: string): Boolean;
function FindInSearchPath(const Name: string): string;
function GetDirSize(Verzeichnis: string): Longint;
function GetDriveList(const DriveType: Cardinal; DriveList: TStringList): Byte;
function GetFileSize(const FileName: string): Int64;
function GetFileVersionNumbers(const Filename: string; var V1, V2, V3, V4: Word): Boolean;
function GetFileVersionString(const FileName: string): string;
function GetFreeSpaceDisk(Drive: string): Int64;
function GetShellFolder(ID: Integer): string;
function GetShellLinkTarget(const LinkName: string): string;
function GetLastDirFromPath(Path: string; const Delimiter: Char):string;
function IsUNCPath(const Path: string): Boolean;
function MakeFileNameValid(Name: string): string;
procedure GetVolumeInfo(var VolInfo: TVolumeInfo);
procedure GetDragQueryFileList(Handle: THandle; List: TStringList; const WmDrpFiles: Boolean);

implementation

uses {$IFDEF MultipleFolderBrowsing}dlg_folderbrowse, {$ENDIF}
     f_wininfo, f_environment, f_largeint;

function _GetDiskFreeSpaceEx; external kernel32 name 'GetDiskFreeSpaceExA'; 

{ GetFreeSpaceDisk -------------------------------------------------------------

  ermittelt den auf dem Datentr�ger verf�gbaren Speicherplatz in Bytes.        }

function GetFreeSpaceDisk(Drive: string): Int64;
var PFreeCaller,
    PTotal,
    PTotalFree : PInt64;
begin
  if Drive[Length(Drive)] <> '\' then Drive := Drive + '\';
  New(PFreeCaller); 
  New(PTotal); 
  New(PTotalFree);
  if _GetDiskFreeSpaceEx(PChar(Drive), PFreeCaller, PTotal, PTotalFree) then
  begin
    Result := PTotalFree^;
  end else
    Result := 0;
  Dispose(PFreeCaller); 
  Dispose(PTotal); 
  Dispose(PTotalFree);     
end;

{ GetFileSize ------------------------------------------------------------------

  GeFileSize liefert die Gr��e einer Datei in Byte.                            }

function GetFileSize(const Filename: string): Int64;
var SR      : TSearchRec;
    SizeHigh: Integer;
    SizeLow : Integer;
begin
  if FindFirst(Filename, faAnyFile, SR) = 0 then
  begin
    SizeHigh := SR.FindData.nFileSizeHigh;
    SizeLow  := SR.FindData.nFileSizeLow;
    Result := IntToComp(SizeLow, SizeHigh);
    FindClose(SR);
  end else
  begin
    Result := -1;
  end;
end;

{ GetDirSize -------------------------------------------------------------------

  GetDirSize liefert die Gr��e eines Ordners incl. aller Dateien und
  Unterordner.                                                                 }

function GetDirSize(Verzeichnis: string): Longint;
var SR     : TSearchRec;
    Groesse: Longint;
begin
  Groesse := 0;
  if Verzeichnis[length(Verzeichnis)] <> '\' then
  begin
    Verzeichnis := Verzeichnis + '\';
  end;
  if FindFirst(Verzeichnis + '*.*', $3F, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) > 0) and
         (SR.Name <> '.') and
         (SR.Name <> '..') then
      begin
        Groesse:=Groesse + GetDirSize(Verzeichnis + SR.Name);
      end else
      begin
        Groesse:=Groesse + SR.Size;
      end; {
      if (SR.Name <> '.') and (SR.Name <> '..') then
      begin
        VerzListe.Add(Verzeichnis + SR.Name);
      end;  }
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  Result := Groesse;
end;

{ FilenameIsValid --------------------------------------------------------------

  FileNameIsValid pr�ft, ob im Dateinamen unerlaubte Zeichnen vorkommen. Nicht
  erlaubt sind: \ / : * ? " < > ;
  Dies gilt nur f�r Dateinamen auf CDs.                                        }

function FilenameIsValid(const Name: string):Boolean;
begin
  Result := not ((LastDelimiter('\/:*?"<>|;', Name) > 0) or (Name = ''));
end;

{ MakeFileNameValid ------------------------------------------------------------

  entfernt alle ung�ltigen Zeichen aus einem Dateinamen.                       }

function MakeFileNameValid(Name: string): string;
begin
  while not FilenameIsValid(Name) do
    Delete(Name, LastDelimiter('\/:*?"<>|;', Name), 1);
  Result := Name;
end;

{ CDLabelIsValid ---------------------------------------------------------------

  CDLabelIsValid pr�ft, ob die Volume-ID g�ltig ist.                           }

function CDLabelIsValid(const VolID: string):Boolean;
begin
  Result := (Length(VolID) > 0) and (Length(VolID) < 33);
end;

{ GetLastDirFromPath -----------------------------------------------------------

  GetLastDirFromPath ermittelt den letzten Ordners im angegebenen Pfad. Diese
  Funktion sollte nur auf Verzeichnisnamen angewendet werden. Delimiter ist der
  Pfadtrenner (\ oder /).                                                      }

function GetLastDirFromPath(Path: string; const Delimiter: Char):string;
var p: Integer;
begin
  p :=  Pos(Delimiter, Path);
  while p > 0 do
  begin
    Delete(Path, 1, p);
    p := Pos(Delimiter, Path);
  end;
  Result := Path;
end;

{ ChooseDir --------------------------------------------------------------------

  zeigt einen Auswahldialog f�r Verzeichnisse an.                              }

var ChooseDir_StartFolder: string;

function ChooseDirCallBack(Wnd: HWND; uMsg: UINT;
                           lParam, lpData: LPARAM): Integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd, BFFM_SETSELECTION, 1, Integer(@ChooseDir_StartFolder[1]));
  Result := 0;
end;

function ChooseDir(const Caption, StartFolder: string;
                   const OwnerHandle: HWnd): string;
var lpItemID   : PItemIDList;
    Malloc     : IMalloc;
    BrowseInfo : TBrowseInfo;
    DisplayName: array[0..MAX_PATH] of Char;
    TempPath   : array[0..MAX_PATH] of Char;
    NewPath    : string;
begin
  Result := '';
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  ShGetMalloc(Malloc);
  with BrowseInfo do
  begin
    hwndOwner      := OwnerHandle;
    pszDisplayName := @DisplayName;
    lpszTitle      := PChar(Caption);
    ulFlags        := 0;
    if StartFolder <> '' then
    begin
      ChooseDir_StartFolder := StartFolder;
      lpfn := ChooseDirCallBack;
    end;
  end;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    NewPath := TempPath;
    Malloc.Free(lpItemId);
  end;
  if DirectoryExists(NewPath) then Result := NewPath;
end;


{ ChooseMultipleFolders --------------------------------------------------------

  zeigt einen Auswahldialog f�r einen oder mehrere Ordner an.                  }

function ChooseMultipleFolders(const Caption, Title, ColCaption, OkCaption,
                                     CancelCaption: string;
                               const OwnerHandle: HWnd;
                               PathList: TStringList;
                               const StartFolder: string): string;
{$IFDEF MultipleFolderBrowsing}
var FolderBrowser: TFolderBrowser;
begin
  FolderBrowser := TFolderBrowser.Create(nil);
  FolderBrowser.Height        := 365;
  FolderBrowser.Width         := 330;
  FolderBrowser.Caption       := Caption;
  FolderBrowser.Title         := Title;
  FolderBrowser.ColCaption    := ColCaption;
  FolderBrowser.OkCaption     := OkCaption;
  FolderBrowser.CancelCaption := CancelCaption;
  FolderBrowser.Multiselect   := True;
  FolderBrowser.OwnerHandle   := OwnerHandle;
  FolderBrowser.InitialDir    := StartFolder;
  if FolderBrowser.Execute then
  begin
    PathList.Assign(FolderBrowser.PathList);
    Result := FolderBrowser.Path;
  end;
  FolderBrowser.Free;
end;
{$ELSE}
begin
end;
{$ENDIF}

{ FindInSearchPath -------------------------------------------------------------

  FindInSearchPath sucht die Datei Name im Suchpfad. Zur�ckgegeben wird der
  gesamte Pfad, falls die Datei gefunden wurde. Andernfalls ist ein leerer
  String das Ergebnis.                                                         }

function FindInSearchPath(const Name: string): string;
var FileNamePath  : PChar;
    FileName      : PChar;
    r: Integer;
begin
  GetMem(FileNamePath, 1024);

  r := SearchPath(nil, PChar(Name), nil, 1024, FileNamePath, FileName);

  if r <> 0 then
  begin
    Result := string(FileNamePath);
  end else
  begin
    Result := '';
  end;
  FreeMem(FileNamePath);
end;

{ GetDriveList -----------------------------------------------------------------

  GetDriveList liefert eine Liste der Laufwerksbuchstaben, die einem bestimmten
  Laufwerkstyp entsprechen. Auch die Anzahl der gefundenen Laufwerke wird
  zur�ckgegeben. Laufwerkstypen: DRIVE_REMOVABLE, DRIVE_FIXED, DRIVE_REMOTE,
  DRIVE_CDROM, DRIVE_RAMDISK. Format: <drive>:\                                }

function GetDriveList(const DriveType: Cardinal; DriveList: TStringList): Byte;
var Drives     :  array [0..105] of char;
    TempList   : TStringList;
    DriveString: PChar;
    i          : Byte;
begin
  Result := 0;
  TempList := TStringList.Create;
  DriveString := Drives;
  {Alle Laufwerke ermitteln}
  GetLogicalDriveStrings(106, @Drives);
  while DriveString^ <> #0 do
  begin
    TempList.Add(string(DriveString));
    Inc(DriveString, StrLen(DriveString) + 1);
  end;
  {Laufwerke des gesuchten Typs ermitteln}
  for i := 0 to TempList.Count - 1 do
  begin
    if GetDriveType(PChar(TempList[i])) = DriveType then
    begin
      DriveList.Add(TempList[i]);
      Result := Result + 1;
    end;
  end;
  TempList.Free;
end;

{ DriveEmpty -------------------------------------------------------------------

  DriveEmpty gibt True zur�ck, wenn kein Datentr�ger im Laufwerk ist.
  a: -> 1, b: - > 2, ...                                                       }

function DriveEmpty(const Drive: Integer): Boolean;
var ErrorMode: Word;
begin
  {Meldung eines kritischen Systemfehlers vehindern}
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    if DiskSize(Drive) = -1 then
    begin
      Result := True;
    end else
    begin
      Result := False;
    end;
  finally
    {ErrorMode auf den alten Wert setzen}
    SetErrorMode(ErrorMode);
  end;
end;

{ GetShellFolder ---------------------------------------------------------------

  GetShellFolder liefert den der ID entsprechenden Ordnernamen zur�ck.         }

function GetShellFolder(ID: Integer): string;
var S: string;
    ItemIDList: PItemIDList;
    SystemHeap: IMalloc;
begin
  Result := EmptyStr;
  if SHGetSpecialFolderLocation(Application.Handle, ID, ItemIDList)
                                                                  = NOERROR then
  begin
    try
      SetLength(S, MAX_PATH);
      if SHGetPathFromIDList(ItemIDList, PChar(S)) then
      begin
        Result:= Copy(S, 1, Pos(#0, S) - 1);
      end;
    finally
      {Von der Shell reservierten Speicher freigeben}
      if SHGetMalloc(SystemHeap) = NOERROR then
      begin
        SystemHeap.Free(ItemIDList);
      end;
    end;
  end;
end;

{ GetVolumeInfo ----------------------------------------------------------------

  GetVolumeInfo liefert Informationen �ber das Laufwerk VolInfo.Drive.         }

procedure GetVolumeInfo(var VolInfo: TVolumeInfo);
var Root              : string;
    VolumeNameBuffer  : PChar;
    FileSystemBuffer  : PChar;
    VolumeSerialNum,
    MaxComponentLength,
    FileSystemFlags   : DWord;
begin
  {Initialisierungen}
  Root := ExtractFileDrive(VolInfo.Drive) + '\';
  GetMem(VolumeNameBuffer, 256);
  GetMem(FileSystemBuffer, 256);
  {Informationen holen}
  if GetVolumeInformation(PChar(Root), VolumeNameBuffer, 255, @VolumeSerialNum,
                          MaxComponentLength, FileSystemFlags, FileSystemBuffer,
                          255) then
  begin
    VolInfo.Name := StrPas(VolumeNameBuffer);
    VolInfo.FileSystem := StrPas(FileSystemBuffer);
    VolInfo.SerialNum := VolumeSerialNum;
    VolInfo.MaxComponentLength := MaxComponentLength;
  end;
  {Aufr�umen}
  FreeMem(VolumeNameBuffer);
  FreeMem(FileSystemBuffer);
end;

{ FileSystemIsFAT --------------------------------------------------------------

  FileSystemIsFAT liefert True, wenn das Dateisystem von Path FAT oder FAT32
  ist.                                                                         }

function FileSystemIsFAT(const Path: string): Boolean;
var VolInfo: TVolumeInfo;
begin
  VolInfo.Drive := Path;
  GetVolumeInfo(VolInfo);
  Result := (VolInfo.FileSystem = 'FAT') or (VolInfo.FileSystem = 'FAT32');
end;

{ FileAccess -------------------------------------------------------------------

  FileAccess pr�ft, ob bei die Datei Name im angegebenen Modus ge�ffnet werden
  kann.
  OpenMode : fmCreate, fmOpenRead, fmOpenWrite, fmOpenReadWrite
  ShareMode: fmShareCompat, fmShareExclusive, fmShareDenyRead, fmShareDenyWrite,
             fmShareDenyNone
  Resul    : True, wenn Zugriff m�glich
             False, sonst                                                      }

function FileAccess(const Name: string;
                    const OpenMode, ShareMode: Word): Boolean;
var FS: TFileStream;
begin
  FS := nil;
  try
    try
      FS := TFileStream.Create(Name, OpenMode or ShareMode);
      Result := True;
    except
      Result := False;
    end;
  finally
    FS.Free;
  end;
end;

{ IsUNCPath --------------------------------------------------------------------

  True, wenn Path im UNC-Format ist: \\server\path...                          }

function IsUNCPath(const Path: string): Boolean;
begin
  Result := (Pos('\\', Path) = 1) or (Pos('//', Path) = 1);
end;

{ DismountVolume ---------------------------------------------------------------

  Alle Handles zum Volume schlie�en. Dies zwingt Windows, eine gerade ge-
  schriebene CD neu einzulesen, ohne das Laufwerk zu �ffnen. Nur unter Win NT,
  2k, XP oder h�her.                                                           }

function DismountVolume(const Drive: string): Boolean;
const LOCK_TIMEOUT = 3000;
      LOCK_RETRIES = 3;
      {Konstanten f�r Volume Funktionen}
      METHOD_BUFFERED             = 0;
      FILE_ANY_ACCESS             = 0;
      FILE_DEVICE_FILE_SYSTEM     = $00000009;
      FSCTL_LOCK_VOLUME           = (FILE_DEVICE_FILE_SYSTEM shl 16) or
                                    (FILE_ANY_ACCESS shl 14) or (6 shl 2) or
                                    METHOD_BUFFERED;
      FSCTL_UNLOCK_VOLUME         = ((FILE_DEVICE_FILE_SYSTEM shl 16) or
                                     (FILE_ANY_ACCESS shl 14) or (7 shl 2) or
                                      METHOD_BUFFERED);
      FSCTL_DISMOUNT_VOLUME       = ((FILE_DEVICE_FILE_SYSTEM shl 16) or
                                     (FILE_ANY_ACCESS shl 14) or (8 shl 2) or
                                      METHOD_BUFFERED);
var iWaitTimeout  : Integer;
    iTryCount     : Integer;
    bLocked       : Boolean;
    sVolumeName   : string;
    sDrive        : string;
    bIOResult     : Boolean;
    cBytesReturned: Cardinal;
    hVolumeHandle : THandle;

begin
  sDrive := Copy(Drive, 1, 2);
  bLocked := False;
  iWaitTimeout := LOCK_TIMEOUT div LOCK_RETRIES;
  sVolumeName := '\\.\' + sDrive;
  {Laufwerks-Handle erzeugen}
  hVolumeHandle := CreateFile(PChar(sVolumeName), GENERIC_READ or GENERIC_WRITE,
                              FILE_SHARE_READ or FILE_SHARE_WRITE,
                              nil, OPEN_EXISTING, 0, 0);
  if hVolumeHandle = INVALID_HANDLE_VALUE then
  begin
    Result := False;
    CloseHandle(hVolumeHandle);
    Exit;
  end;
  {alle Handles schlie�en}
  for iTryCount := 0 to LOCK_RETRIES do
  begin
    bIOResult := DeviceIoControl(hVolumeHandle, FSCTL_DISMOUNT_VOLUME,
                                 nil, 0, nil, 0, cBytesReturned, nil);
    if bIOResult then
    begin
     bLocked := true;
     Break;
    end;
    Sleep(iWaitTimeout);
  end;
  {Volume-Handle freigeben}
  CloseHandle(hVolumeHandle);
  Sleep(LOCK_TIMEOUT);
  Result := bLocked;
end;

{ GetFileVersionNumbers --------------------------------------------------------

  GetFileVersionNumbers liefert die Versionsinformationen einer Datei als
  einzelne Zahlen.                                                             }

function GetFileVersionNumbers(const Filename: string;
                               var V1, V2, V3, V4: Word): Boolean;
var VerInfoSize : Integer;
    VerValueSize: DWord;
    Dummy       : DWord;
    VerInfo     : Pointer;
    VerValue    : PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(Filename), Dummy);
  Result := False;
  if VerInfoSize <> 0 then
  begin
    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(Filename), 0, VerInfoSize, VerInfo) then
      begin
        if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
          with VerValue^ do
          begin
            V1 := dwFileVersionMS shr 16;
            V2 := dwFileVersionMS and $FFFF;
            V3 := dwFileVersionLS shr 16;
            V4 := dwFileVersionLS and $FFFF;
          end;
        Result := True;
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
end;

{ GetFileVersionString ---------------------------------------------------------

  GetFileVersionString liefert die Versionsnummer einer Datei als String.      }

function GetFileVersionString(const FileName: string): string;
var V1, V2, V3, V4: Word;
begin
  Result := '';
  if GetFileVersionNumbers(FileName, V1, V2, V3, V4) then
    Result := IntToStr(V1) + '.' +
              IntToStr(V2) + '.' +
              IntToStr(V3) + '.' +
              IntToStr(V4);
end;

{ GetDragQueryFileList ---------------------------------------------------------

  liefert die per DragQuereFile �bermittelten Dateinamen in einer Stringliste. }

procedure GetDragQueryFileList(Handle: THandle; List: TStringList;
                               const WmDrpFiles: Boolean);
var i, Anzahl, Size: Integer;
    Dateiname      : PChar;
    Filename       : string;
begin
  Anzahl := DragQueryFile(Handle, $FFFFFFFF, nil, 0);
  for i := 0 to (Anzahl - 1) do
  begin
    Size := DragQueryFile(Handle, i, nil, 0) + 1;
    Dateiname:= StrAlloc(Size);
    DragQueryFile(Handle, i, Dateiname, Size);
    Filename := string(Dateiname);
    List.Add(Filename);
    StrDispose(Dateiname);
  end;
  if WmDrpFiles then DragFinish(Handle);
  List.Sort;
end;

{ GetShellLinkTarget -----------------------------------------------------------

  ermittelt das Ziel einer angegebenen Verkn�fung. Im Fehlerfalle wird ein
  leerer String zur�ckgegeben.                                                 }

function GetShellLinkTarget(const LinkName: string): string;
var ShellLink: TShellLink;
begin
  ShellLink.IdList := nil;
  if ShellLinkResolve(LinkName, ShellLink) = S_OK then
    Result := ShellLink.Target
  else
    Result := '';
  ShellLinkFree(ShellLink);
end;

end.
