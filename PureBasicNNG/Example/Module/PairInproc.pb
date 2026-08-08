;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NngWrapper.pbi"

UseModule NngWrapper

Global lpszCurrentDir.s = GetCurrentDirectory()

; NNG version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNngDir.s = "Library/x64"
  Global lpszLibNngDll.s = lpszCurrentDir + lpszLibNngDir + "/nng.dll"
  
  SetCurrentDirectory(lpszCurrentDir + lpszLibNngDir)
CompilerElse
  CompilerError "Only x64 nng.dll is bundled."
CompilerEndIf

; inproc requires both endpoints in the same process.
Global lpszAddr.s = "inproc://pb-pair-smoke"

If DllOpen(lpszLibNngDll)
  OpenConsole()
  
  Define sockA.i = NngSocket::PairOpen()
  Define sockB.i = NngSocket::PairOpen()
  Define Rc.i
  
  Rc = NngSocket::Listen(sockA, lpszAddr)
  Rc = NngSocket::Dial(sockB, lpszAddr)
  
  ; Give the inproc connection a moment to establish.
  Delay(50)
  
  Define lpszPing.s = "ping"
  Define lpszPong.s = "pong"
  Define *buffer = AllocateMemory(64)
  Define ok.i = #True
  
  If NngSocket::SendString(sockA, lpszPing, Len(lpszPing), 0) <> #NNG_OK
    PrintN("Send ping failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
    ok = #False
  EndIf
  
  If ok And NngSocket::Recv(sockB, *buffer, MemorySize(*buffer), 0) < 0
    PrintN("Recv ping failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
    ok = #False
  ElseIf ok
    PrintN("B received: " + PeekS(*buffer, -1, #PB_UTF8))
  EndIf
  
  FillMemory(*buffer, MemorySize(*buffer), 0)
  
  If ok And NngSocket::SendString(sockB, lpszPong, Len(lpszPong), 0) <> #NNG_OK
    PrintN("Send pong failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
    ok = #False
  EndIf
  
  If ok And NngSocket::Recv(sockA, *buffer, MemorySize(*buffer), 0) < 0
    PrintN("Recv pong failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
    ok = #False
  ElseIf ok
    PrintN("A received: " + PeekS(*buffer, -1, #PB_UTF8))
  EndIf
  
  FreeMemory(*buffer)
  
  NngSocket::Close(sockA)
  NngSocket::Close(sockB)
  
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
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
