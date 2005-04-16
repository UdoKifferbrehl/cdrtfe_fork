{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  directives.inc: Symbol-Definitionen

  Copyright (c) 2004-2005 Oliver Valencia

  letzte �nderung  31.03.2005

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt.  

  - Damit diese Symbole in einer Unit g�ltig sind, mu� directives.inc mit $I
    bzw. $INCLUDE eingebunden werden.

  - um die entsprechende Funktion zu aktivieren, das 'x' vor dem Symbolnamen
    entfernen
}

(* -------------------------------------------------------------- Testversion *)

{$DEFINE xTestVersion}
         // kennzeichnet cdrtfe als Testversion
         //    - betrifft: frm_about.pas


(* ------------------------------------- Einstellungen in Registry spreichern *)

{$DEFINE xRegistrySettings}
         // Einstellungen werden auf Wunsch in der Registry gespeichert und beim
         // Programmstart automatisch geladen.
         //    - betrifft: frm_main.pas, frm_settings.pas, cl_settings.pas


(* ----------------------------------- Einstellungen in cdrtfe.ini spreichern *)

{$DEFINE IniSettings}
         // Einstellungen werden auf Wunsch in cdrtfe.ini gespeichert und beim
         // Programmstart automatisch geladen.
         //    - betrifft: frm_main.pas, frm_settings.pas, cl_settings.pas

{$IFDEF IniSettings}{$UNDEF RegistrySettings}{$ENDIF}
         // Dies stellt sicher, da� die Einstellungen nicht sowohl in der
         // Registry als auch in der cdrtfe.ini gesichert werden.
         // Falls beide Direktiven aktiv sind, hat die Speicherung in der
         // Ini-Datei Vorrang.


(* ----------------------------------------------------- QuoteCommandlinePath *)

{$DEFINE QuoteCommandlinePath}
         // Wenn dieses Symbol definiert ist, wird der Pfad des Kommandozeilen-
         // programmes in doppelte Anf�hrungszeichen (") gesetzt, wenn er
         // Leerzeichen enth�lt.
         //    - betrifft: cl_action.pas, f_init.pas


(* ----------------------------------------------------- Best�tigungs-Dialoge *)

{$DEFINE Confirm}
         // aktiviert die Sicherheitsabfrage vor dem Brennen
         //    - gilt f�r Daten-CD, Audio-CD, XCD, Brennen von Images
         //    - betrifft: cl_action


(* --------------------------------------------------------- Optionen togglen *)

{$DEFINE AllowToggle}
         // erlaubt das Umstellen von Optionen durch Klick auf ein Label im
         // OptionPanel
         //    - betrifft: frm_main.pas

{$IFDEF AllowToggle}
         // die verschiedenen M�glichkeiten, anzuzeigen, da� ein Label klickbar
         // ist, machen nur Sinn, wenn das Togglen erlaubt ist

{$DEFINE xMouseOverLabelHighlight}
         // erzeugt einen Highlight-Effekt, wenn sich der Mauszeiger �ber einem
         // anklickbaren Option-Label befindet
         //    - betrifft: frm_main.pas

{$DEFINE MouseOverLabelCursor}
         // verwendet einen anderen Cursor, wenn sich der Mauszeiger �ber einem
         // anklickbaren Option-Label befindet.
         //    - betrifft: frm_main.pas

{$ENDIF}


(* ----------------------------------------------------- spezielle Funktionen *)

{$DEFINE xCreateAllForms}
         // erzeugt bei Doppelklick auf Form1 alle anderen Forms, damit deren
         // String-Properties ausgelesen werden k�nnen
         //    - betrifft: frm_main.pas

{$DEFINE xExportStrings}
         // Strings in Datei schreiben
         //    - Stringproperties aller Controls und alle Messagestrings
         //    - auszul�sen durch Doppelklick auf Hintergrund von Form 1
         //    - betrifft: frm_main.pas

{$DEFINE xExportControls}
         // Gr��e und Position aller Controls exportieren
         //    - auszul�sen durch Doppelklick auf Hintergrund von Form 1
         //    - betriff: frm_main.pas


(* ---------------------------------------------------------- Verify-Funktion *)

{$DEFINE BitwiseVerify}
         // Bitweiser Vergleich
         //    - Ist dieses Symbol definiert, wird statt des Vergleiches �ber
         //      CRC32-Pr�fsummen ein bitweiser Vergleich der Dateien vorge-
         //      nommen.
         //    - betrifft: cl_verifythread.pas

{$DEFINE xVerifyShowDetails}
         // ein paar mehr (Debug-)Informationen anzeigen
         //    - betrifft: cl_verifythread.pas

