{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

{$X+,O-}
unit Seznam;

interface
uses SezClen;


type
     TVysledek = (Ok,NilPtr,BadPtr,BadPos,FullList,EmptyList);
     {funkce pro usporadani, vraci aspon -1 kdyz p1 < p2}
     TCmpFunc = function (p1, p2 : PSeznamClen) : integer;
     TActionProc = procedure (p : PSeznamClen; params : pointer);
     TFindFunc = function (p : PSeznamClen) : boolean;
     PSeznam = ^TSeznam;
     TSeznam = object (TSeznamClen)
       ring : TSeznamClen;
       pocet, maxobjs, cacheclenpos : longint;
       vysl : TVysledek;
       cache : PSeznamClen;

       constructor Init(imaxobjs : longint; ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
       destructor Done; virtual;
       procedure VlozObj(po : PSeznamClen); virtual;
       procedure SmazObj(po : PSeznamClen); virtual;
       procedure SmazObjNa(pos : longint); virtual;
       procedure SmazVsechny; virtual;
       procedure PresunObjDo(po : PSeznamClen; nsez : PSeznam); virtual;
       procedure PresunObjNaDo(pos : longint; nsez : PSeznam); virtual;
       procedure PresunNahoru(po : PSeznamClen); virtual;
       procedure PresunDolu(po : PSeznamClen); virtual;
       procedure TiskniNa(var f : text; pos : longint); virtual;
       procedure Spoj(psez : PSeznam); virtual;
       procedure SeradPodle(cmpfunc : TCmpFunc);
       procedure ZneplatniCache;
       procedure ProKazdyProved(actionproc : TActionProc;
                                params : pointer); virtual;
       function HledejPodle(findfunc : TFindFunc) : PSeznam;
       function Pozice(pos : longint) : PSeznamClen;
       function PocetObj : longint;
       function Vysledek : TVysledek;
     end;

procedure Prohlizej(sez : PSeznam; width : byte);

implementation
uses Konsts, KeybCtrl;

{procedury}
procedure Prohlizej(sez : PSeznam; width : byte);
var i, l, h : longint;
    konec : boolean;
    ch : word;
    pom : PSeznamClen;
begin
  with sez^ do begin
    if PocetObj > 0 then begin
      dec(width);
      konec := false;
      l := 1;
      if PocetObj >= width then
        h := width
      else
        h := PocetObj;
      repeat
        for i := l to h do begin
          pom := Pozice(i);
          pom^.TiskniSe(output);
          writeln;
        end;
        writeln('(',100*h/PocetObj:5:1,'%)');
        ch := kGetKey;
        case ch of
          kESC : konec := true;
          kUp : begin
            if l - width < 1 then
              l := 1
            else
              l := l - width;
            if h - width < l then
              h := PocetObj
            else
              h := h - width;
          end;
          kDown : begin
            if h + width > PocetObj then
              h := PocetObj
            else
              h := h + width;
            if l + width > h then
              l := 1
            else
              l := l + width;
          end;
        end;
      until konec = true;
    end;
  end;
end;


{metody objektu TSeznam}

function TSeznam.Vysledek : TVysledek;
begin
  Vysledek := vysl;
end;

function TSeznam.PocetObj : longint;
begin
  PocetObj := pocet;
end;

procedure TSeznam.TiskniNa(var f : text; pos : longint);
var pom : PSeznamClen;
begin
  pom := Pozice(pos);
  pom^.TiskniSe(f);
end;

procedure TSeznam.ZneplatniCache;
begin
  cache := @ring;
  cacheclenpos := 0;
end;

constructor TSeznam.Init(imaxobjs : longint; ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(ityp{$ifndef NOMSG},imajitel{$endif}); {musi se volat drive, protoze dava next a prev = nil}
  if imaxobjs = 0 then begin
    inherited Done;
    Fail; {kdyz imaxobjs = 0, nemuzu pridat zadny objekt tak se ukoncim}
  end;
  {inicializace vlozeneho obektu, ktery drzi vazby na seznam}
  ring.Init(Static{$ifndef NOMSG},@self{$endif});
  ring.prev := @ring;
  ring.next := @ring;

  objtyp := SeznamID;
  maxobjs := imaxobjs;
  pocet := 0;

  ZneplatniCache;
end;

procedure TSeznam.VlozObj(po : PSeznamClen);
begin
  if po = nil then vysl := NilPtr
  else begin
    if pocet < maxobjs then begin
      ring.prev^.next := po;
      po^.prev := ring.prev;
      po^.next := @ring;
      ring.prev := po;
      inc(pocet);
      vysl := Ok;
    end
    else vysl := FullList; {seznam je uz plny}
  end;
end;

function TSeznam.Pozice(pos : longint) : PSeznamClen;
var pom : PSeznamClen;
    i : word;
begin
  if (pos > 0) and (pos <= pocet) and (pocet > 0) then begin
    {jestli je ta pozice v cache tak ji vrat}
    if pos = cacheclenpos then
      Pozice := cache
    else if pos = cacheclenpos + 1 then begin {optimalizace pro sekvenci pruchod seznamem}
      inc(cacheclenpos);
      cache := cache^.next;
      Pozice := cache;
    end
    else if pos = cacheclenpos - 1 then begin
      dec(cacheclenpos);
      cache := cache^.prev;
      Pozice := cache;
    end
    else begin
      pom := ring.next;
      i := 1;
      while (i < pos) and (i <= pocet) do begin
        pom := pom^.next;
        inc(i);
      end;
      Pozice := pom;

      cache := pom;
      cacheclenpos := pos;
    end;
  end
  else begin
    Pozice := nil;
    vysl := BadPos; {kdyz neni splnena podminka ^, nastavi se BadPos}
  end;
end;

procedure TSeznam.SmazObj(po : PSeznamClen);
begin
  if po = nil then
    vysl := NilPtr
  else begin
    if pocet > 0 then begin
      ZneplatniCache;
      if po^.GetClenTyp = Dynamic then
        dispose(po,Done)
      else
        po^.Done;
      dec(pocet);
    end;
    vysl := Ok;
  end;
end;

procedure TSeznam.SmazObjNa(pos : longint);
var pom : PSeznamClen;
begin
  if (pos > 0) and (pos <= pocet) and (pocet > 0) then begin
    pom := Pozice(pos);
    ZneplatniCache;
    if pom^.GetClenTyp = Dynamic then
      dispose(pom,Done)
    else
      pom^.Done;
    dec(pocet);
  end
  else vysl := BadPos;
end;

{presune objekt po do seznamu nsez}
procedure TSeznam.PresunObjDo(po : PSeznamClen; nsez : PSeznam);
begin
  if po = nil then vysl := NilPtr
  else begin
    if nsez^.pocet < nsez^.maxobjs then begin
      ZneplatniCache;
      po^.VyradSe;
      dec(pocet);
      nsez^.VlozObj(po);
      vysl := Ok;
    end
    else vysl := FullList; {seznam je uz plny}
  end;
end;

{presune objekt na pozici pos do seznamu nsez}
procedure TSeznam.PresunObjNaDo(pos : longint; nsez : PSeznam);
var pom : PSeznamClen;
begin
  if (pos > 0) and (pos <= pocet) and (pocet > 0) then begin
    pom := Pozice(pos);
    if pom = nil then vysl := NilPtr
    else begin
      ZneplatniCache;
      if nsez^.pocet < nsez^.maxobjs then begin
        pom^.VyradSe;
        dec(pocet);
        nsez^.VlozObj(pom);
        vysl := Ok;
      end
      else
        vysl := FullList; {seznam je uz plny}
    end;
  end
  else vysl := BadPos; {kdyz neni splnea podminka ^ (uplne nahore), nastavi se BadPos}
end;

procedure TSeznam.PresunNahoru(po : PSeznamClen); {smerem ke konci}
var pom, pom2, pom3 : PSeznamClen;
begin
  if pocet < 2 then begin
    if pocet = 0 then
      vysl := BadPtr;
    exit;
  end;
  pom := po^.next;
  pom2 := po^.next^.next;
  pom3 := pom^.prev;
  if (cache = po) or (cache = pom) then {zajisteni konzistence cache}
    ZneplatniCache;
  po^.next := pom2;
  po^.prev := pom;
  pom^.next := po;
  pom^.prev := pom3;
  pom3^.next := pom;
  pom2^.prev := po;
end;

procedure TSeznam.PresunDolu(po : PSeznamClen); {smerem k zacatku seznamu}
var pom, pom2, pom3 : PSeznamClen;
begin
  if pocet < 2 then begin
    if pocet = 0 then
      vysl := BadPtr;
    exit;
  end;
  pom := po^.prev;
  pom2 := po^.prev^.prev;
  pom3 := pom^.next;
  {zajisteni konzistence cache}
  if (cache = po) or (cache = pom) then {zajisteni konzistence cache}
    ZneplatniCache;
  po^.prev := pom2;
  po^.next := pom;
  pom^.prev := po;
  pom^.next := pom3;
  pom3^.prev := pom;
  pom2^.next := po;
end;


procedure TSeznam.SeradPodle(cmpfunc : TCmpFunc);
var p,q,e,tail,oldhead,list : PSeznamClen;
    insize, nmerges, psize, qsize, i : longint;
begin
  if pocet <= 1 then
    exit;
  ZneplatniCache;

  insize := 1;

  list := ring.next;
  list^.prev := ring.prev;
  list^.prev^.next := list;
  while true do begin
    p := list;
    oldhead := list;
    list := nil;
    tail := nil;

    nmerges := 0;

    while p <> nil do begin
      inc(nmerges);
      {postup o insize prvku od p}
      q := p;
      psize := 0;
      for i := 0 to insize-1 do begin
        inc(psize);
        q := q^.next;
        if q = oldhead then begin
          q := nil;
          break;
        end;
      end;
      qsize := insize;

      {nyni mame dva seznamy, spojime je}
      while (psize > 0) or ((qsize > 0) and (q <> nil)) do begin
        if psize = 0 then begin
          {p je prazdny, e musi byt z q}
          e := q;
          q := q^.next;
          dec(qsize);
          if q = oldhead then
            q := nil;
        end
        else if (qsize = 0) or (q = nil) then begin
          {q je prazdny, e musi byt z p}
          e := p;
          p := p^.next;
          dec(psize);
          if p = oldhead then
            p := nil;
        end
        else if cmpfunc(p,q) < 0 then begin
          {prvni prvek z p je mensi, e musi byt z p}
          e := p;
          p := p^.next;
          dec(psize);
          if p = oldhead then
            p := nil;
        end
        else begin
          {prvni prvek q je mensi, e musi byt z q}
          e := q;
          q := q^.next;
          dec(qsize);
          if q = oldhead then
            q := nil;
        end;

        {pridej dalsi prvek do sjednoceneho seznamu}
        if tail <> nil then
          tail^.next := e
        else
          list := e;
        e^.prev := tail;
        tail := e;
      end;

      {p a q pokrocily insize mist dopredu}
      p := q;
    end;
    tail^.next := list;
    list^.prev := tail;
    if nmerges <= 1 then begin
      ring.next := list;
      list^.prev := @ring;
      ring.prev := tail;
      tail^.next := @ring;
      exit;
    end;
    insize := insize*2;
  end;
end;


function TSeznam.HledejPodle(findfunc : TFindFunc) : PSeznam;
begin
  {?!?!?}
end;

procedure TSeznam.ProKazdyProved(actionproc : TActionProc; params : pointer);
var pom : PSeznamClen;
begin
  if pocet > 0 then begin
    pom := ring.next;
    {projdeme celym seznamem a na kazdy prvek aplikujeme actionproc}
    while pom <> @ring do begin
      actionproc(pom,params);
      pom := pom^.next;
    end;
  end;
end;


procedure TSeznam.SmazVsechny;
begin
  while pocet > 0 do begin
    if ring.next^.GetClenTyp = Dynamic then
        dispose(ring.next,Done)
      else
        ring.next^.Done;
      dec(pocet);
  end;
  ZneplatniCache;
end;

{presune vsechny objekty z psez}
procedure TSeznam.Spoj(psez : PSeznam);
begin
  while psez^.pocet > 0 do begin
    PresunObjDo(psez^.next,@self);
  end;
end;

destructor TSeznam.Done;
begin
  SmazVsechny;
  {$ifdef LUT}
  cache.Done;
  {$endif}
  {$ifndef NOMSG}
  inherited Done;
  {$endif}
end;

end.