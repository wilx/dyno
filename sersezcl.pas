{$ifdef DEBUG}
  {$D+,L+,Y+,R+,I+,C+,S+,V+,Q+}
{$endif}

{$X+,O-}
unit SerSezCl;

interface

uses SezClen, Konsts,{$ifndef NOMSG}Zpravy,{$endif} Nothing;

type
     PSerazenySeznamClen = ^TSerazenySeznamClen;
     TSerazenySeznamClen = object (TSeznamClen)
         constructor Init(ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
         destructor Done; virtual;
         function Less(po : PSerazenySeznamClen) : boolean; virtual;
     end;


implementation

function TSerazenySeznamClen.Less(po : PSerazenySeznamClen) : boolean;
begin
  RunError(217);
end;


constructor TSerazenySeznamClen.Init(ityp : TClenTyp
                    {$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(ityp{$ifndef NOMSG},imajitel{$endif});
  objtyp := SerazenySeznamClenID;
end;

destructor TSerazenySeznamClen.Done;
begin
  inherited Done;
end;

end.