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

Global lpszServerAddr.s = "tcp://localhost:1703"

If DllOpen(lpszLibNnDll) = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_BUS)

If Socket < 0
  PrintN("Socket failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  CloseConsole()
  DllClose()
  End 1
EndIf

Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)

If Rc < 0
  PrintN("Connect failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

PrintN("Bus node B connected: " + lpszServerAddr)

Define lTotal.l = 0
Dim fds.NnPollFd(0)

While 1
  fds(0)\fd = Socket
  fds(0)\events = #NN_POLLIN
  fds(0)\revents = 0
  
  Rc = NanomsgSocket::Poll(@fds(0), 1, 500)
  
  If Rc < 0
    PrintN("Poll failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  ElseIf Rc > 0 And (fds(0)\revents & #NN_POLLIN)
    Define *lpszBuffer = AllocateMemory(256)
    Define recvRc.i = NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    If recvRc >= 0
      PrintN("Received: " + PeekS(*lpszBuffer, recvRc, #PB_Ascii))
    Else
      PrintN("Recv failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    EndIf
    
    FreeMemory(*lpszBuffer)
  Else
    lTotal = lTotal + 1
    
    Define lpszMessage.s = "From BusB #" + lTotal
    
    If NanomsgSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0) < 0
      PrintN("Send failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
    Else
      PrintN("Sent: " + lpszMessage)
    EndIf
  EndIf
Wend

NanomsgSocket::Close(Socket)
Input()
CloseConsole()
DllClose()
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Executable = ..\..\ModuleBusClient.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
