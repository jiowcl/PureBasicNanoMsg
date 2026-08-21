# PureBasicNanoMsg  

Nanomsg/NNG Wrapper for PureBasic Programming Language.

![GitHub](https://img.shields.io/github/license/jiowcl/PureBasicNanoMsg.svg)
![PureBasic](https://img.shields.io/badge/language-PureBasic-blue.svg)
![Dependency](https://img.shields.io/badge/Protocol-nanomsg-3A3A3A?style=flat-square)

> **Note:** nanomsg is no longer maintained. For new work, use the sibling package [`PureBasicNNG`](./PureBasicNNG) (NNG / nanomsg-next-gen). The APIs are not compatible.

## Environment  

- Windows 7 above (recommend)  
- PureBasic 6.0 above (recommend)  
- [Nanomsg](https://github.com/nanomsg/nanomsg)  
- [NNG](https://github.com/nanomsg/nng)  

## How to Build  

Building requires PureBasic Compiler and test under Windows 11.  
Module features require PureBasic 5.20 and above.  

Bundled runtime: `PureBasicNanoMsg/Library/x64/nanomsg.dll` (x64 only).

## API Notes  

- `NnSetsockopt` / `NanomsgSocket::Setsockopt` take a pointer (`*optval`).
- Use `NnSetsockoptString` / `SetsockoptString` for topic strings (`NN_SUB_SUBSCRIBE`).
- Use `NnSetsockoptInt` / `SetsockoptInt` for integer options (`NN_RCVTIMEO`, …).
- `NnGetsockopt` requires `*optvallen` (in/out length), matching the C API.
- `NnSend` takes a buffer pointer; use `NnSendString` / `SendString` for text.
- `NnPoll` + `NnPollFd` support non-blocking readiness checks.
- Zero-copy helpers: `NnAllocmsg` / `NnReallocmsg` / `NnFreemsg` with `#NN_MSG`.
- Scatter/gather: `NnSendmsg` / `NnRecvmsg` with `NnIovec` / `NnMsghdr` (see `SendmsgIovec` example).
- Ancillary helpers: `NnCmsgFirstHdr` / `NnCmsgNxtHdr` / `NnCmsgData` / `NnCmsgSpace` / `NnCmsgLen`.
- `NnDllOpen` resolves all `nn_*` exports once into `gNnFuncs` (`FuncTable.pbi`); later calls reuse the cache.
- Examples check DLL/socket/bind|connect return values and use `PeekS(buf, recvRc, #PB_Ascii)` (nn_recv has no null terminator).

## Example  

Publisher Server

```purebasic
EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NanomsgWrapper.pbi"

UseModule NanomsgWrapper

Global lpszCurrentDir.s = GetCurrentDirectory()

; Nanomsg version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNnDir.s = "Library/x64"
  Global lpszLibNnDll.s = lpszCurrentDir + lpszLibNnDir + "/nanomsg.dll"
  
  SetCurrentDirectory(lpszCurrentDir + lpszLibNnDir)
CompilerElse
  CompilerError "Only x64 nanomsg.dll is bundled."
CompilerEndIf

Global lpszServerAddr.s = "tcp://*:1689"

If DllOpen(lpszLibNnDll) = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_PUB)

If Socket < 0
  PrintN("Socket failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  CloseConsole()
  DllClose()
  End 1
EndIf

Define Rc.i = NanomsgSocket::Bind(Socket, lpszServerAddr)

If Rc < 0
  PrintN("Bind failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

PrintN("Bind an IP address: " + lpszServerAddr)

While 1
  Define lpszTopic.s = "quotes"
  ; Prefix must match NN_SUB_SUBSCRIBE filter on the subscriber.
  Define lpszMessage.s = lpszTopic + "#Bid:" + Random(9000, 1000) + ",Ask:" + Random(9000, 1000)
  
  Rc = NanomsgSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0)
  
  If Rc >= 0
    PrintN("Published: " + lpszMessage)
  Else
    PrintN("Send failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  EndIf
  
  Delay(500)
Wend

NanomsgSocket::Close(Socket)
CloseConsole()
DllClose()
```

Subscribe Client

```purebasic
EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NanomsgWrapper.pbi"

UseModule NanomsgWrapper

Global lpszCurrentDir.s = GetCurrentDirectory()

; Nanomsg version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNnDir.s = "Library/x64"
  Global lpszLibNnDll.s = lpszCurrentDir + lpszLibNnDir + "/nanomsg.dll"
  
  SetCurrentDirectory(lpszCurrentDir + lpszLibNnDir)
CompilerElse
  CompilerError "Only x64 nanomsg.dll is bundled."
CompilerEndIf

Global lpszServerAddr.s = "tcp://localhost:1689"

If DllOpen(lpszLibNnDll) = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

OpenConsole()

Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_SUB)

If Socket < 0
  PrintN("Socket failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  CloseConsole()
  DllClose()
  End 1
EndIf

Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)

If Rc < 0
  PrintN("Connect failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

Define lpszSubscribe.s = "quotes"

Rc = NanomsgSocket::SetsockoptString(Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe)

If Rc < 0
  PrintN("Subscribe failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  NanomsgSocket::Close(Socket)
  CloseConsole()
  DllClose()
  End 1
EndIf

While 1
  Define *lpszBuffer = AllocateMemory(256)
  Define recvRc.i = NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
  
  ; nn_recv does not append a null terminator; use the returned length.
  If recvRc >= 0
    PrintN(PeekS(*lpszBuffer, recvRc, #PB_Ascii))
  Else
    PrintN("Recv failed: " + NanomsgRuntime::Strerror(NanomsgRuntime::Errno()))
  EndIf
  
  FreeMemory(*lpszBuffer)
Wend

NanomsgSocket::Close(Socket)
Input()
CloseConsole()
DllClose()
```

More samples under `PureBasicNanoMsg/Example`:

- PUB/SUB, REQ/REP, PUSH/PULL (with `NnPoll`)
- Survey (`SurveyorServer` / `RespondentClient`, deadline + `ETIMEDOUT` / `EFSM`)
- Bus (`BusServer` / `BusClient`, bidirectional with `NnPoll`)
- PAIR + `inproc://` smoke test (`PairInproc`)
- `nn_sendmsg` / `nn_recvmsg` iovec smoke test (`SendmsgIovec`)

## License  

Copyright (c) 2017-2026 Ji-Feng Tsai.  
Code released under the MIT license.  

## TODO  

- `nn_device`  

## Donation  

If this application help you reduce time to coding, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/TW/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3RNMD6Q3B495N&source=url)

[Paypal Me](https://paypal.me/jiowcl?locale.x=zh_TW)
