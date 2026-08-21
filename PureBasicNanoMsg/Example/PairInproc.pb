;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../Core/Nanomsg.pbi"

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

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define sockA.i = NnSocket(hLibrary, #AF_SP, #NN_PAIR)
Define sockB.i = NnSocket(hLibrary, #AF_SP, #NN_PAIR)
Define Rc.i
Define ok.i = #True

If sockA < 0 Or sockB < 0
  PrintN("Socket failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  ok = #False
EndIf

If ok
  Rc = NnBind(hLibrary, sockA, lpszAddr)
  
  If Rc < 0
    PrintN("Bind failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
    ok = #False
  EndIf
EndIf

If ok
  Rc = NnConnect(hLibrary, sockB, lpszAddr)
  
  If Rc < 0
    PrintN("Connect failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
    ok = #False
  EndIf
EndIf

; Give the inproc connection a moment to establish.
Delay(50)

Define lpszPing.s = "ping"
Define lpszPong.s = "pong"
Define *buffer = AllocateMemory(64)
Define recvRc.i

If ok
  If NnSendString(hLibrary, sockA, lpszPing, Len(lpszPing), 0) < 0
    PrintN("Send ping failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
    ok = #False
  EndIf
EndIf

If ok
  recvRc = NnRecv(hLibrary, sockB, *buffer, MemorySize(*buffer), 0)
  
  If recvRc < 0
    PrintN("Recv ping failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
    ok = #False
  Else
    PrintN("B received: " + PeekS(*buffer, recvRc, #PB_Ascii))
  EndIf
EndIf

FillMemory(*buffer, MemorySize(*buffer), 0)

If ok
  If NnSendString(hLibrary, sockB, lpszPong, Len(lpszPong), 0) < 0
    PrintN("Send pong failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
    ok = #False
  EndIf
EndIf

If ok
  recvRc = NnRecv(hLibrary, sockA, *buffer, MemorySize(*buffer), 0)
  
  If recvRc < 0
    PrintN("Recv pong failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
    ok = #False
  Else
    PrintN("A received: " + PeekS(*buffer, recvRc, #PB_Ascii))
  EndIf
EndIf

FreeMemory(*buffer)

If sockA >= 0
  NnClose(hLibrary, sockA)
EndIf

If sockB >= 0
  NnClose(hLibrary, sockB)
EndIf

If ok
  PrintN("PAIR inproc smoke test OK.")
Else
  PrintN("PAIR inproc smoke test FAILED.")
EndIf

Input()
CloseConsole()
NnDllClose(hLibrary)

If ok = #False
  End 1
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\PairInproc.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
