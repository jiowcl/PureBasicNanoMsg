;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; nn_cmsghdr size on Windows (size_t + int + int), Module-safe
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  #NN_CMSGHDR_BYTES = 16
CompilerElse
  #NN_CMSGHDR_BYTES = 12
CompilerEndIf

IncludeFile "FuncTable.pbi"

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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_socket
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_close
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_setsockopt
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_setsockopt
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_getsockopt
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_bind
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_connect
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_shutdown
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_send
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_send
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_recv
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_poll
    
    If pFuncCall
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
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_get_statistic
    
    If pFuncCall
      lResult = pFuncCall(socket, stat)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnSendmsg
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="msghdr">pointer</param>
; <param name="flags">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnSendmsg(dllInstance.i, socket.i, *msghdr, flags.i)
  Protected.i lResult = -1
  Protected.NnSendmsgFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_sendmsg
    
    If pFuncCall
      lResult = pFuncCall(socket, *msghdr, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnRecvmsg
; </summary>
; <param name="dllInstance">integer</param>
; <param name="socket">integer</param>
; <param name="msghdr">pointer</param>
; <param name="flags">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnRecvmsg(dllInstance.i, socket.i, *msghdr, flags.i)
  Protected.i lResult = -1
  Protected.NnRecvmsgFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_recvmsg
    
    If pFuncCall
      lResult = pFuncCall(socket, *msghdr, flags)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnCmsgAlign
; </summary>
; <param name="len">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnCmsgAlign(len.i)
  Protected.i alignSize = SizeOf(Integer)
  
  ProcedureReturn (len + alignSize - 1) & ~(alignSize - 1)
EndProcedure

; <summary>
; NnCmsgSpace
; </summary>
; <param name="len">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnCmsgSpace(len.i)
  ProcedureReturn NnCmsgAlign(len) + NnCmsgAlign(#NN_CMSGHDR_BYTES)
EndProcedure

; <summary>
; NnCmsgLen
; </summary>
; <param name="len">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnCmsgLen(len.i)
  ProcedureReturn NnCmsgAlign(#NN_CMSGHDR_BYTES) + len
EndProcedure

; <summary>
; NnCmsgData
; </summary>
; <param name="cmsg">pointer</param>
; <returns>Returns pointer.</returns>
Procedure.i NnCmsgData(*cmsg)
  If *cmsg = 0
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn *cmsg + #NN_CMSGHDR_BYTES
EndProcedure

; <summary>
; NnCmsgFirstHdr
; </summary>
; <param name="dllInstance">integer</param>
; <param name="mhdr">pointer</param>
; <returns>Returns pointer.</returns>
Procedure.i NnCmsgFirstHdr(dllInstance.i, *mhdr)
  Protected.i lResult
  Protected.NnCmsgNxthdrFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_cmsg_nxthdr
    
    If pFuncCall
      lResult = pFuncCall(*mhdr, 0)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure

; <summary>
; NnCmsgNxtHdr
; </summary>
; <param name="dllInstance">integer</param>
; <param name="mhdr">pointer</param>
; <param name="cmsg">pointer</param>
; <returns>Returns pointer.</returns>
Procedure.i NnCmsgNxtHdr(dllInstance.i, *mhdr, *cmsg)
  Protected.i lResult
  Protected.NnCmsgNxthdrFunc pFuncCall
  
  If NnEnsureFuncs(dllInstance)
    pFuncCall = gNnFuncs\nn_cmsg_nxthdr
    
    If pFuncCall
      lResult = pFuncCall(*mhdr, *cmsg)
    EndIf
  EndIf
  
  ProcedureReturn lResult
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = ---
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField4 = 1.0.0
