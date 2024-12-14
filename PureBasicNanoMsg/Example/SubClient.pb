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

Global lpszServerAddr.s = "tcp://localhost:1689"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary
  OpenConsole()
  
  Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_SUB)
  Define Rc.i = NnConnect(hLibrary, Socket, lpszServerAddr)
  
  Define lpszSubscribe.s = "quotes"
  
  NnSetsockopt(hLibrary, Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe, Len(lpszSubscribe))
  
;   Define i.i
;
;   For i = 0 To 10 
;     Define *lpszBuffer = AllocateMemory(32)
;     
;     NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
;     
;     PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
;     
;     FreeMemory(*lpszBuffer)
;   Next
  
  While 1
    Define *lpszBuffer = AllocateMemory(32)
    
    NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
    
    FreeMemory(*lpszBuffer)
    
    Delay(10)
  Wend   
  
  NnClose(hLibrary, Socket)
  
  Input()
  CloseConsole()
  
  NnDllClose(hLibrary)
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 46
; FirstLine = 4
; Folding = -
; EnableXP
; Executable = ..\SubClient.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com