{ f_cygwin.pas: cygwin-Funktionen

  Copyright (c) 2004-2016 Oliver Valencia

  letzte �nderung  19.04.2016

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.

  f_cygwin.pas stellt Funktionen zur Verf�gung, die mit der cygwin-Umgebung zu
  tun haben:
    * Zugriff auf Einstellungen der cygwin-Umgebung
    * Konvertieren von Pfadangaben


  exportierte Funktionen/Prozeduren:

    GetCygwinPathPrefix: string
    MakePathCygwinConform(Path: string; GraftPoints: Boolean = False): string;
    MakePathMkisofsConform(const Path: string):string
    MakePathMingwMkisofsConform(const Path: string):string
    SetUseOwnCygwinDLLs(Value: Boolean);
    UseOwnCygwinDLLs: Boolean
    
}

unit f_cygwin;

{$I directives.inc}

interface

uses Windows, SysUtils, Registry, IniFiles;

function CheckForActiveCygwinDLL: Boolean;
function GetCygwinPathPrefix: string;
function GetCygwinPathPrefixEx: string;
function MakePathCygwinConform(Path: string; GraftPoints: Boolean = False): string;
function MakePathMkisofsConform(const Path: string):string;
function MakePathMingwMkisofsConform(const Path: string): string;
function UseOwnCygwinDLLs: Boolean;
procedure CleanRegistryPortable;
procedure SetUseOwnCygwinDLLs(Value: Boolean);
procedure InitCygwinPathPrefix;
procedure SetCygwinLocale;

implementation

uses {$IFDEF ShowDebugWindow} frm_debug, {$ENDIF}
     {$IFDEF WriteLogfile} f_logfile, {$ENDIF}   // debug: f_window,
     f_getdosoutput,
     cl_cdrtfedata, f_strings, f_filesystem, f_locations, f_environment,
     f_wininfo, const_locations, const_common;

{ 'statische' Variablen }
var CygPathPrefix    : string;           // Cygwin-Mountpoint
    CygnusPresentHKLM: Boolean;          // Registryeintr�ge bis cygwin 1.5.x
    CygnusPresentHKCU: Boolean;
    CygwinPresentHKLM: Boolean;          // Registryeintr�ge ab cygwin 1.7.x
    CygwinPresentHKCU: Boolean;

{ CygnusPresent ----------------------------------------------------------------

  True, wenn Registry-Zweig "HK\Software\Cygnus Solutions" existiert.          }

function CygnusPresent(HK: HKEY): Boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HK;
    Reg.Access := Key_Read;
    Result := Reg.KeyExists('\Software\Cygnus Solutions');
  finally
    Reg.Free;
  end;
end;

{ DeleteCygnus -----------------------------------------------------------------

 l�scht Registry-Zweig "HK\Software\Cygnus Solutions".                         }

function DeleteCygnus(HK: HKEY): Boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HK;
    Reg.Access := Key_Read or Key_Write;
    Result := Reg.DeleteKey('\Software\Cygnus Solutions');
  finally
    Reg.Free;
  end;
end;

{ CygwinPresent ----------------------------------------------------------------

  True, wenn Registry-Zweig "HK\Software\Cygwin" existiert.                    }

function CygwinPresent(HK: HKEY): Boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HK;
    Reg.Access := Key_Read;
    Result := Reg.KeyExists('\Software\Cygwin');
  finally
    Reg.Free;
  end;
end;

{ DeleteCygnus -----------------------------------------------------------------

 l�scht Registry-Zweig "HK\Software\Cygwin".                                   }

function DeleteCygwin(HK: HKEY): Boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HK;
    Reg.Access := Key_Read or Key_Write;
    Result := Reg.DeleteKey('\Software\Cygwin');
  finally
    Reg.Free;
  end;
end;

{ CleanRegistryPortable --------------------------------------------------------

  l�scht die von cygwin erzeugten Eintr�ge, sofern sie beim Start nicht vor-
  handen waren.                                                                }

