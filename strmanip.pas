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