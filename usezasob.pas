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