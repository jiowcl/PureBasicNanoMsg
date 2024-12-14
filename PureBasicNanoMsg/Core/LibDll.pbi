;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Function Declare
Declare.i NnDllOpen(lpszDllPath.s)
Declare.i NnDllClose(dllInstance.i)

; <summary>
; NnDllOpen
; </summary>
; <param name="lpszDllPath"></param>
; <returns>Returns integer.</returns>
Procedure.i NnDllOpen(lpszDllPath.s)
  ProcedureReturn OpenLibrary(#PB_Any, lpszDllPath)
EndProcedure

; <summary>
; NnDllClose
; </summary>
; <param name="dllInstance"></param>
; <returns>Returns integer.</returns>
Procedure.i NnDllClose(dllInstance.i)
  If IsLibrary(dllInstance)
    CloseLibrary(dllInstance)
  EndIf
  
  ProcedureReturn #True
EndProcedure
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 11
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField4 = 1.0.0