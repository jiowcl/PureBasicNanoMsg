;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Include once per compile unit / Module scope (Modules cannot share prior XInclude).
CompilerIf Not Defined(NN_FUNCTABLE_INCLUDED, #PB_Constant)
#NN_FUNCTABLE_INCLUDED = 1

; Prototype Function
PrototypeC.i NnErrnoFunc()
PrototypeC.i NnStrerrorFunc(errnum.i)
PrototypeC.i NnSymbolFunc(index.i, *value.Long)
PrototypeC NnTermFunc()

PrototypeC.i NnAllocmsgFunc(size.i, type.i)
PrototypeC.i NnReallocmsgFunc(*msg, size.i)
PrototypeC.i NnFreemsgFunc(*msg)

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
PrototypeC.i NnSendmsgFunc(socket.i, *msghdr, flags.i)
PrototypeC.i NnRecvmsgFunc(socket.i, *msghdr, flags.i)
PrototypeC.i NnCmsgNxthdrFunc(*mhdr, *cmsg)

; Cached nn_* export pointers for one loaded nanomsg.dll instance.
Structure NnFuncTable
  dllInstance.i
  nn_errno.i
  nn_strerror.i
  nn_symbol.i
  nn_term.i
  nn_allocmsg.i
  nn_reallocmsg.i
  nn_freemsg.i
  nn_socket.i
  nn_close.i
  nn_setsockopt.i
  nn_getsockopt.i
  nn_bind.i
  nn_connect.i
  nn_shutdown.i
  nn_send.i
  nn_recv.i
  nn_poll.i
  nn_get_statistic.i
  nn_sendmsg.i
  nn_recvmsg.i
  nn_cmsg_nxthdr.i
EndStructure

Global gNnFuncs.NnFuncTable

; <summary>
; NnClearFuncs
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnClearFuncs(dllInstance.i = 0)
  If dllInstance = 0 Or gNnFuncs\dllInstance = dllInstance
    ClearStructure(@gNnFuncs, NnFuncTable)
  EndIf
  
  ProcedureReturn #True
EndProcedure

; <summary>
; NnEnsureFuncs
; </summary>
; <param name="dllInstance">integer</param>
; <returns>Returns integer.</returns>
Procedure.i NnEnsureFuncs(dllInstance.i)
  If dllInstance = 0 Or Not IsLibrary(dllInstance)
    NnClearFuncs()
    ProcedureReturn #False
  EndIf
  
  If gNnFuncs\dllInstance = dllInstance
    ProcedureReturn #True
  EndIf
  
  ClearStructure(@gNnFuncs, NnFuncTable)
  gNnFuncs\dllInstance = dllInstance
  
  gNnFuncs\nn_errno         = GetFunction(dllInstance, "nn_errno")
  gNnFuncs\nn_strerror      = GetFunction(dllInstance, "nn_strerror")
  gNnFuncs\nn_symbol        = GetFunction(dllInstance, "nn_symbol")
  gNnFuncs\nn_term          = GetFunction(dllInstance, "nn_term")
  gNnFuncs\nn_allocmsg      = GetFunction(dllInstance, "nn_allocmsg")
  gNnFuncs\nn_reallocmsg    = GetFunction(dllInstance, "nn_reallocmsg")
  gNnFuncs\nn_freemsg       = GetFunction(dllInstance, "nn_freemsg")
  gNnFuncs\nn_socket        = GetFunction(dllInstance, "nn_socket")
  gNnFuncs\nn_close         = GetFunction(dllInstance, "nn_close")
  gNnFuncs\nn_setsockopt    = GetFunction(dllInstance, "nn_setsockopt")
  gNnFuncs\nn_getsockopt    = GetFunction(dllInstance, "nn_getsockopt")
  gNnFuncs\nn_bind          = GetFunction(dllInstance, "nn_bind")
  gNnFuncs\nn_connect       = GetFunction(dllInstance, "nn_connect")
  gNnFuncs\nn_shutdown      = GetFunction(dllInstance, "nn_shutdown")
  gNnFuncs\nn_send          = GetFunction(dllInstance, "nn_send")
  gNnFuncs\nn_recv          = GetFunction(dllInstance, "nn_recv")
  gNnFuncs\nn_poll          = GetFunction(dllInstance, "nn_poll")
  gNnFuncs\nn_get_statistic = GetFunction(dllInstance, "nn_get_statistic")
  gNnFuncs\nn_sendmsg       = GetFunction(dllInstance, "nn_sendmsg")
  gNnFuncs\nn_recvmsg       = GetFunction(dllInstance, "nn_recvmsg")
  gNnFuncs\nn_cmsg_nxthdr   = GetFunction(dllInstance, "nn_cmsg_nxthdr_")
  
  ProcedureReturn #True
EndProcedure

CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField4 = 1.0.0
