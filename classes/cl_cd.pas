{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  cl_cd.pas: Datentypen zur Speicherung der Pfadlisten

  Copyright (c) 2004-2005 Oliver Valencia
  Copyright (c) 2002-2004 Oliver Valencia, Oliver Kutsche

  letzte �nderung  01.04.2005

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.

  cl_cd.pas implementiert die Objekte, in denen die zu einem Projekt hinzuge-
  f�gten Dateien und Verzeichnisse gespeichert werden. Als Grundlage wird eine
  Baumstruktur verwendet, die von cl_tree.pas zur Verf�gung gestellt wird.


  TCD

    Properties   CDSize
                 FileCount
                 FolderCount
                 CDLabel
                 LastError
                 LastFolderAdded
                 MaxLevel

    Methoden     AddFile(const AddName, DestPath: string)
                 ChangeForm2Status(const Name, Path: string)    // nur TXCD
                 CheckFS(var Args: TCheckFSArgs)
                 Create
                 CreateBurnList(List: TStringList)
                 CreateFileLists
                 DeleteAll
                 DeleteFolder(const Path: string)
                 DeleteFromPathlistByIndex(const Index: Integer; const Path: string)
                 DeleteFromPathlistByName(const Name, Path: string)
                 ExportDataToFile(Root: TNode; var File: TextFile)
                 ExportStructureToStringList(List: TStringList)
                 ExportStructureToTreeView(Tree: TTreeView)
                 ImportStructureFromStringList(List: TStringList)
                 GetFolderFromPath(Path: string): TNode
                 MoveFileByIndex(const Index: Integer; const SourcePath, DestPath: string)
                 MoveFileByName(const Name, SourcePath, DestPath: string)
                 MoveFolder(const SourcePath, DestPath: string)
                 NewFolder(const Path, Name: string)
                 RenameFileByIndex(const Index: Integer; const Path, Name: string; MaxLength: Byte)
                 RenameFileByName(const Path, OldName, Name: string; const MaxLength: Byte)
                 RenameFolder(const Path, Name: string; MaxLength: Byte)
                 SetCDLabel(const Name: string)
                 SortFileList(const Path: string)
                 SortFolder(const Path: string)


  TXCD: wie TCD, zus�tzlich

    Properties   AddAsForm2: Boolean
                 Form2FileCount: Integer
                 SmallForm2FileCount: Integer

    Methoden     AddFile(const AddName, DestPath: string); override;
                 ChangeForm2Status(const Name, Path: string)
                 CreateVerifyList(List: TStringList)


  TAudioCD

    Properties   CDTextLength
                 CDTextPresent
                 CDTime
                 LastError
                 TrackCount
                 TrackPausePresent

    Methoden     AddTrack(const Name: string)
                 Create
                 CreateBurnList(List: TStringList)
                 CreateCDTextFile(const Name: string)
                 DeleteAll
                 DeleteTrack(const Index: Integer)
                 GetCDText(const Index: Integer; var Title, Performer: string)
                 GetFileList: TStringList
                 GetTrackPause(const Index: Integer): string;
                 MoveTrack(const Index: Integer; const Direction: TDirection)
                 SetCDText(const Index: Integer; const Title, Performer: string)
                 SetTrackPause(const Index: Integer; const Pause: string)


  TDAE

    Properties   TrackCount

    Methoden     Create
                 GetTrackList: TStringList


  TVideoCD

    Properties   CDTime
                 LastError
                 TrackCount

    Methoden     AddTrack(const Name: string)
                 Create
                 CreateBurnList(List: TStringList)
                 DeleteAll
                 DeleteTrack(const Index: Integer)
                 GetFileList: TStringList
                 MoveTrack(const Index: Integer; const Direction: TDirection)

}

unit cl_cd;

{$I directives.inc}

interface

uses Forms, Classes, StdCtrls, ComCtrls, SysUtils, FileCtrl,
     cl_tree, f_cdtext, constant;

const CD_NoError = 0;          {Fehlercodes}
      CD_FolderNotUnique = 1;
      CD_FileNotUnique = 2;
      CD_FileNotFound = 3;
      CD_DestFolderIsSubFolder = 4;
      CD_NameTooLong = 5;
      CD_InvalidName = 6;
      CD_InvalidWaveFile = 7;
      CD_InvalidLabel = 8;
      CD_InvalidMpegFile = 9;

type TCheckFSArgs = record     {zur Vereinfachung der Parameter�bergabe}
       Path           : string;
       MaxLength      : Byte;
       CheckFolder    : Boolean;
       IgnoreFiles    : Boolean;
       ErrorListFiles,
       ErrorListDir,
       ErrorListIgnore: TStringList;
     end;

     TCD = class(TObject)
     private
       FCDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
       FCDSizeChanged: Boolean;
       FError: Byte;
       FFileCount: Integer;
       FFileCountChanged: Boolean;
       FFolderCountChanged: Boolean;
       FFolderCount: Integer;
       FFolderAdded: string;
       FMaxLevel: Integer;
       FMaxLevelChanged: Boolean;
       FRoot: TNode;
       function CountFiles(Root: TNode): Integer;
       function CountFolders(Root: TNode): Integer;
       function ExtractFileNameFromEntry(const Entry: string): string;
       function ExtractFileSizeFromEntry(const Entry: string): {$IFDEF LargeFiles} Comp {$ELSE} Longint {$ENDIF};
       function FileIsUnique(const Name: string; const Node: TNode): Boolean;
       function FolderIsUnique(const Name: string; const Node: TNode): Boolean;
       function GetPathFromFolder(const Root: TNode): string;
       function GetCDLabel: string;
       function GetCDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
       function GetFileCount: Integer;
       function GetFolderCount: Integer;
       function GetFolderSize(Root: TNode): {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
       function GetIndexOfFile(Name, Path: string): Integer;
       function GetLastError: Byte;
       function GetLastFolderAdded: string;
       function GetMaxFolderLevel(const Root: TNode): Integer;
       function GetMaxLevel: Integer;
       procedure FreeFileLists(Root: TNode);
       procedure InvalidateCounters;
       procedure NodeAddFile(const Name: string; const Node: TNode);
       procedure NodeAddFolder(const Name: string; Node: TNode);
       procedure NodeAddFolderRek(Name: string; Node: TNode); virtual;
     public
       constructor Create;
       destructor Destroy; override;
       function GetFileList(const Path: string): TStringList;
       function GetFolderFromPath(Path: string): TNode;
       procedure CreateBurnList(List: TStringList); virtual;
       procedure AddFile(const AddName, DestPath: string); virtual;
       procedure CheckFS(var Args: TCheckFSArgs);
       procedure CreateFileLists;
       procedure DeleteAll;
       procedure DeleteFolder(const Path: string);
       procedure DeleteFromPathlistByIndex(const Index: Integer; const Path: string);
       procedure DeleteFromPathlistByName(const Name, Path: string);
       procedure ExportDataToFile(Root: TNode; var F: TextFile);
       procedure ExportStructureToStringList(List: TStringList);
       procedure ExportStructureToTreeView(Tree: TTreeView);
       procedure ImportStructureFromStringList(List: TStringList);
       procedure MoveFileByIndex(const Index: Integer; const SourcePath, DestPath: string);
       procedure MoveFileByName(const Name, SourcePath, DestPath: string);
       procedure MoveFolder(const SourcePath, DestPath: string);
       procedure NewFolder(const Path, Name: string);
       procedure RenameFileByIndex(const Index: Integer; const Path, Name: string; MaxLength: Byte);
       procedure RenameFileByName(const Path, OldName, Name: string; const MaxLength: Byte);
       procedure RenameFolder(const Path, Name: string; MaxLength: Byte);
       procedure SetCDLabel(const Name: string);
       procedure SortFileList(const Path: string);
       procedure SortFolder(const Path: string);
       // property Root: TNode read FRoot;
       property CDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF} read GetCDSize;
       property FileCount: Integer read GetFileCount;
       property FolderCount: Integer read GetFolderCount;
       property CDLabel: string read GetCDLabel;
       property LastError: Byte read GetLastError;
       property LastFolderAdded: string read GetLastFolderAdded;
       property MaxLevel: Integer read GetMaxLevel;
     end;

     TXCD = class(TCD)
     private
       FAddAsForm2: Boolean;
       function CountForm2Files(Root: TNode): Integer;
       function CountSmallForm2Files(Root: TNode): Integer;
       function GetForm2FileCount: Integer;
       function GetSmallForm2FileCount: Integer;
       procedure NodeAddFolderRek(Name: string; Node: TNode); override;
       procedure NodeAddMovie(const Name: string; const Node: TNode);
     public
       procedure AddFile(const AddName, DestPath: string); override;
       procedure ChangeForm2Status(const Name, Path: string);
       procedure CreateBurnList(List: TStringList); override;
       procedure CreateVerifyList(List: TStringList);
       property AddAsForm2: Boolean write FAddAsForm2;
       property Form2FileCount: Integer read GetForm2FileCount;
       property SmallForm2FileCount: Integer read GetSmallForm2FileCount;
     end;

     TAudioCD = class(TObject)
     private
       FCDTime: Extended;
       FCDTimeChanged: Boolean;
       FError: Byte;
       FTrackCount: Integer;
       FTrackCountChanged: Boolean;
       FTrackList: TStringList;
       FTextInfo: TStringList;
       FPauseInfo: TStringList;
       FAlbumTitle: string;
       FAlbumPerformer: string;
       FAlbumSongwriter: string;
       FAlbumComposer: string;
       FAlbumArranger: string;
       FAlbumTextMessage: string;
       function ExtractTimeFromEntry(const Entry: string): Extended;
       function GetLastError: Byte;
       function GetCDTextLength: Integer;
       function GetCDTextPresent: Boolean;
       function GetCDTime: Extended;
       function GetTrackCount: Integer;
       function GetTrackPausePresent: Boolean;
       procedure ExportText(CDTextData: TStringList);
     public
       constructor Create;
       destructor Destroy; override;
       function GetFileList: TStringList;
       function GetCDTextList: TStringList;
       function GetTrackPause(const Index: Integer): string;
       procedure AddTrack(const Name: string);
       procedure CreateBurnList(List: TStringList);
       procedure CreateCDTextFile(const Name: string);
       procedure DeleteAll;
       procedure DeleteTrack(const Index: Integer);
       procedure GetCDText(const Index: Integer; var TextData: TCDTextTrackData);
       procedure MoveTrack(const Index: Integer; const Direction: TDirection);
       procedure SetCDText(const Index: Integer; TextData: TCDTextTrackData);
       procedure SetTrackPause(const Index: Integer; const Pause: string);
       property CDTextLength: Integer  read GetCDTextLength;
       property CDTextPresent: Boolean read GetCDTextPresent;
       property CDTime: Extended read GetCDTime;
       property LastError: Byte read GetLastError;
       property TrackCount: Integer read GetTrackCount;
       property TrackPausePresent: Boolean read GetTrackPausePresent;
     end;

     TDAE = class(TObject)
     private
       FTrackList: TStringList;
       function GetTrackCount: Integer;
     public
       constructor Create;
       destructor Destroy; override;
       function GetTrackList: TStringList;
       property TrackCount: Integer read GetTrackCount;
     end;

     TVideoCD = class(TObject)
     private
       FCDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
       FCDSizeChanged: Boolean;
       FCDTime: Extended;
       FCDTimeChanged: Boolean;
       FError: Byte;
       FTrackCount: Integer;
       FTrackCountChanged: Boolean;
       FTrackList: TStringList;
       function ExtractFileSizeFromEntry(const Entry: string): {$IFDEF LargeFiles} Comp {$ELSE} Longint {$ENDIF};       
       function ExtractTimeFromEntry(const Entry: string): Extended;
       function GetLastError: Byte;
       function GetCDTime: Extended;
       function GetCDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
       function GetTrackCount: Integer;
     public
       constructor Create;
       destructor Destroy; override;
       function GetFileList: TStringList;
       procedure AddTrack(const Name: string);
       procedure CreateBurnList(List: TStringList);
       procedure DeleteAll;
       procedure DeleteTrack(const Index: Integer);
       procedure MoveTrack(const Index: Integer; const Direction: TDirection);
       property CDTime: Extended read GetCDTime;
       property CDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF} read GetCDSize;
       property LastError: Byte read GetLastError;
       property TrackCount: Integer read GetTrackCount;
     end;

     TPList = ^TStringList;

