;--------------------------------------------------------------------------------------------
;  Copyright (c) Ji-Feng Tsai. All rights reserved.
;  Code released under the MIT license.
;--------------------------------------------------------------------------------------------

EnableExplicit

IncludeFile "../Core/Nanomsg.pbi"

Global lpszCurrentDir.s = GetCurrentDirectory()

; Nanomsg version (x64)
CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  Global lpszLibNnDir.s = "Library/x64"
  Global lpszLibNnDll.s = lpszCurrentDir + lpszLibNnDir + "/nanomsg.dll"
  
  SetCurrentDirectory(lpszCurrentDir + lpszLibNnDir)
CompilerElse
  CompilerError "Only x64 nanomsg.dll is bundled."
CompilerEndIf

; Scatter/gather via nn_sendmsg / nn_recvmsg (PAIR + inproc).
Global lpszAddr.s = "inproc://pb-sendmsg-iovec"

Global hLibrary.i = NnDllOpen(lpszLibNnDll)

If hLibrary = 0
  OpenConsole()
  PrintN("Failed to open nanomsg.dll: " + lpszLibNnDll)
  CloseConsole()
  End 1
EndIf

If hLibrary
  OpenConsole()
  
  Define sockA.i = NnSocket(hLibrary, #AF_SP, #NN_PAIR)
  Define sockB.i = NnSocket(hLibrary, #AF_SP, #NN_PAIR)
  Define Rc.i
  Define ok.i = #True
  
  Rc = NnBind(hLibrary, sockA, lpszAddr)
  Rc = NnConnect(hLibrary, sockB, lpszAddr)
  Delay(50)
  
  Define *seg1 = AllocateMemory(2)
  Define *seg2 = AllocateMemory(4)
  Define *recvBuf = AllocateMemory(6)
  Dim iov.NnIovec(1)
  Define hdr.NnMsghdr
  
  PokeS(*seg1, "AB", 2, #PB_Ascii)
  PokeS(*seg2, "CDEF", 4, #PB_Ascii)
  
  ; Send two iovec segments as one message: "AB" + "CDEF"
  iov(0)\iov_base = *seg1
  iov(0)\iov_len = 2
  iov(1)\iov_base = *seg2
  iov(1)\iov_len = 4
  
  FillMemory(@hdr, SizeOf(NnMsghdr), 0)
  hdr\msg_iov = @iov(0)
  hdr\msg_iovlen = 2
  
  Rc = NnSendmsg(hLibrary, sockB, @hdr, 0)
  
  If Rc <> 6
    PrintN("Sendmsg failed, rc=" + Str(Rc) + " err=" + NnStrerror(hLibrary, NnErrno(hLibrary)))
    ok = #False
  Else
    PrintN("Sendmsg OK, bytes=" + Str(Rc))
  EndIf
  
  ; Receive into two iovec segments (4 + 2 bytes).
  If ok
    FillMemory(*recvBuf, 6, 0)
    FillMemory(@hdr, SizeOf(NnMsghdr), 0)
    
    iov(0)\iov_base = *recvBuf
    iov(0)\iov_len = 4
    iov(1)\iov_base = *recvBuf + 4
    iov(1)\iov_len = 2
    hdr\msg_iov = @iov(0)
    hdr\msg_iovlen = 2
    
    Rc = NnRecvmsg(hLibrary, sockA, @hdr, 0)
    
    If Rc <> 6
      PrintN("Recvmsg failed, rc=" + Str(Rc) + " err=" + NnStrerror(hLibrary, NnErrno(hLibrary)))
      ok = #False
    Else
      Define got.s = PeekS(*recvBuf, 6, #PB_Ascii)
      
      PrintN("Recvmsg OK, bytes=" + Str(Rc) + " data=" + got)
      
      If got <> "ABCDEF"
        PrintN("Payload mismatch, expected ABCDEF.")
        ok = #False
      EndIf
    EndIf
  EndIf
  
  FreeMemory(*seg1)
  FreeMemory(*seg2)
  FreeMemory(*recvBuf)
  NnClose(hLibrary, sockA)
  NnClose(hLibrary, sockB)
  
  If ok
    PrintN("Sendmsg/Recvmsg iovec smoke test OK.")
  Else
    PrintN("Sendmsg/Recvmsg iovec smoke test FAILED.")
  EndIf
  
  CloseConsole()
  
  NnDllClose(hLibrary)
  
  If ok = #False
    End 1
  EndIf
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; Executable = ..\SendmsgIovec.exe
; CurrentDirectory = ../
; IncludeVersionInfo
; VersionField2 = Inwazy Technology
; VersionField3 = PureBasicNanoMsg
; VersionField9 = Ji-Feng Tsai
; VersionField13 = jiowcl@gmail.com
