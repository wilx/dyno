{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

{$X+,O-}
unit SezClen;

interface

uses Konsts,{$ifndef NOMSG}Zpravy,{$endif} Nothing;

type
     TClenTyp = (Static,Dynamic);
     PSeznamClen = ^TSeznamClen;
     TSeznamClen = object{$ifndef NOMSG}(TKomunikace){$endif}
                     next, prev : PSeznamClen;
                     typ : TClenTyp;
                     objtyp : word;
                     function GetPrev : PSeznamClen;
                     function GetNext : PSeznamClen;
                     {vrati zda je objekt staticky nebo dynamicky}
                     function GetClenTyp : TClenTyp;
                     {vrati cislo typu objektu pr.: SeznamClenID = 1}
                     function GetObjTyp : word;
                     constructor Init(ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
                     destructor Done; virtual;
                     procedure VyradSe; virtual;
                     procedure TiskniSe(var f : text); virtual;
                     function GetString : string; virtual;
                   end;

implementation

{metody objektu TSeznamClen}
function TSeznamClen.GetPrev : PSeznamClen;
begin
  GetPrev := prev;
end;

function TSeznamClen.GetNext : PSeznamClen;
begin
  GetNext := next;
end;

function TSeznamClen.GetClenTyp : TClenTyp;
begin
  GetClenTyp := typ;
end;

function TSeznamClen.GetObjTyp : word;
begin
  GetObjTyp := objtyp;
end;

procedure TSeznamClen.VyradSe;
begin
  if (next <> nil) and (prev <> nil) then begin
    prev^.next := next;
    next^.prev := prev;
    next := nil;
    prev := nil;
  end;
end;

procedure TSeznamClen.TiskniSe(var f : text);
begin
  RunError(217);
end;

function TSeznamClen.GetString : string;
begin
  RunError(217);
end;

constructor TSeznamClen.Init(ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  {$ifndef NOMSG}inherited Init(imajitel){$endif};
  typ := ityp;
  next := nil; prev := nil;
  objtyp := SeznamClenID;
end;

destructor TSeznamClen.Done;
begin
  VyradSe;
  {$ifndef NOMSG}inherited Done{$endif};
end;

end.
