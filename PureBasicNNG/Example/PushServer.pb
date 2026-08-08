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

Global lpszServerAddr.s = "tcp://*:1701"

Global hLibrary.i = NngDllOpen(lpszLibNngDll)

If hLibrary And NngInit(hLibrary) = #NNG_OK
  OpenConsole()
  
  Define Socket.l
  Define Rc.i = NngPush0Open(hLibrary, @Socket)
  
  If Rc = #NNG_OK
    Rc = NngListen(hLibrary, Socket, lpszServerAddr)
  EndIf
  
  PrintN("Listen on address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1
    
    Define lpszMessage.s = "Task #" + lTotal
    
    NngSendString(hLibrary, Socket, lpszMessage, Len(lpszMessage), 0)
    PrintN("Pushed: " + lpszMessage)
    
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
; Executable = ..\PushServer.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
