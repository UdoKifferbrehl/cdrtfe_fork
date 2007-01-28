{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  frm_dae_options.pas: DAE: Optionen

  Copyright (c) 2006 Oliver Valencia

  letzte �nderung  11.09.2006

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.  

}

unit frm_dae_options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  {eigene Klassendefinitionen/Units}
  cl_settings, cl_lang, ComCtrls;

type
  TFormDAEOptions = class(TForm)
    ButtonOk: TButton;
    ButtonCancel: TButton;
    PageControlDAE: TPageControl;
    TabSheetDAE: TTabSheet;
    GroupBoxFileNames: TGroupBox;
    RadioButtonDAEUsePrefix: TRadioButton;
    RadioButtonDAEUseNamePattern: TRadioButton;
    EditDAEPrefix: TEdit;
    EditDAENamePattern: TEdit;
    GroupBoxOptions: TGroupBox;
    CheckBoxDAEBulk: TCheckBox;
    CheckBoxDAELibParanoia: TCheckBox;
    CheckBoxDAENoInfofiles: TCheckBox;
    TabSheetCDDB: TTabSheet;
    GroupBox1: TGroupBox;
    CheckBoxDAEUseCDDB: TCheckBox;
    EditDAECDDBServer: TEdit;
    EditDAECDDBPort: TEdit;
    LabelCDDBServer: TLabel;
    LabelCDDBPort: TLabel;
    GroupBoxDAEFormat: TGroupBox;
    RadioButtonDAEWav: TRadioButton;
    RadioButtonDAEMp3: TRadioButton;
    RadioButtonDAEOgg: TRadioButton;
    RadioButtonDAEFlac: TRadioButton;
    TabSheetCompression: TTabSheet;
    GroupBoxDAETags: TGroupBox;
    CheckBoxDAETags: TCheckBox;
    GroupBoxDAEFlac: TGroupBox;
    TrackBarFlac: TTrackBar;
    LabelDAEFlacCurQuality: TLabel;
    LabelDAEFlac1: TLabel;
    GroupBoxDAEOgg: TGroupBox;
    TrackBarOgg: TTrackBar;
    LabelDAEOggCurQuality: TLabel;
    LabelDAEOgg1: TLabel;
    GroupBoxDAEMp3: TGroupBox;
    ComboBoxDAEMp3Quality: TComboBox;
    RadioButtonDAECustom: TRadioButton;
    GroupBoxDAECustom: TGroupBox;
    EditCustomCmd: TEdit;
    EditCustomOpt: TEdit;
    LabelCustomCmd: TLabel;
    LabelCustomOpt: TLabel;
    procedure ButtonOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure TrackBarChange(Sender: TObject);
    procedure EditExit(Sender: TObject);
  private
    { Private declarations }
    FSettings: TSettings;
    FLang: TLang;
    function GetActivePage: Byte;
    function InputOk: Boolean;
    procedure ActivateTab;
    procedure CheckControls(Sender: TObject);
    procedure GetSettings;
    procedure SetSettings;
  public
    { Public declarations }
    property Lang: TLang read FLang write FLang;
    property Settings: TSettings read FSettings write FSettings;
  end;

{ var }

implementation

{$R *.DFM}

uses f_misc, constant;

{var}

{ ActivateTab ------------------------------------------------------------------

  ActivateTab zeigt das TabSheet an, das in FSettings.General.TabFrmSettings
  angegeben ist.                                                               }

procedure TFormDAEOptions.ActivateTab;
begin
   PageControlDAE.ActivePage :=
     PageControlDAE.Pages[FSettings.General.TabFrmDAE - 1];
end;

{ GetActivePage ----------------------------------------------------------------

  GetActivePage liefert als Ergebnis die Nummer der aktiven Registerkarte.     }

function TFormDAEOptions.GetActivePage: Byte;
begin
  Result := PageControlDAE.ActivePage.PageIndex + 1;
end;


{ InputOk ----------------------------------------------------------------------

  InputOk �berpr�ft die eingaben auf G�ltigkeit bzw. ob alle n�tigen Infos
  vorhanden sind.                                                              }

