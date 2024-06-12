{ ***************************************************** }
{                                                       }
{  Pascal language binding for the BeaEngine            }
{                                                       }
{  Unit Name: BeaEngine Api Header                      }
{     Author: Lsuper 2024.06.01                         }
{    Purpose:                                           }
{                                                       }
{  Copyright (c) 1998-2024 Super Studio                 }
{                                                       }
{ ***************************************************** }

{$IFDEF FPC}
  {$MODE DELPHI}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

unit BeaEngineDelphi;

{.$DEFINE BE_STATICLINK}

{$IFDEF BE_STATICLINK}
  {$IFNDEF MSWINDOWS}
    {$MESSAGE ERROR 'staticlink not supported'}
  {$ENDIF}
  {$IFNDEF CPUX64}
    {$DEFINE BE_USE_UNDERSCORE}
  {$ENDIF}
{$ELSE}
  {$DEFINE BE_USE_EXTNAME}
{$ENDIF}

interface

const
  INSTRUCT_LENGTH = 80;

type
  EVEX_Struct = packed record
    P0: UInt8;
    P1: UInt8;
    P2: UInt8;
    mm: UInt8;
    pp: UInt8;
    R: UInt8;
    X: UInt8;
    B: UInt8;
    R1: UInt8;
    vvvv: UInt8;
    V: UInt8;
    aaa: UInt8;
    W: UInt8;
    z: UInt8;
    b_: UInt8;
    LL: UInt8;
    state: UInt8;
    masking: UInt8;
    tupletype: UInt8;
  end;

  VEX_Struct = packed record
    L: UInt8;
    vvvv: UInt8;
    mmmmm: UInt8;
    pp: UInt8;
    state: UInt8;
    opcode: UInt8;
  end;

  REX_Struct = packed record
    W_: UInt8;
    R_: UInt8;
    X_: UInt8;
    B_: UInt8;
    state: UInt8;
  end;

  // This structure gives informations on used prefixes. When can know if some prefixes
  // are used properly or not.
  PREFIXINFO = packed record
    Number: Integer;
    NbUndefined: Integer;
    LockPrefix: UInt8;
    OperandSize: UInt8;
    AddressSize: UInt8;
    RepnePrefix: UInt8;
    RepPrefix: UInt8;
    FSPrefix: UInt8;
    SSPrefix: UInt8;
    GSPrefix: UInt8;
    ESPrefix: UInt8;
    CSPrefix: UInt8;
    DSPrefix: UInt8;
    BranchTaken: UInt8;
    BranchNotTaken: UInt8;
    REX: REX_Struct;
    alignment: array [0..1] of AnsiChar;
  end;

  // This structure gives informations on the register EFLAGS.
  EFLStruct = packed record
    OF_: UInt8;
    SF_: UInt8;
    ZF_: UInt8;
    AF_: UInt8;
    PF_: UInt8;
    CF_: UInt8;
    TF_: UInt8;
    IF_: UInt8;
    DF_: UInt8;
    NT_: UInt8;
    RF_: UInt8;
    alignment: UInt8;
  end;

  // This structure gives informations if infos.Operandxx.OpType == MEMORY_TYPE.
  MEMORYTYPE = packed record
    BaseRegister: Int64;
    IndexRegister: Int64;
    Scale: Int32;
    Displacement: Int64;
  end;

  // This structure gives informations on operands if: infos.Operandxx.OpType ==
  // REGISTER_TYPE or if infos.Instruction.ImplicitModifiedRegs is filled
  REGISTERTYPE = packed record
    type_: Int64;
    gpr: Int64;
    mmx: Int64;
    xmm: Int64;
    ymm: Int64;
    zmm: Int64;
    special: Int64;
    cr: Int64;
    dr: Int64;
    mem_management: Int64;
    mpx: Int64;
    opmask: Int64;
    segment: Int64;
    fpu: Int64;
    tmm: Int64;
  end;

  // This structure gives informations on the analyzed instruction.
  INSTRTYPE = packed record
    // [out] Specify the family instruction . More precisely, (infos.Instruction.Category
    // & 0xFFFF0000) is used to know if the instruction is a standard one or comes
    // from one of the following technologies: MMX, FPU, SSE, SSE2, SSE3, SSSE3, SSE4.1,
    // SSE4.2, VMX or SYSTEM.LOWORD(infos.Instruction.Category) is used to know if
    // the instruction is an arithmetic instruction, a logical one, a data transfer
    // one ... To see the complete list of constants used by BeaEngine, go HERE .
    Category: Int32;
    // [out] This field contains the opcode on 1, 2 or 3 bytes. If the instruction
    // uses a mandatory prefix, this last one is not present here. For that,
    // you have to use the structure infos.Prefix.
    Opcode: Int32;
    // [out] This field sends back the instruction mnemonic with an ASCII format.
    // You must know that all mnemonics are followed by a space (0x20). For example ,
    // the instruction "add" is written "add ".
    Mnemonic: array [0..23] of AnsiChar;
    // [out] If the decoded instruction is a branch instruction, this field is set to
    // indicate what kind of jump it is (call, ret, unconditional jump, conditional jump).
    // To get a complete list of constants used by BeaEngine, go HERE
    BranchType: Int32;
    // [out] Structure EFLStruct that specifies the used flags.
    Flags: EFLStruct;
    // [out] If the decoded instruction is a branch instruction and if the destination
    // address can be calculated, the result is stored in that field. A "jmp eax" or
    // a "jmp [eax]" will set this field to 0 .
    AddrValue: UInt64;
    // [out] If the instruction uses a constant, this immediat value is stored here.
    Immediat: Int64;
    // [out] Some instructions modify registers implicitly. For example, "push 0" modifies
    // the register RSP. In that case, infos.Instruction.ImplicitModifiedRegs.gpr == REG4.
    // Find more useful informations on that field looking at the Structure REGISTERTYPE
    ImplicitModifiedRegs: REGISTERTYPE;
    // [out] Some instructions use registers implicitly. Find more useful informations
    // on that field looking at the Structure REGISTERTYPE
    ImplicitUsedRegs: REGISTERTYPE;
  end;

  // This structure gives informations about the operand analyzed.
  OPTYPE = packed record
    // [out] This field sends back, when it is possible, the operand in ASCII format.
    OpMnemonic: array [0..23] of AnsiChar;
    // [out] This field specifies the operand type. infos.Operandxx.OpType indicates
    // if it is one of the following :
    // * REGISTER_TYPE
    // * MEMORY_TYPE
    // * CONSTANT_TYPE+ABSOLUTE_
    // * CONSTANT_TYPE+RELATIVE_
    OpType: Int64;
    // [out] This field sends back the size of the operand.
    OpSize: Int32;
    OpPosition: Int32;
    // [out] This field indicates if the operand is modified or not (READ=0x1) or (WRITE=0x2).
    AccessMode: UInt32;
    // [out] Structure MEMORYTYPE , filled only if infos.Operandxx.OpType == MEMORY_TYPE.
    Memory: MEMORYTYPE;
    // [out] Structure REGISTERTYPE , filled only if infos.Operandxx.OpType == REGISTER_TYPE.
    Registers: REGISTERTYPE;
    // [out] This field indicates, in the case of memory addressing mode, the segment
    // register used : ESReg, DSReg, FSReg, GSReg, CSReg, SSReg
    SegmentReg: UInt32;
  end;

  //* reserved structure used for thread-safety */
  //* unusable by customer */

  InternalDatas = packed record
    EIP_: UIntPtr;
    EIP_VA: UInt64;
    EIP_REAL: UIntPtr;
    OriginalOperandSize: Int32;
    OperandSize: Int32;
    MemDecoration: Int32;
    AddressSize: Int32;
    MOD_: Int32;
    RM_: Int32;
    INDEX_: Int32;
    SCALE_: Int32;
    BASE_: Int32;
    REGOPCODE: Int32;
    DECALAGE_EIP: UInt32;
    FORMATNUMBER: Int32;
    SYNTAX_: Int32;
    EndOfBlock: UInt64;
    RelativeAddress: Int32;
    Architecture: UInt32;
    ImmediatSize: Int32;
    NB_PREFIX: Int32;
    PrefRepe: Int32;
    PrefRepne: Int32;
    SEGMENTREGS: UInt32;
    SEGMENTFS: UInt32;
    third_arg: Int32;
    OPTIONS: UInt64;
    ERROR_OPCODE: Int32;
    REX: REX_Struct;
    OutOfBlock: Int32;
    VEX: VEX_Struct;
    EVEX: EVEX_Struct;
    VSIB_: Int32;
    Register_: Int32;
  end;

  //* ************** main structure ************ */

  // This structure is used to store the mnemonic, source and destination operands.
  // You just have to specify the address where the engine has to make the analysis.
  _Disasm = packed record
    // [in] Offset of bytes sequence we want to disassemble
    EIP: UIntPtr;
    // [in] optional - (For instructions CALL - JMP - conditional JMP - LOOP) By default,
    // this value is 0 (disable). The disassembler calculates the destination address of
    // the branch instruction using VirtualAddr (not EIP). This address can be 64 bits long.
    // This option allows us to decode instructions located anywhere in memory even
    // if they are not at their original place
    VirtualAddr: UInt64;
    // [in] By default, this value is 0. (disabled option). In other cases, this number
    // is the number of bytes the engine is allowed to read since EIP. Thus,
    // we can make a read block to avoid some Access violation. On INTEL processors,
    // (in IA-32 or intel 64 modes) , instruction never exceeds 15 bytes.
    // A SecurityBlock value outside this range is useless.
    SecurityBlock: UInt32;
    // [out] String used to store the instruction representation
    CompleteInstr: array [0..79] of AnsiChar;
    // [in] This field is used to specify the architecture used for the decoding.
    // If it is set to 0 or 64 (0x20), the architecture used is 64 bits. If it is
    // set to 32 (0x20), the architecture used is IA-32. If set to 16 (0x10),
    // architecture is 16 bits.
    Archi: UInt32;
    // [in] This field allows to define some display options. You can specify the
    // syntax: masm, nasm ,goasm. You can specify the number format you want to use:
    // prefixed numbers or suffixed ones. You can even add a tabulation between the
    // mnemonic and the first operand or display the segment registers used by the
    // memory addressing. Constants used are the following :
    // * Tabulation: add a tabulation between mnemonic and first operand (default has no tabulation)
    // * GoAsmSyntax / NasmSyntax: change the intel syntax (default is Masm syntax)
    // * PrefixedNumeral: 200h is written 0x200 (default is suffixed numeral)
    // * ShowSegmentRegs: show segment registers used (default is hidden)
    // * ShowEVEXMasking: show opmask and merging/zeroing applyed on first operand for AVX512 instructions (default is hidden)
    Options: UInt64;
    // [out] Structure INSTRTYPE.
    Instruction: INSTRTYPE;
    // [out] Structure OPTYPE that concerns the first operand.
    Operand1: OPTYPE;
    // [out] Structure OPTYPE that concerns the second operand.
    Operand2: OPTYPE;
    // [out] Structure OPTYPE that concerns the third operand.
    Operand3: OPTYPE;
    // [out] Structure OPTYPE that concerns the fourth operand.
    Operand4: OPTYPE;
    // [out] Structure OPTYPE that concerns the fifth operand.
    Operand5: OPTYPE;
    // [out] Structure OPTYPE that concerns the sixth operand.
    Operand6: OPTYPE;
    // [out] Structure OPTYPE that concerns the seventh operand.
    Operand7: OPTYPE;
    // [out] Structure OPTYPE that concerns the eighth operand.
    Operand8: OPTYPE;
    // [out] Structure OPTYPE that concerns the ninth operand.
    Operand9: OPTYPE;
    // [out] Structure PREFIXINFO containing an exhaustive list of used prefixes.
    Prefix: PREFIXINFO;
    // [out] This field returns the status of the disassemble process :
    // * Success: (0) instruction has been recognized by the engine
    // * Out of block: (-2) instruction length is out of SecurityBlock
    // * Unknown opcode: (-1) instruction is not recognized by the engine
    // * Exception #UD: (2) instruction has been decoded properly but sends #UD exception if executed.
    // * Exception #DE: (3) instruction has been decoded properly but sends #DE exception if executed
    Error: Int32;
    // reserved structure used for thread-safety, unusable by customer
    Reserved_: InternalDatas;
  end;
  TDisasm = _Disasm;
  PDisasm = ^TDisasm;

