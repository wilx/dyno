{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

{$X+,O-}
unit SerSez;

interface

uses SezClen, Seznam, Konsts,{$ifdef LUT}LUTs,{$endif} Nothing;

type
    {funkce pro usporadani, vraci aspon -1 kdyz p1 < p2}
    TCmpFunc = function (p1, p2 : PSeznamClen) : integer;

    PSerazenySeznam = ^TSerazenySeznam;
    TSerazenySeznam = object (TSeznam)
        cmpfunc : TCmpFunc;
        (*constructor Init2(imaxobjs : longint; ityp : TClenTyp
                        {$ifndef NOMSG}; imajitel : PKomunikace{$endif});*)
        constructor Init(imaxobjs : longint; icmpfunc : TCmpFunc;
                          ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
        destructor Done; virtual;
        procedure VlozObj(po : PSeznamClen); virtual;
        procedure PresunNahoru(po : PSeznamClen); virtual;
        procedure PresunDolu(po : PSeznamClen); virtual;
        procedure SeradPodle(icmpfunc : TCmpFunc); virtual;
    end;



implementation

procedure TSerazenySeznam.VlozObj(po : PSeznamClen);
var pom,pom2,pom3 : PSeznamClen;
    i : integer;
begin
  if po = nil then vysl := NilPtr
  else begin
    if pocet = 0 then {nic tu neni, neni ani poradi}
      inherited VlozObj(po)
    else if pocet < maxobjs then begin
      {zneplatneni cache, protoze nemuzeme vedet kam budeme vkladat}
      {$ifdef LUT}
      cache.DeleteTagPtr(po);
      {$else}
      cache := @ring;
      cacheclenpos := 0;
      {$endif}
      i := 1;
      {najdeme odpovidajici misto kam prvek vlozime}
      while (cmpfunc(po,Pozice(i)) < 0) and (i+1 <= pocet) do
        inc(i);
      pom := Pozice(i); {pred ktery prvek vkladam}
      pom2 := pom^.prev;
      {vlozim po mezi pom a pom2}
      po^.prev := pom2;
      po^.next := pom;
      {upravim vazby pom a pom2 na po}
      pom2^.next := po;
      pom^.prev := po;
      inc(pocet);
    end
    else vysl := FullList; {seznam je uz plny}
  end;
end;

procedure TSerazenySeznam.PresunNahoru(po : PSeznamClen); {smerem ke konci}
begin
  RunError(218);
end;

procedure TSerazenySeznam.PresunDolu(po : PSeznamClen); {smerem k zacatku seznamu}
begin
  RunError(218);
end;

procedure TSerazenySeznam.SeradPodle(icmpfunc : TCmpFunc);
var p,q,e,tail,oldhead,list : PSeznamClen;
    insize, nmerges, psize, qsize, i : integer;
begin
  {TODO: implementuj mergesort}
  cmpfunc := icmpfunc;
  if pocet <= 1 then
    exit;
  (*sez := new(PSeznam,Init(maxobjs,Dynamic
                     {$ifndef NOMSG},@self{$endif}));*)
  {$ifdef LUT}
  TODO: dodelat mazani cache
  {$else}
  cache := @ring;
  cacheclenpos := 0;
  {$endif}
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
        else if cmpfunc(q,p) < 0 then begin
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
        (*PresunObjDo(e,sez);*)
      end;

      {p a q pokrocily insize mist dopredu}
      p := q;
    end;
    (*{vlozeni serazeneho seznamu na zacatek}
    {vazba mezi poslednim ze sez a prvnim z ring}
    sez^.ring.prev^.next := ring.next;
    ring.next^.prev := sez^.ring.prev;
    {vazba mezi zacatkem ring a zacatkem sez}
    ring.next := sez^.ring.next;
    ring.next^.prev := @ring;
    {uvedeni sez^.ring doporadku}
    sez^.ring.next := @sez^.ring;
    sez^.ring.prev := @sez^.ring;

    pocet := pocet + sez^.pocet;
    sez^.pocet := 0;
    {$ifdef LUT}
    sez^.cache.DeleteTagPtr(po);
    {$else}
    sez^.cache := @sez^.ring;
    sez^.cacheclenpos := 0;
    {$endif}*)
    tail^.next := list;
    list^.prev := tail;
    if nmerges <= 1 then begin
      (*dispose(sez,Done);*)
      ring.next := list;
      list^.prev := @ring;
      ring.prev := tail;
      tail^.next := @ring;
      exit;
    end;
    insize := insize*2;
  end;
end;

(*constructor TSerazenySeznam.Init2(imaxobjs : longint; ityp : TClenTyp
                    {$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(imaxobjs, ityp{$ifndef NOMSG}, imajitel{$endif});
  objtyp := SerazenySeznamID;
end;*)

constructor TSerazenySeznam.Init(imaxobjs : longint; icmpfunc : TCmpFunc;
                    ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(imaxobjs, ityp{$ifndef NOMSG}, imajitel{$endif});
  objtyp := SerazenySeznamID;
  cmpfunc := icmpfunc;
end;

destructor TSerazenySeznam.Done;
begin
  inherited Done;
end;


end.