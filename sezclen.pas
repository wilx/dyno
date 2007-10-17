{
Copyright (c) 1997-2007, Václav Haisman

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
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