implementation

uses {$IFDEF ShowDebugWindow} frm_debug, {$ENDIF}
     f_filesystem, f_misc, f_strings;

{ TCD ------------------------------------------------------------------------ }

{ TCD - private }

{ GetLastError -----------------------------------------------------------------

  GetLastError gibt den Fehlercode aus FError und setzt FError auf No_Error.   }

function TCD.GetLastError: Byte;
begin
  Result := FError;
  FError := CD_NoError;
end;

{ FreeFileLists ----------------------------------------------------------------

  FreeFileLists l�scht ausgehend vom Knoten Root rekursiv alle mit den Knoten
  verkn�pfte String-Listen.                                                    }

procedure TCD.FreeFileLists(Root: TNode);
var Node: TNode;
begin
  TPList(Root.Data)^.Free;
  Dispose(TPList(Root.Data));
  Node := Root.GetFirstChild;
  while Node <> nil do
  begin
    FreeFileLists(Node);
    Node := Root.GetNextChild(Node);
  end;
end;

{ FolderIsUnique ---------------------------------------------------------------

  FolderIsUnique pr�ft, ob der Name des Ordners bereits im Zielordner vor-
  handen ist. War urspr�nglich eine einzelne Funktion, die nun komplett in
  FileIsUnique integriert ist. Damit der restliche Quelltext nicht ge�ndert
  werden mu�te, bleibt FolderIsUnique erhalten.                                }

function TCD.FolderIsUnique(const Name: string;
                            const Node: TNode): Boolean;
begin
  Result := FileIsUnique(Name, Node);
end;

{ FileIsUnique -----------------------------------------------------------------

  FileIsUnique pr�ft, ob in der Pfadliste der (Ziel-)Name der Datei bereits vor-
  handen ist.                                                                  }

function TCD.FileIsUnique(const Name: string;
                          const Node: TNode): Boolean;
var Unique: Boolean;
    TempNode: TNode;
    Temp: string;
    i: Integer;
begin
  Unique := True;
  {Dateiliste pr�fen}
  for i := 0 to TPList(Node.Data)^.Count - 1 do
  begin
    Temp := TPList(Node.Data)^[i];
    Temp := StringLeft(Temp, ':');
    if Temp = Name then
    begin
      Unique := False;
    end;
  end;
  {Ordner pr�fen}
  TempNode := Node.GetFirstChild;
  while TempNode <> nil do
  begin
    if TempNode.Text = Name then
    begin
      Unique := False;
    end;
    TempNode := Node.GetNextChild(TempNode);
  end;
  Result := Unique;
end;

{ NodeAddFile ------------------------------------------------------------------

  NodeAddFile f�gt eine Datei in die Pfadliste des selektierten TreeNodes ein.
  Name       : Datei, die eingef�gt wird
  Node       : Knoten im Tree, in dessen Liste eingef�gt wird

  Pfadlisten-Eintrag: <Name der Datei auf CD>:<Quellpfad>*<Gr��e in Bytes>     }

procedure TCD.NodeAddFile(const Name: string; const Node: TNode);
begin
  TPList(Node.Data)^.Add(ExtractFileName(Name) + ':' + Name + '*' +
                         {$IFDEF LargeFiles}
                         FloatToStr(GetFileSize(Name))
                         {$ELSE}
                         IntToStr(GetFileSize(Name))
                         {$ENDIF});
end;

{ NodeAddFolder ----------------------------------------------------------------

  NodeAddFolder f�gt ein Verzeichnis ein.
  Name  : Verzeichnis, das mit seinem gesamten Inhalt eingef�gt wird
  Node  : Knoten, in den eingef�gt wird                                        }

