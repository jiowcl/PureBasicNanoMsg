;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; nng_msg is opaque.  PureBasic represents it as an untyped pointer.

; Prototype Function
PrototypeC.i NngMsgAllocFunc(*msg, size.i)
PrototypeC NngMsgFreeFunc(*msg)
PrototypeC.i NngMsgReallocFunc(*msg, size.i)
PrototypeC.i NngMsgReserveFunc(*msg, size.i)
PrototypeC.i NngMsgCapacityFunc(*msg)
PrototypeC.i NngMsgHeaderFunc(*msg)
PrototypeC.i NngMsgHeaderLenFunc(*msg)
PrototypeC.i NngMsgBodyFunc(*msg)
PrototypeC.i NngMsgLenFunc(*msg)
PrototypeC.i NngMsgAppendFunc(*msg, *payload, size.i)
PrototypeC.i NngMsgAppendStrFunc(*msg, payload.p-Ascii, size.i)
PrototypeC.i NngMsgInsertFunc(*msg, *payload, size.i)
PrototypeC.i NngMsgInsertStrFunc(*msg, payload.p-Ascii, size.i)
PrototypeC.i NngMsgTrimFunc(*msg, size.i)
PrototypeC.i NngMsgChopFunc(*msg, size.i)
PrototypeC.i NngMsgHeaderAppendFunc(*msg, *payload, size.i)
PrototypeC.i NngMsgHeaderAppendStrFunc(*msg, payload.p-Ascii, size.i)
PrototypeC.i NngMsgHeaderInsertFunc(*msg, *payload, size.i)
PrototypeC.i NngMsgHeaderInsertStrFunc(*msg, payload.p-Ascii, size.i)
PrototypeC.i NngMsgHeaderTrimFunc(*msg, size.i)
PrototypeC.i NngMsgHeaderChopFunc(*msg, size.i)
PrototypeC.i NngMsgHeaderAppendU16Func(*msg, value.w)
PrototypeC.i NngMsgHeaderAppendU32Func(*msg, value.l)
PrototypeC.i NngMsgHeaderAppendU64Func(*msg, value.q)
PrototypeC.i NngMsgHeaderInsertU16Func(*msg, value.w)
PrototypeC.i NngMsgHeaderInsertU32Func(*msg, value.l)
PrototypeC.i NngMsgHeaderInsertU64Func(*msg, value.q)
PrototypeC.i NngMsgHeaderChopU16Func(*msg, *value.Word)
PrototypeC.i NngMsgHeaderChopU32Func(*msg, *value.Long)
PrototypeC.i NngMsgHeaderChopU64Func(*msg, *value.Quad)
PrototypeC.i NngMsgHeaderTrimU16Func(*msg, *value.Word)
PrototypeC.i NngMsgHeaderTrimU32Func(*msg, *value.Long)
PrototypeC.i NngMsgHeaderTrimU64Func(*msg, *value.Quad)
PrototypeC.i NngMsgAppendU16Func(*msg, value.w)
PrototypeC.i NngMsgAppendU32Func(*msg, value.l)
PrototypeC.i NngMsgAppendU64Func(*msg, value.q)
PrototypeC.i NngMsgInsertU16Func(*msg, value.w)
PrototypeC.i NngMsgInsertU32Func(*msg, value.l)
PrototypeC.i NngMsgInsertU64Func(*msg, value.q)
PrototypeC.i NngMsgChopU16Func(*msg, *value.Word)
PrototypeC.i NngMsgChopU32Func(*msg, *value.Long)
PrototypeC.i NngMsgChopU64Func(*msg, *value.Quad)
PrototypeC.i NngMsgTrimU16Func(*msg, *value.Word)
PrototypeC.i NngMsgTrimU32Func(*msg, *value.Long)
PrototypeC.i NngMsgTrimU64Func(*msg, *value.Quad)
PrototypeC.i NngMsgDupFunc(*dst, *src)
PrototypeC NngMsgClearFunc(*msg)
PrototypeC NngMsgHeaderClearFunc(*msg)
PrototypeC NngMsgSetPipeFunc(*msg, pipe.l)
PrototypeC.i NngMsgGetPipeFunc(*msg)
PrototypeC.i NngSendmsgFunc(sock.l, *msg, flags.i)
PrototypeC.i NngRecvmsgFunc(sock.l, *msg, flags.i)

; NNG Function Declare