const
  //* #UD exception */
  UD_                   = 2;
  DE__                  = 3;

const
  // Values taken by infos.Operandxx.SegmentReg
  ESReg                 = $01;
  DSReg                 = $02;
  FSReg                 = $04;
  GSReg                 = $08;
  CSReg                 = $10;
  SSReg                 = $20;

const
  // Concerns the LOCK prefix
  InvalidPrefix         = 4;
  SuperfluousPrefix     = 2;
  NotUsedPrefix         = 0;
  MandatoryPrefix       = 8;
  InUsePrefix           = 1;

  LowPosition           = 0;
  HighPosition          = 1;

  //* EVEX Masking */

  NO_MASK               = 0;
  MERGING               = 1;
  MERGING_ZEROING       = 2;

  //* EVEX Compressed Displacement */

  FULL                  = 1;
  HALF                  = 2;
  FULL_MEM              = 3;
  TUPLE1_SCALAR__8      = 4;
  TUPLE1_SCALAR__16     = 5;
  TUPLE1_SCALAR         = 6;
  TUPLE1_FIXED__32      = 7;
  TUPLE1_FIXED__64      = 8;
  TUPLE2                = 9;
  TUPLE4                = 10;
  TUPLE8                = 11;
  HALF_MEM              = 12;
  QUARTER_MEM           = 13;
  EIGHTH_MEM            = 14;
  MEM128                = 15;
  MOVDDUP               = 16;

