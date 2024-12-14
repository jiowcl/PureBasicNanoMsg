;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

CompilerIf #PB_Compiler_Version < 520
  CompilerWarning "PureBasic 5.2.0 Version Required."
CompilerEndIf

; Declare Module NanomsgWrapper
DeclareModule NanomsgWrapper
  Global dllInstance.i
  
  Declare.i DllOpen(lpszDllPath.s)
  Declare.i DllClose()
EndDeclareModule

; Declare Module NanomsgRuntime
DeclareModule NanomsgRuntime 
  Declare.i Errno()
  Declare.s Strerror(errnum.i)
  Declare.s Symbol(index.i, *value.Long)
EndDeclareModule

; Declare Module NanomsgSocket
DeclareModule NanomsgSocket
  Declare.i Socket(domain.i, protocol.i)
  Declare.i Close(socket.i)
  Declare.i Setsockopt(socket.i, level.i, option.i, optval.s, optvallen.i)
  Declare.i Getsockopt(socket.i, level.i, option.i, *optval, optvallen.i)
  Declare.i Bind(socket.i, addr.s)
  Declare.i Connect(socket.i, addr.s)
  Declare.i Shutdown(socket.i, how.i)
  Declare.i Send(socket.i, buf.s, len.i, flags.i)
  Declare.i Recv(socket.i, *buf, len.i, flags.i)
EndDeclareModule  

; Module NanomsgWrapper
Module NanomsgWrapper
  IncludeFile "LibDll.pbi"
  
  ; <summary>
  ; DllOpen
  ; </summary>
  ; <param name="lpszDllPath"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i DllOpen(lpszDllPath.s)
    If IsLibrary(dllInstance)
      ProcedureReturn dllInstance
    EndIf
    
    dllInstance = NnDllOpen(lpszDllPath)
    
    ProcedureReturn dllInstance
  EndProcedure
  
  ; <summary>
  ; DllClose
  ; </summary>
  ; <param name="dllInstance"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i DllClose()
    ProcedureReturn NnDllClose(dllInstance)
  EndProcedure
EndModule

; Module NanomsgRuntime
Module NanomsgRuntime
  IncludeFile "Runtime.pbi"
  
  ; <summary>
  ; Errno
  ; </summary>
  ; <returns>Returns integer.</returns>
  Procedure.i Errno()
    ProcedureReturn NnErrno(NanomsgWrapper::dllInstance)
  EndProcedure
  
  ; <summary>
  ; Strerror
  ; </summary>
  ; <param name="errnum"></param>
  ; <returns>Returns string.</returns>
  Procedure.s Strerror(errnum.i)
    ProcedureReturn NnStrerror(NanomsgWrapper::dllInstance, errnum)
  EndProcedure
  
  ; <summary>
  ; Symbol
  ; </summary>
  ; <param name="index"></param>
  ; <param name="value"></param>
  ; <returns>Returns string.</returns>
  Procedure.s Symbol(index.i, *value.Long)
    ProcedureReturn NnSymbol(NanomsgWrapper::dllInstance, index, *value)
  EndProcedure
EndModule 

; Module NanomsgSocket
Module NanomsgSocket
  IncludeFile "Socket.pbi"
  
  UseModule NanomsgWrapper
  
  ; <summary>
  ; Socket
  ; </summary>
  ; <param name="domain"></param>
  ; <param name="protocol"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Socket(domain.i, protocol.i)
    ProcedureReturn NnSocket(NanomsgWrapper::dllInstance, domain, protocol)
  EndProcedure
  
  ; <summary>
  ; Close
  ; </summary>
  ; <param name="socket"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Close(socket.i)   
    ProcedureReturn NnClose(NanomsgWrapper::dllInstance, socket)
  EndProcedure
  
  ; <summary>
  ; Setsockopt
  ; </summary>
  ; <param name="socket"></param>
  ; <param name="level"></param>
  ; <param name="option"></param>
  ; <param name="optval"></param>
  ; <param name="optvallen"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Setsockopt(socket.i, level.i, option.i, optval.s, optvallen.i)
    ProcedureReturn NnSetsockopt(NanomsgWrapper::dllInstance, socket, level, option, optval, optvallen)
  EndProcedure  
  
  ; <summary>
  ; Getsockopt
  ; </summary>
  ; <param name="socket"></param>
  ; <param name="level"></param>
  ; <param name="option"></param>
  ; <param name="*optval"></param>
  ; <param name="optvallen"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Getsockopt(socket.i, level.i, option.i, *optval, optvallen.i)
    ProcedureReturn NnGetsockopt(NanomsgWrapper::dllInstance, socket, level, option, *optval, optvallen)
  EndProcedure
  
  ; <summary>
  ; Bind
  ; </summary>
  ; <param name="socket"></param>
  ; <param name="addr"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Bind(socket.i, addr.s)
    ProcedureReturn NnBind(NanomsgWrapper::dllInstance, socket, addr)
  EndProcedure
  
  ; <summary>
  ; Connect
  ; </summary>
  ; <param name="socket"></param>
  ; <param name="addr"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Connect(socket.i, addr.s)
    ProcedureReturn NnConnect(NanomsgWrapper::dllInstance, socket, addr)
  EndProcedure
  
  ; <summary>
  ; Shutdown
  ; </summary>
  ; <param name="socket"></param>
  ; <param name="how"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Shutdown(socket.i, how.i)
    ProcedureReturn NnShutdown(NanomsgWrapper::dllInstance, socket, how)
  EndProcedure
  
  ; <summary>
  ; Send
  ; </summary>
  ; <param name="socket"></param>
  ; <param name="buf"></param>
  ; <param name="len"></param>
  ; <param name="flags"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Send(socket.i, buf.s, len.i, flags.i)
    ProcedureReturn NnSend(NanomsgWrapper::dllInstance, socket, buf, len, flags)
  EndProcedure
  
  ; <summary>
  ; Recv
  ; </summary>
  ; <param name="socket"></param>
  ; <param name="*buf"></param>
  ; <param name="len"></param>
  ; <param name="flags"></param>
  ; <returns>Returns integer.</returns>
  Procedure.i Recv(socket.i, *buf, len.i, flags.i)
    ProcedureReturn NnRecv(NanomsgWrapper::dllInstance, socket, *buf, len, flags)
  EndProcedure
EndModule   
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 200
; FirstLine = 146
; Folding = ----
; EnableXP
; DPIAware