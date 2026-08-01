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

Global lpszServerAddr.s = "tcp://localhost:1701"

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_PULL)
  Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)
  
  PrintN("Connect to Server: " + lpszServerAddr)
  
  Dim fds.NnPollFd(0)
  
  While 1
    fds(0)\fd = Socket
    fds(0)\events = #NN_POLLIN
    fds(0)\revents = 0
    
    If NanomsgSocket::Poll(@fds(0), 1, 1000) > 0
      If fds(0)\revents & #NN_POLLIN
        Define *lpszBuffer = AllocateMemory(256)
        
        If NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0) >= 0
          PrintN("Pulled: " + PeekS(*lpszBuffer, -1, #PB_UTF8))
        EndIf
        
        FreeMemory(*lpszBuffer)
      EndIf
    EndIf
  Wend
  
  NanomsgSocket::Close(Socket)
  
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
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
