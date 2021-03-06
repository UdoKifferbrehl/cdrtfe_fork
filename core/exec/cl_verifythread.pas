{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Frontend

  cl_verifyhread.pas: Quell- und Zieldateien vergleichen

  Copyright (c) 2004-2014 Oliver Valencia
  Copyright (c) 2002-2004 Oliver Valencia, Oliver Kutsche

  letzte �nderung  23.12.2014

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.  

  cl_verifythread.pas implementiert das Thread-Objekt, das die gebrannten
  mit den Original-Dateien vergleicht. Der Vergleich erfolgt anhand von
  CRC32-Pr�fsummen oder bitweise (je nach Kompilerdirektive).
  Au�erdem kann in der Pfadliste nach mehrfach vorkommenden, identischen
  Dateien gesucht werden, um diese durch Links zur Ursprungsdatei ersetzen.
  Zudem kann f�r Mode2/Form2-Dateien eine Info-Datei erzeugt werden.
  Da die Zugriffe auf das Memo �ber das TLogWin-Singleton erfolgen, ist die Unit
  cl_logwindow.pas zwingend notwendig.


  TVerificationThread

    Properties   Action
                 AutoExec
                 Drive
                 Reload
                 StatusBar
                 TotalSizte
                 XCDExt
                 XCDKeepExt

    Methoden     Create(List: TStringList; Device: string; Lang: TLang; Suspended: Boolean)

  exportierte Funktionen (ungenutzt, aus cdrtfe 0.9.x)

    StartVerifyDataCD(List: TStringList; var Thread: TVerificationThread; Device: string; Lang: TLang)
    TerminateVerification(Thread: TVerificationThread)

}

unit cl_verifythread;

{$I directives.inc}

interface

uses Windows, SysUtils, Classes, ComCtrls, Forms, FileCtrl,
     cl_lang, f_largeint;

type TVerificationThread = class(TThread)
     private
       FAction      : Byte;
       {Variablen f�r Ausgabe}
       FHandle      : THandle;           // Window-Handle des Formulars mit Memo
       FStatusBar   : TStatusBar;        // f�r Anzeige von Status-Infos
       FLine        : string;            // Zeile, die ausgegeben werden soll
       FPBPos       : Integer;           // Position des PorgressBars
       FPBTotalPos  : Integer;           // Gesamtfortschritt
       {Variablen f�r Vergleiche (Daten-/XCD/Image)}
       FDevice      : string;
       FDrive       : string;
       FAutoExec    : Boolean;           // True, wenn automatisches Brennen
       FReload      : Boolean;           // Reload druchf�hren oder nicht
       FReloadError : Boolean;           // True, wenn Einlesen nicht m�glich
       FXCD         : Boolean;
       FXCDExt      : string;
       FXCDKeepExt  : Boolean;
       FISOImage    : Boolean;
       {Variablen f�r das Aufsp�ren von Duplikaten}
       FDupSize     : Int64;
       {mehrfach verwendete Variablen}
       FLang        : TLang;       
       FVerifyList  : TStringList;
       FTotalSize   : Int64;
       FSizeVerified: Int64;
       procedure CleanUpList(List: TStringList);
       procedure CreateInfoFile;
       procedure CreateInfoFileInit;
       procedure FindDuplicateFiles;
       procedure FindDuplicateFilesInit;
       procedure ReloadMedium;
       procedure Verify(const Drive: string);
       procedure VerifyISOImage(const Drive: string);
       procedure VerifyInit;
       function CompareFiles(const FileName1, FileName2: string): Boolean;
       function CompareForm2Files(const FileName1, FileName2: string): Boolean;
       function CompareISOImageDisc(const ISOFile: string): Boolean;
       function GetFileCRC32(const FileName: string; var CRC32: LongInt): Boolean;
       {$IFNDEF BitwiseVerify}
       function GetForm2FileCRC32(const FileName1, FileName2: string; var CRC32: LongInt): Boolean;
       {$ENDIF}
       function GetDrive: string;
       function MakeForm2FileName(const Name: string): string;
     protected
       procedure Execute; override;
       procedure DAddLine;
       procedure DStatusBarPanel0;
       procedure DStatusBarPanel1;
       procedure DSetProgressBar;
       procedure DReloadError;
       procedure SendTerminationMessage;
     public
       constructor Create(List: TStringList; Device: string; Lang: TLang; Suspended: Boolean);
       property Action: Byte write FAction;
       property TotalSize: Int64 write FTotalSize;
       {Properties f�r Ausgabe}
       property StatusBar: TStatusBar write FStatusBar;
       {Properties f�r Vergleiche}
       property AutoExec: Boolean write FAutoExec;
       property Reload: Boolean write FReload;
       property XCD: Boolean write FXCD;
       property XCDExt: string write FXCDExt;
       property XCDKeepExt: Boolean write FXCDKeepExt;
       property Drive: string write FDrive;
       property ISOImage: Boolean write FISOImage;
       {Properties f�r das Aufsp�ren von Duplikaten}
     end;

procedure StartVerifyDataCD(List: TStringList; var Thread: TVerificationThread; Device: string; Lang: TLang);
procedure TerminateVerification(Thread: TVerificationThread);

implementation

uses {$IFDEF ShowVerifyTime} cl_timecount, {$ENDIF}
     cl_logwindow,
     f_filesystem, f_locations, f_strings, f_crc, f_helper, f_wininfo,
     usermessages, f_dischelper, const_tabsheets, f_window, const_common,
     const_locations;