{$DEFINE xTestVerify}
         // zum Test der Verify-Funktion
         //    - Doppelklick auf Hintergrund von Form 1 l�st Test aus
         //    - Brennvorgang wird �bersprungen, daher mu� eine CD mit Daten
         //      vorliegen, diese Dateien m�ssen zum Projekt hinzugef�gt sein
         //    - betrift: frm_main.pas

{$DEFINE xNoReload}
         // Reload beim Verify f�r Testzwecke abschalten
         //    - betriff: cl_verifythread.pas

{$DEFINE xForceReloadError}
         // immer Fehler beim Reload annehmen
         //    - betrifft: cl_verifythread.pas

{$DEFINE xUseMD5}
         // beim Suchen nach identischen Dateien MD5-Hashes statt CRC32
         // verwenden
         //    - betrifft: cl_verifythread.pas


(* --------------------------------------------------------- CD-Text-Funktion *)

{$DEFINE xAddCDText}
         // generiert CD-Text zu der aktuellen Trackliste
         //    - Doppelklick auf Hintergrund von Form 1 l�st Funktion aus
         //    - betrifft: frm_main.pas


(* ----------------------------------------------------------------- NoDevice *)

{$DEFINE xNoDevice}
         // simuliert das Nicht-Vorhandensein von Laufwerken
         //    - betrifft: cl_devices.pas

{$DEFINE xUseDummyDevices}
         // simuliert eine gr��ere Laufwerksliste
         //    - betrifft: cl_devices.pas


(* -------------------------------------------------------------- DVD-Support *)

{$DEFINE DVDSupport}

{$IFDEF DVDSupport}
         // Die folgenden Symbole sollen nur ber�cksichtigt werden, wenn cdrtfe
         // mit DVD-Unterst�tzung kompiliert wird.

{$DEFINE LargeProject}
         // Unterst�tzung f�r Projekte > 2 GiByte
         //   - F�r Berechnungen der Gesamtgr��e der zu schreibenden Daten wird
         //     der Typ Comp statt Integer verwendet.
         //   - betrifft: frm_main.pas, cl_projectdata.pas, cl_cd.pas,
         //     cl_action.pas, frm_audiocd_tracks.pas, f_chekproject.pas,
         //     f_strings.pas

{$DEFINE LargeFiles}
         // Unterst�tzung f�r Dateien > 2 GiByte
         //   - F�r Dateigr��en wird der Type Comp statt Integer verwendet.
         //   - Die Funktion GetFileSize verwendet Daten aus TWin32FindData
         //   - betrifft:

{$ENDIF}


(* -------------------------------------------------------------- Zeitmessung *)

{$DEFINE xShowTime}
         // Die Dauer bestimmter Aktionen messen.
         //   - nur wenn ShowTime definiert ist, werden die anderen Symbole
         //     ber�cksichtigt.

{$IFDEF ShowTime}

{$DEFINE xShowVerifyTime}
         // Dauer des Vergleichs anzeigen
         //    - betrifft: cl_verifythread.pas

{$DEFINE xShowTimeAddFolder}
         // zeigt die Dauer des Hinzuf�gens eines Ordners an
         //    - betrifft: frm_main.pas

{$ENDIF}

(* ---------------------------------------------------------------- Debugging *)

{$DEFINE xShowDebugWindow}
         // bindet die Unit frm_debug.pas ein und zeigt beim Start
         // automatisch das Debugfenster an
         //   - nur wenn ShowDebugWindow definiert ist, werden die anderen
         //     DebugSymbole br�cksichtigt
         //   - betrifft: frm_main.pas, frm_debug.pas, cl_projectdata.pas,
         //     cl_cd.pas, cl_settings.pas, cl_filetypeinfo.pas, cl_lang.pas

{$IFDEF ShowDebugWindow}
         // Die folgenden Symbole sollten nur einzeln verwendet werden, da
         // zur Darstellung der Informationen stets die selben Memos verwendet
         // werden.

{$DEFINE xDebugMMkC}
         // Anzeige der Zwischenschritte beim Bearbeiten der Pfadlisten
         //   - betrifft: f_cygwin.pas

{$DEFINE xDebugFileLists}
         // Anzeige der internen Dateilisten:
         //   - f�r die Anzeige wird das Debugfenster verwendet
         //   - betrifft: frm_main.pas

{$DEFINE xDebugAddFiles}
         // Anzeige der Prozeduraufrufe, wenn Dateien oder Ordner
         // hinzugef�gt werden
         //    - betrifft: cl_cd.pas

{$DEFINE xDebugAddFilesDragDrop}
         // Anzeige der Prozedureaufrufe, wenn Dateien oder Ordner
         // per Drag-and-Drop hinzugef�gt werden
         //    - betrifft frm_main.pas

{$DEFINE xDebugDeleteAll}
         // Anzeige der Funktionsaufrufe, wenn alles gel�scht werden soll
         //    - betrifft: cl_cd.pas

