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

If hLibrary
  OpenConsole()
  
  Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_SUB)
  Define Rc.i = NnConnect(hLibrary, Socket, lpszServerAddr)
  
  Define lpszSubscribe.s = "quotes"
  
  NnSetsockoptString(hLibrary, Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe)
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    Define recvRc.i = NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    ; nn_recv does not append a null terminator; use the returned length.
    If recvRc >= 0
      PrintN(PeekS(*lpszBuffer, recvRc, #PB_Ascii))
    EndIf
    
    FreeMemory(*lpszBuffer)
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
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