type TM2F2FileHeader = packed record  // RIFF-Header der Mode2/Form2-Dateien
       RIFF : array[0..3] of char;    // Byte  0 -  3: 'RIFF'
       Size : Integer;                // Byte  4 -  7: Dateigr��e - 8
       CDXA : array[0..3] of char;    // Byte  8 - 11: 'CDXA'
       fmt  : array[0..2] of char;    // Byte 12 - 14: 'fmt'
       FData: array[0..20] of char;   // Byte 15 - 35: FData[9..12] = $15 + 'UXA'
       DATA : array[0..3] of char;    // Byte 36 - 39: 'data'
       DSize: Integer;                // Byte 40 - 43: Gr��e der Datensektion (Vielfaches von 2352)
     end;

     TM2F2Sector = packed record      // Mode2/Form2-Raw-Sektor
       Sync : array[0..11] of char;   // Byte  0 - 11: Synchronisation
       Hdr  : array[0..3] of char;    // Byte 12 - 15: Header: 3 Byte Sektoradresse, 1 Byte Mode
       SHdr : array[0..7] of char;    // Byte 16 - 23: Subheader -> Form1/2
       Data : array[0..2323] of char; // Daten
       EDC  : array[0..3] of char;    // 4 Byte CRC32-Pr�fsumme
     end;

{ TVerificationThread -------------------------------------------------------- }

{ TVerificationThread - private/protected }

{ Methoden f�r den VCL-Zugriff -------------------------------------------------

  Zugriffe auf die VCL m�ssen �ber Synchronize erfolgen. Methoden, die f�r die
  Anzeige von Daten zust�ndig sind beginnen mit 'D'.                           }

procedure TVerificationThread.DAddLine;
begin
  TLogWin.Inst.Add(FLine);
end;

procedure TVerificationThread.DStatusBarPanel0;
var p : Integer;
    ID: string;
begin
  FStatusBar.Panels[0].Text := FLine;
  case FAction of
    cVerify,
    cVerifyXCD,
    cVerifyDVDVideo,
    cVerifyISOImage: ID := 'V';
    cFindDuplicates: ID := 'D';
    cCreateInfoFile: ID := 'X';
  end;
  p := Pos('   ', FLine);
  TLogWin.Inst.ShowProgressTaskBarString(ID + ': ' + Copy(FLine, p + 3,
                                                        Length(FLine) - p + 2));
end;

procedure TVerificationThread.DStatusBarPanel1;
begin
  FStatusBar.Panels[1].Text := FLine;
end;

procedure TVerificationThread.DSetProgressBar;
begin
  TLogWin.Inst.ProgressBarUpdate(1, FPBPos);
  TlogWin.Inst.ProgressBarUpdate(2, FPBTotalPos);
end;

procedure TVerificationThread.DReloadError;
var REText, RECaption: string;
    i: Integer;
begin
  REText := FLang.GMS('everify03');
  RECaption := FLang.GMS('everify04');
  i := ShowMsgDlg(REText, RECaption,
                  MB_OKCANCEL or MB_APPLMODAL or MB_ICONEXCLAMATION or
                  MB_cdrtfeDlgExSnd);
  if i <> 1 then
  begin
    Terminate;
    FReloadError := False;
  end;
end;

procedure TVerificationThread.SendTerminationMessage;
var SizeHigh: Integer;
    SizeLow: Integer;
begin
  TLogWin.Inst.ProgressBarHide(1);
  TLogWin.Inst.ProgressBarHide(2);
  case FAction of
    cFindDuplicates: if Terminated then
                       SendMessage(FHandle, WM_FTerminated, -1, -1) else
                     begin
                       SizeLow := LoComp(FDupSize);
                       SizeHigh := HiComp(FDupSize);
                       SendMessage(FHandle, WM_FTerminated, SizeHigh, SizeLow);
                     end;
    cCreateInfoFile: if Terminated then
                       SendMessage(FHandle, WM_ITerminated, -1, -1) else
                       SendMessage(FHandle, WM_ITerminated, 0, 0);
  else
    SendMessage(FHandle, WM_VTerminated, 0, 0);
  end;
end;

{ CleanUpList ------------------------------------------------------------------

  CleanUpList entfernt aus den Listen die Dummy-Eintr�ge f�r leere Ordner.     }

procedure TVerificationThread.CleanUpList(List: TStringList);
var i: Integer;
begin
  for i := (List.Count - 1) downto 0 do
    if Pos(DummyDirName, List[i]) > 0 then List.Delete(i);
end;

{ ReloadMedium -----------------------------------------------------------------

  Reload durchf�hren, falls FReload = True.                                    }

procedure TVerificationThread.ReloadMedium;
var DismountOk: Boolean;
begin
  FLine := FLang.GMS('mverify04');
  Synchronize(DAddLine);
  DismountOk := False;
  {Unter WinNT und h�her versuchen wir es erst einmal mit Dismount.}
  if (FDrive <> '') and PlatformWinNT then
  begin
    {$IFDEF VerifyShowDetails}
    FLine := 'Dismounting Drive: ' + FDrive;
    Synchronize(DAddLine);
    {$ENDIF}
    DismountOk := DismountVolume(FDrive);
  end;
  {$IFNDEF NoReload}
  if FReload and not DismountOk then
  begin
    {$IFDEF VerifyShowDetails}
    FLine := 'Device: ' + FDevice;
    Synchronize(DAddLine);
    {$ENDIF}
    FLine := '';
    Synchronize(DAddLine);
    FReloadError := ReloadDisk(FDevice);
    {damit die CD sicher erkannt wird, noch eine Sekunde warten}
    Sleep(1000);
  end;
  {$ENDIF}
  {Sollte kein Reload m�glich sein, dann dem User erlauben, ein manuelles Reload
   durchzuf�hren oder den Vergleich abzubrechen. Dies kann bei Notebook-
   Laufwerken auftreten.}
  {$IFDEF ForceReloadError}
  FReloadError := True;
  {$ENDIF}
  if FReloadError then
  begin
    {Wenn der Fehler auftritt, MessageBox anzeigen, es sei denn, es wird auto-
     matisch gebrannt.}
    if not FAutoExec then
    begin
      Synchronize(DReloadError);
    end else
    begin
      FLine := FLang.GMS('everify05');
      Synchronize(DAddLine);
      FLine := '';
      Synchronize(DAddLine);
      Terminate;
    end;
  end;