type
  INSTRUCTION_TYPE = Integer;
const
  // Here is an exhaustive list of constants used by fields sends back by BeaEngine.
  // Values taken by (infos.Instruction.Category & 0xFFFF0000)
  GENERAL_PURPOSE_INSTRUCTION = $10000;
  FPU_INSTRUCTION       = $20000;
  MMX_INSTRUCTION       = $30000;
  SSE_INSTRUCTION       = $40000;
  SSE2_INSTRUCTION      = $50000;
  SSE3_INSTRUCTION      = $60000;
  SSSE3_INSTRUCTION     = $70000;
  SSE41_INSTRUCTION     = $80000;
  SSE42_INSTRUCTION     = $90000;
  SYSTEM_INSTRUCTION    = $A0000;
  VM_INSTRUCTION        = $B0000;
  UNDOCUMENTED_INSTRUCTION = $C0000;
  AMD_INSTRUCTION       = $D0000;
  ILLEGAL_INSTRUCTION   = $E0000;
  AES_INSTRUCTION       = $F0000;
  CLMUL_INSTRUCTION     = $100000;
  AVX_INSTRUCTION       = $110000;
  AVX2_INSTRUCTION      = $120000;
  MPX_INSTRUCTION       = $130000;
  AVX512_INSTRUCTION    = $140000;
  SHA_INSTRUCTION       = $150000;
  BMI2_INSTRUCTION      = $160000;
  CET_INSTRUCTION       = $170000;
  BMI1_INSTRUCTION      = $180000;
  XSAVEOPT_INSTRUCTION  = $190000;
  FSGSBASE_INSTRUCTION  = $1A0000;
  CLWB_INSTRUCTION      = $1B0000;
  CLFLUSHOPT_INSTRUCTION = $1C0000;
  FXSR_INSTRUCTION      = $1D0000;
  XSAVE_INSTRUCTION     = $1E0000;
  SGX_INSTRUCTION       = $1F0000;
  PCONFIG_INSTRUCTION   = $200000;
  UINTR_INSTRUCTION     = $210000;
  KL_INSTRUCTION        = $220000;
  AMX_INSTRUCTION       = $230000;

