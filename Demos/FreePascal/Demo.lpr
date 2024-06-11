program Demo;

{$mode objfpc}{$H+}

uses
  SysUtils, BeaEngine;

procedure DisAsmFunctionCode(const AFunc: Pointer);
var
  aDisasm: TDisasm;
  nLen: LongWord;
  pData: PByte;
  B, S: string;
begin
  FillChar(aDisasm, SizeOf(aDisasm), 0);
{$IFDEF CPUX64}
  aDisasm.Archi := ARCHI_X64;
{$ELSE}
  aDisasm.Archi := ARCHI_X32;
{$ENDIF}
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
  try
    WriteLn(Format('BeaEngine: %s, DisAsm ExpandFileNameCase ...', [BeaEngineVersionInfo]));
    WriteLn('');
    DisAsmFunctionCode(@SysUtils.ExpandFileNameCase);
    WriteLn('');
    WriteLn('Done.');
  except
    on E: Exception do
      WriteLn(Format('Error Decompiler: %s', [E.Message]));
  end;
  ReadLn;
end.
