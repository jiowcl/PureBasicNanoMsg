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

Global lpszServerAddr.s = "tcp://localhost:1701"

If DllOpen(lpszLibNngDll)
  OpenConsole()
  
  Define Socket.i = NngSocket::PullOpen()
  Define Rc.i = NngSocket::Dial(Socket, lpszServerAddr)
  
  PrintN("Dial Server: " + lpszServerAddr)
  
  ; Use recv timeout instead of nn_poll (nng has no nn_poll equivalent).
  NngSocket::SetMs(Socket, #NNG_OPT_RECVTIMEO, 1000)
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    Define recvRc.i = NngSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    If recvRc >= 0
      PrintN("Pulled: " + PeekS(*lpszBuffer, recvRc, #PB_UTF8))
    ElseIf NngRuntime::LastError() <> #NNG_ETIMEDOUT
      PrintN("Recv error: " + NngRuntime::Strerror(NngRuntime::LastError()))
    EndIf
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NngSocket::Close(Socket)
  
  Input()
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\..\ModulePullClient.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