; <summary>
; NngMsgAlloc
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer output (`nng_msg **`)</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgAlloc(dllInstance.i, *msg, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgAllocFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_alloc")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgFree
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns true when the function is available.</returns>
Procedure.i NngMsgFree(dllInstance.i, *msg)
  Protected.NngMsgFreeFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_free")

    If pFuncCall > 0
      pFuncCall(*msg)
      ProcedureReturn #True
    EndIf
  EndIf

  ProcedureReturn #False
EndProcedure

; <summary>
; NngMsgRealloc
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgRealloc(dllInstance.i, *msg, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgReallocFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_realloc")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgReserve
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgReserve(dllInstance.i, *msg, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgReserveFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_reserve")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgCapacity
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns integer.</returns>
Procedure.i NngMsgCapacity(dllInstance.i, *msg)
  Protected.i lResult
  Protected.NngMsgCapacityFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_capacity")

    If pFuncCall > 0
      lResult = pFuncCall(*msg)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeader
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns pointer.</returns>
Procedure.i NngMsgHeader(dllInstance.i, *msg)
  Protected.i lResult
  Protected.NngMsgHeaderFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header")

    If pFuncCall > 0
      lResult = pFuncCall(*msg)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderLen
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns integer.</returns>
Procedure.i NngMsgHeaderLen(dllInstance.i, *msg)
  Protected.i lResult
  Protected.NngMsgHeaderLenFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_len")

    If pFuncCall > 0
      lResult = pFuncCall(*msg)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgBody
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns pointer.</returns>
Procedure.i NngMsgBody(dllInstance.i, *msg)
  Protected.i lResult
  Protected.NngMsgBodyFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_body")

    If pFuncCall > 0
      lResult = pFuncCall(*msg)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgLen
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns integer.</returns>
Procedure.i NngMsgLen(dllInstance.i, *msg)
  Protected.i lResult
  Protected.NngMsgLenFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_len")

    If pFuncCall > 0
      lResult = pFuncCall(*msg)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgAppend
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">data pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgAppend(dllInstance.i, *msg, *payload, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgAppendFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_append")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *payload, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgAppendString
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">string</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgAppendString(dllInstance.i, *msg, payload.s)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgAppendStrFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_append")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, payload, StringByteLength(payload, #PB_Ascii))
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgInsert
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">data pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgInsert(dllInstance.i, *msg, *payload, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgInsertFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_insert")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *payload, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgInsertString
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">string</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgInsertString(dllInstance.i, *msg, payload.s)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgInsertStrFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_insert")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, payload, StringByteLength(payload, #PB_Ascii))
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgTrim
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgTrim(dllInstance.i, *msg, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgTrimFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_trim")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgChop
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgChop(dllInstance.i, *msg, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgChopFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_chop")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderAppend
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">data pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderAppend(dllInstance.i, *msg, *payload, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderAppendFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_append")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *payload, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderAppendString
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">string</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderAppendString(dllInstance.i, *msg, payload.s)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderAppendStrFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_append")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, payload, StringByteLength(payload, #PB_Ascii))
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderInsert
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">data pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderInsert(dllInstance.i, *msg, *payload, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderInsertFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_insert")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *payload, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderInsertString
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="data">string</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderInsertString(dllInstance.i, *msg, payload.s)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderInsertStrFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_insert")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, payload, StringByteLength(payload, #PB_Ascii))
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderTrim
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderTrim(dllInstance.i, *msg, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderTrimFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_trim")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderChop
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="size">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderChop(dllInstance.i, *msg, size.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderChopFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_chop")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, size)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderAppendU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderAppendU16(dllInstance.i, *msg, value.w)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderAppendU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_append_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderAppendU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderAppendU32(dllInstance.i, *msg, value.l)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderAppendU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_append_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderAppendU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderAppendU64(dllInstance.i, *msg, value.q)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderAppendU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_append_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderInsertU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderInsertU16(dllInstance.i, *msg, value.w)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderInsertU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_insert_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderInsertU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderInsertU32(dllInstance.i, *msg, value.l)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderInsertU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_insert_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderInsertU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderInsertU64(dllInstance.i, *msg, value.q)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderInsertU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_insert_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderChopU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderChopU16(dllInstance.i, *msg, *value.Word)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderChopU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_chop_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderChopU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderChopU32(dllInstance.i, *msg, *value.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderChopU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_chop_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderChopU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderChopU64(dllInstance.i, *msg, *value.Quad)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderChopU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_chop_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderTrimU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderTrimU16(dllInstance.i, *msg, *value.Word)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderTrimU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_trim_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderTrimU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderTrimU32(dllInstance.i, *msg, *value.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderTrimU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_trim_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgHeaderTrimU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgHeaderTrimU64(dllInstance.i, *msg, *value.Quad)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgHeaderTrimU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_trim_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgAppendU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgAppendU16(dllInstance.i, *msg, value.w)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgAppendU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_append_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgAppendU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgAppendU32(dllInstance.i, *msg, value.l)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgAppendU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_append_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgAppendU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgAppendU64(dllInstance.i, *msg, value.q)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgAppendU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_append_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgInsertU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgInsertU16(dllInstance.i, *msg, value.w)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgInsertU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_insert_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgInsertU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgInsertU32(dllInstance.i, *msg, value.l)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgInsertU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_insert_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgInsertU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgInsertU64(dllInstance.i, *msg, value.q)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgInsertU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_insert_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgChopU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgChopU16(dllInstance.i, *msg, *value.Word)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgChopU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_chop_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgChopU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgChopU32(dllInstance.i, *msg, *value.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgChopU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_chop_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgChopU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgChopU64(dllInstance.i, *msg, *value.Quad)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgChopU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_chop_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgTrimU16
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned word output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgTrimU16(dllInstance.i, *msg, *value.Word)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgTrimU16Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_trim_u16")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgTrimU32
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned long output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgTrimU32(dllInstance.i, *msg, *value.Long)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgTrimU32Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_trim_u32")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgTrimU64
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="value">unsigned quad output</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgTrimU64(dllInstance.i, *msg, *value.Quad)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgTrimU64Func pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_trim_u64")

    If pFuncCall > 0
      lResult = pFuncCall(*msg, *value)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgDup
; </summary>
; <param name="dllInstance">integer</param>
; <param name="dst">message pointer output (`nng_msg **`)</param>
; <param name="src">source message pointer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngMsgDup(dllInstance.i, *dst, *src)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngMsgDupFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_dup")

    If pFuncCall > 0
      lResult = pFuncCall(*dst, *src)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngMsgClear
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns true when the function is available.</returns>
Procedure.i NngMsgClear(dllInstance.i, *msg)
  Protected.NngMsgClearFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_clear")

    If pFuncCall > 0
      pFuncCall(*msg)
      ProcedureReturn #True
    EndIf
  EndIf

  ProcedureReturn #False
EndProcedure

; <summary>
; NngMsgHeaderClear
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns true when the function is available.</returns>
Procedure.i NngMsgHeaderClear(dllInstance.i, *msg)
  Protected.NngMsgHeaderClearFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_header_clear")

    If pFuncCall > 0
      pFuncCall(*msg)
      ProcedureReturn #True
    EndIf
  EndIf

  ProcedureReturn #False
EndProcedure

; <summary>
; NngMsgSetPipe
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <param name="pipe">pipe id</param>
; <returns>Returns true when the function is available.</returns>
Procedure.i NngMsgSetPipe(dllInstance.i, *msg, pipe.l)
  Protected.NngMsgSetPipeFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_set_pipe")

    If pFuncCall > 0
      pFuncCall(*msg, pipe)
      ProcedureReturn #True
    EndIf
  EndIf

  ProcedureReturn #False
EndProcedure

; <summary>
; NngMsgGetPipe
; </summary>
; <param name="dllInstance">integer</param>
; <param name="msg">message pointer</param>
; <returns>Returns pipe id.</returns>
Procedure.i NngMsgGetPipe(dllInstance.i, *msg)
  Protected.i lResult
  Protected.NngMsgGetPipeFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_msg_get_pipe")

    If pFuncCall > 0
      lResult = pFuncCall(*msg)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngSendmsg
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="msg">message pointer</param>
; <param name="flags">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngSendmsg(dllInstance.i, sock.l, *msg, flags.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngSendmsgFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_sendmsg")

    If pFuncCall > 0
      lResult = pFuncCall(sock, *msg, flags)
    EndIf
  EndIf

  ProcedureReturn lResult
EndProcedure

; <summary>
; NngRecvmsg
; </summary>
; <param name="dllInstance">integer</param>
; <param name="sock">long</param>
; <param name="msg">message pointer output (`nng_msg **`)</param>
; <param name="flags">integer</param>
; <returns>Returns integer (nng_err).</returns>
Procedure.i NngRecvmsg(dllInstance.i, sock.l, *msg, flags.i)
  Protected.i lResult = #NNG_EINVAL
  Protected.NngRecvmsgFunc pFuncCall

  If IsLibrary(dllInstance)
    pFuncCall = GetFunction(dllInstance, "nng_recvmsg")

    If pFuncCall > 0
      lResult = pFuncCall(sock, *msg, flags)
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
