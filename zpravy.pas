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