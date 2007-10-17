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
unit StrManip;

interface

type
  TParseInfo = record
                 next : byte;
                 str : ^string;
               end;
function UpStr(var s : string) : string;
function Osekej(var s : string) : string;
function UpravStr(var is : string) : string;
function StrTok(const is, isep : string; var inf : TParseInfo) : string;
function StrTokPas(const is, isep : string; var inf : TParseInfo) : string;

implementation
uses {$ifdef WINDOWS}WinCrt,{$endif}Strings;

function UpravStr(var is : string) : string;
var s : string;
begin
  Osekej(is);
  UpStr(is);
  UpravStr := is;
end;


function UpStr(var s : string) : string;
var i : integer;
    l : integer;
begin
  l := length(s);
  for i := 1 to l do
    s[i] := upcase(s[i]);
  UpStr := s;
end;

function Osekej(var s : string) : string;
var i : integer;
begin
  i := 0;
  while (s[i+1] = ' ') and (i+1 <= length(s)) do
    inc(i);
  Delete(s,1,i);
  i := length(s)+1;
  while (s[i-1] = ' ') do
    dec(i);
  Delete(s,i,length(s)-i+1);
  Osekej := s;
end;

function StrTok(const is, isep : string; var inf : TParseInfo) : string;
var s, pom, pos, minpos : PChar;
    i : word;
begin
  if length(is) = 0 then begin
    getmem(s,length(is) - inf.next + 2);
    getmem(pom,length(is) - inf.next + 2);
    StrPCopy(s,copy(inf.str^, inf.next, length(inf.str^) - inf.next + 1));
  end
  else begin
    inf.next := 0;
    getmem(pom,length(is)+1);
    getmem(s,length(is)+1);
    StrPCopy(s,is);
  end;

  minpos := StrEnd(s);
  for i := 1 to length(isep) do begin
    pos := StrScan(s,isep[i]);
    if pos < minpos then
      minpos := pos;
  end;
  inf.next := inf.next + minpos - s + 2; {ukazuje na dalsi cast v is}
  StrLCopy(pom,s,minpos - s);
  StrTok := StrPas(pom);

  if length(is) = 0 then begin
    freemem(s,inf.next - length(is) + 2);
    freemem(pom,inf.next - length(is) + 2);
  end
  else begin
    inf.str := @is;
    freemem(pom,length(is)+1);
    freemem(s,length(is)+1);
  end;
end;

function StrTokPas(const is, isep : string; var inf : TParseInfo) : string;
var s, pom, sep : string;
    i, spos, minpos : word;
begin
  if length(is) = 0 then begin
    s := copy(inf.str^, inf.next, length(inf.str^) - inf.next + 1);
  end
  else begin
    inf.next := 0;
    s := is;
  end;

  minpos := length(s);
  for i := 1 to length(isep) do begin
    sep := isep[i];
    spos := pos(isep[i],s);
    if spos < minpos then
      minpos := spos;
  end;
  inf.next := inf.next + minpos; {ukazuje na dalsi cast v is}
  pom := Copy(s,1,minpos - 1);
  StrTokPas := pom;

  if length(is) = 0 then begin
  end
  else begin
    inf.str := @is;
    inc(inf.next);
  end;
end;


end.