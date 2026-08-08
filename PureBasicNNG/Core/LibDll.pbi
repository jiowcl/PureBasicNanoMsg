;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Function Declare
Declare.i NngDllOpen(lpszDllPath.s)
Declare.i NngDllClose(dllInstance.i)

; <summary>
; NngDllOpen
; </summary>
; <param name="lpszDllPath">string</param>
; <returns>Returns integer.</returns>
Procedure.i NngDllOpen(lpszDllPath.s)
  ProcedureReturn OpenLibrary(#PB_Any, lpszDllPath)
EndProcedure

; <summary>
; NngDllClose
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NngDllClose(dllInstance.i)
  If IsLibrary(dllInstance)
    CloseLibrary(dllInstance)
  EndIf
  
  ProcedureReturn #True
EndProcedure
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField4 = 1.0.0
