{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

unit Fronta;

interface
uses Seznam, SezClen{$ifndef NOMSG}, Zpravy{$endif}, Konsts;

type
     PFronta = ^TFronta;
     TFronta = object(TSeznam)
                 procedure Put(po : PSeznamClen); virtual;
                 function Get : PSeznamClen; virtual;
                 constructor Init(imaxobjs : longint; ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
                 destructor Done; virtual;
               end;

implementation

procedure TFronta.Put(po : PSeznamClen);
begin
  VlozObj(po);
end;

function TFronta.Get : PSeznamClen;
begin
  if pocet > 0 then begin
    if cache = ring.next then
      ZneplatniCache;
    Get := ring.next;
    ring.next^.VyradSe;
    dec(pocet);
  end
  else begin
    vysl := EmptyList;
    Get := nil;
    exit;
  end;
  vysl := Ok;
end;

constructor TFronta.Init(imaxobjs : longint; ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(imaxobjs, ityp{$ifndef NOMSG}, imajitel{$endif});
  objtyp := FrontaID;
end;

destructor TFronta.Done;
begin
  inherited Done;
end;


end.