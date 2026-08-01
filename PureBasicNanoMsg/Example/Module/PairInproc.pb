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

; inproc requires both endpoints in the same process.
Global lpszAddr.s = "inproc://pb-pair-smoke"

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define sockA.i = NanomsgSocket::Socket(#AF_SP, #NN_PAIR)
  Define sockB.i = NanomsgSocket::Socket(#AF_SP, #NN_PAIR)
  Define Rc.i
  
  Rc = NanomsgSocket::Bind(sockA, lpszAddr)
  Rc = NanomsgSocket::Connect(sockB, lpszAddr)
  
  ; Give the inproc connection a moment to establish.
  Delay(50)
  
  Define lpszPing.s = "ping"
  Define lpszPong.s = "pong"
  Define *buffer = AllocateMemory(64)
  Define ok.i = #True
  
  If NanomsgSocket::SendString(sockA, lpszPing, Len(lpszPing), 0) < 0
    PrintN("Send ping failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  EndIf
  
  If ok And NanomsgSocket::Recv(sockB, *buffer, MemorySize(*buffer), 0) < 0
    PrintN("Recv ping failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  ElseIf ok
    PrintN("B received: " + PeekS(*buffer, -1, #PB_UTF8))
  EndIf
  
  FillMemory(*buffer, MemorySize(*buffer), 0)
  
  If ok And NanomsgSocket::SendString(sockB, lpszPong, Len(lpszPong), 0) < 0
    PrintN("Send pong failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  EndIf
  
  If ok And NanomsgSocket::Recv(sockA, *buffer, MemorySize(*buffer), 0) < 0
    PrintN("Recv pong failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    ok = #False
  ElseIf ok
    PrintN("A received: " + PeekS(*buffer, -1, #PB_UTF8))
  EndIf
  
  FreeMemory(*buffer)
  
  NanomsgSocket::Close(sockA)
  NanomsgSocket::Close(sockB)
  
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
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\..\ModulePairInproc.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
