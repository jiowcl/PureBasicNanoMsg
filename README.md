# PureBasicNanoMsg  

Nanomsg Wrapper for PureBasic Programming Language.

![GitHub](https://img.shields.io/github/license/jiowcl/PureBasicNanoMsg.svg)
![PureBasic](https://img.shields.io/badge/language-PureBasic-blue.svg)

## Environment  

- Windows 7 above (recommend)  
- PureBasic 6.0 above (recommend)  
- [Nanomsg](https://github.com/nanomsg/nanomsg)  

## How to Build  

Building requires PureBasic Compiler and test under Windows 10.  
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

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_PUB)
  Define Rc.i = NanomsgSocket::Bind(Socket, lpszServerAddr)
  
  PrintN("Bind an IP address: " + lpszServerAddr)
  
  While 1
    Define lpszTopic.s = "quotes"
    Define lpszMessage.s = lpszTopic + "#Bid:" + Random(9000, 1000) + ",Ask:" + Random(9000, 1000)
    
    NanomsgSocket::SendString(Socket, lpszMessage, Len(lpszMessage), 0)
    PrintN("Published: " + lpszMessage)
    
    Delay(500)
  Wend
  
  NanomsgSocket::Close(Socket)
  
  CloseConsole()
  
  DllClose()
EndIf
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

If DllOpen(lpszLibNnDll)
  OpenConsole()

  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_SUB)
  Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)
  
  Define lpszSubscribe.s = "quotes"
  
  NanomsgSocket::SetsockoptString(Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe)
  
  While 1
    Define *lpszBuffer = AllocateMemory(256)
    
    If NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0) >= 0
      PrintN(PeekS(*lpszBuffer, -1, #PB_UTF8))
    EndIf
    
    FreeMemory(*lpszBuffer)
    
    Delay(10)
  Wend   
  
  NanomsgSocket::Close(Socket)
  
  Input()
  CloseConsole()
  
  DllClose()
EndIf
```

More samples under `PureBasicNanoMsg/Example`:

- PUB/SUB, REQ/REP, PUSH/PULL (with `NnPoll`)
- Survey (`SurveyorServer` / `RespondentClient`, deadline + `ETIMEDOUT` / `EFSM`)
- PAIR + `inproc://` smoke test (`PairInproc`)

## License  

Copyright (c) 2017-2026 Ji-Feng Tsai.  
Code released under the MIT license.  

## TODO  

- Bus example  
- `nn_sendmsg` / `nn_recvmsg` / `nn_device`  


## Donation  

If this application help you reduce time to coding, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/TW/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3RNMD6Q3B495N&source=url)

[Paypal Me](https://paypal.me/jiowcl?locale.x=zh_TW)
