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

Global lpszServerAddr.s = "tcp://*:1689"

Global hLibrary.i = NngDllOpen(lpszLibNngDll)

If hLibrary And NngInit(hLibrary) = #NNG_OK
  OpenConsole()
  
  Define Socket.l
  Define Rc.i = NngPub0Open(hLibrary, @Socket)
  
  If Rc = #NNG_OK
    Rc = NngListen(hLibrary, Socket, lpszServerAddr)
  EndIf
  
  If Rc <> #NNG_OK
    PrintN("Listen failed: " + NngStrerror(hLibrary, Rc))
  Else
    PrintN("Listen on address: " + lpszServerAddr)
  EndIf
  
  While 1
    Define lpszTopic.s = "quotes"
    ; Prefix must match Subscribe filter on the subscriber.
    Define lpszMessage.s = lpszTopic + "#Bid:" + Random(9000, 1000) + ",Ask:" + Random(9000, 1000)
    
    Rc = NngSendString(hLibrary, Socket, lpszMessage, Len(lpszMessage), 0)
    
    If Rc = #NNG_OK
      PrintN("Published: " + lpszMessage)
    EndIf
    
    Delay(500)
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
; Executable = ..\PubServer.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
