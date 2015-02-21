// ====================================================================
//
//  Delphi Static lib for BeaEngine 4.x
//
//  upDate: 2010-Jan-9
//  v0.4 support Delphi7 - Delphi2010
//  upDate: 2015-Feb-14
//  v0.4.1 support Delphi7 - DelphiXE2, x86+x64
// ====================================================================
//  BeaEngine.pas convert by Vince
//	updated by kao
//	updated 0.4.1 by lsuper
// ====================================================================
// [+] BranchTaken,BranchNotTaken added in TPREFIXINFO v3.1.0
// ====================================================================
// Default link type is static lib
// comment below line to switch link with DLL
// ====================================================================
// {$DEFINE USEDLL}
// ====================================================================
// Copyright 2006-2009, BeatriX
// File coded by BeatriX
//
// This file is part of BeaEngine.
//
//    BeaEngine is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Lesser General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    BeaEngine is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser General Public License for more details.
//
//    You should have received a copy of the GNU Lesser General Public License
//    along with BeaEngine.  If not, see <http://www.gnu.org/licenses/>.
//
// ====================================================================

unit BeaEngine;

{.$DEFINE USEDLL}

{$IFDEF FPC}
  {$DEFINE USEDLL}
{$ENDIF}

interface

const
  INSTRUCT_LENGTH       = 64;

type
{$IFNDEF FPC}{$IF CompilerVersion < 23}
  PtrUInt = LongWord;
{$ELSE}
  PtrUInt = NativeUInt;
{$IFEND}{$ENDIF}

  TREX_Struct = packed record
    W_: Byte;
    R_: Byte;
    X_: Byte;
    B_: Byte;
    state: Byte;
  end;

  TPREFIXINFO = packed record
    Number: LongInt;
    NbUndefined: LongInt;
    LockPrefix: Byte;
    OperandSize: Byte;
    AddressSize: Byte;
    RepnePrefix: Byte;
    RepPrefix: Byte;
    FSPrefix: Byte;
    SSPrefix: Byte;
    GSPrefix: Byte;
    ESPrefix: Byte;
    CSPrefix: Byte;
    DSPrefix: Byte;
    BranchTaken: Byte;    //v3.1.0 added 2009-11-05
    BranchNotTaken: Byte; //v3.1.0 added 2009-11-05
    REX: TREX_Struct;
    Alignment: array[0..1] of AnsiChar; //v4.1 rev 175 added 2015-02-14
  end;

  TEFLStruct = packed record
    OF_: Byte;
    SF_: Byte;
    ZF_: Byte;
    AF_: Byte;
    PF_: Byte;
    CF_: Byte;
    TF_: Byte;
    IF_: Byte;
    DF_: Byte;
    NT_: Byte;
    RF_: Byte;
    alignment: Byte;
  end;

  TMEMORYTYPE = packed record
    BaseRegister: LongInt;
    IndexRegister: LongInt;
    Scale: LongInt;
    Displacement: Int64;
  end;

  TINSTRTYPE = packed record
    Category: LongInt;
    Opcode: LongInt;
    Mnemonic: array[0..15] of AnsiChar;
    BranchType: LongInt;
    Flags: TEFLStruct;
    AddrValue: Int64;
    Immediat: Int64;
    ImplicitModifiedRegs: LongInt;
  end;

  TARGTYPE = packed record
    ArgMnemonic: array[0..63] of AnsiChar;  //v4.1 rev 175 modify 2015-02-14
    ArgType: LongInt;
    ArgSize: LongInt;
    ArgPosition: LongInt;
    AccessMode: LongInt;
    Memory: TMEMORYTYPE;
    SegmentReg: LongInt;
  end;

  TDISASM = packed record
    EIP: PtrUInt;
    VirtualAddr: Int64;
    SecurityBlock: LongInt;
    CompleteInstr: array[0..(INSTRUCT_LENGTH) - 1] of AnsiChar;
    Archi: LongInt;
    Options: Int64;
    Instruction: TINSTRTYPE;
    Argument1: TARGTYPE;
    Argument2: TARGTYPE;
    Argument3: TARGTYPE;
    Prefix: TPREFIXINFO;
    Reserved_: array[0..39] of LongInt;
  end;
  PDISASM = ^TDISASM;
  LPDISASM = ^TDISASM;

