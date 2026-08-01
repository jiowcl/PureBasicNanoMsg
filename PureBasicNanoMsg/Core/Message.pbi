;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Prototype Function
PrototypeC.i NnAllocmsgFunc(size.i, type.i)
PrototypeC.i NnReallocmsgFunc(*msg, size.i)
PrototypeC.i NnFreemsgFunc(*msg)

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
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_allocmsg")
    
    If pFuncCall > 0
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
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_reallocmsg")
    
    If pFuncCall > 0
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
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_freemsg")
    
    If pFuncCall > 0
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
