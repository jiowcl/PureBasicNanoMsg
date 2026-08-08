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

Global lpszServerAddr.s = "tcp://*:1702"

If DllOpen(lpszLibNngDll)
  OpenConsole()
  
  Define Socket.i = NngSocket::SurveyorOpen()
  Define Rc.i
  
  ; Wait up to 2000 ms for respondent replies after each survey.
  Rc = NngSocket::SetMs(Socket, #NNG_OPT_SURVEYOR_SURVEYTIME, 2000)
  Rc = NngSocket::Listen(Socket, lpszServerAddr)
  
  PrintN("Listen on address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1
    
    Define lpszSurvey.s = "Survey #" + lTotal
    
    NngSocket::SendString(Socket, lpszSurvey, Len(lpszSurvey), 0)
    PrintN("Survey sent: " + lpszSurvey)
    
    ; Collect responses until the survey deadline (NNG_ETIMEDOUT).
    While 1
      Define *lpszBuffer = AllocateMemory(256)
      Define recvRc.i = NngSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
      
      If recvRc >= 0
        PrintN("Response: " + PeekS(*lpszBuffer, recvRc, #PB_UTF8))
        FreeMemory(*lpszBuffer)
      Else
        Define err.i = NngRuntime::LastError()
        
        If err = #NNG_ETIMEDOUT
          PrintN("Survey deadline reached (NNG_ETIMEDOUT).")
        ElseIf err = #NNG_ESTATE
          PrintN("No survey pending (NNG_ESTATE).")
        Else
          PrintN("Recv error: " + NngRuntime::Strerror(err))
        EndIf
        
        FreeMemory(*lpszBuffer)
        Break
      EndIf
    Wend
    
    Delay(1000)
  Wend
  
  NngSocket::Close(Socket)
  
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\..\ModuleSurveyorServer.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
