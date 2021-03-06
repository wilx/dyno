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