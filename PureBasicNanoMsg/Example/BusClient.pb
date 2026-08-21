;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../Core/Nanomsg.pbi"

Global lpszCurrentDir.s = GetCurrentDirectory()

; Nanomsg version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNnDir.s = "Library/x64"
  Global lpszLibNnDll.s = lpszCurrentDir + lpszLibNnDir + "/nanomsg.dll"
  
  SetCurrentDirectory(lpszCurrentDir + lpszLibNnDir)
CompilerElse
  CompilerError "Only x64 nanomsg.dll is bundled."
CompilerEndIf

; Bus node B connects to node A.
Global lpszServerAddr.s = "tcp://localhost:1703"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary
  OpenConsole()
  
  Define Socket.i = NnSocket(hLibrary, #AF_SP, #NN_BUS)
  Define Rc.i = NnConnect(hLibrary, Socket, lpszServerAddr)
  
  If Rc < 0
    PrintN("Connect failed: " + NnStrerror(hLibrary, NnErrno(hLibrary)))
  Else
    PrintN("Bus node B connected: " + lpszServerAddr)
  EndIf
  
  Define lTotal.l = 0
  Dim fds.NnPollFd(0)
  
  While 1
    fds(0)\fd = Socket
    fds(0)\events = #NN_POLLIN
    fds(0)\revents = 0
    
    Rc = NnPoll(hLibrary, @fds(0), 1, 500)
    
    If Rc > 0 And (fds(0)\revents & #NN_POLLIN)
      Define *lpszBuffer = AllocateMemory(256)
      Define recvRc.i = NnRecv(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
      
      If recvRc >= 0
        PrintN("Received: " + PeekS(*lpszBuffer, recvRc, #PB_Ascii))
      EndIf
      
      FreeMemory(*lpszBuffer)
    Else
      ; Poll timeout: publish a bus message (not delivered back to self).
      lTotal = lTotal + 1
      
      Define lpszMessage.s = "From BusB #" + lTotal
      
      If NnSendString(hLibrary, Socket, lpszMessage, Len(lpszMessage), 0) >= 0
        PrintN("Sent: " + lpszMessage)
      EndIf
    EndIf
  Wend
  
  NnClose(hLibrary, Socket)
  
  Input()
  CloseConsole()
  
  NnDllClose(hLibrary)
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\BusClient.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
