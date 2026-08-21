;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

IncludeFile "FuncTable.pbi"

; Function Declare
Declare.i NnDllOpen(lpszDllPath.s)
Declare.i NnDllClose(dllInstance.i)

; <summary>
; NnDllOpen
; </summary>
; <param name="lpszDllPath">string</param>
; <returns>Returns integer.</returns>
Procedure.i NnDllOpen(lpszDllPath.s)
  Protected.i dllInstance = OpenLibrary(#PB_Any, lpszDllPath)
  
  If dllInstance
    NnEnsureFuncs(dllInstance)
  EndIf
  
  ProcedureReturn dllInstance
EndProcedure

; <summary>
; NnDllClose
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnDllClose(dllInstance.i)
  NnClearFuncs(dllInstance)
  
  If IsLibrary(dllInstance)
    CloseLibrary(dllInstance)
  EndIf
  
  ProcedureReturn #True
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField4 = 1.0.0
