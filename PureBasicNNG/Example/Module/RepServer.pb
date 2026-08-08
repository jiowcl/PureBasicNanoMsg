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

Global lpszServerAddr.s = "tcp://*:1700"

If DllOpen(lpszLibNngDll)
  OpenConsole()
  
  Define Socket.i = NngSocket::RepOpen()
  Define Rc.i = NngSocket::Listen(Socket, lpszServerAddr)
  
  PrintN("Listen on address: " + lpszServerAddr)
  
  Define lTotal.l = 0
  
  While 1
    lTotal = lTotal + 1

    Define *lpszBuffer = AllocateMemory(256)
    Define lpszMessage.s = "Hi " + lTotal
    
    If NngSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0) >= 0
      PrintN("Received: ")
      PrintN(PeekS(*lpszBuffer, -1, #PB_UTF8))
      
      NngSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0)
    EndIf
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NngSocket::Close(Socket)
  
  CloseConsole()
  
  DllClose()
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; Folding = -
; EnableXP
; Executable = ..\..\ModuleRepServer.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
