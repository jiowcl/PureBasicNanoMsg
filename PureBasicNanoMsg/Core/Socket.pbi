;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Prototype Function
PrototypeC.i NnSocketFunc(domain.i, protocol.i)
PrototypeC.i NnCloseFunc(socket.i)
PrototypeC.i NnSetsockoptFunc(socket.i, level.i, option.i, *optval, optvallen.i)
PrototypeC.i NnSetsockoptStrFunc(socket.i, level.i, option.i, optval.p-Ascii, optvallen.i)
PrototypeC.i NnGetsockoptFunc(socket.i, level.i, option.i, *optval, *optvallen)
PrototypeC.i NnBindFunc(socket.i, addr.p-Ascii)
PrototypeC.i NnConnectFunc(socket.i, addr.p-Ascii)
PrototypeC.i NnShutdownFunc(socket.i, how.i)
PrototypeC.i NnSendFunc(socket.i, *buf, leng.i, flags.i)
PrototypeC.i NnSendStrFunc(socket.i, buf.p-Ascii, leng.i, flags.i)
PrototypeC.i NnRecvFunc(socket.i, *buf, len.i, flags.i)
PrototypeC.i NnPollFunc(*fds, nfds.i, timeout.i)
PrototypeC.q NnGetStatisticFunc(socket.i, stat.i)

; Nanomsg Function Declare

; <summary>
; NnSocket
; </summary>
; <param name="dllInstance">integer</param>
; <param name="domain">integer</param>
; <param name="protocol">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnSocket(dllInstance.i, domain.i, protocol.i)
  Protected.i lResult = -1
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
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnClose(dllInstance.i, socket.i)
  Protected.i lResult = -1
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
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="level">integer</param>
; <param name="option">integer</param>
; <param name="optval">pointer</param>
; <param name="optvallen">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnSetsockopt(dllInstance.i, socket.i, level.i, option.i, *optval, optvallen.i)
  Protected.i lResult = -1
  Protected.NnSetsockoptFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_setsockopt")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, level, option, *optval, optvallen)
    EndIf
  EndIf  
  
  ProcedureReturn lResult
EndProcedure  

; <summary>
; NnSetsockoptString
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="level">integer</param>
; <param name="option">integer</param>
; <param name="optval">string</param>
; <returns>Returns integer.</returns>
Procedure.i NnSetsockoptString(dllInstance.i, socket.i, level.i, option.i, optval.s)
  Protected.i lResult = -1
  Protected.NnSetsockoptStrFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_setsockopt")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, level, option, optval, Len(optval))
    EndIf
  EndIf  
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnSetsockoptInt
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="level">integer</param>
; <param name="option">integer</param>
; <param name="optval">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnSetsockoptInt(dllInstance.i, socket.i, level.i, option.i, optval.i)
  Protected.l value = optval
  
  ProcedureReturn NnSetsockopt(dllInstance, socket, level, option, @value, SizeOf(Long))
EndProcedure

; <summary>
; NnGetsockopt
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="level">integer</param>
; <param name="option">integer</param>
; <param name="optval">pointer</param>
; <param name="optvallen">pointer</param>
; <returns>Returns integer.</returns>
Procedure.i NnGetsockopt(dllInstance.i, socket.i, level.i, option.i, *optval, *optvallen)
  Protected.i lResult = -1
  Protected.NnGetsockoptFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_getsockopt")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, level, option, *optval, *optvallen)
    EndIf
  EndIf  
  
  ProcedureReturn lResult
EndProcedure  

; <summary>
; NnGetsockoptInt
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="level">integer</param>
; <param name="option">integer</param>
; <param name="optval">pointer</param>
; <returns>Returns integer.</returns>
Procedure.i NnGetsockoptInt(dllInstance.i, socket.i, level.i, option.i, *optval.Long)
  Protected.i optvallen = SizeOf(Long)
  
  ProcedureReturn NnGetsockopt(dllInstance, socket, level, option, *optval, @optvallen)
EndProcedure

; <summary>
; NnBind
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="addr">string</param>
; <returns>Returns integer.</returns>
Procedure.i NnBind(dllInstance.i, socket.i, addr.s)
  Protected.i lResult = -1
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
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="addr">string</param>
; <returns>Returns integer.</returns>
Procedure.i NnConnect(dllInstance.i, socket.i, addr.s)
  Protected.i lResult = -1
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
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="how">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnShutdown(dllInstance.i, socket.i, how.i)
  Protected.i lResult = -1
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
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="buf">pointer</param>
; <param name="len">integer</param>
; <param name="flags">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnSend(dllInstance.i, socket.i, *buf, len.i, flags.i)
  Protected.i lResult = -1
  Protected.NnSendFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_send")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, *buf, len, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnSendString
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="buf">string</param>
; <param name="len">integer</param>
; <param name="flags">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnSendString(dllInstance.i, socket.i, buf.s, len.i, flags.i)
  Protected.i lResult = -1
  Protected.NnSendStrFunc pFuncCall
  
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
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="buf">pointer</param>
; <param name="len">integer</param>
; <param name="flags">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnRecv(dllInstance.i, socket.i, *buf, len.i, flags.i)
  Protected.i lResult = -1
  Protected.NnRecvFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_recv")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, *buf, len, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnPoll
; </summary>
; <param name="dllInstance">integer</param>
; <param name="fds">pointer</param>
; <param name="nfds">integer</param>
; <param name="timeout">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnPoll(dllInstance.i, *fds, nfds.i, timeout.i)
  Protected.i lResult = -1
  Protected.NnPollFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_poll")
    
    If pFuncCall > 0
      lResult = pFuncCall(*fds, nfds, timeout)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnGetStatistic
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="stat">integer</param>
; <returns>Returns quad.</returns>
Procedure.q NnGetStatistic(dllInstance.i, socket.i, stat.i)
  Protected.q lResult
  Protected.NnGetStatisticFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nn_get_statistic")
    
    If pFuncCall > 0
      lResult = pFuncCall(socket, stat)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 59
; FirstLine = 18
; Folding = ---
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField4 = 1.0.0
