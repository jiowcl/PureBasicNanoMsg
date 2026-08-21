;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

IncludeFile "FuncTable.pbi"

; Nanomsg Function Declare

; <summary>
; NnAllocmsg
; </summary>
; <param name="dllInstance">integer</param>
; <param name="size">integer</param>
; <param name="type">integer</param>
; <returns>Returns pointer.</returns>
Procedure.i NnAllocmsg(dllInstance.i, size.i, type.i = 0)
  Protected.i lResult
  Protected.NnAllocmsgFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_allocmsg
    
    If pFuncCall
      lResult = pFuncCall(size, type)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnReallocmsg
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">pointer</param>
; <param name="size">integer</param>
; <returns>Returns pointer.</returns>
Procedure.i NnReallocmsg(dllInstance.i, *msg, size.i)
  Protected.i lResult
  Protected.NnReallocmsgFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_reallocmsg
    
    If pFuncCall
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnFreemsg
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">pointer</param>
; <returns>Returns integer.</returns>
Procedure.i NnFreemsg(dllInstance.i, *msg)
  Protected.i lResult = -1
  Protected.NnFreemsgFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_freemsg
    
    If pFuncCall
      lResult = pFuncCall(*msg)
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
; VersionField3 = PureBasicNanoMsg
; VersionField4 = 1.0.0
