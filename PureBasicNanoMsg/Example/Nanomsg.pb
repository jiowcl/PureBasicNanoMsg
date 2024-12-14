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
CompilerEndIf

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary
  OpenConsole()
  
  Define errorNo.i
  
  Define nnSymbolIndex.i  
  Define nnSymbolValue.l = 0
  Define nnSymbolName.s
  
  While nnSymbolIndex >= 0
    nnSymbolName = NnSymbol(hLibrary, nnSymbolIndex, @nnSymbolValue)
    
    If Len(nnSymbolName) = 0 
      Break 
    EndIf
    
    PrintN("NanoMsg Symbol: " + nnSymbolName + " " + nnSymbolValue)
    
    errorNo = NnErrno(hLibrary)
    
    nnSymbolIndex = nnSymbolIndex + 1
  Wend  
  
  Input()
  CloseConsole()
  
  NnDllClose(hLibrary)
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 37
; Folding = -
; EnableXP
; Executable = ..\Zmq.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com