{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

{$X+,G+,O+}
unit Zasobnik;

interface

uses Seznam, SezClen{$ifndef NOMSG}, Zpravy{$endif}, Konsts;

type
     PZasobnik = ^TZasobnik;
     TZasobnik = object(TSeznam)
                   procedure Push(po : PSeznamClen); virtual;
                   function Pop : PSeznamClen; virtual;
                   constructor Init(imaxobjs : longint; ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
                   destructor Done; virtual;
                 end;

implementation
{metody objektu TZasobnik}
procedure TZasobnik.Push(po : PSeznamClen);
begin
  VlozObj(po);
end;

function TZasobnik.Pop : PSeznamClen;
begin
  if pocet > 0 then begin
    if cache = ring.prev then
      ZneplatniCache;
    Pop := ring.prev;
    ring.prev^.VyradSe;
    dec(pocet);
  end
  else begin
    vysl := EmptyList;
    Pop := nil;
    exit;
  end;
  vysl := Ok;
end;

constructor TZasobnik.Init(imaxobjs : longint; ityp : TClenTyp
                          {$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(imaxobjs, ityp{$ifndef NOMSG}, imajitel{$endif});
end;

destructor TZasobnik.Done;
begin
  inherited Done;
end;

end.