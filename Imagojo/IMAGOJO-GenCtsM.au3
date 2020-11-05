#include "MD5.AU3"

#cs
;obteniendo Mac de getmac
	SplashOff()
	FileDelete(@TempDir & "\Mac.dat")
	RunWait( @comspec & " /c getmac > " & @TempDir & "\Mac.dat",$dir,@SW_HIDE)
	Sleep(500)
	$file = FileOpen(@TempDir & "\Mac.dat", 0)
	If $file = -1 Then
    MsgBox(0, "Error 159", "No se pudo leer archivo Mac.dat. Chequear instalación")
	Exit
	EndIf
	$Lectura = FileRead($file)
	;Se busca donde terminan los datos validos
	$result = StringInStr($Lectura, "=",0, -1) ;busca la posición del último signo de igual luego viene el dato
	$result = $result+3;se posiciona exactamente donde terninan los datos
	$var = StringMid($Lectura, $result, 17);lee los 17 caracteres a partir de la posición $result hallada
	;$resultado = StringInStr($var, "\")
	;$var= StringTrimLeft($var, $resultado-1)	
    MsgBox(0, "de getmac", $var)
	FileClose($file)
#ce
	Global $dir
	;Chequeando la contraseña
	$passwd = InputBox("Imagojo: Generador MAC", "Ingrese su contraseña.", "", "*")
	If $passwd='imagojo1' Then
	Else
		Exit
		EndIf
		;obteniendo Mac de ipconfig /all
	FileDelete(@TempDir & "\Mac.dat")
	RunWait( @comspec & " /c ipconfig /all > " & @TempDir & "\Mac.dat",$dir,@SW_HIDE)
	Sleep(500)
	$file = FileOpen(@TempDir & "\Mac.dat", 0)
	If $file = -1 Then
    MsgBox(0, "Error 181", "No se pudo leer archivo Mac.dat. Chequear instalación")
	Exit
	EndIf
	$Lectura = FileRead($file)
	;Se busca donde terminan los datos validos
	$result = StringInStr($Lectura, "sica",0, 1) ;busca la posición de la primera dirección física
	$result = StringInStr($Lectura, ":",0, 1, $result) ;busca los primeros : después de la palabra fisica
	$result = $result+2;se posiciona exactamente donde terninan los datos
	$var = StringMid($Lectura, $result, 17);lee los 17 caracteres a partir de la posición $result hallada
	;$resultado = StringInStr($var, "\")
	;$var= StringTrimLeft($var, $resultado-1)
$answer = MsgBox(4, "Mac hallada:", $var&@CRLF&"¿Aplicar permiso?")	
    ;MsgBox(0, "de ipconfig la Mac es:", $var)
	FileClose($file)
If $answer = 7 Then
     Exit
EndIf
$Ruta_IMAGOJO=IniRead("IMAGOJO.ini", "Directorios", "Ruta_IMAGOJO", 'C:\IMAGOJO')
$arch_ctsM=$Ruta_IMAGOJO&'\Lib\ctsM.imj'
$sDigest = md5($var&"64K")
;MsgBox(0, "MD5", $sDigest)
$file = FileOpen($arch_ctsM, 9)
FileWriteLine($file, $sDigest)
FileClose($file)
$file = FileOpen($arch_ctsM, 0)
$lectura=FileRead($file)
MsgBox(0, "MD5", $lectura)
FileClose($file)

$answer2 = MsgBox(4, "Acceso directo a IMAGOJO", $var&@CRLF&"¿Crear acceso directo?")	
    ;MsgBox(0, "de ipconfig la Mac es:", $var)
	FileClose($file)
If $answer2 = 7 Then
     Exit
EndIf
FileCreateShortcut("C:\IMAGOJO\IMAGOJO1-00.exe",@DesktopDir & "\Acceso a IMAGOJO.lnk","C:\IMAGOJO\" )