procedure TCD.NodeAddFolder(const Name: string; Node: TNode);
var PList    : TPList;
begin
  {$IFDEF DebugAddFiles}
  FormDebug.Memo3.Lines.Add('Enter NodeAddFolder: ' + Name + ', ' + Node.Text);
  {$ENDIF}
  {es soll das Verzeichnis, nicht nur sein Inhalt eingef�gt werden}
  if Length(Name) > 3 then  {Der Pfad ist kein Wurzelverzeichnis}
  begin
    {Knoten und Liste f�r das Startverzeichnis einf�gen}
    New(PList);
    PList^ := TStringList.Create;
    {neuen Knoten im aktuellen einf�gen, neuer ist dann der aktuelle}
    Node := Node.Items.AddChild(GetLastDirFromPath(Name, '\'));
    Node.Data := PList;
    PList := nil;
    Dispose(PList);
  end;
  {eigentlicher Aufruf der rekursiven Prozedur}
  NodeAddFolderRek(Name, Node);
  Node.AlphaSortRek;
end;

{ NodeAddFolderRek -------------------------------------------------------------

  NodeAddFolderRek ist eigentliche rekursive Prozedure, die das Einf�gen der
  Ordner vornimmt.                                                             }

procedure TCD.NodeAddFolderRek(Name: string; Node: TNode);
var SearchRec  : TSearchRec;
    NodeTemp   : TNode;
    PList      : TPList;
begin
  {$IFDEF DebugAddFiles}
  with FormDebug.Memo3.Lines do
  begin
    Add('');
    Add('  Enter NodeAddFolderRek: ' + Name + ', ' + Node.Text);
  end;
  {$ENDIF}
  if Name[Length(Name)] <> '\' then
  begin
    Name := Name + '\';
  end;
  if FindFirst(Name + '*.*', faDirectory or faAnyFile, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory = faDirectory) and
         (SearchRec.Name[1] <> '.') then
      begin {es ist ein Verzeichnis}
        if (SearchRec.Attr and faDirectory > 0) then
        begin
          {Dateiliste f�r neuen Knoten erstellen}
          New(PList);
          PList^ := TStringList.Create;
          {neuen Knoten im aktuellen einf�gen, neuer wird aktueller Knoten}
          Node := Node.Items.AddChild(SearchRec.Name);
          Node.Data := PList;
          PList := nil;
          Dispose(PList);
        end;
        {urspr�nglichen Knoten merken}
        NodeTemp := Node.Parent;
        {auf Untereintr�ge pr�fen}
        {$IFDEF DebugAddFiles}
        FormDebug.Memo3.Lines.Add('    calling NodeAddFolderRek: ' + Name +
                                  SearchRec.Name + ', ' + Node.Text);
        {$ENDIF}
        NodeAddFolderRek(Name + SearchRec.Name, Node);
        {urspr�nglichen Knoten wieder zum aktuellen machen}
        Node := NodeTemp;
      end else
      begin {es ist eine Datei}
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          {Dateinamen in die Dateiliste des aktuellen Knotens einf�gen}
          NodeAddFile(Name + SearchRec.Name, Node);
        end;
      end;
      Application.ProcessMessages;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
    TPList(Node.Data)^.Sort;
  end;
end;

{ GetIndexOfFile ---------------------------------------------------------------

  GetIndexOfFile bestimmt den Index eines Dateieintrages in einer Dateiliste an-
  hand des Ziel-Dateinamens. Wird beim L�schen und Umbenennen von Dateien beim
  XCD-Editor ben�tigt, da dort die Indizes aus dem ListView nicht mit den
  Indizes in den Dateilisten �bereinstimmen.                                   }

function TCD.GetIndexOfFile(Name, Path: string): Integer;
var Temp: string;
    Found: Boolean;
    i: Integer;
    FileList: TStringList;
begin
  FileList := GetFileList(Path);
  i := 0;
  repeat
    Temp := FileList[i];
    Temp := ExtractFileNameFromEntry(Temp);
    Found := Temp = Name;
    i := i + 1;
  until Found or (i = FileList.Count);
  if not Found and (i = FileList.Count) then
  begin
    Result := -1;
  end else
  begin
    Result := i - 1;
  end;
end;

{ GetFileName ------------------------------------------------------------------

  GetFileName extrahiert aus dem Filelisten-Eintrag den Dateinamen.            }

function TCD.ExtractFileNameFromEntry(const Entry: string): string;
begin
  Result := StringLeft(Entry, ':');
end;

{ GetFileSize ------------------------------------------------------------------

  GetFileSize extrahiert aus dem Filelisten-Eintrag die Dateigr��e.            }

function TCD.ExtractFileSizeFromEntry(const Entry: string):
                              {$IFDEF LargeFiles} Comp {$ELSE} Longint {$ENDIF};
var Temp: string;
begin
  Temp := Entry;
  Temp := StringRight(Entry, '*');
  if Pos('>', Temp) > 0 then
  begin
    Delete(Temp, Pos('>', Temp), 1);
  end;
  {$IFDEF LargeFiles}
  Result := StrToFloat(Temp);
  {$ELSE}
  Result := StrToIntDef(Temp, 0);
  {$ENDIF}
end;

{ GetLastFolderAdded -----------------------------------------------------------

  Liefert den Pfad des zuletzt eingef�gten Ordners.                            }

function TCD.GetLastFolderAdded: string;
begin
  Result := FFolderAdded;
  FFolderAdded := '';
end;

{ GetFileCount -----------------------------------------------------------------

  GetFileCount liefert die Anzahl aller Dateien, die zur CD hinzugef�gt wurden.}

function TCD.GetFileCount: Integer;
begin
  if FFileCountChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('FileCount invalid');
    {$ENDIF}
    FFileCount := CountFiles(FRoot);
    Result := FFileCount;
    FFileCountChanged := False;
  end else
  begin
    Result := FFileCount;
  end;
end;

{ CountFiles -------------------------------------------------------------------

  Z�hlt rekursiv die Anzahl aller Dateien ausgehend von Knoten Root.           }

function TCD.CountFiles(Root: TNode): Integer;
var Node: TNode;
begin
  if (Root <> nil) and (Root.Data <> nil) then
  begin
    Result := TPList(Root.Data)^.Count;
  end else
  begin
    Result := 0;
  end;
  {erster Kind-Knoten}
  Node := Root.GetFirstChild;
  while Node <> nil do
  begin
    Result := Result + CountFiles(Node);
    {n�chster Knoten}
    Node := Root.GetNextChild(Node);
  end;
end;

{ GetFolderCount ---------------------------------------------------------------

  GetFolderCount liefert die Anzahl aller Ordner, die zur CD hinzugef�gt
  wurden.}

function TCD.GetFolderCount: Integer;
begin
  if FFolderCountChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('FolderCount invalid');
    {$ENDIF}
    FFolderCount := CountFolders(FRoot);
    Result := FFolderCount;
    FFolderCountChanged := False;
  end else
  begin
    Result := FFolderCount;
  end;
end;

{ CountFolders -----------------------------------------------------------------

  Z�hlt rekursiv die Anzahl aller Ordner ausgehend von Knoten Root.            }

function TCD.CountFolders(Root: TNode): Integer;
var Node: TNode;
begin
  if Root.Level <> 0 then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
  {erster Kind-Knoten}
  Node := Root.GetFirstChild;
  while Node <> nil do
  begin
    Result := Result + CountFolders(Node);
    {n�chster Knoten}
    Node := Root.GetNextChild(Node);
  end;
end;

{ GetCDSize --------------------------------------------------------------------

  GetCDSize liefert die Gr��e aller Datein in Bytes.                           }

function TCD.GetCDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
begin
  if FCDSizeChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('CDSize invalid');
    {$ENDIF}
    FCDsize := GetFolderSize(FRoot);
    Result := FCDSize;
    FCDSizeChanged := False;
  end else
  begin
    Result := FCDSize;
  end;
end;

{ GetFolderSize ----------------------------------------------------------------

  GetFolderSize summiert die Gr��e aller Dateien ausgehen vom Ordner Root auf. }

function TCD.GetFolderSize(Root: TNode): {$IFDEF LargeProject} Comp
                                                       {$ELSE} Longint {$ENDIF};
var Node: TNode;
    i: Integer;
    s: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
begin
  {$IFDEF DebugGetFolderSize}
  FormDebug.Memo1.Lines.Add('GetFolderSize: ' + Root.Text);
  {$ENDIF}
  s := 0;
  if (Root <> nil) and (Root.Data <> nil) then
  begin
    for i := 0 to TPList(Root.Data)^.Count - 1 do
    begin
      s := s + ExtractFileSizeFromEntry(TPList(Root.Data)^[i]);
    end;
    Result := s;
    {$IFDEF DebugGetFolderSize}
    {$IFDEF LargeProject}
    FormDebug.Memo3.Lines.Add('Size of ' + Root.Text + ' is ' + FloatToStr(s));
    {$ELSE}
    FormDebug.Memo3.Lines.Add('Size of ' + Root.Text + ' is ' + IntToStr(s));
    {$ENDIF}
    {$ENDIF}
  end else
  begin
    Result := 0;
  end;
  {n�chster Knoten}
  Node := Root.GetFirstChild;
  while Node <> nil do
  begin
    Result := Result + GetFolderSize(Node);
    Node := Root.GetNextChild(Node);
  end;
end;

{ InvalidateCounters -----------------------------------------------------------

  InvalidateCounters wird aufgerufen, wenn Dateien/Ordner hinzugef�gt oder
  gel�scht wurden. Damit werden die Counter-Changed-Flags auf True gesetzt.    }

procedure TCD.InvalidateCounters;
begin
  FFileCountChanged := True;
  FFolderCountChanged := True;
  FCDSizeChanged := True;
  FMaxLevelChanged := True;
end;

{ GetMaxLevel ------------------------------------------------------------------

  GetMaxFolderLevel ermittelt die maximale Verschachtelungstiefe ausgehend von
  Root.                                                                        }

function TCD.GetMaxFolderLevel(const Root: TNode): Integer;
var Node: TNode;
    max: Integer;
    Level: Integer;
begin
  if not Root.HasChildren then
  begin
    Result := Root.Level;
  end else
  begin
    max := 0;
    {n�chster Knoten}
    Node := Root.GetFirstChild;
    while Node <> nil do
    begin
      Level := GetMaxFolderLevel(Node);
      if Level > max then
      begin
        max := Level;
      end;
      Node := Root.GetNextChild(Node);
    end;
    Result := max;
  end;
end;

{ GetMaxLevel ------------------------------------------------------------------

  wird bei Zugriff auf property MaxLevel aufgerufen.                           }

function TCD.GetMaxLevel: Integer;
begin
  if FMaxLevelChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('MaxLevel invalid');
    {$ENDIF}
    FMaxLevel := GetMaxFolderLevel(FRoot);
    Result := FMaxLevel;
    FMaxLevelChanged := False;
  end else
  begin
    Result := FMaxLevel;
  end;
end;

{ GetPathFromFolder ------------------------------------------------------------

  GetPathFromFolder bestimmt den Pfad des angegebenen Knotens ausgehend von der
  Wurzel.                                                                      }

function TCD.GetPathFromFolder(const Root: TNode): string;
var Parent: TNode;
    Path: string;
begin
  Parent := Root;
  Path := '';
  while Parent.Level > 0 {Parent <> nil} do
  begin
    Insert(Parent.Text + '/', Path, 1);
    Parent := Parent.Parent;
  end;
  Result := Path;
end;

{ GetCDLabel -------------------------------------------------------------------

  GetCDLabel liefert den Text-Eintrag des Wurzel-Knotes als CDLabel zur�ck.    }

function TCD.GetCDLabel: string;
begin
  Result := FRoot.Text; 
end;

{ TCD - public }

constructor TCD.Create;
var PList: TPList;
begin
  inherited Create;
  FError := CD_NoError;
  FCDSize := 0;
  FCDSizeChanged := False;
  FFileCount := 0;
  FFileCountChanged := False;
  FFolderCount := 0;
  FFolderCountChanged := False;
  FMaxLevel := 0;
  FMaxLevelChanged := False;
  {Wurzel erzeugen}
  FRoot := TNode.Create(nil);
  FRoot.Text := 'CD';
  {Dateiliste f�r Wurzel erstellen}
  New(PList);
  PList^ := TStringList.Create;
  FRoot.Data := PList;
  PList := nil;
  Dispose(PList);
end;

destructor TCD.Destroy;
begin
  {alle Dateilisten freigeben}
  FreeFileLists(FRoot);
  FRoot.Free;
  inherited Destroy;
end;

{ ExportDataToFile -------------------------------------------------------------

  ExportDataToFile geht rekursiv alle Knoten ausgehen von Root durch und
  schreibt die Eintr�ge aus den Dateilisten in eine Textdatei.                 }

procedure TCD.ExportDataToFile(Root: TNode; var F: TextFile);
var Node: TNode;
    i: Integer;
    q: Integer;
    Path: string;
    Temp: string;
begin
  {Pfad innerhalb des Trees bestimmen}
  Path := GetPathFromFolder(Root);
  {Dateiliste speichern}
  if (Root <> nil) and (Root.Data <> nil) then
  begin
    for i := 0 to TPList(Root.Data)^.Count - 1 do
    begin
      Temp := Path + TPList(Root.Data)^[i];
      q := Pos('>', Temp);
      Temp := StringLeft(Temp, '*');
      if q > 0 then
      begin
        Temp := Temp + '>';
      end;
      Writeln(F, Temp);
    end;
  end;
  {n�chster Knoten}
  Node := Root.GetFirstChild;
  while Node <> nil do
  begin
    ExportDataToFile(Node, F);
    Node := Root.GetNextChild(Node);
  end;
end;

{ ExportStructureToTreeView ----------------------------------------------------

  ExportStructureToTreeView exportiert die gesamte Verzeichnisstruktur ausgehend
  von FRoot in den angegebenen Tree-View.                                      }
  
procedure TCD.ExportStructureToTreeView(Tree: TTreeView);
var Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  FRoot.SaveStructureToStream(Stream);
  Stream.Position := 0;
  Tree.LoadFromStream(Stream);
  Stream.Free;
end;

{ ExportStructureToStringList --------------------------------------------------

  ExportStructureToTreeView exportiert die gesamte Verzeichnisstruktur ausgehend
  von FRoot in den angegebenen Tree-View.                                      }

procedure TCD.ExportStructureToStringList(List: TStringList);
var Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  FRoot.SaveStructureToStream(Stream);
  Stream.Position := 0;
  List.LoadFromStream(Stream);
  Stream.Free;
end;

{ ImportStructureFromStringList ------------------------------------------------

  ImportStructureFromStringList importiert eine Verzeichnisstruktur in den
  Knoten FRoot.                                                                }

procedure TCD.ImportStructureFromStringList(List: TStringList);
var Stream: TMemoryStream;
begin
  {alten Inhalt l�schen}
  DeleteAll;
  Stream := TMemoryStream.Create;
  List.SaveToStream(Stream);
  Stream.Position := 0;
  FRoot.LoadStructureFromStream(Stream);
  Stream.Free;
end;

{ GetFolderFromPath ------------------------------------------------------------

  GetFolderFromPath geht ausgehend vom Knoten Root den angegebenen Pfad und
  liefert den Zielknoten als Ergebnis. Pfadtrenner ist '/'; kein Pfadtrenner am
  Anfang erlaubt. Bei leerer Pfadangabe wird der Knoten Root zur�ckgegeben.    }

function TCD.GetFolderFromPath(Path: string): TNode;
var Node, Root: TNode;
    p: Integer;
    List: TSTringList;
begin
  Root := FRoot;
  if Path <> '' then
  begin
    if Path[Length(Path)] <> '/' then
    begin
      Path := Path + '/';
    end;
    {Pfad auftrennen}
    List := TSTringList.Create;
    p := Pos('/', Path);
    while p <> 0 do
    begin
      List.Add(Copy(Path, 1, p - 1));
      Delete(Path, 1, p);
      p := Pos('/', Path);
    end;
    for p := 0 to List.Count - 1 do
    begin
      Node := Root.GetFirstChild;
      while Node.Text <> List[p] do
      begin
        Node := Root.GetNextChild(Node);
      end;
      Root := Node;
    end;
    List.Free;
  end;
  Result := Root;
end;

{ AddFile ----------------------------------------------------------------------

  F�gt eine Datei oder ein Verzeichnis zur Pfadliste hinzu.
    Name    : Datei oder Ordner
    DestPath: Ordner, in den eingef�gt wird                                    }

procedure TCD.AddFile(const AddName, DestPath: string);
var IsFile, IsDir: Boolean;
    Name: string;
    DestFolder: TNode;
begin
  DestFolder := GetFolderFromPath(DestPath);
  {$IFDEF DebugAddFiles}
  with FormDebug.Memo3.Lines do
  begin
    Add('');
    Add('Enter AddFile   : ' + AddName + ', ' + self.ClassName);
    Add('      DestPath  : ' + DestPath);
    Add('      DestFolder: ' + DestFolder.Text);
  end;
  {$ENDIF}
  IsFile := FileExists(AddName);
  IsDir := DirectoryExists(AddName);
  if IsFile or IsDir then
  begin
    if IsDir then
    begin
      Name := AddName;
      Delete(Name, 1, LastDelimiter('\', Name));
      if FolderIsUnique(Name, DestFolder) then
      begin
        NodeAddFolder(AddName, DestFolder);
        DestFolder.AlphaSortRek;
        InvalidateCounters;
      end else
      begin
        FError := CD_FolderNotUnique;
      end;
    end;
    if IsFile then
    begin
      Name := AddName;
      Delete(Name, 1, LastDelimiter('\', Name));
      if FileIsUnique(Name, DestFolder) then
      begin
        NodeAddFile(AddName, DestFolder);
        InvalidateCounters;
      end else
      begin
        FError := CD_FileNotUnique;
      end;
    end;
  end else
  begin
    FError := CD_FileNotFound;
  end;
end;

{ SortFileList -----------------------------------------------------------------

  SortFilesList sortiert die Dateiliste des durch Path bestimmten Ordners.     }

procedure TCD.SortFileList(const Path: string);
var Folder: TNode;
begin
  Folder := GetFolderFromPath(Path);
  TPList(Folder.Data)^.Sort;
end;

{ GetFileList ------------------------------------------------------------------

  GetFileList gibt eine Referenz auf die Dateiliste des durch Path bestimmten
  Ordners zur�ck.                                                              }

function TCD.GetFileList(const Path: string): TStringList;
var Folder: TNode;
begin
  Folder := GetFolderFromPath(Path);
  Result := TPList(Folder.Data)^;
end;

{ DeleteFromPathlistByIndex ----------------------------------------------------

  DeleteFromPathlistByIndex l�scht den (Index + 1)-ten Eintrag aus der Datei-
  liste des durch Path und Choice angegebenen Ordners.                         }

procedure TCD.DeleteFromPathlistByIndex(const Index: Integer;
                                        const Path: string);
var FileList: TStringList;
begin
  FileList := GetFileList(Path);
  if (Index > -1) and (Index < FileList.Count) then FileList.Delete(Index);
  InvalidateCounters;
end;

{ DeleteFromPathlistByName -----------------------------------------------------

  DeleteFromPathlistByName l�scht aus der durch Path bestimmten Dateiliste die
  Datei Name.                                                                  }

procedure TCD.DeleteFromPathlistByName(const Name, Path: string);
var Index: Integer;
begin
  Index := GetIndexOfFile(Name, Path);
  DeleteFromPathlistByIndex(Index, Path);
end;

{ DeleteFolder l�scht den durch Path bestimmten Ordner, es sei denn, es handelt
  sich um das Stammverzeichnis.                                                }

procedure TCD.DeleteFolder(const Path: string);
var Folder: TNode;
begin
  if Path <> '' then
  begin
    Folder := GetFolderFromPath(Path);
    {Dateilisten freigeben}
    FreeFileLists(Folder);
    {Ordner mit Unterordnern l�schen}
    Folder.Delete;
    InvalidateCounters;
  end else
  begin
    // Fehlercode?
  end;
end;

{ DeleteAll --------------------------------------------------------------------

  DeleteAll leert das Wurzelverzeichnis.                                       }

procedure TCD.DeleteAll;
var FileList: TStringList;
    Folder: TNode;
begin
  {Dateiliste des Wurzelverzeichnisses leeren}
  FileList := GetFileList('');
  FileList.Clear;
  {alle Ordner im Wurzelverzeichnis l�schen}
  Folder := FRoot.GetFirstChild;
  while Folder <> nil do
  begin
    {$IFDEF DebugDeleteAll}
    FormDebug.Memo3.Lines.Add('TCD.DeleteAll: deleting ' + Folder.Text);
    {$ENDIF}
    FreeFileLists(Folder);
    Folder.Delete;
    Folder := FRoot.GetNextChild(FRoot);
  end;
  InvalidateCounters;
end;

{ MoveFileByIndex --------------------------------------------------------------

  MoveFileByIndex verschiebt den (Index + 1)-ten Eintrag aus dem Ordner Source-
  path in den Ordner DestPath.                                                 }

procedure TCD.MoveFileByIndex(const Index: Integer;
                              const SourcePath, DestPath: string);
var Name: string;
    DestFolder: TNode;
    SourceList, DestList: TStringList;
begin
  DestFolder := GetFolderFromPath(DestPath);
  SourceList := GetFileList(SourcePath);
  DestList := GetFileList(DestPath);
  Name := ExtractFileNameFromEntry(SourceList[Index]);
  if FileIsUnique(Name, DestFolder) then
  begin
    DestList.Add(SourceList[Index]);
    SourceList.Delete(Index);
  end else
  begin
    FError := CD_FileNotUnique;
  end;
end;

{ MoveFileByName ---------------------------------------------------------------

  MoveFileByName verschiebt den Eintrag der Datei Name aus dem Ordner Source-
  path in den Ordner DestPath.                                                 }

procedure TCD.MoveFileByName(const Name, SourcePath, DestPath: string);
var Index: Integer;
begin
  Index := GetIndexOfFile(Name, SourcePath);
  MoveFileByIndex(Index, SourcePath, DestPath);
end;

{ MoveFolder -------------------------------------------------------------------

  MoveFolder verschiebt den Ordner SourcePath in den Ordner DestPath, es sei
  denn, DestFolder ist ein Unterordner von Folder.                             }

procedure TCD.MoveFolder(const SourcePath, DestPath: string);
var Folder, DestFolder: TNode;
begin
  Folder := GetFolderFromPath(SourcePath);
  DestFolder := GetFolderFromPath(DestPath);
  if not DestFolder.HasAsParent(Folder) then
  begin
    if FolderIsUnique(Folder.Text, DestFolder) then
    begin
      Folder.MoveTo(DestFolder);
      FMaxLevelChanged := True;
    end else
    begin
      FError := CD_FolderNotUnique;
    end;
  end else
  begin
    FError := CD_DestFolderIsSubFolder;
  end;
end;

{ SortFolder -------------------------------------------------------------------

  SortFolder sortiert die Unterordner des Ordners Path.                        }

procedure TCD.SortFolder(const Path: string);
var Folder: TNode;
begin
  Folder := GetFolderFromPath(Path);
  Folder.AlphaSort;
end;

{ SetCDLabel -------------------------------------------------------------------

  Label der CD festlegen.                                                      }

procedure TCD.SetCDLabel(const Name: string);
begin
  if CDLabelIsValid(Name) then
  begin
    FRoot.Text := Name;
  end else
  begin
    FError := CD_InvalidLabel;
  end;
end;

{ RenameFolder -----------------------------------------------------------------

  Durch Path bestimmten Ordner umbenennen. Wenn MaxLength = 0, wird nicht auf zu
  langen Namen �berpr�ft.                                                      }

procedure TCD.RenameFolder(const Path, Name: string; MaxLength: Byte);
var Folder, ParentFolder: TNode;
begin
  if MaxLength = 0 then MaxLength := 255;
  Folder := GetFolderFromPath(Path);
  ParentFolder := Folder.Parent;
  if (Length(Name) <= MaxLength) then
  begin
    if FileNameIsValid(Name) then
    begin
      if FolderIsUnique(Name, ParentFolder) then
      begin
        {alles ok, neuen Namen setzen}
        Folder.Text := Name;
      end else
      begin
        FError := CD_FolderNotUnique;
      end;
    end else
    begin
      FError := CD_InvalidName;
    end;
  end else
  begin
    FError := CD_NameTooLong;
  end;
end;

{ RenameFileByIndex ------------------------------------------------------------

  Die (Index + 1)-te Datei aus der durch Path bestimmen Dateiliste umbenennen. }

procedure TCD.RenameFileByIndex(const Index: Integer; const Path, Name: string;
                                MaxLength: Byte);
var FileList: TStringList;
    Folder: TNode;
    Temp: string;
begin
  if MaxLength = 0 then MaxLength := 255;
  Folder := GetFOlderFromPath(Path);
  FileList := GetFileList(Path);
  if (Length(Name) <= MaxLength) then
  begin
    if FileNameIsValid(Name) then
    begin
      if FileIsUnique(Name, Folder) then
      begin
        {alles ok, neuen Namen setzen}
        Temp := FileList[Index];
        Delete(Temp, 1, Pos(':', Temp) - 1);
        Insert(Name, Temp, 1);
        FileList[Index] := Temp;
      end else
      begin
        FError := CD_FileNotUnique;
      end;
    end else
    begin
      FError := CD_InvalidName;
    end;
  end else
  begin
    FError := CD_NameTooLong;
  end;
end;

{ RenameFileByName -------------------------------------------------------------

  Die Datei OldName im Ordner Path wird in Name umbenannt.                     }

procedure TCD.RenameFileByName(const Path, OldName, Name: string;
                               const MaxLength: Byte);
var Index: Integer;
begin
  Index := GetIndexOfFile(OldName, Path);
  if Index >= 0 then
  begin
    RenameFileByIndex(Index, Path, Name, MaxLength);
  end;
end;

{ NewFolder --------------------------------------------------------------------

  NewFolder legt im Ordner Path einen neuen Ordner Name an.                    }

procedure TCD.NewFolder(const Path, Name: string);
var Folder: TNode;
    PList: TPList;
    i: Integer;
    NewName: string;
begin
  Folder := GetFolderFromPath(Path);
  NewName := Name;
  if not FolderIsUnique(NewName, Folder) then
  begin
    i := 1;
    repeat
      Inc(i);
      NewName := Name + ' (' + IntToStr(i) + ')';
    until FolderIsUnique(NewName, Folder);
  end;
  {Knoten und Liste f�r das Startverzeichnis einf�gen}
  New(PList);
  PList^ := TStringList.Create;
  {neuen Knoten im aktuellen einf�gen, neuer ist dann der aktuelle}
  Folder := Folder.Items.AddChild(NewName);
  Folder.Data := PList;
  PList := nil;
  Dispose(PList);
  FFolderAdded := {Path + '/' +} NewName;
  InvalidateCounters;  
end;

{ CheckFS ----------------------------------------------------------------------

  CheckFS �berpr�ft das Dateisystem der Daten-CD auf zu lange Dateinamen und zu
  tief liegende Ordner. Wenn IgnoreFiles = True, dann wird nur die Verzeichnis-
  tiefe gepr�ft.                                                               }
  
procedure TCD.CheckFS(var Args: TCheckFSArgs);
var Folder: TNode;

  {CheckFileNames pr�ft die L�nge der Dateinamen.}

  procedure CheckFileNames(Root: TNode);
  var Path: string;
      Temp: string;
      CDName: string;
      FileList: TStringList;
      i: Integer;
      Node: TNode;
  begin
    {Pfadangabe f�r den aktuellen Knoten bestimmen}
    Path := GetPathFromFolder(Root);
    if Length(Root.Text) > Args.MaxLength then
    begin
      {nur eintragen, wenn nicht schon in Ignore-List enthalten}
      if Args.ErrorListIgnore.IndexOf(Path + ':') = -1 then
      begin
        Args.ErrorListFiles.Add(Path + ':');
      end;
    end;
    {Dateiliste des Ordners durchgehen}
    FileList := GetFileList(Path);
    for i := 0 to FileList.Count - 1 do
    begin
      Temp := FileList[i];
      {Dateinamen extrahieren}
      CDName := StringLeft(Temp, ':');
      {Wenn Dateiname zu lang, dann in ErrorList eintragen}
      if Length(CDName) > Args.MaxLength then
      begin
        {nur eintragen, wenn nicht schon in Ignore-List enthalten}
        if Args.ErrorListIgnore.IndexOf(Path + Temp) = -1 then
        begin
          Args.ErrorListFiles.Add(Path + Temp);
        end;
      end;
    end;
    {n�chster Knoten}
    Node := Root.GetFirstChild;
    while Node <> nil do
    begin
      CheckFileNames(Node);
      Node := Root.GetNextChild(Node);
    end;

  end;

  {CheckFolderLevel ermittelt Ordner mit zu gro�er Verschachtelungstiefe}

  procedure CheckFolderLevel(Root: TNode);
  var Node: TNode;
  begin
    if Root.Level > 7 then
    begin
      Args.ErrorListDir.Add(GetPathFromFolder(Root));
    end;
    Node := Root.GetFirstChild;
    while Node <> nil do
    begin
      CheckFolderLevel(Node);
      Node := Root.GetNextChild(Node);
    end;
  end;

begin
  with Args do
  begin
    {Dateinamen pr�fen}
    if not IgnoreFiles then
    begin
      {$IFDEF DebugErrorLists}
      FormDebug.Memo3.Lines.Add('Pr�fe Dateinamen in ' + Path);
      {$ENDIF}
      Folder := GetFolderFromPath(Path);
      CheckFileNames(Folder);
    end;
    {Ordner pr�fen}
    if CheckFolder then
    begin
      {$IFDEF DebugErrorLists}
      FormDebug.Memo3.Lines.Add('Pr�fe Ordner');
      {$ENDIF}
      CheckFolderLevel(FRoot);
    end;
  end;
end;

{ CreateFileLists --------------------------------------------------------------

  CreateFileLists erzeugt f�r jeden Knoten des Trees die zugeh�rige String-
  Liste f�r die Dateinamen. Wird ben�tigt, wenn eine Projekt-Datei geladen
  wird.                                                                        }
procedure TCD.CreateFileLists;

  procedure CreateFileListsRek(Root: TNode);
  var Node: TNode;
      PList: TPList;
  begin
    {$IFDEF DebugCreateFileLists}
    FormDebug.Memo1.Lines.Add('Enter CreateFileListsRek');
    {$ENDIF}
    if (Root <> nil) and (Root <> FRoot) then
    begin
      New(PList);
      PList^ := TStringList.Create;
      Root.Data := PList;
      PList := nil;
      Dispose(PList);
    end;
    {n�chster Knoten}
    Node := Root.GetFirstChild;
    while Node <> nil do
    begin
      CreateFileListsRek(Node);
      Node := Root.GetNextChild(Node);
    end;
  end;

begin
  CreateFileListsRek(FRoot);
end;

{ CreateBurnList ---------------------------------------------------------------

  CreateBurnList erzeugt aus den Daten in der Baumstruktur die Pfadlist, die an
  mkisofs �bergeben wird.                                                      }

procedure TCD.CreateBurnList(List: TStringList);

  procedure CreateBurnListRek(Root: TNode);
  var Node: TNode;
      i: Integer;
      Temp: string;
      Path: string;
  begin
    {Pfadangabe f�r -graft-points bestimmen}
    Path := GetPathFromFolder(Root);
    {Dateiliste des Ordners kopieren}
    for i := 0 to TPList(Root.Data)^.Count - 1 do
    begin
      Temp := Path + TPList(Root.Data)^[i];
      {Zusatzinfos entfernen}
      Temp := StringLeft(Temp, '*');
      List.Add(Temp);
    end;
    {n�chster Knoten}
    Node := Root.GetFirstChild;
    while Node <> nil do
    begin
      CreateBurnListRek(Node);
      Node := Root.GetNextChild(Node);
    end;
  end;

begin
  CreateBurnListRek(FRoot);
end;


{ TXCD ----------------------------------------------------------------------- }

{ TXCD - private }

{ NodeAddMovie -----------------------------------------------------------------

  Pfadlisten-Eintrag: <Name der Datei auf CD>:<Quellpfad>*<Gr��e in Bytes>

  NodeAddMovie macht das gleiche wie NodeAddFile, setzt aber am Ende des
  Eintrags noch '>' als Flag, damit die Form1- von Form2-Dateien unterschieden
  werden k�nnen.                                                               }

procedure TXCD.NodeAddMovie(const Name: string; const Node: TNode);
begin
  TPList(Node.Data)^.Add(ExtractFileName(Name) + ':' + Name + '*' +
                         {$IFDEF LargeFiles}
                         FloatToStr(GetFileSize(Name))
                         {$ELSE}
                         IntToStr(GetFileSize(Name))
                         {$ENDIF} + '>');
end;

{ CountForm2Files --------------------------------------------------------------

  CountForm2Files liefert die Anzahl aller Form2-Dateien, die sich in den
  Dateilisten befinden.}

function TXCD.CountForm2Files(Root: TNode): Integer;
var Node: TNode;
    i: Integer;
    c: Integer;
begin
  if (Root <> nil) and (Root.Data <> nil) then
  begin
    c := 0;
    for i := 0 to TPList(Root.Data)^.Count - 1 do
    begin
      if Pos('>', TPList(Root.Data)^[i]) > 0 then
      begin
        c := c + 1;
      end;
    end;
    Result := c;
  end else
  begin
    Result := 0;
  end;
  {n�chster Knoten}
  Node := Root.GetFirstChild;
  while Node <> nil do
  begin
    Result := Result + CountForm2Files(Node);
    Node := Root.GetNextChild(Node);
  end;
end;

{ GetForm2FileCount ------------------------------------------------------------

  GetForm2FileCount gibt die Anzahl der Form2-Dateien an das Property
  Form2FileCount.                                                              }

function TXCD.GetForm2FileCount: Integer;
begin
  Result := CountForm2Files(FRoot);
end;

{ CountSmallForm2Files ---------------------------------------------------------

  CountSmallForm2Files ermittelt die Anzahl der Form2-Dateien mit weniger als
  348.601 Bytes.}

function TXCD.CountSmallForm2Files(Root: TNode): Integer;
var Node: TNode;
    c: Integer;
    i: Integer;
    Temp: string;
begin
  if (Root <> nil) and (Root.Data <> nil) then
  begin
    c := 0;
    for i := 0 to TPList(Root.Data)^.Count - 1 do
    begin
      if Pos('>', TPList(Root.Data)^[i]) > 0 then
      begin
        Temp := TPList(Root.Data)^[i];
        Delete(Temp, 1, Pos('*', Temp));
        Delete(Temp, Pos('>', Temp), 1);
        {$IFDEF LargeFiles}
        if StrToFloat(Temp) < 348601 then
        {$ELSE}
        if StrToIntDef(Temp, 0) < 348601 then
        {$ENDIF}
        begin
          c := c + 1;
        end;
      end;
    end;
    Result := c;
  end else
  begin
    Result := 0;
  end;
  {n�chster Knoten}
  Node := Root.GetFirstChild;
  while Node <> nil do
  begin
    Result := Result + CountSmallForm2Files(Node);
    Node := Root.GetNextChild(Node);
  end;
end;

{ GetSmallForm2FileCount -------------------------------------------------------

  GetSmallForm2FileCount gibt die Anzahl der Form2-Dateien an das Property
  Form2FileCount.                                                              }

function TXCD.GetSmallForm2FileCount: Integer;
begin
  Result := CountSmallForm2Files(FRoot);
end;

{ TXCD - public }

{ NodeAddFolderRek -------------------------------------------------------------

  NodeAddFolderRek ist eigentliche rekursive Prozedure, die das Einf�gen der
  Ordner vornimmt.                                                             }

procedure TXCD.NodeAddFolderRek(Name: string; Node: TNode);
var SearchRec  : TSearchRec;
    NodeTemp   : TNode;
    PList      : TPList;
begin
  {$IFDEF DebugAddFiles}
  with FormDebug.Memo3.Lines do
  begin
    Add('');
    Add('  Enter NodeAddFolderRek: ' + Name + ', ' + Node.Text);
  end;
  {$ENDIF}
  if Name[Length(Name)] <> '\' then
  begin
    Name := Name + '\';
  end;
  if FindFirst(Name + '*.*', faDirectory or faAnyFile, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory = faDirectory) and
         (SearchRec.Name[1] <> '.') then
      begin {es ist ein Verzeichnis}
        if (SearchRec.Attr and faDirectory > 0) then
        begin
          {Dateiliste f�r neuen Knoten erstellen}
          New(PList);
          PList^ := TStringList.Create;
          {neuen Knoten im aktuellen einf�gen, neuer wird aktueller Knoten}
          Node := Node.Items.AddChild(SearchRec.Name);
          Node.Data := PList;
          PList := nil;
          Dispose(PList);
        end;
        {urspr�nglichen Knoten merken}
        NodeTemp := Node.Parent;
        {auf Untereintr�ge pr�fen}
        {$IFDEF DebugAddFiles}
        FormDebug.Memo3.Lines.Add('    calling TXCD.NodeAddFolderRek: ' + Name +
                                  SearchRec.Name + ', ' + Node.Text);
        {$ENDIF}
        NodeAddFolderRek(Name + SearchRec.Name, Node);
        {urspr�nglichen Knoten wieder zum aktuellen machen}
        Node := NodeTemp;
      end else
      begin {es ist eine Datei}
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          {Dateinamen in die Dateiliste des aktuellen Knotens einf�gen}
          if (Pos('.avi', LowerCase(SearchRec.Name)) > 0) or FAddAsForm2 then
          begin
            NodeAddMovie(Name + SearchRec.Name, Node);
          end else
          begin
            NodeAddFile(Name + SearchRec.Name, Node);
          end;
        end;
      end;
      Application.ProcessMessages;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
    TPList(Node.Data)^.Sort;
//    CDEFilesToSort := False;
//    CDEFilesToSortFolder := '';
  end;
end;

{ AddFile ----------------------------------------------------------------------

  F�gt eine Datei oder ein Verzeichnis zur Pfadliste hinzu.
    Name    : Datei oder Ordner
    DestPath: Ordner, in den eingef�gt wird                                    }

procedure TXCD.AddFile(const AddName, DestPath: string);
var IsFile, IsDir: Boolean;
    Name: string;
    DestFolder: TNode;
begin
  DestFolder := GetFolderFromPath(DestPath);
  {$IFDEF DebugAddFiles}
  with FormDebug.Memo3.Lines do
  begin
    Add('');
    Add('Enter AddFile   : ' + AddName + ', ' + self.ClassName);
    Add('      DestPath  : ' + DestPath);
    Add('      DestFolder: ' + DestFolder.Text);
  end;
  {$ENDIF}
  IsFile := FileExists(AddName);
  IsDir := DirectoryExists(AddName);
  if IsFile or IsDir then
  begin
    if IsDir then
    begin
      Name := AddName;
      Delete(Name, 1, LastDelimiter('\', Name));
      if FolderIsUnique(Name, DestFolder) then
      begin
        NodeAddFolder(AddName, DestFolder);
        DestFolder.AlphaSortRek;
        InvalidateCounters;
      end else
      begin
        FError := CD_FolderNotUnique;
      end;
    end;
    if IsFile then
    begin
      Name := AddName;
      Delete(Name, 1, LastDelimiter('\', Name));
      if FileIsUnique(Name, DestFolder) then
      begin
        if (Pos('.avi', LowerCase(AddName)) > 0) or FAddAsForm2 then
        begin
          NodeAddMovie(AddName, DestFolder);
        end else
        begin
          NodeAddFile(AddName, DestFolder);
        end;
        InvalidateCounters;
      end else
      begin
        FError := CD_FileNotUnique;
      end;
    end;
  end else
  begin
    FError := CD_FileNotFound;
  end;
end;

{ ChangeForm2Status ------------------------------------------------------------

  verschiebt Dateien von der Datei-Liste in die Movie-Liste und umgekehrt.     }

procedure TXCD.ChangeForm2Status(const Name, Path: string);
var Index: Integer;
    FileList: TStringList;
    Temp: string;
begin
  Index := GetIndexOfFile(Name, Path);
  FileList := GetFileList(Path);
  Temp := FileList[Index];
  if Temp[Length(Temp)] = '>' then
  begin
    Delete(Temp, Length(Temp), 1);
  end else
  begin
    Temp := Temp + '>';
  end;
  FileList[Index] := Temp;
end;

{ CreateBurnList ---------------------------------------------------------------

  CreateBurnList erzeugt aus den Daten in der Baumstruktur die Pfadlist, die an
  mode2cdmaker �bergeben wird.                                                 }

procedure TXCD.CreateBurnList(List: TStringList);

  procedure CreateXCDBurnList(Root: TNode);
  var Node: TNode;
      i: Integer;
      Temp: string;
      Path: string;
  begin
    {Pfadangabe f�r -graft-points bestimmen}
    Path := GetPathFromFolder(Root);
    Delete(Path, Length(Path), 1);
    Path := ReplaceChar(Path, '/', '\');
    if Path <> '' then
    begin
      List.Add('-d');
      List.Add(Path);
    end;
    {Dateiliste des Ordners kopieren}
    for i := 0 to TPList(Root.Data)^.Count - 1 do
    begin
      Temp := TPList(Root.Data)^[i];
      {Form1 oder Form2?}
      if Pos('>', Temp) > 0 then
      begin
        List.Add('-m');
      end else
      begin
        List.Add('-f');
      end;
      {Zusatzinfos entfernen}
      Temp := StringLeft(Temp, '*');
      {graft-points-Infos entfernen, mode2cdmaker kann nichts damit anfangen}
      Temp := StringRight(Temp, ':');
      List.Add(Temp);
    end;
    {n�chster Knoten}
    Node := Root.GetFirstChild;
    while Node <> nil do
    begin
      CreateXCDBurnList(Node);
      Node := Root.GetNextChild(Node);
    end;
  end;

begin
  CreateXCDBurnList(FRoot);
end;

{ CreateBurnList ---------------------------------------------------------------

  CreateBurnList erzeugt aus den Daten in der Baumstruktur die Pfadlist, die an
  mkisofs �bergeben wird.                                                      }

procedure TXCD.CreateVerifyList(List: TStringList);

  procedure CreateVerifyListRek(Root: TNode);
  var Node: TNode;
      i: Integer;
      Temp: string;
      Path: string;
      IsForm2: Boolean;
  begin
    {Pfadangabe f�r -graft-points bestimmen}
    Path := GetPathFromFolder(Root);
    // Path := ReplaceChar(Path, '/', '\');
    {Dateiliste des Ordners kopieren}
    for i := 0 to TPList(Root.Data)^.Count - 1 do
    begin
      Temp := Path + TPList(Root.Data)^[i];
      IsForm2 := Pos('>', Temp) > 0;
      {Zusatzinfos entfernen, bis auf Form2-Flag}
      Temp := StringLeft(Temp, '*');
      if IsForm2 then Temp := Temp + '>';
      List.Add(Temp);
    end;
    {n�chster Knoten}
    Node := Root.GetFirstChild;
    while Node <> nil do
    begin
      CreateVerifyListRek(Node);
      Node := Root.GetNextChild(Node);
    end;
  end;

begin
  CreateVerifyListRek(FRoot);
end;


{ TAudioCD ------------------------------------------------------------------- }

{ TAudioCD - private }

{ GetLastError -----------------------------------------------------------------

  GetLastError gibt den Fehlercode aus FError und setzt FError auf No_Error.   }

function TAudioCD.GetLastError: Byte;
begin
  Result := FError;
  FError := CD_NoError;
end;

{ GetCDTime --------------------------------------------------------------------

  GetCDTime gibt die Gesamtspielzeit zur�ck.                                   }

function TAudioCD.GetCDTime: Extended;
var Time: Extended;
    i: Integer;
begin
  if FCDTimeChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('CDTime invalid');
    {$ENDIF}
    Time := 0;
    for i := 0 to FTrackList.Count - 1 do
    begin
      Time := Time + ExtractTimeFromEntry(FTrackList[i]);
    end;
    FCDTime := Time;
    Result := FCDTime;
    FCDTimeChanged := False;
  end else
  begin
    Result := FCDTime;
  end;
end;

{ GetTrackCount ----------------------------------------------------------------

  GetTrackCount gibt die Anzahl der Tracks zur�ck.                             }

function TAudioCD.GetTrackCount: Integer;
begin
  if FTrackCountChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('TrackCount invalid');
    {$ENDIF}
    FTrackCount := FTrackList.Count;
    Result := FTrackCount;
    FTrackCountChanged := False;
  end else
  begin
    Result := FTrackCount;
  end;
end;

{ ExtractTimeFromEntry ---------------------------------------------------------

  ExtractTimeFromEntry gibt die Trackl�nge in Sekunden zur�ck.                 }

function TAudioCD.ExtractTimeFromEntry(const Entry: string): Extended;
begin
  Result := StrToFloat(StringRight(Entry, '*'));
end;

{ GetCDTextPresent -------------------------------------------------------------

  pr�ft, ob CD-Text-Informationen vorhanden sind.                              }

function TAudioCD.GetCDTextPresent: Boolean;
var i: Integer;
    TrackData: TCDTextTrackData;
begin
  Result := False;
  for i := -1 to FTextInfo.Count - 1 do
  begin
    GetCDText(i, TrackData);
    with TrackData do
      Result := Result or ((Title <> '') or (Performer <> '') or
                           (Songwriter <> '') or (Composer <> '') or
                           (Arranger <> '') or (TextMessage <> ''));
  end;
end;

{ GetCDTextLength --------------------------------------------------------------

  ermittelt die L�nge der formatierten CD-Text-Daten.                          }

function TAudioCD.GetCDTextLength: Integer;
var i: Integer;
    L: array[0..5] of Integer;
    TrackData: TCDTextTrackData;
begin
  Result := 0;
  for i := 0 to 5 do L[i] := 0;
  for i := -1 to FTextInfo.Count - 1 do
  begin
    GetCDText(i, TrackData);
    with TrackData do
    begin
      L[0] := L[0] + Length(Title) + 1;
      L[1] := L[1] + Length(Performer) + 1;
      L[2] := L[2] + Length(Songwriter) + 1;
      L[3] := L[3] + Length(Composer) + 1;
      L[4] := L[4] + Length(Arranger) + 1;
      L[5] := L[5] + Length(TextMessage) + 1;
    end;
  end;
  for i := 0 to 5 do
  begin
    {wenn f�r einen Pack-Type keine Daten vorhanden sind, L�nge auf Null setzen}
    if L[i] = FTextInfo.Count + 1 then L[i] := 0;
    if L[i] > 0 then
    begin
      Result := Result + (L[i] div 12) * 12;
      if L[i] mod 12 > 0 then Result := Result + 12;
    end;
  end;
end;

{ GetTrackPausePresent ---------------------------------------------------------

  pr�ft, ob Pausen-Informationen f�r die Tracks vorhanden sind.                }

function TAudioCD.GetTrackPausePresent: Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to FPauseInfo.Count - 1 do
  begin
    Result := Result or (GetTrackPause(i) <> '');
  end;
end;

{ ExportText -------------------------------------------------------------------

  ExportText liefert die CD-Text-Daten in zwei String-Listen zur�ck.           }

procedure TAudioCD.ExportText(CDTextData: TStringList);
var i: Integer;
    TextTrackData: TCDTextTrackData;
begin
  {Die Album-Infos als Daten f�r Track 0 hinzuf�gen}
  with TextTrackData do
  begin
    Title := FAlbumTitle;
    Performer := FAlbumPerformer;
    Songwriter :=  FAlbumSongwriter;
    Composer := FAlbumComposer;
    Arranger := FAlbumArranger;
    TextMessage := FAlbumTextMessage;
  end;
  CDTextData.Add(TextTrackDataToString(TextTrackData));
  for i := 0 to FTextInfo.Count - 1 do
  begin
    CDTextData.Add(FTextInfo[i]);
  end;
end;

{ TAudioCD - public }

constructor TAudioCD.Create;
begin
  inherited Create;
  FTrackList := TStringList.Create;
  FTextInfo := TStringList.Create;
  FPauseInfo := TStringList.Create;
  FAlbumTitle := '';
  FAlbumPerformer := '';
  FAlbumSongwriter := '';
  FAlbumComposer := '';
  FAlbumArranger := '';
  FAlbumTextMessage := '';
  FError := CD_NoError;
  FTrackCount := 0;
  FTrackCountChanged := False;
  FCDTime := 0;
  FCDTimeChanged := False;
end;

destructor TAudioCD.Destroy;
begin
  FTrackList.Free;
  FTextInfo.Free;
  FPauseInfo.Free;
  inherited Destroy;
end;

{ AddTrack ---------------------------------------------------------------------

  AddTrack f�gt die Audio-Datei Name in die TrackList ein.

  Pfadlisten-Eintrag: <Quellpfad>:<Gr��e in Bytes>*<L�nge in Sekunden>         }

procedure TAudioCD.AddTrack(const Name: string);
var Size: {$IFDEF LargeFiles} Comp {$ELSE} Longint {$ENDIF};
    TrackLength: Extended;
    Temp: string;
begin
  if FileExists(Name) then
  begin
    if (Pos('.wav', LowerCase(Name)) > 0) then
    begin
      if WaveIsValid(Name) then
      begin
        Size := GetFileSize(Name);
        TrackLength := GetWaveLength(Name);
        Temp := Name + ':' +
                {$IFDEF LargeFiles}FloatToStr(Size)
                {$ELSE}            IntToStr(Size) {$ENDIF} +
                '*' +  FloatToStr(TrackLength);
        FTrackList.Add(Temp);
        FTextInfo.Add('');                  // leerer Eintrag f�r CD-Text
        FPauseInfo.Add('');                 // leerer Eintrag f�r Pausen-Info
        FTrackCountChanged := True;
        FCDTimeChanged := True;
      end else
      begin
        FError := CD_InvalidWaveFile;
      end;
    end;
  end else
  begin
    FError := CD_FileNotFound;
  end;
end;

{ GetFileList ------------------------------------------------------------------

  GetFileList gibt eine Referenz auf die interne TrackListe zur�ck.            }

function TAudioCD.GetFileList: TStringList;
begin
  Result := FTrackList;
end;

{ GetCDTextList ----------------------------------------------------------------

  GetCDTextList gibt eine Referenz auf die interne Liste mit den CD-Text-
  Informationen zur�ck.                                                        }

function TAudioCD.GetCDTextList: TStringList;
begin
  Result := FTextInfo;
end;

{ MoveTrack --------------------------------------------------------------------

  MoveTrack verschiebt einen Audio-Track um eine Position nach oben bzw. unten.}

procedure TAudioCD.MoveTrack(const Index: Integer; const Direction: TDirection);
begin
  if Direction = dUp then
  begin
    if Index > 0 then
    begin
      FTrackList.Exchange(Index, Index - 1);
      FTextInfo.Exchange(Index, Index - 1);
      FPauseInfo.Exchange(Index, Index - 1);
    end;
  end else
  if Direction = dDown then
  begin
    if Index < FTrackList.Count - 1 then
    begin
      FTrackList.Exchange(Index, Index + 1);
      FTextInfo.Exchange(Index, Index + 1);
      FPauseInfo.Exchange(Index, Index + 1);
    end;
  end;
end;

{ DeleteTrack ------------------------------------------------------------------

  DeleteTrack entfernt den (Index + 1)-ten Track aus der Liste.                }

procedure TAudioCD.DeleteTrack(const Index: Integer);
begin
  FTrackList.Delete(Index);          // Track l�schen
  FTextInfo.Delete(Index);           // Textinformation l�schen
  FPauseInfo.Delete(Index);          // Pausen-Information l�schen
  FTrackCountChanged := True;
  FCDTimeChanged := True;
end;

{ CreateBurnList ---------------------------------------------------------------

  CreateBurnList erzeugt die Pfadliste mit den zu schreibenden Tracks.         }

procedure TAudioCD.CreateBurnList(List: TStringList);
var i: Integer;
    p: Integer;
    Temp: string;
begin
  for i := 0 to FTrackList.Count - 1 do
  begin
    p := LastDelimiter(':', FTrackList[i]);
    Temp := Copy(FTrackList[i], 1, p - 1);
    List.Add(Temp);
  end;
end;

{ SetText ----------------------------------------------------------------------

  SetText setzt die CD-Text-Informationen zum Track mit der Nummer (Index + 1).
  Ist Index = -1 (Track 0) werden die Album-Informationen gesetzt.
  Format: <Title>|<Performer>|<Songwriter>|<Composer>|<Arranger>|<Message>     }

procedure TAudioCD.SetCDText(const Index: Integer; TextData: TCDTextTrackData);
begin
  if Index < FTextInfo.Count then
  begin
    if Index = -1 then
    begin
      with TextData do
      begin
        FAlbumTitle := Title;
        FAlbumPerformer := Performer;
        FAlbumSongwriter := Songwriter;
        FAlbumComposer := Composer;
        FAlbumArranger := Arranger;
        FAlbumTextMessage := TextMessage;
      end;
    end else
    begin
      FTextInfo[Index] := TextTrackDataToString(TextData);
    end;
  end;
end;

{ GetText ----------------------------------------------------------------------

  GetText liefert den Titel und Interpreten zum Track mit der Nummer (Index + 1)
  zur�ck. F�r Index = -1 werden Titel und Interpret des Album zur�ckgegeben.   }

procedure TAudioCD.GetCDText(const Index: Integer;
                             var TextData: TCDTextTrackData);
begin
  with TextData do
  begin
    if Index = -1 then
    begin
      Title := FAlbumTitle;
      Performer := FAlbumPerformer;
      Songwriter :=  FAlbumSongwriter;
      Composer := FAlbumComposer;
      Arranger := FAlbumArranger;
      TextMessage := FAlbumTextMessage;
    end else
    begin
      StringToTextTrackData(FTextInfo[Index], TextData);
    end;
  end;
end;

{ CreateCDTextFile -------------------------------------------------------------

  erzeugt aus den CD-Text-Informationen eine bin�re Datei (nach Red Book bzw.
  MMC), die an cdrecord �bergeben werden kann.                                 }

procedure TAudioCD.CreateCDTextFile(const Name: string);
var CDTextData: TStringList;
begin
  CDTextData := TStringList.Create;
  ExportText(CDTextData);
  f_cdtext.CreateCDTextFile(Name, CDTextData);
  CDTextData.Free;
end;

{ SetTrackPause ----------------------------------------------------------------

  SetTrackPause setzt die L�nge der Pause des (Index + 1)-ten Tracks.          }

procedure TAudioCD.SetTrackPause(const Index: Integer; const Pause: string);
begin
  if Index < FTextInfo.Count then
  begin
      FPauseInfo[Index] := Pause;
  end;
end;

{ GetTrackPause ----------------------------------------------------------------

  GetTrackPause liefert die Pauseninformation des (Index + 1)-ten Tracks.      }

function TAudioCD.GetTrackPause(const Index: Integer): string;
begin
  Result := FPauseInfo[Index];
end;

{ DeleteAll --------------------------------------------------------------------

  Alle Datei- und Info-Listen l�schen.                                         }

procedure TAudioCD.DeleteAll;
begin
  FTrackList.Clear;
  FTextInfo.Clear;
  FPauseInfo.Clear;
  FAlbumTitle := '';
  FAlbumPerformer := '';
  FAlbumSongwriter := '';
  FAlbumComposer := '';
  FAlbumArranger := '';
  FAlbumTextMessage := '';
  FTrackCount := 0;
  FCDTime := 0;
end;


{ TDAE ----------------------------------------------------------------------- }

{ TDAE - private }

{ GetTrackCount ----------------------------------------------------------------

  GetTrackCount gibt die Anzahl der Tracks zur�ck.                             }

function TDAE.GetTrackCount: Integer;
begin
    Result := FTrackList.Count;
end;

{ TDAE - public }

constructor TDAE.Create;
begin
  inherited Create;
  FTrackList := TStringList.Create;
end;

destructor TDAE.Destroy;
begin
  FTrackList.Free;
  inherited Destroy;
end;

{ GetTrackList -----------------------------------------------------------------

  GetTrackList gibt eine Referenz auf die interne TrackListe zur�ck.

  Track-Eintrag: <Name>:<Laufzeit>*<Gr��e>                                     }

function TDAE.GetTrackList: TStringList;
begin
  Result := FTrackList;
end;


{ TvideoCD ------------------------------------------------------------------- }

{ TVideoCD - private }

{ GetLastError -----------------------------------------------------------------

  GetLastError gibt den Fehlercode aus FError und setzt FError auf No_Error.   }

function TVideoCD.GetLastError: Byte;
begin
  Result := FError;
  FError := CD_NoError;
end;

{ GetFileSize ------------------------------------------------------------------

  GetFileSize extrahiert aus dem Filelisten-Eintrag die Dateigr��e.            }

function TVideoCD.ExtractFileSizeFromEntry(const Entry: string):
                              {$IFDEF LargeFiles} Comp {$ELSE} Longint {$ENDIF};
var Temp: string;
    p: Integer;
begin
  Temp := Entry;
  Temp := '0';
  Temp := StringLeft(Entry, '*');
  p := LastDelimiter(':', Temp);
  if p > 2 then Delete(Temp, 1, p);
  {$IFDEF LargeFiles}
  Result := StrToFloat(Temp);
  {$ELSE}
  Result := StrToIntDef(Temp, 0);
  {$ENDIF}
end;

{ GetCDTime --------------------------------------------------------------------

  GetCDTime gibt die Gesamtspielzeit zur�ck.                                   }

function TVideoCD.GetCDTime: Extended;
var Time: Extended;
    i: Integer;
begin
  if FCDTimeChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('CDTime invalid');
    {$ENDIF}
    Time := 0;
    for i := 0 to FTrackList.Count - 1 do
    begin
      Time := Time + ExtractTimeFromEntry(FTrackList[i]);
    end;
    FCDTime := Time;
    Result := FCDTime;
    FCDTimeChanged := False;
  end else
  begin
    Result := FCDTime;
  end;
end;

{ GetCDSize --------------------------------------------------------------------

  GetCDSize liefert die Gr��e aller Datein in Bytes.                           }

function TVideoCD.GetCDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
var i: Integer;
begin
  if FCDSizeChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('CDSize invalid');
    {$ENDIF}
    FCDSize := 0;
    for i := 0 to FTrackList.Count - 1 do
    begin
      FCDSize := FCDSize + ExtractFileSizeFromEntry(FTrackList[i]);
    end;
    Result := FCDSize;
    FCDSizeChanged := False;
  end else
  begin
    Result := FCDSize;
  end;
end;

{ GetTrackCount ----------------------------------------------------------------

  GetTrackCount gibt die Anzahl der Tracks zur�ck.                             }

function TVideoCD.GetTrackCount: Integer;
begin
  if FTrackCountChanged then
  begin
    {$IFDEF DebugUpdateGauges}
    FormDebug.Memo3.Lines.Add('TrackCount invalid');
    {$ENDIF}
    FTrackCount := FTrackList.Count;
    Result := FTrackCount;
    FTrackCountChanged := False;
  end else
  begin
    Result := FTrackCount;
  end;
end;

{ ExtractTimeFromEntry ---------------------------------------------------------

  ExtractTimeFromEntry gibt die Trackl�nge in Sekunden zur�ck.                 }

function TVideoCD.ExtractTimeFromEntry(const Entry: string): Extended;
begin
  Result := StrToFloat(StringRight(Entry, '*'));
end;

{ TVideoCD - public }

constructor TVideoCD.Create;
begin
  inherited Create;
  FTrackList := TStringList.Create;
  FError := CD_NoError;
  FTrackCount := 0;
  FTrackCountChanged := False;
  FCDTime := 0;
  FCDTimeChanged := False;
  FCDSize := 0;
  FCDSizeChanged := False;
end;

destructor TVideoCD.Destroy;
begin
  FTrackList.Free;
  inherited Destroy;
end;

{ AddTrack ---------------------------------------------------------------------

  AddTrack f�gt die Audio-Datei Name in die TrackList ein.

  Pfadlisten-Eintrag: <Quellpfad>:<Gr��e in Bytes>*<L�nge in Sekunden>         }

procedure TVideoCD.AddTrack(const Name: string);
var Size: {$IFDEF LargeFiles} Comp {$ELSE} Longint {$ENDIF};
    TrackLength: Extended;
    Temp: string;
begin
  if FileExists(Name) then
  begin
    if (Pos('.mpg', LowerCase(Name)) > 0) then
    begin
      if True {MpegIsValid(Name)} then
      begin
        Size := GetFileSize(Name);
        TrackLength := 0; // GetMpegLength(Name);
        Temp := Name + ':' +
                {$IFDEF LargeFiles}FloatToStr(Size)
                {$ELSE}            IntToStr(Size) {$ENDIF} +
                '*' +  FloatToStr(TrackLength);
        FTrackList.Add(Temp);
        FTrackCountChanged := True;
        FCDTimeChanged := True;
        FCDSizeChanged := True;
      end else
      begin
        FError := CD_InvalidMpegFile;
      end;
    end;
  end else
  begin
    FError := CD_FileNotFound;
  end;
end;

{ GetFileList ------------------------------------------------------------------

  GetFileList gibt eine Referenz auf die interne TrackListe zur�ck.            }

function TVideoCD.GetFileList: TStringList;
begin
  Result := FTrackList;
end;

{ MoveTrack --------------------------------------------------------------------

  MoveTrack verschiebt einen Video-Track um eine Position nach oben bzw. unten.}

procedure TVideoCD.MoveTrack(const Index: Integer; const Direction: TDirection);
begin
  if Direction = dUp then
  begin
    if Index > 0 then
    begin
      FTrackList.Exchange(Index, Index - 1);
    end;
  end else
  if Direction = dDown then
  begin
    if Index < FTrackList.Count - 1 then
    begin
      FTrackList.Exchange(Index, Index + 1);
    end;
  end;
end;

{ DeleteTrack ------------------------------------------------------------------

  DeleteTrack entfernt den (Index + 1)-ten Track aus der Liste.                }

procedure TVideoCD.DeleteTrack(const Index: Integer);
begin
  FTrackList.Delete(Index);          // Track l�schen
  FTrackCountChanged := True;
  FCDTimeChanged := True;
  FCDSizeChanged := True;
end;

{ CreateBurnList ---------------------------------------------------------------

  CreateBurnList erzeugt die Pfadliste mit den zu schreibenden Tracks.         }

procedure TVideoCD.CreateBurnList(List: TStringList);
var i: Integer;
    p: Integer;
    Temp: string;
begin
  for i := 0 to FTrackList.Count - 1 do
  begin
    p := LastDelimiter(':', FTrackList[i]);
    Temp := Copy(FTrackList[i], 1, p - 1);
    List.Add(Temp);
  end;
end;

{ DeleteAll --------------------------------------------------------------------

  Alle Datei- und Info-Listen l�schen.                                         }

procedure TVideoCD.DeleteAll;
begin
  FTrackList.Clear;
  FTrackCount := 0;
  FCDTime := 0;
end;

end.