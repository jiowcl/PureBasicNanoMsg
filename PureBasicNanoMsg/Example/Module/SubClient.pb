;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NanomsgWrapper.pbi"

UseModule NanomsgWrapper

Global lpszCurrentDir.s = GetCurrentDirectory()

; Nanomsg version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNnDir.s = "Library/x64"
  Global lpszLibNnDll.s = lpszCurrentDir + lpszLibNnDir + "/nanomsg.dll"
  
  SetCurrentDirectory(lpszCurrentDir + lpszLibNnDir)
CompilerElse
  CompilerError "Only x64 nanomsg.dll is bundled."
CompilerEndIf

Global lpszServerAddr.s = "tcp://localhost:1689"

If DllOpen(lpszLibNnDll) = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_SUB)

If Socket < 0
  PrintN("Socket failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  CloseConsole()
  DllClose()
  End 1
EndIf

Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)

If Rc < 0
  PrintN("Connect failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

Define lpszSubscribe.s = "quotes"

Rc = NanomsgSocket::SetsockoptString(Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe)

If Rc < 0
  PrintN("Subscribe failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

PrintN("Subscribed to '" + lpszSubscribe + "' on " + lpszServerAddr)

While 1
  Define *lpszBuffer = AllocateMemory(256)
  Define recvRc.i = NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
  
  ; nn_recv does not append a null terminator; use the returned length.
  If recvRc >= 0
    PrintN(PeekS(*lpszBuffer, recvRc, #PB_Ascii))
  Else
    PrintN("Recv failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  EndIf
  
  FreeMemory(*lpszBuffer)
Wend

NanomsgSocket::Close(Socket)
Input()
CloseConsole()
DllClose()
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Executable = ..\..\ModuleSubClient.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
