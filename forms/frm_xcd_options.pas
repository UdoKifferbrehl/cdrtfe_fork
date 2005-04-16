{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  frm_audiocd_options.pas: Audio-CD: Optionen

  Copyright (c) 2004-2005 Oliver Valencia
  Copyright (c) 2002-2004 Oliver Valencia, Oliver Kutsche

  letzte �nderung  27.03.2005

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.  

}

unit frm_xcd_options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  {eigene Klassendefinitionen/Units}
  cl_settings, cl_lang;

type
  TFormXCDOptions = class(TForm)
    GroupBoxImage: TGroupBox;
    EditIsoPath: TEdit;
    ButtonImageSelect: TButton;
    CheckBoxImageOnly: TCheckBox;
    CheckBoxImageKeep: TCheckBox;
    GroupBoxISO: TGroupBox;
    RadioButtonISOLevelX: TRadioButton;
    RadioButtonISOLevel1: TRadioButton;
    RadioButtonISOLevel2: TRadioButton;
    SaveDialog1: TSaveDialog;
    CheckBoxSingle: TCheckBox;
    GroupBoxOptions: TGroupBox;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    CheckBoxKeepExt: TCheckBox;
    EditExt: TEdit;
    Label1: TLabel;
    CheckBoxOverburn: TCheckBox;
    GroupBoxInfoFile: TGroupBox;
    CheckBoxCreateInfoFile: TCheckBox;
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonImageSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FSettings: TSettings;
    FLang: TLang;
    function InputOk: Boolean;
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

uses constant;

{ InputOk ----------------------------------------------------------------------

  InputOk �berpr�ft die eingaben auf G�ltigkeit bzw. ob alle n�tigen Infos
  vorhanden sind.                                                              }

function TFormXCDOptions.InputOk: Boolean;
begin
  Result := True;
  if EditIsoPath.Text = '' then
  begin
    // Fehlermeldung := 'Name f�r die Image-Datei fehlt!';
    Application.MessageBox(PChar(FLang.GMS('e101')), PChar(FLang.GMS('g001')),
      MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL);
    Result := False;
  end;
end;

{ GetSettings ------------------------------------------------------------------

  GetSettings setzt die Controls des Fensters entsprechend den Daten in
  FSettings.                                                                   }

procedure TFormXCDOptions.GetSettings;
begin
  with FSettings.XCD do
  begin
    EditIsoPath.Text               := IsoPath;
    CheckBoxImageOnly.Checked      := ImageOnly;
    CheckBoxImageKeep.Checked      := KeepImage;
    CheckBoxSingle.Checked         := Single;
    CheckBoxKeepExt.Checked        := KeepExt;
    EditExt.Text                   := Ext;
    RadioButtonISOLevelX.Checked   := not (ISOLevel1 or ISOLevel2);
    RadioButtonISOLevel1.Checked   := IsoLevel1;
    RadioButtonISOLevel2.Checked   := IsoLevel2;
    CheckBoxOverburn.Checked       := Overburn;
    CheckBoxCreateInfoFile.Checked := CreateInfoFile;
  end;
  {falls cdrdao nicht vorhanden ist, kann nur ein Image erzeugt werden.}
  if not (FSettings.FileFlags.CdrdaoOk or
          FSettings.Cdrecord.CanWriteCueImage) then
  begin
    CheckBoxImageOnly.Checked := True;
    CheckBoxImageOnly.Enabled := False;
    CheckBoxImageKeep.Enabled := False;
    CheckBoxOverburn.Enabled := False;
  end;
end;

{ SetSettings ------------------------------------------------------------------

  SetSettings �bernimmt die Einstellungen der Controls in FSettings.           }

procedure TFormXCDOptions.SetSettings;
begin
  with FSettings.XCD do
  begin
    IsoPath        := EditIsoPath.Text;
    ImageOnly      := CheckBoxImageOnly.Checked;
    KeepImage      := CheckBoxImageKeep.Checked;
    Single         := CheckBoxSingle.Checked;
    KeepExt        := CheckBoxKeepExt.Checked;
    Ext            := EditExt.Text;
    IsoLevel1      := RadioButtonISOLevel1.Checked;
    IsoLevel2      := RadioButtonISOLevel2.Checked;
    OverBurn       := CheckBoxOverburn.Checked;
    CreateInfoFile := CheckBoxCreateInfoFile.Checked;
  end;