const
  // Values taken by LOWORD(infos.Instruction.Category)
  DATA_TRANSFER         = 1;
  ARITHMETIC_INSTRUCTION = 2;
  LOGICAL_INSTRUCTION   = 3;
  SHIFT_ROTATE          = 4;
  BIT_UInt8             = 5;
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
  ACCELERATOR_INSTRUCTION = 42; //* crc32; popcnt (sse4.2) */
  ROUND_INSTRUCTION     = 43;

type
  EFLAGS_STATES = Integer;
const
  // Values taken by infos.Instruction.Flags.OF_ , .SF_ ...
  TE_                   = $01;
  MO_                   = $02;
  RE_                   = $04;
  SE_                   = $08;
  UN_                   = $10;
  PR_                   = $20;

type
  BRANCH_TYPE = Integer;
const
  // Values taken by infos.Instruction.BranchType
  JO                    = 1;
  JC                    = 2;
  JE                    = 3;
  JA                    = 4;
  JS                    = 5;
  JP                    = 6;
  JL                    = 7;
  JG                    = 8;
  JB                    = 2;   //* JC == JB */
  JECXZ                 = 10;
  JmpType               = 11;
  CallType              = 12;
  RetType               = 13;
  JNO                   = -1;
  JNC                   = -2;
  JNE                   = -3;
  JNA                   = -4;
  JNS                   = -5;
  JNP                   = -6;
  JNL                   = -7;
  JNG                   = -8;
  JNB                   = -2;  //* JNC == JNB */

