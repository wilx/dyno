{$X+}
type
     PCmpProc = ^TCmpProc;
     TCmpProc = function (p1, p2 : integer) : integer;

     TProc = procedure(x:integer);

var x : PCmpProc;
    i : integer;
    {p : TProc;}

function cmp (p1, p2 : integer) : integer; far;
begin
  if (p1 < p2) then
    cmp := -1
  else if p1 > p2 then
    cmp := +1
  else
    cmp := 0;
end;

procedure proc; far;
begin
  writeln('Hello World!!!');
end;

begin
  {p := addr(proc);}
  x := @cmp;
  i := x^(1,2);
  writeln(i);
end.