end;

{ CheckControls ----------------------------------------------------------------

  CheckControls sorgt daf�r, da� bei den Controls keine inkonsistenten
  Einstellungen vorkommen.                                                     }

procedure TFormXCDOptions.CheckControls(Sender: TObject);
begin
  if Sender is TCheckBox then
  begin
    {Info-Datei nur ohne ISO-Level 1/2}
    if (Sender as TCheckBox) = CheckBoxCreateInfoFile then
    begin
      if CheckBoxCreateInfoFile.Checked then
      begin
        RadioButtonIsoLevel1.Enabled := False;
        RadioButtonIsoLevel2.Enabled := False;
      end else
      begin
        RadioButtonIsoLevel1.Enabled := True;
        RadioButtonIsoLevel2.Enabled := True;
      end;
    end;
    {nur Image erstellen/Image behalten}
    if (Sender as TCheckBox) = CheckBoxImageOnly then
    begin
      if CheckBoxImageOnly.Checked then
      begin
        CheckBoxImageKeep.Checked := False;
      end;
    end;
    if (Sender as TCheckBox) = CheckBoxImageKeep then
    begin
      if CheckBoxImageKeep.Checked then
      begin
        CheckBoxImageOnly.Checked := False;
      end;
    end;
  end;
  if Sender is TRadioButton then
  begin
    {bei ISO-Level 1/2 keine Info-Datei}
    if RadioButtonIsoLevel1.Checked or RadioButtonIsoLevel2.Checked then
    begin
      CheckBoxCreateInfoFile.Enabled := False;
    end else
    begin
      CheckBoxCreateInfoFile.Enabled := True;
    end;
  end;
end;


{ Button-Events -------------------------------------------------------------- }

{ Ok }

procedure TFormXCDOptions.ButtonOkClick(Sender: TObject);
begin
  if InputOk then
  begin
    SetSettings;
    ModalResult := mrOK;
  end;
end;

{ SelectImage }

procedure TFormXCDOptions.ButtonImageSelectClick(Sender: TObject);
begin
  SaveDialog1 := TSaveDialog.Create(self);
  SaveDialog1.Title := FLang.GMS('m102');
  SaveDialog1.DefaultExt := '';
  SaveDialog1.Filter := FLang.GMS('f003');
  SaveDialog1.Options := [ofOverwritePrompt, ofHideReadOnly];
  if SaveDialog1.Execute then
  begin
    EditIsoPath.Text := SaveDialog1.FileName;
  end;
  SaveDialog1.Free;
end;


{ Form-Events ---------------------------------------------------------------- }

{ OnFormShow -------------------------------------------------------------------

  Wenn das Fenster gezeigt wird, m�ssen die Controls den Daten in FSettings
  entsprechend gesetzt werden.                                                 }

procedure TFormXCDOptions.FormShow(Sender: TObject);
begin
  FLang.SetFormLang(self);
  GetSettings;
  CheckControls(Sender);
end;


{ CheckBox-Events ------------------------------------------------------------ }

{ OnClick ----------------------------------------------------------------------

  Nach einen Klick auf eine Check-Box mu� sichergestellt sein, da� die Controls
  in einem konsistenten Zustand sind.                                          }

procedure TFormXCDOptions.CheckBoxClick(Sender: TObject);
begin
  CheckControls(Sender);
end;

{ OnKeyPress -------------------------------------------------------------------

  ENTER soll bei Edit- und Comboxen zum n�chsten Control weiterschalten.       }

procedure TFormXCDOptions.EditKeyPress(Sender: TObject;
                                       var Key: Char);
var C: TControl;
begin
  C := Sender as TControl;
  if Key = EnterKey then
  begin
    Key := NoKey;
    if C = EditIsoPath then
    begin
      CheckBoxImageOnly.SetFocus;
    end else
    if C = EditExt then
    begin
      ButtonOk.SetFocus;
    end;
  end;
end;

end.