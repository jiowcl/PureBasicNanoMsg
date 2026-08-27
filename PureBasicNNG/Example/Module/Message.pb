;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NngWrapper.pbi"

UseModule NngWrapper

Global lpszCurrentDir.s = GetCurrentDirectory()

; NNG version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNngDir.s = "Library/x64"
  Global lpszLibNngDll.s = lpszCurrentDir + lpszLibNngDir + "/nng.dll"

  SetCurrentDirectory(lpszCurrentDir + lpszLibNngDir)
CompilerElse
  CompilerError "Only x64 nng.dll is bundled."
CompilerEndIf

Global lpszAddr.s = "inproc://pb-message-smoke"

If DllOpen(lpszLibNngDll)
  OpenConsole()

  Define ok.i = #True
  Define *msg = NngMessage::Alloc(0)

  If *msg = 0
    PrintN("Alloc failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
    ok = #False
  EndIf

  If ok And NngMessage::AppendString(*msg, "hello") <> #NNG_OK
    PrintN("Append failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
    ok = #False
  EndIf

  If ok And NngMessage::HeaderAppendString(*msg, "hdr") <> #NNG_OK
    PrintN("HeaderAppend failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
    ok = #False
  EndIf

  If ok And NngMessage::Length(*msg) <> 5
    PrintN("Unexpected body length.")
    ok = #False
  EndIf

  If ok And NngMessage::HeaderLen(*msg) <> 3
    PrintN("Unexpected header length.")
    ok = #False
  EndIf

  Define headerValue16.w
  Define headerValue32.l
  Define headerValue64.q

  If ok And NngMessage::HeaderAppendU16(*msg, $2345) <> #NNG_OK
    PrintN("HeaderAppendU16 failed.")
    ok = #False
  EndIf

  If ok And NngMessage::HeaderChopU16(*msg, @headerValue16) <> #NNG_OK
    PrintN("HeaderChopU16 failed.")
    ok = #False
  ElseIf ok And headerValue16 <> $2345
    PrintN("Unexpected header U16 value.")
    ok = #False
  EndIf

  If ok And NngMessage::HeaderAppendU32(*msg, $34567890) <> #NNG_OK
    PrintN("HeaderAppendU32 failed.")
    ok = #False
  EndIf

  If ok And NngMessage::HeaderChopU32(*msg, @headerValue32) <> #NNG_OK
    PrintN("HeaderChopU32 failed.")
    ok = #False
  ElseIf ok And headerValue32 <> $34567890
    PrintN("Unexpected header U32 value.")
    ok = #False
  EndIf

  If ok And NngMessage::HeaderAppendU64(*msg, $456789ABCDEF0123) <> #NNG_OK
    PrintN("HeaderAppendU64 failed.")
    ok = #False
  EndIf

  If ok And NngMessage::HeaderChopU64(*msg, @headerValue64) <> #NNG_OK
    PrintN("HeaderChopU64 failed.")
    ok = #False
  ElseIf ok And headerValue64 <> $456789ABCDEF0123
    PrintN("Unexpected header U64 value.")
    ok = #False
  EndIf

  Define *copy
  If ok
    *copy = NngMessage::Duplicate(*msg)
    If *copy = 0 Or NngMessage::Length(*copy) <> 5
      PrintN("Duplicate failed.")
      ok = #False
    EndIf
  EndIf

  If *copy
    NngMessage::Free(*copy)
  EndIf

  If ok And NngMessage::AppendU16(*msg, $1234) <> #NNG_OK
    PrintN("AppendU16 failed.")
    ok = #False
  EndIf

  Define value.w
  If ok And NngMessage::ChopU16(*msg, @value) <> #NNG_OK
    PrintN("ChopU16 failed.")
    ok = #False
  ElseIf ok And value <> $1234
    PrintN("Unexpected U16 value.")
    ok = #False
  EndIf

  If ok And NngMessage::AppendU32(*msg, $12345678) <> #NNG_OK
    PrintN("AppendU32 failed.")
    ok = #False
  EndIf

  Define value32.l
  If ok And NngMessage::ChopU32(*msg, @value32) <> #NNG_OK
    PrintN("ChopU32 failed.")
    ok = #False
  ElseIf ok And value32 <> $12345678
    PrintN("Unexpected U32 value.")
    ok = #False
  EndIf

  If ok And NngMessage::AppendU64(*msg, $123456789ABCDEF0) <> #NNG_OK
    PrintN("AppendU64 failed.")
    ok = #False
  EndIf

  Define value64.q
  If ok And NngMessage::ChopU64(*msg, @value64) <> #NNG_OK
    PrintN("ChopU64 failed.")
    ok = #False
  ElseIf ok And value64 <> $123456789ABCDEF0
    PrintN("Unexpected U64 value.")
    ok = #False
  EndIf

  If *msg
    NngMessage::Free(*msg)
  EndIf

  Define sockA.l = NngSocket::PairOpen()
  Define sockB.l = NngSocket::PairOpen()

  If sockA = 0 Or sockB = 0
    PrintN("PAIR open failed.")
    ok = #False
  EndIf

  If ok And NngSocket::Listen(sockA, lpszAddr) <> #NNG_OK
    PrintN("PAIR listen failed.")
    ok = #False
  EndIf

  If ok And NngSocket::Dial(sockB, lpszAddr) <> #NNG_OK
    PrintN("PAIR dial failed.")
    ok = #False
  EndIf

  Delay(50)

  If ok
    *msg = NngMessage::Alloc(0)
    NngMessage::AppendString(*msg, "message-api")

    If NngMessage::Sendmsg(sockA, *msg, 0) <> #NNG_OK
      PrintN("Sendmsg failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
      NngMessage::Free(*msg)
      ok = #False
    Else
      ; A successful Sendmsg transfers ownership to nng.
      *msg = 0
    EndIf
  EndIf

  If ok
    *msg = NngMessage::Recvmsg(sockB)

    If *msg = 0
      PrintN("Recvmsg failed: " + NngRuntime::Strerror(NngRuntime::LastError()))
      ok = #False
    ElseIf PeekS(NngMessage::Body(*msg), NngMessage::Length(*msg), #PB_Ascii) <> "message-api"
      PrintN("Unexpected received body.")
      ok = #False
    EndIf
  EndIf

  If *msg
    NngMessage::Free(*msg)
  EndIf

  NngSocket::Close(sockA)
  NngSocket::Close(sockB)

  If ok
    PrintN("Message API smoke test OK.")
  Else
    PrintN("Message API smoke test FAILED.")
  EndIf

  Input()
  CloseConsole()

  DllClose()

  If ok = #False
    End 1
  EndIf
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; Executable = ..\..\ModuleMessage.exe
; CurrentDirectory = ..\..\
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNNG
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
