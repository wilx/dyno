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