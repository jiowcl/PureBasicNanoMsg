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

Global lpszServerAddr.s = "tcp://*:1702"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_SURVEYOR)

If Socket < 0
  PrintN("Socket failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  CloseConsole()
  NnDllClose(hLibrary)
  End 1
EndIf

Define Rc.i

; Wait up to 2000 ms for respondent replies after each survey.
Rc = NnSetsockoptInt(hLibrary, Socket, #NN_SURVEYOR, #NN_SURVEYOR_DEADLINE, 2000)

If Rc < 0
  PrintN("Setsockopt deadline failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  NnClose(hLibrary, Socket)
  CloseConsole()
  NnDllClose(hLibrary)
  End 1
EndIf

Rc = NnBind(hLibrary, Socket, lpszServerAddr)

If Rc < 0
  PrintN("Bind failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  NnClose(hLibrary, Socket)
  CloseConsole()
  NnDllClose(hLibrary)
  End 1
EndIf

PrintN("Bind an IP address: " + lpszServerAddr)

Define lTotal.l = 0

While 1
  lTotal = lTotal + 1
  
  Define lpszSurvey.s = "Survey #" + lTotal
  
  If NnSendString(hLibrary, Socket, lpszSurvey, Len(lpszSurvey), 0) < 0
    PrintN("Send failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  Else
    PrintN("Survey sent: " + lpszSurvey)
    
    ; Collect responses until the survey deadline (ETIMEDOUT).
    While 1
      Define *lpszBuffer = AllocateMemory(256)
      Define recvRc.i = NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
      
      If recvRc >= 0
        PrintN("Response: " + PeekS(*lpszBuffer, recvRc, #PB_Ascii))
        FreeMemory(*lpszBuffer)
      Else
        Define err.i = NnErrno(hLibrary)
        
        If err = #ETIMEDOUT
          PrintN("Survey deadline reached (ETIMEDOUT).")
        ElseIf err = #EFSM
          PrintN("No survey pending (EFSM).")
        Else
          PrintN("Recv error: " + NnStrerror(hLibrary, err))
        EndIf
        
        FreeMemory(*lpszBuffer)
        Break
      EndIf
    Wend
  EndIf
  
  Delay(1000)
Wend

NnClose(hLibrary, Socket)
CloseConsole()
NnDllClose(hLibrary)
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\SurveyorServer.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
