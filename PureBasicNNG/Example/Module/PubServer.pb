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

Global lpszServerAddr.s = "tcp://*:1689"

If DllOpen(lpszLibNngDll)
  OpenConsole()
  
  Define Socket.i = NngSocket::PubOpen()
  Define Rc.i = NngSocket::Listen(Socket, lpszServerAddr)
  
  If Rc <> #NNG_OK
    PrintN("Listen failed: " + NngRuntime::Strerror(Rc))
  Else
    PrintN("Listen on address: " + lpszServerAddr)
  EndIf
  
  While 1
    Define lpszTopic.s = "quotes"
    ; Prefix must match Subscribe filter on the subscriber.
    Define lpszMessage.s = lpszTopic + "#Bid:" + Random(9000, 1000) + ",Ask:" + Random(9000, 1000)
    
    Rc = NngSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0)
    
    If Rc = #NNG_OK
      PrintN("Published: " + lpszMessage)
    EndIf
    
    Delay(500)
  Wend
  
  NngSocket::Close(Socket)
  
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 47
; Folding = -
; EnableXP
; Executable = ..\..\ModulePubServer.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
