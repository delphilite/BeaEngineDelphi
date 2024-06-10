program Demo;

{$IF CompilerVersion >= 21.0}
  {$WEAKLINKRTTI ON}
  {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils, BeaEngine;

procedure DisAsmFunctionCode(const AFunc: Pointer);
var
  aDisasm: TDisasm;
  nLen: LongWord;
  pData: PByte;
  B, S: string;
begin
  FillChar(aDisasm, SizeOf(TDISASM), 0);
  aDisasm.EIP := UIntPtr(AFunc);
{$IFDEF CPUX64}
  aDisasm.Archi := 64;
{$ELSE}
  aDisasm.Archi := 0;
{$ENDIF}
  aDisasm.Options := NoTabulation + MasmSyntax;
  pData := PByte(AFunc);
  repeat
    nLen := Disasm(aDisasm);
    B := BufferToHex(pData, nLen);
    S := Format('%.8x %-16s %s', [aDisasm.EIP, B, aDisasm.CompleteInstr]);
    Writeln(S);
    aDisasm.EIP := aDisasm.EIP + nLen;
    Inc(pData, nLen);
  until (aDisasm.Instruction.Opcode = $C3) or (nLen <= 0);
end;

begin
  ReportMemoryLeaksOnShutdown := True;
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
