;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

IncludeFile "FuncTable.pbi"

; Nanomsg Function Declare

; <summary>
; NnErrno
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnErrno(dllInstance.i)
  Protected.i lResult
  Protected.NnErrnoFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_errno
    
    If pFuncCall
      lResult = pFuncCall()
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnStrerror
; </summary>
; <param name="dllInstance">integer</param>
; <param name="errnum">integer</param>
; <returns>Returns string.</returns>
Procedure.s NnStrerror(dllInstance.i, errnum.i)
  Protected.s lResult
  Protected.NnStrerrorFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_strerror
    
    If pFuncCall
      lResult = PeekS(pFuncCall(errnum), -1, #PB_UTF8)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnSymbol
; </summary>
; <param name="dllInstance">integer</param>
; <param name="index">integer</param>
; <param name="value">long</param>
; <returns>Returns string.</returns>
Procedure.s NnSymbol(dllInstance.i, index.i, *value.Long)
  Protected.s lResult
  Protected.NnSymbolFunc pFuncCall
  Protected.i lNnSymbolResult
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_symbol
    
    If pFuncCall
      lNnSymbolResult = pFuncCall(index, *value)
      
      If lNnSymbolResult > 0
        lResult = PeekS(lNnSymbolResult, -1, #PB_UTF8)
      EndIf
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NnTerm
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnTerm(dllInstance.i)
  Protected.NnTermFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_term
    
    If pFuncCall
      pFuncCall()
      
      ProcedureReturn #True
    EndIf
  EndIf
  
  ProcedureReturn #False
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField4 = 1.0.0
