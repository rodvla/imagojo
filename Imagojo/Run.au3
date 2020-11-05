;directorio de trabajo remoto de CtsU.imj
$Dir_ctsU=IniRead("IMAGOJO.ini", "Directorios", "CtsU", 'xx')
IF $Dir_ctsU='xx' THEN
	IniWrite("IMAGOJO.ini", "Directorios", "CtsU", '\\192.168.1.100\Users\Public\Documents')
	$Dir_ctsU='\\192.168.1.100\Users\Public\Documents'
	EndIf
	$arch_ctsU=$Dir_ctsU&"ctsU.imj"
	;MsgBox(0,'notepad.EXE "C:\IMAGOJO\lib\ctsU.imj"',$arch_ctsu)
;Run ( 'notepad.EXE "C:\IMAGOJO\lib\ctsU.imj"' )
;$a='notepad.EXE "C:\IMAGOJO\lib\ctsU.imj"'
	;MsgBox(0,'A notepad.EXE "C:\IMAGOJO\lib\ctsU.imj"',$a)
					
;$b='''notepad.EXE"'&$arch_ctsU&'"'''

$b='notepad.EXE'&" """&$arch_ctsU&""""

	MsgBox(0,'B notepad.EXE "C:\IMAGOJO\lib\ctsU.imj"',$b)
	
					;Run ( '''notepad.EXE "'&$arch_ctsU&'"''')
					;Run ( '''notepad.EXE "'&$arch_ctsU&'"''')
Run($b)

	MsgBox(0,'No corrió la puta que los parió',$b)