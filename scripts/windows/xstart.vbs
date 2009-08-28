' http://cx20.main.jp/pukiwiki/pukiwiki.php?Software/WSH#content_1_18

Set args = Wscript.Arguments
If args.Count < 1 Then
    Wscript.StdOut.WriteLine "xstart <command> [<computer>]"
Else
    '--- コマンド指定
    strCommand = args(0)
    '--- コンピュータ指定
    strComputerPath = ""
    If args.Count = 2 Then
        strComputer = args(1)
        If InStr(strComputer, "\\") = 1 Then
            strComputer = Mid(strComputer, 3)
        End If
        strComputerPath = "\\" & strComputer & "\root\cimv2:"
    End If
    '--- WMI に接続 Wim32_Process クラスを取り出す
    Set clsProcess = GetObject("winmgmts:{impersonationLevel=impersonate}" _
        & "!" & strComputerPath & "Win32_Process")
   '--- プロセスの作成
    lngResult = clsProcess.Create(strCommand)
    Wscript.StdOut.WriteLine strCommand & " :" & lngResult
End If
