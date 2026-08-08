;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../Core/Nng.pbi"

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

Global hLibrary.i = NngDllOpen(lpszLibNngDll)

If hLibrary And NngInit(hLibrary) = #NNG_OK
  OpenConsole()
  
  Define Socket.l
  Define Rc.i = NngPull0Open(hLibrary, @Socket)
  
  If Rc = #NNG_OK
    Rc = NngDial(hLibrary, Socket, lpszServerAddr)
  EndIf
  
  PrintN("Dial Server: " + lpszServerAddr)
  
  ; Use recv timeout instead of nn_poll (nng has no nn_poll equivalent).
  NngSocketSetMs(hLibrary, Socket, #NNG_OPT_RECVTIMEO, 1000)
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    Define recvRc.i = NngRecvBuffer(hLibrary, Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    If recvRc >= 0
      PrintN("Pulled: " + PeekS(*lpszBuffer, recvRc, #PB_UTF8))
    EndIf
    
    FreeMemory(*lpszBuffer)
  Wend
  
  NngSocketClose(hLibrary, Socket)
  
  Input()
  CloseConsole()
  
  NngFini(hLibrary)
  NngDllClose(hLibrary)
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; Executable = ..\PullClient.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
