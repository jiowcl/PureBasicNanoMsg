;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

CompilerIf #PB_Compiler_Version < 520
  CompilerWarning "PureBasic 5.2.0 Version Required."
CompilerEndIf

; Declare Module NngWrapper
DeclareModule NngWrapper
  Global dllInstance.i
  
  Declare.i DllOpen(lpszDllPath.s)
  Declare.i DllClose()
EndDeclareModule

; Declare Module NngRuntime
DeclareModule NngRuntime
  ; Last nng_err from Module convenience wrappers (nng has no nn_errno).
  Global lastError.i
  
  Declare.i Init()
  Declare.i Fini()
  Declare.i LastError()
  Declare.s Strerror(errnum.i)
EndDeclareModule

; Declare Module NngSocket
DeclareModule NngSocket
  Declare.i PubOpen()
  Declare.i SubOpen()
  Declare.i ReqOpen()
  Declare.i RepOpen()
  Declare.i PushOpen()
  Declare.i PullOpen()
  Declare.i PairOpen()
  Declare.i Pair0Open()
  Declare.i SurveyorOpen()
  Declare.i RespondentOpen()
  Declare.i BusOpen()
  Declare.i Close(sock.l)
  Declare.i Listen(sock.l, addr.s, flags.i = 0)
  Declare.i Dial(sock.l, addr.s, flags.i = 0)
  Declare.i Send(sock.l, *buf, len.i, flags.i)
  Declare.i SendString(sock.l, buf.s, len.i, flags.i)
  Declare.i Recv(sock.l, *buf, len.i, flags.i)
  Declare.i SetMs(sock.l, opt.s, val.l)
  Declare.i GetMs(sock.l, opt.s, *val.Long)
  Declare.i SetInt(sock.l, opt.s, val.l)
  Declare.i GetInt(sock.l, opt.s, *val.Long)
  Declare.i SetSize(sock.l, opt.s, val.i)
  Declare.i GetSize(sock.l, opt.s, *val.Integer)
  Declare.i Subscribe(sock.l, topic.s)
  Declare.i Unsubscribe(sock.l, topic.s)
  Declare.i GetRecvPollFd(sock.l, *fdp.Long)
  Declare.i GetSendPollFd(sock.l, *fdp.Long)
EndDeclareModule

; Module NngWrapper
Module NngWrapper
  IncludeFile "LibDll.pbi"
  IncludeFile "Enums.pbi"
  IncludeFile "Runtime.pbi"
  
  ; <summary>
  ; DllOpen
  ; </summary>
  ; <param name="lpszDllPath">string</param>
  ; <returns>Returns integer.</returns>
  Procedure.i DllOpen(lpszDllPath.s)
    If IsLibrary(dllInstance)
      ProcedureReturn dllInstance
    EndIf
    
    dllInstance = NngDllOpen(lpszDllPath)
    
    If IsLibrary(dllInstance)
      If NngInit(dllInstance) <> #NNG_OK
        NngDllClose(dllInstance)
        dllInstance = 0
      EndIf
    EndIf
    
    ProcedureReturn dllInstance
  EndProcedure
  
  ; <summary>
  ; DllClose
  ; </summary>
  ; <returns>Returns integer.</returns>
  Procedure.i DllClose()
    If IsLibrary(dllInstance)
      NngFini(dllInstance)
    EndIf
    
    ProcedureReturn NngDllClose(dllInstance)
  EndProcedure
EndModule

; Module NngRuntime
Module NngRuntime
  IncludeFile "Enums.pbi"
  IncludeFile "Runtime.pbi"
  
  ; <summary>
  ; Init
  ; </summary>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Init()
    ProcedureReturn NngInit(NngWrapper::dllInstance)
  EndProcedure
  
  ; <summary>
  ; Fini
  ; </summary>
  ; <returns>Returns integer.</returns>
  Procedure.i Fini()
    ProcedureReturn NngFini(NngWrapper::dllInstance)
  EndProcedure
  
  ; <summary>
  ; LastError
  ; </summary>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i LastError()
    ProcedureReturn lastError
  EndProcedure
  
  ; <summary>
  ; Strerror
  ; </summary>
  ; <param name="errnum">integer</param>
  ; <returns>Returns string.</returns>
  Procedure.s Strerror(errnum.i)
    ProcedureReturn NngStrerror(NngWrapper::dllInstance, errnum)
  EndProcedure
