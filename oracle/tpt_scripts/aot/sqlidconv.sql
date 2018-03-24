------------------------------------------------------------------------------
--
-- Copyright 2017 Tanel Poder ( tanel@tanelpoder.com | http://tanelpoder.com )
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
------------------------------------------------------------------------------

@saveset
set serverout on

def convstr=0123456789abcdfghjkmnpqrstuvwxyz
def base=32

declare
    r number := 0;
    j number := 0;
    a number := 0;
begin

    for i in 1..length('&1') loop

        j := length('&1') - i + 1; 
        -- dbms_output.put_line('i='||i||' j='||j||' chr='||substr('&1',i,1));

        a := (( power(&base, j-1) * (instr('&convstr',substr('&1',i,1))-1) ));
        -- dbms_output.put_line('    a='||a);

        r := r + a;
        
        -- dbms_output.put_line('    r='||to_char(r,'XXXXXXXXXXXXXXXX'));
        -- dbms_output.put_line('power='||to_char(power(&base, i-1)));
        -- dbms_output.put_line(' mult='||to_char(instr('&convstr',substr('&1',i,1))-1) );
        -- dbms_output.put_line('--');
        dbms_output.put_line('j='||j||' i='||i||' c='||substr('&1',i,1)||' mult='||to_char(instr('&convstr',substr('&1',i,1))-1)||' power='||to_char(power(&base, i-1))||' a='||a );
    end loop;
    dbms_output.put_line('result= '||r||' 0x'||trim(to_char(r, 'xxxxxxxxxxxxxxxxxxxxxxxx')));
    dbms_output.put_line('last 4B= '||trunc(mod(r,power(2,32)))||' 0x'||trim(to_char(trunc(mod(r,power(2,32))), 'xxxxxxxxxxxxxxxxxxxxxxxx')));
    
    dbms_output.put_line(chr(10)||'sqlid=&1 hash_value='|| trunc(mod(r,power(2,32))) );
end;
/

@loadset
