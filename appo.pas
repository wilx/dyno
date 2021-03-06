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
unit AppO;

interface
uses Seznam, Controls, Zpravy, Konsts;

const
      MaxObjVAplikaci = 500;

type
     TAplikace = object(TSeznam)
                   constructor Init(ityp : TClenTyp);
                   procedure Run; virtual;
                   procedure Idle; virtual;
                   procedure VezmiZpravu(sender : PKomunikace; co : word;
                                         info : pointer); virtual;
                   destructor Done; virtual;
                 end;

implementation

procedure TAplikace.VezmiZpravu(sender : PKomunikace; co : word;
                                info : pointer);
begin
end;

procedure TAplikace.Run;
begin
end;

{
 V procedure Idle by meli byt prikazy, ktere se provedou, pokud nenastane
 zadna udalost. Nemelo by to byt neco moc narocneho, protoze to muze zpomalit
 chod programu.
}
procedure TAplikace.Idle;
begin
end;

constructor TAplikace.Init(ityp : TClenTyp);
begin
  inherited Init(MaxObjVAplikaci, ityp, nil);
  objtyp := AplikaceID;
end;

destructor TAplikace.Done;
begin
  inherited Done;
end;

end.