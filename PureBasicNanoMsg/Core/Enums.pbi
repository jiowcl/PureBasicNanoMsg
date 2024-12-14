;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; Version Macros for Compile-time API Version Detection 
#NN_VERSION_CURRENT   = 6
#NN_VERSION_REVISION  = 0
#NN_VERSION_AGE       = 1

; Socket Types
#NN_PROTO_REQREP      = 3
#NN_REQ               = #NN_PROTO_REQREP * 16 + 0
#NN_REP               = #NN_PROTO_REQREP * 16 + 1

#NN_REQ_RESEND_IVL    = 1

#NN_PROTO_PUBSUB      = 2
#NN_PUB               = #NN_PROTO_PUBSUB * 16 + 0
#NN_SUB               = #NN_PROTO_PUBSUB * 16 + 1
#NN_SUB_SUBSCRIBE     = 1
#NN_SUB_UNSUBSCRIBE   = 2

; SP Address Families
#AF_SP                = 1
#AF_SP_RAW            = 2

#NN_TCP               = -3
#NN_TCP_NODELAY       = 1

; Max Size of an SP Address
#NN_SOCKADDR_MAX      = 128

; Socket Option Levels
#NN_SOL_SOCKET        = 0

; Socket Options (NN_SOL_SOCKET level)
#NN_LINGER            = 1
#NN_SNDBUF            = 2
#NN_RCVBUF            = 3
#NN_SNDTIMEO          = 4
#NN_RCVTIMEO          = 5
#NN_RECONNECT_IVL     = 6
#NN_RECONNECT_IVL_MAX = 7
#NN_SNDPRIO           = 8
#NN_RCVPRIO           = 9
#NN_SNDFD             = 10
#NN_RCVFD             = 11
#NN_DOMAIN            = 12
#NN_PROTOCOL          = 13
#NN_IPV4ONLY          = 14
#NN_SOCKET_NAME       = 15
#NN_RCVMAXSIZE        = 16
#NN_MAXTTL            = 17

; Message Options
#NN_DONTWAIT          = 1

; Ancillary Data
#PROTO_SP             = 1
#SP_HDR               = 1

; Socket Mutliplexing Support
#NN_POLLIN            = 1
#NN_POLLOUT           = 2

; Transport Statistics 
#NN_STAT_ESTABLISHED_CONNECTIONS = 101
#NN_STAT_ACCEPTED_CONNECTIONS    = 102
#NN_STAT_DROPPED_CONNECTIONS     = 103
#NN_STAT_BROKEN_CONNECTIONS      = 104
#NN_STAT_CONNECT_ERRORS          = 105
#NN_STAT_BIND_ERRORS             = 106
#NN_STAT_ACCEPT_ERRORS           = 107

#NN_STAT_CURRENT_CONNECTIONS     = 201
#NN_STAT_INPROGRESS_CONNECTIONS  = 202
#NN_STAT_CURRENT_EP_ERRORS       = 203

; The Socket-internal Statistics 
#NN_STAT_MESSAGES_SENT           = 301
#NN_STAT_MESSAGES_RECEIVED       = 302
#NN_STAT_BYTES_SENT              = 303
#NN_STAT_BYTES_RECEIVED          = 304

; Protocol Statistics
#NN_STAT_CURRENT_SND_PRIORITY    = 401

; Errors
#NN_HAUSNUMERO  = 156384712

