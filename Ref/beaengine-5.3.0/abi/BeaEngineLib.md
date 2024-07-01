| | | | | | | | |
|-|-|-|-|-|-|-|-|
|编译器|使用|平台|库名称|格式|导入|导出|调用|
|gcc aarch64-linux-android|否|aarch64-android|BeaEngine.o|elf64 for arm64|sprintf stpcpy strcmp strcpy strlen memcpy memset|BeaEngineRevision BeaEngineVersion Disasm|fastcall|
|xcode14|是|aarch64-darwin|BeaEngine.o|macho for arm64|_sprintf _strcmp _strcpy _strlen _memcpy ___sprintf_chk ___stack_chk_fail ___stack_chk_guard ___strcpy_chk|_BeaEngineRevision _BeaEngineVersion _Disasm|fastcall|
|gcc aarch64-linux-gnu|是|aarch64-linux|BeaEngine.o|elf64 for arm64|sprintf stpcpy strcmp strcpy strlen memcpy memset|BeaEngineRevision BeaEngineVersion Disasm|fastcall|
|gcc arm-linux-androideabi|否|arm-android|BeaEngine.o|elf for arm|sprintf stpcpy strcmp strcpy strlen memcpy memset|BeaEngineRevision BeaEngineVersion Disasm|fastcall|
|gcc x86_64-pc-linux-gnu|是|i386-linux|BeaEngine.o|elf|sprintf stpcpy strcmp strcpy strlen|BeaEngineRevision BeaEngineVersion Disasm|cdecl|
|bcb12|否|i386-win32|BeaEngine.obj|omf|_sprintf _strcmp _strcpy _strlen _memcpy _memset|BeaEngineRevision BeaEngineVersion Disasm|stdcall|
|bcb12 -STDCALL|是|i386-win32|BeaEngine.obj|omf|_sprintf _strcmp _strcpy _strlen _memcpy _memset|_BeaEngineRevision _BeaEngineVersion _Disasm|cdecl|
|gcc tdm64|否|i386-win32|BeaEngine.o|coff|_sprintf _strcpy _strlen|_BeaEngineRevision@0 _BeaEngineVersion@0 _Disasm@4|stdcall|
|gcc tdm64 -STDCALL|是|i386-win32|BeaEngine.o|coff|_sprintf _strcpy _strlen|_BeaEngineRevision _BeaEngineVersion _Disasm|cdecl|
|msvc|否|i386-win32|BeaEngine.dll|pe|-|_BeaEngineRevision@0 _BeaEngineVersion@0 _Disasm@4|stdcall|
|msvc -STDCALL|否|i386-win32|BeaEngine.dll|pe|-|BeaEngineRevision BeaEngineVersion Disasm|cdecl|
|xcode14|是|x86_64-darwin|BeaEngine.o|macho for amd64|_sprintf _strcmp _strcpy _strlen _memcpy ___bzero ___sprintf_chk ___stack_chk_fail ___stack_chk_guard ___strcpy_chk|_BeaEngineRevision _BeaEngineVersion _Disasm|fastcall|
|gcc x86_64-pc-linux-gnu|是|x86_64-linux|BeaEngine.o|elf64 for x86-64|sprintf stpcpy strcmp strcpy strlen|BeaEngineRevision BeaEngineVersion Disasm|fastcall|
|pelles c|是|x86_64-win64|BeaEngine.obj|coff for amd64|sprintf strcmp strcpy strlen memset|BeaEngineRevision BeaEngineVersion Disasm|fastcall|
|pelles c|否|x86_64-win64|BeaEngine.dll|pe64|-|BeaEngineRevision BeaEngineVersion Disasm|fastcall|
|gcc tdm64|是|x86_64-win64|BeaEngine.o|coff for amd64|sprintf strcpy strlen|BeaEngineRevision BeaEngineVersion Disasm|fastcall|
