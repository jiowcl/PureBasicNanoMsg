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

Global lpszServerAddr.s = "tcp://*:1700"

If DllOpen(lpszLibNnDll) = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_REP)

If Socket < 0
  PrintN("Socket failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  CloseConsole()
  DllClose()
  End 1
EndIf

Define Rc.i = NanomsgSocket::Bind(Socket, lpszServerAddr)

If Rc < 0
  PrintN("Bind failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

PrintN("Bind an IP address: " + lpszServerAddr)

Define lTotal.l = 0

While 1
  lTotal = lTotal + 1
  
  Define *lpszBuffer = AllocateMemory(256)
  Define lpszMessage.s = "Hi " + lTotal
  Define recvRc.i = NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
  
  If recvRc >= 0
    PrintN("Received: " + PeekS(*lpszBuffer, recvRc, #PB_Ascii))
    
    If NanomsgSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0) < 0
      PrintN("Send failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    EndIf
  Else
    PrintN("Recv failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  EndIf
  
  FreeMemory(*lpszBuffer)
Wend

NanomsgSocket::Close(Socket)
CloseConsole()
DllClose()
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Executable = ..\..\ModuleRepServer.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
