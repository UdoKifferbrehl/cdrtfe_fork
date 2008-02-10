{ f_logfile.pas: Funktionen zum Debuggen, Anzeigen und Schreiben eines Log-Files

  Copyright (c) 2004-2008 Oliver Valencia

  letzte �nderung  10.01.2008

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.

  f_debug.pas stellt Funktionen zum Debuggen, Anzeigen und Schreiben eines
  Log-Files zur Verf�gung:
    * String bzw. String-Liste an das Log-File anf�gen


  exportierte Funktionen/Prozeduren:

    AddLog(const Value: string; const Show: Byte)
    AddLogAddStringList(List: TStringList)

}


unit f_logfile;

{$I directives.inc}

interface

uses Windows, Forms{, Classes, SysUtils};

procedure AddLog(const Value: string; const Mode: Byte);
procedure AddLogCode(const Value: Integer);

implementation

uses f_filesystem, f_misc;

const cDebugDLL = 'cdrtfedbg.dll';
      cLogName  = 'cdrtfe_log.txt';

type TInitDebugForm = procedure(const AppHandle: THandle); stdcall;
     TFreeDebugForm = procedure; stdcall;
     TShowDebugForm = procedure; stdcall;
     TAddLogStr     = procedure(Value: PChar; Mode: Byte); stdcall;
     TAddLogPreDef  = procedure(Value: Integer); stdcall;
     TSetLogFile    = procedure(Value: PChar); stdcall;

var DLLName       : string;
    DebugDLLHandle: THandle;
    DLLLoaded     : Boolean = False;
    InitDebugForm : TInitDebugForm = nil;
    FreeDebugForm : TFreeDebugForm = nil;
    ShowDebugForm : TShowDebugForm = nil;
    AddLogStr     : TAddLogStr     = nil;
    AddLogPreDef  : TAddLogPreDef  = nil;
    SetLogFile    : TSetLogFile    = nil;

{ LoadDll ----------------------------------------------------------------------

  Debug-DLL laden und die Funktionsadressen bestimmen.                         }

function LoadDLL: Boolean;
begin
  DebugDLLHandle := LoadLibrary(PChar(DLLName));
  if DebugDLLHandle > 0 then
  begin
    @InitDebugForm := GetProcAddress(DebugDLLHandle, 'InitDebugForm');
    @FreeDebugForm := GetProcAddress(DebugDLLHandle, 'FreeDebugForm');
    @ShowDebugForm := GetProcAddress(DebugDLLHandle, 'ShowDebugForm');
    @AddLogStr     := GetProcAddress(DebugDLLHandle, 'AddLogStr');
    @AddLogPreDef  := GetProcAddress(DebugDLLHandle, 'AddLogPreDef');
    @SetLogFile := GetProcAddress(DebugDLLHandle, 'SetLogFile');
    Result := True;
  end else
    Result := False;
end;

{ UnloadDll --------------------------------------------------------------------

  Debug-DLL entladen.                                                          }

procedure UnloadDLL;
begin
  if Assigned(FreeDebugForm) then FreeDebugForm;
  if DebugDLLHandle > 0 then FreeLibrary(DebugDllHandle);
end;

{ AddLog -----------------------------------------------------------------------

  AddLog f�gt eine Zeile an das Logfile an.                                    }

procedure AddLog(const Value: string; const Mode: Byte);
begin
  if DllLoaded then AddLogStr(PChar(Value), Mode);
end;

{ AddLogCode -------------------------------------------------------------------

  AddLog f�gt eine durch Value vordefinierte Zeile an das Logfile an.          }

procedure AddLogCode(const Value: Integer);
begin
  if DllLoaded then AddLogPreDef(Value);
end;

initialization
  DLLLoaded := False;
  DLLName := StartUpDir + '\' + cDebugDLL;
  if CheckCommandLineSwitch('/debug') then DLLLoaded := LoadDLL;
  if DLLLoaded then
  begin
    SetLogFile(PChar(ProgDataDir + '\' + cLogName));  
    InitDebugForm(Application.Handle);
    ShowDebugForm;
    AddLogCode(1010);
  end;

finalization
  AddLogCode(1011);
  UnloadDLL;

end.



