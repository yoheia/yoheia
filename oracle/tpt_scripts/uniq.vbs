'------------------------------------------------------------------------------
'--
'-- Copyright 2017 Tanel Poder ( tanel@tanelpoder.com | http://tanelpoder.com )
'--
'-- Licensed under the Apache License, Version 2.0 (the "License");
'-- you may not use this file except in compliance with the License.
'-- You may obtain a copy of the License at
'--
'--     http://www.apache.org/licenses/LICENSE-2.0
'--
'-- Unless required by applicable law or agreed to in writing, software
'-- distributed under the License is distributed on an "AS IS" BASIS,
'-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
'-- See the License for the specific language governing permissions and
'-- limitations under the License.
'--
'------------------------------------------------------------------------------

Dim curRow, prevRow, rowCount, lineSize

prevRow = ""
rowCount= 0
lineSize = 900

Set re1 = New RegExp
re1.Pattern = "\+[0-9]*"
re1.Global = True

Set re2 = New RegExp
re2.Pattern = ".*sspuser\(\)"
re2.Global = False
re2.IgnoreCase = True

Set re3 = New RegExp
re3.Pattern = ".*(" & WScript.Arguments.Item(0) & "\(\)<-)"
're3.Pattern = ".*<-(.*\(\)<-" & WScript.Arguments.Item(0) & "\(\)<-)"
re3.Global = False
re3.IgnoreCase = True


With WScript
    Do 
        curRow = re3.replace(re2.replace(re1.Replace(WScript.StdIn.ReadLine, ""),""), "$1")
        If rowCount = 0 Then prevRow = curRow

        rowCount = rowCount + 1
        If curRow <> prevRow Then 
            WScript.StdOut.WriteLine Space(6-Len(rowCount - 1)) & rowCount - 1 & " " & Space(lineSize-Len(prevRow)) & prevRow
            rowCount = 1
        End If
        prevRow = curRow
    Loop Until WScript.StdIn.AtEndOfStream
    WScript.StdOut.WriteLine Space(6-Len(rowCount)) & rowCount & " " & Space(lineSize-Len(prevRow)) & prevRow
End With
