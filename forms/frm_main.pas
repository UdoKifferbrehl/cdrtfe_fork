{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  frm_main.pas: Hauptfenster

  Copyright (c) 2004-2005 Oliver Valencia
  Copyright (c) 2002-2004 Oliver Valencia, Oliver Kutsche

  letzte �nderung  02.04.2005

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.

}

unit frm_main;

{$I directives.inc}
                
interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ComCtrls, ExtCtrls, ShellAPI, Menus, FileCtrl, CommCtrl, Buttons,
     {externe Komponenten}
     {eigene Klassendefinitionen/Units}
     cl_lang, cl_imagelists, cl_settings, cl_projectdata, cl_filetypeinfo,
     cl_action, cl_cmdlineparser, cl_devices,
     user_messages, constant;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    GroupBoxDrive: TGroupBox;
    ComboBoxDrives: TComboBox;
    ComboBoxSpeed: TComboBox;
    StaticTextSpeed: TStaticText;
    CheckBoxDummy: TCheckBox;
    GroupBoxCDRWDelete: TGroupBox;
    RadioButtonCDRWBlankAll: TRadioButton;
    RadioButtonCDRWBlankFast: TRadioButton;
    RadioButtonCDRWBlankOpenSession: TRadioButton;
    RadioButtonCDRWBlankSession: TRadioButton;
    CheckBoxCDRWBlankForce: TCheckBox;
    TabSheet5: TTabSheet;
    GroupBoxCDInfo: TGroupBox;
    RadioButtonToc: TRadioButton;
    RadioButtonAtip: TRadioButton;
    RadioButtonMSInfo: TRadioButton;
    RadioButtonScanbus: TRadioButton;
    RadioButtonPrcap: TRadioButton;
    Bevel1: TBevel;
    MainMenu1: TMainMenu;
    Projekt1: TMenuItem;
    MainMenuLoadProject: TMenuItem;
    MainMenuSaveProject: TMenuItem;
    Bevel4: TBevel;
    Datei1: TMenuItem;
    MainMenuClose: TMenuItem;
    ButtonShowOutput: TButton;
    TabSheet6: TTabSheet;
    RadioButtonCapacity: TRadioButton;
    CDETreeView: TTreeView;
    CDEListView: TListView;
    CDETreeViewPopupMenu: TPopupMenu;
    CDETreeViewPopupSetCDLabel: TMenuItem;
    CDETreeViewPopupN1: TMenuItem;
    CDETreeViewPopupAddFolder: TMenuItem;
    CDETreeViewPopupAddFile: TMenuItem;
    CDETreeViewPopupN2: TMenuItem;
    CDETreeViewPopupDeleteFolder: TMenuItem;
    CDETreeViewPopupRenameFolder: TMenuItem;
    CDETreeViewPopupN3: TMenuItem;
    CDETreeViewPopupNewFolder: TMenuItem;
    CDEListViewPopupMenu: TPopupMenu;
    CDEListViewPopupAddFile: TMenuItem;
    CDEListViewPopupN1: TMenuItem;
    CDEListViewPopupRenameFile: TMenuItem;
    CDEListViewPopupDeleteFile: TMenuItem;
    StatusBar: TStatusBar;
    CDESpeedButton1: TSpeedButton;
    CDESpeedButton2: TSpeedButton;
    CDESpeedButton3: TSpeedButton;
    CDESpeedButton4: TSpeedButton;
    CDESpeedButton5: TSpeedButton;
    AudioListView: TListView;
    AudioSpeedButton1: TSpeedButton;
    AudioSpeedButton2: TSpeedButton;
    AudioSpeedButton3: TSpeedButton;
    AudioSpeedButton4: TSpeedButton;
    AudioListViewPopupMenu: TPopupMenu;
    AudioListViewPopupAddTrack: TMenuItem;
    AudioListViewPopupDeleteTrack: TMenuItem;
    AudioListViewPopupN1: TMenuItem;
    AudioListViewPopupMoveUp: TMenuItem;
    AudioListViewPopupMoveDown: TMenuItem;
    XCDETreeView: TTreeView;
    XCDEListView1: TListView;
    XCDEListView2: TListView;
    CDEListViewPopupAddMovie: TMenuItem;
    XCDESpeedButton1: TSpeedButton;
    XCDESpeedButton2: TSpeedButton;
    XCDESpeedButton3: TSpeedButton;
    XCDESpeedButton4: TSpeedButton;
    XCDESpeedButton5: TSpeedButton;
    XCDESpeedButton6: TSpeedButton;
    XCDESpeedButton7: TSpeedButton;
    DAEListView: TListView;
    N1: TMenuItem;
    MainMenuInfo: TMenuItem;
    MiscPopupMenu: TPopupMenu;
    MiscPopupVerify: TMenuItem;
    TabSheet7: TTabSheet;
    PanelDataCD: TPanel;
    Sheet1SpeedButtonCheckFS: TSpeedButton;
    ButtonDataCDOptionsFS: TButton;
    ButtonDataCDOptions: TButton;
    CheckBoxDataCDVerify: TCheckBox;
    PanelDataCDOptions: TPanel;
    LabelDataCDSingle: TLabel;
    LabelDataCDMulti: TLabel;
    LabelDataCDOTF: TLabel;
    LabelDataCDTAO: TLabel;
    LabelDataCDDAO: TLabel;
    LabelDataCDRAW: TLabel;
    LabelDataCDJoliet: TLabel;
    LabelDataCDRockRidge: TLabel;
    LabelDataCDUDF: TLabel;
    LabelDataCDISOLevel: TLabel;
    LabelDataCDBoot: TLabel;
    Label12: TLabel;
    LabelDataCDOverburn: TLabel;
    PanelAudioCD: TPanel;
    ButtonAudioCDOptions: TButton;
    PanelAudioCDOptions: TPanel;
    LabelAudioCDSingle: TLabel;
    LabelAudioCDMulti: TLabel;
    LabelAudioCDOverburn: TLabel;
    LabelAudioCDTAO: TLabel;
    LabelAudioCDDAO: TLabel;
    LabelAudioCDRAW: TLabel;
    LabelAudioCDPreemp: TLabel;
    LabelAudioCDUseInfo: TLabel;
    PanelXCD: TPanel;
    ButtonXCDOptions: TButton;
    PanelXCDOptions: TPanel;
    LabelXCDSingle: TLabel;
    LabelXCDIsoLEvel1: TLabel;
    LabelXCDIsoLevel2: TLabel;
    LabelXCDKeepExt: TLabel;
    LabelXCDOverburn: TLabel;
    PanelDAE: TPanel;
    ButtonDAEOptions: TButton;
    ButtonDAEReadToc: TButton;
    CheckBoxDAEBulk: TCheckBox;
    CheckBoxDAELibParanoia: TCheckBox;
    CheckBoxDAENoInfofiles: TCheckBox;
    Label1: TLabel;
    EditDAEPath: TEdit;
    ButtonDAESelectPath: TButton;
    Label2: TLabel;
    EditDAEPrefix: TEdit;
    PanelImage: TPanel;
    GroupBoxReadCD: TGroupBox;
    CheckBoxReadCDNoerror: TCheckBox;
    CheckBoxReadCDNocorr: TCheckBox;
    CheckBoxReadCDClone: TCheckBox;
    CheckBoxReadCDRange: TCheckBox;
    StaticTextReadCDStartSec: TStaticText;
    StaticTextReadCDEndSec: TStaticText;
    EditReadCDStartSec: TEdit;
    EditReadCDEndSec: TEdit;
    GroupBoxImage: TGroupBox;
    EditReadCDIsoPath: TEdit;
    EditImageIsoPath: TEdit;
    ButtonImageSelectPath: TButton;
    ButtonReadCDSelectPath: TButton;
    RadioButtonImageRead: TRadioButton;
    RadioButtonImageWrite: TRadioButton;
    RadioButtonImageRAW: TRadioButton;
    PanelImageWriteRawOptions: TPanel;
    RadioButtonImageRaw96r: TRadioButton;
    RadioButtonImageRaw96p: TRadioButton;
    RadioButtonImageRaw16: TRadioButton;
    RadioButtonImageTAO: TRadioButton;
    RadioButtonImageDAO: TRadioButton;
    CheckBoxImageOverburn: TCheckBox;
    CheckBoxImageClone: TCheckBox;
    MiscPopupClearOutput: TMenuItem;
    Panel1: TPanel;
    Bevel2: TBevel;
    ButtonSettings: TButton;
    Bevel3: TBevel;
    ButtonStart: TButton;
    ButtonCancel: TButton;
    ButtonAbort: TButton;
    ProgressBar: TProgressBar;
    SpeedButtonFixCD: TSpeedButton;
    ButtonAudioCDTracks: TButton;
    LabelAudioCDText: TLabel;
    N2: TMenuItem;
    MainMenuLoadFileList: TMenuItem;
    MainMenuSaveFileList: TMenuItem;
    N3: TMenuItem;
    MainMenuReloadDefaults: TMenuItem;
    CheckBoxXCDVerify: TCheckBox;
    Extras1: TMenuItem;
    MainMenuSetLang: TMenuItem;
    LabelXCDCreateInfoFile: TLabel;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    GroupBoxDVDVideo: TGroupBox;
    LabelDVDVideoPath: TLabel;
    EditDVDVideoSourcePath: TEdit;
    ButtonDVDVideoSelectPath: TButton;
    VideoListView: TListView;
    PanelVideoCD: TPanel;
    ButtonVideoCDOptions: TButton;
    VideoSpeedButton1: TSpeedButton;
    VideoSpeedButton2: TSpeedButton;
    VideoSpeedButton4: TSpeedButton;
    VideoSpeedButton3: TSpeedButton;
    PanelVideoCDOptions: TPanel;
    LabelVideoCDVCD1: TLabel;
    LabelVideoCDVCD2: TLabel;
    LabelVideoCDSVCD: TLabel;
    LabelVideoCDOverburn: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure MainMenuInfoClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure CDESpeedButton1Click(Sender: TObject);
    procedure CDESpeedButton2Click(Sender: TObject);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure CDESpeedButton3Click(Sender: TObject);
    procedure XCDESpeedButton1Click(Sender: TObject);
    procedure XCDESpeedButton2Click(Sender: TObject);
    procedure XCDESpeedButton3Click(Sender: TObject);
    procedure XCDESpeedButton5Click(Sender: TObject);
    procedure XCDESpeedButton4Click(Sender: TObject);
    procedure CDESpeedButton4Click(Sender: TObject);
    procedure XCDESpeedButton6Click(Sender: TObject);
    procedure CDESpeedButton5Click(Sender: TObject);
    procedure XCDESpeedButton7Click(Sender: TObject);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeViewEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure XCDEListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure XCDEListView1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure XCDEListView1Editing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure CDETreeViewPopupMenuPopup(Sender: TObject);
    procedure CDETreeViewPopupAddFolderClick(Sender: TObject);
    procedure CDETreeViewPopupAddFileClick(Sender: TObject);
    procedure CDETreeViewPopupDeleteFolderClick(Sender: TObject);
    procedure CDETreeViewPopupRenameFolderClick(Sender: TObject);
    procedure CDETreeViewPopupNewFolderClick(Sender: TObject);
    procedure CDETreeViewPopupSetCDLabelClick(Sender: TObject);
    procedure CDEListViewPopupMenuPopup(Sender: TObject);
    procedure CDEListViewPopupAddFileClick(Sender: TObject);
    procedure CDEListViewPopupAddMovieClick(Sender: TObject);
    procedure CDEListViewPopupRenameFileClick(Sender: TObject);
    procedure CDEListViewPopupDeleteFileClick(Sender: TObject);
    procedure AudioSpeedButton1Click(Sender: TObject);
    procedure AudioSpeedButton2Click(Sender: TObject);
    procedure AudioSpeedButton3Click(Sender: TObject);
    procedure AudioSpeedButton4Click(Sender: TObject);
    procedure AudioListViewPopupMenuPopup(Sender: TObject);
    procedure AudioListViewPopupAddTrackClick(Sender: TObject);
    procedure AudioListViewPopupDeleteTrackClick(Sender: TObject);
    procedure AudioListViewPopupMoveUpClick(Sender: TObject);
    procedure AudioListViewPopupMoveDownClick(Sender: TObject);
    procedure AudioListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure AudioListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonDataCDOptionsFSClick(Sender: TObject);
    procedure ButtonDataCDOptionsClick(Sender: TObject);
    procedure Sheet1SpeedButtonCheckFSClick(Sender: TObject);
    procedure ButtonAudioCDOptionsClick(Sender: TObject);
    procedure ButtonXCDOptionsClick(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonDAESelectPathClick(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure ButtonReadCDSelectPathClick(Sender: TObject);
    procedure ButtonImageSelectPathClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure EditExit(Sender: TObject);
    procedure ButtonSettingsClick(Sender: TObject);
    procedure ButtonShowOutputClick(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure ButtonDAEReadTocClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MainMenuCloseClick(Sender: TObject);
    procedure MainMenuLoadProjectClick(Sender: TObject);
    procedure MainMenuSaveProjectClick(Sender: TObject);
    procedure ButtonAbortClick(Sender: TObject);
    procedure MiscPopupVerifyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MiscPopupMenuPopup(Sender: TObject);
    procedure MiscPopupClearOutputClick(Sender: TObject);
    procedure SpeedButtonFixCDClick(Sender: TObject);
    procedure ButtonAudioCDTracksClick(Sender: TObject);
    {$IFDEF AllowToggle}
    procedure LabelClick(Sender: TObject);
    {$ENDIF}
    {$IFDEF MouseOverLabelHighlight}
    procedure LabelMouseMove(Sender: TObject;  Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    {$ENDIF}
    procedure DAEListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure DAEListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MainMenuLoadFileListClick(Sender: TObject);
    procedure MainMenuSaveFileListClick(Sender: TObject);
    procedure MainMenuReloadDefaultsClick(Sender: TObject);
    procedure MainMenuSetLangClick(Sender: TObject);
    procedure ButtonDVDVideoSelectPathClick(Sender: TObject);
    procedure VideoSpeedButton1Click(Sender: TObject);
    procedure VideoSpeedButton2Click(Sender: TObject);
    procedure VideoSpeedButton3Click(Sender: TObject);
    procedure VideoSpeedButton4Click(Sender: TObject);
    procedure VideoListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure VideoListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonVideoCDOptionsClick(Sender: TObject);
  private
    { Private declarations }
    FImageLists: TImageLists;              // FormCreate - FormDestroy
    FLang: TLang;                          // FormCreate - FormDestroy
    FSettings: TSettings;                  // FormCreate - FormDestroy
    FData: TProjectData;                   // FormCreate - FormDestroy
    FFileTypeInfo: TFileTypeInfo;          // FormCreate - FormDestroy
    FAction: TCDAction;                    // FormCreate - FormDestroy
    FCmdLineParser: TCmdLineParser;        // FormCreate - FormDestroy
    FDevices: TDevices;                    // FormCreate - FormDestroy
    FInstanceTermination: Boolean;
    function GetActivePage: Byte;
    function InputOk: Boolean;
    procedure ActivateTab(const PageToActivate: Byte);
    procedure AddToPathList(const Filename: string);
    procedure AddToPathListSort(const FolderAdded: Boolean);
    procedure AddItemToListView(const Item: string; ListView: TListView);
    procedure CheckDataCDFS;
    procedure CheckControls;
    procedure GetSettings;
    procedure InitMainform;
    procedure InitTreeView(Tree: TTreeView; const Choice: Byte);
    procedure InitTreeViews;
    procedure LoadProject(const ListsOnly: Boolean);
    procedure SaveProject(const ListsOnly: Boolean);
    procedure SaveWinPos;
    procedure SetSettings;
    procedure SetWinPos;
    procedure SetButtons(const Status: TOnOff);
    procedure ShowFolderContent(const Tree: TTreeView; ListView: TListView);
    procedure ShowTracks;
    procedure ShowTracksDAE;
    {$IFDEF AllowToggle}
    procedure ToggleOptions(Sender: TObject);
    {$ENDIF}
    procedure UpdateGauges;
    procedure UpdateOptionPanel;
    procedure UserAddFile(Tree: TTreeView);
    procedure UserAddFolder(Tree: TTreeView);
    procedure UserAddFolderUpdateTree(Tree: TTreeView);
    procedure UserAddTrack;
    procedure UserDeleteAll(Tree: TTreeView);
    procedure UserDeleteFile(Tree: TTreeView; View: TListView);
    procedure UserDeleteFolder(Tree: TTreeView);
    procedure UserMoveFile(SourceNode, DestNode: TTreeNode; View: TListView);
    procedure UserMoveFolder(SourceNode, DestNode: TTreeNode);
    procedure UserMoveTrack(List: TListView; const Direction: TDirection);
    procedure UserNewFolder(Tree: TTreeView);
    procedure UserRenameFile(View: TListView);
    procedure UserRenameFolder(Tree: TTreeView);
    procedure UserRenameFolderByKey(Tree: TTreeView);
    procedure UserSetCDLabel(Tree: TTreeView);
    procedure UserSort(Force: Boolean);
    {Message-Handler}
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMDROPFILES(var Msg: TMessage); message WM_DROPFILES;
    procedure WMButtonsOff(var Msg: TMessage); message WM_ButtonsOff;
    procedure WMButtonsOn(var Msg: TMessage); message WM_ButtonsOn;
    procedure WMTTerminated(var Msg: TMessage); message WM_TTerminated;
    procedure WMVTerminated(var Msg: TMessage); message WM_VTerminated;
    procedure WMFTerminated(var Msg: TMessage); message WM_FTerminated;
    procedure WMITerminated(var Msg: TMessage); message WM_ITerminated;
    procedure WMUpdateGauges(var Msg: TMessage); message WM_UPDATEGAUGES;
    procedure WMActivateDataTab(var Msg: TMessage); message WM_ACTIVATEDATATAB;
    procedure WMActivateAudioTab(var Msg: TMessage); message WM_ACTIVATEAUDIOTAB;
    procedure WMActivateXcdTab(var Msg: TMessage); message WM_ACTIVATEXCDTAB;
    procedure WMActivateVcdTab(var Msg: TMessage); message WM_ACTIVATEVCDTAB;
    procedure WMExecute(var Msg: TMessage); message WM_EXECUTE;
    procedure WMExitAfterExecute(var Msg: TMessage); message WM_ExitAfterExec;
    procedure WMWriteLog(var Msg: TMessage); message WM_WriteLog;
    procedure WMCheckDataFS(var Msg: TMessage); message WM_CheckDataFS;
    procedure WMMinimize(var Msg: TMessage); message WM_Minimize;
    {eigene Event-Handler}
    procedure MessageShow(Sender: TObject);
    procedure ProgressBarHide(Sender: TObject);
    procedure ProgressBarReset(Sender: Tobject);
    procedure ProgressBarUpdate(Sender: TObject);
    procedure UpdatePanels(Sender: TObject);
  public
    { Public declarations }
  end;

var Form1: TForm1;

implementation

{$R *.DFM}
{$R ../resource/icons.res}
{$R ../resource/buttons.res}

uses frm_datacd_fs, frm_datacd_options, frm_datacd_fs_error,
     frm_audiocd_options, frm_audiocd_tracks,
     frm_xcd_options, frm_settings, frm_about, frm_output,
     frm_videocd_options,
     {$IFDEF ShowDebugWindow} frm_debug, {$ENDIF}
     {$IFDEF ShowCDTextInfo} f_cdtext, {$ENDIF}
     {$IFDEF AddCDText} f_cdtext, {$ENDIF}
     f_filesystem, f_process, f_misc, f_strings, f_largeint, f_init,
     f_checkproject;

{$IFDEF ShowTime}
var TC, TC2: TTimeCount;
{$ENDIF}

{ Messagehandling ------------------------------------------------------------ }

{ WMCopyData -------------------------------------------------------------------

  Nimmt Dateinamen entgegen und f�gt sie der aktuellen Dateiliste hinzu, wenn
  WM_COPYDATA empfangen wird.                                                  }

procedure TForm1.WMCopyData(var Msg: TWMCopyData);
var temp: PChar;
    FolderAdded: Boolean;
begin
  temp := Msg.CopyDataStruct.lpData;
  AddToPathList(string(temp));
  {Flag setzen, wenn Order hinzugef�gt wurde}
  FolderAdded := DirectoryExists(string(temp));
  AddToPathlistSort(FolderAdded);
end;

{ WMDROPFILES ------------------------------------------------------------------

  WMDROPFILES nimmt Datei- und Verzeichnisnamen entgegen, wenn per Drag-and-Drop
  diese aus dem Explorer auf cdrtfe gezogen werden.                            }

procedure TForm1.WMDROPFILES (var Msg: TMessage);
var i, Anzahl, Size: Integer;
    Dateiname: PChar;
    Filename: string;
    FolderAdded: Boolean;
begin
  inherited;
  FolderAdded := False;
  Form1.StatusBar.Panels[0].Text := FLang.GMS('m118');
  {Wieviele Objekte wurden auf cdrtfe gezogen?}
  Anzahl := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 0);
  for i := 0 to (Anzahl - 1) do
  begin
    Size := DragQueryFile(Msg.WParam, i, nil, 0) + 1;
    Dateiname:= StrAlloc(Size);
    DragQueryFile(Msg.WParam, i, Dateiname, Size);
    Filename := string(Dateiname);
    AddToPathList(FileName);
    {Flag setzen, wenn Order hinzugef�gt wurde}
    if not FolderAdded then
    begin
      if DirectoryExists(FileName) then FolderAdded := True;
    end;
    StrDispose(Dateiname);
  end;
  DragFinish(Msg.WParam);
  {Ordner sortieren}
  AddToPathlistSort(FolderAdded);
end;

{ WMButtonsOff/On --------------------------------------------------------------

  Erm�glichen das (De-)Aktivieren der Buttons aus einer anderen Klasse  heraus,
  ohne direkten Zugriff auf die Controls.                                      }

procedure TForm1.WMButtonsOff(var Msg: TMessage);
begin
  SetButtons(oOff);
end;

procedure TForm1.WMButtonsOn(var Msg: TMessage);
begin
  SetButtons(oOn);
end;

{ WMFTerminated ----------------------------------------------------------------

  Wenn WM_FTerminated empfangen wird, ist der Thread, der Dateiduplikate sucht
  beendet worden.                                                              }

procedure TForm1.WMFTerminated(var Msg: TMessage);
begin
  {$IFDEF DebugFindDups}
  SendMessage(Handle, WM_VTerminated, 0, 0);
  exit;
  {$ENDIF}
  if (Msg.WParam = -1) and (Msg.LParam = -1) then
  begin
    {Suche wurde vom User abgebrochen}
    SendMessage(Handle, WM_VTerminated, 0, 0);
  end else
  begin
    {$IFDEF LargeFiles}
    {WParam: high order longword, LParam: low order longword von FDupSize}
    // Memo1.Lines.Add(SizeToString(Msg.WParam));
    // Memo1.Lines.Add(SizeToString(Msg.LParam));
    // Memo1.Lines.Add(SizeToString(IntToComp(Msg.LParam, Msg.WParam)));
    FAction.DuplicateFileSize := IntToComp(Msg.LParam, Msg.WParam);
    {$ELSE}
    // Memo1.Lines.Add(SizeToString(Msg.LParam));
    FAction.DuplicateFileSize := Msg.LParam;
    {$ENDIF}
    StatusBar.Panels[1].Text := '';
    UpdateGauges;
    FAction.Action := FSettings.General.Choice;
    FAction.StartAction;
  end;
end;

{ WMITerminated ----------------------------------------------------------------

  Wenn WM_ITerminated empfangen wird, ist der Thread, der die XCD-Info-Datei
  erstellt, beendet worden.                                                    }

procedure TForm1.WMITerminated(var Msg: TMessage);
begin
  {$IFDEF DebugCreateInfoFile}
  SendMessage(Handle, WM_VTerminated, 0, 0);
  exit;
  {$ENDIF}
  if (Msg.WParam = -1) and (Msg.LParam = -1) then
  begin
    {Suche wurde vom User abgebrochen}
    DeleteFile(FSettings.XCD.XCDInfoFile);
    SendMessage(Handle, WM_VTerminated, 0, 0);
  end else
  begin
    {Datei zu den Daten hinzuf�gen}
    FData.AddToPathlist(FSettings.XCD.XCDInfoFile, '', cXCD);
    StatusBar.Panels[1].Text := '';
    UpdateGauges;
    FAction.Action := FSettings.General.Choice;
    FAction.StartAction;
  end;
end;

{ WMTTerminated ----------------------------------------------------------------

  Wenn WM_TTerminated empfangen wird, ist der zweite Thread beendet worden.    }

procedure TForm1.WMTTerminated(var Msg: TMessage);
begin
  {EnvironmentBlock entsorgen, falls n�tig}
  CheckEnvironment(FSettings);
  {Aufr�umen: aufgrund des Multithreadings hierher verschoben}
  DeleteFile(FSettings.DataCD.PathListName);
  DeleteFile(FSettings.DataCD.ShCmdName);
  DeleteFile(FSettings.XCD.XCDParamFile);
  //DeleteFile(FSettings.XCD.XCDInfoFile);
  DeleteFile(FSettings.AudioCD.CDTextFile);
  DeleteFile(FSettings.DVDVideo.ShCmdName);
  if not (FSettings.DataCD.ImageOnly or FSettings.DataCD.KeepImage) then
  begin
    DeleteFile(FSettings.DataCD.IsoPath);
  end;
  if not (FSettings.XCD.ImageOnly or FSettings.XCD.KeepImage) and
     (FSettings.General.Choice = cXCD) then
  begin
    DeleteFile(FSettings.XCD.IsoPath + cExtBin);
    DeleteFile(FSettings.XCD.IsoPath + cExtToc);
    DeleteFile(FSettings.XCD.IsoPath + cExtCue);
  end;
  if not (FSettings.VideoCD.ImageOnly or FSettings.VideoCD.KeepImage) and
     (FSettings.General.Choice = cVideoCD) then
  begin
    DeleteFile(FSettings.VideoCD.IsoPath + cExtBin);
    DeleteFile(FSettings.VideoCD.IsoPath + cExtCue);
  end;
  {Thread zu Vergleichen der Dateien starten}
  if (FSettings.General.Choice = cDataCD) and FSettings.DataCD.Verify  and
     not (FSettings.DataCD.ImageOnly or FSettings.Cdrecord.Dummy) then
  begin
    FAction.Action := cVerify;
    FAction.StartAction;
  end else
  if (FSettings.General.Choice = cXCD) and FSettings.XCD.Verify  and
     not (FSettings.XCD.ImageOnly or FSettings.Cdrecord.Dummy) then
  begin
    FAction.Action := cVerifyXCD;
    FAction.StartAction;
  end else
  begin
    if FSettings.General.Choice = cFixCD then
      FSettings.General.Choice := GetActivePage;
    {Falls kein Vergleich stattfindet, gleich weiter}
    SendMessage(Handle, WM_VTerminated, 0, 0);
  end;
end;

{ WMVTerminated ----------------------------------------------------------------

  Wenn WM_VTerminated empfangen wird, ist der dritte Thread beendet bzw. gar
  nicht gestartet worden.                                                      }

procedure TForm1.WMVTerminated(var Msg: TMessage);
var LogFile: string;
begin
  {Die XCD-Info-Datei darf erst nach dem Vergleich entsorgt werden.}
  if DeleteFile(FSettings.XCD.XCDInfoFile) then
    FData.DeleteFromPathlistByName(ExtractFileName(FSettings.XCD.XCDInfoFile),
                                   '', cXCD);
  with FSettings.CmdLineFlags do
  begin
    {Flag f�r automatisches Brennen zur�cksetzten}
    if ExecuteProject then ExecuteProject := False;
    {Buttons freigeben}
    SetButtons(oOn);
    StatusBar.Panels[1].Text := '';
    UpdateGauges;
    {Log-File schreiben}
    if WriteLogFile then
    begin
      if FSettings.General.LastProject = '' then
      begin
        LogFile := ProgDataDir + '\cdrtfe.log';
      end else
      begin
        LogFile := FSettings.General.LastProject + '.log';
      end;
      Memo1.Lines.SaveToFile(LogFile);
    end;
    {automatisches Beenden}
    if ExitAfterExecution then
    begin
      Application.Terminate;
    end;
  end;
end;

{ WMActivate[Data|Audio|Xcd|Vcd]Tab --------------------------------------------

  Wenn eine dieser Messages empfangen wird, ist die entsprechende Registerkarte
  in den Vordergrund zu bringen.                                               }

procedure TForm1.WMActivateDataTab(var Msg: TMessage);
begin
  ActivateTab(cDataCD);
end;

procedure TForm1.WMActivateAudioTab(var Msg: TMessage);
begin
  ActivateTab(cAudioCD);
end;

procedure TForm1.WMActivateXcdTab(var Msg: TMessage);
begin
  ActivateTab(cXCD);
end;

procedure TForm1.WMActivateVcdTab(var Msg: TMessage);
begin
  ActivateTab(cVideoCD);
end;

{ WMUpdateGauges ---------------------------------------------------------------

  Wird diese Message empfangen, soll die Anzeige der Statusinformationen
  aktualisiert werden.                                                         }

procedure TForm1.WMUpdateGauges(var Msg: TMessage);
begin
  UpdateGauges;
end;

{ WMExecute --------------------------------------------------------------------

  Wenn WM_EXECUTE empfangen wird, soll automatisch gestartet werden.           }

procedure TForm1.WMExecute(var Msg: TMessage);
begin
  FSettings.CmdLineFlags.ExecuteProject := True;
  Form1.Activate;
end;

{ WMExitAfterExecute -----------------------------------------------------------

  Wenn WM_ExitAfterExecute empfangen wird, soll cdrtfe nach dem automatischen
  Start beendet werden.                                                        }

procedure TForm1.WMExitAfterExecute(var Msg: TMessage);
begin
  FSettings.CmdLineFlags.ExitAfterExecution := True;
end;

{ WMWriteLog -------------------------------------------------------------------

  Wenn WM_WriteLog empfangen wird, soll eine Log-Datei angelegt werden, die alle
  Ausgabe der Konsolenprogramme enth�lt.                                       }

procedure TForm1.WMWriteLog(var Msg: TMessage);
begin
  FSettings.CmdLineFlags.WriteLogFile := True;
end;

{ WMCheckDataFS ----------------------------------------------------------------

  Wird WM_CheckDataFS empfangen, soll das Dateisystem der CD gepr�ft werden.   }

procedure TForm1.WMCheckDataFS(var Msg: TMessage);
begin
  CheckDataCDFS;
end;

{ WMMinimize -------------------------------------------------------------------

  Wird WM_Minimize empfangen, soll das Hauptfenster minimiert werden.   }

procedure TForm1.WMMinimize(var Msg: TMessage);
begin
  FSettings.CmdLineFlags.Minimize := True;
end;


{ Lesen/Speichern der Einstellungen ------------------------------------------ }

{ GetSettings ------------------------------------------------------------------

  GetSettings setzt die Controls des Fensters entsprechend den Daten in
  FSettings.                                                                   }

procedure TForm1.GetSettings;
begin
  {allgemein}
  MainMenuReloadDefaults.Enabled := FSettings.FileFlags.IniFileOk;
  CheckBoxDummy.Checked := FSettings.Cdrecord.Dummy;
  {Data-CD}
  with FSettings.DataCD do
  begin
    CheckBoxDataCDVerify.Checked := Verify;
  end;
  {XCD}
  with FSettings.XCD do
  begin
    CheckBoxXCDVerify.Checked := Verify;
  end;
  {CDRW}
  with FSettings.CDRW do
  begin
    RadioButtonCDRWBlankAll.Checked         := All;
    RadioButtonCDRWBlankFast.Checked        := Fast;
    RadioButtonCDRWBlankOpenSession.Checked := OpenSession;
    RadioButtonCDRWBlankSession.Checked     := BlankSession;
    CheckBoxCDRWBlankForce.Checked          := Force;
  end;
  {CDInfos}
  with FSettings.CDInfo do
  begin
    RadioButtonScanbus.Checked  := Scanbus;
    RadioButtonPrcap.Checked    := Prcap;
    RadioButtonToc.Checked      := Toc;
    RadioButtonAtip.Checked     := Atip;
    RadioButtonMSInfo.Checked   := MSInfo;
    RadioButtonCapacity.Checked := CapInfo;
  end;
  {DAE}
  with FSettings.DAE do
  begin
    CheckBoxDAEBulk.Checked        := Bulk;
    CheckBoxDAELibParanoia.Checked := Paranoia;
    CheckBoxDAENoInfofiles.Checked := NoInfoFile;
    EditDAEPath.Text               := Path;
    EditDAEPrefix.Text             := Prefix;
  end;
  {Image}
  RadioButtonImageRead.Checked := FSettings.General.ImageRead;
  RadioButtonImageWrite.Checked := not FSettings.General.ImageRead;  
  with FSettings.Readcd do
  begin
    EditReadCDIsoPath.Text        := IsoPath;
    EditReadCDStartSec.Text       := StartSec;
    EditReadCDEndSec.Text         := EndSec;
    CheckBoxReadCDNoerror.Checked := Noerror;
    CheckBoxReadCDNocorr.Checked  := Nocorr;
    CheckBoxReadCDClone.Checked   := Clone;
    CheckBoxReadCDRange.Checked   := Range;
  end;
  with FSettings.Image do
  begin
    EditImageIsoPath.Text          := IsoPath;
    RadioButtonImageTAO.Checked    := TAO;
    RadioButtonImageDAO.Checked    := DAO;
    RadioButtonImageRAW.Checked    := RAW;
    if RawMode = 'raw96r' then
    begin
      RadioButtonImageRaw96r.Checked := True;
    end else
    if RawMode = 'raw96p' then
    begin
      RadioButtonImageRaw96p.Checked := True;
    end else
    if RawMode = 'raw16' then
    begin
      RadioButtonImageRaw16.Checked := True;
    end;
    CheckBoxImageOverburn.Checked := Overburn;
    CheckBoxImageClone.Checked := Clone;
  end;
  {DVD-Video}
  with FSettings.DVDVideo do
  begin
    EditDVDVideoSourcePath.Text := SourcePath;
  end;
end;

{ SetSettings ------------------------------------------------------------------

  SetSettings �bernimmt die Einstellungen der Controls in FSettings.           }

procedure TForm1.SetSettings;
var i: Integer;

  {Der �bersichtlichkeit wegen wurde die Bestimmung des gew�hlten Laufwerks und
   der Geschwindigkeit in eigene Funktionen ausgelagert.}
  function GetDevice(Choice: Byte): string;
  var Index: Byte;
      DeviceList: TStringList;
  begin
    with FDevices do
    begin
      case Choice of
        cDataCD,
        cAudioCD,
        cXCD,
        cCDRW,
        cVideoCD,
        cDVDVideo: DeviceList := CDWriter;
        cCDInfos : DeviceList := CDDevices;
        cDAE     : DeviceList := CDDevices;
      else
        if RadioButtonImageRead.Checked then
        begin
          DeviceList := CDDevices;
        end else
        begin
          DeviceList := CDWriter;
        end;
      end;
      Index := FSettings.General.TabSheetDrive[Choice];
      Result := DeviceList.Values[DeviceList.Names[Index]];
    end;
  end;

  function GetSpeed(Choice: Byte): string;
  var Index: Integer;
  begin
    Result := '';
    Index := FSettings.General.TabSheetSpeed[Choice];
    if Index <> -1 then
    begin
      Result := ComboBoxSpeed.Items[Index]
    end;
  end;

begin
  {allgemein}
  FSettings.Cdrecord.Dummy := CheckBoxDummy.Checked;
  {Data-CD}
  with FSettings.DataCD do
  begin
    Verify := CheckBoxDataCDVerify.Checked;
    Device := GetDevice(cDataCD);
    Speed  := GetSpeed(cDataCD);
    VolId  := FData.GetCDLabel(cDataCD);
  end;
  {Audio-CD}
  with FSettings.AudioCD do
  begin
    Device := GetDevice(cAudioCD);
    Speed  := GetSpeed(cAudioCD);
  end;
  {xCD}
  with FSettings.XCD do
  begin
    Verify := CheckBoxXCDVerify.Checked;
    Device := GetDevice(cXCD);
    Speed  := GetSpeed(cXCD);
    VolId  := FData.GetCDLabel(cXCD);
  end;
  {CDRW}
  with FSettings.CDRW do
  begin
    All          := RadioButtonCDRWBlankAll.Checked;
    Fast         := RadioButtonCDRWBlankFast.Checked;
    OpenSession  := RadioButtonCDRWBlankOpenSession.Checked;
    BlankSession := RadioButtonCDRWBlankSession.Checked;
    Force        := CheckBoxCDRWBlankForce.Checked;
    Device       := GetDevice(cCDRW);
  end;
  {CDInfos}
  with FSettings.CDInfo do
  begin
    Scanbus := RadioButtonScanbus.Checked;
    Prcap   := RadioButtonPrcap.Checked;
    Toc     := RadioButtonToc.Checked;
    Atip    := RadioButtonAtip.Checked;
    MSInfo  := RadioButtonMSInfo.Checked;
    CapInfo := RadioButtonCapacity.Checked;
    Device  := GetDevice(cCDInfos);
  end;
  {DAE}
  with FSettings.DAE do
  begin
    Bulk       := CheckBoxDAEBulk.Checked;
    Paranoia   := CheckBoxDAELibParanoia.Checked;
    NoInfoFile := CheckBoxDAENoInfofiles.Checked;
    Path       := EditDAEPath.Text;
    Prefix     := EditDAEPrefix.Text;
    Device     := GetDevice(cDAE);
    Speed      := GetSpeed(cDAE);
    {ausgw�hlte Tracks merken}
    Tracks := '';
    for i := 0 to (DAEListView.Items.Count - 1) do
    begin
      if DAEListView.Items[i].Selected then
      begin
        Tracks := Tracks + IntToStr(i + 1) + ',';
      end;
    end;
  end;
  {Image}
  FSettings.General.ImageRead := RadioButtonImageRead.Checked;
  with FSettings.Readcd do
  begin
    IsoPath  := EditReadCDIsoPath.Text;
    StartSec := EditReadCDStartSec.Text;
    EndSec   := EditReadCDEndSec.Text;
    Noerror  := CheckBoxReadCDNoerror.Checked;
    Nocorr   := CheckBoxReadCDNocorr.Checked;
    Clone    := CheckBoxReadCDClone.Checked;
    Range    := CheckBoxReadCDRange.Checked;
    Device   := GetDevice(cCDImage);
    Speed    := GetSpeed(cCDImage);
  end;
  with FSettings.Image do
  begin
    IsoPath    := EditImageIsoPath.Text;
    TAO        := RadioButtonImageTAO.Checked;
    DAO        := RadioButtonImageDAO.Checked;
    RAW        := RadioButtonImageRAW.Checked;
    if RadioButtonImageRaw96r.Checked then
    begin
      RawMode := 'raw96r';
    end else
    if RadioButtonImageRaw96p.Checked then
    begin
      RawMode := 'raw96p';
    end else
    if  RadioButtonImageRaw16.Checked then
    begin
      RawMode := 'raw16';
    end;
    OverBurn := CheckBoxImageOverburn.Checked;
    Clone    := CheckBoxImageClone.Checked;
    Device   := GetDevice(cCDImage);
    Speed    := GetSpeed(cCDImage);
  end;
  {Video-CD}
  with FSettings.VideoCD do
  begin
    Device   := GetDevice(cVideoCD);
    Speed    := GetSpeed(cVideoCD);
  end;
  {DVD-Video}
  with FSettings.DVDVideo do
  begin
    SourcePath := EditDVDVideoSourcePath.Text;
    Device   := GetDevice(cDVDVideo);
    Speed    := GetSpeed(cDVDVideo);
  end;
end;

{ InputOk ----------------------------------------------------------------------

  InputOk �berpr�ft die eingaben auf G�ltigkeit bzw. ob alle n�tigen Infos
  vorhanden sind.                                                              }

function TForm1.InputOk: Boolean;
begin
  Result := CheckProject(FData, FSettings, FLang);
end;

{ SaveProject ------------------------------------------------------------------

  SaveProject speichert die aktuellen Einstellungen und Dateilisten oder nur die
  Dateilisten, wenn ListsOnly = True. Aufruf erfolgt vom Hauptmen� aus.        }

procedure TForm1.SaveProject(const ListsOnly: Boolean);
begin
  if not ListsOnly then SetSettings;
  SaveDialog1 := TSaveDialog.Create(Form1);
  if not ListsOnly then
  begin
    SaveDialog1.Title := FLang.GMS('m107');
    SaveDialog1.DefaultExt := 'cfp';
    SaveDialog1.Filter := FLang.GMS('f006');
  end else
  begin
    SaveDialog1.Title := FLang.GMS('m121');
    SaveDialog1.DefaultExt := 'cfp.files';
    SaveDialog1.Filter := FLang.GMS('f008');
  end;
  SaveDialog1.Options := [ofOverwritePrompt,ofHideReadOnly];
  if SaveDialog1.Execute then
  begin
    if not ListsOnly then
    begin
      FSettings.SaveToFile(SaveDialog1.FileName);
      FData.SaveToFile(SaveDialog1.FileName + '.files');
    end else
    begin
      FData.SaveToFile(SaveDialog1.FileName);
    end;
  end;
  SaveDialog1.Free;
end;

{ LoadProject ------------------------------------------------------------------

  LoadProject l�dt Einstellungen und Dateilisten oder nur die Dateilisten, wenn
  ListsOnly = True. Aufruf erfolgt vom Hauptmen� aus.                          }

procedure TForm1.LoadProject(const ListsOnly: Boolean);
var i: Byte;
begin
  OpenDialog1 := TOpenDialog.Create(Form1);
  if not ListsOnly then
  begin
    OpenDialog1.Title := FLang.GMS('m106');
    OpenDialog1.Filter := FLang.GMS('f006');
  end else
  begin
    OpenDialog1.Title := FLang.GMS('m120');
    OpenDialog1.Filter := FLang.GMS('f008');
  end;
  if OpenDialog1.Execute then
  begin
    if not ListsOnly then
    begin
      FSettings.LoadFromFile(OpenDialog1.FileName);
      FData.LoadFromFile(OpenDialog1.FileName + '.files', FSettings.Shared);
    end else
    begin
      FData.LoadFromFile(OpenDialog1.FileName, FSettings.Shared);
    end;
  end;
  OpenDialog1.Free;
  if not ListsOnly then
  begin
    GetSettings;
    CheckControls;
  end;
  i := FSettings.General.Choice;
  {jetzt die Daten in GUI �bernehmen}
  InitTreeViews;
  CDETreeView.Items[0].Expand(False);
  XCDETreeView.Items[0].Expand(False);
  FSettings.General.Choice := cAudioCD;
  ShowTracks;
  FSettings.General.Choice := cDAE;    
  ShowTracksDAE;
  FSettings.General.Choice := cVideoCD;
  ShowTracks;
  FSettings.General.Choice := i;
  ActivateTab(FSettings.General.Choice);
  UpdateOptionPanel;
  UpdateGauges;
end;


{ Bearbeitung der Dateilisten ------------------------------------------------ }

{ CheckDataCDFS ----------------------------------------------------------------

  CheckDataCDFS �berpr�ft das Dateisystem der Daten-CD auf zu lange Dateinamen
  und zu tief liegende Ordner.                                                 }

procedure TForm1.CheckDataCDFS;
var OldStatusText: string;
    Path: string;
    CheckFolder: Boolean;
    FormDataCDFSError: TFormDataCDFSError;
begin
  OldStatusText := Form1.StatusBar.Panels[0].Text;
  Form1.StatusBar.Panels[0].Text := FLang.GMS('m118');
  {zu �berpr�fenden Ordner ermitteln}
  Path := GetPathFromNode(CDETreeView.Selected);
  {Verzeichnistiefe pr�fen?}
  with FSettings.DataCD do
  begin
    {Anmerkung: Erlaubt UDF wirklich beliebig tief liegende Ordner?}
    CheckFolder := not (ISODeepDir or (ISOLevel and (ISOLevelNr = 4)) or UDF);
  end;
  FData.CheckDataCDFS(Path, FSettings.GetMaxFileNameLength, CheckFolder);
  {$IFDEF DebugErrorLists}
  FormDebug.Memo2.Lines.Assign(FData.ErrorListFiles);
  FormDebug.Memo1.Lines.Assign(FData.ErrorListDir);
  {$ENDIF}
  {Wenn Fehler gefunden, dann Dialog aufrufen}
  if FData.ErrorListFiles.Count > 0 then
  begin
    FormDataCDFSError := TFormDataCDFSError.Create(nil);
    try
      FormDataCDFSError.Data := FData;
      FormDataCDFSError.ImageLists := FImageLists;
      FormDataCDFSError.Lang := FLang;
      FormDataCDFSError.Settings := FSettings;
      FormDataCDFSError.Mode := mFiles;
      FormDataCDFSError.ShowModal;
      {Ordner sortieren, Namen k�nnten sich ge�ndert haben}
      FData.SortFolder('', cDataCD);
      {Und eventuelle �nderungen im GUI nachvollziehen}
      UserAddFolderUpdateTree(CDETreeView);
    finally
      FormDataCDFSError.Release;
    end;
  end;
  {Verschachtelung der Ordner pr�fen, falls zu tief, dann Dialog}
  if FData.ErrorListDir.Count > 0 then
  begin
    FormDataCDFSError := TFormDataCDFSError.Create(nil);
    try
      FormDataCDFSError.Data := FData;
      FormDataCDFSError.ImageLists := FImageLists;
      FormDataCDFSError.Lang := FLang;
      FormDataCDFSError.Settings := FSettings;
      FormDataCDFSError.Mode := mFolders;
      FormDataCDFSError.ShowModal;
    finally
      FormDataCDFSError.Release;
    end;
  end;
  Form1.StatusBar.Panels[0].Text := OldStatusText;
end;

{ AddToPathlist ----------------------------------------------------------------

  AddToPathlist f�gt Dateien oder Ordner in die Pfadlisten ein, wenn die Aktion
  �ber die Kommandozeile oder per Drag-and-Drop ausgel�st wurde. Hierbei
  auftretende Fehler werden direkt im Memo angezeigt und nicht �ber eine eigene
  Message-Box.                                                                 }

procedure TForm1.AddToPathList(const FileName: string);
var ErrorCode: Byte;
    Path: string;
begin
  {sicherstellen, da� ein Knoten selektiert ist, und Pfad bestimmen}
  case FSettings.General.Choice of
    cDataCD : begin
                SelectRootIfNoneSelected(CDETreeView);
                Path := GetPathFromNode(CDETreeView.Selected);
              end;
    cXCD    : begin
                SelectRootIfNoneSelected(XCDETreeView);
                Path := GetPathFromNode(XCDETreeView.Selected);
              end;
    cAudioCD: Path := '';
    cVideoCD: Path := '';
  end;
  {$IFDEF DebugAddFilesDragDrop}
  Deb('Dateiname: ' + FileName, 3);
  Deb('Pfad     : ' + Path, 3);
  Deb('Choice   : ' + IntToStr(FSettings.General.Choice), 3);
  Deb('', 3);
  {$ENDIF}
  {Datei/Ordner hinzuf�gen}
  FData.AddToPathlist(FileName, Path, FSettings.General.Choice);
  {Fehler auswerten}
  ErrorCode := FData.LastError;
  with Form1.Memo1.Lines do
  begin
    case ErrorCode of
      PD_FolderNotUnique: Add(Format(FLang.GMS('e111'), [FileName]));
      PD_FileNotUnique  : Add(Format(FLang.GMS('e112'), [FileName]));
      PD_InvalidWaveFile: Add(Format(FLang.GMS('eprocs01'), [FileName]));
      PD_FileNotFound   : Add(Format(FLang.GMS('e113'), [FileName]));
      PD_InvalidMpegFile: Add(Format(FLang.GMS('eprocs02'), [FileName]));      
    end;
  end;
end;

{ AddToPathlistSort ------------------------------------------------------------

  AddToPathlistSort sortiert die Dateilisten, nachdem �ber AddToPathlist Dateien
  hinzugef�gt wurden. Au�erdem wird das GUI aktualisiert.                      }

procedure TForm1.AddToPathlistSort(const FolderAdded: Boolean);
var Path: string;
begin
  {Ordner sortieren}
  case FSettings.General.Choice of
    cDataCD: begin
               Path := GetPathFromNode(CDETreeView.Selected);
               FData.SortFileList(Path, cDataCD);
               {Dateisystem pr�fen}
               CheckDataCDFS;
             end;
    cXCD   : begin
               Path := GetPathFromNode(XCDETreeView.Selected);
               FData.SortFileList(Path, cXCD);
             end;
  end;
  {GUI aktualisieren}
  case FSettings.General.Choice of
    cDataCD : if FolderAdded then
              begin
                UserAddFolderUpdateTree(CDETreeView);
              end else
              begin
                ShowFolderContent(CDETreeView, CDEListView);
              end;
    cXCD    : if FolderAdded then
              begin
                UserAddFolderUpdateTree(XCDETreeView);
              end else
              begin
                ShowFolderContent(XCDETreeView, XCDEListView1);
              end;
    cAudioCD,
    cVideoCD: ShowTracks;
  end;
  UpdateGauges;
end;

{ UserAddFile ------------------------------------------------------------------

  UserAddFile f�gt eine Datei hinzu, wenn die Aktion �ber das GUI ausgel�st
  wurde.                                                                       }

procedure TForm1.UserAddFile(Tree: TTreeView);
var i: integer;
    Path: string;
    ErrorCode: Byte;
begin
  {sicherstellen, da� ein Knoten im Tree-View selektiert ist}
  SelectRootIfNoneSelected(Tree);
  Form1.OpenDialog1 := TOpenDialog.Create(Form1);
  case FSettings.General.Choice of
    cDataCD: Form1.OpenDialog1.Title := FLang.GMS('m103');
    cXCD   : begin
               if FSettings.General.XCDAddMovie then
               begin
                 Form1.OpenDialog1.Title := FLang.GMS('m105');
                 Form1.OpenDialog1.Filter := FLang.GMS('f005');
               end else
               begin
                 Form1.OpenDialog1.Title := FLang.GMS('m103');
               end;
             end;
  end;
  Form1.OpenDialog1.Options := [ofAllowMultiSelect, ofFileMustExist];
  if Form1.OpenDialog1.Execute then
  begin
    Form1.StatusBar.Panels[0].Text := FLang.GMS('m116');
    {Flag setzen, wenn 'normale' Dateien als Form2-Dateien ausgew�hlt werden}
    if Form1.OpenDialog1.FilterIndex > 1 then
    begin
      FData.AddAsForm2 := True;
    end;
    {Pfad des gew�hlten Knotens feststellen}
    Path := GetPathFromNode(Tree.Selected);
    for i :=0 to Form1.OpenDialog1.Files.Count - 1 do
    begin
      FData.AddToPathlist(OpenDialog1.Files[i], Path, FSettings.General.Choice);
      ErrorCode := FData.LastError;
      if ErrorCode = PD_FileNotUnique then
      begin
        Application.MessageBox(PChar(Format(FLang.GMS('e112'),
                                            [OpenDialog1.Files[i]])),
                               PChar(Flang.GMS('g001')),
                               MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
      end;
    end;
    {Dateiliste sortieren}
    FData.SortFileList(Path, Fsettings.General.Choice);
    if FSettings.General.Choice = cDataCD then
    begin
      CheckDataCDFS;
    end;
    UpdateGauges;
  end;
  Form1.OpenDialog1.Free;
  {XCD-Flags zur�cksetzen}
  if FSettings.General.Choice = cXCD then
  begin
    FSettings.General.XCDAddMovie := False;
    FData.AddAsForm2 := False;
  end;
end;

{ UserAddFolder ----------------------------------------------------------------

  UserAddFolder f�gt einen Ordner hinzu, wenn die Aktion �ber das GUI aus-
  gel�st wurde.                                                                }

procedure TForm1.UserAddFolder(Tree: TTreeView);
var dir: string;
    Name: string;
    Path: string;
    ErrorCode: Byte;
begin
  {sicherstellen, da� ein Knoten selektiert ist}
  SelectRootIfNoneSelected(Tree);
  dir := ChooseDir(FLang.GMS('g002'), Form1.Handle);
  Name := dir;
  Delete(Name, 1, LastDelimiter('\', Name));
  if dir <> '' then
  begin
    {$IFDEF ShowTimeAddFolder}
    TC.StartTimeCount;
    {$ENDIF}
    Path := GetPathFromNode(Tree.Selected);
    Form1.StatusBar.Panels[0].Text := FLang.GMS('m117');
    {$IFDEF DebugAddFiles}
    Deb('', 3);
    Deb('calling AddToPathlist: add folder ' + dir + '; Choice is: ' +
        IntToStr(FSettings.General.Choice), 3);
    {$ENDIF}
    FData.AddToPathlist(dir, Path, FSettings.General.Choice);
    ErrorCode := FData.LastError;
    {$IFDEF ShowTimeAddFolder}
    TC.StopTimeCount;
    Form1.Memo1.Lines.Add('add folder: ' + TC.TimeAsString);
    {$ENDIF}
    if ErrorCode = PD_FolderNotUnique then
    begin
      Application.MessageBox(PChar(Format(FLang.GMS('e111'), [Name])),
                             PChar(FLang.GMS('g001')),
                             MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
    end else
    begin
      {�nderungen im GUI nachvollziehen}
      UserAddFolderUpdateTree(Tree);
      CheckDataCDFS;
      UpdateGauges;
    end;
  end;
end;

{ UserAddFolderUpdateTree ------------------------------------------------------

  Nach dem Hinzuf�gen eines Ordners mu� die Baumstruktur auf den neuesten Stand
  gebraht werden.                                                              }

procedure TForm1.UserAddFolderUpdateTree(Tree: TTreeView);
var Path: string;
    Node: TTreeNode;
begin
  Path := GetPathFromNode(Tree.Selected);
  InitTreeView(Tree, FSettings.General.Choice);
  Node := GetNodeFromPath(Tree.Items[0], Path);
  Tree.Selected := Node;
  Node.Expand(False);
  case FSettings.General.Choice of
    cDataCD: ShowFolderContent(CDETreeView, CDEListView);
    cXCD   : ShowFolderContent(XCDETreeView, XCDEListView1);
  end;
end;

{ UserDeleteFile ---------------------------------------------------------------

  UserDeleteFile entfernt die im List-View selektierten Dateien aus dem ListView
  und der Dateiliste des TreeViews.                                            }

procedure TForm1.UserDeleteFile(Tree: TTreeView; View: TListView);
var i: Integer;
    Meldung: string;
    Path: string;
    {$IFDEF DebugFileLists}
    FileList: TStringList;
    {$ENDIF}
begin
  if View.SelCount > 0 then
  begin
    Meldung := FLang.GMS('m115');
    i := Application.MessageBox(PChar(Meldung), PChar(FLang.GMS('m110')),
           MB_OKCANCEL or MB_SYSTEMMODAL or MB_ICONQUESTION);
    if i = 1 then
    begin
      if FSettings.General.Choice in [cDataCD, cXCD] then
      begin
        Path := GetPathFromNode(Tree.Selected);
      end;
      if View.Selected <> nil then
      begin
        for i := (View.Items.Count - 1) downto 0 do
        begin
          if View.Items[i].Selected then
          begin
            with FSettings.General do
            begin
              if Choice = cDataCD then
              begin
                FData.DeleteFromPathlistByIndex(i, Path, Choice);
              end else
              if Choice = cXCD then
              begin
                FData.DeleteFromPathlistByName(View.Items[i].Caption,
                                               Path, Choice);
              end else
              if Choice = cAudioCD then
              begin
                FData.DeleteFromPathlistByIndex(i, '', cAudioCD);
              end;
              if Choice = cVideoCD then
              begin
                FData.DeleteFromPathlistByIndex(i, '', cVideoCD);
              end;
              {�nderung im GUI nachvollziehen}
              View.Items[i].Delete;
            end;
          end;
        end;
        UpdateGauges;
      end;
      {Debugging: interne Pfadliste anzeigen}
      {$IFDEF DebugFileLists}
      case FSettings.General.Choice of
        cDataCD : ShowFolderContent(Tree, View);
        cXCD    : ShowFolderContent(Tree, XCDEListView1);
        cAudioCD: begin
                    FileList := FData.GetFileList('', cAudioCD);
                    FormDebug.Memo2.Lines.Assign(FileList);
                  end;
        cVideoCD: begin
                    FileList := FData.GetFileList('', cVideoCD);
                    FormDebug.Memo2.Lines.Assign(FileList);
                  end;
      end;
      {$ENDIF}
    end;
  end;
end;

{ UserDeleteFolder -------------------------------------------------------------

  UserDeleteFolder entfernt den ausgew�hlten Ordner aus der Zusammenstellung
  Daten-CD bzw. XCD, es sei denn, es handelt sich um das Wurzelverzeichnis.    }

procedure TForm1.UserDeleteFolder(Tree: TTreeView);
var i: Integer;
    Meldung: string;
    Path: string;
begin
  Path := GetPathFromNode(Tree.Selected);
  if Path <> '' then
  begin
    Meldung := Format(FLang.GMS('m108'), [Tree.Selected.Text]);
    i := Application.MessageBox(PChar(Meldung), PChar(FLang.GMS('m110')),
           MB_OKCANCEL or MB_SYSTEMMODAL or MB_ICONQUESTION);
    if i = 1 then
    begin
      {Ordner aus Datenstruktur l�schen}
      FData.DeleteFolder(Path, FSettings.General.Choice);
      {entsprechenden Tree-Node l�schen}
      Tree.Selected.Delete;
      UpdateGauges;
    end;
  end;
end;

{ UserDeleteAll ----------------------------------------------------------------

  UserDeleteAll l�scht alle hinzugef�gten Dateien und Ordner.                  }

procedure TForm1.UserDeleteAll(Tree: TTreeView);
var i: Integer;
begin
  i := Application.MessageBox(
         PChar(FLang.GMS('m114')), PChar(FLang.GMS('m110')),
         MB_OKCANCEL or MB_SYSTEMMODAL or MB_ICONQUESTION);
  if i = 1 then
  begin
    Tree.Selected := Tree.Items[0];
    case FSettings.General.Choice of
      cDataCD: begin
                 FData.DeleteAll(cDataCD);
                 InitTreeView(Tree, cDataCD);
                 {sicherstellen, da� ein Knoten im Tree-View selektiert ist}
                 SelectRootIfNoneSelected(Tree);
                 ShowFolderContent(Tree, CDEListView);
               end;
      cXCD   : begin
                 FData.DeleteAll(cXCD);
                 InitTreeView(Tree, cXCD);
                 SelectRootIfNoneSelected(Tree);
                 ShowFolderContent(Tree, XCDEListView1);
               end;
    end;
    UpdateGauges;
  end;
end;

{ UserMoveFile -----------------------------------------------------------------

  UerMoveFile verschiebt Dateien aus einem Verzeichnis in ein anderes.         }

procedure TForm1.UserMoveFile(SourceNode, DestNode: TTreeNode; View: TListView);
var i: Integer;
    ErrorCode: Byte;
    SourcePath, DestPath: string;
begin
   SourcePath := GetPathFromNode(SourceNode);
   DestPath := GetPathFromNode(DestNode);
   for i := View.Items.Count - 1 downto 0 do
   begin
     if View.Items[i].Selected then
     begin
       case FSettings.General.Choice of
         cDataCD: FData.MoveFileByIndex(i, SourcePath, DestPath, cDataCD);
         cXCD   : FData.MoveFileByName(View.Items[i].Caption, SourcePath,
                                       DestPath, cXCD);
       end;
       ErrorCode := FData.LastError;
       if ErrorCode = PD_FileNotUnique then
       begin
         Application.MessageBox(PChar(Format(FLang.GMS('e112'),
                                             [View.Items[i].Caption])),
                                PChar(FLang.GMS('e108')),
                                MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
       end else
       begin
         {ge�nderte Dateiliste sortieren}
         FData.SortFileList(DestPath, FSettings.General.Choice);
         {�nderungen auch im GUI  nachvollziehen}
         View.Items.BeginUpdate;
         View.Items[i].Delete;
         View.Items.EndUpdate;
       end;
     end;
   end;
end;

{ UserMoveFolder ---------------------------------------------------------------

  UerMoveFolder verschiebt einen Ordner in einen anderen.                      }

procedure TForm1.UserMoveFolder(SourceNode, DestNode: TTreeNode);
var SourcePath, DestPath: string;
    ErrorCode: Byte;
begin
   SourcePath := GetPathFromNode(SourceNode);
   DestPath := GetPathFromNode(DestNode);
   FData.MoveFolder(SourcePath, DestPath, FSettings.General.Choice);
   ErrorCode := FData.LastError;
   if ErrorCode = PD_DestFolderIsSubFolder then
   begin
     Application.MessageBox(PChar(FLang.GMS('e109')), PChar(FLang.GMS('e108')),
                            MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
   end else
   if ErrorCode = PD_FolderNotUnique then
   begin
     Application.MessageBox(PChar(Format(FLang.GMS('e111'), [SourceNode.Text])),
                            PChar(FLang.GMS('e108')),
                            MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
   end else
   begin
     {Zielordner sortieren}
     FData.SortFolder(DestPath, FSettings.General.Choice);
     {�nderungen auch im GUI nachvollziehen}
     (DestNode.TreeView as TTreeView).Items.BeginUpdate;
     SourceNode.MoveTo(DestNode, naAddChild);
     DestNode.AlphaSort;
     (DestNode.TreeView as TTreeView).Items.EndUpdate;
   end;
end;

{ UserRenameFile ---------------------------------------------------------------

  Eine Datei umbenennen. Die eigentliche Auswertung wird im onEdited-Handler
  vorgenommen.                                                                 }

procedure TForm1.UserRenameFile(View: TListView);
begin
  if View.Selected <> nil then
  begin
    View.Selected.EditCaption;
  end;
end;

{ UserRenameFolderByKey --------------------------------------------------------

  UserRenameFolderByKey reagiert auf die Taste F2 und l�st das Umbenennen des
  CD-Lables oder eines Ordner aus.                                             }

procedure TForm1.UserRenameFolderByKey(Tree: TTreeView);
begin
  if Tree.Selected = Tree.Items[0] then
  begin
    UserSetCDLabel(Tree);
  end else
  begin
    UserRenameFolder(Tree);
  end;
end;

{ UserSetCDLabel ---------------------------------------------------------------

  Das Label der CD festelgen.                                                  }

procedure TForm1.UserSetCDLabel(Tree: TTreeView);
begin
  if Tree.Items[0] <> nil then
  begin
    Tree.Items[0].EditText;
  end;
end;

{ UserRenameFolder -------------------------------------------------------------

  Einen Ordner umbenennen. Die eigentliche Auswertung wird im onEdited-Handler
  vorgenommen.                                                                 }

procedure TForm1.UserRenameFolder(Tree: TTreeView);
begin
  if Tree.Selected <> Tree.Items[0] then
  begin
    Tree.Selected.EditText;
  end;
end;

{ UserSort ---------------------------------------------------------------------

  UserSort sortiert die Datei- oder die Ordnerlisten, wenn die Flags
  CDEFilesToSort oder FolderRenamed gesetzt sind. Aufruf erfolgt aus dem
  OnChanging-Event des TreeViews oder dem OnKeyDown-Event.
  Mit Force=True wird die Sortierung der Ordner erzwungen, auch wenn der
  aktuelle Ordner auf gleicher Ebene liegt, wie der umbenannte.                }

procedure TForm1.UserSort(Force: Boolean);
var Node: TTreeNode;
begin
  if FData.DataCDFilesToSort then
  begin
    {$IFDEF DebugSort}
    Node := GetNodeFromPath(CDETreeView.Items[0],
                            FData.DataCDFilesToSortFolder);
    Deb('sortiere Dateien im Ordner: ' + Node.Text, 3);
    {$ENDIF}
    FData.SortFileList(FData.DataCDFilesToSortFolder, cDataCD);
    FData.DataCDFilesToSort := False;
    FData.DataCDFilesToSortFolder := '';
    ShowFolderContent(CDETreeView, CDEListView);
  end;
  if FData.DataCDFoldersToSort then
  begin
    Node := GetNodeFromPath(CDETreeView.Items[0],
                            FData.DataCDFoldersToSortParent);
    if (Form1.CDETreeView.Selected.Parent <> Node) or Force then
    begin
      {$IFDEF DebugSort}
      with FormDebug.Memo3.Lines do
      begin
        Add('aktueller Ordner: ' + CDETreeView.Selected.Text);
        Add('1: sortiere Unterordner im Ordner: ' + Node.Text);
      end;
      {$ENDIF}
      FData.SortFolder(FData.DataCDFoldersToSortParent, cDataCD);
      Node.AlphaSort;
      FData.DataCDFoldersToSort := False;
      FData.DataCDFoldersToSortParent := '';
    end;
  end;
  if FData.XCDFoldersToSort then
  begin
    Node := GetNodeFromPath(XCDETreeView.Items[0],
                            FData.XCDFoldersToSortParent);
    if (Form1.XCDETreeView.Selected.Parent <> Node) or Force then
    begin
      {$IFDEF DebugSort}
      with FormDebug.Memo3.Lines do
      begin
        Add('aktueller Ordner: ' + XCDETreeView.Selected.Text);
        Add('3: sortiere Unterordner im Ordner: ' + Node.Text);
      end;
      {$ENDIF}
      FData.SortFolder(FData.XCDFoldersToSortParent, cXCD);
      Node.AlphaSort;
      FData.XCDFoldersToSort := False;
      FData.XCDFoldersToSortParent := '';
    end;
  end;
end;

{ UserNewFolder ----------------------------------------------------------------

  Einen neuen Ordner anlegen.                                                  }

procedure TForm1.UserNewFolder(Tree: TTreeView);
var Path: string;
    Name: string;
    Node: TTreeNode;
begin
  SelectRootIfNoneSelected(Tree);
  Path := GetPathFromNode(Tree.Selected);
  {Standardnamen f�r neue Ordner holen}
  Name := FLang.GMS('m111');
  FData.NewFolder(Path, Name, FSettings.General.Choice);
  Name := FData.LastFolderAdded;
  {�nderungen im GUI nachvollziehen}
  Node := Tree.Items.AddChild(Tree.Selected, Name);
  Node.ImageIndex := FImageLists.IconFolder;
  Node.SelectedIndex := FImageLists.IconFolderSelected;
  {Neuen Ordner benamsen und User die M�glichkeit zum Editieren geben.}
  Tree.Selected := Node;
  Tree.Selected.Focused := True;
  Tree.Selected.EditText;
  UpdateGauges;
end;

{ UserAddTrack -----------------------------------------------------------------

  UserAddTrack f�gt eine Audio-Datei oder eine MPEG-Datei zur Trackliste hinzu.
  Ausgel�st �ber GUI.                                                          }

procedure TForm1.UserAddTrack;
var i : integer;
    ErrorCode: Byte;
begin
  with Form1 do
  begin
    OpenDialog1 := TOpenDialog.Create(Form1);
    case FSettings.General.Choice of
      cAudioCD: begin
                  OpenDialog1.Title := FLang.GMS('m104');
                  OpenDialog1.DefaultExt := 'wav';
                  OpenDialog1.Filter := FLang.GMS('f004');
                end;
      cVideoCD: begin
                  OpenDialog1.Title := FLang.GMS('m105');
                  OpenDialog1.DefaultExt := 'mpg';
                  OpenDialog1.Filter := FLang.GMS('f009');
                end;
    end;
    OpenDialog1.Options := [ofAllowMultiSelect, ofFileMustExist];
    if OpenDialog1.Execute then
    begin
      for i :=0 to OpenDialog1.Files.Count - 1 do
      begin
        case FSettings.General.Choice of
          cAudioCD: FData.AddToPathlist(OpenDialog1.Files[i], '', cAudioCD);
          cVideoCD: FData.AddToPathlist(OpenDialog1.Files[i], '', cVideoCD);
        end;
        ErrorCode := FData.LastError;
        if ErrorCode = PD_InvalidWaveFile then
        begin
          Form1.Memo1.Lines.Add(Format(FLang.GMS('eprocs01'),
                                       [OpenDialog1.Files[i]]));
        end else
        if ErrorCode = PD_InvalidMpegFile then
        begin
          Form1.Memo1.Lines.Add(Format(FLang.GMS('eprocs02'),
                                       [OpenDialog1.Files[i]]));
        end;
      end;
    end;
    OpenDialog1.Free;
    ShowTracks;
    UpdateGauges;
  end;
end;

{ UserMoveTrack ----------------------------------------------------------------

  UserMoveTrack verschiebt einen Audio-Track um eine Position nach oben bzw.
  unten.                                                                       }

procedure TForm1.UserMoveTrack(List: TListView; const Direction: TDirection);
var TempItem: TListItem;
    Index: Integer;
    {$IFDEF DebugFileLists}
    FileList: TSTringList;
    {$ENDIF}
begin
  if List.SelCount > 0 then
  begin
    Index := List.Selected.Index;
    if Direction = dUp then
    begin
      if List.Selected.Index > 0 then
      begin
        FData.MoveTrack(Index, Direction, FSettings.General.Choice);
        {�nderungen im GUI nachvollziehen}
        TempItem := TListItem.Create(List.Items);
        TempItem.Assign(List.Items[Index]);
        List.Items[Index].Assign(List.Items[Index - 1]);
        List.Items[Index - 1].Assign(TempItem);
        List.Selected := nil;
        List.Selected := List.Items[Index - 1];
        TempItem.Free;
        if List.Selected.Index < List.TopItem.Index then
        begin
          List.Scroll(0, -40);
        end;
      end;
    end else
    if Direction = dDown then
    begin
      if List.Selected.Index < List.Items.Count - 1 then
      begin
        FData.MoveTrack(Index, Direction, FSettings.General.Choice);
        {�nderungen im GUI nachvollziehen}
        TempItem := TListItem.Create(List.Items);
        TempItem.Assign(List.Items[Index]);
        List.Items[Index].Assign(List.Items[Index + 1]);
        List.Items[Index + 1].Assign(TempItem);
        List.Selected := nil;
        List.Selected := List.Items[Index + 1];
        TempItem.Free;
        if List.Selected.Top > List.ClientHeight - 17 then
        begin
          List.Scroll(0, 40);
        end;
      end;
    end;
    {$IFDEF DebugFileLists}
    FileList := FData.GetFileList('', FSettings.General.Choice);
    FormDebug.Memo2.Lines.Assign(FileList);
    {$ENDIF}
  end;
end;


{ Anzeige der Dateilisten ---------------------------------------------------- }

{ AddItemToListView: -----------------------------------------------------------

  Anzeige der in den Dateilisten gespeicherten Dateien.
  Wenn Choice = [1|3] ist, die in den Pfadlisten gespeicherten Dateien werden im
  ListView angezeigt, incl. Gr��e, Typ und Icon und Herkunft.
  Wenn Choice = 2 ist, werden die Dateien in den AudioListView eingef�gt. Dabei
  werden Name, L�nge, Gr��e und Herkunft angezeigt.                            }

procedure TForm1.AddItemToListView(const Item: string; ListView: TListView);
var NewItem  : TListItem;
    IconIndex: Integer;
    Size     : {$IFDEF LargeFiles} Comp {$ELSE} Integer {$ENDIF};
    Name     : string;
    Caption  : string;
    Filetype : string;
    TrackLength: Extended;
begin
  if (FSettings.General.Choice = cDataCD) or
     (FSettings.General.Choice = cXCD) then
  begin
    ExtractFileInfoFromEntry(Item, Caption, Name, Size);
    NewItem := ListView.Items.Add;
    NewItem.Caption := Caption;
    FFileTypeInfo.GetFileInfo(Name, IconIndex, Filetype);
    NewItem.ImageIndex := IconIndex;
    {Verhindern, da� bei Dateien mit weniger als 512 Byte 0 KiByte angezeigt
     werden.}
    if (Size > 0) and (Size <= 512) then Size := Size + 512;
    Size := Round(Size / 1024);
    NewItem.SubItems.Add(FormatFloat('#,###,##0 ' + UnitKiByte, Size));
    NewItem.SubItems.Add(Filetype);
    NewItem.SubItems.Add(Name);
  end else
  if (FSettings.General.Choice = cAudioCD) or
     (FSettings.General.Choice = cVideoCD)  then
  begin
    ExtractTrackInfoFromEntry(Item, Caption, Name, Size, TrackLength);
    NewItem := ListView.Items.Add;
    NewItem.Caption := Caption;
    FFileTypeInfo.GetFileInfo(Name, IconIndex, Filetype);
    NewITem.ImageIndex := IconIndex;
    NewItem.SubItems.Add(FormatTime(TrackLength));
    Size := Round(Size / 1024);
    NewItem.SubItems.Add(FormatFloat('#,###,##0 ' + UnitKiByte, Size));
    NewItem.SubItems.Add(Name);
  end;
end;

{ ShowFolderContent ------------------------------------------------------------

  zeigt den Inhalt des selektierten Knotens im TreeView an:
  Tree: TreeView
  ListView: ListView, der den Inhalt darstellen soll                           }

procedure TForm1.ShowFolderContent(const Tree: TTreeView; ListView: TListView);
var i: Integer;
    Temp: string;
    Path: string;
    FileList: TStringList;
begin                              
  FileList := nil;
  {Pfad des gew�hlten Knotens feststellen}
  Path := GetPathFromNode(Tree.Selected);
  {Referenz auf Dateiliste holen, da die Tree-Views auch aktualisiert werden,
   wenn sie nicht angezeigt werden (z.B. beim Laden einer Projekt-Datei, mu�
   anhand des Namens und nicht anhand von FSettings.General.Choice entschieden
   werden.}
  if (Tree = CDETreeView) then
  begin
    FileList := FData.GetFileList(Path, cDataCD);
  end else
  if (Tree = XCDETreeView) then
  begin
    FileList := FData.GetFileList(Path, cXCD);
  end;
  {Debugging: interne Pfadliste anzeigen}
  {$IFDEF DebugFileLists}
  try
    if FileList <> nil then
    begin
      with FormDebug.Memo1.Lines do
      begin
        Add('aktueller Knoten im Tree-View  : ' + Tree.Selected.Text);
        Add('entsprechender Daten-Knoten    : ' +
            FData.GetFolderName(Path, FSettings.General.Choice));
        Add('Pfad                           : ' + Path);
        Add('Eintr�ge in der Dateiliste     : ' + IntToStr(FileList.Count));
      // Add('Unterordner                    : ' + IntToStr(Folder.ChildCount));
        Add('');
      end;
      FormDebug.Memo2.Lines.Assign(FileList);
    end;
  except
  end;
  {$ENDIF}

  {ListView f�llen, es sei denn, FileList ist nil (wenn Choice <> [1|3] aber
   trotzdem der selektierte Knoten ge�ndert wurde.}
  if FileList <> nil then
  begin
    if (Tree = CDETreeView) then
    begin
      ListView.Items.BeginUpdate;
      ListView.Items.Clear;
      for i := 0 to FileList.Count - 1 do
      begin
        AddItemToListView(FileList[i], ListView);
      end;
      ListView.Items.EndUpdate;
    end else
    if (Tree = XCDETreeView) then
    begin
      ListView.Items.BeginUpdate;
      ListView.Items.Clear;
      XCDEListView2.Items.BeginUpdate;
      XCDEListView2.Items.Clear;
      for i := 0 to FileList.Count - 1 do
      begin
        Temp := FileList[i];
        if Temp[Length(Temp)] = '>' then
        begin
          AddItemToListView(Temp, XCDEListView2);
        end else
        begin
          AddItemToListView(Temp, ListView);
        end;
      end;
      ListView.Items.EndUpdate;
      XCDEListView2.Items.EndUpdate;
    end;
  end;
end;

{ ShowTracks -------------------------------------------------------------------

  ShowTrack aktualisiert die Anzeige der ausgw�hlten Audio-Tracks.             }

procedure TForm1.ShowTracks;
var i: Integer;
    FileList: TStringList;
    ListView: TListView;
begin
  FileList := nil;
  ListView := nil;
  case FSettings.General.Choice of
    cAudioCD: begin
                ListView := AudioListView;
                FileList := FData.GetFileList('', cAudioCD);
              end;
    cVideoCD: begin
                ListView := VideoListView;
                FileList := FData.GetFileList('', cVideoCD);
              end;
  end;
  {Debugging: interne Pfadliste anzeigen}
  {$IFDEF DebugFileLists}
  try
    FormDebug.Memo2.Lines.Assign(FileList);
  except
  end;
  {$ENDIF}
  {m�glicherweise noch aktuell selektierten Track und Sichtbarkeit der Tracks
   merken.}
  ListView.Items.BeginUpdate;
  ListView.Items.Clear;
  for i := 0 to FileList.Count - 1 do
  begin
    AddItemToListView(FileList[i], ListView);
  end;
  ListView.Items.EndUpdate;
end;

{ ShowTracksDAE ----------------------------------------------------------------

  ShowTrackDAE aktualisiert die Anzeige der auf der CD vorhandenen Tracks.     }

procedure TForm1.ShowTracksDAE;
var i: Integer;
    TrackList: TStringList;
    NewItem: TListItem;
    Temp: string;
begin
  TrackList := FData.GetFileList('', cDAE);
  {Debugging: interne Pfadliste anzeigen}
  {$IFDEF DebugFileLists}
  try
    FormDebug.Memo2.Lines.Add('DAETrackList');
    FormDebug.Memo2.Lines.Assign(TrackList);
  except
  end;
  {$ENDIF}
  {m�glicherweise noch aktuell selektierten Track und Sichtbarkeit der Tracks
   merken.}
  DAEListView.Items.BeginUpdate;
  DAEListView.Items.Clear;
  for i := 0 to TrackList.Count - 1 do
  begin
    NewItem := DAEListView.Items.Add;
    NewItem.Caption := StringLeft(TrackList[i], ':');
    NewItem.ImageIndex := FImageLists.IconCDA;
    SplitString(TrackList[i], ':', Temp, Temp);
    NewItem.SubItems.Add(StringLeft(Temp, '*'));
    NewItem.SubItems.Add(StringRight(Temp, '*'));
  end;
  DAEListView.Items.EndUpdate;
end;


{ Hauptfenster: sonstiges ---------------------------------------------------- }

{ SaveWinPos -------------------------------------------------------------------

  speichert die aktuelle Position und Gr��e des Hauptfenster in FSettings.WinPos
  ab.                                                                          }

procedure TForm1.SaveWinPos;
begin
  {Fensterposition merken}
  with FSettings.WinPos do
  begin
    if self.WindowState = wsMaximized then
    begin
      MainMaximized := True;
    end else
    begin
      MainTop := self.Top;
      MainLeft := self.Left;
      MainWidth := self.Width;
      MainHeight := self.Height;
      MainMaximized := False;
    end;
  end;
end;

{ SetWinPos --------------------------------------------------------------------

  sofern Werte vorhanden sind, wird die Gr��e und Posiiton des Hauptfensters
  angepa�t.                                                                    }

procedure TForm1.SetWinPos;
begin
  {falls vorhanden, alte Gr��e und Position wiederherstellen}
  with FSettings.WinPos do
  begin
    if (MainWidth <> 0) and (MainHeight <> 0) then
    begin
      self.Top := MainTop;
      self.Left := MainLeft;
      self.Width := MainWidth;
      self.Height := MainHeight;
    end else
    begin
      {Falls keine Werte vorhanden, dann Fenster zentrieren. Die mu� hier
       manuell geschehen, da poScreenCenter zu Fehlern beim Setzen der
       Eigenschaften f�hrt. Deshalb mu� poDefault verwendet werden.}
      if (Screen.PixelsPerInch = 96) then
      begin
        self.Width := dWidth;
        self.Height := dHeight;
      end else
      if (Screen.PixelsPerInch > 96) then
      begin
        self.Width := dWidthBigFont;
        self.Height := dHeightBigFont;
      end;
      self.Top := (Screen.Height - self.Height) div 2;
      self.Left := (Screen.Width - self.Width) div 2;
    end;
    if MainMaximized then
    begin
      self.Position := poDefault;
      self.WindowState := wsMaximized;
    end;
  end;
end;

{ ActivateTab ------------------------------------------------------------------

  ActivateTab zeigt das gew�nschte TabSheet an.                                }

procedure TForm1.ActivateTab(const PageToActivate: Byte);
begin
  Form1.PageControl1.ActivePage := Form1.PageControl1.Pages[PageToActivate - 1];
  PageControl1Change(PageControl1);
end;

{ GetActivePage ----------------------------------------------------------------

  GetActivePage liefert als Ergebnis die Nummer der aktiven Registerkarte:
  Daten-CD: 1, Audio-CD: 2, XCD: 3, CD-RW: 4, CD-Infos: 5, DAE: 6, CD Image: 7,
  (S)Vide CD: 8, DVD Video: 9.}

function TForm1.GetActivePage: Byte;
begin
  Result := Form1.PageControl1.ActivePage.PageIndex + 1;
end;

{ UpateGauges ------------------------------------------------------------------

  UpdateGauges aktualisiert in Abh�ngigkeit des aktives TabSheets die
  Anzeige f�r Gesamtgr��e der ausgew�hlten Dateien bzw. Gesamtspielzeit.       }

procedure TForm1.UpdateGauges;
var FileCount, FolderCount, TrackCount: Integer;
    CDSize: {$IFDEF LargeProject} Comp {$ELSE} Longint {$ENDIF};
    CDTime: Extended;
    Temp: string;
begin
  FData.GetProjectInfo(FileCount, FolderCount, CDSize, CDTime, TrackCount,
                       FSettings.General.Choice);

  case FSettings.General.Choice of
    cDataCD,
    cXCD    : Temp := Format(FLang.GMS('m112'),
                             [FormatFloat('#,##0', FolderCount),
                              FormatFloat('#,##0', FileCount),
                              SizeToString(CDSize)]);

    cAudioCD: Temp := Format(FLang.GMS('m119'),
                             [FormatFloat('#,##0', TrackCount),
                              FormatTime(CDTime)]);
    cVideoCD: Temp := Format(FLang.GMS('m122'),
                             [FormatFloat('#,##0', TrackCount),
                              SizeToString(CDSize)]);
    {vielleicht noch Angaben bei cDAE: Anzahl Tracks/ gew�hlt}
  else
    Temp := '';
  end;
  StatusBar.Panels[0].Text := Temp;
  {$IFDEF DebugUpdateGauges}
  with FormDebug.Memo3.Lines do
  begin
    if FSettings.General.Choice in [cDataCD, cXCD] then
    begin
      Add('Dateien      : ' + IntToStr(FileCount));
      Add('Ordner       : ' + IntToStr(FolderCount));
      Add('Gesamtgr��e  : ' + SizeToString(CDSize));
      Add('MaxLevel     : ' +
          IntToStr(FData.GetProjectMaxLevel(FSettings.General.Choice)));
      if FSettings.General.Choice = cXCD then
      begin
        Add('Form2        : ' + IntToStr(FData.GetForm2FileCount));
        Add('Form2, klein : ' + IntToStr(FData.GetSmallForm2FileCount));
      end;
    end;
    if FSettings.General.Choice in [cAudioCD, cVideoCD] then
    begin
      Add('Tracks       : ' + IntToStr(TrackCount));
      Add('Spielzeit    : ' + FormatTime(CDTime));
      Add('Gesamtgr��e  : ' + SizeToString(CDSize));
    end;
    Add('');
  end;
  {$ENDIF}
end;

{ UpdateOptionPanel ------------------------------------------------------------

  UpdateOptionPanel aktualisiert die Anzeige der aktivierten Optionen auf dem
  jeweiligen Panel.                                                            }

procedure TForm1.UpdateOptionPanel;
var Temp: string;

  {lokale Prozedure zum Ver�ndern der Labels}
  procedure SetLabel(L: TLabel; Status: Boolean);
  begin
    {$IFNDEF AllowToggle}
    L.Enabled := Status;
    {$ELSE}
    if Status then
    begin
      L.Font.Color := clWindowText
    end else
    begin
      L.Font.Color := clGrayText;
    end;
    {$ENDIF}
  end;

begin
  if FSettings.General.Choice = cDataCD then
  begin
    with FSettings.DataCD do
    begin
      SetLabel(LabelDataCDSingle, not Multi);
      SetLabel(LabelDataCDMulti, Multi);
      SetLabel(LabelDataCDOTF, OnTheFly);
      SetLabel(LabelDataCDTAO, TAO);
      SetLabel(LabelDataCDDAO, DAO);
      SetLabel(LabelDataCDRAW, RAW);
      Temp := LabelDataCDJoliet.Caption;
      if Pos('(103)', Temp) > 0 then
      begin
        Delete(Temp, 7, 6);
      end;
      if JolietLong then
      begin
        Temp := Temp + ' (103)';
      end;
      LabelDataCDJoliet.Caption := Temp;
      SetLabel(LabelDataCDJoliet, Joliet);
      SetLabel(LabelDataCDRockRidge, RockRidge);
      SetLabel(LabelDataCDUDF, UDF);
      Temp := LabelDataCDISOLevel.Caption;
      if Temp[Length(Temp)] in ['1', '2', '3', '4'] then
      begin
        Delete(Temp, Length(Temp) - 1, 2);
      end;
      if ISOLevel then
      begin
        Temp := Temp + ' ' + IntToStr(IsoLevelNr);
        SetLabel(LabelDataCDISOLevel, True);
      end else
      begin
        SetLabel(LabelDataCDISOLevel, False);
      end;
      LabelDataCDISOLevel.Caption := Temp;
      SetLabel(LabelDataCDBoot, Boot);
      if (DAO or RAW) and Overburn then
      begin
        SetLabel(LabelDataCDOverburn, Overburn);
      end else
      begin
        SetLabel(LabelDataCDOverburn, False);
      end;
      LabelDataCDOverburn.Visible := not TAO;
    end;
    {$IFDEF DebugMaxFileNameLength}
    LabelDataCDBoot.Caption := 'boot ' +
                               IntToStr(FSettings.GetMaxFileNameLength);
    {$ENDIF}
  end;
  if FSettings.General.Choice = cAudioCD then
  begin
    with FSettings.AudioCD do
    begin
      SetLabel(LabelAudioCDSingle, not Multi and Fix);
      SetLabel(LabelAudioCDMulti, Multi and Fix);
      if (DAO or RAW) and Overburn then
      begin
        SetLabel(LabelAudioCDOverburn, Overburn);
      end else
      begin
        SetLabel(LabelAudioCDOverburn, False);
      end;
      if (DAO or RAW) and CDText then
      begin
        SetLabel(LabelAudioCDText, CDText);
      end else
      begin
        SetLabel(LabelAudioCDText, False);
      end;
      LabelAudioCDOverburn.Visible := not TAO;
      LabelAudioCDText.Visible := not TAO;
      SetLabel(LabelAudioCDTAO, TAO);
      SetLabel(LabelAudioCDDAO, DAO);
      SetLabel(LabelAudioCDRAW, RAW);
      SetLabel(LabelAudioCDPreemp, Preemp);
      SetLabel(LabelAudioCDUseInfo, UseInfo);
    end;
  end;
  if FSettings.General.Choice = cXCD then
  begin
    with FSettings.XCD do
    begin
      SetLabel(LabelXCDSingle, Single);
      SetLabel(LabelXCDIsoLevel1, IsoLevel1);
      SetLabel(LabelXCDIsoLevel2, IsoLevel2);
      SetLabel(LabelXCDKeepExt, KeepExt);
      SetLabel(LabelXCDOverburn, Overburn);
      SetLabel(LabelXCDCreateInfoFile, CreateInfoFile);
      LabelXCDCreateInfoFile.Visible := not (IsoLevel1 or IsoLevel2);
    end;
  end;
  if Fsettings.General.Choice = cVideoCD then
  begin
    with FSettings.VideoCD do
    begin
      SetLabel(LabelVideoCDVCD1, VCD1);
      SetLabel(LabelVideoCDVCD2, VCD2);
      SetLabel(LabelVideoCDSVCD, SVCD);
      SetLabel(LabelVideoCDOverburn, Overburn);
    end;
  end;
end;

{ ToggleOptions ----------------------------------------------------------------

  Beim Klick auf ein Label, das den Zustand einer Option darstellt, soll die
  Option umgeschaltet werden.                                                  }

{$IFDEF AllowToggle}
procedure TForm1.ToggleOptions(Sender: TObject);
var L: TLabel;
begin
  {Damit die Einstellungen der Checkboxen auf dem Hauptformular nicht verloren
   gehen, ist ein SetSettings n�tig.}
  SetSettings;
  L := Sender as TLabel;
  {Data-CD}
  with FSettings.DataCD do
  begin
    if (L = LabelDataCDSingle) or (L = LabelDataCDMulti) then
    begin
      Multi := not Multi;
      if Multi then RockRidge := True;
    end;
    if L = LabelDataCDOTF then
    begin
      OnTheFly := not OnTheFly and
                 (FSettings.FileFlags.ShOk or not FSettings.FileFlags.ShNeeded);
    end;
    if (L = LabelDataCDTAO) or (L = LabelDataCDDAO) or (L = LabelDataCDRAW) then
    begin
      TAO := L = LabelDataCDTAO;
      DAO := L = LabelDataCDDAO;
      RAW := L = LabelDataCDRAW;
    end;
    if L = LabelDataCDJoliet then
    begin
      if not Joliet then Joliet := True else
      if Joliet and not JolietLong then JolietLong := True else
      if Joliet and JolietLong then
      begin
        Joliet := False;
        JolietLong := False;
      end;
    end;
    if L = LabelDataCDRockRidge then
    begin
      RockRidge := not RockRidge;
      if not RockRidge then Multi := False;
    end;
    if L = LabelDataCDUDF then
    begin
      UDF := not UDF;
    end;
    if L = LabelDataCDISOLevel then
    begin
      if not ISOLevel then
      begin
        ISOLevel := True;
        ISOLevelNr := 1;
      end else
      if ISOLevel then
      begin
        ISOLevelNr := ISOLevelNr + 1;
        if ISOLevelNr = 5 then
        begin
          ISOLevelNr := 0;
          ISOLevel := False;
        end;
      end;
    end;
    if L = LabelDataCDBoot then
    begin
      FSettings.General.TempBoot := not Boot;
      if FSettings.General.TempBoot then ButtonDataCDOptionsFSClick(nil) else
        Boot := not Boot;
    end;
    if L = LabelDataCDOverburn then
    begin
      Overburn := not Overburn;
    end;
  end;
  {Audio-CD}
  with FSettings.AudioCD do
  begin
    if (L = LabelAudioCDSingle) or (L = LabelAudioCDMulti) then
    begin
      if Fix then Multi := not Multi;
    end;
    if L = LabelAudioCDOverburn then
    begin
      Overburn := not Overburn;
    end;
    if (L = LabelAudioCDTAO) or
       (L = LabelAudioCDDAO) or
       (L = LabelAudioCDRAW) then
    begin
      TAO := L = LabelAudioCDTAO;
      DAO := L = LabelAudioCDDAO;
      RAW := L = LabelAudioCDRAW;
    end;
    if L = LabelAudioCDPreemp then
    begin
      Preemp := not Preemp;
    end;
    if L = LabelAudioCDUseInfo then
    begin
      UseInfo := not UseInfo;
    end;
    if L = LabelAudioCDText then
    begin
      CDText := not CDText;
    end;
  end;
  {XCD}
  with FSettings.XCD do
  begin
    if L = LabelXCDSingle then
    begin
      Single := not Single;
    end;
    if L = LabelXCDIsoLevel1 then
    begin
      IsoLevel1 := not IsoLevel1;
      if IsoLevel1 then
      begin
        IsoLevel2 := False;
        CreateInfoFile := False;
      end
    end;
    if L = LabelXCDIsoLevel2 then
    begin
      IsoLevel2 := not IsoLevel2;
      if IsoLevel2 then
      begin
        IsoLevel1 := False;
        CreateInfoFile := False;
      end;
    end;
    if L = LabelXCDKeepExt then
    begin
      KeepExt := not KeepExt;
    end;
    if L = LabelXCDOverburn then
    begin
      Overburn := not Overburn;
    end;
    if L = LabelXCDCreateInfoFile then
    begin
      CreateInfoFile := not CreateInfoFile;
      if CreateInfoFile then
      begin
        IsoLevel1 := False;
        IsoLevel2 := False;
      end;
    end;
  end;
  {Video-CD}
  with FSettings.VideoCD do
  begin
    if L = LabelVideoCDOverburn then
    begin
      Overburn := not Overburn;
    end;
    if (L = LabelVideoCDVCD1) or
       (L = LabelVideoCDVCD2) or
       (L = LabelVideoCDSVCD) then
    begin
      VCD1 := L = LabelVideoCDVCD1;
      VCD2 := L = LabelVideoCDVCD2;
      SVCD := L = LabelVideoCDSVCD;
    end;
  end;
  {�nderungen �bernehmen}
  GetSettings;
  UpdateOptionPanel;
end;
{$ENDIF}

{ CheckControls ----------------------------------------------------------------

  CheckControls sorgt daf�r, da� bei den Controls keine inkonsistenten
  Einstellungen vorkommen.                                                     }

procedure TForm1.CheckControls;

  {lokale Prozeduren nur der �bersicht wegen.}
  procedure SetDrives(DeviceList: TStringList);
  var i: Integer;
  begin
    case FSettings.General.Choice of
      cDataCD,
      cAudioCD,
      cXCD,
      cCDRW,
      cVideoCD,
      cDVDVideo: begin
                   GroupBoxDrive.Caption := FLang.GMS('c002');
                   StaticTextSpeed.Caption := FLang.GMS('c001');
                   SpeedButtonFixCD.Visible := True;
                 end;
      cCDInfos,
      cDAE     : begin
                   GroupBoxDrive.Caption := FLang.GMS('c003');
                   StaticTextSpeed.Caption := FLang.GMS('c004');
                   SpeedButtonFixCD.Visible := False;
                 end;
    end;
    ComboBoxDrives.Items.Clear;
    for i := 0 to (DeviceList.Count - 1) do
    begin
      ComboBoxDrives.Items[i] := DeviceList.Names[i];
    end;
    i := FSettings.General.Choice;
    if ComboBoxDrives.Items.Count > FSettings.General.TabSheetDrive[i] then
    begin
      ComboBoxDrives.ItemIndex := FSettings.General.TabSheetDrive[i];
    end else
    begin
      ComboBoxDrives.ItemIndex := 0;
      FSettings.General.TabSheetDrive[i] := 0;
    end;
  end;

  {TabSheet3: XCD }
  procedure CheckControlsXCD;
  var i: Integer;
  begin
    if not FSettings.FileFlags.M2CDMOk then
    begin
      for i := 0 to PanelXCD.ControlCount - 1 do
      begin
        PanelXCD.Controls[i].Enabled := False;
      end;
      for i := 0 to TabSheet3.ControlCount - 1 do
      begin
        if TabSheet3.Controls[i] is TSpeedButton then
        begin
          TabSheet3.Controls[i].Visible := False;
        end else
        begin
          TabSheet3.Controls[i].Enabled := False;
        end;
      end;
    end;
  end;

  { TabSheet6: DAE }
  procedure CheckControlsDAE;
  var i: Integer;
  begin
    if not FSettings.FileFlags.Cdda2wavOk then
    begin
      for i := 0 to PanelDAE.ControlCount - 1 do
      begin
        PanelDAE.Controls[i].Enabled := False;
      end;
    end;
  end;

  { TabSheet7: Image schreiben/erstellen }
  procedure CheckControlsImage;
  var i: Integer;
      CUEImage: Boolean;
  begin
    {Laufwerksliste anpassen}
    if RadioButtonImageRead.Checked then
    begin
      SetDrives(FDevices.CDDevices);
      GroupBoxDrive.Caption := FLang.GMS('c003');
      StaticTextSpeed.Caption := FLang.GMS('c004');
      SpeedButtonFixCD.Visible := False;
    end else
    if RadioButtonImageWrite.Checked then
    begin
      SetDrives(FDevices.CDWriter);
      GroupBoxDrive.Caption := FLang.GMS('c002');
      StaticTextSpeed.Caption := FLang.GMS('c001');
      SpeedButtonFixCD.Visible := True;
    end;
    {Image erstellen}
    for i := 0 to GroupBoxReadCD.ControlCount - 1 do
    begin
      GroupBoxReadCD.Controls[i].Enabled :=
        RadioButtonImageRead.Checked and FSettings.FileFlags.ReadcdOk;
    end;
    {Sektoren}
    if RadioButtonImageRead.Checked then
    begin
      EditReadCDStartSec.Enabled := CheckBoxReadCDRange.Checked;
      EditReadCDEndSec.Enabled := CheckBoxReadCDRange.Checked;
      StaticTextReadCDStartSec.Enabled := CheckBoxReadCDRange.Checked;
      StaticTextReadCDEndSec.Enabled := CheckBoxReadCDRange.Checked;
    end;
    {Image schreiben: Controls h�ngen auch vom Typ des Images ab, Pr�fung aber
     nur vornehmen, wenn cdrdao oder cdrecord ab 2.01a24 vorhanden ist .}
    CUEImage := False; 
    if FSettings.FileFlags.CdrdaoOk or FSettings.Cdrecord.CanWriteCueImage then
    begin
      GroupBoxImage.Caption := FLang.GMS('c005');
      CUEImage := LowerCase(ExtractFileExt(EditImageIsoPath.text)) = cExtCue;
    end else
    begin
      GroupBoxImage.Caption := FLang.GMS('c006');
    end;
    if not (CUEImage and RadioButtonImageWrite.Checked) then
    begin
      {Normalfall: ISO-Image}
      for i := 0 to PanelImageWriteRawOptions.ControlCount - 1 do
      begin
        PanelImageWriteRawOptions.Controls[i].Enabled :=
          RadioButtonImageWrite.Checked;
      end;
      for i := 0 to GroupBoxImage.ControlCount - 1 do
      begin
        GroupBoxImage.Controls[i].Enabled := RadioButtonImageWrite.Checked;
      end;
      {Schreibmodus}
      if RadioButtonImageWrite.Checked then
      begin
        if RadioButtonImageTAO.Checked then
        begin
          CheckBoxImageOverburn.Enabled := False;
        end else
        begin
          CheckBoxImageOverburn.Enabled := True;
        end;
        if RadioButtonImageRAW.Checked then
        begin
          RadioButtonImageRaw96r.Enabled := True;
          RadioButtonImageRaw96p.Enabled := True;
          RadioButtonImageRaw16.Enabled := True;
          CheckBoxImageClone.Enabled := True;
        end else
        begin
          RadioButtonImageRaw96r.Enabled := False;
          RadioButtonImageRaw96p.Enabled := False;
          RadioButtonImageRaw16.Enabled := False;
          CheckBoxImageClone.Enabled := False;
        end;
      end;
    end else
    begin
      {Sonderfall: CUE-Image; Schreibmodus festgelegt, da cdrdao verwendet wird}
      for i := 0 to GroupBoxImage.ControlCount - 1 do
      begin
        GroupBoxImage.Controls[i].Enabled := RadioButtonImageWrite.Checked;
      end;
      RadioButtonImageTAO.Enabled := False;
      RadioButtonImageDAO.Enabled := False;
      RadioButtonImageRAW.Enabled := False;
      for i := 0 to PanelImageWriteRawOptions.ControlCount - 1 do
      begin
        PanelImageWriteRawOptions.Controls[i].Enabled := False;
      end;
      CheckBoxImageOverburn.Enabled := True;
      CheckBoxImageClone.Enabled := False;
    end;
  end;

  {TabSheet8: Video-CD }
  procedure CheckControlsVideoCD;
  var i: Integer;
  begin
    if not FSettings.FileFlags.VCDImOk then
    begin
      for i := 0 to PanelVideoCD.ControlCount - 1 do
      begin
        PanelVideoCD.Controls[i].Enabled := False;
      end;
      for i := 0 to TabSheet8.ControlCount - 1 do
      begin
        if TabSheet8.Controls[i] is TSpeedButton then
        begin
          TabSheet8.Controls[i].Visible := False;
        end else
        begin
          TabSheet8.Controls[i].Enabled := False;
        end;
      end;
    end;
  end;

begin
  case FSettings.General.Choice of
    cDataCD  : SetDrives(FDevices.CDWriter);
    cAudioCD : SetDrives(FDevices.CDWriter);
    cXCD     : begin
                 CheckControlsXCD;
                 SetDrives(FDevices.CDWriter);
               end;
    cCDRW    : SetDrives(FDevices.CDWriter);
    cCDInfos : SetDrives(FDevices.CDDevices);
    cDAE     : begin
                 CheckControlsDAE;
                 SetDrives(FDevices.CDDevices);
               end;
    cCDImage : CheckControlsImage;
    cVideoCD : begin
                 CheckControlsVideoCD;
                 SetDrives(FDevices.CDWriter);
               end;
    cDVDVideo: SetDrives(FDevices.CDWriter);
  end;
  ComboBoxSpeed.ItemIndex :=
    FSettings.General.TabSheetSpeed[FSettings.General.Choice];
end;

{ SetButtons -------------------------------------------------------------------

  SetButtons wird ben�tig, um die Buttons zu deaktivieren, wenn cdrtfe die
  externen Programme ausf�hrt.                                                 }

procedure TForm1.Setbuttons(const Status: TOnOff);
begin
  if Status = oOff then
  begin
    ButtonStart.Enabled := False;
    ButtonCancel.Enabled := False;
    ButtonSettings.Enabled := False;
    ButtonAbort.Visible := True;
    SpeedButtonFixCD.Enabled := False;
    self.Update; {damit die �nderngen sofort wirksam werden}
  end else
  begin
    ButtonStart.Enabled := True;
    ButtonCancel.Enabled := True;
    ButtonSettings.Enabled := True;
    ButtonAbort.Visible := False;
    SpeedButtonFixCD.Enabled := True;    
  end;
end;


{ Initialisierungen -----------------------------------------------------------}

{ InitMainform -----------------------------------------------------------------

  Diese Prozdedur initialisiert das Hauptfenster. Die Grafiken f�r die Speed-
  buttons werden geladen, die ImageListen an die Tree- und ListViews zugewiesen
  und Drag-and-Drop wird zugelassen.                                           }

procedure TForm1.InitMainform;

  {lokale Prozedur zum Registrieren der Label-OnClick-Eventhandler}
  {$IFDEF AllowToggle}
  procedure RegisterLabelEvents;
  var i: Integer;
      j: Integer;
      Panel: TPanel;
  begin
    for i := 0 to Form1.ComponentCount - 1 do
    begin
      if Form1.Components[i] is TPanel then
      begin
        Panel := Form1.Components[i] as TPanel;
        if (Panel = PanelDataCDOptions) or
           (Panel = PanelAudioCDOptions) or
           (Panel = PanelXCDOptions) or
           (Panel = PanelVideoCDOptions) then
        begin
         {$IFDEF MouseOverLabelHighlight}
          Panel.OnMouseMove := PanelMouseMove;
         {$ENDIF}
          for j := 0 to Panel.ControlCount - 1 do
          begin
            if Panel.Controls[j] is TLabel then
            begin
              (Panel.Controls[j] as TLabel).OnClick := LabelClick;
              {$IFDEF MouseOverLabelCursor}
              (Panel.Controls[j] as TLabel).Cursor:=crHandPoint;
              {$ENDIF}
              {$IFDEF MouseOverLabelHighlight}
              (Panel.Controls[j] as TLabel).OnMouseMove := LabelMouseMove;
              {$ENDIF}
            end;
          end;
        end;
      end;
    end;
  end;
  {$ENDIF}

begin
  {Drag'n'Drop f�r dieses Fenster zulassen}
  DragAcceptFiles(Form1.Handle, true);
  {Sonderbehandlung, falls gro�e Schriftarten verwendet werden}
  if Screen.PixelsPerInch > 96 then
  begin
    Form1.Width := 923;
    Form1.Height := 610;
  end;
  {Das sch�ne der beiden gro�en Icons f�r cdrtfe. Anscheinend �bergibt GetIcon
   nur ein Handle, daher mu� in FormDestroy Application.Icon.ReleaseHandle aus-
   gef�hrt werden, da sonst das Icon sowohl durch das TApplication als auch
   durch TImnageLists freigegeben wird, was einen Fehler (bei Memcheck)
   verursacht.}
  FImageLists.IconImages.GetIcon(0, Application.Icon);
  {Bitmap-Resourcen einlesen}
  CDESpeedButton1.Glyph.LoadFromResourceName(hInstance, 'B1');
  CDESpeedButton2.Glyph.LoadFromResourceName(hInstance, 'B2');
  CDESpeedButton3.Glyph.LoadFromResourceName(hInstance, 'B3');
  CDESpeedButton4.Glyph.LoadFromResourceName(hInstance, 'B4');
  CDESpeedButton5.Glyph.LoadFromResourceName(hInstance, 'B5');
  Sheet1SpeedButtonCheckFS.Glyph.LoadFromResourceName(hInstance, 'B6');
  AudioSpeedButton2.Glyph.LoadFromResourceName(hInstance, 'B7');
  AudioSpeedButton3.Glyph.LoadFromResourceName(hInstance, 'B8');
  {Wiederverwendung spart ein paar Bytes}
  AudioSpeedButton1.Glyph := CDESpeedButton1.Glyph;
  AudioSpeedButton4.Glyph := CDESpeedButton3.Glyph;
  XCDESpeedButton1.Glyph := CDESpeedButton1.Glyph;
  XCDESpeedButton2.Glyph := CDESpeedButton2.Glyph;
  XCDESpeedButton3.Glyph := CDESpeedButton3.Glyph;
  XCDESpeedButton4.Glyph := CDESpeedButton1.Glyph;
  XCDESpeedButton5.Glyph := CDESpeedButton3.Glyph;
  XCDESpeedButton6.Glyph := CDESpeedButton4.Glyph;
  XCDESpeedButton7.Glyph := CDESpeedButton5.Glyph;
  VideoSpeedButton1.Glyph := AudioSpeedButton1.Glyph;
  VideoSpeedButton2.Glyph := AudioSpeedButton2.Glyph;
  VideoSpeedButton3.Glyph := AudioSpeedButton3.Glyph;
  VideoSpeedButton4.Glyph := AudioSpeedButton4.Glyph;
  {Den Tree- und ListViews die Image-Listen zuweisen}
  CDEListView.LargeImages := FImageLists.LargeImages;
  CDEListView.SmallImages := FImageLists.SmallImages;
  CDETreeView.Images := FImageLists.IconImages;
  AudioListView.SmallImages := FImageLists.SmallImages;
  XCDEListView1.LargeImages := FImageLists.LargeImages;
  XCDEListView1.SmallImages := FImageLists.SmallImages;
  XCDEListView2.LargeImages := FImageLists.LargeImages;
  XCDEListView2.SmallImages := FImageLists.SmallImages;
  XCDETreeView.Images := FImageLists.IconImages;
  DAEListView.SmallImages := FImageLists.IconImages;
  DAEListView.LargeImages := FImageLists.IconImages;
  VideoListView.SmallImages := FImageLists.SmallImages;
  {OnClick-Event f�r Option-Labels zuweisen}
  {$IFDEF AllowToggle}
  RegisterLabelEvents;
  {$ENDIF}
end;

{ InitTreeView -----------------------------------------------------------------

  einen bestimmten Tree-View initialisieren.                                   }

procedure TForm1.InitTreeView(Tree: TTreeView; const Choice: Byte);
var i: Byte;
begin
  {hier mu� FSettings.General.Choice tempor�r gesetzt werden, um sicherzu-
   stellen, da� AddItemToListView funktioniert.}
  i := FSettings.General.Choice;
  FSettings.General.Choice := Choice;
  {TreeView-Tool-Tips abschalten}
  SetWindowLong(Tree.Handle, GWL_Style,
                GetWindowLong(Tree.Handle, GWL_Style) or TVS_NoTooltips);
  {alle Elemente l�schen}
  Tree.Items.Clear;
  {Datenstruktur in den Tree-View �bertragen}
  FData.ExportStructureToTreeView(Choice, Tree);
  Tree.Items[0].ImageIndex := FImageLists.IconCD;
  Tree.Items[0].SelectedIndex := FImageLists.IconCD;
  {verhindert einen Heisen-Bug beim Verschieben von Dateien: wenn keine
   Ordner selektiert sind, dann werden f�lschlicherweise im XCD-List-View die
   im CD-List-View bewegten Dateien angezeigt. Diese Anweisung stellt sicher,
   da� auch direkt nach dem Start, die Wurzelknoten selektiert sind.}
  SelectRootIfNoneSelected(Tree);
  FSettings.General.Choice := i;
end;

{ InitTreeViews ----------------------------------------------------------------

  InitTreeViews initialisiert alle Tree-Views.                                 }

procedure TForm1.InitTreeViews;
begin
  InitTreeView(CDETreeView, cDataCD);
  InitTreeView(XCDETreeView, cXCD);
end;


{ Eventverarbeitung ---------------------------------------------------------- }

{ eigene Events -------------------------------------------------------------- }

{ MessageShow ------------------------------------------------------------------

  MessageShow zeigt den in FSettings.Shared.MessageToShow abgelegten String an.
  Dieser Mechanismus wird genutzt, damit andere Forms oder Klassen im Memo des
  Hauptfensters Text anzeigen k�nnen, ohne frm_main.pas einzubinden und direkt
  auf die Form1.Controls zuzugreifen.
  Wahscheinlich gibt es eine bessere oder elegantere Methode. ;-)              }

procedure TForm1.MessageShow(Sender: TObject);
begin
  Memo1.Lines.Add(FSettings.Shared.MessageToShow);
  FSettings.Shared.MessageToShow := '';
end;

{ UpdatePanels -----------------------------------------------------------------

  UpdatePanels zeigt in den beidne Panels des Stauts-Bars die Strings
  FSettings.Shared.Panel1 und .Panel2 an. Wenn der String den Inhalt '<>' haben
  sollte, wird der Panel-Text nicht ge�ndert.                                  }

procedure TForm1.UpdatePanels(Sender: TObject);
begin
  if FSettings.Shared.Panel1 <> '<>' then
  begin
    StatusBar.Panels[0].Text := FSettings.Shared.Panel1;
  end;
  if FSettings.Shared.Panel2 <> '<>' then
  begin
    StatusBar.Panels[1].Text := FSettings.Shared.Panel2;
  end;
  FSettings.Shared.Panel1 := '';
  FSettings.Shared.Panel2 := '';
end;

{ ProgressBarHide --------------------------------------------------------------

  ProgressBarHide macht den Progress-Bar unsichtbar.                           }

procedure TForm1.ProgressBarHide(Sender: TObject);
begin
  ProgressBar.Visible := False;
end;

{ ProgressBarReset -------------------------------------------------------------

  ProgressBarReset setzt ProgressBar.Position auf Null, ProgressBar.Max auf
  FSettings.Shared.ProgressBarMax und ProgressBar.Visible auf True.            }

procedure TForm1.ProgressBarReset(Sender: TObject);
begin
  ProgressBar.Position := 0;
  ProgressBar.Max := FSettings.Shared.ProgressBarMax;
  ProgressBar.Visible := True;
end;

{ ProgressBarUpdate ------------------------------------------------------------

  ProgressBarReset setzt StatusBar.Position auf FSettings.Shared.
  ProgressBarPosition.                                                         }

procedure TForm1.ProgressBarUpdate(Sender: TObject);
begin
  ProgressBar.Position := FSettings.Shared.ProgressBarPosition;
end;


{ Form-Events ---------------------------------------------------------------- }

{ FormCreate -------------------------------------------------------------------

  Diese Prozedur wird beim Erzeugen des Fensters abgearbeitet. Hier werden not-
  wendige Initialisierungen vorgenommen.                                       }

procedure TForm1.FormCreate(Sender: TObject);
var DummyHandle: HWND;
    TempChoice: Byte;
begin
  FInstanceTermination := False;
  {Ein paar Objekte brauchen wir, egal ob es sich um die erste oder zweite
   Instanz handelt.}
  {Objekt mit Sprachinformationen}
  FLang := TLang.Create;
  with FLang do
  begin
    {Einheiten �bersetzen}
    SizeToStringSetUnits(GMS('g005'), GMS('g006'), GMS('g007'), GMS('g008'));
    MainMenuSetLang.Enabled := LangFileFound;
    {Spracheinstellungen setzen}
    SetFormLang(self);
  end;
  {Objekt mit den Laufwerksinfos}
  FDevices := TDevices.Create;
  {Objekt f�r Einstellungen}
  FSettings := TSettings.Create;
  FSettings.Lang := FLang;
  FSettings.OnUpdatePanels := UpdatePanels;
  FSettings.OnProgressBarHide := ProgressBarHide;
  FSettings.OnProgressBarReset := ProgressBarReset;
  FSettings.OnProgressBarUpdate := ProgressBarUpdate;
  {Datenobjekt}
  FData := TProjectData.Create;
  FData.Lang := FLang;
  FData.OnUpdatePanels := UpdatePanels;
  FData.OnProgressBarHide := ProgressBarHide;
  FData.OnProgressBarReset := ProgressBarReset;
  FData.OnProgressBarUpdate := ProgressBarUpdate;
  FData.OnMessageToShow := MessageShow;  
  {Kommandzeile auswerten}
  FCmdLineParser := TCmdLineParser.Create;
  FCmdLineParser.Settings := FSettings;
  FCmdLineParser.Data := FData;
  FCmdLineParser.FormCaption := Form1.Caption;
  FCmdLineParser.ParseCommandLine;
  {jetzt auf eine bereits laufende Instanz pr�fen}
  if IsFirstInstance(DummyHandle, 'TForm1', Form1.Caption) then
  begin {die aktuelle Instanz ist die erste}
    {Image-Listen erzeugen}
    FImageLists := TImageLists.Create(self);
    {Hautpfenster initialisieren}
    InitMainForm;
    {Tree-Views initialisieren}
    InitTreeViews;
    {FileTypeInfo: Cache f�r Dateiinfos}
    FFileTypeInfo := TFileTypeInfo.Create;
    {pr�fen, ob alle Dateien da sind}
    if CheckFiles(FSettings, Memo1, FLang) then
    begin
      {$IFDEF RegistrySettings}
      {Einstellungen laden: Registry}
      FSettings.LoadFromRegistry;
      {$ENDIF}
      {$IFDEF IniSettings}
      {Einstellungen laden: Ini}
      FSettings.LoadFromFile(cIniFile);
      {$ENDIF}      
      {Device-Scan}
      with FDevices do
      begin
        UseRSCSI := FSettings.Drives.UseRSCSI;
        RSCSIHost := FSettings.Drives.RSCSIString;
        RemoteDrives := FSettings.Drives.RemoteDrives;
        LocalDrives := FSettings.Drives.LocalDrives;
        DetectDrives;
        if (CDWriter.Count = 1) and (CDWriter[0] = '') then
        begin
          Memo1.Lines.Text := Memo1.Lines.Text + FLang.GMS('g003') + CR +
                              FLang.GMS('minit05') + CR;
        end;
      end;
      {Falls vorhanden, d2fgui.exe und dat2file.exe hinzuf�gen}
      TempChoice := FSettings.General.Choice;
      FSettings.General.Choice := cXCD;
      if FileExists(StartUpDir + cM2F2ExtractBin) then
      begin
        AddToPathlist(StartUpDir + cM2F2ExtractBin);
      end;
      if FileExists(StartUpDir + cDat2FileBin) then
      begin
        AddToPathlist(StartUpDir + cDat2FileBin);
      end;
      if FileExists(StartUpDir + cD2FGuiBin) then
      begin
        AddToPathlist(StartUpDir + cD2FGuiBin);
      end;
      AddToPathlistSort(False);
      FSettings.General.Choice := TempChoice;
      {Einstellungen wurde urspr�nglich hier geladen!}
      {Einstellungen in GUI �bernehmen}
      GetSettings;
      {Objekt zum Ausf�hren der Aktion}
      FAction := TCDAction.Create;
      FAction.Data := FData;
      FAction.Devices := FDevices;
      FAction.Settings := FSettings;
      FAction.Lang := FLang;
      FAction.Memo := Form1.Memo1;
      FAction.ProgressBar := Form1.ProgressBar;
      FAction.StatusBar := Form1.StatusBar;
      FAction.FormHandle := self.Handle;
      FAction.OnMessageToShow := MessageShow;
    end;
    {falls der Aufruf mit /hide erfolgte, Hauptfenster verstecken}
    if FSettings.CmdLineFlags.Hide then
    begin
      Application.ShowMainForm := False;
      {Wir haben jetzt verhindert, da� das Fenster angezeigt wird, also werden
       FormShow und FormActivate nich ausgel�st. Also die Eventhandler manuell
       ausl�sen.}
      FormShow(self);
      FormActivate(self);
    end;
  end else
  begin {es gibt eine weitere Instanz}
    {verhindern, da� diese Instanz angezeigt wird}
    Application.ShowMainForm:= False;
    {Kommandozeile auswerten:
     Da eine zweite Instanz sowieso keine Projekt-Dateien laden soll, kann die
     Kommandozeile auch gleich hier ausgef�hrt werden. Durch 'ShowMainForm :=
     False' wird jedes auch noch so kurzes Auftauchen eines zweiten Fensters
     verhindert.}
    FCmdLineParser.ExecuteCommandLine;
    {Instanz beenden}
    FInstanceTermination := True;
    Application.Terminate;
  end;
end;

{ FormDestroy ------------------------------------------------------------------

  Hier werden die in FormCreate erzeugten Objekte wieder freigegeben.          }

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FLang.Free;
  FImageLists.Free;
  FSettings.Free;
  FData.Free;
  FFileTypeInfo.Free;
  FAction.Free;
  FCmdLineParser.Free;
  FDevices.Free;
  {ListView-Bug: Wenn ein List-View beim Beenden automatisch zerst�rt wird, er-
   zeugt dies einen unbekannten Win32 Fehler in TWinControl.DestroyWindowHandle.
   Dieses Verhalten kann verhindert werden, indem man in FormDestroy den List-
   View explizit freigibt. M�glicherweise hat dies Nebenwirkungen, daher ist
   dieses Verhalten per Kompilerdirektive steuerbar.}
  {$IFDEF ManualFreeListView}
  CDEListView.Free;
  AudioListView.Free;
  XCDEListView1.Free;
  XCDEListView2.Free;
  DAEListView.Free;
  VideoListView.Free;
  {$ENDIF}
  {Verhindern, da� das Icon doppelt freigegeben wird. Freigabe erfolgte bereits
   mit FImageLists.Free.
   Wenn jedoch abgebrochen wird, weil eine weitere Instanz gefunden wurde, dann
   mu� das Icon von TApplication.Destroy abger�umt werden.}
   if not FInstanceTermination then Application.Icon.ReleaseHandle;
end;

{ FormShow ---------------------------------------------------------------------

  Hier werden Dinge erledigt, die vor dem ersten Anzeigen des Fensters n�tig
  sind, aber in FormCreate noch nicht ausgef�hrt werden k�nnen.                }

procedure TForm1.FormShow(Sender: TObject);
var i: Byte;
    OldChoice: Byte;
begin
  {einmal jedes Tab aktivieren, sonst funktioniert FormResize nicht richtig.
   Au�erdem wird damit gew�hrleistet, da� FSettings.General.Choice initialisiert
   ist.}
  for i := 1 to PageControl1.PageCount do ActivateTab(i);
  ActivateTab(cDataCD);
  {Das Laden der Projekt-Datei kann noch nicht in der OnCreate-Prozedur
   erfolgen -> Access Violation. Beim Laden eines Projektes wird der Zugriff auf
   Form1 ben�tigt. Deshalb f�r die erste Instanz erst hier der Aufruf von
   ExecutCommandLine. Zu einer doppelten Ausf�hrung in der zweiten Instanz kommt
   es nicht, da dort FormShow nie erreicht wird. Und falls doch, ist es auch
   egal, da das Objekt ParsedCmdLine geleert wurde.}
  FCmdLineParser.ExecuteCommandLine;
  {Fehlerbehandlung: Project-File nicht gefunden}
  if FSettings.General.LastProject <> '' then
  begin
    if FCmdLineParser.LastError = CP_ProjectFileNotFound then
    begin
      Form1.Memo1.Lines.Add(Format(FLang.GMS('epref01'),
                            [FSettings.General.LastProject]));
    end else
    begin
      GetSettings;
      CheckControls;
      UpdateOptionPanel;
      OldChoice := FSettings.General.Choice;
      for i := 1 to 3 do
      begin
        FSettings.General.Choice := i;
        AddToPathlistSort(True);
        ActivateTab(i);
        UpdateGauges;
      end;
      FSettings.General.Choice := OldChoice;
      ActivateTab(OldChoice);
    end;
  end;
  SetWinPos;
end;

{ FormActivate -----------------------------------------------------------------

  Der automatische Brennvorgang wird erst hier ausgel�st, damit das Fenster
  auch ganz sicher zu sehen ist.                                               }

procedure TForm1.FormActivate(Sender: TObject);
begin
  if FSettings.CmdLineFlags.ExecuteProject then
  begin
    SetSettings;
    if InputOk then
    begin
      {Fenster falls gew�nscht minimieren}
      if FSettings.CmdLineFlags.Minimize then Application.Minimize;
      {Taskbareintrag verschwinden lassen}
      if FSettings.CmdLineFlags.Hide then
      begin
        ShowWindow(GetWindow(Handle,GW_OWNER), SW_HIDE);
      end;
      {Aktion ausf�hren}
      FAction.Action := FSettings.General.Choice;
      FAction.StartAction;
    end else
    begin
      {im Fehlerfalle cdrtfe anzeigen}
      Application.ShowMainForm := True;
      Application.Restore;
    end;
  end;
end;

{ FormResize -------------------------------------------------------------------

  Gr��en�nderung des Hauptfensters, urspr�nglich Mod by Oli.                   }
  
procedure TForm1.FormResize(Sender: TObject);
var i       : Integer;
    TSHeight: Integer;
begin
  {Resize bei kleiner Schriftart}
  if (Screen.PixelsPerInch <= 96) and not Application.Terminated then
  begin
    {minimale Gr��e festlegen}
    if Form1.Width < dWidth then Form1.Width := dWidth;
    if Form1.Height < dHeight then Form1.Height := dHeight;
    {allgemeine Controls}
    {V-Button: richtige Gr��e bestimmen}
    ButtonShowOutput.Width  := GetSystemMetrics(SM_CXVSCROLL);
    ButtonshowOutput.Height := GetSystemMetrics(SM_CYHSCROLL);
    {L�nge der Trennlinie der Hauptmen�leiste}
    Bevel4.Width := ClientWidth;
    {StatusBar}
    StatusBar.Width := ClientWidth - 192 - (Width - ClientWidth);
    StatusBar.Top := ClientHeight - StatusBar.Height;
    {Ausgabefenster}
    Memo1.Width := StatusBar.Width;
    Memo1.Top := StatusBar.Top - 109;
    {V-Button}
    ButtonShowOutput.Left := Memo1.Left + Memo1.Width -
                                          ButtonShowOutput.Width - 2;
    ButtonShowOutput.Top := Memo1.Top + Memo1.Height -
                                        ButtonShowOutput.Height - 2;

    {Controls am rechten Rand}
    GroupBoxDrive.Left := ClientWidth - GroupBoxDrive.Width - 8;
    Bevel1.Left := GroupBoxDrive.Left;
    CheckBoxDummy.Left := GroupBoxDrive.Left + 8;
    SpeedButtonFixCD.Left := ClientWidth - SpeedButtonFixCD.Width - 8; 
    Panel1.Left := GroupBoxDrive.Left;
    Panel1.Top := ClientHeight - Panel1.Height;

    {Pagecontrol und TabSheets}
    PageControl1.Width := GroupBoxDrive.Left - 14;
    PageControl1.Height := Memo1.Top - 15;
    for i := 0 to PageControl1.PageCount - 1 do
    begin
      PageControl1.Pages[i].Width := PageControl1.Width - 8;
      PageControl1.Pages[i].Height := PageControl1.Height - 28;
    end;

    {H�he des aktuellen TabSheets}
    TSHeight := PageControl1.ActivePage.Height;

    {TabSheet1}
    PanelDataCD.Top := TSHeight - 69;
    CDESpeedButton1.Left := TabSheet1.Width - 26;
    CDESpeedButton2.Left := CDESpeedButton1.Left;
    CDESpeedButton3.Left := CDESpeedButton1.Left;
    CDESpeedButton4.Left := CDESpeedButton1.Left;
    CDESpeedButton5.Left := CDESpeedButton1.Left;
    CDETreeView.Height := PanelDataCD.Top - 15;
    CDEListView.Height := CDETreeView.Height;
    CDEListView.Width := TabSheet1.Width - 241;

    {TabSheet2}
    PanelAudioCD.Top := TSHeight - 69;
    AudioSpeedButton1.Left := TabSheet2.Width - 26;
    AudioSpeedButton2.Left := AudioSpeedButton1.Left;
    AudioSpeedButton3.Left := AudioSpeedButton1.Left;
    AudioSpeedButton4.Left := AudioSpeedButton1.Left;
    AudioListView.Height := PanelAudioCD.Top - 15;
    AudioListView.Width := TabSheet2.Width - 41;

    {TabSheet3}
    PanelXCD.Top := TSHeight - 101;
    XCDETreeView.Height := PanelXCD.Top - 15;
    XCDEListView1.Width := TabSheet3.Width - 241;
    XCDEListView1.Height := (TSHeight - 34 - 13) div 2;
    XCDEListView2.Width := TabSheet3.Width - 241;
    XCDEListView2.Top := XCDEListView1.Top + XCDEListView1.Height + 5;
    XCDEListView2.Height := XCDEListView1.Height;
    XCDESpeedButton1.Left := TabSheet3.Width - 26;
    XCDESpeedButton2.Left := XCDESpeedButton1.Left;
    XCDESpeedButton3.Left := XCDESpeedButton1.Left;
    XCDESpeedButton4.Left := XCDESpeedButton1.Left;
    XCDESpeedButton4.Top := XCDEListView2.Top + 24;
    XCDESpeedButton5.Left := XCDESpeedButton1.Left;
    XCDESpeedButton5.Top := XCDEListView2.Top + 56;
    XCDESpeedButton6.Left := XCDESpeedButton1.Left - 32;
    XCDESpeedButton6.Top  := TSHeight - 29;
    XCDESpeedButton7.Left := XCDESpeedButton1.Left;
    XCDESpeedButton7.Top  := TSHeight - 29;

    {TabSheet4}
    GroupBoxCDRWDelete.Top := (TSHeight - GroupBoxCDRWDelete.Height) div 2;
    GroupBoxCDRWDelete.Left := (TabSheet4.Width - GroupBoxCDRWDelete.Width)
                               div 2;

    {TabSheet5}
    GroupBoxCDInfo.Top := (TSHeight - GroupBoxCDInfo.Height) div 2;
    GroupBoxCDInfo.Left := (TabSheet5.Width - GroupBoxCDInfo.Width) div 2;

    {TabSheet6}
    PanelDAE.Top := TSHeight - 69;
    DAEListView.Height := PanelDAE.Top - 15;
    DAEListView.Width := TabSheet6.Width - 41;

    {TabSheet7}
    PanelImage.Top := (TSHeight - PanelImage.Height) div 2;
    PanelImage.Left := (TabSheet7.Width - PanelImage.Width) div 2;

    {TabSheet8}
    PanelVideoCD.Top := TSHeight - 69;
    VideoSpeedButton1.Left := TabSheet8.Width - 26;
    VideoSpeedButton2.Left := VideoSpeedButton1.Left;
    VideoSpeedButton3.Left := VideoSpeedButton1.Left;
    VideoSpeedButton4.Left := VideoSpeedButton1.Left;
    VideoListView.Height := PanelVideoCD.Top - 15;
    VideoListView.Width := TabSheet8.Width - 41;

    {TabSheet9}
    GroupBoxDVDVideo.Top := (TSHeight - GroupBoxDVDVideo.Height) div 2;
    GroupBoxDVDVideo.Left := (TabSheet9.Width - GroupBoxDVDVideo.Width) div 2;

  end else
  {Resize mit gro�er Schriftart}
  if (Screen.PixelsPerInch > 96) and not Application.Terminated then
  begin
    {minimale Gr��e festlegen}
    if Form1.Width < dWidthBigFont then Form1.Width := dWidthBigFont;
    if Form1.Height < dHeightBigFont then Form1.Height := dHeightBigFont;
    {allgemeine Controls}
    {V-Button: richtige Gr��e bestimmen}
    ButtonShowOutput.Width  := GetSystemMetrics(SM_CXVSCROLL);
    ButtonShowOutput.Height := GetSystemMetrics(SM_CYHSCROLL);
    {L�nge der Trennlinie der Hauptmen�leiste}
    Bevel4.Width := ClientWidth;
    {StatusBar}
    StatusBar.Width := ClientWidth - 236 - (Width - ClientWidth);
    StatusBar.Top := ClientHeight - StatusBar.Height;
    {Ausgabefenster}
    Memo1.Width := StatusBar.Width;
    Memo1.Top := StatusBar.Top - 139;
    {V-Button}
    ButtonShowOutput.Left := Memo1.Left + Memo1.Width -
                                          ButtonShowOutput.Width - 2;
    ButtonShowOutput.Top := Memo1.Top + Memo1.Height -
                                        ButtonShowOutput.Height - 2;

    {Controls am rechten Rand}
    GroupBoxDrive.Left := ClientWidth - GroupBoxDrive.Width - 8;
    Bevel1.Left := GroupBoxDrive.Left;
    CheckBoxDummy.Left := GroupBoxDrive.Left + 10;
    SpeedButtonFixCD.Left := ClientWidth - SpeedButtonFixCD.Width - 8;
    Panel1.Left := GroupBoxDrive.Left;
    Panel1.Top := ClientHeight - Panel1.Height;

    {Pagecontrol und TabSheets}
    PageControl1.Width := GroupBoxDrive.Left - 14;
    PageControl1.Height := Memo1.Top - 15;
    for i := 0 to PageControl1.PageCount - 1 do
    begin
      PageControl1.Pages[i].Width := PageControl1.Width - 8;
      PageControl1.Pages[i].Height := PageControl1.Height - 28;
    end;

    {H�he des aktuellen TabSheets}
    TSHeight := PageControl1.ActivePage.Height;

    {TabSheet1}
    PanelDataCD.Top := TSHeight - 88;
    CDESpeedButton1.Left := TabSheet1.Width - 34;
    CDESpeedButton2.Left := CDESpeedButton1.Left;
    CDESpeedButton3.Left := CDESpeedButton1.Left;
    CDESpeedButton4.Left := CDESpeedButton1.Left;
    CDESpeedButton5.Left := CDESpeedButton1.Left;
    CDETreeView.Height := PanelDataCD.Top - 19;
    CDEListView.Height := CDETreeView.Height;
    CDEListView.Width := TabSheet1.Width - 298;
    CDEListView.Left := 256;

    {TabSheet2}
    PanelAudioCD.Top := TSHeight - 88;
    AudioSpeedButton1.Left := TabSheet2.Width - 34;
    AudioSpeedButton2.Left := AudioSpeedButton1.Left;
    AudioSpeedButton3.Left := AudioSpeedButton1.Left;
    AudioSpeedButton4.Left := AudioSpeedButton1.Left;
    AudioListView.Height := PanelAudioCD.Top - 19;
    AudioListView.Width := TabSheet2.Width - 52;

    {TabSheet3}
    PanelXCD.Top := TSHeight - 127;
    XCDETreeView.Height := PanelXCD.Top - 15;
    XCDEListView1.Left := 256;
    XCDEListView1.Width := TabSheet3.Width - 298;
    XCDEListView1.Height := (TSHeight - 62) div 2;
    XCDEListView2.Left := 256;
    XCDEListView2.Width := TabSheet3.Width - 298;
    XCDEListView2.Top := XCDEListView1.Top + XCDEListView1.Height + 5;
    XCDEListView2.Height := XCDEListView1.Height;
    XCDESpeedButton1.Left := TabSheet3.Width - 34;
    XCDESpeedButton2.Left := XCDESpeedButton1.Left;
    XCDESpeedButton3.Left := XCDESpeedButton1.Left;
    XCDESpeedButton4.Left := XCDESpeedButton1.Left;
    XCDESpeedButton4.Top := XCDEListView2.Top + 24;
    XCDESpeedButton5.Left := XCDESpeedButton1.Left;
    XCDESpeedButton5.Top := XCDEListView2.Top + 56;
    XCDESpeedButton6.Left := XCDESpeedButton1.Left - 32;
    XCDESpeedButton6.Top  := TSHeight - 39;
    XCDESpeedButton7.Left := XCDESpeedButton1.Left;
    XCDESpeedButton7.Top  := TSHeight - 39;

    {TabSheet4}
    GroupBoxCDRWDelete.Top := (TSHeight - GroupBoxCDRWDelete.Height) div 2;
    GroupBoxCDRWDelete.Left := (TabSheet4.Width - GroupBoxCDRWDelete.Width)
                               div 2;

    {TabSheet5}
    GroupBoxCDInfo.Top := (TSHeight - GroupBoxCDInfo.Height) div 2;
    GroupBoxCDInfo.Left := (TabSheet5.Width - GroupBoxCDInfo.Width) div 2;

    {TabSheet6}
    PanelDAE.Top := TSHeight - 85;
    DAEListView.Height := PanelDAE.Top - 15;
    DAEListView.Width := TabSheet6.Width - 52;

    {TabSheet7}
    PanelImage.Top := (TSHeight - PanelImage.Height) div 2;
    PanelImage.Left := (TabSheet7.Width - PanelImage.Width) div 2;

    {TabSheet8}
    PanelVideoCD.Top := TSHeight - 88;
    VideoSpeedButton1.Left := TabSheet2.Width - 34;
    VideoSpeedButton2.Left := VideoSpeedButton1.Left;
    VideoSpeedButton3.Left := VideoSpeedButton1.Left;
    VideoSpeedButton4.Left := VideoSpeedButton1.Left;
    VideoListView.Height := PanelVideoCD.Top - 19;
    VideoListView.Width := TabSheet8.Width - 52;

    {TabSheet9}
    GroupBoxDVDVideo.Top := (TSHeight - GroupBoxDVDVideo.Height) div 2;
    GroupBoxDVDVideo.Left := (TabSheet9.Width - GroupBoxDVDVideo.Width) div 2;
  end;
end;

{ FormClose --------------------------------------------------------------------

  In FormClose werden die Einstellungen gespeichert, sofern die automatische
  Speicheung beim Beenden aktiviert ist.                                       }

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Einstellungen speichern}
  SaveWinPos;
end;

procedure TForm1.FormDblClick(Sender: TObject);
{$IFDEF CreateAllForms}
var FormDataCDOptions : TFormDataCDOptions;
    FormDataCDFS      : TFormDataCDFS;
    FormDataCDFSError : TFormDataCDFSError;
    FormAudioCDOptions: TFormAudioCDOptions;
    FormAudioCDTracks : TFormAudioCDTracks;
    FormXCDOptions    : TFormXCDOptions;
    FormSettings      : TFormSettings;
    FormOutput        : TFormOutput;
    FormAbout         : TFormAbout;
{$ENDIF}
{$IFDEF AddCDText}
var i: Integer;
    DummyI, TrackCount: Integer;
    DummyE: Extended;
    TextTrackData: TCDTextTrackData;
{$ENDIF}
{$IFDEF ShowCDTextInfo}
var i: Integer;
    DummyI, TrackCount: Integer;
    DummyE: Extended;
    TextTrackData: TCDTextTrackData;
{$ENDIF}
begin
  {$IFDEF CreateAllForms}
  FormDataCDOptions  := TFormDataCDOptions.Create(Application);
  FormDataCDFS       := TFormDataCDFS.Create(Application);
  FormDataCDFSError  := TFormDataCDFSError.Create(Application);
  FormAudioCDOptions := TFormAudioCDOptions.Create(Application);
  FormAudioCDTracks  := TFormAudioCDTracks.Create(Application);
  FormXCDOptions     := TFormXCDOptions.Create(Application);
  FormSettings       := TFormSettings.Create(Application);
  FormOutput         := TFormOutput.Create(Application);
  FormAbout          := TFormAbout.Create(Application);
  {$ENDIF}
  {$IFDEF ExportStrings}
  ExportStringProperties;
  FLang.ExportMessageStrings;
  ShowMessage('Strings exportiert.');
  {$ENDIF}
  {$IFDEF ExportControls}
  ExportControls;
  {$ENDIF}
  {$IFDEF CreateAllForms}
  FormDataCDOptions.Free;
  FormDataCDFS.Free;
  FormDataCDFSError.Free;
  FormAudioCDOptions.Free;
  FormAudioCDTracks.Free;
  FormXCDOptions.Free;
  FormSettings.Free;
  FormOutput.Free;
  FormAbout.Free;
  {$ENDIF}
  {$IFDEF TestVerify}
  SendMessage(self.Handle, WM_ButtonsOff, 0, 0);
  FAction.Action := cVerify{XCD};
  FAction.StartAction;
  {$ENDIF}
  {$IFDEF DebugSettings}
  SetSettings;
  FSettings.ShowSettings;
  {$ENDIF}
  {$IFDEF AddCDText}
  FData.GetProjectInfo(DummyI, DummyI, DummyI, DummyE, TrackCount, cAudioCD);
  for i := -1 to TrackCount - 1 do
  begin
    with TextTrackData do
    begin
      Title       := 'Title ' + IntToStr(i + 1);
      Performer   := 'Performer ' + IntToStr(i + 1);
      Songwriter  := 'Songwriter ' + IntToStr(i + 1);
      Composer    := 'Composer ' + IntToStr(i + 1);
      Arranger    := 'Arranger ' + IntToStr(i + 1);
      TextMessage := 'TextMessage ' + IntToStr(i + 1);
    end;
    FData.SetCDText(i, TextTrackData);
  end;
  {$ENDIF}
  {$IFDEF ShowCDTextInfo}
  FData.GetProjectInfo(DummyI, DummyI, DummyI, DummyE, TrackCount, cAudioCD);
  for i := -1 to TrackCount - 1 do
  begin
    FData.GetCDText(i, TextTrackData);
    with TextTrackData do
    begin
      Deb('Track ' + IntToStr(i + 1) + ': ', 2);
      Deb('  Title     : ' + Title, 2);
      Deb('  Performer : ' + Performer, 2);
      Deb('  Songwriter: ' +  Songwriter, 2);
      Deb('  Composer  : ' +  Composer, 2);
      Deb('  Arranger  : ' +  Arranger, 2);
      Deb('  Message   : ' +  TextMessage, 2);
    end;
  end;
  {$ENDIF}
  {$IFDEF DebugCreateCDText}
  FData.CreateCDTextFile(ProgDataDir + '\cdtext.dat');
  {$ENDIF}
end;


{ Button-Events -------------------------------------------------------------- }

{ Button 'Start' }

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  SetSettings;
  if InputOk then
  begin
    FAction.Reset;
    {Aktion ausf�hren}
    FAction.Action := FSettings.General.Choice;
    FAction.StartAction;
  end;
end;

{ Button 'Beenden' }

procedure TForm1.ButtonCancelClick(Sender: TObject);
begin
  Application.Terminate;
end;

{ Data-CD: Options file system }

procedure TForm1.ButtonDataCDOptionsFSClick(Sender: TObject);
var FormDataCDFS: TFormDataCDFS;
begin
  FormDataCDFS := TFormDataCDFS.Create(nil);
  try
    FormDataCDFS.Settings := FSettings;
    FormDataCDFS.Lang := FLang;
    FormDataCDFS.ShowModal;
  finally
    FormDataCDFS.Release;
  end;
  UpdateOptionPanel;
end;

{ Data-CD: Options CD }

procedure TForm1.ButtonDataCDOptionsClick(Sender: TObject);
var FormDataCDOptions: TFormDataCDOptions;
begin
  FormDataCDOptions := TFormDataCDOptions.Create(nil);
  try
    FormDataCDOptions.Settings := FSettings;
    FormDataCDOptions.Lang := FLang;
    FormDataCDOptions.ShowModal;
  finally
    FormDataCDOptions.Release;
  end;
  UpdateOptionPanel;
end;

{ Audio-CD: Options }

procedure TForm1.ButtonAudioCDOptionsClick(Sender: TObject);
var FormAudioCDOptions: TFormAudioCDOptions;
begin
  FormAudioCDOptions := TFormAudioCDOptions.Create(nil);
  try
    FormAudioCDOptions.Settings := FSettings;
    FormAudioCDOptions.Lang := FLang;
    FormAudioCDOptions.ShowModal;
  finally
    FormAudioCDOptions.Release;
  end;
  UpdateOptionPanel;
end;

{ Audio-CD: Track Options}

procedure TForm1.ButtonAudioCDTracksClick(Sender: TObject);
var FormAudioCDTracks: TFormAudioCDTracks;
begin
  FormAudioCDTracks := TFormAudioCDTracks.Create(nil);
  try
    FormAudioCDTracks.Data := FData;
    FormAudioCDTracks.Settings := FSettings;
    FormAudioCDTracks.Lang := FLang;
    FormAudioCDTracks.ShowModal;
  finally
    FormAudioCDTracks.Release;
  end;
end;

{ XCD: Options }

procedure TForm1.ButtonXCDOptionsClick(Sender: TObject);
var FormXCDOptions: TFormXCDOptions;
begin
  FormXCDOptions := TFormXCDOptions.Create(nil);
  try
    FormXCDOptions.Settings := FSettings;
    FormXCDOptions.Lang := FLang;
    FormXCDOptions.ShowModal;
  finally
    FormXCDOptions.Release;
  end;
  UpdateOptionPanel;
end;

{ DAE: Select path }

procedure TForm1.ButtonDAESelectPathClick(Sender: TObject);
var dir: string;
begin
  dir := ChooseDir(Flang.GMS('g002'), Self.Handle);
  if dir <> '' then
  begin
    EditDAEPath.Text := dir;
  end;
end;

{ DAE: Read TOC }

procedure TForm1.ButtonDAEReadTocClick(Sender: TObject);
begin
  SetSettings;
  FAction.Action := cDAEReadTOC;
  FAction.StartAction;
  ShowTracksDAE;
end;

{ Image: Select path }

procedure TForm1.ButtonReadCDSelectPathClick(Sender: TObject);
begin
  SaveDialog1 := TSaveDialog.Create(Form1);
  SaveDialog1.Title := FLang.GMS('m102');
  SaveDialog1.DefaultExt := 'iso';
  SaveDialog1.Filter := FLang.GMS('f002');
  SaveDialog1.Options := [ofOverwritePrompt,ofHideReadOnly];
  if SaveDialog1.Execute then
  begin
    EditReadCDIsoPath.Text := SaveDialog1.FileName;
  end;
  SaveDialog1.Free;
end;

{ Image: Select ISO-/CUE-Image }

procedure TForm1.ButtonImageSelectPathClick(Sender: TObject);
begin
  OpenDialog1 := TOpenDialog.Create(Form1);
  OpenDialog1.Title := FLang.GMS('m101');
  if (FSettings.FileFlags.CdrdaoOk or FSettings.Cdrecord.CanWriteCueImage) then
  begin
    OpenDialog1.Filter := FLang.GMS('f001');
  end else
  begin
    OpenDialog1.Filter := FLang.GMS('f002');
  end;
  if OpenDialog1.Execute then
  begin
    EditImageIsoPath.Text := (OpenDialog1.Files[0]);
  end;
  OpenDialog1.Free;
  CheckControls;
end;

{ DVD Video: Select source dir }

procedure TForm1.ButtonDVDVideoSelectPathClick(Sender: TObject);
var dir: string;
begin
  dir := ChooseDir(Flang.GMS('g002'), Self.Handle);
  if dir <> '' then
  begin
    EditDVDVideoSourcePath.Text := dir;
  end;
end;

{ Video CD: Options }

procedure TForm1.ButtonVideoCDOptionsClick(Sender: TObject);
var FormVideoCDOptions: TFormVideoCDOptions;
begin
  FormVideoCDOptions := TFormVideoCDOptions.Create(nil);
  try
    FormVideoCDOptions.Settings := FSettings;
    FormVideoCDOptions.Lang := FLang;
    FormVideoCDOptions.ShowModal;
  finally
    FormVideoCDOptions.Release;
  end;
  UpdateOptionPanel;
end;

{ cdrtfe Settings }

procedure TForm1.ButtonSettingsClick(Sender: TObject);
var FormSettings: TFormSettings;
begin
  SetSettings;
  SaveWinPos;
  FormSettings := TFormSettings.Create(nil);
  try
    FormSettings.Settings := FSettings;
    FormSettings.Lang := FLang;
    FormSettings.OnMessageToShow := Form1.MessageShow;
    FormSettings.ShowModal;
  finally
    FormSettings.Release;
  end;
  GetSettings;
end;

{ Show output window }

procedure TForm1.ButtonShowOutputClick(Sender: TObject);
var FormOutput: TFormOutput;
begin
  FormOutput := TFormOutput.Create(nil);
  try
    FormOutput.Lang := FLang;
    FormOutput.Settings := FSettings;
    FormOutput.Memo1.Lines.Assign(Memo1.Lines);
    FormOutput.ShowModal;
  finally
    FormOutput.Release;
  end;
end;

{ Abort action }

procedure TForm1.ButtonAbortClick(Sender: TObject);
begin
  FAction.AbortAction;
end;


{ Menu-Events ---------------------------------------------------------------- }

{ Datei/Schlie�en }

procedure TForm1.MainMenuCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

{ Projekt/Projekt laden }

procedure TForm1.MainMenuLoadProjectClick(Sender: TObject);
begin
  LoadProject(False);
end;

{ Projekt/Projekt speichern }

procedure TForm1.MainMenuSaveProjectClick(Sender: TObject);
begin
  SaveProject(False);
end;

{ Projekt/Dateiliste laden }

procedure TForm1.MainMenuLoadFileListClick(Sender: TObject);
begin
  LoadProject(True);
end;

{ Projekt/Dateiliste speichern }

procedure TForm1.MainMenuSaveFileListClick(Sender: TObject);
begin
  SaveProject(True);
end;

{ Pojekt/Standardeinstellungen }

procedure TForm1.MainMenuReloadDefaultsClick(Sender: TObject);
var Temp: Byte;
begin
  Temp := FSettings.General.Choice;
  {$IFDEF RegistrySettings}
  {Einstellungen laden: Registry}
  FSettings.LoadFromRegistry;
  {$ENDIF}
  {$IFDEF IniSettings}
  {Einstellungen laden: Ini}
  FSettings.LoadFromFile(cIniFile);
  {$ENDIF}
  {Einstellungen in GUI �bernehmen}
  GetSettings;
  FSettings.General.Choice := Temp;
  CheckControls;
  UpdateOptionPanel;
end;

{ Extras/Sprache �ndern }

procedure TForm1.MainMenuSetLangClick(Sender: TObject);
begin
  if FLang.SelectLanguage then
  begin
    FLang.SetFormLang(Self);
    UpdateGauges;
    FormResize(Self);
  end;
end;

{ ?/Info }

procedure TForm1.MainMenuInfoClick(Sender: TObject);
var AboutBox: TFormAbout;
begin
  AboutBox := TFormAbout.Create(nil);
  try
    AboutBox.Lang := Flang;
    AboutBox.ShowModal;
  finally
    AboutBox.Release;
  end;
end;


{ PageControl-Events --------------------------------------------------------- }

{ PageControl1Change -----------------------------------------------------------

  Bei jedem Wechsel der aktiven Registerkarte m�ssen die Controls entsprechend
  (de-)aktiviert werden. Au�erdem mu� Choice aktualisiert werden.              }

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  FSettings.General.Choice := GetActivePage;
  CheckControls;
  UpdateGauges;
  UpdateOptionPanel;
end;


{ TreeView-Events --------------------------------------------------------------

  Die TreeView-Events gelten sowohl f�r CDETreeView als auch f�r XCDETreeView. }

{ TreeView: OnChange -----------------------------------------------------------

  OnChange: der selektierte Knoten hat sich ge�ndert. Die mit dem Knoten
  verkn�pfte Pfadliste wird im ListView angezeigt. Vorher werden noch die
  Dateilisten des alten Knotens neu sortiert, sofern dort Dateien umbenannt
  wurden. Ebenso wird falls n�tig der TreeView neu sortiert.                   }

procedure TForm1.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  UserSort(False);
  if (Sender as TTreeView) = CDETreeView then
  begin
    ShowFolderContent(CDETreeView, CDEListView);
  end else
  if (Sender as TTreeView) = XCDETreeView then
  begin
    ShowFolderContent(XCDETreeView, XCDEListView1);
  end;
end;

{ TreeView: OnExpanding --------------------------------------------------------

  TreeViewExpanding wird ausgef�hrt, wenn ein Knoten des Tree-Views expandiert
  wird. Dieses Event wird dazu benutzt, um die Knoten mit den korrekten Icons
  zu versehen. Immer, wenn ein Knoten expandiert wird, erhalten die direkt
  untergeordneten Knoten die Icon-Indizes.                                     }

procedure TForm1.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
                                   var AllowExpansion: Boolean);
var TempNode: TTreeNode;
begin
  TempNode := Node.GetFirstChild;
  while TempNode <> nil do
  begin
    with FImageLists do
    begin
      {zu langsam:
      if TempNode.AbsoluteIndex = 0 then }
      {�berfl�ssig, da der Wurzelknoten hier nie als Child erreicht werden kann
      if TempNode = (Sender as TTreeView).Items[0] then
      begin
        TempNode.ImageIndex := IconCD;
        TempNode.SelectedIndex := IconCD;
      end else }
      begin
        TempNode.ImageIndex := IconFolder;
        TempNode.SelectedIndex := IconFolderSelected;
      end;
    end;
    TempNode := Node.GetNextChild(TempNode);
  end;
end;

{ TreeView: OnMouseDown---------------------------------------------------------

  OnMouseDown sorgt daf�r, da� auch bei einem Rechtsklick das Item selektiert
  wird.                                                                        }

procedure TForm1.TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer);
var Node: TTreeNode;
begin
  if Button = mbRight then
  begin
    Node := (Sender as TTreeView).GetNodeAt(x, y);
    if Node <> nil then
    begin
      (Sender as TTreeView).Selected := Node;
    end;
  end;
end;

{ TreeView: OnDragOver ---------------------------------------------------------

  Ein Objekt wird auf den Tree-View gezogen. Drop nur zulassen, wenn es aus
  dem Tree-View selbst oder aus einem List-View stammt.                        }

procedure TForm1.TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
                                  State: TDragState; var Accept: Boolean);
var Tree: TTreeView;
begin
  Tree := (Sender as TTreeView);
  if (Source is TTreeView) or (Source is TListView) then
  begin
    Accept := True;
    {da THETreeView nicht mehr benutzt wird, mu� hier gescrollt werden}
    if (Y > Tree.Height - 20) and (Y < Tree.Height) then
      PostMessage(Tree.Handle, WM_VSCROLL, MakeLong(SB_LINEDOWN, 0), 0);
    if (Y < 20) then
      PostMessage(Tree.Handle, WM_VSCROLL, MakeLong(SB_LINEUP, 0), 0);
  end else
  begin
    Accept := False;
  end;
end;

{ TreeView: OnDragDrop ---------------------------------------------------------

  Ein Objekt wird auf den Tree-View fallengelassen.                            }

procedure TForm1.TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
var SourceNode: TTreeNode;
    DestNode: TTreeNode;
begin
  DestNode := nil;
  SourceNode := nil;
  case FSettings.General.Choice of
    cDataCD: begin
               DestNode := CDETreeView.GetNodeAt(X, Y);
               SourceNode := CDETreeView.Selected;
             end;
    cXCD   : begin
               DestNode := XCDETreeView.GetNodeAt(X, Y);
               SourceNode := XCDETreeView.Selected;
             end;
  end;
  {Datei: ListView -> TreeView}
  if Source is TListView then
  begin
    if (DestNode <> nil) and (DestNode <> SourceNode) then
    begin
      UserMoveFile(SourceNode, DestNode, TListView(Source));
    end;
  end;
  {Ordner: TreeView -> TreeView}
  if Source is TTreeView then
  begin
    if (DestNode <> nil) and (DestNode <> SourceNode) then
    begin
      UserMoveFolder(SourceNode, DestNode);
    end;
  end;
end;

{ TreeView: OnKeyDown ----------------------------------------------------------

  Tastatur-Events.                                                             }

procedure TForm1.TreeViewKeyDown(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
var Tree: TTreeView;
begin
  Tree := Sender as TTreeView;
  case Key of
    VK_DELETE: if not Tree.IsEditing and (Tree.Selected <> Tree.Items[0]) then
               begin
                 UserDeleteFolder(Tree);
               end;
    VK_F2    : UserRenameFolderByKey(Tree);
    VK_F5    : UserSort(True);
  end;
end;

{ TreeView: OnEdited -----------------------------------------------------------

  Der Text eines Knotens wurde ge�ndert. Wenn es sich nicht um die Wurzel des
  Tree-Views handelte, m�ssen alle Knoten auf gleicher Ebene sortiert
  werden.                                                                      }

procedure TForm1.TreeViewEdited(Sender: TObject; Node: TTreeNode;
                                var S: String);
var Temp: string;
    Path: string;
    ErrorCode: Byte;
begin
  if Node.Parent <> nil then {Folder}
  begin
    Path := GetPathFromNode(Node);
    FData.RenameFolder(Path, S, FSettings.GetMaxFileNameLength,
                       FSettings.General.Choice);
    ErrorCode := FData.LastError;
    if ErrorCode = PD_NoError then
    begin
      {�nderungen im GUI nachvollziehen}
      Node.Text := S;
      {Flags f�r die sp�tere Sortierng (onChange oder F5) setzen}
      with FData do
      begin
        case FSettings.General.Choice of
          cDataCD: begin
                     DataCDFoldersToSort := True;
                     DataCDFoldersToSortParent := GetPathFromNode(Node.Parent);
                   end;
          cXCD   : begin
                     XCDFoldersToSort := True;
                     XCDFoldersToSortParent := GetPathFromNode(Node.Parent);
                   end;
        end;
      end;
    end else
    begin
      Temp := S;
      S := Node.Text;
      Node.Text := S;
      if ErrorCode = PD_FolderNotUnique then
      begin
        {Fehlermeldung nur ausgeben, wenn der neue Name sich wirklich vom
         alten unterscheidet.}
        if Temp <> Node.Text then
        begin
          Application.MessageBox(PChar(Format(FLang.GMS('e111'), [Temp])),
                                 PChar(FLang.GMS('g001')),
                                 MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
        end;
      end else
      if ErrorCode = PD_InvalidName then
      begin
        Application.MessageBox(PChar(FLang.GMS('e110')),
                               PChar(FLang.GMS('g001')),
                               MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
      end else
      if ErrorCode = PD_NameTooLong then
      begin
        Application.MessageBox(PChar(FLang.GMS('e501')),
                               PChar(FLang.GMS('g001')),
                               MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
      end;
    end;
  end else {CD-Label}
  begin
    FData.SetCDLabel(S, FSettings.General.Choice);
    {Fehlerbehandlung}
    ErrorCode := FData.LastError;
    if ErrorCode = PD_NoError then
    begin
      {�nderung im GUI nachvollziehen}
      Node.Text := S;
    end else
    begin
      Temp := S;
      S := Node.Text;
      Node.Text := S;
      {evtl. noch Fehlermeldungen ausgeben.}    
    end;
  end;
end;


{ ListView-Events ------------------------------------------------------------ }

{ ListView: OnKeyDown ----------------------------------------------------------

  Tastatur-Events.                                                             }

procedure TForm1.ListViewKeyDown(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
var List: TListview;
begin
  List := Sender as TListView;
  case Key of
    VK_DELETE : if not List.IsEditing then
                begin
                  case FSettings.General.Choice of
                    cDataCD: UserDeleteFile(CDETreeView, CDEListView);
                    cXCD   : UserDeleteFile(XCDETreeView, List);
                  end;
                end;
    Ord('A')  : if Shift = [ssCtrl] then
                begin
                  ListViewSelectAll(List);
                end;
    VK_F2     : if FSettings.General.Choice = cDataCD then
                begin
                  {nur bei Daten-CDs d�rfen Dateien umbenannt werden}
                  UserRenameFile(CDEListView);
                end;
    VK_F5     : UserSort(True);
   end;
end;

{ ListView: OnEdited -----------------------------------------------------------

  Ein Dateiname wurde ge�ndert.                                                }

procedure TForm1.ListViewEdited(Sender: TObject; Item: TListItem;
                                var S: String);
var Temp: string;
    Path: string;
    ErrorCode: Byte;
begin
  Path := GetPathFromNode(CDETreeView.Selected);
  FData.RenameFileByIndex(Item.Index, Path, S, FSettings.GetMaxFileNameLength,
                          FSettings.General.Choice);
  ErrorCode := FData.LastError;
  if ErrorCode = PD_NoError then
  begin
    {�nderungen im GUI nachvollziehen}
    Item.Caption := S;
    {Flags f�r die sp�tere Sortierng (onChange oder F5) setzen}
    with FData do
    begin
      case FSettings.General.Choice of
        cDataCD: begin
                   DataCDFilesToSort := True;
                   DataCDFilesToSortFolder := Path;
                 end;
        cXCD   : ;
      end;
    end;
  end else
  begin
    Temp := S;
    S := Item.Caption;
    Item.Caption := S;
    if ErrorCode = PD_FileNotUnique then
    begin
      {Fehlermeldung nur ausgeben, wenn der neue Name sich wirklich vom
       alten unterscheidet.}
      if Temp <> Item.Caption then
      begin
        Application.MessageBox(PChar(Format(FLang.GMS('e112'), [Temp])),
                               PChar(FLang.GMS('g001')),
                               MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
      end;
    end else
    if ErrorCode = PD_InvalidName then
    begin
      Application.MessageBox(PChar(FLang.GMS('e110')),
                             PChar(FLang.GMS('g001')),
                             MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
    end else
    if ErrorCode = PD_NameTooLong then
    begin
      Application.MessageBox(PChar(FLang.GMS('e501')),
                             PChar(FLang.GMS('g001')),
                             MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
    end;
  end;
end;

{ XCDEListView1: OnDragDrop ----------------------------------------------------

  verschieben von Dateien von Datei-List zur Movie-Liste und umgekehrt. Gilt nur
  f�r XCD.                                                                     }

procedure TForm1.XCDEListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var Path: string;
    i: Integer;
begin
  Path := GetPathFromNode(XCDETreeView.Selected);
  if {Form1 -> Form2}
     ((Source as TListView) = XCDEListView1) and
     ((Sender as TListView) = XCDEListView2) or
     {Form2 -> Form1}
     ((Source as TListView) = XCDEListView2) and
     ((Sender as TListView) = XCDEListView1) then
  begin
    for i := (Source as TListView).Items.Count - 1 downto 0 do
    begin
      if (Source as TListView).Items[i].Selected then
      begin
        FData.ChangeForm2Status((Source as TListView).Items[i].Caption, Path);
      end;
    end;
  end;
  FData.SortFileList(Path, cXCD);
  ShowFolderContent(XCDETreeView, XCDEListView1);
end;

{ XCDEListView1: OnDragOver ----------------------------------------------------

  es sollen nur Dateien akzeptiert werden. Keine Ordner. Nur XCD.              }

procedure TForm1.XCDEListView1DragOver(Sender, Source: TObject; X, Y: Integer;
                                       State: TDragState; var Accept: Boolean);
begin
   if (Source is TListView) then
  begin
    Accept := True;
  end else
  begin
    Accept := False;
  end;
end;

{ XCDEListView1: OnEditing -----------------------------------------------------

  Der Mode2CDMaker unterst�tz zur Zeit die �nderung vo Dateinamen nicht. Daher
  d�rfen die Dateinamen nicht ge�ndert werden.                                 }

procedure TForm1.XCDEListView1Editing(Sender: TObject; Item: TListItem;
                                      var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

{ AudioListView: OnEditing -----------------------------------------------------

  Bei Audio-CD spielt der Dateiname keine Rolle, also kein Editieren.          }

procedure TForm1.AudioListViewEditing(Sender: TObject; Item: TListItem;
                                      var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

{ AudioListView: KeyDown -------------------------------------------------------

  Tastatur-Events: Hinzuf�gen, L�schen und Bewegen von Tracks.                 }

procedure TForm1.AudioListViewKeyDown(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
begin
  case Key of
    VK_DELETE  : if not AudioListView.IsEditing then
                 begin
                   UserDeleteFile(nil, AudioListView);
                 end;
    Ord('A')   : if Shift = [ssCtrl] then
                 begin
                   ListViewSelectAll(AudioListView);
                 end;
    VK_ADD     : UserMoveTrack(AudioListView, dDown);
    VK_SUBTRACT: UserMoveTrack(AudioListView, dUp);
  end;
end;

{ DAEListView: OnEditing -------------------------------------------------------

  Bei Audio-CD spielt der Dateiname keine Rolle, also kein Editieren.          }

procedure TForm1.DAEListViewEditing(Sender: TObject; Item: TListItem;
                                    var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

{ DAEListView: KeyDown ---------------------------------------------------------

  Tastatur-Events: Alle Tracks markieren.                                      }

procedure TForm1.DAEListViewKeyDown(Sender: TObject; var Key: Word;
                                    Shift: TShiftState);
begin
  case Key of
    Ord('A')   : if Shift = [ssCtrl] then
                 begin
                   ListViewSelectAll(DAEListView);
                 end;
  end;
end;

{ VideoListView: OnEditing -----------------------------------------------------

  Bei Video-CD spielt der Dateiname keine Rolle, also kein Editieren.          }

procedure TForm1.VideoListViewEditing(Sender: TObject; Item: TListItem;
                                      var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

{ VideoListView: OnKeyDown -----------------------------------------------------

  Tastatur-Events: L�schen und Bewegen von Tracks.                             }

procedure TForm1.VideoListViewKeyDown(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
begin
  case Key of
    VK_DELETE  : if not VideoListView.IsEditing then
                 begin
                   UserDeleteFile(nil, VideoListView);
                 end;
    Ord('A')   : if Shift = [ssCtrl] then
                 begin
                   ListViewSelectAll(VideoListView);
                 end;
    VK_ADD     : UserMoveTrack(VideoListView, dDown);
    VK_SUBTRACT: UserMoveTrack(VideoListView, dUp);
  end;
end;


{ SpeedButton-Events --------------------------------------------------------- }

{ Data-CD: Add file }

procedure TForm1.CDESpeedButton1Click(Sender: TObject);
begin
  UserAddFile(CDETreeView);
  ShowFolderContent(CDETreeView, CDEListView);
end;

{ Data-CD: Add folder }

procedure TForm1.CDESpeedButton2Click(Sender: TObject);
begin
  UserAddFolder(CDETreeView);
end;

{ Data-CD: Delete file }

procedure TForm1.CDESpeedButton3Click(Sender: TObject);
begin
  UserDeleteFile(CDETreeView, CDEListView);
end;

{ Data-CD: Delete folder }

procedure TForm1.CDESpeedButton4Click(Sender: TObject);
begin
  UserDeleteFolder(CDETreeView);
end;

{ Data-CD: Delete all }

procedure TForm1.CDESpeedButton5Click(Sender: TObject);
begin
  UserDeleteAll(CDETreeView);
  {mit einem neuen Projekt sollen auch die alten Ausnahmen gel�scgt werden}
  FData.IgnoreNameLengthErrors := False;
  FData.ErrorListIgnore.Clear;  
end;

{ Data-CD: Check filesystem }

procedure TForm1.Sheet1SpeedButtonCheckFSClick(Sender: TObject);
var Node: TTreeNode;
    Path: string;
begin
  FData.IgnoreNameLengthErrors := False;
  FData.ErrorListIgnore.Clear;
  {aktuellen Knoten merken, Wurzel selektieren}
  Path := GetPathFromNode(CDETreeView.Selected);
  CDETreeView.Selected := CDETreeView.Items[0];
  {gesamtes Dateisystem pr�fen}
  CheckDataCDFS;
  {alten Knoten wieder selektieren}
  Node := GetNodeFromPath(CDETreeView.Items[0], Path);
  if Node <> nil then
  begin
    CDETreeView.Selected := Node;
    Node.Expand(False);
  end else
  begin
    CDETreeView.Selected := CDETreeView.Items[0];
  end;
  ShowFolderContent(CDETreeView, CDEListView);
end;

{ XCD: Add file}

procedure TForm1.XCDESpeedButton1Click(Sender: TObject);
begin
  UserAddFile(XCDETreeView);
  ShowFolderContent(XCDETreeView, XCDEListView1);
end;

{ XCD: Add folder}

procedure TForm1.XCDESpeedButton2Click(Sender: TObject);
begin
  UserAddFolder(XCDETreeView);
end;

{ XCD: Delete file }

procedure TForm1.XCDESpeedButton3Click(Sender: TObject);
begin
  UserDeleteFile(XCDETreeView, XCDEListView1);
end;

{ XCD: Add movie }

procedure TForm1.XCDESpeedButton4Click(Sender: TObject);
begin
  FSettings.General.XCDAddMovie := True;
  UserAddFile(XCDETreeView);
  ShowFolderContent(XCDETreeView, XCDEListView1);
end;

{ XCD: Delete movie }

procedure TForm1.XCDESpeedButton5Click(Sender: TObject);
begin
  UserDeleteFile(XCDETreeView, XCDEListView2);
end;

{ XCD: Delete folder }

procedure TForm1.XCDESpeedButton6Click(Sender: TObject);
begin
  UserDeleteFolder(XCDETreeView);
end;

{ XCD: Delete all }

procedure TForm1.XCDESpeedButton7Click(Sender: TObject);
begin
  UserDeleteAll(XCDETreeView);
end;

{ Audio-CD: Add track }

procedure TForm1.AudioSpeedButton1Click(Sender: TObject);
begin
  UserAddTrack;
end;

{ Audio-CD: Move track up }

procedure TForm1.AudioSpeedButton2Click(Sender: TObject);
begin
  if AudioListView.Items.Count > 0 then
  begin
    UserMoveTrack(AudioListView, dUp);
  end;
end;

{ Audio-CD: Move track down }

procedure TForm1.AudioSpeedButton3Click(Sender: TObject);
begin
  if AudioListView.Items.Count > 0 then
  begin
    UserMoveTrack(AudioListView, dDown);
  end;
end;

{ Audio-CD: Delete track}

procedure TForm1.AudioSpeedButton4Click(Sender: TObject);
begin
  UserDeleteFile(nil, AudioListView);
end;

{ Video-CD: Add track }

procedure TForm1.VideoSpeedButton1Click(Sender: TObject);
begin
  UserAddTrack;
end;

{ Video-CD: Move track up }

procedure TForm1.VideoSpeedButton2Click(Sender: TObject);
begin
  if VideoListView.Items.Count > 0 then
  begin
    UserMoveTrack(VideoListView, dUp);
  end;
end;

{ Video-CD: Move track down }

procedure TForm1.VideoSpeedButton3Click(Sender: TObject);
begin
  if VideoListView.Items.Count > 0 then
  begin
    UserMoveTrack(VideoListView, dDown);
  end;
end;

{ Video-CD: Delete track}

procedure TForm1.VideoSpeedButton4Click(Sender: TObject);
begin
  UserDeleteFile(nil, VideoListView);
end;

{ Fix CD }

procedure TForm1.SpeedButtonFixCDClick(Sender: TObject);
begin
  SetSettings;
  FSettings.Cdrecord.FixDevice := FDevices.CDWriter.Values[
                                    FDevices.CDWriter.Names[
                                      FSettings.General.TabSheetDrive[
                                        FSettings.General.Choice]]];
  FSettings.General.Choice := cFixCD;
  FAction.Action := FSettings.General.Choice;
  FAction.StartAction;
end;

{ Kontextmen�-Events ----------------------------------------------------------}

{ Kontextmen� der Tree-Views ---------------------------------------------------

  Das Tree-View-Kontextmen� wird sowohl f�r den CDETreeeView als auch f�r den
  XCDETreeView verwendet.                                                      }

{ OnPopUp-----------------------------------------------------------------------

  Allgemeines Event, wenn das Popup-Men� aufgrufen wurde. In Abh�ngigkeit des
  selektierten Knotens werden die nicht gew�nschten Eintr�ge des Men�s
  ausgeblenden.                                                                }

procedure TForm1.CDETreeViewPopupMenuPopup(Sender: TObject);
var Node: TTreeNode;
    Root: TTreeNode;
begin
  case FSettings.General.Choice of
    cDataCD: begin
               Node := CDETreeView.Selected;
               Root := CDETreeView.Items[0];
             end;
    cXCD   : begin
               Node := XCDETreeView.Selected;
               Root := XCDETreeView.Items[0];
             end;
  else
    Node := nil;
    Root := nil;
  end;
  if Node = Root then
  begin
    CDETreeViewPopupSetCDLabel.Visible := True;
    CDETreeViewPopupN1.Visible := True;
    CDETreeViewPopupAddFolder.Visible := True;
    CDETreeViewPopupAddFile.Visible := True;
    CDETreeViewPopupN2.Visible := True;
    CDETreeViewPopupDeleteFolder.Visible := False;
    CDETreeViewPopupRenameFolder.Visible := False;
    CDETreeViewPopupN3.Visible := False;
    CDETreeViewPopupNewFolder.Visible := True;
  end else
  begin
    CDETreeViewPopupSetCDLabel.Visible := False;
    CDETreeViewPopupN1.Visible := False;
    CDETreeViewPopupAddFolder.Visible := True;
    CDETreeViewPopupAddFile.Visible := True;
    CDETreeViewPopupN2.Visible := True;
    CDETreeViewPopupDeleteFolder.Visible := True;
    CDETreeViewPopupRenameFolder.Visible := True;
    CDETreeViewPopupN3.Visible := True;
    CDETreeViewPopupNewFolder.Visible := True;
  end;
end;

{ Data-CD, XCD: Set CD label }

procedure TForm1.CDETreeViewPopupSetCDLabelClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: UserSetCDLabel(CDETreeView);
    cXCD   : UserSetCDLabel(XCDETreeView);
  end;
end;

{ Data-CD, XCD: Add folder }

procedure TForm1.CDETreeViewPopupAddFolderClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: begin
               UserAddFolder(CDETreeView);
             end;
    cXCD   : begin
               UserAddFolder(XCDETreeView);
             end;
  end;
end;

{ Data-CD, XCD: Add file }

procedure TForm1.CDETreeViewPopupAddFileClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: begin
               UserAddFile(CDETreeView);
               ShowFolderContent(CDETreeView, CDEListView);
             end;
    cXCD   : begin
               UserAddFile(XCDETreeView);
               ShowFolderContent(XCDETreeView, XCDEListView1);
             end;
  end;
end;

{ Data-CD, XCD: Delete folder }

procedure TForm1.CDETreeViewPopupDeleteFolderClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: begin
               UserDeleteFolder(CDETreeView);
             end;
    cXCD   : begin
               UserDeleteFolder(XCDETreeView);
             end;
  end;
end;

{ Data-CD, XCD: Rename folder }

procedure TForm1.CDETreeViewPopupRenameFolderClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: begin
               UserRenameFolderByKey(CDETreeView);
             end;
    cXCD   : begin
               UserRenameFolderByKey(XCDETreeView);
             end;
  end;
end;

{ Data-CD, XCD: Create new folder }

procedure TForm1.CDETreeViewPopupNewFolderClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: UserNewFolder(CDETreeView);
    cXCD   : UserNewFolder(XCDETreeView);
  end;
end;

{ Kontextmen� der List-Views ---------------------------------------------------

  Das List-View-Kontextmen� wird sowohl f�r den CDEListView als auch f�r den
  XCDEListView verwendet.
  Das Audio-List-View-Kontextmen� wird sowohl f�r der AudioListView als auch f�r
  VideoListView verwendet.                                                     }

{ OnPopup ----------------------------------------------------------------------

  in Abh�ngigkeit des List-Views, und der Anzahl der selektierten Dateien werden
  Men�-Eintr�ge ein- bzw. ausgeblendet.                                        }

procedure TForm1.CDEListViewPopupMenuPopup(Sender: TObject);
var ListView: TListView;
begin
  ListView := (Sender as TPopupMenu).PopupComponent as TListView;
  if ListView.SelCount = 0 then
  begin
    CDEListViewPopupAddFile.Visible := True;
    CDEListViewPopupN1.Visible := False;
    CDEListViewPopupRenameFile.Visible := False;
    CDEListViewPopupDeleteFile.Visible := False;
  end else
  if ListView.SelCount = 1 then
  begin
    CDEListViewPopupAddFile.Visible := True;
    CDEListViewPopupN1.Visible := True;
    CDEListViewPopupRenameFile.Visible := True;
    CDEListViewPopupDeleteFile.Visible := True;
  end else
  begin
    CDEListViewPopupAddFile.Visible := True;
    CDEListViewPopupN1.Visible := True;
    CDEListViewPopupRenameFile.Visible := False;
    CDEListViewPopupDeleteFile.Visible := True;
  end;
  if ListView = XCDEListView2 then
  begin
    CDEListViewPopupAddFile.Visible := False;
    CDEListViewPopupAddMovie.Visible := True;
    CDEListViewPopupRenameFile.Visible := False;
  end else
  if ListView = XCDEListView1 then
  begin
    CDEListViewPopupRenameFile.Visible := False;
  end else
  begin
    CDEListViewPopupAddMovie.Visible := False;
  end;
end;

{ Data-CD, XCD: Add file }

procedure TForm1.CDEListViewPopupAddFileClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: begin
               UserAddFile(CDETreeView);
               ShowFolderContent(CDETreeView, CDEListView);
             end;
    cXCD   : begin
               UserAddFile(XCDETreeView);
               ShowFolderContent(XCDETreeView, XCDEListView1);
             end;
  end;
end;

{ XCD: Add file as Form2 file }

procedure TForm1.CDEListViewPopupAddMovieClick(Sender: TObject);
begin
  FSettings.General.XCDAddMovie := True;
  UserAddFile(XCDETreeView);
  ShowFolderContent(XCDETreeView, XCDEListView1);
end;

{ Data-CD: Rename file }

procedure TForm1.CDEListViewPopupRenameFileClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: begin
               UserRenameFile(CDEListView);
             end;
    cXCD   : {wird zur Zeit von Mode2CDMaker nicht unterst�tzt};
  end;
end;

{ Data-CD, XCD: Delete file }

procedure TForm1.CDEListViewPopupDeleteFileClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cDataCD: UserDeleteFile(CDETreeView, CDEListView);
    cXCD   : UserDeleteFile(XCDETreeView,
                            TListView(CDEListViewPopupMenu.PopupComponent));
  end;
end;

{ OnPopup ----------------------------------------------------------------------

  in Abh�ngigkeit der Anzahl der Tracks werden die Men�-Eintr�ge ein- bzw.
  ausgeblendet.                                                                }

procedure TForm1.AudioListViewPopupMenuPopup(Sender: TObject);
var ListView: TListView;
begin
  case FSettings.General.Choice of
    cAudioCD: ListView := AudioListView;
    cVideoCD: ListView := VideoListView;
  else
    ListView := nil;
  end;
  if ListView.SelCount = 0 then
  begin
    AudioListViewPopupAddTrack.Visible := True;
    AudioListViewPopupDeleteTrack.Visible := False;
    AudioListViewPopupN1.Visible := False;
    AudioListViewPopupMoveUp.Visible := False;
    AudioListViewPopupMoveDown.Visible := False;
  end else
  begin
    AudioListViewPopupAddTrack.Visible := True;
    AudioListViewPopupDeleteTrack.Visible := True;
    AudioListViewPopupN1.Visible := True;
    if ListView.Selected.Index = 0 then
    begin
      AudioListViewPopupMoveUp.Visible := False;
      AudioListViewPopupMoveDown.Visible := True;
    end else
    if ListView.Selected.Index = ListView.Items.Count - 1 then
    begin
      AudioListViewPopupMoveUp.Visible := True;
      AudioListViewPopupMoveDown.Visible := False;
    end else
    begin
      AudioListViewPopupMoveUp.Visible := True;
      AudioListViewPopupMoveDown.Visible := True;
    end;
  end;
end;

{ Audio-/Video-CD: Add track }

procedure TForm1.AudioListViewPopupAddTrackClick(Sender: TObject);
begin
  UserAddTrack;
end;

{ Audio-/Video-CD: Delete track }

procedure TForm1.AudioListViewPopupDeleteTrackClick(Sender: TObject);
begin
  case FSettings.General.Choice of
    cAudioCD: UserDeleteFile(nil, AudioListView);
    cVideoCD: UserDeleteFile(nil, VideoListView);
  end;                                 
end;

{ Audio-CD: Move track up }

procedure TForm1.AudioListViewPopupMoveUpClick(Sender: TObject);
var ListView: TListView;
begin
  case FSettings.General.Choice of
    cAudioCD: ListView := AudioListView;
    cVideoCD: ListView := VideoListView;
  else
    ListView := nil;
  end;
  if ListView.Items.Count > 0 then
  begin
    UserMoveTrack(ListView, dUp);
  end;
end;

{ Audio-CD: Move track down }

procedure TForm1.AudioListViewPopupMoveDownClick(Sender: TObject);
var ListView: TListView;
begin
  case FSettings.General.Choice of
    cAudioCD: ListView := AudioListView;
    cVideoCD: ListView := VideoListView;
  else
    ListView := nil;
  end;
  if ListView.Items.Count > 0 then
  begin
    UserMoveTrack(ListView, dDown);
  end;
end;

{ Kontextmen�, sonstiges  ------------------------------------------------------

  Dieses Kontextmen� wird f�r sonstige Zwecke verwendet, die nicht zu einer
  bestimmten Aufgabe oder Option passen.                                       }

{ OnPopup ----------------------------------------------------------------------

  in Abh�ngigkeit des List-Views, und der Anzahl der selektierten Dateien werden
  Men�-Eintr�ge ein- bzw. ausgeblendet.                                        }

procedure TForm1.MiscPopupMenuPopup(Sender: TObject);
begin
  if ((Sender as TPopupMenu).PopupComponent = CheckBoxDataCDVerify) or
     ((Sender as TPopupMenu).PopupComponent = CheckBoxXCDVerify) then
  begin
    MiscPopupVerify.Visible := True;
    MiscPopupClearOutput.Visible := False;
  end else
  if ((Sender as TPopupMenu).PopupComponent = ButtonShowOutput) then
  begin
    MiscPopupVerify.Visible := False;
    MiscPopupClearOutput.Visible := True;
  end;
end;

{ Verify }

procedure TForm1.MiscPopupVerifyClick(Sender: TObject);
var OTF: Boolean;
    XCDPath: string;
begin
  {Um sicherzustellen, da� nicht �ber einen fehlenden Namen f�r das Image ge-
   meckert wird, t�uschen wir einfach otf vor bzw. setzten einfach einen Image-
   Namen ein (XCD).}
  OTF := FSettings.DataCD.OnTheFly;
  FSettings.DataCD.OnTheFly := True;
  XCDPath := FSettings.XCD.IsoPath;
  FSettings.XCD.IsoPath := 'dummy';
  {Auf 'Image-only' und 'dummy' wird nicht mehr gepr�ft, da sonst m�glicherweise
   ein selbst erstelltes und sp�ter geschriebenes Image nicht verifiziert werden
   kann.}
  if (FSettings.General.Choice = cDataCD) and InputOk {and
     not (FSettings.DataCD.ImageOnly or FSettings.Cdrecord.Dummy)} then
  begin
    FAction.Action := cVerify;
    FAction.Reload := False;
    FAction.StartAction;
  end else
  if (FSettings.General.Choice = cXCD) and InputOk then
  begin
    FAction.Action := cVerifyXCD;
    FAction.Reload := False;
    FAction.StartAction;
  end;
  {Alten Wert wiederherstellen.}
  FSettings.DataCD.OnTheFly := OTF;
  FSettings.XCD.IsoPath := XCDPath;
end;

{ Clear output }

procedure TForm1.MiscPopupClearOutputClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;


{ CheckBox-Events ------------------------------------------------------------ }

{ OnClick ----------------------------------------------------------------------

  Nach einen Klick auf eine Check-Box mu� sichergestellt sein, da� die Controls
  in einem konsistenten Zustand sind.

  Diese Prozedur wird auch f�r das OnClick-Event der Radio-Buttuns verwendet.  }

procedure TForm1.CheckBoxClick(Sender: TObject);
begin
  CheckControls;
end;


{ Edit-Events ---------------------------------------------------------------- }

{ OnKeyPress -------------------------------------------------------------------

  allgemein: nach Enter soll zum n�chsten Control gewechselt werden.           }

procedure TForm1.EditKeyPress(Sender: TObject; var Key: Char);
var C: TControl;
begin
  C := Sender as TControl;
  if Key = EnterKey then
  begin
    Key := NoKey;
    if C = EditDAEPath then
    begin
      EditDAEPrefix.SetFocus;
    end else
    if C = EditDAEPrefix then
    begin
      PageControl1.SetFocus;
    end else
    if C = EditReadCDIsoPath then
    begin
      ButtonReadCDSelectPath.SetFocus;
    end else
    if C = EditReadCDStartSec then
    begin
      EditReadCDEndSec.SetFocus;
    end else
    if C = EditReadCDEndSec then
    begin
      PageControl1.SetFocus;
    end else
    if C = EditImageIsoPath then
    begin
      ButtonImageSelectPath.SetFocus;
    end else
    if C = ComboBoxDrives then
    begin
      ComboBoxSpeed.SetFocus;
    end else
    if C = ComboBoxSpeed then
    begin
      ButtonStart.SetFocus;
    end;
  end;
end;

{ OnExit -----------------------------------------------------------------------

  Wenn das EditImageIsoPath verlassen wird, m�ssenin Abh�nigkeit der Dateiendung
  des Images die Controls angepa�t werden.                                     }

procedure TForm1.EditExit(Sender: TObject);
begin
  if (Sender as TEdit) = EditImageIsoPath then
  begin
    CheckControls;
  end;
end;


{ ComboBox-Events ------------------------------------------------------------ }

{ OnChange ---------------------------------------------------------------------

  Die ausgew�hlten Laufwerke sollen f�r jedes Tab-Sheet getrennt gespeichert
  werden. Ebenso die Geschwindigkeit.                                          }

procedure TForm1.ComboBoxChange(Sender: TObject);
begin
  if (Sender as TComboBox) = ComboBoxDrives then
  begin
    FSettings.General.TabSheetDrive[FSettings.General.Choice] :=
      ComboBoxDrives.ItemIndex;
  end else
  if (Sender as TComboBox) = ComboBoxSpeed then
  begin
    FSettings.General.TabSheetSpeed[FSettings.General.Choice] :=
      ComboBoxSpeed.ItemIndex;
  end;
end;


{ Label-Events --------------------------------------------------------------- }

{ OnClick ----------------------------------------------------------------------

  Beim Klick auf ein Label, das den Zustand einer Option darstellt, soll die
  Option (de-)aktiviert werden. Das Umschalten erfolgt in einer eigenen
  Prozedur.
                                                             }
{$IFDEF AllowToggle}
procedure TForm1.LabelClick(Sender: TObject);
begin
  ToggleOptions(Sender);
end;
{$ENDIF}

{ MouseOver --------------------------------------------------------------------

  Die Labels sollen anzeigen k�nnen, da� sie klickbar sind, wenn der Mauszeiger
  auf ihnen ist.                                                               }

{$IFDEF MouseOverLabelHighlight}
procedure TForm1.LabelMouseMove(Sender: TObject; Shift: TShiftState;
                                X, Y: Integer);
begin
  (Sender as TLabel).Color := clInactiveCaptionText;
end;
{$ENDIF}


{ Panel-Events --------------------------------------------------------------- }

{ MouseOver --------------------------------------------------------------------

  Setzt die Markierung eines Labels zur�ck, wenn es verlassen wird.            }

{$IFDEF MouseOverLabelHighlight}
procedure TForm1.PanelMouseMove(Sender: TObject; Shift: TShiftState;
                                X, Y: Integer);
var Panel: TPanel;
    i: Integer;
begin
  Panel := Sender as TPanel;
  for i := 0 to Panel.ControlCount - 1 do
  begin
    if Panel.Controls[i] is TLabel then
    begin
      (Panel.Controls[i] as TLabel).Color := clBtnFace;
    end;
  end;
end;
{$ENDIF}

initialization
  {$IFDEF ShowDebugWindow}
  FormDebug := TFormDebug.Create(nil);
  FormDebug.Top := 0;
  FormDebug.Left := 0;
  FormDebug.Show;
  {$ENDIF}
  {$IFDEF ShowTime}
  TC  := TTimeCount.Create;
  TC2 := TTimeCount.Create;
  {$ENDIF}

finalization
  {$IFDEF ShowDebugWindow}
  FormDebug.Free;
  {$ENDIF}
  {$IFDEF ShowTime}
  TC.Free;
  TC2.Free;  
  {$ENDIF}

end.