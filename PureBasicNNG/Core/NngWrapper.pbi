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

; Declare Module NngMessage
DeclareModule NngMessage
  Declare.i Alloc(size.i)
  Declare.i Free(*msg)
  Declare.i Realloc(*msg, size.i)
  Declare.i Reserve(*msg, size.i)
  Declare.i Capacity(*msg)
  Declare.i Header(*msg)
  Declare.i HeaderLen(*msg)
  Declare.i Body(*msg)
  Declare.i Length(*msg)
  Declare.i Append(*msg, *payload, size.i)
  Declare.i AppendString(*msg, payload.s)
  Declare.i Insert(*msg, *payload, size.i)
  Declare.i InsertText(*msg, payload.s)
  Declare.i BodyTrim(*msg, size.i)
  Declare.i BodyChop(*msg, size.i)
  Declare.i HeaderAppend(*msg, *payload, size.i)
  Declare.i HeaderAppendString(*msg, payload.s)
  Declare.i HeaderInsert(*msg, *payload, size.i)
  Declare.i HeaderInsertString(*msg, payload.s)
  Declare.i HeaderTrim(*msg, size.i)
  Declare.i HeaderChop(*msg, size.i)
  Declare.i HeaderAppendU16(*msg, value.w)
  Declare.i HeaderAppendU32(*msg, value.l)
  Declare.i HeaderAppendU64(*msg, value.q)
  Declare.i HeaderInsertU16(*msg, value.w)
  Declare.i HeaderInsertU32(*msg, value.l)
  Declare.i HeaderInsertU64(*msg, value.q)
  Declare.i HeaderChopU16(*msg, *value.Word)
  Declare.i HeaderChopU32(*msg, *value.Long)
  Declare.i HeaderChopU64(*msg, *value.Quad)
  Declare.i HeaderTrimU16(*msg, *value.Word)
  Declare.i HeaderTrimU32(*msg, *value.Long)
  Declare.i HeaderTrimU64(*msg, *value.Quad)
  Declare.i AppendU16(*msg, value.w)
  Declare.i AppendU32(*msg, value.l)
  Declare.i AppendU64(*msg, value.q)
  Declare.i InsertU16(*msg, value.w)
  Declare.i InsertU32(*msg, value.l)
  Declare.i InsertU64(*msg, value.q)
  Declare.i ChopU16(*msg, *value.Word)
  Declare.i ChopU32(*msg, *value.Long)
  Declare.i ChopU64(*msg, *value.Quad)
  Declare.i TrimU16(*msg, *value.Word)
  Declare.i TrimU32(*msg, *value.Long)
  Declare.i TrimU64(*msg, *value.Quad)
  Declare.i Duplicate(*msg)
  Declare.i Clear(*msg)
  Declare.i HeaderClear(*msg)
  Declare.i SetPipe(*msg, pipe.l)
  Declare.i GetPipe(*msg)
  Declare.i Sendmsg(sock.l, *msg, flags.i)
  Declare.i Recvmsg(sock.l, flags.i = 0)
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

