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

Global lpszAddr.s = "inproc://pb-pair-smoke"

If DllOpen(lpszLibNnDll) = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define sockA.i = NanomsgSocket::Socket(#AF_SP, #NN_PAIR)
Define sockB.i = NanomsgSocket::Socket(#AF_SP, #NN_PAIR)
Define Rc.i
Define ok.i = #True
Define recvRc.i

If sockA < 0 Or sockB < 0
  PrintN("Socket failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  ok = #False
EndIf

If ok
  Rc = NanomsgSocket::Bind(sockA, lpszAddr)
  
  If Rc < 0
    PrintN("Bind failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  EndIf
EndIf

If ok
  Rc = NanomsgSocket::Connect(sockB, lpszAddr)
  
  If Rc < 0
    PrintN("Connect failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  EndIf
EndIf

Delay(50)

Define lpszPing.s = "ping"
Define lpszPong.s = "pong"
Define *buffer = AllocateMemory(64)

If ok
  If NanomsgSocket::SendString(sockA, lpszPing, Len(lpszPing), 0) < 0
    PrintN("Send ping failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  EndIf
EndIf

If ok
  recvRc = NanomsgSocket::Recv(sockB, *buffer, MemorySize(*buffer), 0)
  
  If recvRc < 0
    PrintN("Recv ping failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  Else
    PrintN("B received: " + PeekS(*buffer, recvRc, #PB_Ascii))
  EndIf
EndIf

FillMemory(*buffer, MemorySize(*buffer), 0)

If ok
  If NanomsgSocket::SendString(sockB, lpszPong, Len(lpszPong), 0) < 0
    PrintN("Send pong failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  EndIf
EndIf

If ok
  recvRc = NanomsgSocket::Recv(sockA, *buffer, MemorySize(*buffer), 0)
  
  If recvRc < 0
    PrintN("Recv pong failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  Else
    PrintN("A received: " + PeekS(*buffer, recvRc, #PB_Ascii))
  EndIf
EndIf

FreeMemory(*buffer)

If sockA >= 0
  NanomsgSocket::Close(sockA)
EndIf

If sockB >= 0
  NanomsgSocket::Close(sockB)
EndIf

If ok
  PrintN("PAIR inproc smoke test OK.")
Else
  PrintN("PAIR inproc smoke test FAILED.")
EndIf

Input()
CloseConsole()
DllClose()

If ok = #False
  End 1
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Executable = ..\..\ModulePairInproc.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
