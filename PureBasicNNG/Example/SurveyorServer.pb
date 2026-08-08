;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../Core/Nng.pbi"

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

Global hLibrary.i = NngDllOpen(lpszLibNngDll)

If hLibrary And NngInit(hLibrary) = #NNG_OK
  OpenConsole()
  
  Define Socket.l
  Define Rc.i = NngSurveyor0Open(hLibrary, @Socket)
  
  ; Wait up to 2000 ms for respondent replies after each survey.
  If Rc = #NNG_OK
    Rc = NngSocketSetMs(hLibrary, Socket, #NNG_OPT_SURVEYOR_SURVEYTIME, 2000)
    Rc = NngListen(hLibrary, Socket, lpszServerAddr)
  EndIf
  
  PrintN("Listen on address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1
    
    Define lpszSurvey.s = "Survey #" + lTotal
    
    NngSendString(hLibrary, Socket, lpszSurvey, Len(lpszSurvey), 0)
    PrintN("Survey sent: " + lpszSurvey)
    
    ; Collect responses until the survey deadline (NNG_ETIMEDOUT).
    While 1
      Define *lpszBuffer = AllocateMemory(256)
      Define sz.i = MemorySize(*lpszBuffer)
      Define recvRc.i = NngRecv(hLibrary, Socket, *lpszBuffer, @sz, 0)
      
      If recvRc = #NNG_OK
        PrintN("Response: " + PeekS(*lpszBuffer, sz, #PB_UTF8))
        FreeMemory(*lpszBuffer)
      Else
        If recvRc = #NNG_ETIMEDOUT
          PrintN("Survey deadline reached (NNG_ETIMEDOUT).")
        ElseIf recvRc = #NNG_ESTATE
          PrintN("No survey pending (NNG_ESTATE).")
        Else
          PrintN("Recv error: " + NngStrerror(hLibrary, recvRc))
        EndIf
        
        FreeMemory(*lpszBuffer)
        Break
      EndIf
    Wend
    
    Delay(1000)
  Wend
  
  NngSocketClose(hLibrary, Socket)
  
  CloseConsole()
  
  NngFini(hLibrary)
  NngDllClose(hLibrary)
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; Executable = ..\SurveyorServer.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
