{
Copyright (c) 1997-2007, Václav Haisman

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

unit EProcs;

interface
uses Seznam, Graph;

type
     TExitProc = procedure;
     PExitProcO = ^TExitProcO;
     TExitProcO = object(TSeznamClen)
                         proc : TExitProc;
                         procedure CallProc;
                         constructor Init(iproc : TExitProc; ityp : TClenTyp);
                       end;
var epchain : TSeznam;

{Hex prevadeni asi nejfunguje jak by melo tzn. prevadi spatne.}
const HexDigits : array [0..15] of char = ('0','1','2','3','4','5','6',
                                           '7','8','9','A','B','C','D',
                                           'E','F');
function HexDump(x : word) : string;

implementation

var oldexitproc : pointer;

function HexDump(x : word) : string;
var pom : string[4];
begin
  pom[0] := #4;
  pom[1] := HexDigits[Hi(x) shr 4];
  pom[2] := HexDigits[Hi(x) and $f];
  pom[3] := HexDigits[Lo(x) shr 4];
  pom[4] := HexDigits[Lo(x) and $f];
  HexDump := pom;
end;

procedure ExitProcHandler; far; {tato procedura se vyvola pri ukonceni programu}
var i, poc : word;
begin
  ExitProc := oldexitproc;
  poc := epchain.PocetObj;
  if poc > 0 then
    for i := 1 to poc do
      PExitProcO(epchain.Pozice(i))^.CallProc;
  epchain.Done;
{$ifdef CZ_EXIT_TEXT} {vypis duvodu ukonceni}
  if (ExitCode = 0) and (ErrorAddr = nil) then
    writeln('Normalni ukonceni.')
  else
    if (ErrorAddr = nil) then
      writeln('Ukonceni procedurou Halt(',ExitCode,')')
    else
      writeln('Ukonceni chybou za behu s chybovym kodem ',ExitCode,
              ' na adrese ',HexDump(Seg(ErrorAddr)),':',HexDump(Ofs(ErrorAddr)));
  ExitCode := 0; {aby se nevypisovala pripadna chybova zprava dvakrat}
  ErrorAddr := nil;
{$endif}
end;

procedure TExitProcO.CallProc;
begin
  proc;
end;

constructor TExitProcO.Init(iproc : TExitProc; ityp : TClenTyp);
begin
  inherited Init(ityp, nil);
  proc := iproc;
end;

begin
  epchain.Init(256,Static,nil);
  oldexitproc := ExitProc;
  ExitProc := @ExitProcHandler;
end.