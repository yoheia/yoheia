#!/bin/ksh
#------------------------------------------------------------------------------
#--
#-- Copyright 2017 Tanel Poder ( tanel@tanelpoder.com | http://tanelpoder.com )
#--
#-- Licensed under the Apache License, Version 2.0 (the "License");
#-- you may not use this file except in compliance with the License.
#-- You may obtain a copy of the License at
#--
#--     http://www.apache.org/licenses/LICENSE-2.0
#--
#-- Unless required by applicable law or agreed to in writing, software
#-- distributed under the License is distributed on an "AS IS" BASIS,
#-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#-- See the License for the specific language governing permissions and
#-- limitations under the License.
#--
#------------------------------------------------------------------------------

TRACEFILE=$1

sed -e '
s/</\&lt;/g
s/>/\&gt;/g
s/SO: \(0x[A-Fa-f0-9]*\)/<a name="#\1">SO: \1<\/a>/
s/LIBRARY HANDLE:\(0x[A-Fa-f0-9]*\)/<a name="#\1">LIBRARY HANDLE:\1<\/a>/
s/owner: \(0x[A-Fa-f0-9]*\)/owner: <a href="#\1">\1<\/a>/
s/handle=\(0x[A-Fa-f0-9]*\)/handle=<a href="#\1">\1<\/a>/
' $TRACEFILE | awk '
   BEGIN { print "<html><head><title>ssexplorer output</title></head><body><pre><code>" }
   { print $0 }
   END { print "</code></pre></body></html>" }
' > ~/blah.html


#awk '
#
#    BEGIN { print "<html><head><title>ssexplorer output</title></head><body><pre><code>" }
#    
#    /0x[A-Fa-f0-9]/ { gsub( /(0x[A-Fa-f0-9]*)/, "<a href=\"#&\">&</a>", $0 ) }
#     
##    /SO: 0x[A-Za-z0-9]/ {
##        match($0, /(0x[A-Fa-f0-9]*),/ , arr)
##        printf ("<a name=\"%s\"></a>%s\n", arr[1], gsub( /(0x[A-Fa-f0-9]*)/, "<a href=\"#&\">&</a>", $0 ) )
##        
##    }
##    !/SO: 0x[A-Fa-f0-9]/ { gsub(/(0x[A-Fa-f0-9]*)/, "<a href=\"#&\">&</a>", $0) ; printf("%s\n", $0)  }
#    
#    
#    END { print "</code></pre></body></html>" }
#    
#
#' | awk '/SO: / { sub( /<a href=/, "<a name=" ) }' > ~/blah.html


