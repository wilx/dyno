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

unit Konsts;
{vseobecne konstatny vseho druhu}

interface

const
      {rozsah ID konstant volnych pro unitu Seznam je 0 - 5}
      SeznamClenID = 0;
      SeznamID = 1;
      {rozsah ID konstant volnych pro unitu GraphO je 6 - 20}
      GraphicObjectID = 6;
      {BodID = 7;}
      ElipsaID = 8;
      ElipsaPlnaID = 9;
      TextID = 10;
      ObdelnikID = 11;
      ObdelnikPlnyID = 12;
      {rozsah ID konstant volnych pro unitu Controls je 21 - 35}
      OvladaciPrvekID = 21;
      PrikazoveTlacitkoID = 22;
      MenuPrvekID = 23;
      MenuID = 24;
      {rozsah ID konstant volnych pro unitu Vyrez je 36 - 40}
      VyrezID = 36;
      ViewPortID = 37;
      {rozsah ID konstant volnych pro unitu EProcs je 41 - 45}
      ExitProcOID = 41;
      {rozsah ID konstant volnych pro unitu Zasobnik je 46 - 50}
      ZasobnikID = 46;
      {rozsah ID konstant volnych pro unitu seznam je 51 - 55}
      {ID konstaty nejsou implementovany, nemuze byt zarazen do seznamu, rezerva pro budoucnost}
      {rozsah ID konstant volnych pro unitu AppO je 56 - 60}
      AplikaceID = 56;
      {rozsah ID konstant volnych pro unitu Fronta je 61 - 65}
      FrontaID = 61;
      {rozsah ID konstant volnych pro unitu Datum je 66 - 70}
      DatumID = 62;
      {DatumRozpetiID = 63;}
(*
      {rozsah ID konstant volnych pro unit SerSez je 71 - 75}
      SerazenySeznamID = 71;
      {rozsah ID konstant volnych pro unit SerSezCl je 76 - 80}
      SerazenySeznamClenID = 76;
      {prvni ID konstanta, kterou muze pouzit uzivatel}
*)
      UserID = 100;
      {konstanty jsou pouzity take jako nastroje,
       nasleduji nestandardni nastroje}

      {konstanty druhu zprav pouzivanych v metodach PosliZpravu a VezmiZpravu}
      zpKeyDown =      0;
      zpMouse =        6; {obecne jaka koliv zprava od misi}
      zpMouseMove =    1;
      zpLBDown =       2;
      zpLBUp =         3;
      zpRBDown =       4;
      zpRBUp =         5;
      zpMouseAuto =    7;
      zpLBClick =      8;
      zpRBClick =      9;
      zpReset =       -1;
      zpNothing =     -2;
      zpUser =        20; {prvni cislo zpravy, ktere muze pouzit uzivatle}

implementation

end.