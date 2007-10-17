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
unit Datum;

interface
uses SezClen{$ifndef NOMSG}, Zpravy{$endif};

type
  PDen = ^TDen;
  TDen = 1..31;

  PMesic = ^TMesic;
  TMesic = 1..12;

  PRok = ^TRok;
  TRok = 1970..2138;

  PHodina = ^THodina;
  THodina = 1..23;

  PMinuta = ^TMinuta;
  TMinuta = 0..59;

  PSekunda = ^TSekunda;
  TSekunda = 0..59;

  PDatumRec = ^TDatumRec;
  TDatumRec = record
                den : TDen;
                mesic : TMesic;
                rok : TRok;
                hodina : THodina;
                minuta : TMinuta;
                sekunda : TSekunda;
              end;

  PDatum = ^TDatum;
  TDatum = object(TSeznamClen)
             den : TDen;
             mesic : TMesic;
             rok : TRok;
             hodina : THodina;
             minuta : TMinuta;
             sekunda : TSekunda;
             procedure Plus(irok, imesic, iden, ihodina, iminuta, isekunda : word);
             procedure SetDatum(const datumrec : TDatumRec);
             procedure GetDatum(var datumrec : TDatumRec);
             function IsLess(const idatum : TDatum) : boolean;
             function IsMore(const idatum : TDatum) : boolean;
             function IsEqual(const idatum : TDatum) : boolean;
             procedure TiskniSe(var f : text); virtual;
             function GetString : string; virtual;
             constructor Init(irok : TRok; imesic : TMesic; iden : TDen;
                              ihodina : THodina; iminuta : TMinuta;
                              isekunda : TSekunda;
                              ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
             constructor Init2(const idatum : TDatum;
                               ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
             constructor Init3(const datumrec : TDatumRec;
                               ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
             constructor InitNow(ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
             destructor Done; virtual;
           end;

  (*PDatumRozpeti = ^TDatumRozpeti;
  TDatumRozpeti = object(TSeznamClen)
                    rozpeti : longint;
                    constructor Init(d1, d2 : TDatum;
                                     ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
                    {destructor Done; virtual;}
                 end;*)

const _dny : array [0..11] of byte = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

procedure More(const d1, d2 : TDatum; var dest : TDatum);
procedure Less(const d1, d2 : TDatum; var dest : TDatum);
function Equal(const d1, d2 : TDatum) : boolean;
{procedure DatumRozpeti(const d1, d2 : TDatum; var dest : TDatumRozpeti);}


implementation
uses Konsts, WinDos;

const cRokMin : TRok = 1970;
{      _Days : array [0..11] of byte = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
      YDays : array [0..11] of integer = (0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);}

(*function totalsec(year, month, day, hour, min, sec : integer) : longint;
var leaps : integer;
    days, secs : longint;
begin
    {if (year < 70 || year > 138)
	return ((time_t) -1);}
    {vse zacina od nuly (0)}
    min := sec div 60;
    sec := sec mod 60;
    hour := hour + min div 60;
    min := min mod 60;
    day := day + hour div 24;
    hour := hour mod 24;
    year := year + month div 12;
    month := month mod 12;
    while (day >= _Days[month]) do begin
      if ((year mod 4) = 0) and (month=1) then begin
        if day > 28 then begin
  	  dec(day,29);
	  inc(month);
	end
	else
          break;
      end
      else begin
        day := day - _Days[month];
        inc(month);
      end;
        year := year + month div 12; {/* Normalize month */}
        month := month mod 12;
    end;
    dec(year,70);
    leaps := (year + 2) div 4;
    if (not((year+70) mod 4 = 0) and (month < 2)) then
      dec(leaps);
    days := year*365 + leaps + YDays[month] + day;
    secs := days*86400 + hour*3600 + min*60 + sec;
    totalsec := secs;
end;*)

procedure More(const d1, d2 : TDatum; var dest : TDatum);
begin;
  with d1 do begin
    dest := d2;
    if rok > d2.rok then
      dest := d1
    else if rok = d2.rok then
      if mesic > d2.mesic then
        dest := d1
      else if mesic = d2.mesic then
        if den > d2.den then
          dest := d1
        else if den = d2.den then
          if hodina > d2.hodina then
            dest := d1
          else if hodina = d2.hodina then
            if minuta > d2.minuta then
              dest := d1
            else if minuta = d2.minuta then
              if sekunda > d2.sekunda then
                dest := d1;
  end;
end;

procedure Less(const d1, d2 : TDatum; var dest : TDatum);
begin;
  with d1 do begin
    dest := d2;
    if rok < d2.rok then
      dest := d1
    else if rok = d2.rok then
      if mesic < d2.mesic then
        dest := d1
      else if mesic = d2.mesic then
        if den < d2.den then
          dest := d1
        else if den = d2.den then
          if hodina < d2.hodina then
            dest := d1
          else if hodina = d2.hodina then
            if minuta < d2.minuta then
              dest := d1
            else if minuta = d2.minuta then
              if sekunda < d2.sekunda then
                dest := d1;
  end;
end;

function Equal(const d1, d2 : TDatum) : boolean;
begin;
  with d1 do
    if (rok = d2.rok) and (mesic = d2.mesic) and (den = d2.den)
     and (hodina = d2.hodina) and (minuta = d2.minuta)
     and (sekunda = d2.sekunda) then
      Equal := true
    else
      Equal := false;
end;

{procedure DatumRozpeti(const d1, d2 : TDatum; var dest : TDatumRozpeti);
var d1sec, d2sec : longint;
begin
  d1sec := totalsec(d1.rok,d1.mesic,d1.den,d1.hodina,d1.minuta,d1.sekunda);
  d2sec := totalsec(d2.rok,d2.mesic,d2.den,d2.hodina,d2.minuta,d2.sekunda);
  dest.rozpeti := d2sec - d1sec;
end;}

{metody objektu TDatum}

procedure TDatum.Plus(irok, imesic, iden, ihodina, iminuta, isekunda : word);
begin
  irok := rok + irok - 1;
  imesic := mesic + imesic - 1;
  iden := den + iden - 1;
  ihodina := hodina + ihodina - 1;
  iminuta := minuta + iminuta - 1;
  isekunda := sekunda + isekunda - 1;

  iminuta := iminuta + isekunda div 60;
  isekunda := isekunda mod 60;

  ihodina := ihodina + iminuta div 60;
  iminuta  := iminuta mod 60;

  iden := iden + ihodina div 24;
  ihodina := ihodina mod 24;

  irok := irok + imesic div 12;
  imesic := imesic mod 12;

  if iden > _dny[imesic] then
    while iden >= _dny[imesic mod 12] do begin
      if ((irok mod 4) = 0) and (imesic = 1) then begin
        inc(imesic);
        dec(iden,29);
      end
      else begin
        inc(imesic);
        iden := iden - _dny[imesic mod 12];
      end;
    end;
  irok := irok + imesic div 12;
  imesic := imesic mod 12;

  rok := irok + 1;
  mesic := imesic + 1;
  den := iden + 1;
  hodina := ihodina + 1;
  minuta := iminuta + 1;
  sekunda := isekunda + 1;
end;

procedure TDatum.SetDatum(const datumrec : TDatumRec);
begin
  rok := datumrec.rok;
  mesic := datumrec.mesic;
  den := datumrec.den;
  hodina := datumrec.hodina;
  minuta := datumrec.minuta;
  sekunda := datumrec.sekunda;
end;

procedure TDatum.GetDatum(var datumrec : TDatumRec);
begin
  datumrec.rok := rok;
  datumrec.mesic := mesic;
  datumrec.den := den;
  datumrec.hodina := hodina;
  datumrec.minuta := minuta;
  datumrec.sekunda := sekunda;
end;

function TDatum.IsLess(const idatum : TDatum) : boolean;
var d : TDatum;
begin
  Less(self,idatum,d);
  if Equal(self,d) then
    IsLess := true
  else
    IsLess := false;
end;

function TDatum.IsMore(const idatum : TDatum) : boolean;
var d : TDatum;
begin
  More(self,idatum,d);
  if Equal(self,d) then
    IsMore := true
  else
    IsMore := false;
end;

function TDatum.IsEqual(const idatum : TDatum) : boolean;
begin
  if Equal(self,idatum) then
    IsEqual := true
  else
    IsEqual := false;
end;

procedure TDatum.TiskniSe(var f : text);
begin
  write(f,den,'.',mesic,'.',rok,' ',hodina,':',minuta,':',sekunda)
end;

function TDatum.GetString : string;
var pom : string[4];
    s : string;
begin
  str(den,s);
  str(mesic,pom);
  s := s + '.' + pom + '.';
  str(rok,pom);
  s := s + pom + ' ';
  str(hodina,pom);
  s := s + pom + ':';
  str(minuta,pom);
  s := s + pom + ':';
  str(sekunda,pom);
  s := s + pom;
  GetString := s;
end;

constructor TDatum.Init(irok : TRok; imesic : TMesic; iden : TDen;
                 ihodina : THodina; iminuta : TMinuta;
                 isekunda : TSekunda;
                 ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(ityp{$ifndef NOMSG}, imajitel{$endif});
  objtyp := DatumID;
  rok := irok;
  mesic := imesic;
  den := iden;
  hodina := ihodina;
  minuta := iminuta;
  sekunda := isekunda;
end;

constructor TDatum.Init2(const idatum : TDatum;
                         ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(ityp{$ifndef NOMSG},imajitel{$endif});
  objtyp := DatumID;
  self := idatum;
end;

constructor TDatum.Init3(const datumrec : TDatumRec;
                         ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(ityp{$ifndef NOMSG},imajitel{$endif});
  objtyp := DatumID;
  rok := datumrec.rok;
  mesic := datumrec.mesic;
  den := datumrec.den;
  hodina := datumrec.hodina;
  minuta := datumrec.minuta;
  sekunda := datumrec.sekunda;
end;

constructor TDatum.InitNow(ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
var pom,r,m,d,s,h : word;
begin
  inherited Init(ityp{$ifndef NOMSG},imajitel{$endif});
  objtyp := DatumID;
  GetDate(r,m,d,pom);
  rok := r; mesic := m; den := d;
  GetTime(h,m,s,pom);
  hodina := h; minuta := m; sekunda := s;
end;

destructor TDatum.Done;
begin
  inherited Done;
end;

{metody objektu TDatumRozpeti}
(*constructor TDatumRozpeti.Init(d1, d2 : TDatum;
                             ityp : TClenTyp{$ifndef NOMSG}; imajitel : PKomunikace{$endif});
begin
  inherited Init(ityp{$ifndef NOMSG},imajitel{$endif});
  objtyp := DatumRozpetiID;
end;*)

end.