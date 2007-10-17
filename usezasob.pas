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
uses Zasobnik, Seznam, SezClen;

type
     PRetezec = ^TRetezec;
     TRetezec = object(TSeznamClen)
                  s : string;
                  constructor Init(is : string; ityp : TClenTyp);
                end;

constructor TRetezec.Init(is : string; ityp : TClenTyp);
begin
  inherited Init(ityp);
  s := is;
end;

var konec : boolean;
    z : TZasobnik;
    ch : char;

procedure Push;
var s : string;
begin
  write('zadej retezec:');
  readln(s);
  writeln('Push(''',s,''')');
  z.Push(new(PRetezec,Init(s,Dynamic)));
end;

procedure Pop;
var ps : PRetezec;
begin
  if z.PocetObj > 0 then begin
    ps := PRetezec(z.Pop);
    writeln('Get=''',ps^.s,'''');
    dispose(ps,Done);
  end
  else
    writeln('Zasobnik je prazdny!');
end;

begin
  z.Init(maxlongint,Static);
  writeln;
  repeat
    write('>');
    readln(ch);
    case upcase(ch) of
      'P' : Push;
      'G' : Pop;
      'X' : konec := true;
    else
      writeln('Neznamy prikaz!');
    end;
  until konec=true;
  z.Done;
end.