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

{$X+,O-}

uses Seznam, SezClen, Konsts, Iterator;

type
    PIntO = ^TIntO;
    TIntO = object (TSeznamClen)
      x : byte;
      constructor Init(ix : integer; ityp : TClenTyp);
      destructor Done; virtual;
    end;


function cmp (x,y : PSeznamClen) : integer; far;
begin
  if PIntO(x)^.x < PIntO(y)^.x then
    cmp := -1
  else if PIntO(x)^.x > PIntO(y)^.x then
    cmp := 1
  else
    cmp := 0;
end;

function cmp2 (x,y : PSeznamClen) : integer; far;
begin
  cmp2 := -cmp(x,y);
end;

procedure akce(p : PSeznamClen); far;
begin
  inc(PIntO(p)^.x);
end;

constructor TIntO.Init(ix : integer; ityp : TClenTyp);
begin
  inherited Init(ityp);
  objtyp := SeznamClenID;
  x := ix;
end;

destructor TIntO.Done;
begin
  inherited Done;
end;



var s : TSeznam;
    i : longint;
    it : TIterator;

const poc : longint = 10;

begin
  writeln;
  writeln;
  writeln;
  randomize;
  s.Init(100,Static);

  for i := 1 to poc do begin
    s.VlozObj(new(PIntO,Init(random(100),Dynamic)));
  end;

  for i := 1 to poc do begin
    write(PIntO(s.Pozice(i))^.x,' ');
  end;

  writeln;
  s.SeradPodle(cmp);
  for i := 1 to poc do begin
    write(PIntO(s.Pozice(i))^.x,' ');
  end;

  writeln;
  s.ProKazdyProved(akce);
  for i := 1 to poc do begin
    write(PIntO(s.Pozice(i))^.x,' ');
  end;

  writeln;

  s.Done;
end.