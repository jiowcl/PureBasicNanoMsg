# PureBasicNNG

NNG (nanomsg-next-gen) Wrapper for PureBasic Programming Language.

![PureBasic](https://img.shields.io/badge/language-PureBasic-blue.svg)
![Dependency](https://img.shields.io/badge/Protocol-nng-3A3A3A?style=flat-square)

This package is the NNG counterpart of [PureBasicNanoMsg](../PureBasicNanoMsg).  
nanomsg is no longer maintained; new projects should prefer NNG. The two wrappers are **API-incompatible** and live side by side.

## Environment

- Windows 7 above (recommend)
- PureBasic 6.0 above (recommend)
- [NNG](https://github.com/nanomsg/nng)

## How to Build

Building requires PureBasic Compiler and test under Windows 10.  
Module features require PureBasic 5.20 and above.

Bundled runtime: `Library/x64/nng.dll` (x64 only).

## API Notes

- Success is `#NNG_OK` (`0`). Unlike nanomsg, most calls return an `nng_err` directly (no `nn_errno`).
- Create sockets with protocol helpers: `PubOpen`, `SubOpen`, `ReqOpen`, … (not `Socket(domain, protocol)`).
- Use `Listen` / `Dial` instead of nanomsg `Bind` / `Connect`.
- `Recv` (Module) returns the byte count on success, or `-1` on failure; read `NngRuntime::LastError()` for the `nng_err`.
- Low-level `NngRecv` takes an in/out size pointer (`*sz`), matching the C API.
- Socket options use string names (`#NNG_OPT_RECVTIMEO`, …) with typed setters (`SetMs` / `SetInt` / `SetSize`).
- SUB topics use `Subscribe` / `Unsubscribe` (`nng_sub0_socket_subscribe`).
- Call `nng_init` via `DllOpen` (Module) or `NngInit` (low-level); pair with `DllClose` / `NngFini`.
- There is no `nn_poll`; use `SetMs(..., #NNG_OPT_RECVTIMEO, …)` or `GetRecvPollFd` with an OS poll.

## Example

Publisher Server

```purebasic
EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NngWrapper.pbi"

UseModule NngWrapper

Global lpszCurrentDir.s = GetCurrentDirectory()

CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNngDir.s = "Library/x64"
  Global lpszLibNngDll.s = lpszCurrentDir + lpszLibNngDir + "/nng.dll"
  SetCurrentDirectory(lpszCurrentDir + lpszLibNngDir)
CompilerElse
  CompilerError "Only x64 nng.dll is bundled."
CompilerEndIf

Global lpszServerAddr.s = "tcp://*:1689"

If DllOpen(lpszLibNngDll)
  OpenConsole()
  
  Define Socket.i = NngSocket::PubOpen()
  Define Rc.i = NngSocket::Listen(Socket, lpszServerAddr)
  
  If Rc <> #NNG_OK
    PrintN("Listen failed: " + NngRuntime::Strerror(Rc))
  EndIf
  
  While 1
    Define lpszMessage.s = "quotes#hello"
    NngSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0)
    Delay(500)
  Wend
  
  NngSocket::Close(Socket)
  CloseConsole()
  DllClose()
EndIf
```

Subscribe Client

```purebasic
EnableExplicit

IncludeFile "../../Core/Enums.pbi"
IncludeFile "../../Core/NngWrapper.pbi"

UseModule NngWrapper

; ... DllOpen as above ...

Define Socket.i = NngSocket::SubOpen()
NngSocket::Dial(Socket, "tcp://localhost:1689")
NngSocket::Subscribe(Socket, "quotes")

Define *lpszBuffer = AllocateMemory(256)
Define recvRc.i = NngSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)

If recvRc >= 0
  PrintN(PeekS(*lpszBuffer, recvRc, #PB_Ascii))
EndIf
```

More samples under `Example`:

- PUB/SUB, REQ/REP, PUSH/PULL (recv-timeout instead of `nn_poll`)
- Survey (`SurveyorServer` / `RespondentClient`)
- PAIR + `inproc://` smoke test (`PairInproc`)

## Nanomsg vs NNG (quick map)

| Nanomsg | NNG (this wrapper) |
|---------|--------------------|
| `nn_socket(AF_SP, NN_PUB)` | `PubOpen()` |
| `Bind` / `Connect` | `Listen` / `Dial` |
| `Rc < 0` failure | `Rc <> #NNG_OK` failure |
| `nn_errno` | return code / `LastError()` |
| `SetsockoptInt(..., NN_RCVTIMEO, …)` | `SetMs(sock, #NNG_OPT_RECVTIMEO, …)` |
| `SetsockoptString(..., NN_SUB_SUBSCRIBE, …)` | `Subscribe(sock, topic)` |

## License

Copyright (c) 2017-2026 Ji-Feng Tsai.  
Code released under the MIT license.

## TODO

- `nng_msg_*` / `Sendmsg` / `Recvmsg`
- dialer / listener fine-grained control
- `nng_aio` asynchronous API
- Bus example

## Donation  

If this application help you reduce time to coding, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/TW/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3RNMD6Q3B495N&source=url)

[Paypal Me](https://paypal.me/jiowcl?locale.x=zh_TW)
