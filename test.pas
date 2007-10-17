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
{$F+}
program Test;

uses SezClen, Seznam, Crt;

{definice typu}
type
     PSong = ^TSong;
     TSong = object (TSeznamClen)
       nazev : string;
       delka : integer;
       poradi : integer;

       procedure TiskniSe(var f : text); virtual;
       constructor Init(const inazev : string;
                        idelka : integer; iporadi : integer;
                        ityp : TClenTyp);
     end;


     PSongsList = ^TSongsList;
     TSongsList = object (TSeznam)
       constructor Init(ityp : TClenTyp);
     end;


     PAlbum = ^TAlbum;
     TAlbum = object (TSeznamClen)
       pk : longint;
       nazev : string;
       interpret : string;
       delka : integer;
       pocetskladeb : integer;
       songs : TSongsList;

       procedure VlozSong(const inazev : string; idelka : integer;
                          iporadi : integer);
       procedure TiskniSe(var f : text); virtual;
       constructor Init(ipk : longint; const inazev, iinterpret : string;
                        idelka, ipocetskladeb : integer;
                        ityp : TClenTyp);
       destructor Done; virtual;
     end;


     PAlbumsList = ^TAlbumsList;
     TAlbumsList = object (TSeznam)
       lastpk : longint;

       {procedure VlozObj(po : PSeznamClen); virtual;}
       function VlozAlbum(const inazev, iinterpret : string;
                          idelka, ipocetskladeb : integer) : PAlbum;
       constructor Init(ityp : TClenTyp);
     end;


{*****
 TSong
 *****}
constructor TSong.Init(const inazev : string;
                       idelka : integer; iporadi : integer;
                       ityp : TClenTyp);
begin
  inherited Init(ityp);
  nazev := inazev;
  delka := idelka;
  poradi := iporadi;
end;

procedure TSong.TiskniSe(var f : text);
begin
  writeln(f,'C: ',poradi:2,'  NAZEV: ',nazev:30,'  DELKA: ',delka div 60,':',delka mod 60);
end;

{**********
 TSongsList
 **********}
constructor TSongsList.Init(ityp : TClenTyp);
begin
  inherited Init(30,ityp);
end;


{******
 TAlbum
 ******}
constructor TAlbum.Init(ipk : longint; const inazev, iinterpret : string;
                        idelka, ipocetskladeb : integer;
                        ityp : TClenTyp);
begin
  inherited Init(ityp);
  songs.Init(Static);
  nazev := inazev;
  interpret := iinterpret;
  delka := idelka;
  pocetskladeb := ipocetskladeb;
end;

destructor TAlbum.Done;
begin
  songs.Done;
  inherited Done;
end;

procedure TAlbum.TiskniSe(var f : text);
begin
  writeln(f,'INTERPRET: ',interpret:15,'  ALBUM: ',nazev:15);
  writeln(f,'DELKA: ',delka div 60,':',delka mod 60,'  SKLADEB: ',pocetskladeb);
end;

{vlozeni pisnicky do alba (nazev, delka, poradi na albu)}
procedure TAlbum.VlozSong(const inazev : string; idelka : integer;
                          iporadi : integer);
begin
  songs.VlozObj(new(PSong,Init(inazev,idelka,iporadi,Dynamic)));
end;


{***********
 TAlbumsList
 ***********}
constructor TAlbumsList.Init(ityp : TClenTyp);
begin
  inherited Init(100,ityp);
  lastpk := 0;
end;

{vlozeni noveho alba (nazev, interpret, delka, pocet skladeb)}
function TAlbumsList.VlozAlbum(const inazev, iinterpret : string;
                              idelka, ipocetskladeb : integer) : PAlbum;
var a : PAlbum;
begin
  a := new(PAlbum,Init(lastpk+1,inazev,iinterpret,idelka,ipocetskladeb,Dynamic));
  VlozObj(a);
  VlozAlbum := a;
  inc(lastpk);
end;


{TPtrO}
{constructor TPtrO.Init(ip : pointer; ityp : TClenTyp);
begin
  inherited Init(ityp);
  p := ip;
end;}

{promenne}
var albums : TAlbumsList;
    a : PAlbum;
    stdout : text;


{procedury a funkce}
function cmpSongPodlePoradi(p1, p2 : PSeznamClen) : integer; far;
begin
  if PSong(p1)^.poradi < PSong(p2)^.poradi then
    cmpSongPodlePoradi := -1
  else if PSong(p1)^.poradi > PSong(p2)^.poradi then
    cmpSongPodlePoradi := 1
  else
    cmpSongPodlePoradi := 0;
end;

function cmpSongPodleDelka(p1, p2 : PSeznamClen) : integer; far;
begin
  if PSong(p1)^.delka < PSong(p2)^.delka then
    cmpSongPodleDelka := -1
  else if PSong(p1)^.delka > PSong(p2)^.delka then
    cmpSongPodleDelka := 1
  else
    cmpSongPodleDelka := 0;
end;

function cmpSongPodleNazev(p1, p2 : PSeznamClen) : integer; far;
begin
  if PSong(p1)^.nazev < PSong(p2)^.nazev then
    cmpSongPodleNazev := -1
  else if PSong(p1)^.nazev > PSong(p2)^.nazev then
    cmpSongPodleNazev := 1
  else
    cmpSongPodleNazev := 0;
end;

function cmpAlbumPodleNazev(p1, p2 : PSeznamClen) : integer; far;
begin
  if PAlbum(p1)^.nazev < PAlbum(p2)^.nazev then
    cmpAlbumPodleNazev := -1
  else if PAlbum(p1)^.nazev > PAlbum(p2)^.nazev then
    cmpAlbumPodleNazev := 1
  else
    cmpAlbumPodleNazev := 0;
end;

procedure UkazSong(p : PSeznamClen; params : pointer); far;
begin
  p^.TiskniSe(stdout);
end;

procedure UkazAlbum(p : PSeznamClen; params : pointer); far;
begin
  p^.TiskniSe(stdout);
  PAlbum(p)^.songs.ProKazdyProved(UkazSong,nil);
end;

procedure SeradSongyPodle(p : PSeznamClen; params : pointer); far;
begin
  PAlbum(p)^.songs.SeradPodle(cmpSongPodlePoradi);
end;


{hlavni blok}
begin
  clrscr;
  assign(stdout,'');
  rewrite(stdout);

  {Inicializace seznamu}
  albums.Init(Static);

  {vlozeni alba}
  a := albums.VlozAlbum('I Say I Say I Say','Erasure',45*60+30, 10);

  {vlozeni skladeb}
  a^.VlozSong('All through the years',3*60+45, 7);
  a^.VlozSong('Run To The Sun',4*60+15,5);
  a^.VlozSong('Always',3*60+15, 6);

  a := albums.VlozAlbum('The Downward spiral','Nine Inch Nails',60*60,5);
  a^.VlozSong('Hurt',4*60,7);
  a^.VlozSong('Closer',4*60+32,5);

  {vypis}
  writeln;
  albums.ProKazdyProved(UkazAlbum,nil);

  {serazeni a vypis}
  writeln;
  albums.SeradPodle(cmpAlbumPodleNazev);
  albums.ProKazdyProved(SeradSongyPodle,nil);

  writeln;
  albums.ProKazdyProved(UkazAlbum,nil);

  albums.Done;
end.