CompilerIf Not Defined(ENOTSUP, #PB_Constant)
  #ENOTSUP         = #NN_HAUSNUMERO + 1    
CompilerEndIf

CompilerIf Not Defined(EPROTONOSUPPORT, #PB_Constant)
  #EPROTONOSUPPORT = #NN_HAUSNUMERO + 2   
CompilerEndIf

CompilerIf Not Defined(ENOBUFS, #PB_Constant)
  #ENOBUFS         = #NN_HAUSNUMERO + 3
CompilerEndIf

CompilerIf Not Defined(ENETDOWN, #PB_Constant)
  #ENETDOWN        = #NN_HAUSNUMERO + 4
CompilerEndIf

CompilerIf Not Defined(EADDRINUSE, #PB_Constant)
  #EADDRINUSE      = #NN_HAUSNUMERO + 5
CompilerEndIf

CompilerIf Not Defined(EADDRNOTAVAIL, #PB_Constant)
  #EADDRNOTAVAIL   = #NN_HAUSNUMERO + 6
CompilerEndIf

CompilerIf Not Defined(ECONNREFUSED, #PB_Constant)
  #ECONNREFUSED    = #NN_HAUSNUMERO + 7
CompilerEndIf

CompilerIf Not Defined(EINPROGRESS, #PB_Constant)
  #EINPROGRESS     = #NN_HAUSNUMERO + 8
CompilerEndIf

CompilerIf Not Defined(ENOTSOCK, #PB_Constant)
  #ENOTSOCK        = #NN_HAUSNUMERO + 9
CompilerEndIf

CompilerIf Not Defined(EAFNOSUPPORT, #PB_Constant)
  #EAFNOSUPPORT    = #NN_HAUSNUMERO + 10
CompilerEndIf

CompilerIf Not Defined(EPROTO, #PB_Constant)
  #EPROTO          = #NN_HAUSNUMERO + 11
CompilerEndIf

CompilerIf Not Defined(EAGAIN , #PB_Constant)
  #EAGAIN          = #NN_HAUSNUMERO + 12
CompilerEndIf

CompilerIf Not Defined(EBADF , #PB_Constant)
  #EBADF           = #NN_HAUSNUMERO + 13
CompilerEndIf

CompilerIf Not Defined(EINVAL , #PB_Constant)
  #EINVAL          = #NN_HAUSNUMERO + 14
CompilerEndIf

CompilerIf Not Defined(EMFILE , #PB_Constant)
  #EMFILE          = #NN_HAUSNUMERO + 15
CompilerEndIf

CompilerIf Not Defined(EFAULT , #PB_Constant)
  #EFAULT          = #NN_HAUSNUMERO + 16
CompilerEndIf

CompilerIf Not Defined(EACCES , #PB_Constant)
  #EACCES          = #NN_HAUSNUMERO + 17
CompilerEndIf

CompilerIf Not Defined(ENETRESET , #PB_Constant)
  #ENETRESET       = #NN_HAUSNUMERO + 18
CompilerEndIf

CompilerIf Not Defined(ENETUNREACH , #PB_Constant)
  #ENETUNREACH     = #NN_HAUSNUMERO + 19
CompilerEndIf

CompilerIf Not Defined(EHOSTUNREACH , #PB_Constant)
  #EHOSTUNREACH    = #NN_HAUSNUMERO + 20
CompilerEndIf

CompilerIf Not Defined(ENOTCONN , #PB_Constant)
  #ENOTCONN        = #NN_HAUSNUMERO + 21
CompilerEndIf

CompilerIf Not Defined(EMSGSIZE , #PB_Constant)
  #EMSGSIZE        = #NN_HAUSNUMERO + 22
CompilerEndIf

CompilerIf Not Defined(ETIMEDOUT , #PB_Constant)
  #ETIMEDOUT       = #NN_HAUSNUMERO + 23
CompilerEndIf

CompilerIf Not Defined(ECONNABORTED , #PB_Constant)
  #ECONNABORTED    = #NN_HAUSNUMERO + 24
CompilerEndIf

CompilerIf Not Defined(ECONNRESET , #PB_Constant)
  #ECONNRESET      = #NN_HAUSNUMERO + 25
CompilerEndIf

CompilerIf Not Defined(ENOPROTOOPT , #PB_Constant)
  #ENOPROTOOPT     = #NN_HAUSNUMERO + 26
CompilerEndIf

CompilerIf Not Defined(EISCONN , #PB_Constant)
  #EISCONN         = #NN_HAUSNUMERO + 27
CompilerEndIf

CompilerIf Not Defined(ESOCKTNOSUPPORT , #PB_Constant)
  #ESOCKTNOSUPPORT = #NN_HAUSNUMERO + 28
CompilerEndIf

; Native Nanomsg Error Codes
#ETERM            = #NN_HAUSNUMERO + 53
#EFSM             = #NN_HAUSNUMERO + 54

; Structure
Structure ZmqMsgT
  _.b[64]
EndStructure

; Callback Function
;PrototypeC NnThreadFnProc(vData.i)
;PrototypeC NnFreeFnProc(vData.i, vHint.i)
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 88
; FirstLine = 70
; Folding = -----
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicZMQ
; VersionField4 = 1.0.0