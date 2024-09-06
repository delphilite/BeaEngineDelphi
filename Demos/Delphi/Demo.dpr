{ ***************************************************** }
{                                                       }
{  Pascal language binding for the BeaEngine            }
{                                                       }
{  Unit Name: Demo                                      }
{     Author: Lsuper 2024.06.01                         }
{    Purpose: Demo                                      }
{    License: Mozilla Public License 2.0                }
{                                                       }
{  Copyright (c) 1998-2024 Super Studio                 }
{                                                       }
{ ***************************************************** }

program Demo;

{$IF CompilerVersion >= 21.0}
  {$WEAKLINKRTTI ON}
  {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils, BeaEngineDelphi;

const
  DelphiExpandFileNameCaseCode32: array[0..562] of Byte = (
    $55, $8B, $EC, $81, $C4, $6C, $FD, $FF, $FF, $53, $56, $57, $33, $DB, $89, $9D,
    $6C, $FD, $FF, $FF, $89, $9D, $70, $FD, $FF, $FF, $89, $9D, $74, $FD, $FF, $FF,
    $89, $9D, $78, $FD, $FF, $FF, $89, $9D, $7C, $FD, $FF, $FF, $89, $9D, $84, $FD,
    $FF, $FF, $89, $9D, $80, $FD, $FF, $FF, $89, $5D, $FC, $89, $5D, $F8, $8B, $D9,
    $8B, $F2, $8B, $F8, $8D, $85, $88, $FD, $FF, $FF, $8B, $15, $84, $3B, $82, $00,
    $E8, $6F, $10, $FF, $FF, $33, $C0, $55, $68, $45, $70, $82, $00, $64, $FF, $30,
    $64, $89, $20, $8B, $D3, $8B, $C7, $E8, $10, $FF, $FF, $FF, $C6, $06, $00, $85,
    $FF, $0F, $84, $70, $01, $00, $00, $8D, $55, $FC, $8B, $03, $E8, $A7, $FD, $FF,
    $FF, $8D, $55, $F8, $8B, $03, $E8, $95, $FE, $FF, $FF, $8D, $95, $80, $FD, $FF,
    $FF, $8B, $45, $FC, $E8, $57, $FE, $FF, $FF, $8B, $85, $80, $FD, $FF, $FF, $8D,
    $95, $84, $FD, $FF, $FF, $E8, $8E, $3F, $00, $00, $8B, $95, $84, $FD, $FF, $FF,
    $8B, $45, $FC, $E8, $E4, $43, $00, $00, $84, $C0, $0F, $85, $94, $00, $00, $00,
    $8D, $95, $7C, $FD, $FF, $FF, $8B, $45, $FC, $E8, $AE, $3F, $00, $00, $8B, $85,
    $7C, $FD, $FF, $FF, $8D, $8D, $88, $FD, $FF, $FF, $BA, $FF, $01, $00, $00, $E8,
    $D8, $FC, $FF, $FF, $8B, $F8, $8D, $85, $88, $FD, $FF, $FF, $E8, $1B, $FD, $FF,
    $FF, $85, $FF, $74, $5F, $8D, $95, $78, $FD, $FF, $FF, $8B, $45, $FC, $E8, $79,
    $3F, $00, $00, $8B, $95, $78, $FD, $FF, $FF, $8D, $45, $FC, $E8, $0F, $07, $FF,
    $FF, $8D, $8D, $74, $FD, $FF, $FF, $8B, $D6, $8B, $45, $FC, $E8, $DF, $FE, $FF,
    $FF, $8B, $95, $74, $FD, $FF, $FF, $8D, $45, $FC, $E8, $F1, $06, $FF, $FF, $80,
    $3E, $00, $0F, $84, $AF, $00, $00, $00, $8D, $95, $70, $FD, $FF, $FF, $8B, $45,
    $FC, $E8, $F2, $3E, $00, $00, $8B, $95, $70, $FD, $FF, $FF, $8D, $45, $FC, $E8,
    $CC, $06, $FF, $FF, $33, $C0, $55, $68, $00, $70, $82, $00, $64, $FF, $30, $64,
    $89, $20, $8D, $85, $6C, $FD, $FF, $FF, $8B, $4D, $F8, $8B, $55, $FC, $E8, $71,
    $0B, $FF, $FF, $8B, $85, $6C, $FD, $FF, $FF, $8D, $8D, $88, $FD, $FF, $FF, $BA,
    $FF, $01, $00, $00, $E8, $33, $FC, $FF, $FF, $85, $C0, $75, $38, $0F, $B6, $06,
    $04, $FE, $2C, $02, $72, $18, $8B, $45, $F8, $8B, $95, $9C, $FD, $FF, $FF, $E8,
    $78, $0C, $FF, $FF, $75, $05, $C6, $06, $01, $EB, $03, $C6, $06, $02, $8B, $C3,
    $8B, $8D, $9C, $FD, $FF, $FF, $8B, $55, $FC, $E8, $26, $0B, $FF, $FF, $E8, $0D,
    $FC, $FE, $FF, $EB, $22, $33, $C0, $5A, $59, $59, $64, $89, $10, $68, $07, $70,
    $82, $00, $8D, $85, $88, $FD, $FF, $FF, $E8, $2F, $FC, $FF, $FF, $58, $FF, $E0,
    $E9, $17, $FA, $FE, $FF, $EB, $EB, $33, $C0, $5A, $59, $59, $64, $89, $10, $68,
    $4C, $70, $82, $00, $8D, $85, $6C, $FD, $FF, $FF, $BA, $07, $00, $00, $00, $E8,
    $6C, $03, $FF, $FF, $8D, $85, $88, $FD, $FF, $FF, $8B, $15, $84, $3B, $82, $00,
    $E8, $93, $12, $FF, $FF, $8D, $45, $F8, $BA, $02, $00, $00, $00, $E8, $4E, $03,
    $FF, $FF, $58, $FF, $E0, $E9, $D2, $F9, $FE, $FF, $EB, $C8, $5F, $5E, $5B, $8B,
    $E5, $5D, $C3
  );
  DelphiExpandFileNameCaseCode64: array[0..654] of Byte = (
    $55, $48, $81, $EC, $00, $03, $00, $00, $48, $8B, $EC, $48, $C7, $45, $20, $00,
    $00, $00, $00, $48, $C7, $45, $28, $00, $00, $00, $00, $48, $C7, $45, $30, $00,
    $00, $00, $00, $48, $C7, $45, $38, $00, $00, $00, $00, $48, $C7, $45, $40, $00,
    $00, $00, $00, $48, $C7, $45, $50, $00, $00, $00, $00, $48, $C7, $45, $48, $00,
    $00, $00, $00, $48, $C7, $45, $78, $00, $00, $00, $00, $48, $C7, $45, $70, $00,
    $00, $00, $00, $48, $89, $6D, $58, $48, $89, $8D, $10, $03, $00, $00, $48, $89,
    $95, $18, $03, $00, $00, $4C, $89, $85, $20, $03, $00, $00, $48, $8D, $8D, $80,
    $00, $00, $00, $48, $8B, $15, $F6, $B1, $FF, $FF, $E8, $91, $C1, $FE, $FF, $90,
    $48, $8B, $8D, $10, $03, $00, $00, $48, $8B, $95, $18, $03, $00, $00, $E8, $BD,
    $FE, $FF, $FF, $48, $8B, $85, $20, $03, $00, $00, $C6, $00, $00, $48, $83, $BD,
    $18, $03, $00, $00, $00, $0F, $84, $A5, $01, $00, $00, $48, $8D, $4D, $78, $48,
    $8B, $85, $10, $03, $00, $00, $48, $8B, $10, $E8, $C2, $FC, $FF, $FF, $48, $8D,
    $4D, $70, $48, $8B, $85, $10, $03, $00, $00, $48, $8B, $10, $E8, $FF, $FD, $FF,
    $FF, $48, $8D, $4D, $48, $48, $8B, $55, $78, $E8, $B2, $FD, $FF, $FF, $48, $8D,
    $4D, $50, $48, $8B, $55, $48, $E8, $65, $67, $00, $00, $48, $8B, $4D, $78, $48,
    $8B, $55, $50, $E8, $08, $6D, $00, $00, $84, $C0, $0F, $85, $9C, $00, $00, $00,
    $48, $8D, $4D, $40, $48, $8B, $55, $78, $E8, $A3, $67, $00, $00, $48, $8B, $4D,
    $40, $BA, $FF, $01, $00, $00, $4C, $8D, $85, $80, $00, $00, $00, $E8, $CE, $FB,
    $FF, $FF, $89, $45, $6C, $48, $8D, $8D, $80, $00, $00, $00, $E8, $1F, $FC, $FF,
    $FF, $83, $7D, $6C, $00, $74, $65, $48, $8D, $4D, $38, $48, $8B, $55, $78, $E8,
    $6C, $67, $00, $00, $48, $8D, $4D, $78, $48, $8B, $55, $38, $E8, $8F, $B2, $FE,
    $FF, $48, $8D, $4D, $30, $48, $8B, $55, $78, $4C, $8B, $85, $20, $03, $00, $00,
    $E8, $9B, $FE, $FF, $FF, $48, $8D, $4D, $78, $48, $8B, $55, $30, $E8, $6E, $B2,
    $FE, $FF, $48, $8B, $85, $20, $03, $00, $00, $80, $38, $00, $0F, $84, $CE, $00,
    $00, $00, $48, $8D, $4D, $28, $48, $8B, $55, $78, $E8, $C1, $66, $00, $00, $48,
    $8D, $4D, $78, $48, $8B, $55, $28, $E8, $44, $B2, $FE, $FF, $90, $48, $8D, $4D,
    $20, $48, $8B, $55, $78, $4C, $8B, $45, $70, $E8, $82, $BB, $FE, $FF, $48, $8B,
    $4D, $20, $BA, $FF, $01, $00, $00, $4C, $8D, $85, $80, $00, $00, $00, $E8, $2D,
    $FB, $FF, $FF, $85, $C0, $75, $6C, $48, $8B, $85, $20, $03, $00, $00, $48, $0F,
    $B6, $08, $80, $F9, $07, $77, $13, $B0, $01, $D3, $E0, $48, $0F, $B6, $0D, $11,
    $01, $00, $00, $84, $C8, $0F, $95, $C0, $EB, $02, $33, $C0, $84, $C0, $75, $2A,
    $48, $8B, $4D, $70, $48, $8B, $95, $98, $00, $00, $00, $E8, $A0, $BC, $FE, $FF,
    $85, $C0, $75, $0C, $48, $8B, $85, $20, $03, $00, $00, $C6, $00, $01, $EB, $0A,
    $48, $8B, $85, $20, $03, $00, $00, $C6, $00, $02, $48, $8B, $8D, $10, $03, $00,
    $00, $48, $8B, $55, $78, $4C, $8B, $85, $98, $00, $00, $00, $E8, $FF, $BA, $FE,
    $FF, $EB, $0F, $90, $48, $8D, $8D, $80, $00, $00, $00, $E8, $10, $FB, $FF, $FF,
    $EB, $0D, $33, $C9, $48, $8B, $55, $58, $E8, $43, $00, $00, $00, $EB, $01, $90,
    $48, $8D, $4D, $20, $BA, $07, $00, $00, $00, $E8, $12, $AD, $FE, $FF, $48, $8D,
    $4D, $70, $BA, $02, $00, $00, $00, $E8, $04, $AD, $FE, $FF, $48, $8D, $8D, $80,
    $00, $00, $00, $48, $8B, $15, $F6, $AF, $FF, $FF, $E8, $A1, $C5, $FE, $FF, $48,
    $8B, $85, $10, $03, $00, $00, $48, $8D, $A5, $00, $03, $00, $00, $5D, $C3
  );

procedure DisAsmFunctionCode(const AFunc: Pointer; Archi: Integer);
var
  aDisasm: TDisasm;
  nLen: LongWord;
  pData: PByte;
  B, S: string;
begin
  FillChar(aDisasm, SizeOf(aDisasm), 0);
  aDisasm.Archi := Archi;
  aDisasm.EIP := UIntPtr(AFunc);
  aDisasm.Options := NoTabulation + MasmSyntax;
  pData := PByte(AFunc);
  repeat
    nLen := Disasm(aDisasm);
    B := BufferToHex(pData, nLen);
    S := Format('%.8x %-16s %s', [aDisasm.EIP, B, aDisasm.CompleteInstr]);
    Writeln(S);
    aDisasm.EIP := aDisasm.EIP + nLen;
    Inc(pData, nLen);
  until (aDisasm.Instruction.Opcode = OPCODE_RET) or (nLen <= 0);
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    WriteLn('BeaEngine: ', BeaEngineVersionInfo);
    WriteLn('');
    WriteLn('DisAsm ExpandFileNameCase32:', sLineBreak);
    DisAsmFunctionCode(@DelphiExpandFileNameCaseCode32, ARCHI_X32);
    WriteLn('');
    WriteLn('DisAsm ExpandFileNameCase64:', sLineBreak);
    DisAsmFunctionCode(@DelphiExpandFileNameCaseCode64, ARCHI_X64);
    WriteLn('');
    WriteLn('Done.');
  except
    on E: Exception do
      WriteLn('Error Decompiler: ', E.Message);
  end;
  ReadLn;
end.
