{ cdrtfe: cdrtools/Mode2CDMaker/VCDImager Front End

  userevents.pas: Event-Deklaration

  Copyright (c) 2006 Oliver Valencia

  letzte �nderung 13.08.2006

  Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
  GNU General Public License weitergeben und/oder modifizieren. Weitere
  Informationen (Lizenz, Gew�hrleistungsausschlu�) in license.txt, COPYING.txt. 

}

unit userevents;

{$I directives.inc}

interface

type TMessageShowEvent = procedure(const s: string) of object;
     TProgressBarHideEvent = procedure of object;
     TProgressBarShowEvent = procedure(const Max: Integer) of object;
     TProgressBarUpdateEvent = procedure(const Position: Integer) of object;
     TProjectErrorEvent = procedure (const ErrorCode: Byte; const Name: string) of object;
     TUpdatePanelsEvent = procedure(const s1, s2: string) of object;
 
implementation

end.