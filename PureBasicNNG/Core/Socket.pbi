;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Prototype Function
; nng_socket / nng_dialer / nng_listener are single uint32_t wrappers;
; Win64 passes them by value as a 32-bit integer (Long).
PrototypeC.i NngOpenFunc(*sock.Long)
PrototypeC.i NngSocketCloseFunc(sock.l)
PrototypeC.i NngListenFunc(sock.l, addr.p-Ascii, *listener.Long, flags.i)
PrototypeC.i NngDialFunc(sock.l, addr.p-Ascii, *dialer.Long, flags.i)
PrototypeC.i NngSendFunc(sock.l, *buf, leng.i, flags.i)
PrototypeC.i NngSendStrFunc(sock.l, buf.p-Ascii, leng.i, flags.i)
PrototypeC.i NngRecvFunc(sock.l, *buf, *sz.Integer, flags.i)
PrototypeC.i NngSocketSetMsFunc(sock.l, opt.p-Ascii, val.l)
PrototypeC.i NngSocketGetMsFunc(sock.l, opt.p-Ascii, *val.Long)
PrototypeC.i NngSocketSetIntFunc(sock.l, opt.p-Ascii, val.l)
PrototypeC.i NngSocketGetIntFunc(sock.l, opt.p-Ascii, *val.Long)
PrototypeC.i NngSocketSetSizeFunc(sock.l, opt.p-Ascii, val.i)
PrototypeC.i NngSocketGetSizeFunc(sock.l, opt.p-Ascii, *val.Integer)
PrototypeC.i NngSocketSetBoolFunc(sock.l, opt.p-Ascii, val.b)
PrototypeC.i NngSocketGetBoolFunc(sock.l, opt.p-Ascii, *val.Byte)
PrototypeC.i NngSubSubscribeFunc(sock.l, *buf, sz.i)
PrototypeC.i NngSubSubscribeStrFunc(sock.l, buf.p-Ascii, sz.i)
PrototypeC.i NngGetRecvPollFdFunc(sock.l, *fdp.Long)
PrototypeC.i NngGetSendPollFdFunc(sock.l, *fdp.Long)

; NNG Function Declare

; <summary>
; NngOpenByName
; </summary>
; <param name="dllInstance">integer</param>
; <param name="lpszFuncName">string</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngOpenByName(dllInstance.i, lpszFuncName.s, *sock.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngOpenFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, lpszFuncName)
    
    If pFuncCall > 0
      *sock\l = 0
      lResult = pFuncCall(*sock)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngPub0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngPub0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_pub0_open", *sock)
EndProcedure

; <summary>
; NngSub0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSub0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_sub0_open", *sock)
EndProcedure

; <summary>
; NngReq0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngReq0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_req0_open", *sock)
EndProcedure

; <summary>
; NngRep0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngRep0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_rep0_open", *sock)
EndProcedure

; <summary>
; NngPush0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngPush0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_push0_open", *sock)
EndProcedure

; <summary>
; NngPull0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngPull0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_pull0_open", *sock)
EndProcedure

; <summary>
; NngPair1Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngPair1Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_pair1_open", *sock)
EndProcedure

; <summary>
; NngPair0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngPair0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_pair0_open", *sock)
EndProcedure

; <summary>
; NngSurveyor0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSurveyor0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_surveyor0_open", *sock)
EndProcedure

; <summary>
; NngRespondent0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngRespondent0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_respondent0_open", *sock)
EndProcedure

; <summary>
; NngBus0Open
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngBus0Open(dllInstance.i, *sock.Long)
  ProcedureReturn NngOpenByName(dllInstance, "nng_bus0_open", *sock)
EndProcedure

