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

Global lpszServerAddr.s = "tcp://localhost:1689"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_SUB)

If Socket < 0
  PrintN("Socket failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  CloseConsole()
  NnDllClose(hLibrary)
  End 1
EndIf

Define Rc.i = NnConnect(hLibrary, Socket, lpszServerAddr)

If Rc < 0
  PrintN("Connect failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  NnClose(hLibrary, Socket)
  CloseConsole()
  NnDllClose(hLibrary)
  End 1
EndIf

Define lpszSubscribe.s = "quotes"

Rc = NnSetsockoptString(hLibrary, Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe)

If Rc < 0
  PrintN("Subscribe failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  NnClose(hLibrary, Socket)
  CloseConsole()
  NnDllClose(hLibrary)
  End 1
EndIf

PrintN("Subscribed to '" + lpszSubscribe + "' on " + lpszServerAddr)

While 1
  Define *lpszBuffer = AllocateMemory(256)
  Define recvRc.i = NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
  
  ; nn_recv does not append a null terminator; use the returned length.
  If recvRc >= 0
    PrintN(PeekS(*lpszBuffer, recvRc, #PB_Ascii))
  Else
    PrintN("Recv failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  EndIf
  
  FreeMemory(*lpszBuffer)
Wend

NnClose(hLibrary, Socket)
Input()
CloseConsole()
NnDllClose(hLibrary)
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 46
; FirstLine = 4
; Folding = -
; EnableXP
; Executable = ..\SubClient.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