const
  ESReg                 = 1;
  DSReg                 = 2;
  FSReg                 = 3;
  GSReg                 = 4;
  CSReg                 = 5;
  SSReg                 = 6;
  InvalidPrefix         = 4;
  SuperfluousPrefix     = 2;
  NotUsedPrefix         = 0;
  MandatoryPrefix       = 8;
  InUsePrefix           = 1;

type
  INSTRUCTION_TYPE = LongInt;
const
  GENERAL_PURPOSE_INSTRUCTION = $10000;
  FPU_INSTRUCTION       = $20000;
  MMX_INSTRUCTION       = $40000;
  SSE_INSTRUCTION       = $80000;
  SSE2_INSTRUCTION      = $100000;
  SSE3_INSTRUCTION      = $200000;
  SSSE3_INSTRUCTION     = $400000;
  SSE41_INSTRUCTION     = $800000;
  SSE42_INSTRUCTION     = $1000000;
  SYSTEM_INSTRUCTION    = $2000000;
  VM_INSTRUCTION        = $4000000;
  UNDOCUMENTED_INSTRUCTION = $8000000;
  AMD_INSTRUCTION       = $10000000;
  ILLEGAL_INSTRUCTION   = $20000000;
  AES_INSTRUCTION       = $40000000;
  CLMUL_INSTRUCTION     = $80000000;

  DATA_TRANSFER         = $1;
  ARITHMETIC_INSTRUCTION = 2;
  LOGICAL_INSTRUCTION   = 3;
  SHIFT_ROTATE          = 4;
  BIT_BYTE              = 5;
  CONTROL_TRANSFER      = 6;
  STRING_INSTRUCTION    = 7;
  InOutINSTRUCTION      = 8;
  ENTER_LEAVE_INSTRUCTION = 9;
  FLAG_CONTROL_INSTRUCTION = 10;
  SEGMENT_REGISTER      = 11;
  MISCELLANEOUS_INSTRUCTION = 12;
  COMPARISON_INSTRUCTION = 13;
  LOGARITHMIC_INSTRUCTION = 14;
  TRIGONOMETRIC_INSTRUCTION = 15;
  UNSUPPORTED_INSTRUCTION = 16;
  LOAD_CONSTANTS        = 17;
  FPUCONTROL            = 18;
  STATE_MANAGEMENT      = 19;
  CONVERSION_INSTRUCTION = 20;
  SHUFFLE_UNPACK        = 21;
  PACKED_SINGLE_PRECISION = 22;
  SIMD128bits           = 23;
  SIMD64bits            = 24;
  CACHEABILITY_CONTROL  = 25;
  FP_INTEGER_CONVERSION = 26;
  SPECIALIZED_128bits   = 27;
  SIMD_FP_PACKED        = 28;
  SIMD_FP_HORIZONTAL    = 29;
  AGENT_SYNCHRONISATION = 30;
  PACKED_ALIGN_RIGHT    = 31;
  PACKED_SIGN           = 32;
  PACKED_BLENDING_INSTRUCTION = 33;
  PACKED_TEST           = 34;
  PACKED_MINMAX         = 35;
  HORIZONTAL_SEARCH     = 36;
  PACKED_EQUALITY       = 37;
  STREAMING_LOAD        = 38;
  INSERTION_EXTRACTION  = 39;
  DOT_PRODUCT           = 40;
  SAD_INSTRUCTION       = 41;
  ACCELERATOR_INSTRUCTION = 42; //   crc32, popcnt (sse4.2)
  ROUND_INSTRUCTION     = 43;

type
  EFLAGS_STATES = LongInt;
const
  TE_                   = 1;
  MO_                   = 2;
  RE_                   = 4;
  SE_                   = 8;
  UN_                   = $10;
  PR_                   = $20;

type
  BRANCH_TYPE = LongInt;
const
  JO                    = 1;
  JC                    = 2;
  JE                    = 3;
  JA                    = 4;
  JS                    = 5;
  JP                    = 6;
  JL                    = 7;
  JG                    = 8;
  JB                    = 2;
  JECXZ                 = 10;
  JmpType               = 11;
  CallType              = 12;
  RetType               = 13;
  JNO                   = -(1);
  JNC                   = -(2);
  JNE                   = -(3);
  JNA                   = -(4);
  JNS                   = -(5);
  JNP                   = -(6);
  JNL                   = -(7);
  JNG                   = -(8);
  JNB                   = -(2);

type
  ARGUMENTS_TYPE = LongInt;
