
type TA = object
            x : integer;
          end;

     TB = object(TA)
            a : TA;

          end;

var x : TB;

begin
  writeln(longint(@x),'  ',longint(@x.a));
end.