{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  frm_output.pas: Darstellung der Ausgabe der Konsolenprogramme

  Copyright (c) 2004 Oliver Valencia
  Copyright (c) 2002-2004 Oliver Valencia, Oliver Kutsche

  letzte �nderung  19.07.2004

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.  

}

unit frm_output;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  {eigene Klassendefinitionen/Units}
  cl_lang, cl_settings;


type
  TFormOutput = class(TForm)
    Memo1: TMemo;
    ButtonOk: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FLang: TLang;
    FSettings: TSettings;
  public
    { Public declarations }
    property Lang: TLang read FLang write FLang;
    property Settings: TSettings read FSettings write FSettings;
  end;

{ var }

implementation

uses frm_main;

{$R *.DFM}

procedure TFormOutput.FormCreate(Sender: TObject);
begin
  if Screen.PixelsPerInch > 96 then
  begin
    self.Width := 756;
    self.Height := 629;
  end;
end;

procedure TFormOutput.FormShow(Sender: TObject);
begin
  {falls vorhanden, alte Gr��e und Position wiederherstellen}
  with FSettings.WinPos do
  begin
    if (OutWidth <> 0) and (OutHeight <> 0) then
    begin
      self.Top := OutTop;
      self.Left := OutLeft;
      self.Width := OutWidth;
      self.Height := OutHeight;
    end else
    begin
      {Falls keine Werte vorhanden, dann Fenster zentrieren. Die mu� hier
       manuell geschehen, da poScreenCenter zu Fehlern beim Setzen der
       Eigenschaften f�hrt. Deshalb mu� poDefault verwendet werden.}
      self.Top := (Screen.Height - self.Height) div 2;
      self.Left := (Screen.Width - self.Width) div 2;
    end;
    if OutMaximized then self.WindowState := wsMaximized;
  end;
  FLang.SetFormLang(self);

  {zur ersten Zeile scrollen}
  // Memo1.Perform(EM_LineScroll, 0, -Memo1.Lines.Count - 1);
  {zur letzen Zeile scrollen}
  if FSettings.WinPos.OutScrolled then
    Memo1.Perform(EM_LineScroll, 0, Memo1.Lines.Count - 1);
  ButtonOk.SetFocus;
end;

procedure TFormOutput.FormResize(Sender: TObject);
begin
  if Screen.PixelsPerInch <= 96 then
  begin
    Memo1.Width := self.ClientWidth - 16;
    Memo1.Height := self.ClientHeight - 44;
    ButtonOk.Top := Memo1.Height + 14;
    ButtonOk.Left := Memo1.Width + 8 - 75;
  end else
  if Screen.PixelsPerInch > 96 then
  begin
    Memo1.Width := self.ClientWidth - 16;
    Memo1.Height := self.ClientHeight - 53;
    ButtonOk.Top := ClientHeight - 39;
    ButtonOk.Left := ClientWidth - 8 - ButtonOk.Width;
  end;
end;

procedure TFormOutput.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with FSettings.WinPos do
  begin
    if self.WindowState = wsMaximized then
    begin
      OutMaximized := True;
    end else
    begin
      OutTop := self.Top;
      OutLeft := self.Left;
      OutWidth := self.Width;
      OutHeight := self.Height;
      OutMaximized := False;
    end;
  end;
end;

procedure TFormOutput.Memo1KeyDown(Sender: TObject; var Key: Word;
                                   Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close;
  end;
end;

end.