# PureBasicNanoMsg

Nanomsg Wrapper for PureBasic Programming Language.

![GitHub](https://img.shields.io/github/license/jiowcl/PureBasicNanoMsg.svg)
![PureBasic](https://img.shields.io/badge/language-PureBasic-blue.svg)

## Environment

- Windows 7 above (recommend)  
- PureBasic 6.0 above (recommend)  
- [Nanomsg](https://github.com/nanomsg)  

## How to Build

Building requires PureBasic Compiler and test under Windows 10.  
Module features require PureBasic 5.20 and above.

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
CompilerEndIf

Global lpszServerAddr.s = "tcp://*:1689"

If DllOpen(lpszLibNnDll)
  OpenConsole()
  
  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_PUB)
  Define Rc.i = NanomsgSocket::Bind(Socket, lpszServerAddr)
  
  PrintN("Bind an IP address: " + lpszServerAddr)
  
  While 1
    Define *lpszBuffer = AllocateMemory(32)
    Define lpszTopic.s = "quotes"
    Define lpszMessage.s = lpszTopic + "#Bid:" + Random(9000, 1000) + ",Ask:" + Random(9000, 1000)
    
    NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    Delay(10)
    
    Define lpszReturnMessage.s = PeekS(*lpszBuffer, -1, #PB_UTF8)
    
    If lpszReturnMessage <> ""
      PrintN("Received: ")
      PrintN(lpszReturnMessage)
    EndIf
    
    NanomsgSocket::Send(Socket, lpszMessage, Len(lpszMessage), 0)
    
    FreeMemory(*lpszBuffer)
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
CompilerEndIf

Global lpszServerAddr.s = "tcp://localhost:1689"

If DllOpen(lpszLibNnDll)
  OpenConsole()

  Define Socket.i = NanomsgSocket::Socket(#AF_SP, #NN_SUB)
  Define Rc.i = NanomsgSocket::Connect(Socket, lpszServerAddr)
  
  Define lpszSubscribe.s = "quotes"
  
  NanomsgSocket::Setsockopt(Socket, #NN_SUB, #NN_SUB_SUBSCRIBE, lpszSubscribe, Len(lpszSubscribe))
  
;   Define i.i
;
;   For i = 0 To 10 
;     *lpszBuffer = AllocateMemory(32)
;     
;     NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
;     
;     PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
;     
;     FreeMemory(*lpszBuffer)
;   Next
  
  While 1
    Define *lpszBuffer = AllocateMemory(32)
    
    NanomsgSocket::Recv(Socket, *lpszBuffer, MemorySize(*lpszBuffer), 0)
    
    PrintN( PeekS(*lpszBuffer, -1, #PB_UTF8) )
    
    FreeMemory(*lpszBuffer)
    
    Delay(10)
  Wend   
  
  NanomsgSocket::Close(Socket)
  
  Input()
  CloseConsole()
  
  DllClose()
EndIf
```

## License

Copyright (c) 2017-2024 Ji-Feng Tsai.  
Code released under the MIT license.  

## TODO

- More examples  

## Donation

If this application help you reduce time to coding, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/TW/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3RNMD6Q3B495N&source=url)

[Paypal Me](https://paypal.me/jiowcl?locale.x=zh_TW)
