{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

{$X+,O-}
{?!?!?!?!?!?!?!?!?}
unit Iterator;

interface
uses Seznam, SezClen;

type TIterator = object
      private
       seznam : PSeznam;
       last : PSeznamClen;
      public
       function Next : PSeznamClen; virtual;
       procedure Reset; virtual;
       constructor Init(psez : PSeznam);
     end;

implementation

constructor TIterator.Init(psez : PSeznam);
begin
  if seznam = nil then
    Fail;
  seznam := psez;
  last := @seznam^.ring;
end;

function TIterator.Next;
begin
  if last <> @seznam^.ring then begin
    Next := last;
    last := last^.next;
  end
  else
    Next := nil;
end;

procedure TIterator.Reset;
begin
  last := seznam^.ring.next;
end;

end.