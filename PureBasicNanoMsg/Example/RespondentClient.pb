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

Global lpszServerAddr.s = "tcp://localhost:1702"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary
  OpenConsole()
  
  Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_RESPONDENT)
  Define Rc.i = NnConnect(hLibrary, Socket, lpszServerAddr)
  
  PrintN("Connect to Surveyor: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    
    If NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0) >= 0
      lTotal = lTotal + 1
      
      PrintN("Survey: " + PeekS(*lpszBuffer, -1, #PB_UTF8))
      
      Define lpszReply.s = "Reply #" + lTotal + " from respondent"
      
      NnSendString(hLibrary, Socket, lpszReply, Len(lpszReply), 0)
      PrintN("Responded: " + lpszReply)
    EndIf
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NnClose(hLibrary, Socket)
  
  Input()
  CloseConsole()
  
  NnDllClose(hLibrary)
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\RespondentClient.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
