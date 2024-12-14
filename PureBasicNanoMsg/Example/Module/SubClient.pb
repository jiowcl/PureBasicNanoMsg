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

Global lpszServerAddr.s = "tcp://localhost:1689"

If DllOpen(lpszLibNnDll)
  OpenConsole()

  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_SUB)
  Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)
  
  Define lpszSubscribe.s = "quotes"
  
  NanomsgSocket::Setsockopt(Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe, Len(lpszSubscribe))
  
;   Define i.i
;
;   For i = 0 To 10 
;     *lpszBuffer = AllocateMemory(32)
;     
;     NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
;     
;     PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
;     
;     FreeMemory(*lpszBuffer)
;   Next
  
  While 1
    Define *lpszBuffer = AllocateMemory(32)
    
    NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
    
    FreeMemory(*lpszBuffer)
    
    Delay(10)
  Wend   
  
  NanomsgSocket::Close(Socket)
  
  Input()
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 47
; FirstLine = 8
; Folding = -
; EnableXP
; Executable = ..\..\ModuleSubClient.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com