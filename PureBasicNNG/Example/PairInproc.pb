;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../Core/Nng.pbi"

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

Global hLibrary.i = NngDllOpen(lpszLibNngDll)

If hLibrary And NngInit(hLibrary) = #NNG_OK
  OpenConsole()
  
  Define sockA.l
  Define sockB.l
  Define Rc.i
  Define ok.i = #True
  
  Rc = NngPair1Open(hLibrary, @sockA)
  If Rc <> #NNG_OK
    ok = #False
  EndIf
  
  Rc = NngPair1Open(hLibrary, @sockB)
  If Rc <> #NNG_OK
    ok = #False
  EndIf
  
  If ok
    Rc = NngListen(hLibrary, sockA, lpszAddr)
    Rc = NngDial(hLibrary, sockB, lpszAddr)
  EndIf
  
  ; Give the inproc connection a moment to establish.
  Delay(50)
  
  Define lpszPing.s = "ping"
  Define lpszPong.s = "pong"
  Define *buffer = AllocateMemory(64)
  
  If ok And NngSendString(hLibrary, sockA, lpszPing, Len(lpszPing), 0) <> #NNG_OK
    PrintN("Send ping failed: " + NngStrerror(hLibrary, Rc))
    ok = #False
  EndIf
  
  If ok And NngRecvBuffer(hLibrary, sockB, *buffer, MemorySize(*buffer), 0) < 0
    PrintN("Recv ping failed.")
    ok = #False
  ElseIf ok
    PrintN("B received: " + PeekS(*buffer, -1, #PB_UTF8))
  EndIf
  
  FillMemory(*buffer, MemorySize(*buffer), 0)
  
  If ok And NngSendString(hLibrary, sockB, lpszPong, Len(lpszPong), 0) <> #NNG_OK
    PrintN("Send pong failed.")
    ok = #False
  EndIf
  
  If ok And NngRecvBuffer(hLibrary, sockA, *buffer, MemorySize(*buffer), 0) < 0
    PrintN("Recv pong failed.")
    ok = #False
  ElseIf ok
    PrintN("A received: " + PeekS(*buffer, -1, #PB_UTF8))
  EndIf
  
  FreeMemory(*buffer)
  
  NngSocketClose(hLibrary, sockA)
  NngSocketClose(hLibrary, sockB)
  
  If ok
    PrintN("PAIR inproc smoke test OK.")
  Else
    PrintN("PAIR inproc smoke test FAILED.")
  EndIf
  
  Input()
  CloseConsole()
  
  NngFini(hLibrary)
  NngDllClose(hLibrary)
  
  If ok = #False
    End 1
  EndIf
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; Executable = ..\PairInproc.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
