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

Global lpszServerAddr.s = "tcp://*:1689"

If DllOpen(lpszLibNnDll) = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_PUB)

If Socket < 0
  PrintN("Socket failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  CloseConsole()
  DllClose()
  End 1
EndIf

Define Rc.i = NanomsgSocket::Bind(Socket, lpszServerAddr)

If Rc < 0
  PrintN("Bind failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

PrintN("Bind an IP address: " + lpszServerAddr)

While 1
  Define lpszTopic.s = "quotes"
  ; Prefix must match NN_SUB_SUBSCRIBE filter on the subscriber.
  Define lpszMessage.s = lpszTopic + "#Bid:" + Random(9000, 1000) + ",Ask:" + Random(9000, 1000)
  
  Rc = NanomsgSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0)
  
  If Rc >= 0
    PrintN("Published: " + lpszMessage)
  Else
    PrintN("Send failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  EndIf
  
  Delay(500)
Wend

NanomsgSocket::Close(Socket)
CloseConsole()
DllClose()
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Executable = ..\..\ModulePubServer.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
