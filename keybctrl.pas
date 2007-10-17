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

unit KeybCtrl;

interface

{konstanty klavesovych kodu vracemych mojema funkcema}
const kAlt_X = $12d;
      kCtrl_F10 = $167;
      kESC = 27;
      kUp = $148;
      kDown = $150;
      kLeft = $14b;
      kRight = $14d;
      kO = word($4f);
      kI = word($49);

function kGetKey : word;
function kGetKey101 : word;
function kGetPressed : word;
function kGetPressed101 : word;
function kGetShifts : byte;
function kGetCtrl : boolean;
function kGetAlt : boolean;
function kGetShift : boolean;
function kClrBuf : byte;
function kClrBuf101 : byte;

implementation

function kGet : byte; assembler;
asm
  xor ax,ax {00h = cteni ascii kodu v AL}
  int 16h
end;

function kGet101 : byte; assembler;
asm
  mov ax,0010h {10h = cteni ascii kodu z rozsirene klavesnice 101/102 v AL}
  int 16h
end;

function kGetKey : word; assembler;
asm
  call [kGet]
  cmp al,0
  je @@kGetKey_rozsireny
  xor ah,ah
  ret
@@kGetKey_rozsireny:
  mov al,ah           {AX = AH + 100h}
  mov ah,1
end;

function kGetKey101 : word; assembler;
asm
  call [kGet101]
  cmp al,0
  je @@kGetKey101_rozsireny
  xor ah,ah
  ret
@@kGetKey101_rozsireny:
  mov al,ah       {AX = AH + 100h}
  mov ah,1
end;

function kGetPressed : word; assembler;
asm
  mov ah,01h
  int 16h
  jz @@kGetPressed_ne
  cmp al,0
  je @@kGetPressed_rozsireny
  xor ah,ah
  ret
@@kGetPressed_rozsireny:
  mov al,ah             {AX = AH + 100h}
  mov ah,1
  ret
@@kGetPressed_ne:
  xor ax,ax             {zadna klavesa, zadny kod}
end;

function kGetPressed101 : word; assembler;
asm
  mov ah,01h
  int 16h
  jz @@kGetPressed101_ne
  cmp al,0
  je @@kGetPressed101_rozsireny
  xor ah,ah
  ret
@@kGetPressed101_rozsireny:
  mov al,ah            {AX = AH + 100h}
  mov ah,1
  ret
@@kGetPressed101_ne:
  xor ax,ax             {zadna klavesa, zadny kod}
end;

function kGetShifts : byte; assembler;
asm
  mov ah,02h
  int 16h               {v AL vraci stav shiftovych klaves}
end;

function kGetCtrl : boolean; assembler;
asm
  call [kGetShifts]
  and al,100b          {Ctrl klavesa}
  jnz @@kGetCtrl_ano
  ret
@@kGetCtrl_ano:
  mov al,1
end;

function kGetAlt : boolean; assembler;
asm
  call [kGetShifts]
  and al,1000b          {Alt klavesa}
  jnz @@kGetAlt_ano
  ret
@@kGetAlt_ano:
  mov al,1
end;

function kGetShift : boolean; assembler;
asm
  call [kGetShifts]
  and al,11b          {LShift nebo RShift klavesa} {}
  jnz @@kGetCtrl_ano
  mov al,0
  ret
@@kGetCtrl_ano:
  mov al,1
end;

function kClrBuf : byte;
var poc : byte;
begin
  poc := 0;
  while kGetPressed <> 0 do begin
    kGetKey;
    inc(poc);
  end;
  kClrBuf := poc;
end;

function kClrBuf101 : byte;
var poc : byte;
begin
  poc := 0;
  while kGetPressed101 <> 0 do begin
    kGetKey101;
    inc(poc);
  end;
  kClrBuf101 := poc;
end;

end.