;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

; NNG Library & API version (from nng.h)
#NNG_MAJOR_VERSION = 2
#NNG_MINOR_VERSION = 0
#NNG_PATCH_VERSION = 0

; Maximum length of a socket address (includes terminating NUL)
#NNG_MAXADDRLEN = 128

; Flags
#NNG_FLAG_NONBLOCK = 2

; Duration helpers (milliseconds)
#NNG_DURATION_INFINITE = -1
#NNG_DURATION_DEFAULT  = -2
#NNG_DURATION_ZERO     = 0

; Socket option names (string options used by nng_socket_set_* / get_*)
#NNG_OPT_RECVBUF    = "recv-buffer"
#NNG_OPT_SENDBUF    = "send-buffer"
#NNG_OPT_RECVTIMEO  = "recv-timeout"
#NNG_OPT_SENDTIMEO  = "send-timeout"
#NNG_OPT_LOCADDR    = "local-address"
#NNG_OPT_MAXTTL     = "ttl-max"
#NNG_OPT_RECVMAXSZ  = "recv-size-max"
#NNG_OPT_RECONNMINT = "reconnect-time-min"
#NNG_OPT_RECONNMAXT = "reconnect-time-max"
#NNG_OPT_TCP_NODELAY   = "tcp-nodelay"
#NNG_OPT_TCP_KEEPALIVE = "tcp-keepalive"

; Protocol-specific option names
#NNG_OPT_SUB_PREFNEW          = "sub:prefnew"
#NNG_OPT_REQ_RESENDTIME       = "req:resend-time"
#NNG_OPT_REQ_RESENDTICK       = "req:resend-tick"
#NNG_OPT_SURVEYOR_SURVEYTIME  = "surveyor:survey-time"
#NNG_OPT_PAIR1_POLY           = "pair1:polyamorous"

; Error codes (nng_err)
#NNG_OK           = 0
#NNG_EINTR        = 1
#NNG_ENOMEM       = 2
#NNG_EINVAL       = 3
#NNG_EBUSY        = 4
#NNG_ETIMEDOUT    = 5
#NNG_ECONNREFUSED = 6
#NNG_ECLOSED      = 7
#NNG_EAGAIN       = 8
#NNG_ENOTSUP      = 9
#NNG_EADDRINUSE   = 10
#NNG_ESTATE       = 11
#NNG_ENOENT       = 12
#NNG_EPROTO       = 13
#NNG_EUNREACHABLE = 14
#NNG_EADDRINVAL   = 15
#NNG_EPERM        = 16
#NNG_EMSGSIZE     = 17
#NNG_ECONNABORTED = 18
#NNG_ECONNRESET   = 19
#NNG_ECANCELED    = 20
#NNG_ENOFILES     = 21
#NNG_ENOSPC       = 22
#NNG_EEXIST       = 23
#NNG_EREADONLY    = 24
#NNG_EWRITEONLY   = 25
#NNG_ECRYPTO      = 26
#NNG_EPEERAUTH    = 27
#NNG_EBADTYPE     = 30
#NNG_ECONNSHUT    = 31
#NNG_ESTOPPED     = 999
#NNG_EINTERNAL    = 1000
#NNG_ESYSERR      = $10000000
#NNG_ETRANERR     = $20000000

; Structure (matches struct nng_socket / nng_dialer / nng_listener / nng_ctx)
; On Windows x64 these are passed by value as a single uint32_t id.
Structure NngSocket Align #PB_Structure_AlignC
  id.l
EndStructure

Structure NngDialer Align #PB_Structure_AlignC
  id.l
EndStructure

Structure NngListener Align #PB_Structure_AlignC
  id.l
EndStructure

Structure NngCtx Align #PB_Structure_AlignC
  id.l
EndStructure

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField4 = 1.0.0