const
  NO_ARGUMENT           = $10000000;
  REGISTER_TYPE         = $20000000;
  MEMORY_TYPE           = $40000000;
  CONSTANT_TYPE         = $80000000;

  MMX_REG               = $10000;
  GENERAL_REG           = $20000;
  FPU_REG               = $40000;
  SSE_REG               = $80000;
  CR_REG                = $100000;
  DR_REG                = $200000;
  SPECIAL_REG           = $400000;
  MEMORY_MANAGEMENT_REG = $800000;
  SEGMENT_REG           = $1000000;

  RELATIVE_             = $4000000;
  ABSOLUTE_             = $8000000;

  Read                  = $1;
  Write                 = $2;

  REG0                  = $1;
  REG1                  = $2;
  REG2                  = $4;
  REG3                  = $8;
  REG4                  = $10;
  REG5                  = $20;
  REG6                  = $40;
  REG7                  = $80;
  REG8                  = $100;
  REG9                  = $200;
  REG10                 = $400;
  REG11                 = $800;
  REG12                 = $1000;
  REG13                 = $2000;
  REG14                 = $4000;
  REG15                 = $8000;

type
  SPECIAL_INFO = LongInt;
const
  UNKNOWN_OPCODE        = -(1);
  OUT_OF_BLOCK          = 0;
  { === mask = 0xff }
  NoTabulation          = $00000000;
  Tabulation            = $00000001;
  { === mask = 0xff00 }
  MasmSyntax            = $00000000;
  GoAsmSyntax           = $00000100;
  NasmSyntax            = $00000200;
  ATSyntax              = $00000400;
  { === mask = 0xff0000 }
  PrefixedNumeral       = $00010000;
  SuffixedNumeral       = $00000000;
  { === mask = 0xff000000 }
  ShowSegmentRegs       = $01000000;
  LowPosition           = 0;
  HighPosition          = 1;

function Disasm(var aDisAsm: TDISASM): LongInt; stdcall;

function BeaEngineVersion: PAnsiChar; stdcall;
function BeaEngineRevision: PAnsiChar; stdcall;

implementation

{$IFDEF USEDLL}

const
{$IFDEF CPUX64}
  BeaEngineLib = 'BeaEngine64.dll';
{$ELSE}
  BeaEngineLib = 'BeaEngine.dll';
{$ENDIF}

{$IFDEF CPUX64}
function Disasm(var aDisAsm: TDISASM): LongInt; stdcall; external BeaEngineLib Name 'Disasm';
function BeaEngineVersion: PAnsiChar; stdcall; external BeaEngineLib Name 'BeaEngineVersion';
function BeaEngineRevision: PAnsiChar; stdcall; external BeaEngineLib Name 'BeaEngineRevision';
{$ELSE}
function Disasm(var aDisAsm: TDISASM): LongInt; stdcall; external BeaEngineLib Name '_Disasm@4';
function BeaEngineVersion: PAnsiChar; stdcall; external BeaEngineLib Name '_BeaEngineVersion@0';
function BeaEngineRevision: PAnsiChar; stdcall; external BeaEngineLib Name '_BeaEngineRevision@0';
{$ENDIF}

{$ELSE}

{$WARN BAD_GLOBAL_SYMBOL OFF}

{$IFDEF CPUX64}
  {$L 'Win64\BeaEngine.obj'}
{$ELSE}
  {$L 'Win32\BeaEngine.obj'}
{$ENDIF}

const
{$IFDEF MACOS}
  libc        = '/usr/lib/libc.dylib';
  _PU         = '_';
{$ELSE}
  libc        = 'msvcrt.dll';
  _PU         = '';
{$ENDIF}

function memset(dest: Pointer; val: Integer; count: PtrUInt): Pointer; cdecl;
  external libc name _PU + 'memset';
function sprintf(buf: Pointer; format: PAnsiChar {args}): Integer; cdecl; varargs;
  external libc name _PU + 'sprintf';
function strcmp(s1: PAnsiChar; s2: PAnsiChar): Integer; cdecl;
  external libc name _PU + 'strcmp';
function strcpy(dest, src: PAnsiChar): PAnsiChar; cdecl;
  external libc name _PU + 'strcpy';
function strlen(s: PAnsiChar): PtrUInt; cdecl;
  external libc name _PU + 'strlen';

function Disasm(var aDisAsm: TDISASM): LongInt; stdcall; external;
function BeaEngineVersion: PAnsiChar; stdcall; external;
function BeaEngineRevision: PAnsiChar; stdcall; external;
{$ENDIF}

end.

