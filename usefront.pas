uses Fronta, SezClen;

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
    f : TFronta;
    ch : char;

procedure Put;
var s : string;
begin
  write('zadej retezec:');
  readln(s);
  writeln('Put(''',s,''')');
  f.Put(new(PRetezec,Init(s,Dynamic)));
end;

procedure Get;
var ps : PRetezec;
begin
  if f.PocetObj > 0 then begin
    ps := PRetezec(f.Get);
    writeln('Get=''',ps^.s,'''');
    dispose(ps,Done);
  end
  else
    writeln('Fronta je prazdna!');
end;

begin
  f.Init(maxlongint,Static);
  writeln;
  repeat
    write('>');
    readln(ch);
    case upcase(ch) of
      'P' : Put;
      'G' : Get;
      'X' : konec := true;
    else
      writeln('Neznamy prikaz!');
    end;
  until konec=true;
  f.Done;
end.