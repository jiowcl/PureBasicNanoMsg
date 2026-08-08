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

Global lpszServerAddr.s = "tcp://localhost:1702"

If DllOpen(lpszLibNngDll)
  OpenConsole()
  
  Define Socket.i = NngSocket::RespondentOpen()
  Define Rc.i = NngSocket::Dial(Socket, lpszServerAddr)
  
  PrintN("Dial Surveyor: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    
    If NngSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0) >= 0
      lTotal = lTotal + 1
      
      PrintN("Survey: " + PeekS(*lpszBuffer, -1, #PB_UTF8))
      
      Define lpszReply.s = "Reply #" + lTotal + " from respondent"
      
      NngSocket::SendString(Socket, lpszReply, Len(lpszReply), 0)
      PrintN("Responded: " + lpszReply)
    EndIf
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NngSocket::Close(Socket)
  
  Input()
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\..\ModuleRespondentClient.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