function TFormDAEOptions.InputOk: Boolean;
begin
  Result := True;

end;

{ GetSettings ------------------------------------------------------------------

  GetSettings setzt die Controls des Fensters entsprechend den Daten in
  FSettings.                                                                   }

procedure TFormDAEOptions.GetSettings;
begin
  if FSettings.FileFlags.ShNeeded and not FSettings.FileFlags.ShOk then
  begin
    RadioButtonDAEMp3.Enabled := False;
    RadioButtonDAEOgg.Enabled := False;
    RadioButtonDAEFlac.Enabled := False;
    RadioButtonDAECustom.Enabled := False;
  end else
  begin
    RadioButtonDAEMp3.Enabled := FSettings.FileFlags.LameOk;
    RadioButtonDAEOgg.Enabled := FSettings.FileFlags.OggencOk;
    RadioButtonDAEFlac.Enabled := FSettings.FileFlags.FlacOk;
    RadioButtonDAECustom.Enabled := FileExists(FSettings.DAE.CustomCmd);
  end;
  with FSettings.DAE do
  begin
    CheckBoxDAEBulk.Checked              := Bulk;
    CheckBoxDAELibParanoia.Checked       := Paranoia;
    CheckBoxDAENoInfofiles.Checked       := NoInfoFile;
    EditDAEPrefix.Text                   := Prefix;
    EditDAENamePattern.Text              := NamePattern;
    RadioButtonDAEUsePrefix.Checked      := PrefixNames;
    RadioButtonDAEUseNamePattern.Checked := not PrefixNames;
    CheckBoxDAEUseCDDB.Checked           := UseCDDB;
    EditDAECDDBServer.Text               := CDDBServer;
    EditDAECDDBPort.Text                 := CDDBPort;
    RadioButtonDAEMp3.Checked            := Mp3;
    RadioButtonDAEOgg.Checked            := Ogg;
    RadioButtonDAEFlac.Checked           := Flac;
    RadioButtonDAECustom.Checked         := Custom;
    RadioButtonDAEWav.Checked            := not (MP3 or Ogg or Flac or Custom);
    CheckBoxDAETags.Checked              := AddTags;
    TrackBarFlac.Position                := StrToIntDef(FlacQuality, 5);
    TrackBarOgg.Position                 := StrToIntDef(OggQuality, 6);
    EditCustomCmd.Text                   := CustomCmd;
    EditCustomOpt.Text                   := CustomOpt;                                        
    ComboBoxDAEMp3Quality.ItemIndex :=
                                ComboBoxDAEMp3Quality.Items.IndexOf(LamePreset);

  end;
  ActivateTab;
end;

{ SetSettings ------------------------------------------------------------------

  SetSettings �bernimmt die Einstellungen der Controls in FSettings.           }

procedure TFormDAEOptions.SetSettings;
begin
  with FSettings.DAE do
  begin
    Bulk        := CheckBoxDAEBulk.Checked;
    Paranoia    := CheckBoxDAELibParanoia.Checked;
    NoInfoFile  := CheckBoxDAENoInfofiles.Checked;
    Prefix      := EditDAEPrefix.Text;
    NamePattern := EditDAENamePattern.Text;
    PrefixNames := RadioButtonDAEUsePrefix.Checked;
    UseCDDB     := CheckBoxDAEUseCDDB.Checked;
    CDDBServer  := EditDAECDDBServer.Text;
    CDDBPort    := EditDAECDDBPort.Text;
    MP3         := RadioButtonDAEMp3.Checked;
    Ogg         := RadioButtonDAEOgg.Checked;
    Flac        := RadioButtonDAEFlac.Checked;
    Custom      := RadioButtonDAECustom.Checked;
    AddTags     := CheckBoxDAETags.Checked;
    FlacQuality := IntToStr(TrackBarFLAC.Position);
    OggQuality  := IntToStr(TrackBarOgg.Position);
    CustomCmd   := EditCustomCmd.Text;
    CustomOpt   := EditCustomOpt.Text;
    LamePreset  := ComboBoxDAEMp3Quality.Items[ComboBoxDAEMp3Quality.ItemIndex];
  end;
  FSettings.General.TabFrmDAE := GetActivePage;
