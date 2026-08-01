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

Global lpszServerAddr.s = "tcp://*:1701"

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_PUSH)
  Define Rc.i = NanomsgSocket::Bind(Socket, lpszServerAddr)
  
  PrintN("Bind an IP address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1
    
    Define lpszMessage.s = "Task #" + lTotal
    
    NanomsgSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0)
    PrintN("Pushed: " + lpszMessage)
    
    Delay(500)
  Wend
  
  NanomsgSocket::Close(Socket)
  
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\..\ModulePushServer.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