procedure CleanRegistryPortable;
// var Temp: string;
//    Ok  : Boolean;
begin
  if not CygnusPresentHKLM then DeleteCygnus(HKEY_LOCAL_MACHINE);
  if not CygnusPresentHKCU then DeleteCygnus(HKEY_CURRENT_USER);
  if not CygwinPresentHKLM then DeleteCygwin(HKEY_LOCAL_MACHINE);
  if not CygwinPresentHKCU then DeleteCygwin(HKEY_CURRENT_USER);
(* debug:
  if CygnusPresentHKLM then Temp := 'CygnusHKLMPresent = True' + #13#10 else
                            Temp := 'CygnusHKLMPresent = False' + #13#10;
  if CygnusPresentHKCU then Temp := Temp + 'CygnusHKCUPresent = True' + #13#10 else
                            Temp := Temp + 'CygnusHKCUPresent = False' + #13#10;
  if not CygnusPresentHKLM then
  begin
    Ok := DeleteCygnus(HKEY_LOCAL_MACHINE);
    if OK then Temp := Temp + 'CygnusHKLM deleted' + #13#10 else
               Temp := Temp + 'CygnusHKLM delete failed' + #13#10;
  end;
  if not CygnusPresentHKCU then
  begin
    Ok := DeleteCygnus(HKEY_CURRENT_USER);
    if OK then Temp := Temp + 'CygnusHKLM deleted' + #13#10 else
               Temp := Temp + 'CygnusHKLM delete failed' + #13#10;
  end;
  ShowMsgDlg(Temp, 'StealthInfo', MB_cdrtfeInfo);
*)
end;

{ GetCygwinPathPrefix ----------------------------------------------------------

  liefert den Cygwin-Mountpoint f�r Windowslaufwerke (normalerweise /cygdrive).}

function GetCygwinPathPrefix: string;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    with Reg do
    begin
      {Cygwin Path Prefix zuerst in HKCU suchen}
      RootKey := HKEY_CURRENT_USER;
      OpenKey('\Software\Cygnus Solutions\Cygwin\mounts v2', False);
      try
        Result := ReadString('cygdrive prefix');
      except
        {Wenn etwas schiefgeht 'cygdrive prefix' also nicht vorhanden ist,
         setzen wir das Ergebnis aus '', damit in HKLM gesucht wird. Aufgrund
         eines Fehlers in TRegistry wird diese Exception aber nie ausgel�st, was
         kein Problem ist, da Result in diesem Fall ein Leerstring ist.}
        Result := '';
      end;
      {Wenn in HKCU nichts gefunden wird, dann vielleicht in HKLM}
      if Result = '' then
      begin
        RootKey := HKEY_LOCAL_MACHINE;
        OpenKey('\Software\Cygnus Solutions\Cygwin\mounts v2', False);
        try
          Result := ReadString('cygdrive prefix');
        except
          Result := '';
        end;
      end;
      {Wenn das Prefix '/' ist, m�ssen wir mit '' arbeiten.}
      if Result = '/' then Result := '' else
      {Wenn nichts gefunden wurde, arbeiten wir mit dem cygwin-Default.}
      if Result = '' then Result := '/cygdrive';
    end;
  finally
    Reg.Free;
  end;
end;

{ GetCygwinPathPrefixEx --------------------------------------------------------

  liefert den Cygwin-Mountpoint f�r Windowslaufwerke (normalerweise /cygdrive).

  Zur Zeit wird hierf�r ein externes Programm (cygpathprefix.exe) aufgerufen,
  das das Prefix nach StdOut ausgibt.                                          }

function GetCygwinPathPrefixEx: string;
var Cmd    : string;
    Output : string;
    Prefix : string;
    i      : Integer;