type
  ARGUMENTS_TYPE = Integer;
const
  // Values taken by infos.Operandxx.OpType
  NO_ARGUMENT           = $10000;
  REGISTER_TYPE         = $20000;
  MEMORY_TYPE           = $30000;
  CONSTANT_TYPE         = $40000;

  GENERAL_REG           = $1;
  MMX_REG               = $2;
  SSE_REG               = $4;
  AVX_REG               = $8;
  AVX512_REG            = $10;
  SPECIAL_REG           = $20;
  CR_REG                = $40;
  DR_REG                = $80;
  MEMORY_MANAGEMENT_REG = $100;
  MPX_REG               = $200;
  OPMASK_REG            = $400;
  SEGMENT_REG           = $800;
  FPU_REG               = $1000;
  TMM_REG               = $2000;

  RELATIVE_             = $4000000;
  ABSOLUTE_             = $8000000;

  // OPTYPE.AccessMode, indicates if the operand is modified or not
  READ                  = $1;
  WRITE                 = $2;

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
  REG16                 = $10000;
  REG17                 = $20000;
  REG18                 = $40000;
  REG19                 = $80000;
  REG20                 = $100000;
  REG21                 = $200000;
  REG22                 = $400000;
  REG23                 = $800000;
  REG24                 = $1000000;
  REG25                 = $2000000;
  REG26                 = $4000000;
  REG27                 = $8000000;
  REG28                 = $10000000;
  REG29                 = $20000000;
  REG30                 = $40000000;
  REG31                 = $80000000;

type
  SPECIAL_INFO = Integer;
const
  UNKNOWN_OPCODE        = -1;
  OUT_OF_BLOCK          = -2;

  // Values taken by infos.Options

  //* === mask = 0xff */
  NoTabulation          = $00000000;
  Tabulation            = $00000001;

  //* === mask = 0xff00 */
  MasmSyntax            = $00000000;
  GoAsmSyntax           = $00000100;
  NasmSyntax            = $00000200;
  ATSyntax              = $00000400;
  IntrinsicMemSyntax    = $00000800;

  //* === mask = 0xff0000 */
  PrefixedNumeral       = $00010000;
  SuffixedNumeral       = $00000000;

  //* === mask = 0xff000000 */
  ShowSegmentRegs       = $01000000;
  ShowEVEXMasking       = $02000000;

const
  // _Disasm.Archi
  ARCHI_X16             = $10;
  ARCHI_X32             = $20;
  ARCHI_X64             = $40;

const
  OPCODE_RET            = $C3;