end;

{ GetDrive ---------------------------------------------------------------------

  Wenn beim Aufruf des Threads eine Laufwerksbezeichnung angegeben wurde, wird
  diese verwendet. Ansonsten sucht GetDrive das Laufwerk, in dem die gerade
  geschriebene CD eingelegt ist, indem die ersten Datei gesucht wird, die in
  BurnList steht.                                                              }

function TVerificationThread.GetDrive: string;
var CDDrives: TStringList;
    i: Integer;
    c: Integer;
    Temp: string;
begin
  {Reload durchf�hren}
  ReloadMedium;
  if FDrive = '' then
  begin
    {CD-Laufwerke suchen, da FDrive leer ist.}
    CDDrives := TStringList.Create;
    {Laufwerke suchen, Format: <lw>:\ }
    GetDriveList(DRIVE_CDROM, CDDrives);
    {Laufwerk mit eingelegter CD suchen}
    for i := CDDrives.Count - 1 downto 0 do
    begin
      {$IFDEF VerifyShowDetails}
      FLine := 'Drive: ' + CDDrives[i];
      Synchronize(DAddLine);
      {$ENDIF}
      {Nummer des Laufwerks bestimmen}
      c := Ord(LowerCase(CDDrives[i])[1]) - 96;
      if DriveEmpty(c) then
      begin
        CDDrives.Delete(i);
      end;
    end;
    {Laufwerk mit den richtigen Daten suchen}
    Temp := Copy(FVerifyList[0], 1, Pos(':', FVerifyList[0]) - 1);
    {Aufpassen, falls es eine Form2-Datei ist.}
    if Pos('>', FVerifyList[0]) > 0 then Temp := MakeForm2FileName(Temp);
    for i := CDDrives.Count - 1 downto 0 do
    begin
      Temp := CDDrives[i] {+ '\'} + Temp;
      Temp := ReplaceChar(Temp, '/', '\');
      if not FileExists(Temp) and not DirectoryExists(Temp) then
      begin
        CDDrives.Delete(i);
      end;
    end;
    if CDDrives.Count > 0 then
    begin
      {CDDrives sollte jetzt nur noch ein Laufwerk enthalten, dort mu� noch der
       Backslash enfernt werden.}
      Temp := CDDrives[0];
      if Temp[Length(Temp)] = '\' then Delete(Temp, Length(Temp), 1);
      Result := Temp;
    end else
    begin
      Result := '';
    end;
    CDDrives.free;
    {$IFDEF VerifyShowDetails}
    FLine := 'Drive: ' + Result;
    Synchronize(DAddLine);
    {$ENDIF}
  end else
  begin
    Temp := FDrive;
    if Temp[Length(Temp)] = '\' then Delete(Temp, Length(Temp), 1);
    Result := Temp;
    {$IFDEF VerifyShowDetails}
    FLine := 'FDrive: ' + Result;
    Synchronize(DAddLine);
    {$ENDIF}
  end;
end;

{ MakeForm2FileName ------------------------------------------------------------

  pa�t den Dateinamen den Einstellungen (KeepExt, Ext) entsprechend an.        }

function TVerificationThread.MakeForm2FileName(const Name: string): string;
var Temp: string;
    p: Integer;
begin
  Temp := Name;
  if FXCDKeepExt then
  begin
    Temp := Temp + '.' + FXCDExt;
  end else
  begin
    if ExtractFileExt(Temp) <> '' then
    begin
      p := LastDelimiter('.', Temp);
      Delete(Temp, p, Length(Temp) - p + 1);
      Temp := Temp + '.' + FXCDExt;
    end else
    begin
      Temp := Temp + '.' + FXCDExt;
    end;
  end;
  Result := Temp;
end;

{ CompareFiles -----------------------------------------------------------------

  CompareFiles f�hrt einen bitweisen Vergleich der angegebenen Dateien durch und
  liefert als R�ckgabewert True, wenn die Dateien identisch sind (gilt auch f�r
  0-Byte-Dateien).                                                             }

function TVerificationThread.CompareFiles(const FileName1, FileName2: string):
                                          Boolean;
var File1, File2  : TFileStream;
    p1, p2        : Pointer;
    FSize1, FSize2: Int64;
    BSize         : Integer;
    NBytes        : Integer; //Number of bytes to read
begin
  File1 := nil;
  File2 := nil;
  Result := True;
  BSize := cBufSize;
  GetMem(p1, BSize);
  GetMem(p2, BSize);
  try
    try
      File1 := TFileStream.Create(FileName1, fmOpenRead or fmShareDenyNone);
      File2 := TFileStream.Create(FileName2, fmOpenRead or fmShareDenyNone);
      FSize1 := GetFileSize(FileName1);
      FSize2 := GetFileSize(FileName2);
      if (FSize1 = FSize2) and (FSize1 > 0) then
      begin
        while (FSize1 <> 0) and Result and not Terminated do
        begin
          if FSize1 > BSize then NBytes := BSize else NBytes := LoComp(FSize1);
          FSize1 := FSize1 - NBytes;
          File1.ReadBuffer(p1^, NBytes);
          File2.ReadBuffer(p2^, NBytes);
          Result := Result and CompareBufferA(p1, p2, NBytes);
          FPBPos := Round(((FSize2 - FSize1) / FSize2) * 100);
          FPBTotalPos := Round((((FSizeVerified + FSize2 - FSize1) / FTotalSize)
                                                                        * 100));
          Synchronize(DSetProgressBar);
        end;
      end else
      begin
        Result := (FSize1 = 0) and (FSize2 = 0);
      end;
      FSizeVerified := FSizeVerified + FSize2;
    except
      Result := False;
    end;
  finally
    File1.Free;
    File2.Free;
    FreeMem(p1, BSize);
    FreeMem(p2, BSize)
  end;
end;

{ CompareForm2Files ------------------------------------------------------------

  CompareForm2Files f�hrt einen bitweisen Vergleich der angegebenen Form2-
  Dateien durch und liefert als R�ckgabewert True, wenn die Dateien identisch
  sind.                                                                        }

function TVerificationThread.CompareForm2Files(const FileName1, FileName2:
                                                               string): Boolean;
var File1, File2  : TFileStream;
    p1            : Pointer;
    HBuffer       : array[0..43] of Char;   // Buffer for Header
    SBuffer       : array[0..2351] of Char; // Buffer for Sector
    FileHeader    : ^TM2F2FileHeader;
    Sector        : ^TM2F2Sector;
    SecCount      : Integer;                // Sectors to read
    FSize1, FSize2: LongInt;
    BSize1, BSize2: Integer;
    NBytes        : Integer;                //Number of bytes to read/compare
begin
  File1 := nil;
  File2 := nil;
  Result := True;
  {Aufgrund des Dateiformates der Mode2/Form2-Dateien ist es einfacher, nicht
   mit cBufSize (2048 Bytes) als Puffergr��e zu arbeiten.}
  BSize1 := 2324;
  BSize2 := SizeOf(SBuffer); // 2352 Bytes
  GetMem(p1, BSize1);
  try
    try
      File1 := TFileStream.Create(FileName1, fmOpenRead or fmShareDenyNone);    // Form1-Datei
      File2 := TFileStream.Create(FileName2, fmOpenRead or fmShareDenyNone);    // Form2-Datei
      FSize1 := File1.Size;
      FSize2 := FSize1;
      if (FSize1 > 0) and (FSize2 > 0) then
      begin
        {44 Byte gro�en Header lesen}
        ZeroMemory(@HBuffer, SizeOf(HBuffer));
        FileHeader := @HBuffer;
        File2.ReadBuffer(HBuffer, 44);
        SecCount := FileHeader^.DSize div 2352;
        ZeroMemory(@SBuffer, SizeOf(SBuffer));
        Sector := @SBuffer;
        while (FSize1 <> 0) and (SecCount > 0) and Result and not Terminated do
        begin
          {aus der Form1-Datei lesen}
          if FSize1 > BSize1 then NBytes := BSize1 else NBytes := FSize1;
          Dec(FSize1, NBytes);
          File1.ReadBuffer(p1^, NBytes);
          {aus der Form2-Datei lesen}
          File2.ReadBuffer(SBuffer, BSize2);
          Dec(SecCount);
          {Vergleichen}
          Result := Result and CompareBufferA(p1, @Sector^.Data, NBytes);
          FPBPos := Round(((FSize2 - FSize1) / FSize2) * 100);
          FPBTotalPos := Round((((FSizeVerified + FSize2 - FSize1) / FTotalSize)
                                                                        * 100));
          Synchronize(DSetProgressBar);
        end;
      end else
      begin
        Result := False;
      end;
      FSizeVerified := FSizeVerified + FSize2;
    except
      Result := False;
    end;
  finally
    File1.Free;
    File2.Free;
    FreeMem(p1, BSize1);
  end;
end;

{ CompareISOImageDisc ----------------------------------------------------------

  CompareISOImageDisc f�hrt einen bitweisen Vergleich des angegebenen ISO-Images
  mit der geschriebenen Disk durch und liefert als R�ckgabewert True, wenn das
  Image mit der Disk �bereinstimmt.                                            }

function TVerificationThread.CompareISOImageDisc(const ISOFile: string): Boolean;
const MaxRetry = 10;
var File1         : TFileStream;
    DriveRoot     : string;
    p1, p2        : Pointer;
    FSize1, FSize2: Int64;
    BSize         : Integer;
    NBytes        : Integer;  //Number of bytes to read
    RBytes        : LongWord; //Number of Bytes read
    CDHandle      : THandle;
    RetryCount    : Integer;
begin
  RetryCount := 0;
  File1 := nil;
  DriveRoot := Copy(FDrive, 1, 2);
  CDHandle := INVALID_HANDLE_VALUE;
  Result := True;
  BSize := cBufSize;
  GetMem(p1, BSize);
  GetMem(p2, BSize);
  try
    try
      File1 := TFileStream.Create(ISOFile, fmOpenRead or fmShareDenyNone);
      FSize1 := GetFileSize(ISOFile);
      FSize2 := FSize1;
      {Handle zur Disc holen, ggf. mehrfach versuchen, bis MaxRetry erreicht}
      repeat
//        FLine := 'Getting disc handle: ' + DriveRoot;
//        Synchronize(DAddLine);
        CDHandle := CreateFile(PChar('\\.\' + DriveRoot), GENERIC_READ, 0, nil,
                               OPEN_EXISTING,
                               FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN,
                               0);
        if CDHandle = INVALID_HANDLE_VALUE then
        begin
          FLine := FLang.GMS('everify07'); //  'Invalid Handle, retrying...';
          Synchronize(DAddLine);
          Inc(RetryCount);
          Sleep(3000);
        end;
      until (CDHandle <> INVALID_HANDLE_VALUE) or (RetryCount > MaxRetry);
      if CDHandle = INVALID_HANDLE_VALUE then
      begin
          FLine := FLang.GMS('everify08'); // 'Invalid Handle';
          Synchronize(DAddLine);
      end;
      if (FSize1 > 0) then
      begin
        while (FSize1 <> 0) and Result and not Terminated do
        begin
          if FSize1 > BSize then NBytes := BSize else NBytes := LoComp(FSize1);
          FSize1 := FSize1 - NBytes;
          File1.ReadBuffer(p1^, NBytes);
          ReadFile(CDHandle, p2^, NBytes, RBytes, nil);

          Result := Result and CompareBufferA(p1, p2, NBytes);
          
          FPBPos := Round(((FSize2 - FSize1) / FSize2) * 100);
          FPBTotalPos := FPBPos;
          Synchronize(DSetProgressBar);
        end;
      end else
      begin
        Result := (FSize1 = 0) and (FSize2 = 0);
      end;
      FSizeVerified := FSizeVerified + FSize2;
    except
      Result := False;
    end;
  finally
    File1.Free;
    if CDHandle <> INVALID_HANDLE_VALUE then CloseHandle(CDHandle);
    FreeMem(p1, BSize);
    FreeMem(p2, BSize)
  end;
end;

{ GetFileCRC32 -----------------------------------------------------------------

  GetFileCRC32 berechnet den CRC32-Wert einer Datei.
    FileName:     Dateiname (mit Pfad)
    CRC32:        CRC32-Wert, beliebiger Startwert m�glich, da innerhalb der
                  Funktion sowieso mit -1 initialisiert
    R�ckgabewert: True, wenn erfolgreich

  GetFileCRC32 wurde in als Methode des Thread-Objektes definiert, damit auch
  w�hrend der CRC-Berechnung der Thread abgebrochen bzw. der Fortschritt bei den
  einzelnen Dateien angezeigt werden kann.                                     }

function TVerificationThread.GetFileCRC32(const FileName: string;
                                          var CRC32: Longint): Boolean;
var FileIn  : TFileStream;
    p       : Pointer;
    FSize   : Longint;
    FSIzeBak: Longint;
    BSize   : Integer;
    NBytes  : Integer; //Number of bytes to read
begin
  FileIn := nil;
  Result := True;
  FSizeBak := 0;
  {Blockgr��e von 2 KiByte erscheint als schnellste Variante}
  BSize := cBufSize;
  GetMem(p, BSize);
  try
    try
      FileIn := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      FSize := FileIn.Size;
      FSizeBak := FSize;
      if FSize > 0 then
      begin
        {Startwert -1 f�r PKZIP-kompatible CRC32-Werte}
        CRC32 := -1;
        while (FSize <> 0) and not Terminated {FTerminate} do
        begin
          if FSize > BSize then NBytes := BSize else NBytes := FSize;
          Dec(FSize, NBytes);
          FileIn.ReadBuffer(p^, NBytes);
          CRC32 := UpdateCRC32A(Crc32, p, NBytes);
          FPBPos := Round(((FSizeBak - FSize) / FSizeBak) * 100);
          FPBTotalPos := Round((((FSizeVerified + FSizeBak - FSize)
                                  / FTotalSize) * 100));
          Synchronize(DSetProgressBar);
        end;
        {f�r PKZIP-Kompatibilit�t mu� Wert noch invertiert werden}
        CRC32 := not CRC32;
      end;
    except
      Result := False;
    end;
    FSizeVerified := FSizeVerified + FSizeBak;
  finally
    FileIn.Free;
    FreeMem(p, BSize);
  end;
end;

{$IFNDEF BitwiseVerify}

{ GetForm2FileCRC32 ------------------------------------------------------------

  GetForm2FileCRC32 berechnet den CRC32-Wert einer Mode2/Form2-Datei. Ansonsten
  gilt das zu GetFileCRC32 gesagte.
  Die Originaldatei wird ben�tigt, um die genaue Dateigr��e zu ermitteln, die
  aus der Form2-Datei nicht zu ermitteln ist.                                  }

function TVerificationThread.GetForm2FileCRC32(const FileName1, FileName2:
                                           string; var CRC32: Longint): Boolean;
var File1, File2: TFileStream;
    HBuffer: array[0..43] of char;   // Buffer for Header
    SBuffer: array[0..2351] of char; // Buffer for Sector
    FileHeader: ^TM2F2FileHeader;
    Sector: ^TM2F2Sector;
    SecCount: Integer;               // Sectors to read
    FSize1, FSize2: LongInt;
    BSize1, BSize2: Integer;
    NBytes: Integer;                 //Number of bytes to read/compare
begin
  File1 := nil;
  File2 := nil;
  Result := True;
  {Aufgrund des Dateiformates der Mode2/Form2-Dateien ist es einfacher, nicht
   mit cBufSize (2048 Bytes) als Puffergr��e zu arbeiten.}
  BSize1 := 2324;
  BSize2 := SizeOf(SBuffer); // 2352 Bytes
  try
    try
      File1 := TFileStream.Create(FileName1, fmOpenRead or fmShareDenyNone);    // Form1-Datei
      File2 := TFileStream.Create(FileName2, fmOpenRead or fmShareDenyNone);    // Form2-Datei
      FSize1 := File1.Size;
      FSize2 := FSize1;
      if (FSize1 > 0) and (FSize2 > 0) then
      begin
        {Startwert -1 f�r PKZIP-kompatible CRC32-Werte}
        CRC32 := -1;
        {44 Byte gro�en Header lesen}
        ZeroMemory(@HBuffer, SizeOf(HBuffer));
        FileHeader := @HBuffer;
        File2.ReadBuffer(HBuffer, 44);
        SecCount := FileHeader^.DSize div 2352;
        ZeroMemory(@SBuffer, SizeOf(SBuffer));
        Sector := @SBuffer;
        while (FSize1 <> 0) and (SecCount > 0) and not Terminated do
        begin
          {simuliert aus der Form1-Datei lesen}
          if FSize1 > BSize1 then NBytes := BSize1 else NBytes := FSize1;
          Dec(FSize1, NBytes);
          {aus der Form2-Datei lesen}
          File2.ReadBuffer(SBuffer, BSize2);
          Dec(SecCount);
          {Vergleichen}
          CRC32 := UpdateCRC32A(Crc32, @Sector^.Data, NBytes);
          FPBPos := Round(((FSize2 - FSize1) / FSize2) * 100);
          Synchronize(DSetProgressBar);
        end;
        {f�r PKZIP-Kompatibilit�t mu� Wert noch invertiert werden}
        CRC32 := not CRC32;        
      end else
      begin
        Result := False;
      end;
    except
      Result := False;
    end;
  finally
    File1.Free;
    File2.Free;
  end;
end;

{$ENDIF}

{ Verify -----------------------------------------------------------------------

  Eigentliche Aufgabe von TVerificationThread: Vergleichen.
  Je nach Kompilerdirektive findet ein bitweiser Vergleich bzw. ein Vergleich
  �ber CRC32-Pr�fsummen statt. Es k�nnen sowohl Daten-CDs als auch XCDs �ber-
  pr�ft werden.                                                                }

procedure TVerificationThread.Verify(const Drive: string);
var i                     : Integer;
    p                     : Integer;
    ErrorCount            : Integer;
    SourceFile, TargetFile: string;
    IsForm2               : Boolean;
    {$IFNDEF BitwiseVerify}
    SourceCRC, TargetCRC  : LongInt;
    {$ELSE}
    Ok                    : Boolean;
    {$ENDIF}
    {$IFDEF ShowVerifyTime}
    TimeCount             : TTimeCount;
    {$ENDIF}
begin
  {$IFDEF ShowVerifyTime}
  TimeCount := TTimeCount.Create; TimeCount.StartTimeCount;
  {$ENDIF}
  i := 0;
  ErrorCount := 0;
  IsForm2 := False;
  repeat
    FLine := FLang.GMS('mverify01') + '   ' + IntToStr(i + 1) + '/' +
             IntToStr(FVerifyList.Count);
    Synchronize(DStatusBarPanel0);

    p := Pos(':', FVerifyList[i]);
    TargetFile := Copy(FVerifyList[i], 1, p - 1);
    TargetFile := Drive + '\' + TargetFile;
    TargetFile := ReplaceChar(TargetFile, '/', '\');
    SourceFile := FVerifyList[i];
    Delete(SourceFile, 1, p);
    
    {Sonderbehandlung f�r Form2-Dateien}
    if FXCD then
    begin
      {Form2-File?}
      IsForm2 := Pos('>', FVerifyList[i]) > 0;
      {Endung anpassen, wenn es eine Form2-Datei ist}
      if IsForm2 then
      begin
        Delete(SourceFile, Length(SourceFile), 1);
        TargetFile := MakeForm2FileName(TargetFile);
      end;
    end;

    {$IFNDEF BitwiseVerify}
    {Vergleich �ber CRC32-Pr�fsummen}
    SourceCRC := 0;
    TargetCRC := 0;
    FLine := SourceFile;
    Synchronize(DStatusBarPanel1);
    GetFileCRC32(SourceFile, SourceCRC);
    FLine := TargetFile;
    Synchronize(DStatusBarPanel1);
    if FXCD and IsForm2 then
    begin
      GetForm2FileCRC32(SourceFile, TargetFile, TargetCRC);
    end else
    begin
      GetFileCRC32(TargetFile, TargetCRC);
    end;
    {CRC32 identisch?}
    if (SourceCRC <> TargetCRC) and not Terminated then
    begin
      ErrorCount := ErrorCount + 1;
      if not FileExists(SourceFile) then
        FLine := Format(Flang.GMS('everify06'), [SourceFile]) else
      if not FileExists(TargetFile) then
        FLine := Format(Flang.GMS('everify06'), [TargetFile])
      else
        FLine := Format(Flang.GMS('everify02'), [SourceFile, TargetFile]);
      Synchronize(DAddLine);
    end;
    {$ELSE}
    {bitweiser Vergleich}
    FLine := TargetFile;
    Synchronize(DStatusBarPanel1);
    if FXCD and IsForm2 then
    begin
      Ok := CompareForm2Files(SourceFile, TargetFile);
    end else
    begin
      Ok := CompareFiles(SourceFile, TargetFile);
    end;
    if not Ok and not Terminated then
    begin
      ErrorCount := ErrorCount + 1;
      if not FileExists(SourceFile) then
        FLine := Format(Flang.GMS('everify06'), [SourceFile]) else
      if not FileExists(TargetFile) then
        FLine := Format(Flang.GMS('everify06'), [TargetFile])
      else
        FLine := Format(Flang.GMS('everify02'), [SourceFile, TargetFile]);
      Synchronize(DAddLine);
    end;
    {$ENDIF}

    i := i + 1;
  until (i = FVerifyList.Count) or Terminated;

  if ErrorCount > 0 then
  begin
    FLine := '';
    Synchronize(DAddLine);
  end;
  FLine := Format(FLang.GMS('mverify02'), [ErrorCount]);
  Synchronize(DAddLine);
  FLine := '';
  Synchronize(DAddLine);
  if Terminated {FTerminate} then
  begin
    FLine := FLang.GMS('mverify03');
    Synchronize(DAddLine);
    FLine := '';
    Synchronize(DAddLine);
  end;
  {$IFDEF ShowVerifyTime}
  TimeCount.StopTimeCount;
  FLine := TimeCount.TimeAsString;
  Synchronize(DAddLine);
  TimeCount.Free;
  {$ENDIF}
end;

{ VerifyISOImage ---------------------------------------------------------------

  Eigentliche Aufgabe von TVerificationThread: Vergleichen.
  Diese Prozedur vergleicht die Disk mit dem ISO-Image.                        }

procedure TVerificationThread.VerifyISOImage;
var ISOFile               : string;
    ErrorCount            : Integer;
    Ok                    : Boolean;
    {$IFDEF ShowVerifyTime}
    TimeCount             : TTimeCount;
    {$ENDIF}
begin
  {$IFDEF ShowVerifyTime}
  TimeCount := TTimeCount.Create; TimeCount.StartTimeCount;
  {$ENDIF}
  ErrorCount := 0;
  ISOFile := FVerifyList[0];
  FLine := FLang.GMS('mverify01') + '   1/1';
  Synchronize(DStatusBarPanel0);
  FLine := ISOFile;
  Synchronize(DStatusBarPanel1);
  Ok := CompareISOImageDisc(ISOFile);
  if not Ok and not Terminated then
  begin
    ErrorCount := ErrorCount + 1;
  end;
  if ErrorCount > 0 then
  begin
    FLine := '';
    Synchronize(DAddLine);
  end;
  FLine := Format(FLang.GMS('mverify02'), [ErrorCount]);
  Synchronize(DAddLine);
  FLine := '';
  Synchronize(DAddLine);
  if Terminated {FTerminate} then
  begin
    FLine := FLang.GMS('mverify03');
    Synchronize(DAddLine);
    FLine := '';
    Synchronize(DAddLine);
  end;
  {$IFDEF ShowVerifyTime}
  TimeCount.StopTimeCount;
  FLine := TimeCount.TimeAsString;
  Synchronize(DAddLine);
  TimeCount.Free;
  {$ENDIF}
 end;

{ VerifyInit -------------------------------------------------------------------

  Feststellen, welches Laufwerk das richtige ist und den Vergleich starten.    }

procedure TVerificationThread.VerifyInit;
var Drive: string;
begin
  FLine := FLang.GMS('mverify01');
  Synchronize(DAddLine);
  FLine := '';
  Synchronize(DAddLine);
  DStatusBarPanel0;
  if FXCD then if FXCDExt = '' then FXCDExt := 'dat';
  {CD-Laufwerk mit der gerade beschriebenen CD suchen}
  Drive := GetDrive;
  if not Terminated then
  begin
    if Drive = '' then
    begin
      FLine := FLang.GMS('everify01');
      Synchronize(DAddLine);
    end else
    begin
      CleanUpList(FVerifyList);
      FLine := Format(FLang.GMS('mverify05'), [FVerifyList.Count]);
      Synchronize(DAddLine);
      FLine := '';
      Synchronize(DAddLine);
      if not FISOImage then Verify(Drive) else VerifyISOImage(Drive);
    end;
  end else
  begin
    if not FReloadError then
    begin
      FLine := FLang.GMS('mverify03');
      Synchronize(DAddLine);
      FLine := '';
      Synchronize(DAddLine);
    end;
  end;
  Synchronize(SendTerminationMessage);
end;

{ FindDuplicateFiles -----------------------------------------------------------

  In der Liste identische Dateien suchen und mehrfach vorhandene Eintr�ge auf
  den ersten zeigen lassen.                                                    }

procedure TVerificationThread.FindDuplicateFiles;
var i              : Integer;
    Count          : Integer;
    SourceFileSize,
    HashFileSize,
    DuplicateSize,
    TotalSize      : Int64;
    Quota          : Single;
    HashValue      : Longint;
    HashValueStr   : string;
    SourceFile,
    TargetFile,
    HashFile       : string;
    Hashtable      : TStringList;
    {$IFDEF ShowVerifyTime}
    TimeCount      : TTimeCount;
    {$ENDIF}
begin
  {$IFDEF ShowVerifyTime}
  TimeCount := TTimeCount.Create; TimeCount.StartTimeCount;
  {$ENDIF}
  i := 0;
  Count := 0;
  DuplicateSize := 0;
  TotalSize := 0;
  HashTable := TStringList.Create;
  repeat
    FLine := FLang.GMS('mdup01') + '   ' + IntToStr(i + 1) + '/' +
             IntToStr(FVerifyList.Count);
    Synchronize(DStatusBarPanel0);
    {Dateinamen aus Liste}
    SplitString(FVerifyList[i], ':', TargetFile, SourceFile);
    {Das Dummy-Verzeichnis ignorieren.}
    if SourceFile <> DummyDirName then
    begin
      HashValue := 0;
      FLine := SourceFile;
      Synchronize(DStatusBarPanel1);
      GetFileCRC32(SourceFile, HashValue);
      HashValueStr := IntToStr(HashValue);
      {Kam der Hashwert schon einmal vor?}
      HashFile := HashTable.Values[HashValueStr];
      SourceFileSize := GetFileSize(SourceFile);
      TotalSize := TotalSize + SourceFileSize;
      if HashFile = '' then
      begin
        {neuer Wert, also speichern}
        HashTable.Add(HashValueStr + '=' + SourceFile);
      end else
      begin
        {Bekannter Wert, Datei k�nnte identisch sein. Auch Gr��e mu� �berein-
         stimmen}
        HashFileSize   := GetFileSize(HashFile);
        if SourceFileSize = HashFileSize then
        begin
          {Pfad ersetzen}
          FVerifyList[i] := TargetFile + ':' + HashFile;
          Inc(Count);
          DuplicateSize := DuplicateSize + SourceFileSize;
          FLine := Format(Flang.GMS('mdup02'), [SourceFile, HashFile]);
          Synchronize(DAddLine);
        end;
      end;
    end;
    i := i + 1;
  until (i = FVerifyList.Count) or Terminated;
  FDupSize := DuplicateSize;
  Quota := (DuplicateSize / TotalSize) * 100;
  FLine := '';
  Synchronize(DAddLine);
  FLine := Format(FLang.GMS('mdup03'), [SizeToString(DuplicateSize),
                                        Count, FormatFloat('##.#%', Quota)]);
  Synchronize(DAddLine);
  FLine := '';
  Synchronize(DAddLine);
  if Terminated then
  begin
    FLine := FLang.GMS('mverify03');
    Synchronize(DAddLine);
    FLine := '';
    Synchronize(DAddLine);
    FVerifyList.Clear;
  end;
  HashTable.Free;
  {$IFDEF ShowVerifyTime}
  TimeCount.StopTimeCount;
  FLine := TimeCount.TimeAsString;
  Synchronize(DAddLine);
  TimeCount.Free;
  {$ENDIF}
end;

{ CreateInfoFile ---------------------------------------------------------------

  F�r alle Form2-Dateien Dateigr��e und CRC32 ermitteln.                       }

procedure TVerificationThread.CreateInfoFile;
var i, j     : Integer;
    Folder   : string;
    FileName : string;
    Size     : Int64;
    CRC32    : Longint;
    InfoList : TStringList;
    Count    : Integer;
    {$IFDEF ShowVerifyTime}
    TimeCount: TTimeCount;
    {$ENDIF}
begin
  {$IFDEF ShowVerifyTime}
  TimeCount := TTimeCount.Create; TimeCount.StartTimeCount;
  {$ENDIF}
  Count := 0;
  InfoList := TStringList.Create;
  {zun�chst nur Form2-Dateien und Ordnernamen behalten}
  for i := 0 to FVerifyList.Count - 1 do
    if FVerifyList[i] = '-f' then
    begin
      FVerifyList[i] := '';
      FVerifyList[i + 1] := '';
    end;
  for i := FVerifyList.Count - 1 downto 0 do
  begin
    if FVerifyList[i] = '-m' then Inc(Count);
    if FVerifyList[i] = '' then FVerifyList.Delete(i);
  end;
  {jetzt die List durchgehen}
  i := 0;
  j := 0;
  Folder := '\';
  repeat
    CRC32 := 0;
    if FVerifyList[i] = '-m' then
    begin
      Inc(j);
      FileName := FVerifyList[i + 1];
      FLine := FLang.GMS('mxcd02') + '   ' + IntToStr(j) + '/' +
               IntToStr(Count);
      Synchronize(DStatusBarPanel0);
      FLine := FileName;
      Synchronize(DStatusBarPanel1);
      
      Size := GetFileSize(FileName);
      GetFileCRC32(FileName, CRC32);
      InfoList.Add(Folder + ExtractFileName(FileName) + '|' +
                   IntToStr(LoComp(Size)) + '|' + CRCToStr(CRC32));
    end else
    if FVerifyList[i] = '-d' then
    begin
      Folder := '\' + FVerifyList[i + 1] + '\';
    end;
    Inc(i, 2);
  until (i >= FVerifyList.Count) or Terminated {FTerminate};
  InfoList.SaveToFile(ProgDataDir + cXCDInfoFile);
  InfoList.Free;
  if Terminated then
  begin
    FLine := FLang.GMS('moutput02');
    Synchronize(DAddLine);
    FLine := '';
    Synchronize(DAddLine);
    FVerifyList.Clear;
  end;
  {$IFDEF ShowVerifyTime}
  TimeCount.StopTimeCount;
  FLine := TimeCount.TimeAsString;
  Synchronize(DAddLine);
  TimeCount.Free;
  {$ENDIF}
end;

{ FindDuplicateFilesInit -------------------------------------------------------

  Suche nach identischen Dateien initialisieren und starten.                   }

procedure TVerificationThread.FindDuplicateFilesInit;
begin
  FLine := FLang.GMS('mdup01');
  Synchronize(DAddLine);
  FLine := '';
  Synchronize(DAddLine);
  DStatusBarPanel0;
  FindDuplicateFiles;
  Synchronize(SendTerminationMessage);
end;

{ CreateInfoFileInit -----------------------------------------------------------

  Info-Datei f�r Mode2/Form2-Dateien anlegen.                                  }

procedure TVerificationThread.CreateInfoFileInit;
begin
  FLine := FLang.GMS('mxcd01');
  Synchronize(DAddLine);
  FLine := '';
  Synchronize(DAddLine);
  DStatusBarPanel0;
  CreateInfoFile;
  Synchronize(SendTerminationMessage);
end;

{ Execute ----------------------------------------------------------------------

  Den Thread starten und mit dem Vergleich beginnen.                           }

procedure TVerificationThread.Execute;
begin
  // if FXCD then Synchronize(DHideProgressBarTotal);
  case FAction of
    cFindDuplicates: FindDuplicateFilesInit;
    cCreateInfoFile: CreateInfoFileInit;
  else
    VerifyInit;
  end;
end;

constructor TVerificationThread.Create(List: TStringList;
                                       Device: string; Lang: TLang;
                                       Suspended: Boolean);
begin
  FAction := cNoAction;    // spielt beim Verify keine Rolle
  FVerifyList := List;
  FLang := Lang;
  FDevice := Device;
  FDrive := '';
  FHandle := TLogWin.Inst.OutWindowHandle;
  FAutoExec := False;
  FXCD := False;
  FXCDExt := '';
  FXCDKeepExt := True;
  FISOImage := False;
  FDupSize := 0;
  FSizeVerified := 0;
  inherited Create(Suspended);
  TLogWin.Inst.ProgressBarShow(1, 100);
  TLogWin.Inst.ProgressBarShow(2, 100);
end;


{ Funktionen zum einfachen Starten und Beenden eines Threads -------------------

  werden ab cdrtfe 1.0 nicht mehr verwendet.                                   }

{ StartVerifyDataCD ------------------------------------------------------------

  StartVerifyDataCD bereitet die Daten vor und startet den Vergleich. Dieser
  Aufruf verzichtet auf die Fortschrittsanzeige. Wird in diesem Programm nicht
  verwendet.                                                                   }

procedure StartVerifyDataCD(List: TStringList; var Thread: TVerificationThread;
                            Device: string; Lang: TLang);

begin
  Thread := TVerificationThread.Create(List, Device, Lang, True);
  Thread.FreeOnTerminate := True;
  Thread.Resume;
end;

{ TerminateVerification --------------------------------------------------------

  Dem Thread signalisieren, den Vergleich schnellstm�glich abzubrechen.        }

procedure TerminateVerification(Thread: TVerificationThread);
begin
  if Thread <> nil then
  begin
    Thread.Terminate; //Thread.TerminateThread := True;
  end;
end;

end.
