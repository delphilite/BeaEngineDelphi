# BeaEngineDelphi
![Version](https://img.shields.io/badge/version-v5.3.0-yellow.svg)
![License](https://img.shields.io/github/license/delphilite/BeaEngineDelphi)
![Lang](https://img.shields.io/github/languages/top/delphilite/BeaEngineDelphi.svg)
![stars](https://img.shields.io/github/stars/delphilite/BeaEngineDelphi.svg)

BeaEngineDelphi is a [Delphi](http://www.embarcadero.com/products/delphi) and [Free Pascal](https://www.freepascal.org/) binding for the [BeaEngine](https://github.com/BeaEngine/beaengine/). It supports BeaEngine and provides a friendly and simple type-safe API that is ridiculously easy to learn and quick to pick up.

BeaEngine is a C library designed to decode instructions from 16 bits, 32 bits and 64 bits intel architectures. It includes standard instructions set and instructions set from FPU, MMX, SSE, SSE2, SSE3, SSSE3, SSE4.1, SSE4.2, VMX, CLMUL, AES, MPX, AVX, AVX2, AVX512 (VEX & EVEX prefixes), CET, BMI1, BMI2, SGX, UINTR, KL, TDX and AMX extensions. If you want to analyze malicious codes and more generally obfuscated codes, BeaEngine sends back a complex structure that describes precisely the analyzed instructions.

## Features
* **Supports** BeaEngine 5, x16 bits, x32 bits and x64 bits intel architectures.
* **Supports** Delphi XE2 and greater, and FPC 3 and greater.
* **Supports** Static libraries: i386-win32, x86_64-win64, i386-linux, x86_64-linux, arm-linux, aarch64-linux, x86_64-darwin, aarch64-darwin, arm-android, aarch64-android, loongarch64-linux.
* **Supports** Dynamic libraries: i386-win32, x86_64-win64, x86_64-darwin, aarch64-darwin.

## Installation: Manual
To install the BeaEngineDelphi binding, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/delphilite/BeaEngineDelphi.git
    ```

2. Add the BeaEngineDelphi\Source directory to the project or IDE's search path.

## Installation: Delphinus-Support
BeaEngineDelphi should now be listed in [Delphinus package manager](https://github.com/Memnarch/Delphinus/wiki/Installing-Delphinus).

Be sure to restart Delphi after installing via Delphinus otherwise the units may not be found in your test projects.

## Usage
Included is the wrapper record `TDisasm` in `BeaEngineDelphi.pas`. The example bellow is incomplete, but it may give you an impression how to use it.

```pas
uses
  SysUtils, BeaEngineDelphi;

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
  aDisasm.Archi := ARCHI_X64;
{$ELSE}
  aDisasm.Archi := ARCHI_X32;
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
  until (aDisasm.Instruction.Opcode = OPCODE_RET) or (nLen <= 0);
end;

begin
  try
    WriteLn('BeaEngine: ', BeaEngineVersionInfo, ', DisAsm ExpandFileNameCase ...');
    WriteLn('');
    DisAsmFunctionCode(@SysUtils.ExpandFileNameCase);
    WriteLn('');
    WriteLn('Done.');
  except
    on E: Exception do
      WriteLn('Error Decompiler: ', E.Message);
  end;
  ReadLn;
end.
```

For more examples based on low-level API, refer to the test cases under the demos directory.

## Documentation
For more detailed information, refer to the [BeaEngine documentation](https://github.com/BeaEngine/beaengine/blob/master/doc/beaengine.md).

## Contributing
Contributions are welcome! Please fork this repository and submit pull requests with your improvements.

## License
This project is licensed under the Mozilla Public License 2.0. See the [LICENSE](LICENSE) file for details.

## Acknowledgements
Special thanks to the BeaEngine development team for creating and maintaining the BeaEngine.