; Module NngMessage
Module NngMessage
  IncludeFile "Enums.pbi"
  IncludeFile "Message.pbi"

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
  ; Alloc
  ; </summary>
  ; <param name="size">integer</param>
  ; <returns>Returns message pointer, or 0 on failure.</returns>
  Procedure.i Alloc(size.i)
    Protected *msg
    Protected.i rc = NngMsgAlloc(NngWrapper::dllInstance, @*msg, size)

    StoreLastError(rc)

    If rc = #NNG_OK
      ProcedureReturn *msg
    EndIf

    ProcedureReturn 0
  EndProcedure

  ; <summary>
  ; Free
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns true when the function is available.</returns>
  Procedure.i Free(*msg)
    ProcedureReturn NngMsgFree(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; Realloc
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Realloc(*msg, size.i)
    ProcedureReturn StoreLastError(NngMsgRealloc(NngWrapper::dllInstance, *msg, size))
  EndProcedure

  ; <summary>
  ; Reserve
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Reserve(*msg, size.i)
    ProcedureReturn StoreLastError(NngMsgReserve(NngWrapper::dllInstance, *msg, size))
  EndProcedure

  ; <summary>
  ; Capacity
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns integer.</returns>
  Procedure.i Capacity(*msg)
    ProcedureReturn NngMsgCapacity(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; Header
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns pointer.</returns>
  Procedure.i Header(*msg)
    ProcedureReturn NngMsgHeader(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; HeaderLen
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns integer.</returns>
  Procedure.i HeaderLen(*msg)
    ProcedureReturn NngMsgHeaderLen(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; Body
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns pointer.</returns>
  Procedure.i Body(*msg)
    ProcedureReturn NngMsgBody(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; Length
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns integer.</returns>
  Procedure.i Length(*msg)
    ProcedureReturn NngMsgLen(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; Append
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">data pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Append(*msg, *payload, size.i)
    ProcedureReturn StoreLastError(NngMsgAppend(NngWrapper::dllInstance, *msg, *payload, size))
  EndProcedure

  ; <summary>
  ; AppendString
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">string</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i AppendString(*msg, payload.s)
    ProcedureReturn StoreLastError(NngMsgAppendString(NngWrapper::dllInstance, *msg, payload))
  EndProcedure

  ; <summary>
  ; Insert
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">data pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Insert(*msg, *payload, size.i)
    ProcedureReturn StoreLastError(NngMsgInsert(NngWrapper::dllInstance, *msg, *payload, size))
  EndProcedure

  ; <summary>
  ; InsertString
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">string</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i InsertText(*msg, payload.s)
    ProcedureReturn StoreLastError(NngMsgInsertString(NngWrapper::dllInstance, *msg, payload))
  EndProcedure

  ; <summary>
  ; Trim
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i BodyTrim(*msg, size.i)
    ProcedureReturn StoreLastError(NngMsgTrim(NngWrapper::dllInstance, *msg, size))
  EndProcedure

  ; <summary>
  ; Chop
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i BodyChop(*msg, size.i)
    ProcedureReturn StoreLastError(NngMsgChop(NngWrapper::dllInstance, *msg, size))
  EndProcedure

  ; <summary>
  ; HeaderAppend
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">data pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderAppend(*msg, *payload, size.i)
    ProcedureReturn StoreLastError(NngMsgHeaderAppend(NngWrapper::dllInstance, *msg, *payload, size))
  EndProcedure

  ; <summary>
  ; HeaderAppendString
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">string</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderAppendString(*msg, payload.s)
    ProcedureReturn StoreLastError(NngMsgHeaderAppendString(NngWrapper::dllInstance, *msg, payload))
  EndProcedure

  ; <summary>
  ; HeaderInsert
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">data pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderInsert(*msg, *payload, size.i)
    ProcedureReturn StoreLastError(NngMsgHeaderInsert(NngWrapper::dllInstance, *msg, *payload, size))
  EndProcedure

  ; <summary>
  ; HeaderInsertString
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="data">string</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderInsertString(*msg, payload.s)
    ProcedureReturn StoreLastError(NngMsgHeaderInsertString(NngWrapper::dllInstance, *msg, payload))
  EndProcedure

  ; <summary>
  ; HeaderTrim
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderTrim(*msg, size.i)
    ProcedureReturn StoreLastError(NngMsgHeaderTrim(NngWrapper::dllInstance, *msg, size))
  EndProcedure

  ; <summary>
  ; HeaderChop
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="size">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderChop(*msg, size.i)
    ProcedureReturn StoreLastError(NngMsgHeaderChop(NngWrapper::dllInstance, *msg, size))
  EndProcedure

  ; <summary>
  ; HeaderAppendU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderAppendU16(*msg, value.w)
    ProcedureReturn StoreLastError(NngMsgHeaderAppendU16(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; HeaderAppendU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderAppendU32(*msg, value.l)
    ProcedureReturn StoreLastError(NngMsgHeaderAppendU32(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; HeaderAppendU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderAppendU64(*msg, value.q)
    ProcedureReturn StoreLastError(NngMsgHeaderAppendU64(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; HeaderInsertU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderInsertU16(*msg, value.w)
    ProcedureReturn StoreLastError(NngMsgHeaderInsertU16(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; HeaderInsertU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderInsertU32(*msg, value.l)
    ProcedureReturn StoreLastError(NngMsgHeaderInsertU32(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; HeaderInsertU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderInsertU64(*msg, value.q)
    ProcedureReturn StoreLastError(NngMsgHeaderInsertU64(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; HeaderChopU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderChopU16(*msg, *value.Word)
    ProcedureReturn StoreLastError(NngMsgHeaderChopU16(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; HeaderChopU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderChopU32(*msg, *value.Long)
    ProcedureReturn StoreLastError(NngMsgHeaderChopU32(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; HeaderChopU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderChopU64(*msg, *value.Quad)
    ProcedureReturn StoreLastError(NngMsgHeaderChopU64(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; HeaderTrimU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderTrimU16(*msg, *value.Word)
    ProcedureReturn StoreLastError(NngMsgHeaderTrimU16(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; HeaderTrimU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderTrimU32(*msg, *value.Long)
    ProcedureReturn StoreLastError(NngMsgHeaderTrimU32(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; HeaderTrimU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i HeaderTrimU64(*msg, *value.Quad)
    ProcedureReturn StoreLastError(NngMsgHeaderTrimU64(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; AppendU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i AppendU16(*msg, value.w)
    ProcedureReturn StoreLastError(NngMsgAppendU16(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; AppendU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i AppendU32(*msg, value.l)
    ProcedureReturn StoreLastError(NngMsgAppendU32(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; AppendU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i AppendU64(*msg, value.q)
    ProcedureReturn StoreLastError(NngMsgAppendU64(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; InsertU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i InsertU16(*msg, value.w)
    ProcedureReturn StoreLastError(NngMsgInsertU16(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; InsertU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i InsertU32(*msg, value.l)
    ProcedureReturn StoreLastError(NngMsgInsertU32(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; InsertU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i InsertU64(*msg, value.q)
    ProcedureReturn StoreLastError(NngMsgInsertU64(NngWrapper::dllInstance, *msg, value))
  EndProcedure

  ; <summary>
  ; ChopU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i ChopU16(*msg, *value.Word)
    ProcedureReturn StoreLastError(NngMsgChopU16(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; ChopU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i ChopU32(*msg, *value.Long)
    ProcedureReturn StoreLastError(NngMsgChopU32(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; ChopU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i ChopU64(*msg, *value.Quad)
    ProcedureReturn StoreLastError(NngMsgChopU64(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; TrimU16
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned word output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i TrimU16(*msg, *value.Word)
    ProcedureReturn StoreLastError(NngMsgTrimU16(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; TrimU32
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned long output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i TrimU32(*msg, *value.Long)
    ProcedureReturn StoreLastError(NngMsgTrimU32(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; TrimU64
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="value">unsigned quad output</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i TrimU64(*msg, *value.Quad)
    ProcedureReturn StoreLastError(NngMsgTrimU64(NngWrapper::dllInstance, *msg, *value))
  EndProcedure

  ; <summary>
  ; Duplicate
  ; </summary>
  ; <param name="msg">source message pointer</param>
  ; <returns>Returns duplicated message pointer, or 0 on failure.</returns>
  Procedure.i Duplicate(*msg)
    Protected *copy
    Protected.i rc = NngMsgDup(NngWrapper::dllInstance, @*copy, *msg)

    StoreLastError(rc)

    If rc = #NNG_OK
      ProcedureReturn *copy
    EndIf

    ProcedureReturn 0
  EndProcedure

  ; <summary>
  ; Clear
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns true when the function is available.</returns>
  Procedure.i Clear(*msg)
    ProcedureReturn NngMsgClear(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; HeaderClear
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns true when the function is available.</returns>
  Procedure.i HeaderClear(*msg)
    ProcedureReturn NngMsgHeaderClear(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; SetPipe
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <param name="pipe">pipe id</param>
  ; <returns>Returns true when the function is available.</returns>
  Procedure.i SetPipe(*msg, pipe.l)
    ProcedureReturn NngMsgSetPipe(NngWrapper::dllInstance, *msg, pipe)
  EndProcedure

  ; <summary>
  ; GetPipe
  ; </summary>
  ; <param name="msg">message pointer</param>
  ; <returns>Returns pipe id.</returns>
  Procedure.i GetPipe(*msg)
    ProcedureReturn NngMsgGetPipe(NngWrapper::dllInstance, *msg)
  EndProcedure

  ; <summary>
  ; Sendmsg
  ; The message is owned by nng after a successful send.
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="msg">message pointer</param>
  ; <param name="flags">integer</param>
  ; <returns>Returns integer (nng_err).</returns>
  Procedure.i Sendmsg(sock.l, *msg, flags.i)
    ProcedureReturn StoreLastError(NngSendmsg(NngWrapper::dllInstance, sock, *msg, flags))
  EndProcedure

  ; <summary>
  ; Recvmsg
  ; The caller owns the returned message and must call Free().
  ; </summary>
  ; <param name="sock">long</param>
  ; <param name="flags">integer</param>
  ; <returns>Returns message pointer, or 0 on failure.</returns>
  Procedure.i Recvmsg(sock.l, flags.i = 0)
    Protected *msg
    Protected.i rc = NngRecvmsg(NngWrapper::dllInstance, sock, @*msg, flags)

    StoreLastError(rc)

    If rc = #NNG_OK
      ProcedureReturn *msg
    EndIf

    ProcedureReturn 0
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
