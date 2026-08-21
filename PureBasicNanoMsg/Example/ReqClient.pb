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

Global lpszServerAddr.s = "tcp://localhost:1700"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_REQ)

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

PrintN("Connect to Server: " + lpszServerAddr)

Define i.i

For i = 0 To 10
  Define *lpszBuffer = AllocateMemory(256)
  Define lpszMessage.s = "From Client"
  
  If NnSendString(hLibrary, Socket, lpszMessage, Len(lpszMessage), 0) < 0
    PrintN("Send failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  Else
    Define recvRc.i = NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    If recvRc >= 0
      PrintN("Reply From Server: " + PeekS(*lpszBuffer, recvRc, #PB_Ascii))
    Else
      PrintN("Recv failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
    EndIf
  EndIf
  
  FreeMemory(*lpszBuffer)
Next

NnClose(hLibrary, Socket)
Input()
CloseConsole()
NnDllClose(hLibrary)
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\ReqClient.exe
; CurrentDirectory = ..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
