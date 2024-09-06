{ ***************************************************** }
{                                                       }
{  Pascal language binding for the BeaEngine            }
{                                                       }
{  Unit Name: test_block                                }
{     Author: Lsuper 2024.06.01                         }
{    Purpose: tests\test_block.c                        }
{    License: Mozilla Public License 2.0                }
{                                                       }
{  Copyright (c) 1998-2024 Super Studio                 }
{                                                       }
{ ***************************************************** }

program test_block;

{$APPTYPE CONSOLE}

uses
  SysUtils, BeaEngineDelphi;

type
  TPlatform = record
    Archi: Integer;
    Code: PByte;
    Size: Integer;
    Comment: string;
  end;

procedure DisassembleCode(const APlatform: TPlatform; const AVirtualAddr: UInt64);

  function FormatBuffer(ACode: PByte; ASize: Integer): string;
  var
    I: Integer;
    L: string;
    P: PByte;
  begin
    Result := '';
    P := PByte(ACode);
    for I := 0 to ASize - 1 do
    begin
      L := '0x' + LowerCase(IntToHex(P[I], 2)) + ' ';
      Result := Result + L;
    end;
  end;
var
  aDisasm: TDisasm;
  nLen: Integer;
  pData, pEnd: PByte;
  S: string;
begin
  WriteLn('Platform: ', APlatform.Comment);
  WriteLn('Archi: ', APlatform.Archi);
  S := FormatBuffer(APlatform.Code, APlatform.Size);
  WriteLn('Code: ', LowerCase(S));
  WriteLn('Disasm:');

  FillChar(aDisasm, SizeOf(aDisasm), 0);
  aDisasm.Archi := APlatform.Archi;
  aDisasm.EIP := UIntPtr(APlatform.Code);
  aDisasm.Options := NoTabulation + MasmSyntax;
  aDisasm.VirtualAddr := AVirtualAddr;

  pData := APlatform.Code;
  pEnd := APlatform.Code + APlatform.Size;

  while aDisasm.Error = 0 do
  begin
    aDisasm.SecurityBlock := UInt32(pEnd - PByte(aDisasm.EIP));
    if aDisasm.SecurityBlock <= 0 then
      Break;
    nLen := Disasm(aDisasm);
    case aDisasm.Error of
      OUT_OF_BLOCK:
        WriteLn('disasm engine is not allowed to read more memory');
      UNKNOWN_OPCODE:
        begin
          S := BufferToHex(pData, 1);
          S := Format('%.8x %-16s %s', [aDisasm.EIP, S, aDisasm.CompleteInstr]);
          Writeln(S);
          aDisasm.EIP := aDisasm.EIP + 1;
          aDisasm.Error := 0;
          Inc(pData, 1);
        end;
    else
      begin
        S := BufferToHex(pData, nLen);
        S := Format('%.8x %-16s %s', [aDisasm.EIP, S, aDisasm.CompleteInstr]);
        Writeln(S);
        aDisasm.EIP := aDisasm.EIP + nLen;
        Inc(pData, nLen);
      end;
    end;
  end;

  WriteLn('');
end;

procedure Test;
const
  X86_CODE16: array[0..61] of Byte = (
    $8D, $4C, $32, $08, $01, $D8, $81, $C6, $34, $12, $00, $00, $05, $23, $01, $00,
    $00, $36, $8B, $84, $91, $23, $01, $00, $00, $41, $8D, $84, $39, $89, $67, $00,
    $00, $8D, $87, $89, $67, $00, $00, $B4, $C6, $66, $E9, $B8, $00, $00, $00, $67,
    $FF, $A0, $23, $01, $00, $00, $66, $E8, $CB, $00, $00, $00, $74, $FC
  );
  X86_CODE32: array[0..58] of Byte = (
    $8D, $4C, $32, $08, $01, $D8, $81, $C6, $34, $12, $00, $00, $05, $23, $01, $00,
    $00, $36, $8B, $84, $91, $23, $01, $00, $00, $41, $8D, $84, $39, $89, $67, $00,
    $00, $8D, $87, $89, $67, $00, $00, $B4, $C6, $E9, $EA, $BE, $AD, $DE, $FF, $A0,
    $23, $01, $00, $00, $E8, $DF, $BE, $AD, $DE, $74, $FF
  );
  X86_CODE64: array[0..25] of Byte = (
    $55, $48, $8B, $05, $B8, $13, $00, $00, $E9, $EA, $BE, $AD, $DE, $FF, $25, $23,
    $01, $00, $00, $E8, $DF, $BE, $AD, $DE, $74, $FF
  );
const
  Platforms: array[0..3] of TPlatform = (
    (Archi: ARCHI_X16; Code: @X86_CODE16; Size: SizeOf(X86_CODE16); Comment: 'X86 16bit (Intel syntax)'),
    (Archi: ARCHI_X32; Code: @X86_CODE32; Size: SizeOf(X86_CODE32); Comment: 'X86 32 (AT&T syntax)'),
    (Archi: ARCHI_X64; Code: @X86_CODE32; Size: SizeOf(X86_CODE32); Comment: 'X86 32 (Intel syntax)'),
    (Archi: ARCHI_X64; Code: @X86_CODE64; Size: SizeOf(X86_CODE64); Comment: 'X86 64 (Intel syntax)')
  );
var
  P: TPlatform;
begin
  for P in Platforms do
  begin
    DisassembleCode(P, $1000);
  end;
end;

begin
  try
    Test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