EndModule

; Module NngSocket
Module NngSocket
  IncludeFile "Enums.pbi"
  IncludeFile "Socket.pbi"
  
  UseModule NngWrapper
  
  ; <summary>
  ; StoreLastError
  ; </summary>
  ; <param name="rc">integer</param>
  ; <returns>Returns integer.</returns>
  Procedure.i StoreLastError(rc.i)
    NngRuntime::lastError = rc
    ProcedureReturn rc
  EndProcedure
  
  ; <summary>
  ; OpenFromResult
  ; </summary>
  ; <param name="rc">integer</param>
  ; <param name="sock">long</param>
  ; <returns>Returns long socket id, or 0 on failure.</returns>
  Procedure.l OpenFromResult(rc.i, sock.l)
    StoreLastError(rc)
    
    If rc = #NNG_OK
      ProcedureReturn sock
    EndIf
    
    ProcedureReturn 0
  EndProcedure
  
  ; <summary>
  ; PubOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i PubOpen()
    Protected.l sock
    Protected.i rc = NngPub0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; SubOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i SubOpen()
    Protected.l sock
    Protected.i rc = NngSub0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; ReqOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i ReqOpen()
    Protected.l sock
    Protected.i rc = NngReq0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; RepOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i RepOpen()
    Protected.l sock
    Protected.i rc = NngRep0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; PushOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i PushOpen()
    Protected.l sock
    Protected.i rc = NngPush0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; PullOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i PullOpen()
    Protected.l sock
    Protected.i rc = NngPull0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; PairOpen (PAIR1)
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i PairOpen()
    Protected.l sock
    Protected.i rc = NngPair1Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; Pair0Open
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i Pair0Open()
    Protected.l sock
    Protected.i rc = NngPair0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; SurveyorOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i SurveyorOpen()
    Protected.l sock
    Protected.i rc = NngSurveyor0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; RespondentOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i RespondentOpen()
    Protected.l sock
    Protected.i rc = NngRespondent0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; BusOpen
  ; </summary>
  ; <returns>Returns long.</returns>
  Procedure.i BusOpen()
    Protected.l sock
    Protected.i rc = NngBus0Open(NngWrapper::dllInstance, @sock)
    
    ProcedureReturn OpenFromResult(rc, sock)
  EndProcedure
  
  ; <summary>
  ; Close
  ; </summary>
  ; <param name="sock">long</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Close(sock.l)
    ProcedureReturn StoreLastError(NngSocketClose(NngWrapper::dllInstance, sock))
  EndProcedure
  
  ; <summary>
  ; Listen
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="addr">string</param>
  ; <param name="flags">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Listen(sock.l, addr.s, flags.i = 0)
    ProcedureReturn StoreLastError(NngListen(NngWrapper::dllInstance, sock, addr, flags))
  EndProcedure
  
  ; <summary>
  ; Dial
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="addr">string</param>
  ; <param name="flags">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Dial(sock.l, addr.s, flags.i = 0)
    ProcedureReturn StoreLastError(NngDial(NngWrapper::dllInstance, sock, addr, flags))
  EndProcedure
  
  ; <summary>
  ; Send
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="buf">pointer</param>
  ; <param name="len">integer</param>
  ; <param name="flags">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Send(sock.l, *buf, len.i, flags.i)
    ProcedureReturn StoreLastError(NngSend(NngWrapper::dllInstance, sock, *buf, len, flags))
  EndProcedure
  
  ; <summary>
  ; SendString
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="buf">string</param>
  ; <param name="len">integer</param>
  ; <param name="flags">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i SendString(sock.l, buf.s, len.i, flags.i)
    ProcedureReturn StoreLastError(NngSendString(NngWrapper::dllInstance, sock, buf, len, flags))
  EndProcedure
  
  ; <summary>
  ; Recv
  ; Returns received byte count on success, or -1 on failure.
  ; Use NngRuntime::LastError() for the nng_err code.
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="buf">pointer</param>
  ; <param name="len">integer</param>
  ; <param name="flags">integer</param>
  ; <returns>Returns integer.</returns>
  Procedure.i Recv(sock.l, *buf, len.i, flags.i)
    Protected.i sz = len
    Protected.i rc = NngRecv(NngWrapper::dllInstance, sock, *buf, @sz, flags)
    
    StoreLastError(rc)
    
    If rc = #NNG_OK
      ProcedureReturn sz
    EndIf
    
    ProcedureReturn -1
  EndProcedure
  
  ; <summary>
  ; SetMs
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="opt">string</param>
  ; <param name="val">long</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i SetMs(sock.l, opt.s, val.l)
    ProcedureReturn StoreLastError(NngSocketSetMs(NngWrapper::dllInstance, sock, opt, val))
  EndProcedure
  
  ; <summary>
  ; GetMs
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="opt">string</param>
  ; <param name="val">long pointer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i GetMs(sock.l, opt.s, *val.Long)
    ProcedureReturn StoreLastError(NngSocketGetMs(NngWrapper::dllInstance, sock, opt, *val))
  EndProcedure
  
  ; <summary>
  ; SetInt
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="opt">string</param>
  ; <param name="val">long</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i SetInt(sock.l, opt.s, val.l)
    ProcedureReturn StoreLastError(NngSocketSetInt(NngWrapper::dllInstance, sock, opt, val))
  EndProcedure
  
  ; <summary>
  ; GetInt
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="opt">string</param>
  ; <param name="val">long pointer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i GetInt(sock.l, opt.s, *val.Long)
    ProcedureReturn StoreLastError(NngSocketGetInt(NngWrapper::dllInstance, sock, opt, *val))
  EndProcedure
  
  ; <summary>
  ; SetSize
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="opt">string</param>
  ; <param name="val">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i SetSize(sock.l, opt.s, val.i)
    ProcedureReturn StoreLastError(NngSocketSetSize(NngWrapper::dllInstance, sock, opt, val))
  EndProcedure
  
  ; <summary>
  ; GetSize
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="opt">string</param>
  ; <param name="val">integer pointer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i GetSize(sock.l, opt.s, *val.Integer)
    ProcedureReturn StoreLastError(NngSocketGetSize(NngWrapper::dllInstance, sock, opt, *val))
  EndProcedure
  
  ; <summary>
  ; Subscribe
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="topic">string</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Subscribe(sock.l, topic.s)
    ProcedureReturn StoreLastError(NngSub0Subscribe(NngWrapper::dllInstance, sock, topic))
  EndProcedure
  
  ; <summary>
  ; Unsubscribe
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="topic">string</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Unsubscribe(sock.l, topic.s)
    ProcedureReturn StoreLastError(NngSub0Unsubscribe(NngWrapper::dllInstance, sock, topic))
  EndProcedure
  
  ; <summary>
  ; GetRecvPollFd
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="fdp">long pointer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i GetRecvPollFd(sock.l, *fdp.Long)
    ProcedureReturn StoreLastError(NngSocketGetRecvPollFd(NngWrapper::dllInstance, sock, *fdp))
  EndProcedure
  
  ; <summary>
  ; GetSendPollFd
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="fdp">long pointer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i GetSendPollFd(sock.l, *fdp.Long)
    ProcedureReturn StoreLastError(NngSocketGetSendPollFd(NngWrapper::dllInstance, sock, *fdp))
  EndProcedure
EndModule
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; DPIAware
