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
CompilerEndIf

Global lpszServerAddr.s = "tcp://*:1700"

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_REP)
  Define Rc.i = NanomsgSocket::Bind(Socket, lpszServerAddr)
  
  PrintN("Bind an IP address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1

    Define *lpszBuffer = AllocateMemory(32)
    Define lpszMessage.s = "Hi " + lTotal
    
    NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    Delay(10)
    
    PrintN("Received: ")
    PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
    
    NanomsgSocket::Send(Socket, lpszMessage, Len(lpszMessage), 0)
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NanomsgSocket::Close(Socket)
  
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 1
; Folding = -
; EnableXP
; Executable = ..\..\ModuleRepServer.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com