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

Global lpszServerAddr.s = "tcp://localhost:1689"

If DllOpen(lpszLibNnDll)
  OpenConsole()

  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_SUB)
  Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)
  
  Define lpszSubscribe.s = "quotes"
  
  NanomsgSocket::SetsockoptString(Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe)
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    
    If NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0) >= 0
      PrintN(PeekS(*lpszBuffer, -1, #PB_UTF8))
    EndIf
    
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
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
