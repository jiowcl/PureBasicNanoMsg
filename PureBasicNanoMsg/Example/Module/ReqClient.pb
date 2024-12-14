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

Global lpszServerAddr.s = "tcp://localhost:1700"

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_REQ)
  Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)
  
  PrintN("Connect to Server: " + lpszServerAddr)
  
  Define i.i
  
  For i = 0 To 10 
    Define *lpszBuffer = AllocateMemory(32)
    Define lpszMessage.s = "From Client"
    
    NanomsgSocket::Send(Socket, lpszMessage, Len(lpszMessage), 0)
    NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    PrintN("Reply From Server: ")
    PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
    
    FreeMemory(*lpszBuffer)
  Next 
  
  NanomsgSocket::Close(Socket)
  
  Input()
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; Folding = -
; EnableXP
; Executable = ..\..\ModuleReqClient.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com