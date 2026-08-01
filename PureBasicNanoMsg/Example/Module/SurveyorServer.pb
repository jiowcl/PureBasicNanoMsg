;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NanomsgWrapper.pbi"

UseModule NanomsgWrapper

Global lpszCurrentDir.s = GetCurrentDirectory()

; Nanomsg version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNnDir.s = "Library/x64"
  Global lpszLibNnDll.s = lpszCurrentDir + lpszLibNnDir + "/nanomsg.dll"
  
  SetCurrentDirectory(lpszCurrentDir + lpszLibNnDir)
CompilerElse
  CompilerError "Only x64 nanomsg.dll is bundled."
CompilerEndIf

Global lpszServerAddr.s = "tcp://*:1702"

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_SURVEYOR)
  Define Rc.i
  
  ; Wait up to 2000 ms for respondent replies after each survey.
  Rc = NanomsgSocket::SetsockoptInt(Socket, #NN_SURVEYOR, #NN_SURVEYOR_DEADLINE, 2000)
  Rc = NanomsgSocket::Bind(Socket, lpszServerAddr)
  
  PrintN("Bind an IP address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1
    
    Define lpszSurvey.s = "Survey #" + lTotal
    
    NanomsgSocket::SendString(Socket, lpszSurvey, Len(lpszSurvey), 0)
    PrintN("Survey sent: " + lpszSurvey)
    
    ; Collect responses until the survey deadline (ETIMEDOUT).
    While 1
      Define *lpszBuffer = AllocateMemory(256)
      Define recvRc.i = NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
      
      If recvRc >= 0
        PrintN("Response: " + PeekS(*lpszBuffer, -1, #PB_UTF8))
        FreeMemory(*lpszBuffer)
      Else
        Define err.i = NanomsgRuntime::Errno()
        
        If err = #ETIMEDOUT
          PrintN("Survey deadline reached (ETIMEDOUT).")
        ElseIf err = #EFSM
          PrintN("No survey pending (EFSM).")
        Else
          PrintN("Recv error: " + NanomsgRuntime::Strerror(err))
        EndIf
        
        FreeMemory(*lpszBuffer)
        Break
      EndIf
    Wend
    
    Delay(1000)
  Wend
  
  NanomsgSocket::Close(Socket)
  
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
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
