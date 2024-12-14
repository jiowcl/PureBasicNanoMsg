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
CompilerEndIf

Global lpszServerAddr.s = "tcp://*:1700"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary
  OpenConsole()
  
  Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_REP)
   
  Define Rc.i = NnBind(hLibrary, Socket, lpszServerAddr)
  
  PrintN("Bind an IP address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1
    
    Define *lpszBuffer = AllocateMemory(32)
    Define lpszMessage.s = "Hi " + lTotal
    
    NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    Delay(10)
    
    PrintN("Received: ")
    PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
    
    NnSend(hLibrary, Socket, lpszMessage, Len(lpszMessage), 0)
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NnClose(hLibrary, Socket)
  
  CloseConsole()
  
  NnDllClose(hLibrary)
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\RepServer.exe
; CurrentDirectory = ..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com