{$DEFINE xDebugFileTypeInfoList}
         // Anzeige der FileTypeInfoList
         //    - Anzeige der gesamten Liste
         //    - Anzeige der Treffer/Fehler
         //    - betrifft: cl_filetypeinfo.pas

{$DEFINE xDebugSort}
         // Anzeige der sortierten Ordner
         //    - betrifft frm_main.pas

{$DEFINE xDebugGetFolderSize}
         // Anzeige der Funktionsaufrufe und Zwischenergebnisse
         //    - betrifft: cd_cd.pas

{$DEFINE xDebugUpdateGauges}
         // Anzeige aller Projektinfos
         //    - Anzeige, wann Properties aktualisiert werden
         //    - betrifft: frm_main.pas, cl_cd.pas

{$DEFINE xDebugSettings}
         // Anzeige der internen Einstellungen
         //    - betrifft: frm_main.pas, cl_settings.pas

{$DEFINE xDebugMaxFileNameLength}
         // Anzeige der maximalen Dateinamenl�nge
         //    - betrifft: frm_main.pas

{$DEFINE xDebugErrorLists}
         // Anzeige der Listen mit zu langen Dateinamen und zu tiefen Ordnern
         //    - betrifft: frm_main.pas, cl_cd.pas

{$DEFINE xDebugReadAudioTOC}
         // zeigt die Zwischenergebnisse beim Auslesen der TOC einer Audio-CD an
         //    - betrifft: cl_action.pas

{$DEFINE xDebugCreateFileLists}
         // Statusinfos
         //    - betrifft: cl_cd.pas

{$DEFINE xDebugAddFileLoad}
         // zeigt Pfadnamen beim Laden von Dateien an
         //    - betrifft: cl_projectdata.pas

{$DEFINE xDebugReadCDInfo}
         // zeigt Zwischenergebnisse in TAction.ReadCDInfo an
         //    - betrifft: cl_action.pas

{$DEFINE xShowCDTextInfo}
         // zeigt die CD-Text-Informationen an (Doppelklick auf Hintergrund)
         //    - betrifft: frm_main.pas

{$DEFINE xDebugCreateCDText}
         // zeigt Zwischenergebnisse beim Erstellen von cdtext.dat an
         //    - wird durch Doppelklick auf den Hintergrund von Form1
         //      ausgel�st
         //    - betrifft: frm_main.pas, f_cdtext.pas

{$DEFINE xShowBurnList}
         // zeigt die Pfadliste an, bevor sie f�r mkisosfs bearbeitet wird
         //    - sowohl BurnList als auch FVList werden angezeigt
         //    - betrifft: cl_action.pas

{$DEFINE xDebugFindDups}
         // h�lt die Programmausf�hrung nach dem Suchvorgang an
         //    - betrifft: frm_main.pas

{$DEFINE xDebugLang}
         // Anzeige der Sprach-Liste
         //    - betrifft: cl_lang.pas

{$DEFINE xDebugCheckEnv}
         // zeigt Infos zum Environment-Block
         //    - betrifft: f_init.pas

{$DEFINE xDebugCreateInfoFile}
         // h�lt die Programmausf�hrung nach der Dateierstellung an
         //    - frm_main.pas

{$DEFINE xDebugExp}
         // zeigt Infos auf TExperiment
         //    - betrifft: f_experiment.pas

{$DEFINE xDebugDeviceList}
         // zeigt den Inhalt aller Laufwerkslisten
         //    - betrifft: cl_devices.pas

{$DEFINE xDebugDriveDetection}
         // Anzeige der cdrecord-Aufrufe zur Laufwerkserkennung
         //    - betrifft: cl_devices.pas

{$ENDIF}


(* ------------------------------------------- List-View: Unknown Win32 Error *)

{$DEFINE ManualFreeListView}
         // Gibt einen List-View im FormDestroy frei, bevor dies automatisch
         // durch das Programm geschieht. Das verhindert einen unbekannten
         // Win32 Fehler in TWinControl.DestroyWindowHandle
         //    - betrifft frm_main.pas, frm_datacd_fs_error.pas


(* -------------------------------------- RegOpenKeyEx: Handle must be closed *)

{$DEFINE UseRegistryKeyExists}
         // Wenn dieses Symbol definiert ist, wird die Delphi-Funktion
         // TRegistry.KeyExists verwendet, um auf das Vorhandensein eines
         // Registry-Zweiges zu pr�fen.
         // Andernfalls wird eine alternative Methode verwendet, da KeyExists
         // unter Umst�nden Fehler erzeugt. N�here Erkl�rungen in
         // f_shellext.pas (Funktion ShellExtensionsRegistered).
         //    - betrifft f_shellext.pas
