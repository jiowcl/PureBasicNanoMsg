;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Prototype Function
PrototypeC.i NnErrnoFunc()
PrototypeC.i NnStrerrorFunc(errnum.i)
PrototypeC.i NnSymbolFunc(index.i, *value.Long)

; Zmq Function Declare

; <summary>
; NnErrno
; </summary>
; <param name="dllInstance"></param>
; <returns>Returns integer.</returns>
Procedure.i NnErrno(dllInstance.i)
  Protected.i lResult
  Protected.NnErrnoFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_errno")
    
    If pFuncCall > 0
      lResult = pFuncCall()
    EndIf  
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnStrerror
; </summary>
; <param name="dllInstance"></param>
; <param name="errnum"></param>
; <returns>Returns string.</returns>
Procedure.s NnStrerror(dllInstance.i, errnum.i)
  Protected.s lResult
  Protected.NnStrerrorFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_strerror")
    
    If pFuncCall > 0
      lResult = PeekS(pFuncCall(errnum), -1, #PB_UTF8)
    EndIf  
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnSymbol
; </summary>
; <param name="dllInstance"></param>
; <param name="index"></param>
; <param name="value"></param>
; <returns>Returns string.</returns>
Procedure.s NnSymbol(dllInstance.i, index.i, *value.Long)
  Protected.s lResult
  Protected.NnSymbolFunc pFuncCall
  Protected.i lNnSymbolResult
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_symbol")
    
    If pFuncCall > 0
      lNnSymbolResult = pFuncCall(index, *value)
      
      If lNnSymbolResult > 0
        lResult = PeekS(lNnSymbolResult, -1, #PB_UTF8)
      EndIf  
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 72
; FirstLine = 22
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField4 = 1.0.0