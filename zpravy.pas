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
unit Zpravy;

interface

type
     PKomunikace = ^TKomunikace;
     TKomunikace = object
                majitel : PKomunikace;
                function GetMajitel : PKomunikace;
                procedure SetMajitel(imajitel : PKomunikace);
                procedure VezmiZpravu(sender : PKomunikace; co : word;
                                      info : pointer); virtual;
                procedure PosliZpravu(receiver : PKomunikace; co : word;
                                      info : pointer); virtual;
                procedure OnRButtonUp(sender : PKomunikace); virtual;
                procedure OnRButtonDown(sender : PKomunikace); virtual;
                procedure OnLButtonUp(sender : PKomunikace); virtual;
                procedure OnLButtonDown(sender : PKomunikace); virtual;
                procedure OnMAuto(sender : PKomunikace); virtual;
                procedure OnLButtonClick(sender : PKomunikace); virtual;
                procedure OnRButtonClick(sender : PKomunikace); virtual;
                constructor Init(imajitel : PKomunikace);
                destructor Done; virtual;
              end;


implementation

procedure TKomunikace.PosliZpravu(receiver : PKomunikace; co : word; info : pointer);
begin
  if receiver <> nil then
    receiver^.VezmiZpravu(@self,co,info);
end;

procedure TKomunikace.VezmiZpravu(sender : PKomunikace; co : word; info : pointer);
begin
  RunError(217);
end;

procedure TKomunikace.OnRButtonUp(sender : PKomunikace);
begin
  RunError(217);
end;

procedure TKomunikace.OnRButtonDown(sender : PKomunikace);
begin
  RunError(217);
end;

procedure TKomunikace.OnLButtonUp(sender : PKomunikace);
begin
  RunError(217);
end;

procedure TKomunikace.OnLButtonDown(sender : PKomunikace);
begin
  RunError(217);
end;

procedure TKomunikace.OnMAuto(sender : PKomunikace);
begin
  RunError(217);
end;

procedure TKomunikace.OnLButtonClick(sender : PKomunikace);
begin
  RunError(217);
end;

procedure TKomunikace.OnRButtonClick(sender : PKomunikace);
begin
  RunError(217);
end;

function TKomunikace.GetMajitel : PKomunikace;
begin
  GetMajitel := majitel;
end;

procedure TKomunikace.SetMajitel(imajitel : PKomunikace);
begin
  majitel := imajitel;
end;

constructor TKomunikace.Init(imajitel : PKomunikace);
begin
  majitel := imajitel;
end;

destructor TKomunikace.Done;
begin
end;

end.