{ cdrtfedbg: cdrtools/Mode2CDMaker/VCDImager Frontend, Debug-DLL

  f_dllfuncs.pas: Exportierte Funktionen der Debug-DLL

  Copyright (c) 2007-2008 Oliver Valencia

  letzte �nderung  12.01.2008

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.  

  f_dllfuncs.pas stellt Funktionen dieser DLL nach au�en hin zur Verf�gung:
    * Debug-Fenster erstellen und freigeben
    * Strings bzw. String-Listen ans Logfile anh�ngen
    * vordefinierte Strings ans Logfile anh�ngen


  exportierte Funktionen/Prozeduren:

    InitDebugForm(const AppHandle: THandle)
    FreeDebugForm
    ShowDebugForm
    AddLogStr(Value: PChar; Mode: Byte)
    AddLogPreDef(Value: Integer)

}

unit f_dllfuncs;

interface

uses Windows, Forms, SysUtils;

procedure InitDebugForm(const AppHandle: THandle); stdcall;
procedure FreeDebugForm;
procedure ShowDebugForm;
procedure AddLogStr(Value: PChar; Mode: Byte); stdcall;
procedure AddLogPreDef(Value: Integer); stdcall;
procedure SetAutoSave(Value: Integer); stdcall;
procedure SetLogFile(Value: PChar); stdcall;

implementation

uses frm_dbg, f_log;

var FormDebug     : TFormDebug;
    OldHandle     : THandle;
    LogFileName   : string;
    AutoSave      : Boolean;

{ exportierte DLL-Funktionen ------------------------------------------------- }

{ InitDebugForm ----------------------------------------------------------------

  Debug-Fenster erstellen und Handles entsprechen setzten.                     }

procedure InitDebugForm(const AppHandle: THandle); stdcall;
begin
  OldHandle := Application.Handle;
  Application.Handle := AppHandle;
  FormDebug := TFormDebug.Create(Application);
  FormDebug.LogFileName := LogFileName;
  FormDebug.AutoSave := AutoSave;
end;

{ FreeDebugForm ----------------------------------------------------------------

  Debug-Fenster freigeben und urspr�ngliches Handle wiederherstellen.          }

procedure FreeDebugForm;
begin
  FormDebug.Close;
  FormDebug.Release;
  Application.Handle := OldHandle;
end;

{ ShowDebugForm ----------------------------------------------------------------

  Debug-Fenster anzeigen.                                                      }

procedure ShowDebugForm;
begin
  try
    FormDebug.Show;
  except
  end;
end;

{ AddLogStr --------------------------------------------------------------------

  AddLog f�gt eine Zeile an das Log-File an.                                   }

procedure AddLogStr(Value: PChar; Mode: Byte); stdcall;
begin
  AddLogStrInt(string(Value), Mode, FormDebug.MemoLog.Lines);
end;

{ AddLogPreDef -----------------------------------------------------------------

  AddLogPreDef f�gt die durch Value bestimmte Zeige an das Log-File an.        }

procedure AddLogPreDef(Value: Integer); stdcall;
begin
  AddLogPreDefInt(Value, FormDebug.MemoLog.Lines);
end;

{ SetLogFile -------------------------------------------------------------------

  SetLogFile legt den Namen fest, unter dem das Logfile gespeichert werden
  soll.                                                                        }

procedure SetLogFile(Value: PChar); stdcall;
var TempStr: PChar;
begin
  TempStr := StrNew(Value);
  LogFileName := string(TempStr);
  StrDispose(TempStr);
end;

{ SetAutoSave ------------------------------------------------------------------

  SetAutoSave legt fest, ob das Logfile automatisch beim Schlie�en des Fensters
  gespeichert werden soll:  Value = 0 -> AutoSave := False;
                            Value = 1 -> AutoSave := True;                     }

procedure SetAutoSave(Value: Integer); stdcall;
begin
  AutoSave := Value = 1;
end;

end.
