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

Global lpszServerAddr.s = "tcp://localhost:1689"

If DllOpen(lpszLibNngDll)
  OpenConsole()

  Define Socket.i = NngSocket::SubOpen()
  Define Rc.i = NngSocket::Dial(Socket, lpszServerAddr)
  
  Define lpszSubscribe.s = "quotes"
  
  NngSocket::Subscribe(Socket, lpszSubscribe)
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    Define recvRc.i = NngSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    ; nng_recv does not append a null terminator; use the returned length.
    If recvRc >= 0
      PrintN(PeekS(*lpszBuffer, recvRc, #PB_Ascii))
    EndIf
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NngSocket::Close(Socket)
  
  Input()
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 47
; Folding = -
; EnableXP
; Executable = ..\..\ModuleSubClient.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
