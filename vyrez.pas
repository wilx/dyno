{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

{G+,O+}
{
Poznamka:
- Pouziva-li se Presun, musi se nejdrive Aktivovat vyrez, jinak se objekt
dokresli do puvodniho ViewPortu
}
unit Vyrez;

interface
uses Seznam, Zasobnik, GraphO, Controls, Graph, EProcs, Myska, Zpravy, Konsts;

type
     PViewPort = ^TViewPort;
     TViewPort = object(TSeznamClen)
                   vp : ViewPortType;
                   procedure vOn; virtual;
                   constructor Init(ivp : ViewPortType; ityp : TClenTyp);
                   destructor Done; virtual;
                 end;
     PVyrez = ^TVyrez;
     TVyrez = object (TSeznam)
                x,y,x2,y2 : word;
                aktiv : boolean;
                oldviewport : ViewPortType;
                ActualObj, objMouseDown : PSeznamClen;
                constructor Init(ix, iy, ix2, iy2, imaxobjs : word;
                                 ityp : TClenTyp; imajitel : PKomunikace);
                destructor Done; virtual;
                procedure Obnov; virtual;
                procedure Aktivuj; virtual;
                procedure Deaktivuj; virtual;
                procedure VlozObj(po : PSeznamClen); virtual;
                procedure SmazObj(po : PSeznamClen); virtual;
                procedure SmazObjNa(pos : longint); virtual;
                procedure PresunObjDo(po : PSeznamClen; nsez : PSeznam); virtual;
                procedure PresunObjNaDo(pos : longint; nsez : PSeznam); virtual;
                {procedure SmazVsechny; virtual;}
                function Dotaz(ix, iy : word) : boolean; virtual;
                function ObjPtr(ix, iy : word) : PSeznamClen;
                function GetX : word;
                function GetY : word;
                function GetX2 : word;
                function GetY2 : word;
                function GetActualObj : PSeznamClen;
                procedure SetVyrez(ix, iy, ix2, iy2 : word);
                procedure GetVyrez(var ix, iy, ix2, iy2 : word);
                procedure Vyrez2Normal(var ix, iy : word);
                procedure Normal2Vyrez(var ix, iy : word);
                {procedure Udalost(var iu : TUdalost); virtual;}
                procedure VezmiZpravu(sender : PKomunikace; co : word;
                                      info : pointer); virtual;
             end;

{ActualObj je pointer na aktualni objekt, nemelo by se s nim delat nic bez vedomi jeho
 vyrezu. Zpocatku je nil, udalost uMouseUp predana vyrezu nastavi jako
 aktualni objekt nad kterym bylo pusteno tlacitko, ale jen v pripade ze je
 to stejny objekt jako objMouseDown, jinak zustane nezmenen.}

implementation
{zasobnik pro TViewPort objekty}
var vps : TZasobnik;
    VyrezExitProcO : TExitProcO;

{metody objektu TViewPort}
procedure TViewPort.vOn;
begin
  with vp do setviewport(x1, y1, x2, y2,Clip);
end;

constructor TViewPort.Init(ivp : ViewPortType; ityp : TClenTyp);
begin
  inherited Init(ityp, nil);
  vp := ivp;
end;

destructor TViewPort.Done;
begin
  TSeznamClen.Done;
end;

{metody objektu TVyrez}
function TVyrez.GetX : word;
begin
  GetX := x;
end;

function TVyrez.GetY : word;
begin
  GetY := y;
end;

function TVyrez.GetX2 : word;
begin
  GetX2 := x2;
end;

function TVyrez.GetY2 : word;
begin
  GetY2 := y2;
end;

function TVyrez.GetActualObj : PSeznamClen;
begin
  GetActualObj := ActualObj;
end;

procedure TVyrez.SetVyrez(ix, iy, ix2, iy2 : word);
begin
  x := ix;
  y := iy;
  x2 := ix2;
  y2 := iy2;
  Obnov;
end;

procedure TVyrez.GetVyrez(var ix, iy, ix2, iy2 : word);
begin
  ix := x;
  iy := y;
  ix2 := x2;
  iy2 := y2;
end;

procedure TVyrez.Aktivuj;
var pom : PViewPort;
    ovp : ViewPortType;
begin
  GetViewSettings(ovp);
  new(pom,Init(ovp,Dynamic));
  vps.Push(pom);
  SetViewPort(x,y,x2,y2,true);
end;

procedure TVyrez.Deaktivuj;
var ovp : PViewPort;
begin
  ovp := PViewPort(vps.Pop);
  ovp^.vOn;
  dispose(ovp,Done);
end;

procedure TVyrez.Obnov;
var i : word;
    pom : PGraphicObject;
begin
  Aktivuj;
  {for i := 1 to pocet do begin
    pom := PGraphicObject(Pozice(i));
    pom^.Zhasni;
  end;}
  i := 1;
  while i <= pocet do begin
    pom := PGraphicObject(Pozice(i));
    pom^.Zhasni;
    inc(i);
  end;
  {for i := 1 to pocet do begin
    pom := PGraphicObject(Pozice(i));
    pom^.Zasvit;
  end;}
  i := 1;
  while i <= pocet do begin
    pom := PGraphicObject(Pozice(i));
    pom^.Zasvit;
    inc(i);
  end;
  Deaktivuj;
end;

procedure TVyrez.SmazObj(po : PSeznamClen);
begin
  Aktivuj;
  inherited SmazObj(po);
  Deaktivuj;
  Obnov;
end;

procedure TVyrez.SmazObjNa(pos : longint);
begin
  Aktivuj;
  inherited SmazObjNa(pos);
  Deaktivuj;
  Obnov;
end;

{procedure TVyrez.SmazVsechny;
begin
  inherited SmazVsechny;
  {nemusi se volat Obnov, protoze se v metode SmazObj}
{end;}

function TVyrez.ObjPtr(ix, iy : word) : PSeznamClen;
var i : word;
    pom : PGraphicObject;
begin
  if pocet > 0 then begin
    for i := 1 to pocet do begin
      pom := PGraphicObject(Pozice(i));
      if pom^.Dotaz(ix,iy) = true then begin
        ObjPtr := pom; {kdyz najdu takovej objekt, tak ho vratim a ukoncim se}
        exit;
      end;
    end;
    ObjPtr := nil;
  end
  else
    ObjPtr := nil; {jinak vratim nil}
end;

procedure TVyrez.VlozObj(po : PSeznamClen);
begin
  inherited VlozObj(po);
  Obnov;
end;

procedure TVyrez.PresunObjDo(po : PSeznamClen; nsez : PSeznam);
begin
  PGraphicObject(po)^.Zhasni;
  inherited PresunObjDo(po,nsez);
  PVyrez(nsez)^.Obnov;
end;

procedure TVyrez.PresunObjNaDo(pos : longint; nsez : PSeznam);
var pom : PSeznamClen;
begin
  pom := Pozice(pos);
  PGraphicObject(pom)^.Zhasni;
  inherited PresunObjDo(pom,nsez);
  PVyrez(nsez)^.Obnov;
end;

procedure TVyrez.Vyrez2Normal(var ix, iy : word);
begin
  ix := x + ix;         {transformace souradni vyrezu na globalni}
  iy := y + iy
end;

procedure TVyrez.Normal2Vyrez(var ix, iy : word);
begin
  ix := ix - x;
  iy := iy - y;
end;

function TVyrez.Dotaz(ix, iy : word) : boolean;
begin
  if ((ix >= x) and (ix <= x2)) and ((iy >= y) and (iy <= y2)) then
    Dotaz := true
  else
    Dotaz := false;
end;

procedure TVyrez.VezmiZpravu(sender : PKomunikace; co : word; info : pointer);
var i, pomx, pomy : word;
    pom : PSeznamClen;
    pom2 : PUdalost;
begin
  if co = zpReset then begin
    ActualObj := nil;
    objMouseDown := nil;
  end
  else begin
    pomx := pom2^.x; pomy := pom2^.y; {prevod na vnitrni souradnice}
    Normal2Vyrez(pomx,pomy);
    case co of
      zpRBDown : begin
                   objMouseDown := ObjPtr(pomx,pomy)
                 end;
      zpRBUp : begin
                 pom := ObjPtr(pomx,pomy);
                 if (pom = objMouseDown) and (pom <> nil) then
                   ActualObj := objMouseDown;
               end;
      zpMouseMove : begin
                    end;
    end;
  end;
end;

constructor TVyrez.Init(ix, iy, ix2, iy2, imaxobjs : word; ityp : TClenTyp; imajitel : PKomunikace);
begin
  x := ix; y := iy; x2 := ix2; y2 := iy2;
  inherited Init(imaxobjs,ityp, imajitel);
  objtyp := VyrezID;
end;

destructor TVyrez.Done;
begin
  inherited Done;
end;

procedure VyrezExitProc; far;
begin
  vps.Done;
end;

begin
  vps.Init(256,Static, nil);
  VyrezExitProcO.Init(VyrezExitProc,Static);
  epchain.VlozObj(@VyrezExitProcO);
end.