const
{$IFDEF MSWINDOWS}
  // Win32 from beaengine-src-5.3.0.zip\build\obj\Windows.msvc.Debug\src\BeaEngine_d_l_stdcall.vcxproj
  //     + BUILD_BEA_ENGINE_DLL;BEA_LACKS_SNPRINTF;BEA_USE_STDCALL + VC-LTL 5
  // Win64 from beaengine-bin-5.3.0.zip\dll_x64\BeaEngine.dll
  BeaEngineLib   = 'BeaEngine.dll';
{$ENDIF}
{$IFDEF LINUX}
  BeaEngineLib   = 'libBeaEngine.so';
{$ENDIF}
{$IFDEF MACOS}
  {$IF DEFINED(IOS) or DEFINED(MACOS64)}
  BeaEngineLib   = '/usr/lib/libBeaEngine.dylib';
  {$ELSE}
  BeaEngineLib   = 'libBeaEngine.dylib';
  {$IFEND}
{$ENDIF}
{$IF DEFINED(FPC) and DEFINED(DARWIN)}
  BeaEngineLib   = 'libBeaEngine.dylib';
  {$LINKLIB libBeaEngine}
{$IFEND}
{$IFDEF ANDROID}
  BeaEngineLib   = 'libBeaEngine.so';
{$ENDIF}

const
{$IFDEF FPC}
  {$IFDEF CPUX64}
  BeaEngineRevisionName = 'BeaEngineRevision';
  BeaEngineVersionName  = 'BeaEngineVersion';
  DisasmName            = 'Disasm';
  {$ELSE}
  BeaEngineRevisionName = '_BeaEngineRevision@0';
  BeaEngineVersionName  = '_BeaEngineVersion@0';
  DisasmName            = '_Disasm@4';
  {$ENDIF}
{$ELSE}
  {$IF DEFINED(CPUX64) or DEFINED(BE_STATICLINK)}
  BeaEngineRevisionName = 'BeaEngineRevision';
  BeaEngineVersionName  = 'BeaEngineVersion';
  DisasmName            = 'Disasm';
  {$ELSE}
  BeaEngineRevisionName = '_BeaEngineRevision@0';
  BeaEngineVersionName  = '_BeaEngineVersion@0';
  DisasmName            = '_Disasm@4';
  {$IFEND}
{$ENDIF}

// The Disasm function disassembles one instruction from the Intel ISA. It makes a precise
// analysis of the focused instruction and sends back a complete structure that is usable
// to make data-flow and control-flow studies.
// Parameters
// infos: Pointer to a structure PDISASM
// Return
// The function may sends you back 3 values. if the analyzed bytes sequence is an invalid
// opcode, it sends back UNKNOWN_OPCODE (-1). If it tried to read a byte located outside
// the Security Block, it sends back OUT_OF_BLOCK (-2). In others cases, it sends back
// the instruction length. Thus, you can use it as a LDE. To have a detailed status,
// use infos.Error field.
function Disasm(var aDisAsm: TDisasm): LongInt; stdcall;
  external {$IFDEF BE_USE_EXTNAME}BeaEngineLib{$ENDIF} name DisasmName;

function BeaEngineVersion: PAnsiChar; stdcall;
  external {$IFDEF BE_USE_EXTNAME}BeaEngineLib{$ENDIF} name BeaEngineVersionName;

function BeaEngineRevision: PAnsiChar; stdcall;
  external {$IFDEF BE_USE_EXTNAME}BeaEngineLib{$ENDIF} name BeaEngineRevisionName;

function BeaEngineVersionInfo: string; stdcall;

function BufferToHex(const AData: Pointer; ALen: Integer): string;

implementation

{$IFDEF BE_STATICLINK}

{$IFDEF FPC}
  {$IFDEF MSWINDOWS} {$IFDEF CPUX64}
    // Win64 from beaengine-src-5.3.0.zip\cb\BeaEngineLib.cbp + TDM-GCC-64 9.2.0
    //     + BEA_ENGINE_STATIC;BEA_LACKS_SNPRINTF;BEA_USE_STDCALL
    {$L 'Win64\BeaEngine.o'}
  {$ELSE}
    // Win32 from beaengine-src-5.3.0.zip\cb\BeaEngineLib.cbp + TDM-GCC-32 9.2.0
    //     + BEA_ENGINE_STATIC;BEA_LACKS_SNPRINTF;BEA_USE_STDCALL
    {$L 'Win32\BeaEngine.o'}
  {$ENDIF} {$ENDIF}
  {$IFDEF MACOS} {$IFDEF CPUX64}
    {$L 'OSX64\BeaEngine.o'}
  {$ELSE}
    {$L 'OSX32\BeaEngine.o'}
  {$ENDIF} {$ENDIF}
  {$IFDEF LINUX} {$IFDEF CPUX64}
    {$L 'Linux64\BeaEngine.o'}
  {$ELSE}
    {$L 'Linux32\BeaEngine.o'}
  {$ENDIF} {$ENDIF}
{$ELSE}
  {$IFDEF MSWINDOWS} {$IFDEF CPUX64}
    // Win64 from beaengine-bin-5.3.0.zip\lib_static_x64\BeaEngine.lib
    {$L 'Win64\BeaEngine.obj'}
  {$ELSE}
    // Win32 from beaengine-src-5.3.0.zip\bcb\BeaEngineLib.cbproj
    //     + BEA_ENGINE_STATIC;BEA_LACKS_SNPRINTF;BEA_USE_STDCALL
    {$L 'Win32\BeaEngine.obj'}
  {$ENDIF} {$ENDIF}
{$ENDIF}

