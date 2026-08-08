;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Prototype Function
PrototypeC.i NngInitFunc(*params)
PrototypeC NngFiniFunc()
PrototypeC.i NngStrerrorFunc(errnum.i)

; NNG Function Declare

; <summary>
; NngInit
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngInit(dllInstance.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngInitFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_init")
    
    If pFuncCall > 0
      ; Pass NULL for default init parameters.
      lResult = pFuncCall(0)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngFini
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NngFini(dllInstance.i)
  Protected.NngFiniFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_fini")
    
    If pFuncCall > 0
      pFuncCall()
      ProcedureReturn #True
    EndIf
  EndIf
  
  ProcedureReturn #False
EndProcedure

; <summary>
; NngStrerror
; </summary>
; <param name="dllInstance">integer</param>
; <param name="errnum">integer</param>
; <returns>Returns string.</returns>
Procedure.s NngStrerror(dllInstance.i, errnum.i)
  Protected.s lResult
  Protected.NngStrerrorFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_strerror")
    
    If pFuncCall > 0
      lResult = PeekS(pFuncCall(errnum), -1, #PB_UTF8)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField4 = 1.0.0