begin
  Result := '';
  Cmd := StartUpDir + cCygPathPref;
  Cmd := QuotePath(Cmd);
  Output := GetDosOutput(PChar(Cmd), True, True, 3);
  Prefix := Output;
  i := LastDelimiter('/', Prefix);
  if i > 1 then Delete(Prefix, 1, i - 1);
  Prefix := Trim(Prefix);
  if Prefix = '/' then Prefix := '' else
  if Prefix = '' then Prefix := '/cygdrive';
  Result := Prefix;
  {$IFDEF WriteLogfile}
  AddLog('cygwin path prefix         : ' + Prefix + #13#10 + ' ', 0);
  {$ENDIF}
end;                            

procedure InitCygwinPathPrefix;
begin
  if CygPathPrefix = 'unknown' then CygPathPrefix := GetCygwinPathPrefixEx;
end;

{ MakePathCygwinConform --------------------------------------------------------

  MakePathCygwinconform wandelt Pfade so um, da� sie kompatibel sind zu den
  Konventionen der Cygwin-Umgebung.
  Wenn die Pfadangaben '=' enthalten (aus der Graft-Points-Pfadliste), wird dies
  korrekt behandelt.                                                           }

function MakePathCygwinConform(Path: string;
                               GraftPoints: Boolean = False): string;
var p     : Integer;
    Target: string;
begin
  if CygPathPrefix = 'unknown' then CygPathPrefix := GetCygwinPathPrefix;
  {standardkonforme Pfadangaben benutzen / statt \}
  Path := ReplaceChar(Path, '\', '/');
  {Doppelpunkt bei Laufwerksangabe entfernen}
  p := Pos(':', Path);
  if p <> 0 then
  begin
    Delete(Path, p, 1);
  end;
  {Pfade f�r Cygwin anpassen, dabei auf das = f�r -graft-points achten. UNC-
   Pfade (\\server\...) k�nnen bleiben, wie sie sind.}
  p := Pos('=', Path);
  if (p <> 0) and GraftPoints then
  begin
    SplitString(Path, '=', Target, Path);
    if IsUNCPath(Path) then
    begin
      Path := Target + '=' + Path;
    end else
    begin
      Path := Target + '=' + CygPathPrefix + '/' + Path;
    end;
  end else
  begin
    if not IsUNCPath(Path) then Path := CygPathPrefix +'/' + Path;
  end;
  Result := Path;
end;

{ MakePathMkisofsConform -------------------------------------------------------

  MakePathMkisofsconform ist n�tig, um das Vorkommen von '=' in Dateinamen
  richtig zu behandeln.                                                        }

function MakePathMkisofsConform(const Path: string):string;
var Temp: string;
begin
  Temp := Path;                                            {$IFDEF DebugMMkC}
                                                           Deb(Path, 2);{$ENDIF}
  {n�tiger Zwischenschritt:  = -> *}
  Temp := ReplaceChar(Temp, '=', '*');                     {$IFDEF DebugMMkC}
                                                           Deb(Temp, 2);{$ENDIF}
  {erster : -> =}
  Temp := ReplaceCharFirst(Temp, ':', '=');                {$IFDEF DebugMMkC}
                                                           Deb(Temp, 2);{$ENDIF}
  {\ -> / und x: -> /cygdrive/x}
  Temp := MakePathCygwinConform(Temp, True);               {$IFDEF DebugMMkC}
                                                           Deb(Temp, 2);{$ENDIF}
  {* - > \=}
  Temp := ReplaceString(Temp, '*', '\=');
  Result := Temp;                                          {$IFDEF DebugMMkC}
                                                  Deb(Temp + #13#10, 2);{$ENDIF}
end;

{ MakePathMingwMkisofsConform --------------------------------------------------

  MakePathMkisofsconform ist n�tig, um das Vorkommen von '=' in Dateinamen
  richtig zu behandeln. Da die Mingw-Version von mkisofs anders mit Pfaden um
  geht, ist eine eigene Funktion n�tig.                                        }

function MakePathMingwMkisofsConform(const Path: string): string;
var Temp: string;
begin
  Temp := Path;
  {n�tiger Zwischenschritt:  = -> *}
  Temp := ReplaceChar(Temp, '=', '*');
  {erster : -> =}
  Temp := ReplaceCharFirst(Temp, ':', '=');
  {\ -> /}
  Temp := ReplaceChar(Temp, '\', '/');
  {* - > \=}
  Temp := ReplaceString(Temp, '*', '\=');
  Result := Temp;
end;

const cCygOwnDLLSec  : string = 'CygwinDLL';
      cCygOwnDLL     : string = 'UseOwnDLLs';
      cCygCheckActive: string = 'CheckForActiveDLL';

{ UseOwnDLLs -------------------------------------------------------------------

  Wertet die Datei tools\cygwin\cygwin.ini aus.

  True:  Die mitgelieferten DLLs sollen verwendet werden, unabh�ngig davon, ob
         die cygwin1.dll im Suchpfad gefunden wurde.
  False: Die mitgelieferten DLLs sollen nur verwendet werden, wenn die
         cygwin1.dll nicht im Suchpfad gefunden wurde.                         }

function UseOwnCygwinDLLs: Boolean;
var Ini : TIniFile;
    Name: string;
begin
  Name := StartUpDir + cToolDir + cCygwinDir + cIniCygwin;
  Result := False;
  if FileExists(Name) then
  begin
    {$IFDEF WriteLogFile}
    AddLogCode(1256);
    {$ENDIF}
    Ini := TIniFile.Create(Name);
    Result := Ini.ReadBool(cCygOwnDLLSec, cCygOwnDLL, False);
    Ini.Free;
  end;
  {$IFDEF WriteLogFile}
  if Result then AddLogCode(1257) else AddLogCode(1258);
  {$ENDIF}
  {Wir ben�tigen den Wert in FSettings, daher hier Zugrif �ber Singleton. Sehr
   unsch�ne L�sung. Demn�chst mal �ndern.}
  TCdrtfeData.Instance.Settings.FileFlags.UseOwnDLLs := Result;
end;

{ SetUseOwnCygwinDLLs ----------------------------------------------------------

  Setzt die Option [CygwinDLL], UseOwnDLLs in tools\cygwin\cygwin.ini.         }

procedure SetUseOwnCygwinDLLs(Value: Boolean);
var Ini : TIniFile;
    Name: string;
begin
  Name := StartUpDir + cToolDir + cCygwinDir + cIniCygwin;
  Ini := TIniFile.Create(Name);
  Ini.WriteBool(cCygOwnDLLSec, cCygOwnDLL, Value);
  Ini.Free;
end;

{ CheckForActiveCygwinDLL ------------------------------------------------------

  True: nach geladener cygwin1.dll suchen
  False: nicht nach geladener cygwin1.dll suchen                               }

function CheckForActiveCygwinDLL: Boolean;
var Ini : TIniFile;
    Name: string;
begin
  Name := StartUpDir + cToolDir + cCygwinDir + cIniCygwin;
  Result := False;
  if FileExists(Name) then
  begin
    {$IFDEF WriteLogFile}
    AddLogCode(1256);
    {$ENDIF}
    Ini := TIniFile.Create(Name);
    Result := Ini.ReadBool(cCygOwnDLLSec, cCygCheckActive, False);
    Ini.Free;
  end;
end;

{ SetCygwinLocale --------------------------------------------------------------

  setzt LC_ALL=LangCode als Umgebungsvariable. N�tig ab cygwin 1.7.            }

procedure SetCygwinLocale;
var LangCode: string;
    ANSICP  : string;
    Locale  : string;
begin
  LangCode := GetWindowsLanguage;
  ANSICP := 'CP' + IntToStr(GetACP());
  Locale := LangCode + '.' + ANSICP;
  SetEnvVarValue('LC_ALL', Locale);
  {$IFDEF WriteLogfile}
  AddLog('Setting cygwin locale: LC_ALL=' + Locale + CRLF + CRLF, 0);
  {$ENDIF}
end;
                
initialization
  CygPathPrefix := 'unknown';
  CygnusPresentHKLM := CygnusPresent(HKEY_LOCAL_MACHINE);
  CygnusPresentHKCU := CygnusPresent(HKEY_CURRENT_USER);
  CygwinPresentHKLM := CygwinPresent(HKEY_LOCAL_MACHINE);
  CygwinPresentHKCU := CygwinPresent(HKEY_CURRENT_USER);

end.