const
  libc = 'msvcrt.dll';

{$IFDEF BE_USE_UNDERSCORE}
procedure _memcpy; cdecl; external libc name 'memcpy';
{$ELSE}
procedure memcpy; cdecl; external libc name 'memcpy';
{$ENDIF}

{$IFDEF BE_USE_UNDERSCORE}
procedure _memset; cdecl; external libc name 'memset';
{$ELSE}
procedure memset; cdecl; external libc name 'memset';
{$ENDIF}

{$IFDEF BE_USE_UNDERSCORE}
procedure _strcmp; cdecl; external libc name 'strcmp';
{$ELSE}
procedure strcmp; cdecl; external libc name 'strcmp';
{$ENDIF}

{$IFDEF BE_USE_UNDERSCORE}
procedure _strcpy; cdecl; external libc name 'strcpy';
{$ELSE}
procedure strcpy; cdecl; external libc name 'strcpy';
{$ENDIF}

{$IFDEF BE_USE_UNDERSCORE}
procedure _strlen; cdecl; external libc name 'strlen';
{$ELSE}
procedure strlen; cdecl; external libc name 'strlen';
{$ENDIF}

{$IFDEF BE_USE_UNDERSCORE}
procedure _sprintf; cdecl; external libc name 'sprintf';
{$ELSE}
procedure sprintf; cdecl; external libc name 'sprintf';
{$ENDIF}

{$IFDEF FPC}

const
{$IFDEF BE_USE_UNDERSCORE}
  _PREFIX = '_';
{$ELSE}
  _PREFIX = '';
{$ENDIF CPU64}

procedure impl_strcpy; assembler; nostackframe; public name _PREFIX + 'strcpy';
asm
  jmp {$IFDEF BE_USE_UNDERSCORE}_strcpy{$ELSE}strcpy{$ENDIF}
end;

procedure impl_strlen; assembler; nostackframe; public name _PREFIX + 'strlen';
asm
  jmp {$IFDEF BE_USE_UNDERSCORE}_strlen{$ELSE}strlen{$ENDIF}
end;

procedure impl_sprintf; assembler; nostackframe; public name _PREFIX + 'sprintf';
asm
  jmp {$IFDEF BE_USE_UNDERSCORE}_sprintf{$ELSE}sprintf{$ENDIF}
end;

{$ENDIF}

{$ENDIF BE_STATICLINK}

function BeaEngineVersionInfo: string; stdcall;
begin
{$IFDEF CPUX64}
  Result := 'v' + string(BeaEngineVersion) + ' (Rev' + string(BeaEngineRevision) + ',x64)';
{$ELSE}
  Result := 'v' + string(BeaEngineVersion) + ' (Rev' + string(BeaEngineRevision) + ',x32)';
{$ENDIF}
end;

function BufferToHex(const AData: Pointer; ALen: Integer): string;
const
  defCharConvertTable: array[0..15] of Char = (
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
  );
var
  pData: PByte;
  pRet: PChar;
begin
  pData := AData;
  SetLength(Result, 2 * ALen);
  pRet := PChar(Result);
  while ALen > 0 do
  begin
    pRet^ := defCharConvertTable[(pData^ and $F0) shr 4];
    Inc(pRet);
    pRet^ := defCharConvertTable[pData^ and $0F];
    Inc(pRet);
    Dec(ALen);
    Inc(pData);
  end;
end;

end.
