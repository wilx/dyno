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

{$O-,G+,X+}
unit Hudba;

interface
uses EProcs, Seznam, midas, mconfig, vgatext, mfile, mplayer, errors, s3m;

function hudbaStart(soub : PChar) : boolean;
function hudbaStop : boolean;

implementation

var configured : integer;
    module : PmpModule;
    i, error, isConfig : integer;
    str : array [0..256] of char;
    HudbaExitProcO : TExitProcO;
(*
function toASCIIZ(dest : PChar; str : string) : PChar;
var
    spos, slen : integer;
    i : integer;
begin
    spos := 0;                          { string position = 0 }
    slen := ord(str[0]);                { string length }
    { copy string to ASCIIZ conversion buffer: }
    while spos < slen do
    begin
        dest[spos] := str[spos+1];
        spos := spos + 1;
    end;
    dest[spos] := chr(0);               { put terminating 0 to end of string }
    toASCIIZ := dest;
end;
*)

function hudbaStart(soub : PChar) : boolean;
BEGIN
    error := fileExists('MIDAS.CFG', @isConfig);
    if error <> OK then
        midasError(error);
    if isConfig <> 1 then
    begin
      midasSetDefaults;                   { set MIDAS defaults }
      { Run MIDAS Sound System configuration: }
      configured := midasConfig;
      { Reset display mode: }
      vgaSetMode($03);
      if configured = 1 then
      begin
        { Configuration succesful - save configuration file: }
        midasSaveConfig('MIDAS.CFG');
        WriteLn('Konfigurace byla zapsana do MIDAS.CFG');
      end
      else
      begin
        { Configuration unsuccessful: }
        WriteLn('Konfigurace NEBYLA zapsana');
      end;
    end;
    midasSetDefaults;                   { set MIDAS defaults }
    midasLoadConfig('MIDAS.CFG');       { load configuration }
    midasInit;                          { initialize MIDAS Sound System }
    module := midasLoadModule(soub, @mpS3M, NIL);
    midasPlayModule(module, 0);         { start playing }
end;

function hudbaStop : boolean;
begin
    midasStopModule(module);            { stop playing }
    midasFreeModule(module);            { deallocate module }
    midasClose;                         { uninitialize MIDAS }
end;

procedure HudbaExitProc; far;
begin
  if midasMPInit = 1 then begin
    if midasMPPlay = 1 then begin
      midasStopModule(module);
      midasFreeModule(module);
    end;
    midasClose;
  end;
end;

begin
  HudbaExitProcO.Init(HudbaExitProc,Static);
  epchain.VlozObj(@HudbaExitProcO);
end.