; <summary>
; NngSocketClose
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketClose(dllInstance.i, sock.l)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSocketCloseFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_close")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngListen
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="addr">string</param>
; <param name="flags">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngListen(dllInstance.i, sock.l, addr.s, flags.i = 0)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngListenFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_listen")
    
    If pFuncCall > 0
      ; Pass NULL listener when the caller does not need the endpoint handle.
      lResult = pFuncCall(sock, addr, 0, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngDial
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="addr">string</param>
; <param name="flags">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngDial(dllInstance.i, sock.l, addr.s, flags.i = 0)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngDialFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_dial")
    
    If pFuncCall > 0
      ; Pass NULL dialer when the caller does not need the endpoint handle.
      lResult = pFuncCall(sock, addr, 0, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSend
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="buf">pointer</param>
; <param name="len">integer</param>
; <param name="flags">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSend(dllInstance.i, sock.l, *buf, len.i, flags.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSendFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_send")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, *buf, len, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSendString
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="buf">string</param>
; <param name="len">integer</param>
; <param name="flags">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSendString(dllInstance.i, sock.l, buf.s, len.i, flags.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSendStrFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_send")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, buf, len, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngRecv
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="buf">pointer</param>
; <param name="sz">integer pointer (in/out size)</param>
; <param name="flags">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngRecv(dllInstance.i, sock.l, *buf, *sz.Integer, flags.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngRecvFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_recv")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, *buf, *sz, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngRecvBuffer
; Convenience helper: returns received byte count on success, or -1 on failure.
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="buf">pointer</param>
; <param name="buflen">integer</param>
; <param name="flags">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NngRecvBuffer(dllInstance.i, sock.l, *buf, buflen.i, flags.i)
  Protected.i sz = buflen
  Protected.i lResult = NngRecv(dllInstance, sock, *buf, @sz, flags)
  
  If lResult = #NNG_OK
    ProcedureReturn sz
  EndIf
  
  ProcedureReturn -1
EndProcedure

; <summary>
; NngSocketSetMs
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="opt">string</param>
; <param name="val">long (milliseconds)</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketSetMs(dllInstance.i, sock.l, opt.s, val.l)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSocketSetMsFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_set_ms")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, opt, val)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSocketGetMs
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="opt">string</param>
; <param name="val">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketGetMs(dllInstance.i, sock.l, opt.s, *val.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSocketGetMsFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_get_ms")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, opt, *val)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSocketSetInt
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="opt">string</param>
; <param name="val">long</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketSetInt(dllInstance.i, sock.l, opt.s, val.l)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSocketSetIntFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_set_int")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, opt, val)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSocketGetInt
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="opt">string</param>
; <param name="val">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketGetInt(dllInstance.i, sock.l, opt.s, *val.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSocketGetIntFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_get_int")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, opt, *val)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSocketSetSize
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="opt">string</param>
; <param name="val">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketSetSize(dllInstance.i, sock.l, opt.s, val.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSocketSetSizeFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_set_size")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, opt, val)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSocketGetSize
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="opt">string</param>
; <param name="val">integer pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketGetSize(dllInstance.i, sock.l, opt.s, *val.Integer)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSocketGetSizeFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_get_size")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, opt, *val)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSub0Subscribe
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="topic">string</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSub0Subscribe(dllInstance.i, sock.l, topic.s)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSubSubscribeStrFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_sub0_socket_subscribe")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, topic, Len(topic))
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSub0Unsubscribe
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="topic">string</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSub0Unsubscribe(dllInstance.i, sock.l, topic.s)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSubSubscribeStrFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_sub0_socket_unsubscribe")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, topic, Len(topic))
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSocketGetRecvPollFd
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="fdp">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketGetRecvPollFd(dllInstance.i, sock.l, *fdp.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngGetRecvPollFdFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_get_recv_poll_fd")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, *fdp)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSocketGetSendPollFd
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="fdp">long pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSocketGetSendPollFd(dllInstance.i, sock.l, *fdp.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngGetSendPollFdFunc pFuncCall
  
  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_socket_get_send_poll_fd")
    
    If pFuncCall > 0
      lResult = pFuncCall(sock, *fdp)
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
