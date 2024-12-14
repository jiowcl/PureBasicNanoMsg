;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Prototype Function
PrototypeC.i NnSocketFunc(domain.i, protocol.i)
PrototypeC.i NnCloseFunc(socket.i)
PrototypeC.i NnSetsockoptFunc(socket.i, level.i, option.i, optval.p-Ascii, optvallen.i)
PrototypeC.i NnGetsockoptFunc(socket.i, level.i, option.i, *optval.p-Ascii, optvallen.i)
PrototypeC.i NnBindFunc(socket.i, addr.p-Ascii)
PrototypeC.i NnConnectFunc(socket.i, addr.p-Ascii)
PrototypeC.i NnShutdownFunc(socket.i, how.i)
PrototypeC.i NnSendFunc(socket.i, buf.p-Ascii, leng.i, flags.i)
PrototypeC.i NnRecvFunc(socket.i, *buf.p-Ascii, len.i, flags.i)

; Nanomsg Function Declare

; <summary>
; NnSocket
; </summary>
; <param name="dllInstance"></param>
; <param name="domain"></param>
; <param name="protocol"></param>
; <returns>Returns integer.</returns>
Procedure.i NnSocket(dllInstance.i, domain.i, protocol.i)
  Protected.i lResult
  Protected.NnSocketFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_socket")
    
    If pFuncCall > 0
      lResult = pFuncCall(domain, protocol)
    EndIf
  EndIf
    
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnClose
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <returns>Returns integer.</returns>
Procedure.i NnClose(dllInstance.i, socket.i)
  Protected.i lResult
  Protected.NnCloseFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_close")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnSetsockopt
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <param name="level"></param>
; <param name="option"></param>
; <param name="optval"></param>
; <param name="optvallen"></param>
; <returns>Returns integer.</returns>
Procedure.i NnSetsockopt(dllInstance.i, socket.i, level.i, option.i, optval.s, optvallen.i)
  Protected.i lResult
  Protected.NnSetsockoptFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_setsockopt")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, level, option, optval, optvallen)
    EndIf
  EndIf  
  
  ProcedureReturn lResult
EndProcedure  

; <summary>
; NnGetsockopt
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <param name="level"></param>
; <param name="option"></param>
; <param name="optval"></param>
; <param name="optvallen"></param>
; <returns>Returns integer.</returns>
Procedure.i NnGetsockopt(dllInstance.i, socket.i, level.i, option.i, *optval, optvallen.i)
  Protected.i lResult
  Protected.NnGetsockoptFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_getsockopt")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, level, option, *optval, optvallen)
    EndIf
  EndIf  
  
  ProcedureReturn lResult
EndProcedure  

; <summary>
; NnBind
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <param name="addr"></param>
; <returns>Returns integer.</returns>
Procedure.i NnBind(dllInstance.i, socket.i, addr.s)
  Protected.i lResult
  Protected.NnBindFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_bind")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, addr)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnConnect
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <param name="addr"></param>
; <returns>Returns integer.</returns>
Procedure.i NnConnect(dllInstance.i, socket.i, addr.s)
  Protected.i lResult
  Protected.NnConnectFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_connect")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, addr)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnShutdown
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <param name="how"></param>
; <returns>Returns integer.</returns>
Procedure.i NnShutdown(dllInstance.i, socket.i, how.i)
  Protected.i lResult
  Protected.NnShutdownFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_shutdown")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, how)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnSend
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <param name="buf"></param>
; <param name="len"></param>
; <param name="flags"></param>
; <returns>Returns integer.</returns>
Procedure.i NnSend(dllInstance.i, socket.i, buf.s, len.i, flags.i)
  Protected.i lResult
  Protected.NnSendFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_send")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, buf, len, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnRecv
; </summary>
; <param name="dllInstance"></param>
; <param name="socket"></param>
; <param name="buf"></param>
; <param name="len"></param>
; <param name="flags"></param>
; <returns>Returns integer.</returns>
Procedure.i NnRecv(dllInstance.i, socket.i, *buf.String, len.i, flags.i)
  Protected.i lResult
  Protected.NnRecvFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_recv")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, *buf, len, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 59
; FirstLine = 18
; Folding = ---
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField4 = 1.0.0