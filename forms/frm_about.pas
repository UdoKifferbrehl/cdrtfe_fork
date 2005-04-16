{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  frm_about.pas: About-Dialog

  Copyright (c) 2004-2005 Oliver Valencia
  Copyright (c) 2002-2004 Oliver Valencia, Oliver Kutsche

  letzte �nderung  13.04.2005

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.  

}

unit frm_about;

{$I directives.inc}

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ExtCtrls, ShellAPI, ComCtrls,
     cl_lang;

type
  TFormAbout = class(TForm)
    Button1: TButton;
    Image1: TImage;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    RichEdit1: TRichEdit;
    StaticText6: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FLang: TLang;
  public
    { Public declarations }
    property Lang: TLang read Flang write FLang;
  end;

{ var }

implementation

{$R *.DFM}

{$R ../resource/license.res}

uses constant;

const Cdrtfe_Version     = 'cdrtfe 1.1pre4'
                           {$IFDEF TestVersion} + '-test' {$ENDIF};
      Cdrtfe_Description = 'cdrtools/Mode2CDMaker/VCDImager Front End';
      Cdrtfe_Copyright   = 'Copyright � 2004-2005  O. Valencia';
      Cdrtfe_Copyright2  = 'Copyright � 2002-2004  O. Valencia, O. Kutsche';
      Cdrtfe_Homepage    = 'http://www.cdrtfe.de.vu';
      // Cdrtfe_Homepage    = 'http://home.arcor.de/kerberos002';
      Cdrtfe_eMail       = 'kerberos002@arcor.de';
      {$IFDEF TestVersion}
      Cdrtfe_HintTest    = 'Achtung/Attention!' + CRLF + CRLF +
                           'Dies ist eine Testversion, die noch schwere ' +
                           'Fehler enthalten k�nnte.' + CRLF + CRLF +
                           'This is a test version which still may have ' +
                           'severe bugs.' + CRLF + CRLF;
      {$ENDIF}

procedure TFormAbout.FormCreate(Sender: TObject);
var TempStream : TResourceStream;
begin
  StaticText1.Caption := Cdrtfe_Version;
  StaticText2.Caption := Cdrtfe_Description;
  StaticText3.Caption := Cdrtfe_Copyright;
  StaticText6.Caption := Cdrtfe_Copyright2;
  Label1.Caption      := Cdrtfe_Homepage;
  Label2.Caption      := Cdrtfe_eMail;

  Label1.Font.Color:=clBlue;
  Label1.Font.Style:=[fsUnderline];
  Label1.Cursor:=crHandPoint;

  Label2.Font.Color:=clBlue;
  Label2.Font.Style:=[fsUnderline];
  Label2.Cursor:=crHandPoint;

  TempStream := TResourceStream.Create(hInstance, 'License', RT_RCDATA);

  try
    TempStream.Position := 0;
    RichEdit1.Lines.LoadFromStream(TempStream);
  finally
    TempStream.Free;
  end;

  {$IFDEF TestVersion}
  RichEdit1.Lines.Insert(0, Cdrtfe_HintTest);
  {$ENDIF}

end;

procedure TFormAbout.Label1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open',
               PCHar(Label1.Caption), nil, nil,
               SW_ShowNormal);
end;

procedure TFormAbout.Label2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,
               'open',
               PChar('mailto:' + Label2.Caption + '?subject=[cdrtfe]'),
               nil, nil,
               SW_SHOWNORMAL);
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin
  FLang.SetFormLang(self);
end;

initialization

end.