end;

{ CheckControls ----------------------------------------------------------------

  CheckControls sorgt daf�r, da� bei den Controls keine inkonsistenten
  Einstellungen vorkommen.                                                     }

procedure TFormDAEOptions.CheckControls(Sender: TObject);
begin
  EditDAEPrefix.Enabled := RadioButtonDAEUsePrefix.Checked;
  EditDAENamePattern.Enabled := RAdioButtonDAEUseNamePattern.Checked;
  EditDAECDDBServer.Enabled := CheckBoxDAEUseCDDB.Checked;
  EditDAECDDBPort.Enabled := CheckBoxDAEUseCDDB.Checked;  
end;


{ Button-Events -------------------------------------------------------------- }

{ Ok }

procedure TFormDAEOptions.ButtonOkClick(Sender: TObject);
begin
  if InputOk then
  begin
    SetSettings;
    ModalResult := mrOK;
  end;
end;


{ Form-Events ---------------------------------------------------------------- }

{ OnFormShow -------------------------------------------------------------------

  Wenn das Fenster gezeigt wird, m�ssen die Controls den Daten in FSettings
  entsprechend gesetzt werden.                                                 }

procedure TFormDAEOptions.FormShow(Sender: TObject);
begin
  SetFont(Self);
  FLang.SetFormLang(Self);
  ComboBoxDAEMp3Quality.Items.Assign(FSettings.General.Mp3Qualities);
  GetSettings;
  CheckControls(Sender);
  LabelDAEFlacCurQuality.Caption := IntToStr(TrackBarFlac.Position);
  LabelDAEOggCurQuality.Caption := IntToStr(TrackBarOgg.Position);
end;


{ CheckBox-Events ------------------------------------------------------------ }

{ OnClick ----------------------------------------------------------------------

  Nach einen Klick auf eine Check-Box mu� sichergestellt sein, da� die Controls
  in einem konsistenten Zustand sind.                                          }

procedure TFormDAEOptions.CheckBoxClick(Sender: TObject);
begin
  CheckControls(Sender);
end;

{ OnKeyPress -------------------------------------------------------------------

  ENTER soll bei Edit- und Comboxen zum n�chsten Control weiterschalten.       }

procedure TFormDAEOptions.EditKeyPress(Sender: TObject;
                                           var Key: Char);
var C: TControl;
begin
  C := Sender as TControl;
  if Key = EnterKey then
  begin
    Key := NoKey;
    if (C = EditDAEPrefix) or (C = EditDAENamePattern) then
    begin
      CheckBoxDAEBulk.SetFocus;
    end else
    if C = EditDAECDDBServer then
    begin
      EditDAECDDBPort.SetFocus;
    end else
    if C = EditDAECDDBPort then
    begin
      ButtonOk.SetFocus;
    end else
    if C = EditCustomCmd then
    begin
      EditCustomOpt.SetFocus;
    end else
    if c= EditCustomOpt then
    begin
      ButtonOk.SetFocus;
    end;
  end;
end;


{ TrackBar-Events ------------------------------------------------------------ }

{ OnChange ---------------------------------------------------------------------

  Anzeige aktualisieren.                                                       }

procedure TFormDAEOptions.TrackBarChange(Sender: TObject);
begin
  if Sender as TTrackBar = TrackBarFLAC then
  begin
    LabelDAEFlacCurQuality.Caption := IntToStr(TrackBarFlac.Position);
  end else
  if Sender as TTrackBar = TrackBarOgg then
  begin
    LabelDAEOggCurQuality.Caption := IntToStr(TrackBarOgg.Position);
  end;
end;


{ Edit-Events ---------------------------------------------------------------- }

{ OnExit -----------------------------------------------------------------------

  Eingabe pr�fen.                                                              }

procedure TFormDAEOptions.EditExit(Sender: TObject);
begin
  if Sender as TEdit = EditCustomCmd then
  begin
    if not FileExists((Sender as TEdit).Text) then
    begin
      (Sender as TEdit).Text := '';
      RadioButtonDAECustom.Enabled := False;
    end else
      RadioButtonDAECustom.Enabled := True;
  end;
end;

end.