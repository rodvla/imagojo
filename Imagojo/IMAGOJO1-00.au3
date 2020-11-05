; Proyecto de fin de carrera: IMAGOJO
; Tutor: Franco Simini
; Programa IMAGOJO
; AutoIt 3.3.61
; Creado :12/11/10   Modificado: 29/2/12 
; Autores: Rodrigo Vlaeminck y Alvaro Prieto
;*********************************
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
SplashTextOn ("Programa IMAGOJO", "Abriendo aplicación... espere", 250,100)
If WinExists("IMAGOJO:", "") Then
SplashOff()
WinActivate("IMAGOJO:", "")
MsgBox(0, "ATENCIÓN", "IMAGOJO ya está en ejecución",5)
Exit
EndIf
#include <Date.au3>
#include <IE.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <DateTimeConstants.au3>

#include "MD5.AU3"

;MsgBox(0, "Prueba", "Mensaje",10)
Opt("WinTitleMatchMode", 1)
Opt("TrayIconHide", 1)
;Declaración de Variables
Global $Ced_pa = "", $Nom_pa = "",$Ape_pa = "", $DiaN_pa = "", $MesN_pa = "", $AniN_pa = "", $sex_paciente=" ", $Dir_pa = "", $Tel1_pa = "", $Tel2_pa = ""
Global $ced, $nom, $Ape, $DiaN, $Dir, $Tel1, $Tel2, $MesN, $AniN, $DiaN
Global $EstadoServ = "Inactivo", $IpPuertoServidor, $Arch_nuevo_dcm, $Azar, $Dir_jpg, $form1, $form2, $form3, $form4, $form5
Global $RutaCaptura, $AE2, $Coment_pa, $PUERTO2, $ALIAS1, $AE1, $IP1, $PUERTO1, $OPSAL=1, $Debug=1
Global $X_vent=-1, $Y_vent=-1, $PosVent, $var, $Coment, $Desc_estud, $Ruta_jpg, $Arch_jpg, $Dir_pdf, $Ruta_pdf
Global $form7, $form8, $form9, $form10, $form11, $form20, $form21, $form22, $Nom_paciente, $Dir_video
Global $Ruta_video, $form23, $form24, $form25, $NProgCaptura, $Dir_trab, $Temp_log, $FormXX, $X_ventE=790, $Y_ventE=35
Global $Pav=0, $arch_log, $Ocultar, $estudioSel="", $Consulta=0, $Nro_registros, $Nro_CONSULTA, $Query, $tipoId, $Cedula_valida=0
Global $MedRef, $PaintEst, $Asterisco, $Institucion, $Fecha_contenido, $Arch_pdf, $Arch_video, $Dpto, $Nro_registrosT

;DIRECTORIOS Y ARCHIVOS A INSTALAR
$Ruta_IMAGOJO=IniRead("IMAGOJO.ini", "Directorios", "Ruta_IMAGOJO", 'xx')
IF $Ruta_IMAGOJO='xx' THEN
	IniWrite("IMAGOJO.ini", "Directorios", "Ruta_IMAGOJO", 'C:\IMAGOJO')
	$Ruta_IMAGOJO='C:\IMAGOJO'
	EndIf

;ruta de archivos DICOM locales que se crearán
$Ruta_Dcm= IniRead("IMAGOJO.ini", "Directorios", "Ruta_Dcm", 'xx')
IF $Ruta_Dcm='xx' THEN
	IniWrite("IMAGOJO.ini", "Directorios", "Ruta_Dcm", $Ruta_IMAGOJO&'\DCM')
	$Ruta_Dcm=$Ruta_IMAGOJO&'\DCM'
	EndIf

$file =DirCreate($Ruta_Dcm)
	If $file = -1 Then
    MsgBox(0, "Error 78", "Intenta crear un directorio en"&@CRLF& "dipositivo sin espacio o de solo lectura")
	EndIf
$arch_log = $Ruta_IMAGOJO&'\Log\'&@YEAR&@MON&@MDAY&'.log';Creación de ruta y archivo log diario

$visorweb=IniRead("IMAGOJO.ini", "Directorios", "Visorweb", 'xx')
IF $visorweb='xx' THEN
	IniWrite("IMAGOJO.ini", "Directorios", "Visorweb", 'C:\IMAGOJO\GoogleChromePortable\GoogleChromePortable.exe')
	$visorweb='C:\IMAGOJO\GoogleChromePortable\GoogleChromePortable.exe'
	EndIf

$visor=IniRead("IMAGOJO.ini", "Directorios", "Ruta_Visor", 'xx')
IF $visor='xx' THEN 
	IniWrite("IMAGOJO.ini", "Directorios", "Ruta_Visor", 'C:\Archivos de programa\synedra\ViewPersonal\synedraViewPersonal.exe')
	$visor='C:\Archivos de programa\synedra\ViewPersonal\synedraViewPersonal.exe'
	EndIf

;directorio de trabajo de Dcm4che
$Dir_trab=IniRead("IMAGOJO.ini", "Java", "Dcm4che_bin", 'xx')
IF 'xx' THEN
	IniWrite("IMAGOJO.ini", "Java", "Dcm4che_bin", $Ruta_IMAGOJO&'\dcm4\bin\')
	$Dir_trab=$Ruta_IMAGOJO&'\dcm4\bin\'
	EndIf

DirCreate($Ruta_IMAGOJO&'\Lib\Gui')
DirCreate($Ruta_IMAGOJO&'\Estudios')
FileInstall ('C:\IMAGOJOInst\MD5.AU3', $Ruta_IMAGOJO&'\', 1)
FileInstall ('C:\IMAGOJOInst\Lib\IMAGOJODIR.exe', $Ruta_IMAGOJO&'\Lib\IMAGOJODIR.exe', 1)
FileInstall ('C:\IMAGOJOInst\Lib\IMAGOJODIR2.exe', $Ruta_IMAGOJO&'\Lib\IMAGOJODIR2.exe', 1)
FileInstall ('C:\IMAGOJOInst\Lib\IMAGOJORCV.exe', $Ruta_IMAGOJO&'\Lib\IMAGOJORCV.exe', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Ayuda IMAGOJO.chm', $Ruta_IMAGOJO&'\Lib\Ayuda IMAGOJO.chm', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\presentacion.jpg', $Ruta_IMAGOJO&'\Lib\Gui\presentacion.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\barrita1.jpg', $Ruta_IMAGOJO&'\Lib\Gui\barrita1.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\barrita2.jpg', $Ruta_IMAGOJO&'\Lib\Gui\barrita2.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\bandacolorV.gif', $Ruta_IMAGOJO&'\Lib\Gui\bandacolorV.gif', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\bandacolor.gif', $Ruta_IMAGOJO&'\Lib\Gui\bandacolor.gif', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\mpgImage.jpg', $Ruta_IMAGOJO&'\Lib\Gui\mpgImage.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\pdfImage.jpg', $Ruta_IMAGOJO&'\Lib\Gui\pdfImage.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\acercade.gif', $Ruta_IMAGOJO&'\Lib\Gui\acercade.gif', 1)
FileInstall ('C:\IMAGOJOInst\Lib\Gui\IMAGOJOIco.gif', $Ruta_IMAGOJO&'\Lib\Gui\IMAGOJOIco.gif', 1)
FileInstall ('C:\IMAGOJOInst\Lib\TipoArch.dat', $Ruta_IMAGOJO&'\Lib\TipoArch.dat', 1)
$arch_ctsn=$Ruta_IMAGOJO&'\Lib\ctsn.imj'

;LECTURA DEL ARCHIVO DE CONFIGURACIÓN IMAGOJO.ini
$ALIAS1=IniRead("IMAGOJO.ini", "Comunicaciones", "Alias1", 'xxIMAGOJOSERV')
IF $ALIAS1='xxIMAGOJOSERV' THEN 
	IniWrite("IMAGOJO.ini", "Comunicaciones", "Alias1", 'IMAGOJOSERV')
	$ALIAS1='IMAGOJOSERV'
	EndIf

$AE1=IniRead("IMAGOJO.ini", "Comunicaciones", "AE1", 'xx')
IF $AE1='xx' THEN 
	IniWrite("IMAGOJO.ini", "Comunicaciones", "AE1", 'DCM4CHEE')
	$AE1='DCM4CHEE'
	EndIf

$IP1=IniRead("IMAGOJO.ini", "Comunicaciones", "IP1", 'xx')
IF $IP1='xx' THEN
	IniWrite("IMAGOJO.ini", "Comunicaciones", "IP1", '192.168.1.100')
	$IP1='192.168.1.100'
EndIf

$PUERTO1=IniRead("IMAGOJO.ini", "Comunicaciones", "PUERTO1", 'xx11112')
IF $PUERTO1='xx11112' THEN 
	IniWrite("IMAGOJO.ini", "Comunicaciones", "PUERTO1", '11112')
	$PUERTO1='11112'
	EndIf
	
;Se genera un numero al azar para crear un AET único para la primera ejecución
$Azar=0
While $Azar<1000
	$Azar=int (Random ()*10000)
WEnd
$AE2=IniRead("IMAGOJO.ini", "Comunicaciones", "AE2", 'xxEST0000')
IF $AE2='xxEST0000' THEN
	IniWrite("IMAGOJO.ini", "Comunicaciones", "AE2", 'EST'&$Azar)
	$AE2='EST'&$Azar
	EndIf
	
$PUERTO2=IniRead("IMAGOJO.ini", "Comunicaciones", "PUERTO2", 'xx11113')
IF $PUERTO2='xx11113' THEN 
	IniWrite("IMAGOJO.ini", "Comunicaciones", "PUERTO2", '11113')
	$PUERTO2='11113'
	EndIf
	
$Servidor = $ALIAS1
$IpPuertoServidor = $IP1&':'&$PUERTO1

$Bucle=IniRead("IMAGOJO.ini", "EnvioDICOM", "Reintentos", '1x1')
IF $Bucle='xx1' THEN 
	IniWrite("IMAGOJO.ini", "EnvioDICOM", "Reintentos", '1')
	$Bucle='1'
	EndIf
	
;$BorrarEnv=IniRead("IMAGOJO.ini", "EnvioDICOM", "BorrarEnviados", '1')
$Ocultar=IniRead("IMAGOJO.ini", "EnvioDICOM", "Ocultar", 'xx0')
IF $Ocultar='xx0' THEN 
	IniWrite("IMAGOJO.ini", "EnvioDICOM", "Ocultar", '0')
	$Ocultar='0'
	EndIf
	
$Estacion=IniRead("IMAGOJO.ini", "Estación", "Estación", 'xx')
IF $Estacion='xx' THEN 
	IniWrite("IMAGOJO.ini", "Estación", "Estación", 'ESTACIÓN '&$Azar)
	$Estacion='ESTACIÓN '&$Azar
	EndIf

;IF $Institucion='xx' THEN 
IniWrite("IMAGOJO.ini", "Estación", "Institución", 'Hospital de Clínicas')
$Institucion=IniRead("IMAGOJO.ini", "Estación", "Institución", 'Hospital de Clínicas')

;IF $Institucion='xx' THEN 
IniWrite("IMAGOJO.ini", "Estación", "Departamento", 'Dpto. de Oftalmología')
$Dpto=IniRead("IMAGOJO.ini", "Estación", "Departamento", 'Dpto. de Oftalmología')

$RutaCaptura=IniRead("IMAGOJO.ini", "Estación", "RutaCaptura", 'xx')
IF $RutaCaptura='xx' THEN 
	IniWrite("IMAGOJO.ini", "Estación", "RutaCaptura", '')
	$RutaCaptura=''
	EndIf

$Dir_jpg=IniRead("IMAGOJO.ini", "Estación", "DirJpg", 'xx')
IF $Dir_jpg='xx' THEN 
	IniWrite("IMAGOJO.ini", "Estación", "DirJpg", '')
	$Dir_jpg=''
	EndIf

$Dir_video=IniRead("IMAGOJO.ini", "Estación", "DirVideo", 'xx')
IF $Dir_video='xx' THEN 
	IniWrite("IMAGOJO.ini", "Estación", "DirVideo", '')
	$Dir_video=''
	EndIf
	
$Dir_pdf=IniRead("IMAGOJO.ini", "Estación", "DirPdf", 'xx')
IF $Dir_pdf='xx' THEN 
	IniWrite("IMAGOJO.ini", "Estación", "DirPdf", '')
	$Dir_pdf=''
	EndIf

$NProgCaptura=IniRead("IMAGOJO.ini", "Estación", "NProgCaptura", 'xx')
IF $NProgCaptura='xx' THEN IniWrite("IMAGOJO.ini", "Estación", "NProgCaptura", '')

$Asterisco=IniRead("IMAGOJO.ini", "Estación", "* en Consultar", 'xx')
IF $Asterisco='xx' THEN 
	IniWrite("IMAGOJO.ini", "Estación", "* en Consultar", '1')
	$Asterisco='1'
	EndIf

$PosVent=IniRead("IMAGOJO.ini", "Estación", "PosVent", 'xx')
IF $PosVent='xx' THEN 
	IniWrite("IMAGOJO.ini", "Estación", "PosVent", '1')
	$PosVent='1'
	EndIf


;$Servidor = "IMAGOJO"
;$IpPuertoServidor = "192.168.1.101:1112"

;IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "EnvioDICOM", "Ocultar", '1')
;variables de configuración del .ini
#CS
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "EnvioDICOM", "Reintentos", '4')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "EnvioDICOM", "Ocultar", '1')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "EnvioDICOM", "BorrarEnviados", '0')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Directorios", "Ruta_Dcm", 'C:\IMAGOJO\Local\Dcm')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "Alias1", 'Charrua')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "AE1", 'CHARRUAPACS')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "IP1", 'localhost')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "PUERTO1", '11112')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "Alias2", 'SYNEDRA')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "AE2", 'CHARRUAPACS')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "IP2", 'localhost')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "PUERTO2", '11317')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "Servidor", 'Charrua')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "SNIFFER", '11317')

IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Directorios", "Visorweb", 'C:\IMAGOJO\GoogleChromePortable\GoogleChromePortable.exe')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Java", "Dcm4che_bin", 'C:\IMAGOJO\dcm4\bin\')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Directorios", "Ruta_IMAGOJO", 'C:\IMAGOJO')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "Estación", 'Workstation')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Directorios", "Ruta_Visor", 'C:\Archivos de programa\synedra\ViewPersonal\synedraViewPersonal.exe')
IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "PesVent", '1')
#CE

;$Nom_Dcm="Im" borrar
;variables prog principal
$usuario = ""
$contrasenia = ""

$ced_paciente = ""
$Nom_paciente = ""
$fnac_paciente = ""
$sex_paciente = ""


#cs
;Se hace un EchoDICOM al empezar
FileChangeDir($dir_trab)
	FileDelete(@TempDir & "\ECO.log")
	RunWait( @comspec & " /c dcmecho "&$AE1&"@"&$IpPuertoServidor & " > " & @TempDir & "\ECO.log",$dir_trab,@SW_HIDE)
	$file = FileOpen(@TempDir & "\ECO.log", 0)
	If $file = -1 Then
    MsgBox(0, "Error 200", "Chequear instalación")
	Exit
	EndIf
	$chars = FileRead($file)
	$result = StringInStr($chars, "verification")
	if $result >0 then $EstadoServ = "Activo"
	if $result <=0 then $EstadoServ = "Inactivo"
	FileClose($file)
#ce;Fin Echo DICOM


;Verificando la autenticidad del programa
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
	;SplashOff()
	;MsgBox(0, "de ipconfig", $var)
	FileClose($file)

			$sDigest = md5($var&"64K")
			$file = FileOpen($arch_ctsn, 0)
			If $file = -1 Then
				MsgBox(0, "Error 253", "No se pudo abrir archivo de configuración, chequee instalación.")
				Exit
			EndIf
			$lectura=FileRead($file)
			FileClose($file)
			$result = StringInStr($lectura, $sDigest)
			If $result>0 Then 
			Else
			SplashOff()
			MsgBox(0, "ATENCIÓN", "Error, equipo no autorizado a ejecutar IMAGOJO, contáctese a rvlaeminck@antel.net.uy o aprieto@adinet.com.uy")
			Exit
			EndIf




;Conteo de estudios
RunWait( @comspec & " /c dcmqr -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor & " -q00100020== -r 00100030 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta genérica que da todos los estudios en el pacs
	$file = FileOpen(@TempDir & "\IMAGOJOQuery.dat", 0)
	If $file = -1 Then
	MsgBox(0, "Error 156", "No se pudo abrir IMAGOJOquery.dat")
	GUIDelete ($form2)
	Call ("Form"&$Op)
	EndIf
	$Query = FileRead($file)
	FileClose($file)
	;Se lee primero la cantidad de registros encontrados
	$result = StringInStr($Query, "INFO   - Received ") ;busca la posición donde está el dato
	If $result>0 Then
		$EstadoServ = "Activo";Si está la frase es porque el servidor está arriba
		$result = $result+18;se posiciona exactamente donde comienza el dato
		$var = StringMid($Query, $result, 6) ; extraigo 6 caracteres por si es un número largo
		$array = StringSplit($var, ' ', 1);obtengo el dato válido hasta el espacio como delimitador
		$Nro_registrosT = $array[1]
		IniWrite($Ruta_IMAGOJO&"\LIB\IMAGOJO_CONT.ini", "CONTEO", "ESTUDIOS", $Nro_registrosT)
		;MsgBox(0, "La cantidad de registros encontrados es:", $Nro_registrosT+15000)
	Else
		$EstadoServ = "Inactivo"
		IniWrite($Ruta_IMAGOJO&"\LIB\IMAGOJO_CONT.ini", "CONTEO", "ESTUDIOS", 0)
	EndIf
;Fin de conteo de estudios

#ce
SplashOff()
;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PRESENTACIÓN Y LOGUEO 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PRESENTACIÓN Y LOGUEO 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PRESENTACIÓN Y LOGUEO 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
$usuario=''
$contrasenia=''
Form0()
Func Form0 ()
#Region ### START Koda GUI section ### Form=C:\IMAGOJO\koda 1.7.0.1\Forms\Inicio-de-sesion2.kxf
$Form0 = GUICreate("IMAGOJO: Inicio de sesión", 730, 440, $X_vent, $Y_vent)
GUISetBkColor(0xF9FCFF)
$Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\presentacion.jpg", 0, 0, 726, 243)
$Input1 = GUICtrlCreateInput($usuario, 232, 288, 193, 21)
$Input2 = GUICtrlCreateInput($contrasenia, 232, 326, 193, 21, $ES_PASSWORD )
$Label1 = GUICtrlCreateLabel("Usuario", 176, 288, 52, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Label2 = GUICtrlCreateLabel("Contraseña", 151, 328, 76, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Button1 = GUICtrlCreateButton("Aceptar", 597, 376, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 56, 384, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
#cs
$Form0 = GUICreate("Bienvenidos a IMAGOJO", 625, 443, -1)
$continuar = GUICtrlCreateButton("continuar", 464, 336, 75, 25, 0)

$IMAGOJO = GUICtrlCreateLabel("IMAGOJO", 232, 112, 176, 52)
GUICtrlSetFont(-1, 28, 400, 0, "MS Sans Serif")
$IMAGOJO = GUICtrlCreateLabel("Sistema de Captura y Gestión de Imágenes Médicas", 100, 200, 300, 300)
GUICtrlSetFont(-1, 28, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#ce
;habilito chequear usuario y contraseña
$hab=1
$usu=0
While 1
Switch GUIGetMsg()
Case $Button1;Aceptar
		$usuario = GUICtrlRead($Input1)
		$contrasenia = GUICtrlRead($Input2)	
;	While $hab
		if $hab=0 Then
			$usuario="Administrador"
			$Op=1
			exitloop
		EndIf
		
		if $hab and $usuario<>''then ; con esta opcion se acepta cualquier nombre de usuario
			$usu=1
		Else
			MsgBox( 4096, "ATENCIÓN", "Debe escribir su nombre en usuario")
			$Op=0
			exitloop
		EndIf
			
		;opcion para chequear también nombres de usuario
		#cs
		if $hab and $usuario = "IMAGOJO" then
		$usu=1
		ElseIf $hab and $usuario = "alvaro" then
		$usu=1
		Else
		MsgBox( 4096, "ATENCIÓN", "Usuario  No registrado")
		$Op=0
		exitloop
		EndIf
		#ce
		
;	WEnd
	;Chequeo de Contraseña
		If $usu=1 Then
			$sDigest = md5($contrasenia&"43K")
			$file = FileOpen($arch_ctsn, 0)
			If $file = -1 Then
				MsgBox(0, "Error 253", "No se pudo abrir archivo de configuración, chequee instalación.")
				Exit
			EndIf
			$lectura=FileRead($file)
			FileClose($file)
			$result = StringInStr($lectura, $sDigest)
			If $result>0 Then 
				$habilitado=1
			Else
				$habilitado=0
			EndIf
		EndIf

		if $usu=1 and $habilitado=1 then
		;Escribir en el log
				$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 270", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' Abrió sesión '&$usuario)
				FileClose($file2)
				EndIf
		;Fin escritura del log
			$Op=1
			ExitLoop
		Else
			MsgBox( 4096, "ATENCIÓN", "Contraseña inválida")
			$Op=0
			exitloop
		Endif

Case $GUI_EVENT_CLOSE
		Exit
Case $Button2;Cancelar
		Exit
ExitLoop
EndSwitch
WEnd
GUIDelete ($form0)
Call ("Form"&$Op)


EndFunc

;Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 PRINCIPAL 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
;Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 PRINCIPAL 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
;Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 PRINCIPAL 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
Func Form1 ()
$Nro_registrosT=IniRead($Ruta_IMAGOJO&"\LIB\IMAGOJO_CONT.ini", "CONTEO", "ESTUDIOS", '0')
$k=27
$q=20
#Region ### START Koda GUI section ### Form=h:\IMAGOJO\software bajado\programacion\koda 1.7.0.1\forms\menuprincipa01.kxf
$Form1= GUICreate("IMAGOJO: Principal                              "&$Dpto&" - "&$Institucion, 801, 451, $X_vent, $Y_vent)
If $EstadoServ = "Activo" Then $Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\bandacolorV.gif", 0, 0, 801, 49)
If $EstadoServ = "Inactivo" Then $Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\bandacolor.gif", 0, 0, 801, 59)
GUISetBkColor(0xF9FCFF)
$Button1 = GUICtrlCreateButton("&Paciente", 550, 80+$q, 99, 25, 0)
$Button2 = GUICtrlCreateButton("&Captura", 549, 129+$q, 99, 25, 0)
$Button3 = GUICtrlCreateButton("Crear &DICOM", 549, 177+$q, 99, 25, 0)
$Button4 = GUICtrlCreateButton("Visor &Editor", 549, 227+$q, 100, 25, 0)
$Button5 = GUICtrlCreateButton("&Visualizador Web", 549, 276+$q, 99, 25, 0)
$Label1 = GUICtrlCreateLabel("Sesión: ", 121, 360+$k, 44, 20)
;GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label13 = GUICtrlCreateLabel($usuario, 121, 377+$k, 190, 17)
;GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

$Label2 = GUICtrlCreateLabel("Servidor:", 572, 360+$k, 164, 17)
;GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Button6 = GUICtrlCreateButton("Cerrar Sesión", 32, 363+$k, 75, 25, 0)
	If $Nro_registrosT Then $servi=" (estudios:"&$Nro_registrosT&")"
	If Not $Nro_registrosT Then $servi=""
$Label3 = GUICtrlCreateLabel($Servidor&$servi, 572, 377+$k, 164, 17)
;GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
;If $Nro_registrosT Then $Label21 = GUICtrlCreateLabel($Nro_registrosT&")", 710, 377+$k, 43, 17)


$MenuItem2 = GUICtrlCreateMenu("Opciones")
;$MenuItem5 = GUICtrlCreateMenuItem("Ocultar dialogos al enviar", $MenuItem2)
$MenuItem17 = GUICtrlCreateMenuItem("Configurar estación", $MenuItem2)
$MenuItem16 = GUICtrlCreateMenuItem("Ver equipos conectados en la red", $MenuItem2)
$MenuItem19 = GUICtrlCreateMenuItem("Tipo de archivos almacenados", $MenuItem2)
$MenuItem18 = GUICtrlCreateMenuItem("Salir del programa", $MenuItem2)


;$MenuItem6 = GUICtrlCreateMenuItem("Borrar archivos enviados", $MenuItem2)
;If $BorrarEnv=1 then GUICtrlSetState(-1, $GUI_CHECKED)
;If $BorrarEnv=0 then GUICtrlSetState(-1, $GUI_UNCHECKED)
$MenuItem9 = GUICtrlCreateMenu("Herramientas")
$MenuItem14 = GUICtrlCreateMenuItem("Enviar DICOM no enviados", $MenuItem9)
$MenuItem10 = GUICtrlCreateMenuItem("Enviar un archivo DICOM", $MenuItem9)
$MenuItem12 = GUICtrlCreateMenuItem("Ver carpeta LOG", $MenuItem9)
$MenuItem13 = GUICtrlCreateMenuItem("Explorar carpeta NoEnviados", $MenuItem9)

$MenuItem1 = GUICtrlCreateMenu("&Avanzado")
$MenuItem8 = GUICtrlCreateMenuItem("Comunicaciones", $MenuItem1)
$MenuItem15 = GUICtrlCreateMenuItem("Editar IMAGOJO.ini", $MenuItem1)
$MenuItem11 = GUICtrlCreateMenuItem("Explorar carpeta Temporal", $MenuItem1)
$MenuItem4 = GUICtrlCreateMenu("&Ayuda")
$MenuItem7 = GUICtrlCreateMenuItem("Ayuda", $MenuItem4)
$MenuItem3 = GUICtrlCreateMenuItem("Acerca de", $MenuItem4)

$l=24
$Group2 = GUICtrlCreateGroup("", 24-$l, 344+$k, 285+$l, 60)
GUICtrlCreateGroup("", -99, -99, 1, 1)
If $RutaCaptura Then
$Label10 = GUICtrlCreateLabel("Prog. de captura:", 360, 360+$k,120, 17)
;GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label11 = GUICtrlCreateLabel($NProgCaptura, 360, 377+$k, 120, 17)
;GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
EndIf
$Group3 = GUICtrlCreateGroup("", 308, 344+$k, 237, 60)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("", 544, 344+$k, 233+$l, 60)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group5 = GUICtrlCreateGroup("", 0, 344+$k, 801, 60)
GUICtrlCreateGroup("", -99, -99, 1, 1)
	
$x=7
$y=18	
	If $Ced_pa Then
	$Label4 = GUICtrlCreateLabel("Paciente: ", 86+$x, 200+$y, 69, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label5 = GUICtrlCreateLabel($Ape_pa&", "&$Nom_pa, 153+$x, 201+$y, 273, 22)
	GUICtrlSetFont(-1, 11, 800, 0, "Arial")
	$Label6 = GUICtrlCreateLabel("Estación : "&$Estacion, 86+$x, 152+$y, 254, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label7 = GUICtrlCreateLabel("ID Paciente:", 86+$x, 233+$y, 83, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label8 = GUICtrlCreateLabel("Fecha : "&@MDAY & "/" & @MON & "/" & @YEAR, 86+$x, 123+$y, 129, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label9 = GUICtrlCreateLabel($Ced_pa, 173+$x, 232+$y, 273, 22)
	GUICtrlSetFont(-1, 11, 800, 0, "Arial")
	$Group1 = GUICtrlCreateGroup("", 56+$x, 96+$y, 417, 185)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	EndIf
	
	If $EstadoServ = "Activo" then 
	GuiCtrlCreateLabel(" ", 765, 373+$k, 10, 7)
	GuiCtrlSetBkColor(-1, 0x00FF00)
	Else
	GuiCtrlCreateLabel(" ", 765, 373+$k, 10, 7)
	GuiCtrlSetBkColor(-1, 0xFF0000)
	EndIf
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$borr=1
While 1
$kMsg = GUIGetMsg()
Switch $kMsg
Case $Button3;Crear DICOM
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	$Op=8
	ExitLoop
Case $Button4;Visualizador Editor synedra View Personal
	ClipPut($Ced_pa);Coloca el id de paciente en el portapapeles
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	If ProcessExists("synedraViewPersonal.exe") Then 
		WinActivate("synedra", "")
		$state = WinGetState("synedra", "")
		If $state=13 Then
		SplashTextOn ("Abrir Visor Editor", "Ya está en ejecución"&@LF&"Se copió ID Paciente al portapapeles", 250,100)
		Sleep (1500)
		SplashOff()
		EndIf
	else
		SplashTextOn ("Abrir Visor Editor", "Abriendo", 250,100)
		Run ($visor, @WindowsDir, @SW_MAXIMIZE)
		Sleep (1000)
		If ProcessExists("synedraViewPersonal.exe") Then
		SplashTextOn ("Abrir Visor Editor", "Se inició proceso"&@LF&"Se copió ID Paciente al portapapeles", 250,100)
		Sleep (1000)
		Else
		SplashTextOn ("Abrir Visor Editor", "No se encuentra el programa, verificar instalación", 250,100)
		Sleep (4000)
		EndIf
		Sleep (1000)
		SplashOff ()
	EndIf

Case $Button5;Visualizador Web
	ClipPut($Ced_pa);Coloca el id de paciente en el portapapeles
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	;$Op=1
	If ProcessExists("FirefoxPortable.exe") Then 
		WinActivate("Mozilla", "")
		SplashTextOn ("Abrir Viualizador Web", "Ya está en ejecución@LFSe copió ID Paciente al portapapeles", 250,100)
		Sleep (1500)
		SplashOff()
	ElseIf ProcessExists("GoogleChromePortable.exe") Then
		WinActivate("Google", "")
		SplashTextOn ("Abrir Viualizador Web", "Ya está en ejecución"&@LF&"Se copió ID Paciente al portapapeles", 250,100)
		Sleep (1500)
		SplashOff()
	
	else
		SplashTextOn ("Abrir Viualizador Web", "Se inició proceso"&@LF&"Se copió ID Paciente al portapapeles", 250,100)
		Sleep (1000)
		Run ($visorweb, @WindowsDir, @SW_MAXIMIZE)
		SplashOff()
	EndIf

Case $Button1;Paciente
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf

	$Op=2
	$opsal=1
	ExitLoop

Case $Button6;Cerrar Sesión
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf

	$Op=0
	$usuario=''
	$contrasenia=''
	$borrar=1
	$Ced_pa = ""
	$Nom_pa = ""
	$Ape_pa = ""
	$DiaN_pa = ""
	$Dir_pa = ""
	$Tel1_pa = ""
	$MesN_pa = ""
	$AniN_pa = ""
	$Tel2_pa = ""
	$sex_paciente = ""	
	$tipoId=''
	$Cedula_valida=0
		;Escribir en el log
				$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 518", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' Cerró sesión '&$usuario)
				FileClose($file2)
				EndIf
		;Fin escritura del log
	ExitLoop

Case $Button2;Captura
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
		If $RutaCaptura='' then
		$borr=0
		$Op=7
		ExitLoop
		Else			
			If $Ced_pa Then
				$borr=0
				$Op=7
			Else 
				$OPSAL=7
				$Op=2
			Endif
			ExitLoop
		EndIf

Case $GUI_EVENT_CLOSE
		;Escribir en el log
				$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 554", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' Cerró el programa '&$usuario)
				FileClose($file2)
				EndIf
		;Fin escritura del log
	Exit
Case $MenuItem18;Salir del programa
		;Escribir en el log
				$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 565", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' Cerró el programa '&$usuario)
				FileClose($file2)
				EndIf
		;Fin escritura del log
	Exit
Case $MenuItem8;Serviores
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	Call ("Form6")

Case $MenuItem17;Estación
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	Call ("Form10")

Case $MenuItem14; Enviar Dcm no enviados
	RunWait($Ruta_IMAGOJO&'\Lib\IMAGOJODIR.exe')
	

Case $MenuItem12; Ver Carpeta de archivos Log
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf

	$path=$Ruta_IMAGOJO&"\Log\"
	Run("C:\WINDOWS\EXPLORER.EXE /n,/e," & $path)

Case $MenuItem11; Explorar Carpeta Temporal de Windows
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	$path=@TempDir
	Run("C:\WINDOWS\EXPLORER.EXE /n,/e," & $path)
	
Case $MenuItem10;Enviar un DICOM
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	$Op=30
	$opsal=1
	ExitLoop
	
Case $MenuItem13; Explorar Carpeta NoEnviados
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf

	$path=$Ruta_IMAGOJO&"\NoEnviados"
	Run("C:\WINDOWS\EXPLORER.EXE /n,/e," & $path)

	
Case $MenuItem3;Acerca de
	Call ("Form40")
	
Case $MenuItem7; Ayuda di Programa IMAGOJO
	ShellExecute($Ruta_IMAGOJO&'\Lib\Ayuda IMAGOJO.chm')

Case $MenuItem15;Editar archivo imagojo.ini
	ShellExecute($Ruta_IMAGOJO&'\IMAGOJO.ini')

Case $MenuItem16;Ver equipos conectados y tipos de imágenes que generan
	FileDelete(@TempDir & "\Equipos.txt")
	RunWait( @comspec & " /c net view > " & @TempDir & "\Equipos.txt",$dir,@SW_HIDE)
	Sleep(500)
	$file = FileOpen(@TempDir & "\Equipos.txt", 0)
	If $file = -1 Then
    MsgBox(0, "Error 669", "Falta el archivo Equipos.txt. Chequear instalación")
	Exit
	EndIf
	$Lectura = FileRead($file)
	;Se busca donde terminan los datos validos
	$result = StringInStr($Lectura, "se ") ;busca la posición donde está el dato
	$result = $result-3;se posiciona exactamente donde terninan los datos
	$var = StringMid($Lectura, 1, $result)
	$resultado = StringInStr($var, "\")
	$var= StringTrimLeft($var, $resultado-1)	
    MsgBox(0, "Equipos", $var)
	FileClose($file)
	
Case $MenuItem19;Tipo de archivos almacenados
	$file = FileOpen($Ruta_IMAGOJO&'\Lib\TipoArch.dat', 0)
	If $file = -1 Then
    MsgBox(0, "Error 685", "Falta el archivo TipoArch.dat. Chequear instalación")
	Exit
	EndIf
	$Lectura = FileRead($file)
    MsgBox(0, "Tipo de archivos", $Lectura)
	FileClose($file)
	
Case $Label3; Clic sobre el ícono de estado del servidor
	SplashTextOn ("Conteo de estudios", "Actualizando número de estudios, espere..", 250,100)
	;Conteo de estudios
	RunWait( @comspec & " /c dcmqr -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor & " -q00100020== -r 00100030 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta genérica que da todos los estudios en el pacs
	$file = FileOpen(@TempDir & "\IMAGOJOQuery.dat", 0)
	If $file = -1 Then
	MsgBox(0, "Error 698", "No se pudo abrir IMAGOJOquery.dat")
	GUIDelete ($form2)
	Call ("Form"&$Op)
	EndIf
	$Query = FileRead($file)
	FileClose($file)
	;Se lee primero la cantidad de registros encontrados
	$result = StringInStr($Query, "INFO   - Received ") ;busca la posición donde está el dato
	If $result>0 Then
		$EstadoServ = "Activo";Si está la frase es porque el servidor está arriba
		$result = $result+18;se posiciona exactamente donde comienza el dato
		$var = StringMid($Query, $result, 6) ; extraigo 6 caracteres por si es un número largo
		$array = StringSplit($var, ' ', 1);obtengo el dato válido hasta el espacio como delimitador
		$Nro_registrosT = $array[1]
		IniWrite($Ruta_IMAGOJO&"\LIB\IMAGOJO_CONT.ini", "CONTEO", "ESTUDIOS", $Nro_registrosT)
			Else
		$EstadoServ = "Inactivo"
		IniWrite($Ruta_IMAGOJO&"\LIB\IMAGOJO_CONT.ini", "CONTEO", "ESTUDIOS", 0)
	EndIf
	;Fin de conteo de estudios
	$borr=1
	$Op=1
	SplashOff()
	ExitLoop

EndSwitch
WEnd
If $borr=1 Then GUIDelete ( "Form1")
Call ("Form"&$Op)
	EndFunc
#Region Fin Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#Region Fin Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#Region Fin Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1

;Función Paciente 2 2 2 2  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
;Función Paciente 2 2 2 2  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
;Función Paciente 2 2 2 2  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
Func Form2 (); ;Función Paciente
$button14 = 100
$button13 = 100
$ok2=100
$noingresa=1
if $sex_paciente='' then $sex_paciente='O'
if $tipoId='' then $tipoId='C.I.'
#Region ### START Koda GUI section ### Form=h:\IMAGOJO\software bajado\programacion\koda 1.7.0.1\forms\paciente01.kxf
$Form2 = GUICreate("IMAGOJO: Paciente                              "&$Dpto&" - "&$Institucion, 801, 451, $X_vent, $Y_vent, $WS_CAPTION)
GUISetBkColor(0xF9FCFF)
$Paciente = GUICtrlCreateLabel("Paciente", 96, 16, 77, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$ced = GUICtrlCreateInput($Ced_pa, 248, 64, 153, 21)
$Nom = GUICtrlCreateInput($Nom_pa, 248, 101, 425, 21)
$Ape = GUICtrlCreateInput($Ape_pa, 248, 137, 425, 21)
$Sexo = GUICtrlCreateCombo($sex_paciente, 200, 172, 41, 25)
GUICtrlSetData(-1, "F|M", $sex_paciente) 
$DiaN = GUICtrlCreateInput($DiaN_pa, 472, 172, 49, 21)
$updown1 = GuiCtrlCreateUpDown(-1)
GUICtrlSetLimit($updown1,31,1)
$MesN = GUICtrlCreateInput($MesN_pa, 544, 172, 49, 21)
$updown2 = GuiCtrlCreateUpDown(-1)
GUICtrlSetLimit($updown2,12,1)
$AniN = GUICtrlCreateInput($AniN_pa, 616, 172, 49, 21)
$updown3 = GuiCtrlCreateUpDown(-1)
GUICtrlSetLimit($updown3,2020,1900)

$Dir = GUICtrlCreateInput($Dir_pa, 240, 257, 425, 21)
$Tel1 = GUICtrlCreateInput($Tel1_pa, 240, 292, 201, 21)
$OK1 = GUICtrlCreateButton("Crear", 632, 384, 75, 25, 0)

	If $consulta =1 then 
	$OK2 = GUICtrlCreateButton("Ok", 664, 384, 43, 25, 0)
	$Button13 = GUICtrlCreateButton("<", 597, 384, 27, 25, 0)
	$Button14 = GUICtrlCreateButton(">", 629, 384, 27, 25, 0)
	endif

$Label20 = GUICtrlCreateLabel($Nro_CONSULTA&" de "&$Nro_registros, 600, 354, 104, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$tipo = GUICtrlCreateCombo($tipoId, 457, 64, 49, 25)
GUICtrlSetData(-1, "C.I.|Otro", $tipoId) 
$Label11 = GUICtrlCreateLabel("Tipo", 414, 64, 42, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")

If $Ced_pa='' Then $Consulta=0

If $Consulta=1 then
	GUICtrlDelete($OK1)
	if not $Cedula_valida then GUICtrlDelete($tipo)
	if not $Cedula_valida then GUICtrlDelete($Label11)
	EndIf
If $Consulta=0 then
	;GUICtrlDelete($OK2)
	;GUICtrlDelete($Button13)
	;GUICtrlDelete($Button14)
	GUICtrlDelete($Label20)
	EndIf
If $Consulta=3 then
	GUICtrlDelete($OK1)
	;GUICtrlDelete($OK2)
	;GUICtrlDelete($Button13)
	;GUICtrlDelete($Button14)
	GUICtrlDelete($Label20)
	if not $Cedula_valida then GUICtrlDelete($tipo)
	if not $Cedula_valida then GUICtrlDelete($Label11)
	EndIf
;$Label50 = 
GUICtrlCreateLabel("ID Paciente", 142, 64, 99, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000080)
GUICtrlSetTip(-1, "Patient ID")
;$Label51 = 
GUICtrlCreateLabel("Nombre(s)", 142, 99, 94, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Patients First Name")
;$Label52 = 
GUICtrlCreateLabel("Apellido(s)", 142, 135, 94, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000080)
GUICtrlSetTip(-1, "Patients Last Name")
;$Label53 = 
GUICtrlCreateLabel("Sexo", 142, 171, 48, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Patients Sex")
GUICtrlCreateLabel("Fecha de Nacimiento", 278, 171, 185, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Patients Birth Date")
$Consultar = GUICtrlCreateButton("Consultar", 592, 60, 75, 25, 0)

$Label1 = GUICtrlCreateLabel("dia", 488, 194, 18, 17)
$Label4 = GUICtrlCreateLabel("mes", 560, 194, 23, 17)
$Label5 = GUICtrlCreateLabel("año", 632, 194, 22, 17)
$Label6 = GUICtrlCreateLabel("Teléfono1", 142, 291, 89, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Patients Telephone Numbers")
$Label3 = GUICtrlCreateLabel("Teléfono2", 142, 328, 89, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Patients Telephone Numbers")
$Label7 = GUICtrlCreateLabel("Dirección", 142, 257, 84, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Patients Adress")
$Tel2 = GUICtrlCreateInput($Tel2_pa, 240, 329, 201, 21)
GUICtrlCreateLabel("*", 128, 72, 8, 17)
GUICtrlCreateLabel("*", 127, 106, 8, 17)
GUICtrlCreateLabel("*", 127, 142, 8, 17)
$Button1 = GUICtrlCreateButton("Volver", 112, 386, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Borrar", 376, 386, 75, 25, 0)
$Group1 = GUICtrlCreateGroup("", 112, 40, 585, 185)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1;$noingresa
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE;Al cerrar ventana
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	$Op=1
	If $Pav=0 Then
	$Ced_pa = ""
	$Nom_pa = ""
	$Ape_pa = ""
	$DiaN_pa = ""
	$Dir_pa = ""
	$Tel1_pa = ""
	$MesN_pa = ""
	$AniN_pa = ""
	$Tel2_pa = ""
	$sex_paciente = ""	
	$tipoId=''
	$Cedula_valida=0
	EndIf
	ExitLoop

Case $OK1; Crear
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf

	$Ced_pa = GUICtrlRead($ced)
	$Nom_pa = GUICtrlRead($Nom)
	$Ape_pa = GUICtrlRead($Ape)
	$DiaN_pa = GUICtrlRead($DiaN)
	$MesN_pa = GUICtrlRead($MesN)
	$AniN_pa = GUICtrlRead($AniN)
	$Dir_pa = GUICtrlRead($Dir)
	$Tel1_pa = GUICtrlRead($Tel1)
	$Tel2_pa = GUICtrlRead($Tel2) 
	$sex_paciente = GUICtrlRead($sexo)
	$tipoId = GUICtrlRead($tipo)

	If $sex_paciente= 'f' Then $sex_paciente= 'F'
	If $sex_paciente= 'm' Then $sex_paciente= 'M'
	If $sex_paciente= 'o' Then $sex_paciente= 'O'
	if $sex_paciente= 'F' or $sex_paciente= 'M' or $sex_paciente= 'O' Then
	else
	$sex_paciente=''
	EndIf
	
	;Se chequean los items mardcados con *
	;if $Ced_pa = "" or $Nom_pa = "" or $Ape_pa = "" or $DiaN_pa = "" or $MesN_pa = "" Or $AniN_pa = "" or $sex_paciente = "" then 
	if $Ced_pa = "" or $Nom_pa = "" or $Ape_pa = "" then 
	$noingresa=1
	MsgBox(0, "ATENCIÓN", "Debe ingresar los datos marcados con *",10)
	GUIDelete ($form2)
	Call ("Form2")
	Else 
	$noingresa=0
	EndIf

;Comprobación de validez de Cédula de identidad uruguaya
	If $tipoId='C.I.' Then
	$num=StringIsDigit($Ced_pa)  ;verifica que la cedula solo contenga digitos 0 a 9
		If $num then; si contiene solo números
			$ced = $Ced_pa
			$len = StringLen ($ced)
			if $len=7 then $ced = "0"&$ced
			;MsgBox(0, "la suma da:", $ced)
			$len = StringLen ($ced)
			$suma=0
			For $i=1 to $len-1
			;variable, posición,  numero de caracteres a extraer
			$var = StringMid($ced, $i, 1)
			If $i=1 Then $amult=2
			If $i=2 Then $amult=9
			If $i=3 Then $amult=8
			If $i=4 Then $amult=7
			If $i=5 Then $amult=6
			If $i=6 Then $amult=3
			If $i=7 Then $amult=4
			$suma=$suma+($var*$amult)
			Next
			;MsgBox(0, "la suma da:", $suma)
			$len = StringLen ($suma)
			$var = StringMid($suma, $len, 1)
			;MsgBox(0, "el ultimo digito de la suma es:", $var)
			$digver=10-$var
			If $digver=10 then $digver=0
			$var = StringMid($ced, 8, 1)
			;MsgBox(0, "el digito debe ser:", $digver)
			If $digver = $var Then 
			;MsgBox(0, 'Resultado', "La cédula "& $cedula & " ingresada es correcta")
			$Cedula_valida=1
			Else
			MsgBox(0, 'ATENCIÓN', "La cédula "& $Ced_pa & " ingresada NO es correcta");No verifican los dígitos con el número verificador
			GUIDelete ($form2)
			Call ("Form2")
			EndIf
		Else
		MsgBox(0, 'ATENCIÓN', "La cédula "& $Ced_pa & " ingresada NO es correcta, debe contener solamente dígitos incluyendo el dígito verificador")
		GUIDelete ($form2)
		Call ("Form2")			
		EndIf	
	EndIf
	;Fin de comprobación de la cédula

	;Comprobación de validez de fechas
	If $AniN_pa='' Or $MesN_pa='' Or $DiaN_pa=''Then
		Else
		if $AniN_pa<3 then
			$AniN_pa = StringReplace($AniN_pa, ",", ".")
			$AniN_pa=$AniN_pa*1000
			EndIf

		if $MesN_pa<10 then
			$result = StringInStr($MesN_pa, "0")
			If $result =0 Then $MesN_pa="0"&$MesN_pa
		EndIf	
	
		if $DiaN_pa<10 then
		$result = StringInStr($DiaN_pa, "0")
		If $result =0 Then $DiaN_pa="0"&$DiaN_pa
		EndIf		
		;MsgBox( 4096, "ATENCIÓN", "Año de nacimiento "&$AniN_pa&" mes "&$MesN_pa &" dis "&$DiaN_pa)
		$sDate =  $AniN_pa & "/" & $MesN_pa & "/" & $DiaN_pa
		If not _DateIsValid( $sDate ) or StringLen ($DiaN_pa)>2 or StringLen ($MesN_pa)>2 Then
		MsgBox( 0, "ATENCIÓN", "La fecha de nacimiento ingresada no es válida")
		GUIDelete ($form2)
		Call ("Form2")
		EndIf
	EndIf

	;Validación de los datos	
	if $noingresa=0 then
	$PaV=1;Se valida el paciente porque ha ingresado los datos correctamente
	$Op=$OPSAL
	$Consulta=3
	ExitLoop
	EndIf

Case $OK2; Ok luego de una consulta
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf

	$Dir_pa = GUICtrlRead($Dir)
	$Tel1_pa = GUICtrlRead($Tel1)
	$Tel2_pa = GUICtrlRead($Tel2) 
	$sex_paciente = GUICtrlRead($sexo)
	$Pav=1
	$Op=$OPSAL
	$Consulta=3
	ExitLoop


Case $Button1;Volver
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	$Op=1
	If $Pav=0 Then
	$Ced_pa = ""
	$Nom_pa = ""
	$Ape_pa = ""
	$DiaN_pa = ""
	$Dir_pa = ""
	$Tel1_pa = ""
	$MesN_pa = ""
	$AniN_pa = ""
	$Tel2_pa = ""
	$sex_paciente = ""	
	$tipoId=''
	$Cedula_valida=0
	EndIf
	ExitLoop

Case $Button2;Borrar
	$Op=2
	$Ced_pa = ""
	$Nom_pa = ""
	$Ape_pa = ""
	$DiaN_pa = ""
	$Dir_pa = ""
	$Tel1_pa = ""
	$MesN_pa = ""
	$AniN_pa = ""
	$Tel2_pa = ""
	$sex_paciente = ""
	$tipoId=''
	$PaV=0
	$Consulta=0
	$Cedula_valida=0
	ExitLoop

Case $Consultar;Consulta a la base de datos para ver si ya existe el paciente, y en caso afirmativo trae los datos
	;MsgBox(0, $CONSULTA,$OK2)
	SplashTextOn ("Consulta al servidor", "Se inició la consulta", 250,100)
	$Consulta=1; Indica que se ha pulsado consulta
	$Nro_CONSULTA=1;se parte de que hay un registro
	$Op=2
	$Ced_pa = GUICtrlRead($ced)
	$Nom_pa = GUICtrlRead($Nom)
	$Ape_pa = GUICtrlRead($Ape)
	
	FileChangeDir($dir_trab)
	FileDelete(@TempDir & "\IMAGOJOQuery.dat")
	;Send ("dcmqr -L QRSCU:11113 DCM4CHEE@localhost:11112 -q00100010=*alvaro* -r 00100030 -r 00100020 -r 00100021 -r 00100040{ENTER}")
	If $Ced_pa then
		$ced_paPrima=$Ced_pa
		if $ced_paPrima=">" or $ced_paPrima="=" or $ced_paPrima="<" or $ced_paPrima="&" or $ced_paPrima=";" or $ced_paPrima="?" or $ced_paPrima="/" or $ced_paPrima="""" or $ced_paPrima="\" or $ced_paPrima="," then $ced_paPrima='- - - - -'
		;RunWait( @comspec & " /c dcmqr -L QRSCU:11113 "&$AE1&"@"&$IpPuertoServidor & " -q00100020="&$Ced_pa&"* -r 00100030 -r 00100010 -r 00100040 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta por id paciente
		If $asterisco=1 Then
		RunWait( @comspec & " /c dcmqr -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor & " -q00100020="&$ced_paPrima&"* -r 00100030 -r 00100010 -r 00100040 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta por id paciente
		Else
		RunWait( @comspec & " /c dcmqr -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor & " -q00100020="&$ced_paPrima&" -r 00100030 -r 00100010 -r 00100040 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta por id paciente
		EndIf
	;Send ("dcmqr -L QRSCU:11113 DCM4CHEE@localhost:11112 -q00100020=1512* -r 00100030 -r 00100010 -r 00100021 -r 00100040{ENTER}")
	Else 
		$ape_paPrima=$Ape_pa
		If $ape_paPrima='' or $ape_paPrima="=" or $ape_paPrima=">" or $ape_paPrima="<" or $ape_paPrima="&" or $ape_paPrima=";"or $ape_paPrima="?"  or $ape_paPrima="/" or $ape_paPrima="""" or $ape_paPrima="\" or $ape_paPrima="," Then $ape_paPrima='IMAGOJO6464'
		;RunWait( @comspec & " /c dcmqr -L QRSCU:11113 "&$AE1&"@"&$IpPuertoServidor & " -q00100010="&$Ape_pa&"* -r 00100030 -r 00100020 -r 00100040 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta por apellido
		If $asterisco=1 Then
		RunWait( @comspec & " /c dcmqr -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor & " -q00100010="&$ape_paPrima&"* -r 00100030 -r 00100020 -r 00100040 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta por apellido
		Else
		RunWait( @comspec & " /c dcmqr -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor & " -q00100010="&$ape_paPrima&" -r 00100030 -r 00100020 -r 00100040 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta por apellido
		EndIf
		;RunWait( @comspec & " /c dcmecho "&$AE1&"@"&$IpPuertoServidor & " > " & @TempDir & "\ECO.log",$dir_trab,@SW_HIDE)
	EndIf
	$file = FileOpen(@TempDir & "\IMAGOJOQuery.dat", 0)
	If $file = -1 Then
    SplashOff()
	MsgBox(0, "Error 1099", "El valor ingresado contiene caracteres no permitidos")
	GUIDelete ($form2)
	Call ("Form"&$Op)
	EndIf
	$Query = FileRead($file)
	;Se lee primero la cantidad de registros encontrados
	$result = StringInStr($Query, "INFO   - Received ") ;busca la posición donde está el dato
	If $result>0 Then
		$EstadoServ = "Activo";Si está la frase es porque el servidor está arriba
	Else
		if  $Ced_pa Or $Ape_pa Then $EstadoServ = "Inactivo"
	EndIf
	$result = $result+18;se posiciona exactamente donde comienza el dato
	$var = StringMid($Query, $result, 6) ; extraigo 6 caracteres por si es un número largo
	$array = StringSplit($var, ' ', 1);obtengo el dato válido hasta el espacio como delimitador
	$Nro_registros = $array[1]
	SplashOff()
	if 	$Nro_registros >1 Then $Nro_CONSULTA=1;si hay registros se inicializa la consulta
		;MsgBox(0, "La cantidad de registros encontrados es:", $Nro_registros)
	FileClose($file)
		If $Nro_registros=0 Then
			If $EstadoServ = "Activo" then
				MsgBox(0, "Búsqueda finalizada", "No se encontraron datos para su consulta",10)
			Else
				MsgBox(0, "Búsqueda finalizada", "No se encontraron datos porque no hay conexión con el servidor",10)
			EndIf
		$Consulta=0
		ExitLoop
		EndIf
	;DECODIFICANDO LOS DATOS QUE RESPONIÓ EL PACS
	;(0010,0010) PN #14 [Prieto^Alvaro] Patient's Name
	$result = StringInStr($Query, "(0010,0010)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$pat_name_Pacsdb = $array[1]
	;Convirtiendo los datos obtenidos para IMAGOJO
	$array = StringSplit($pat_name_Pacsdb, '^', 1)
	if @error Then; por si hubiera un caso -no permitido en IMAGOJO- que contenga solo apellido
	$Ape_pa = $array[1]
	$Nom_pa = 'INVALIDO SIN -> NOMPRE DE PACIENTE'
	Else
	$Nom_pa = $array[2]
	$Ape_pa = $array[1]	
	endif
	;MsgBox(0, "El nombre es :", $Nom_pa&' y el apellido es:'&$Ape_pa )
	
	;(0010,0020) LO #10 [1512555-6] Patient ID
	$result = StringInStr($Query, "(0010,0020)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$ced_paciente = $array[1]
	if $ced_paciente ='' then $ced_paciente = 'INVALIDO SIN -> PATIENT ID'
	$Ced_pa = $ced_paciente
	;MsgBox(0, "El IDpaciente es :", $pat_id_Pacsdb)
		;Detector de cédulas válidas
		$Cedula_valida=0
		$num=StringIsDigit($Ced_pa)  ;verifica que la cedula solo contenga digitos 0 a 9
		If $num then; si contiene solo números
			$ced = $Ced_pa
			$len = StringLen ($ced)
			if $len=7 then $ced = "0"&$ced
			;MsgBox(0, "la suma da:", $ced)
			$len = StringLen ($ced)
			$suma=0
			For $i=1 to $len-1
			;variable, posición,  numero de caracteres a extraer
			$var = StringMid($ced, $i, 1)
			If $i=1 Then $amult=2
			If $i=2 Then $amult=9
			If $i=3 Then $amult=8
			If $i=4 Then $amult=7
			If $i=5 Then $amult=6
			If $i=6 Then $amult=3
			If $i=7 Then $amult=4
			$suma=$suma+($var*$amult)
			Next
			;MsgBox(0, "la suma da:", $suma)
			$len = StringLen ($suma)
			$var = StringMid($suma, $len, 1)
			;MsgBox(0, "el ultimo digito de la suma es:", $var)
			$digver=10-$var
			If $digver=10 then $digver=0
			$var = StringMid($ced, 8, 1)
			;MsgBox(0, "el digito debe ser:", $digver)
			If $digver = $var Then 	$Cedula_valida=1
			;MsgBox(0, 'Resultado', "La cédula "& $cedula & " ingresada es correcta")
		EndIf
	
	;(0010,0030) DA #0 [] Patient's Birth Date
	$result = StringInStr($Query, "(0010,0030)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$pat_birthdate_Pacsdb = $array[1]

	$DiaN_pa = StringTrimLeft($pat_birthdate_Pacsdb, 6)
	$MesN_pa = StringTrimLeft($pat_birthdate_Pacsdb, 4)
	$MesN_pa = StringTrimRight($MesN_pa, 2)
	$AniN_pa = StringTrimRight($pat_birthdate_Pacsdb, 4)
	;MsgBox(0, "El nacimiento es :", $DiaN_pa&' '&$MesN_pa&' '&$AniN_pa)
	
	;(0010,0040) CS #0 [] Patient's Sex
	$result = StringInStr($Query, "(0010,0040)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$sex_paciente = $array[1]
	;MsgBox(0, "El sexo es :", $sex_paciente)

	GUIDelete ($form2)
	Call ("Form"&$Op)

	
Case $Button14;Botón > de consulta siguiente
	$Nro_CONSULTA= $Nro_CONSULTA+1
	If $Nro_CONSULTA > $Nro_registros then $Nro_CONSULTA = $Nro_registros ; es cuando llego al tope
	$Op=2
	;DECODIFICANDO LOS DATOS QUE RESPONDIÓ EL PACS
	;(0010,0010) PN #14 [Prieto^Alvaro] Patient's Name
	$result = StringInStr($Query, "(0010,0010)",0,$Nro_CONSULTA+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$pat_name_Pacsdb = $array[1]
	;Convirtiendo los datos obtenidos para IMAGOJO
	$array = StringSplit($pat_name_Pacsdb, '^', 1)
	if @error Then; por si hubiera un caso -no permitido en IMAGOJO- que contenga solo apellido
	$Ape_pa = $array[1]	
	$Nom_pa = 'INVALIDO SIN -> NOMPRE DE PACIENTE'
	Else
	$Nom_pa = $array[2]
	$Ape_pa = $array[1]	
	endif
	;MsgBox(0, "El nombre es :", $Nom_pa&' y el apellido es:'&$Ape_pa )
	
	;(0010,0020) LO #10 [1512555-6] Patient ID
	$result = StringInStr($Query, "(0010,0020)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$ced_paciente = $array[1]
	if $ced_paciente ='' then $ced_paciente = 'INVALIDO SIN -> PATIENT ID'
	$Ced_pa = $ced_paciente
	;MsgBox(0, "El IDpaciente es :", $pat_id_Pacsdb)
		;Detector de cédulas válidas
		$Cedula_valida=0
		$num=StringIsDigit($Ced_pa)  ;verifica que la cedula solo contenga digitos 0 a 9
		If $num then; si contiene solo números
			$ced = $Ced_pa
			$len = StringLen ($ced)
			if $len=7 then $ced = "0"&$ced
			;MsgBox(0, "la suma da:", $ced)
			$len = StringLen ($ced)
			$suma=0
			For $i=1 to $len-1
			;variable, posición,  numero de caracteres a extraer
			$var = StringMid($ced, $i, 1)
			If $i=1 Then $amult=2
			If $i=2 Then $amult=9
			If $i=3 Then $amult=8
			If $i=4 Then $amult=7
			If $i=5 Then $amult=6
			If $i=6 Then $amult=3
			If $i=7 Then $amult=4
			$suma=$suma+($var*$amult)
			Next
			;MsgBox(0, "la suma da:", $suma)
			$len = StringLen ($suma)
			$var = StringMid($suma, $len, 1)
			;MsgBox(0, "el ultimo digito de la suma es:", $var)
			$digver=10-$var
			If $digver=10 then $digver=0
			$var = StringMid($ced, 8, 1)
			;MsgBox(0, "el digito debe ser:", $digver)
			If $digver = $var Then 	$Cedula_valida=1
			;MsgBox(0, 'Resultado', "La cédula "& $cedula & " ingresada es correcta")
		EndIf
		
	;(0010,0030) DA #0 [] Patient's Birth Date
	$result = StringInStr($Query, "(0010,0030)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$pat_birthdate_Pacsdb = $array[1]

	$DiaN_pa = StringTrimLeft($pat_birthdate_Pacsdb, 6)
	$MesN_pa = StringTrimLeft($pat_birthdate_Pacsdb, 4)
	$MesN_pa = StringTrimRight($MesN_pa, 2)
	$AniN_pa = StringTrimRight($pat_birthdate_Pacsdb, 4)
	;MsgBox(0, "El nacimiento es :", $DiaN_pa&' '&$MesN_pa&' '&$AniN_pa)
	
	;(0010,0040) CS #0 [] Patient's Sex
	$result = StringInStr($Query, "(0010,0040)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$sex_paciente = $array[1]
	;MsgBox(0, "El sexo es :", $sex_paciente)
			
	;ExitLoop
	GUIDelete ($form2)
	Call ("Form"&$Op)

Case $Button13;Botón < de consulta anterior
	$Nro_CONSULTA= $Nro_CONSULTA-1
	If $Nro_CONSULTA < 1 then $Nro_CONSULTA = 1 ; es cuando llego al tope
	$Op=2
	;RESCATANDO LOS DATOS QUE RESPONIÓ EL PACS
	;(0010,0010) PN #14 [Prieto^Alvaro] Patient's Name
	$result = StringInStr($Query, "(0010,0010)",0,$Nro_CONSULTA+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$pat_name_Pacsdb = $array[1]
	;Convirtiendo los datos obtenidos para IMAGOJO
	$array = StringSplit($pat_name_Pacsdb, '^', 1)
		if @error Then; por si hubiera un caso -no permitido en IMAGOJO- que contenga solo apellido
		$Ape_pa = $array[1]
		$Nom_pa = 'INVALIDO SIN -> NOMPRE DE PACIENTE'
		Else
		$Nom_pa = $array[2]
		$Ape_pa = $array[1]	
		endif
	;MsgBox(0, "El nombre es :", $Nom_pa&' y el apellido es:'&$Ape_pa )
	
	;(0010,0020) LO #10 [1512555-6] Patient ID
	$result = StringInStr($Query, "(0010,0020)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$ced_paciente = $array[1]
	if $ced_paciente ='' then $ced_paciente = 'INVALIDO SIN -> PATIENT ID'
	$Ced_pa = $ced_paciente
	;MsgBox(0, "El IDpaciente es :", $pat_id_Pacsdb)
		;Detector de cédulas válidas
		$Cedula_valida=0
		$num=StringIsDigit($Ced_pa)  ;verifica que la cedula solo contenga digitos 0 a 9
		If $num then; si contiene solo números
			$ced = $Ced_pa
			$len = StringLen ($ced)
			if $len=7 then $ced = "0"&$ced
			;MsgBox(0, "la suma da:", $ced)
			$len = StringLen ($ced)
			$suma=0
			For $i=1 to $len-1
			;variable, posición,  numero de caracteres a extraer
			$var = StringMid($ced, $i, 1)
			If $i=1 Then $amult=2
			If $i=2 Then $amult=9
			If $i=3 Then $amult=8
			If $i=4 Then $amult=7
			If $i=5 Then $amult=6
			If $i=6 Then $amult=3
			If $i=7 Then $amult=4
			$suma=$suma+($var*$amult)
			Next
			;MsgBox(0, "la suma da:", $suma)
			$len = StringLen ($suma)
			$var = StringMid($suma, $len, 1)
			;MsgBox(0, "el ultimo digito de la suma es:", $var)
			$digver=10-$var
			If $digver=10 then $digver=0
			$var = StringMid($ced, 8, 1)
			;MsgBox(0, "el digito debe ser:", $digver)
			If $digver = $var Then 	$Cedula_valida=1
			;MsgBox(0, 'Resultado', "La cédula "& $cedula & " ingresada es correcta")
		EndIf
	
	;(0010,0030) DA #0 [] Patient's Birth Date
	$result = StringInStr($Query, "(0010,0030)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$pat_birthdate_Pacsdb = $array[1]

	$DiaN_pa = StringTrimLeft($pat_birthdate_Pacsdb, 6)
	$MesN_pa = StringTrimLeft($pat_birthdate_Pacsdb, 4)
	$MesN_pa = StringTrimRight($MesN_pa, 2)
	$AniN_pa = StringTrimRight($pat_birthdate_Pacsdb, 4)
	;MsgBox(0, "El nacimiento es :", $DiaN_pa&' '&$MesN_pa&' '&$AniN_pa)
	
	;(0010,0040) CS #0 [] Patient's Sex
	$result = StringInStr($Query, "(0010,0040)",0,$Nro_Consulta+1) ;busca el dato, se saltea la 1ra. porque es la propia consulta
	$var = StringMid($Query, $result, 80)
	$array = StringSplit($var, '[', 1)
	$var = $array[2];selecciono el dato desde este caracter al final
	$array = StringSplit($var, ']', 1)
	$sex_paciente = $array[1]
	;MsgBox(0, "El sexo es :", $sex_paciente)
			
	;ExitLoop
	GUIDelete ($form2)
	Call ("Form"&$Op)

EndSwitch
WEnd
$ced_paciente = $Ced_pa
$Nom_paciente = $Ape_pa&"^" & $Nom_pa 
$fnac_paciente = $AniN_pa & $MesN_pa & $DiaN_pa 

GUIDelete ($form2)
Call ("Form"&$Op)
EndFunc
#Region FIN PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#Region FIN PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#Region FIN PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2

;Función 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4   SELECC ARCHIVOS JPG   4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
;Función 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4   SELECC ARCHIVOS JPG   4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
;Función 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4   SELECC ARCHIVOS JPG   4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
Func Form4()
;GUISetState (@SW_DISABLE, $form1 )
$previsual=GUICreate("Archivo Seleccionado",500,500,-1,-1,$WS_SIZEBOX+$WS_SYSMENU)
$message = "Elegir imagen para crear archivo para la historia del paciente"
;$var = FileOpenDialog($message, $Dir_jpg & "\", "Imagenes (*.jpg)", 1 + 4 )
$var = FileOpenDialog($message, $Dir_jpg, "Imagenes (*.jpg)", 1 + 4 )
if @error = 1 then 

form1()
EndIf
$busca = StringInStr($var, "\",0 , -1); busca la primer ocurrencia desde la izq
$Arch_jpg = StringTrimLeft($var, $busca)
$Dir_jpg= StringTrimRight($var,(StringLen($var) - $busca)); directroio de los jpg


If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_jpg = $var;ruta completa hasta el archivo
    ;MsgBox(4096,"","Archivo elegido " & $Ruta_jpg)
	EndIf

form5()
EndFunc;fin Func4
#Region FIN FORM4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 SELECC ARCHIVOS 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
#Region FIN FORM4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 SELECC ARCHIVOS 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
#Region FIN FORM4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 SELECC ARCHIVOS 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4

;5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
;5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
;5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
Func Form5()
#Region ### START Koda GUI section ### Form=l:\IMAGOJO\software bajado\programacion\koda 1.7.0.1\forms\fotocomentar.kxf
$nombrevent="Imagen para crear DICOM para paciente: "&$Ape_pa &', '& $Nom_pa &"  Fecha:"&@MDAY & "/" & @MON & "/" & @YEAR
$Form5 = GUICreate($nombrevent, 801, 474, $X_vent, $Y_vent, $WS_SIZEBOX + $WS_SYSMENU + $WS_MAXIMIZEBOX)
$Pic1 = GUICtrlCreatePic($Ruta_jpg, 144, 77, 521, 361)
$Label2 = GUICtrlCreateLabel("Descripción del estudio:", 45, 8, 114, 17)
GUICtrlSetTip(-1, "Study Description")
$Input2 = GUICtrlCreateInput($estudioSel, 165, 3, 265, 21)
$Label3 = GUICtrlCreateLabel("Médico  de Referencia:", 460, 6, 113, 17)
GUICtrlSetTip(-1, "Referring Physicians Name")
$Input3 = GUICtrlCreateInput("", 579, 3, 209, 21)
$Label4 = GUICtrlCreateLabel("Comentario sobre el paciente:", 17, 32, 143, 17)
GUICtrlSetTip(-1, "Comments on Patient")
$Input4 = GUICtrlCreateInput("", 165, 27, 265, 21)
$Label1 = GUICtrlCreateLabel("Comentario sobre la imagen:", 25, 56, 134, 17)
GUICtrlSetTip(-1, "Image Comments")
$Input1 = GUICtrlCreateInput("", 165, 51, 622, 21)
$Button1 = GUICtrlCreateButton("Crear", 710, 80, 75, 25, 0)
$Button3 = GUICtrlCreateButton("Previsualizar", 16, 80, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 16, 408, 75, 25, 0)
$Label5 = GUICtrlCreateLabel("Fecha del contenido:", 471, 29, 101, 17)
GUICtrlSetTip(-1, "Content Date")
; DATE
$InputFecha_contenido=GuiCtrlCreateDate("", 581, 27, 200, 21,$DTS_SHORTDATEFORMAT)


GUISetState ()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	GUIDelete ($form5)
Call ("Form1")
Case $Button1; Crear
	$Coment=GUICtrlRead($Input1)
	$Desc_estud=GUICtrlRead($Input2);"Aqui va la variable con la desc. del estudio"
	$MedRef=GUICtrlRead($Input3)
	$Coment_pa=GUICtrlRead($Input4)
	$estudioSel=""
	$Fecha_contenido=GUICtrlRead($InputFecha_contenido)
	$anioFC=StringTrimLeft($Fecha_contenido, 6);2012
	$mesFC=StringTrimLeft($Fecha_contenido, 3);12/2012
	$mesFC=StringTrimRight($mesFC, 5);12
	$diaFC=StringTrimRight($Fecha_contenido, 8);31
	$Fecha_contenido=$anioFC&$mesFC&$diaFC;Se convierte al formato de la norma DICOM 20121231
	$Op=9; Va a Form9 crear DICOM
	ExitLoop
Case $Button2; Cancelar
	$estudioSel=""
	$Op=1
	ExitLoop
Case $Button3; Previsualizar orig 31/12/2012
	ShellExecute($Ruta_jpg)

	EndSwitch
WEnd
if $Op=1 or $Op=5 Then GUIDelete ($form5)
Call ("Form"&$Op)
EndFunc;Fin función 5
#region 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
#region 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
#region 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5

Func Form9()
;GUISetState (@SW_ENABLE, $form1 )
;SplashTextOn ("Creación de Archivo DICOM", "Se está creando el archivo DICOM", 250,100)
$Formaa = GUICreate("", 393, 157, -1, -1)
$Progress1 = GUICtrlCreateProgress(88, 88, 201, 20)
$Label1 = GUICtrlCreateLabel("Se está creando el archivo DICOM", 24, 40, 346, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
GUICtrlSetData ($Progress1,10)
;Crear archivo cfg para el jpg2dcm.bat
;se crea el archivo cfg vacío(,2)en el direcorio temp, si ya existe borra el contenido
$arch_cfg = @TempDir &"\jpg2dcm.cfg";ruta y archivo cfg
$file = FileOpen($arch_cfg, 2)
If $file = -1 Then
    MsgBox(0, "Error 1529", "No se pudoo abrir "&$arch_cfg". Chequear instalación")
    Exit
EndIf
;Sector jpg - Tags DICOM - Etiquetas DICOM 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$Nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
;# Issuer of Patient ID 00100021
if $PaV=1 and $Cedula_valida=1 then
FileWriteLine ($file, "00100021:C.I. uruguaya")
endif
;# Patient's Birth Date
;00100030:19990421
FileWriteLine ($file, "00100030:"&$fnac_paciente)
;# Patient's Sex
;00100040:M
FileWriteLine ($file, "00100040:"&$sex_paciente)
;# Patient's Adress 00101040
FileWriteLine ($file, "00101040:"&$Dir_pa)
;# Patient's Telephone Numbers 00102154
FileWriteLine ($file, "00102154:"&$Tel1_pa&"; "&$Tel2_pa)
;# Comments on Patient 00104000
FileWriteLine ($file, "00104000:"&$Coment_pa); - - - - - - - - - - - - - 

;# Image Comments
FileWriteLine ($file, "00204000:"&$Coment)
;# StudyID (0020,0010) 
FileWriteLine ($file, "00200010:")
;# (0008,1030) StudyDescription
FileWriteLine ($file, "00081030:"&$Desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
;# ContentDate
FileWriteLine ($file, "00080023:"&$Fecha_contenido); - - - - - - - - - - - - - 
;# Manufacturer
FileWriteLine ($file, "00080070:IMAGOJO 1.00")
;# ReferringPhysiciansName
FileWriteLine ($file, "00080090:"&$MedRef)
;# InstitutionName
FileWriteLine ($file, "00080080:" &$Institucion)
;# StationName
FileWriteLine ($file, "00081010:"&$Estacion)
;# Operator's Name
FileWriteLine ($file, "00081070:"&$usuario)
;# InstitutionalDepartment
FileWriteLine ($file, "00081040:"&$Dpto)

FileClose($file)
;Crear imagen DICOM
;ruta y archivo DICOM a crear:
$Nom_Dcm=@YEAR&@MON&@MDAY&@HOUR&@MIN&@SEC
$Arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm &".dcm"
;$Arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm&$Azar &".dcm"
;$consola_crea_log = @TempDir & "\conversión.log";log de la consola al crear el archivo
GUICtrlSetData ($Progress1,20)
;Se copia el archivo seleccionado con otro nombre mas corto, sino el jpg2dcm da problemas 
FileCopy($Ruta_jpg, $dir_trab&"\selecc.jpg",1)
GUICtrlSetData ($Progress1,30)
Sleep (4000)
GUICtrlSetData ($Progress1,40)
;Creación del archivo DICOM con la imagen seleccionada
RunWait( @comspec & " /c jpg2dcm -c "&$arch_cfg& " "&$dir_trab&"\selecc.jpg " & $Arch_nuevo_dcm & " > " & @TempDir & "\conversion.log",$dir_trab,@SW_HIDE)
GUICtrlSetData ($Progress1,50)
;Lee el log
$file = FileOpen(@TempDir & "\conversion.log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 1599", "No se pudoo abrir el archivo conversion.log. Chequear instalación")
    ;Exit
EndIf
; Lee el archivo
$chars = FileRead($file)
FileClose($file)
;Busca la palabra de que el archivo fue creado
$result = StringInStr($chars, "Encapsulated ")
GUICtrlSetData ($Progress1,100)
Sleep (1000)
GUIDelete ()
if $result >0 then
	;SplashTextOn ("Creación de Archivo DICOM", "Se creó el archivo :" &$Nom_Dcm&".dcm")
;	GUIDelete ($form5)
Else
	MsgBox(0, "Resultado:", "El archivo jpg elegido no es compatible o el comentario contiene avances de línea",10)
	GUIDelete ($form5)
	Call ("Form1")
EndIf
FileDelete($Dir_trab&"\selecc.jpg")
;Escribir en el log
$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 1622", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se creó '&$Nom_Dcm&'.dcm a partir de archivo jpg')
				FileClose($file2)
				EndIf
;Fin escritura del log
$respuesta=MsgBox(4, "Archivo creado exitosamente", "Desea enviar al servidor "&$servidor &" el archivo DICOM creado ahora?")
if $respuesta= "7" Then
	GUIDelete ($form5)
	Call ("Form1")
	EndIf
$FormXX=$form5
;EnviarDcm()
Run($Ruta_IMAGOJO&'\Lib\IMAGOJODIR.exe')
GUIDelete ($FormXX)
Call ("Form8")
EndFunc;fin de Func9
;6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 COMUNICACIONES 6 6 6 6 6 6 6 6 6 6 6 6
;6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 COMUNICACIONES 6 6 6 6 6 6 6 6 6 6 6 6
;6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 COMUNICACIONES 6 6 6 6 6 6 6 6 6 6 6 6
Func Form6()
GUIDelete ($form1)
#Region ### START Koda GUI section ### Form=C:\IMAGOJO\koda 1.7.0.1\Forms\ConfiguracionTab.kxf
SplashOff()
$Form6 = GUICreate("IMAGOJO: Configuración                              "&$Dpto&" - "&$Institucion, 801, 451, $X_vent, $Y_vent)
$PageControl1 = GUICtrlCreateTab(8, 8, 780, 352)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Comunicaciones")
$Label2 = GUICtrlCreateLabel("Servidor:"&$Servidor, 546, 246, 164, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Estado: "&$EstadoServ, 545, 272, 99, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$ae22 = GUICtrlCreateInput($AE2, 227, 173, 113, 22);input ae2
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label5 = GUICtrlCreateLabel("AE  Título", 259, 157, 49, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$puerto22 = GUICtrlCreateInput($PUERTO2, 501, 173, 113, 22); input puerto2
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label7 = GUICtrlCreateLabel("Puerto", 541, 157, 35, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button6 = GUICtrlCreateButton("Activar", 633, 171, 75, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$alias11 = GUICtrlCreateInput($ALIAS1, 89, 107, 113, 22);input alias1
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label1 = GUICtrlCreateLabel("Alias", 121, 91, 35, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$ae11 = GUICtrlCreateInput($AE1, 226, 108, 113, 22);input ae2
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label8 = GUICtrlCreateLabel("AE  Título", 258, 92, 49, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$ip11 = GUICtrlCreateInput($IP1, 364, 108, 113, 22);input ip1
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label9 = GUICtrlCreateLabel("Dirección IP", 392, 92, 60, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$puerto11 = GUICtrlCreateInput($PUERTO1, 500, 108, 113, 22);input puerto1
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label10 = GUICtrlCreateLabel("Puerto", 540, 92, 35, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button7 = GUICtrlCreateButton("Activar", 632, 106, 75, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$LabelServ = GUICtrlCreateLabel("Servidor Remoto:   "&$Servidor&"   "&$IpPuertoServidor, 146, 52, 358, 18)
GUICtrlSetFont(-1, 9, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x008000)
$Label12 = GUICtrlCreateLabel("Remoto", 42, 108, 40, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label13 = GUICtrlCreateLabel("Local", 54, 178, 30, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

$Label14 = GUICtrlCreateLabel("Mi PC: Nombre del equipo: "&@ComputerName, 28, 334, 231, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Group1 = GUICtrlCreateGroup("", 9, 318, 776, 39)
GUICtrlCreateGroup("", -99, -99, 1, 1)


$Label4 = GUICtrlCreateLabel("IP1: "&@IPAddress1, 301, 334, 102, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label6 = GUICtrlCreateLabel("IP2: "&@IPAddress2, 441, 334, 102, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

GUICtrlCreateTabItem("")
$Button1 = GUICtrlCreateButton("&OK", 694, 384, 75, 25, 0)

If $EstadoServ = "Activo" then 
	GuiCtrlCreateLabel(" ", 637, 277, 10, 7)
	GuiCtrlSetBkColor(-1, 0x00FF00)
	Else
	GuiCtrlCreateLabel(" ", 644, 277, 10, 7)
	GuiCtrlSetBkColor(-1, 0xFF0000)
	EndIf

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $Button1
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	GUIDelete ($form6)
	Call ("Form1")
Case $GUI_EVENT_CLOSE
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	GUIDelete ($form6)
	Call ("Form1")
Case $Button7; Activar Op1
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	SplashTextOn ("Activando..", "Activando y efectuando Eco", 250,100)
	$ALIAS1=GUICtrlRead($Alias11)
	$AE1=GUICtrlRead($AE11)
	$IP1=GUICtrlRead($IP11)
	$PUERTO1=GUICtrlRead($PUERTO11)
	$Servidor = $ALIAS1
	$IpPuertoServidor = $IP1&':'&$PUERTO1

	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "Alias1", $ALIAS1)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "AE1", $AE1)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "IP1", $IP1)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "PUERTO1", $PUERTO1)
	;IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "IpPuertoServidor", $IpPuertoServidor)


;Inicio Echo DICOM
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	$Op=1
	$borr=1
#cs;Eco DICOM
FileChangeDir($dir_trab)
FileDelete(@TempDir & "\IMAGOJO.log")
	RunWait( @comspec & " /c dcmecho "&$AE1&"@"&$IpPuertoServidor & " > " & @TempDir & "\ECO.log",$dir_trab,@SW_HIDE)
	$file = FileOpen(@TempDir & "\ECO.log", 0)
	If $file = -1 Then
    MsgBox(0, "Error 200", "Chequear instalación")
	Exit
	EndIf
	$chars = FileRead($file)
	$result = StringInStr($chars, "verification")
	if $result >0 then $EstadoServ = "Activo"
	if $result <=0 then $EstadoServ = "Inactivo"
	FileClose($file)
#ce;Fin Echo DICOM
;Conteo de estudios
RunWait( @comspec & " /c dcmqr -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor & " -q00100020== -r 00100030 > " & @TempDir & "\IMAGOJOQuery.dat",$dir_trab,@SW_HIDE);consulta genérica que da todos los estudios en el pacs
	$file = FileOpen(@TempDir & "\IMAGOJOQuery.dat", 0)
	If $file = -1 Then
	MsgBox(0, "Error 1784", "No se pudo abrir IMAGOJOquery.dat")
	GUIDelete ($form2)
	Call ("Form"&$Op)
	EndIf
	$Query = FileRead($file)
	FileClose($file)
	;Se lee primero la cantidad de registros encontrados
	$result = StringInStr($Query, "INFO   - Received ") ;busca la posición donde está el dato
	If $result>0 Then
		$EstadoServ = "Activo";Si está la frase es porque el servidor está arriba
		$result = $result+18;se posiciona exactamente donde comienza el dato
		$var = StringMid($Query, $result, 6) ; extraigo 6 caracteres por si es un número largo
		$array = StringSplit($var, ' ', 1);obtengo el dato válido hasta el espacio como delimitador
		$Nro_registrosT = $array[1]
		IniWrite($Ruta_IMAGOJO&"\LIB\IMAGOJO_CONT.ini", "CONTEO", "ESTUDIOS", $Nro_registrosT)
		;MsgBox(0, "La cantidad de registros encontrados es:", $Nro_registrosT+15000)
	Else
		$EstadoServ = "Inactivo"
		IniWrite($Ruta_IMAGOJO&"\LIB\IMAGOJO_CONT.ini", "CONTEO", "ESTUDIOS", 0)
	EndIf
;Fin de conteo de estudios al empezar
	GUIDelete ($form6)
	ExitLoop
Case $Button6; Activar Op2
	SplashTextOn ("Activando..", "Activando", 250,100)
	;$ALIAS2=GUICtrlRead($Alias22)
	$AE2=GUICtrlRead($AE22)
	;$IP2=GUICtrlRead($IP22)
	$PUERTO2=GUICtrlRead($PUERTO22)
	;$IpPuertoLocal = $IP2&':'&$PUERTO2
	;IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "Alias2", $ALIAS2)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "AE2", $AE2)
	;IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "IP2", $IP2)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "PUERTO2", $PUERTO2)
;	;IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "Servidor", $Servidor)
;	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Comunicaciones", "IpPuertoLocal", $IpPuertoLocal)	
	GUIDelete ($form6)
	ExitLoop
#CS
Case $Button7
GUIDelete ($form1)
GUIDelete ($form5)
Call ("Form1")
#CE
EndSwitch
WEnd
Call ("Form6")
EndFunc ;FINAL FORM6
#Region Fin Form6 COMUNICACIONES 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
#Region Fin Form6 COMUNICACIONES 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
#Region Fin Form6 COMUNICACIONES 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6


Func Form10()
GUIDelete ($form1)
#Region ### START Koda GUI section ### Form=C:\IMAGOJO\koda 1.7.0.1\Forms\ConfiguracionTab.kxf
SplashOff()
$Form10 = GUICreate("IMAGOJO: Configuración                              "&$Dpto&" - "&$Institucion, 801, 451, $X_vent, $Y_vent)
$PageControl1 = GUICtrlCreateTab(8, 8, 780, 352)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Estación")
$inputRutaCaptura = GUICtrlCreateInput($RutaCaptura, 216, 128, 417, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label1 = GUICtrlCreateLabel("Programa de captura", 102, 133, 105, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button2 = GUICtrlCreateButton("Explorar", 640, 126, 57, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$inputEstacion = GUICtrlCreateInput($Estacion, 184, 48, 145, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label2 = GUICtrlCreateLabel("Nombre de esta estación:", 54, 53, 123, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;$Label3 = GUICtrlCreateLabel("Nombre del programa de Captura", 102, 95, 163, 18)
;GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;$InputNProgCaptura = GUICtrlCreateInput($NProgCaptura , 269, 90, 177, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$InputDir_jpg = GUICtrlCreateInput($Dir_jpg, 201, 168, 433, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label4 = GUICtrlCreateLabel("Ruta imagenes jpg", 102, 173, 92, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button3 = GUICtrlCreateButton("Explorar", 641, 166, 57, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label3 = GUICtrlCreateLabel("Ruta videos mpeg, mpg", 102, 213, 116, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$InputDir_video = GUICtrlCreateInput($Dir_video, 225, 208, 409, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button5 = GUICtrlCreateButton("Explorar", 641, 206, 57, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label5 = GUICtrlCreateLabel("Ruta documentos pdf", 102, 253, 107, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$InputDir_pdf = GUICtrlCreateInput($Dir_pdf, 213, 248, 417, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button6 = GUICtrlCreateButton("Explorar", 637, 246, 57, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Checkbox1 = GUICtrlCreateCheckbox("Insertar un  comodín (*) en la consulta de pacientes", 112, 298, 273, 25)
$Label6 = GUICtrlCreateLabel("Institución:", 55, 93, 55, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$InputInstitucion = GUICtrlCreateInput($Institucion, 119, 88, 249, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label7 = GUICtrlCreateLabel("Departamento:", 393, 93, 74, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$InputDpto = GUICtrlCreateInput($Dpto, 476, 88, 249, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Checkbox2 = GUICtrlCreateCheckbox("Ocultar diálogos al enviar DICOM", 467, 298, 193, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

If $Asterisco=1 then
	GUICtrlSetState(19, $GUI_CHECKED)
	Else
	GUICtrlSetState(19, $GUI_UNCHECKED)
	EndIf	
If $Ocultar=1 then
	GUICtrlSetState(22, $GUI_CHECKED)
	Else
	GUICtrlSetState(22, $GUI_UNCHECKED)
	EndIf	


GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlCreateTabItem("")
$Button1 = GUICtrlCreateButton("&OK", 694, 384, 75, 25, 0)
$Button4 = GUICtrlCreateButton("&Cancelar", 38, 384, 75, 25, 0)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $Checkbox1
	$estado=GUICtrlRead($Checkbox1)	
	If $estado=1 Then
	 $Asterisco=1
	Else
	$Asterisco=0
	EndIf
Case $Checkbox2
	$estado2=GUICtrlRead($Checkbox2)	
	If $estado2=1 Then
	 $Ocultar=1
	Else
	$Ocultar=0
	EndIf
;SplashTextOn ("Estado checkbox2="&$Checkbox2, "Estado="&$estado2, 250,100)
;Sleep(3000)
;SplashOff()
Case $Button1;ok
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	$RutaCaptura=GUICtrlRead($inputRutaCaptura)
	$Estacion=GUICtrlRead($inputEstacion)
	$Institucion=GUICtrlRead($inputInstitucion)
	$Dpto=GUICtrlRead($inputDpto)
	$Dir_jpg=GUICtrlRead($InputDir_jpg)
	$Dir_video=GUICtrlRead($inputDir_video)
	$Dir_pdf=GUICtrlRead($inputDir_pdf)
	if $RutaCaptura then
		$array = StringSplit($RutaCaptura, '\', 1)
		$n=$ARRAY[0]
		$NProgCaptura=$ARRAY[$n]
	Else
		$NProgCaptura=''
	EndIf
			
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "NProgCaptura", $NProgCaptura)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "RutaCaptura", $RutaCaptura)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "DirJpg", $Dir_jpg)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "Estación", $Estacion)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "DirVideo", $Dir_video)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "DirPdf", $Dir_pdf)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "* en Consultar", $Asterisco)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "Institución", $Institucion)
	IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Estación", "Departamento", $Dpto)

	GUIDelete ($form10)
	Call ("Form1")
Case $GUI_EVENT_CLOSE
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	GUIDelete ($form10)
	Call ("Form1")
Case $Button4; CANCELAR
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	
	GUIDelete ($form10)
	Call ("Form1")

Case $Button2; Explorar RProgCaptura
	$message = "Seleccionar Programa de captura"
	$RutaCaptura = FileOpenDialog($message, $RutaCaptura, "Programas (*.exe)", 1 + 4 )
	GUIDelete ($form10)
	ExitLoop
Case $Button3; Explorar Ruta jpg
	$message = "Seleccionar ruta de archivos jpg"
	$Dir_jpg = FileSelectFolder($message, "")
	GUIDelete ($form10)
	ExitLoop
Case $Button5; Explorar Ruta mpeg
	$message = "Seleccionar ruta de archivos mpeg, mpg"
	$Dir_video = FileSelectFolder($message, "")
	GUIDelete ($form10)
	ExitLoop
Case $Button6; Explorar Ruta pdf
	$message = "Seleccionar ruta de documentos pdf"
	$Dir_pdf = FileSelectFolder($message, "")
	GUIDelete ($form10)
	ExitLoop
EndSwitch
WEnd
Call ("Form10")
EndFunc ;FINAL FORM10
#Region Fin Form10 ESTACIÓN 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
#Region Fin Form10 ESTACIÓN 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
#Region Fin Form10 ESTACIÓN 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10

;7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7     CAPTURA     7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
;7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7     CAPTURA     7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
;7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7     CAPTURA     7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
Func Form7 ();Captura
	If $RutaCaptura='' Then
	$r=MsgBox(4, "Atención:", "No se ha elegido un programa de captura, ¿Desea hacerlo ahora?","")
		if $r=6 Then
		GUIDelete ($form1)
		Call ("Form10")
		Else
		GUIDelete ($form1)
		Call ("Form1")
		EndIf
	Else
	ClipPut($Ced_pa);Coloca el id de paciente en el portapapeles
	SplashTextOn ("Abrir Programa de Captura", "Abriendo.."&@LF&"Se copió ID Paciente al portapapeles", 250,100)
	Sleep (1500)
	SplashOff()
	Run ($RutaCaptura, @WindowsDir, @SW_MAXIMIZE)
	GUIDelete ($form1)
	Call ("Form1")
	EndIf
	
EndFunc ;FINAL FORM7 CAPTURA
#Region Fin Form7 CAPTURA 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
#Region Fin Form7 CAPTURA 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
#Region Fin Form7 CAPTURA 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7

;8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 MENU CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
;8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 MENU CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
;8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 MENU CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
Func Form8 ();
#Region ### START Koda GUI section ### Form=C:\IMAGOJO\koda 1.7.0.1\Forms\CrearDICOM03.kxf
$Form8 = GUICreate("IMAGOJO: Creación DICOM                              "&$Dpto&" - "&$Institucion, 801, 451, $X_vent, $Y_vent)
GUISetBkColor(0xF9FCFF)
If $EstadoServ = "Activo" Then $Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\bandacolorV.gif", 0, 0, 801, 49)
If $EstadoServ = "Inactivo" Then $Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\bandacolor.gif", 0, 0, 801, 49)
$Button4 = GUICtrlCreateButton("&Estudios en Papel", 546, 140, 99, 25, 0)
$Button3 = GUICtrlCreateButton("Archivo de &Video", 547, 200, 99, 25, 0)
$Button1 = GUICtrlCreateButton("Archivo de &Imagen", 546, 260, 99, 25, 0)
;$Button2 = GUICtrlCreateButton("&Texto", 546, 320, 99, 25, 0
$Button5 = GUICtrlCreateButton("Archivo &Pdf", 546, 320, 99, 25, 0)
$Button6 = GUICtrlCreateButton("Volver", 684, 386, 75, 25, 0)
$Label1 = GUICtrlCreateLabel("Paciente: ", 78, 256, 69, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label2 = GUICtrlCreateLabel($Ape_pa&", "&$Nom_pa, 145, 257, 273, 22)
GUICtrlSetFont(-1, 11, 800, 0, "Arial")
$Label4 = GUICtrlCreateLabel("Estación : "&$Estacion, 78, 208, 254, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label3 = GUICtrlCreateLabel("ID Paciente:", 78, 289, 83, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label5 = GUICtrlCreateLabel("Fecha : "&@MDAY & "/" & @MON & "/" & @YEAR, 78, 179, 129, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label7 = GUICtrlCreateLabel($Ced_pa, 165, 288, 273, 22)
GUICtrlSetFont(-1, 11, 800, 0, "Arial")
$Group1 = GUICtrlCreateGroup("", 48, 148, 417, 185)
GUICtrlCreateGroup("", -99, -99, 1, 1)
#EndRegion ### END Koda GUI section ###

GUISetState(@SW_SHOW)
While 1
   Switch GUIGetMsg()
   Case $Button1;archivo de imagen
	   	$borr=0
		If $Ced_pa Then
			$Op=4
		Else 
			$OPSAL=4
			$Op=2
		Endif
       exitloop
	Case $GUI_EVENT_CLOSE
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
		$Op=1
       exitloop 
   Case $Button6;Volver
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Else
	$X_vent=-1
	$Y_vent=-1
	EndIf
	   $Op=1
       exitloop 
	   
   Case $Button5;archivo Pdf
	   	If $PosVent=1 then
		$size = WinGetPos("IMAGOJO:")
		$X_vent=$size[0]
		$Y_vent=$size[1]
		Else
		$X_vent=-1
		$Y_vent=-1
		EndIf
	   	$borr=0
		If $Ced_pa Then
			$Op=20
		Else 
			$OPSAL=20
			$Op=2
		Endif
       exitloop
   Case $Button3;archivo Video
		If $PosVent=1 then
		$size = WinGetPos("IMAGOJO:")
		$X_vent=$size[0]
		$Y_vent=$size[1]
		Else
		$X_vent=-1
		$Y_vent=-1
		EndIf
	   
	   	$borr=0
		If $Ced_pa Then
			$Op=23
		Else 
			$OPSAL=23
			$Op=2
		Endif
       exitloop
   Case $Button4;Estudios en papel
		If $PosVent=1 then
		$size = WinGetPos("IMAGOJO:")
		$X_vent=$size[0]
		$Y_vent=$size[1]
		Else
		$X_vent=-1
		$Y_vent=-1
		EndIf
	
	   	$borr=1
		If $Ced_pa Then
			$Op=50
		Else 
			$OPSAL=50
			$Op=2
		Endif
       exitloop
EndSwitch
WEnd
;If $borr=1 Then GUIDelete ( "Form8")
GUIDelete ($form8)
Call ("Form"&$Op)
EndFunc
#Region Fin Form8 CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 
#Region Fin Form8 CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 
#Region Fin Form8 CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8

;Form20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20  SELECC PDF  20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
;Form20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20  SELECC PDF  20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
;Form20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20  SELECC PDF  20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
Func Form20()
$previsual=GUICreate("Archivo Seleccionado",500,500,-1,-1,$WS_SIZEBOX+$WS_SYSMENU)
$message = "Elegir Pdf para crear archivo para la historia del paciente"
$var = FileOpenDialog($message, $Dir_pdf, "Archivos Pdf (*.pdf)", 1 + 4 )
if @error = 1 then 
;		MsgBox(0, "ATENCIÓN", $form1,20)
;	Sleep (5000)
GUIDelete ($form1)
;	MsgBox(0, "ATENCIÓN2", $form1,20)
form1()
EndIf
$busca = StringInStr($var, "\",0 , -1)
$Arch_pdf = StringTrimLeft($var, $busca)
$Dir_pdf= StringTrimRight($var,(StringLen($var) - $busca)); directroio de los pdf

;MsgBox(4096, "Ruta", $var& "numero encontrado "&$busca)
;MsgBox(4096, "Imagen", $Arch_jpg)

If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_pdf = $var;ruta completa hasta el archivo
;    MsgBox(4096,"","Archivo elegido =" & $Ruta_pdf)
 ;   MsgBox(4096,"","$Arch_pdf =" & $Arch_pdf)
	EndIf
;$Nom_paciente = $Nom_pa &" " & $Ape_pa

form21()
EndFunc;fin Func20
Func Form21()
#Region ### START Koda GUI section ### Form=l:\IMAGOJO\software bajado\programacion\koda 1.7.0.1\forms\fotocomentar.kxf
$nombrevent="Archivo "&$Arch_pdf&" para crear DICOM para: "&$Ape_pa &', '& $Nom_pa &"  Fecha:"&@MDAY & "/" & @MON & "/" & @YEAR
$Form21 = GUICreate($nombrevent, 801, 474, $X_vent, $Y_vent, $WS_SIZEBOX + $WS_SYSMENU + $WS_MAXIMIZEBOX)
$Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\PdfImage.jpg", 288, 111, 225, 265)
$Label2 = GUICtrlCreateLabel("Descripción del estudio:", 45, 8, 114, 17)
GUICtrlSetTip(-1, "Study Description")
$Input2 = GUICtrlCreateInput($estudioSel, 165, 3, 265, 21)
$Label3 = GUICtrlCreateLabel("Médico  de Referencia:", 460, 6, 113, 17)
GUICtrlSetTip(-1, "Referring Physicians Name")
$Input3 = GUICtrlCreateInput("", 579, 3, 209, 21)
$Label4 = GUICtrlCreateLabel("Comentario sobre el paciente:", 17, 32, 143, 17)
GUICtrlSetTip(-1, "Comments on Patient")
$Input4 = GUICtrlCreateInput("", 165, 27, 265, 21)
$Label1 = GUICtrlCreateLabel("Título del documento pdf:", 35, 56, 134, 17)
GUICtrlSetTip(-1, "Document Title")
$Input1 = GUICtrlCreateInput("", 165, 51, 622, 21)
$Button1 = GUICtrlCreateButton("Crear", 710, 80, 75, 25, 0)
$Button3 = GUICtrlCreateButton("Previsualizar", 16, 80, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 16, 408, 75, 25, 0)
$Label5 = GUICtrlCreateLabel("Fecha del contenido:", 471, 29, 101, 17)
GUICtrlSetTip(-1, "Content Date")
; DATE
$InputFecha_contenido=GuiCtrlCreateDate("", 581, 27, 200, 21,$DTS_SHORTDATEFORMAT)
GUISetState ()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	GUIDelete ($form21)
Call ("Form1")
Case $Button1; Crear
	$Coment=GUICtrlRead($Input1)
	$Desc_estud=GUICtrlRead($Input2);"Aqui va la variable con la desc. del estudio"
	$MedRef=GUICtrlRead($Input3)
	$Coment_pa=GUICtrlRead($Input4)
	$estudioSel=""
	$Fecha_contenido=GUICtrlRead($InputFecha_contenido)
	$anioFC=StringTrimLeft($Fecha_contenido, 6);2012
	$mesFC=StringTrimLeft($Fecha_contenido, 3);12/2012
	$mesFC=StringTrimRight($mesFC, 5);12
	$diaFC=StringTrimRight($Fecha_contenido, 8);31
	$Fecha_contenido=$anioFC&$mesFC&$diaFC;Se convierte al formato de la norma DICOM 20121231
	$Op=22;Va a Form22 crear DICOM con Pdf
	ExitLoop
Case $Button3; Previsualizar pdf
	ShellExecute($Arch_pdf)
Case $Button2; Cancelar
	$Op=1;Vuelve al menú
	ExitLoop
EndSwitch
WEnd
if $Op=1 Then GUIDelete ($form21)
Call ("Form"&$Op)
EndFunc;Fin función 21
#Region FIN COMENTAR PDF 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
#Region FIN COMENTAR PDF 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
#Region FIN COMENTAR PDF 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
Func Form22()
;GUISetState (@SW_ENABLE, $form1 )
;SplashTextOn ("Creación de Archivo DICOM", "Se está creando el archivo DICOM", 250,100)
$Formaa = GUICreate("", 393, 157, -1, -1)
$Progress1 = GUICtrlCreateProgress(88, 88, 201, 20)
$Label1 = GUICtrlCreateLabel("Se está creando el archivo DICOM", 24, 40, 346, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
GUICtrlSetData ($Progress1,10)
;Crear archivo cfg para el pdf2dcm.bat
;se crea el archivo cfg vacío(,2)en el direcorio temp, si ya existe borra el contenido
$arch_cfg = @TempDir &"\pdf2dcm.cfg";ruta y archivo cfg
$file = FileOpen($arch_cfg, 2)
If $file = -1 Then
    MsgBox(0, "Error 2277", "No se pudo abri "&$arch_cfg&". Chequear instalación")
    Exit
EndIf
;Sector pdf - Tags DICOM - Etiquetas DICOM 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$Nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
;# Issuer of Patient ID 00100021
if $PaV=1 and $Cedula_valida=1 then
FileWriteLine ($file, "00100021:C.I. uruguaya")
endif
;# Patient's Birth Date
;00100030:19580221
FileWriteLine ($file, "00100030:"&$fnac_paciente)
;# Patient's Sex
;00100040:M
FileWriteLine ($file, "00100040:"&$sex_paciente)
;# Patient's Adrees 00101040
FileWriteLine ($file, "00101040:"&$Dir_pa)
;# Patient's Telephone Numbers 00102154
FileWriteLine ($file, "00102154:"&$Tel1_pa&"  "&$Tel2_pa)
;# Comments on Patient 00104000
FileWriteLine ($file, "00104000:"&$Coment_pa); - - - - - - - - - - - - - 

;# StudyID (0020,0010) 
FileWriteLine ($file, "00200010:")
;# (0008,1030) StudyDescription
FileWriteLine ($file, "00081030:"&$Desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
;# ContentDate
FileWriteLine ($file, "00080023:"&$Fecha_contenido); - - - - - - - - - - - - - 

;# Manufacturer
FileWriteLine ($file, "00080070:IMAGOJO 1.00")
;# ReferringPhysiciansName
FileWriteLine ($file, "00080090:"&$MedRef)
;# InstitutionName
FileWriteLine ($file, "00080080:" &$Institucion)
;# StationName
FileWriteLine ($file, "00081010:"&$Estacion)
;# Operator's Name
FileWriteLine ($file, "00081070:"&$usuario)
;# InstitutionalDepartment
FileWriteLine ($file, "00081040:"&$Dpto)
;# SC Equipment Module Attributes # Conversion Type


;# Document Title
FileWriteLine ($file, "00420010:"&$Coment)


FileWriteLine ($file, "00080064:SD")
;# MIME Type of Encapsulated Document 00420012:application/pdf
FileWriteLine ($file, "00420012:application/pdf")
;# SOP Common Module Attributes # SOP Class UID 00080016:1.2.840.10008.5.1.4.1.1.104.1
FileWriteLine ($file, "00080016:1.2.840.10008.5.1.4.1.1.104.1")

FileClose($file)
;Crear imagen DICOM
;ruta y archivo DICOM a crear:
$Nom_Dcm=@YEAR&@MON&@MDAY&@HOUR&@MIN&@SEC
$arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm &".dcm"
;$arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm&$Azar &".dcm"
;$consola_crea_log = @TempDir & "\conversión.log";log de la consola al crear el archivo
GUICtrlSetData ($Progress1,20)
;Se copia el archivo seleccionado con otro nombre mas corto
FileCopy($Ruta_pdf, $dir_trab&"\selecc.pdf",1)
GUICtrlSetData ($Progress1,30)
Sleep (4000)
;Creación del archivo DICOM con la imagen seleccionada
RunWait( @comspec & " /c pdf2dcm -c "&$arch_cfg& " selecc.pdf " & $arch_nuevo_dcm & " > " & @TempDir & "\conversion.log",$dir_trab,@SW_HIDE)
GUICtrlSetData ($Progress1,50)
;Lee el log
$file = FileOpen(@TempDir & "\conversion.log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 2357", "No se pudo abrir conversion.log. Chequear instalación")
    ;Exit
EndIf
; Lee el archivo
$chars = FileRead($file)
FileClose($file)
;Busca la palabra de que el archivo fue creado
$result = StringInStr($chars, "Encapsulated ")
GUICtrlSetData ($Progress1,100)
Sleep (1000)
GUIDelete ()
;SplashOff()
if $result >0 then 
	;SplashTextOn ("Creación de Archivo DICOM", "Se creó el archivo :" &$Nom_Dcm&".dcm")
	;GUIDelete ($form22)
Else
	MsgBox(0, "Resultado:", "El archivo pdf elegido no es compatible o el comentario contiene avances de línea",10)
	GUIDelete ($form21)
	Call ("Form5")
EndIf
FileDelete($Dir_trab&"\selecc.pdf")
;Escribir en el log
$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 2381", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se creó '&$Nom_Dcm&'.dcm a partir de archivo pdf')
				FileClose($file2)
				EndIf
;Fin escritura del log
;invitar a enviar DICOM con la opción a elegir a que servidor quiere mandarla
; o invitar a abrir el archivo con algún Visor DICOM
$respuesta=MsgBox(4, "Archivo creado exitosamente", "Desea enviar al servidor "&$servidor &" el archivo DICOM creado ahora?")
if $respuesta= "7" Then
	GUIDelete ($form21)
	Call ("Form1")
	EndIf
$FormXX=$form21
;EnviarDcm()
Run($Ruta_IMAGOJO&'\Lib\IMAGOJODIR.exe')
GUIDelete ($FormXX)
Call ("Form1")
EndFunc;fin de Func22
#Region Fin Crear PDF 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
#Region Fin Crear PDF 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
#Region Fin Crear PDF 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22

;Form23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23  SELECC MPEG  23 23 23 23 23 23 23 23 23 23 23 23 23 23 23
;Form23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23  SELECC MPEG  23 23 23 23 23 23 23 23 23 23 23 23 23 23 23
;Form23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23  SELECC MPEG  23 23 23 23 23 23 23 23 23 23 23 23 23 23 23
Func Form23()
GUISetState (@SW_DISABLE, $form1 )
$previsual=GUICreate("Archivo Seleccionado",500,500,-1,-1,$WS_SIZEBOX+$WS_SYSMENU)
$message = "Elegir Video para crear archivo DICOM para la historia del paciente"
$var = FileOpenDialog($message, $Dir_video, "Archivos de Video (*.mpg;*.mpeg)", 1 + 4 )
if @error = 1 then 
;		MsgBox(0, "ATENCIÓN", $form1,20)
;	Sleep (5000)
GUIDelete ($form1)
;	MsgBox(0, "ATENCIÓN2", $form1,20)
form1()
EndIf
;Aqui de la ruta y archvio elegido solo se selecciona el nombre del archivo seleccionado
$busca = StringInStr($var, "\",0 , -1)
$Arch_video = StringTrimLeft($var, $busca)
$Dir_video= StringTrimRight($var,(StringLen($var) - $busca)); directroio de los videos

If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_video = $var;ruta completa hasta el archivo
;    MsgBox(4096,"","Archivo elegido =" & $Ruta_video)
 	EndIf
;$Nom_paciente = $Nom_pa &" " & $Ape_pa

form24()
EndFunc;fin Func23
Func Form24()
#Region ### START Koda GUI section ### Form=l:\IMAGOJO\software bajado\programacion\koda 1.7.0.1\forms\fotocomentar.kxf
;$Form24 = GUICreate("Archivo de video para crear DICOM para paciente: "&$Nom_paciente,527, 440, -1, -1, $WS_SIZEBOX + $WS_SYSMENU)
;$Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\MpgImage.jpg", 136, 117, 249, 281)
$nombrevent="Video para crear DICOM para paciente: "&$Ape_pa &', '& $Nom_pa &"  Fecha:"&@MDAY & "/" & @MON & "/" & @YEAR
$Form24 = GUICreate($nombrevent, 801, 474, $X_vent, $Y_vent, $WS_SIZEBOX + $WS_SYSMENU + $WS_MAXIMIZEBOX)
$Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\MpgImage.jpg", 288, 111, 225, 265)
$Label2 = GUICtrlCreateLabel("Descripción del estudio:", 45, 8, 114, 17)
GUICtrlSetTip(-1, "Study Description")
$Input2 = GUICtrlCreateInput($estudioSel, 165, 3, 265, 21)
$Label3 = GUICtrlCreateLabel("Médico  de Referencia:", 460, 6, 113, 17)
GUICtrlSetTip(-1, "Referring Physicians Name")
$Input3 = GUICtrlCreateInput("", 579, 3, 209, 21)
$Label4 = GUICtrlCreateLabel("Comentario sobre el paciente:", 17, 32, 143, 17)
GUICtrlSetTip(-1, "Comments on Patient")
$Input4 = GUICtrlCreateInput("", 165, 27, 265, 21)
$Label1 = GUICtrlCreateLabel("Descripción del video:", 51, 56, 109, 17)
GUICtrlSetTip(-1, "Image Comments")
$Input1 = GUICtrlCreateInput("", 165, 51, 622, 21)
$Button1 = GUICtrlCreateButton("Crear", 710, 80, 75, 25, 0)
$Button3 = GUICtrlCreateButton("Previsualizar", 16, 80, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 16, 408, 75, 25, 0)
$Label5 = GUICtrlCreateLabel("Fecha del contenido:", 471, 29, 101, 17)
GUICtrlSetTip(-1, "Content Date")
; DATE
$InputFecha_contenido=GuiCtrlCreateDate("", 581, 27, 200, 21,$DTS_SHORTDATEFORMAT)

GUISetState ()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	GUIDelete ($form24)
Call ("Form1")
Case $Button1; Crear
	$Coment=GUICtrlRead($Input1)
	$Desc_estud=GUICtrlRead($Input2);"Aqui va la variable con la desc. del estudio"
	$MedRef=GUICtrlRead($Input3)
	$Coment_pa=GUICtrlRead($Input4)
	$estudioSel=""
	$Fecha_contenido=GUICtrlRead($InputFecha_contenido)
	$anioFC=StringTrimLeft($Fecha_contenido, 6);2012
	$mesFC=StringTrimLeft($Fecha_contenido, 3);12/2012
	$mesFC=StringTrimRight($mesFC, 5);12
	$diaFC=StringTrimRight($Fecha_contenido, 8);31
	$Fecha_contenido=$anioFC&$mesFC&$diaFC;Se convierte al formato de la norma DICOM 20121231
	$Op=25;Va a Form25 crear DICOM con Mpg
	ExitLoop
Case $Button2; Cancelar
	GUIDelete ($form24)
	$Op=1;Vuelve al menú
	ExitLoop
Case $Button3; Previsualizar video
	ShellExecute($Arch_video)
	EndSwitch
WEnd
if $Op=1 Then GUIDelete ($form24)
Call ("Form"&$Op)
EndFunc;Fin función 24
#Region FIN COMENTAR MPG 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24
#Region FIN COMENTAR MPG 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24
#Region FIN COMENTAR MPG 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24
Func Form25()
;GUISetState (@SW_ENABLE, $form1 )
;SplashTextOn ("Creación de Archivo DICOM", "Se está creando el archivo DICOM", 250,100)
$Formaa = GUICreate("", 393, 157, -1, -1)
$Progress1 = GUICtrlCreateProgress(88, 88, 201, 20)
$Label1 = GUICtrlCreateLabel("Se está creando el archivo DICOM", 24, 40, 346, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
GUICtrlSetData ($Progress1,10)
;Crear archivo cfg para el JPG2dcm.bat
;se crea el archivo cfg vacío(,2)en el direcorio temp, si ya existe borra el contenido
$arch_cfg = @TempDir &"\mpg2dcm.cfg";ruta y archivo cfg
$file = FileOpen($arch_cfg, 2)
If $file = -1 Then
    MsgBox(0, "Error 2509", "No se pudo abrir "&$arch_cfg&". Chequear instalación")
    Exit
EndIf
;Sector video - Tags DICOM - Etiquetas DICOM 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$Nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
;# Issuer of Patient ID 00100021
if $PaV=1 and $Cedula_valida=1 then
FileWriteLine ($file, "00100021:C.I. uruguaya")
endif
;# Patient's Birth Date
;00100030:19990421
FileWriteLine ($file, "00100030:"&$fnac_paciente)
;# Patient's Sex
;00100040:M
FileWriteLine ($file, "00100040:"&$sex_paciente)
;# Patient's Adrees 00101040
FileWriteLine ($file, "00101040:"&$Dir_pa)
;# Patient's Telephone Numbers 00102154
FileWriteLine ($file, "00102154:"&$Tel1_pa&"  "&$Tel2_pa)
;# Comments on Patient 00104000
FileWriteLine ($file, "00104000:"&$Coment_pa); - - - - - - - - - - - - - 

;# Image Comments
FileWriteLine ($file, "00204000:"&$Coment)
;# StudyID (0020,0010) 
FileWriteLine ($file, "00200010:")
;# (0008,1030) StudyDescription
FileWriteLine ($file, "00081030:"&$Desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
;# ContentDate
FileWriteLine ($file, "00080023:"&$Fecha_contenido); - - - - - - - - - - - - - 
;# Manufacturer
FileWriteLine ($file, "00080070:IMAGOJO 1.00")
;# ReferringPhysiciansName
FileWriteLine ($file, "00080090:"&$MedRef)
;# InstitutionName
FileWriteLine ($file, "00080080:" &$Institucion)
;# StationName
FileWriteLine ($file, "00081010:"&$Estacion)
;# Operator's Name
FileWriteLine ($file, "00081070:"&$usuario)
;# InstitutionalDepartment
FileWriteLine ($file, "00081040:"&$Dpto)
;# SC Equipment Module Attributes # Conversion Type


;# General Series Module Attributes
;# Modality
;00080060:XC
FileWriteLine ($file, "00080060:XC")

;# Series Instance UID
;#0020,000E:

;# Series Number
;00200011:1
FileWriteLine ($file, "00200011:1")


;# General Equipment Module Attributes
;# Manufacturer
FileWriteLine ($file, "00080070:IMAGOJO 1.00")


;# General Image Module Attributes
;# Instance Number
;00200013:1
FileWriteLine ($file, "00200013:1")




;# Cine Module Attributes
;# Frame Time [525-line NTSC] #00181063:33.33
FileWriteLine ($file, "00181063:33.33")
;# Frame Time [625-line PAL] 00181063:40.0
FileWriteLine ($file, "00181063:40.0")
;# Multiplexed Audio Channels Description Code Sequence
;003A0300

;# Multi-frame Module Attributes
;#Number of Frames (use dummy value, if unknown) 00280008:1500
FileWriteLine ($file, "00280008:1500")
;# Frame Increment Pointer 00280009:00181063
FileWriteLine ($file, "00280009:00181063")

;# Image Pixel Module Attributes (MUST be specified for encapsulating MPEG2 streams)
;# (s. DICOM Part 5, 8.2.5 MPEG2 MP@ML IMAGE COMPRESSION for details)
;# Samples per Pixel 00280002:3
FileWriteLine ($file, "00280002:3")

;# Photometric Interpretation 00280004:YBR_PARTIAL_420
FileWriteLine ($file, "00280004:YBR_PARTIAL_420")

;# Planar Configuration 00280006:0
FileWriteLine ($file, "00280006:0")

;# Rows 00280010:480
FileWriteLine ($file, "00280010:288")

;# Columns 00280011:640
FileWriteLine ($file, "00280011:352")

;# Bits Allocated 00280100:8
FileWriteLine ($file, "00280100:8")

;# Bits Stored 00280101:8
FileWriteLine ($file, "00280101:8")

;# High Bit 00280102:7
FileWriteLine ($file, "00280102:7")

;# Pixel Representation 00280103:0
FileWriteLine ($file, "00280103:0")

;# Acquisition Context Module Attributes
;# Acquisition Context Sequence 00400555

;# VL Image Module Attributes
;# Image Type 00080008:ORIGINAL\PRIMARY
FileWriteLine ($file, "00080008:SECONDARY")

;# Lossy Image Compression 00282110:01
FileWriteLine ($file, "00282110:01")

;# SOP Common Module Attributes
;# SOP Class UID 00080016:1.2.840.10008.5.1.4.1.1.77.1.4.1
FileWriteLine ($file, "00080016:1.2.840.10008.5.1.4.1.1.77.1.4.1")

;# SOP Instance UID
;#00080018

FileClose($file)
;Crear video DICOM
;ruta y archivo DICOM a crear:
$Nom_Dcm=@YEAR&@MON&@MDAY&@HOUR&@MIN&@SEC
$Arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm &".dcm"
;$Arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm&$Azar &".dcm"
$consola_crea_log = @TempDir & "\conversión.log";log de la consola al crear el archivo
GUICtrlSetData ($Progress1,20)
;Se copia el archivo seleccionado con otro nombre mas corto
FileCopy($Ruta_video, $Dir_trab&"\selecc.mpg",1)
GUICtrlSetData ($Progress1,30)
Sleep (4000)
GUICtrlSetData ($Progress1,40)
Sleep (6000)
GUICtrlSetData ($Progress1,50)
;Creación del archivo DICOM con la imagen seleccionada
RunWait( @comspec & " /c jpg2dcm --mpeg -C "&$arch_cfg& " "&$Dir_trab&"\selecc.mpg " & $Arch_nuevo_dcm & " > " & @TempDir & "\conversion.log",$Dir_trab,@SW_HIDE)
GUICtrlSetData ($Progress1,60)
;Lee el log
$file = FileOpen(@TempDir & "\conversion.log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 2669", "No se pudo abrir convesion.log. Chequear instalación")
    ;Exit
EndIf
; Lee el archivo
$chars = FileRead($file)
FileClose($file)
;Busca la palabra de que el archivo fue creado
$result = StringInStr($chars, "Encapsulated ")
GUICtrlSetData ($Progress1,100)
Sleep (1000)
GUIDelete ()
;SplashOff()
if $result >0 then 
	;SplashTextOn ("Creación de Archivo DICOM", "Se creó el archivo :" &$Nom_Dcm&".dcm")
	;GUIDelete ($form22)
Else
	MsgBox(0, "Resultado:", "El archivo de video elegido no es compatible o el comentario contiene avances de línea",10)
	GUIDelete ($form24)
	Call ("Form1")
EndIf
FileDelete($Dir_trab&"\"&$Arch_video)
;Escribir en el log
$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 2693", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se creó '&$Nom_Dcm&'.dcm a partir de archivo de video')
				FileClose($file2)
				EndIf
;Fin escritura del log
;invitar a enviar DICOM con la opción a elegir a que servidor quiere mandarla
; o invitar a abrir el archivo con algún Visor DICOM
$respuesta=MsgBox(4, "Archivo creado exitosamente", "Desea enviar al servidor "&$servidor &" el archivo DICOM creado ahora?")
if $respuesta= "7" Then
	GUIDelete ($form24)
	Call ("Form1")
	EndIf
$FormXX=$form24
;EnviarDcm()
Run($Ruta_IMAGOJO&'\Lib\IMAGOJODIR.exe')
GUIDelete ($FormXX)
Call ("Form1")

EndFunc;fin de Func25
#Region Fin Crear VIDEO 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25
#Region Fin Crear VIDEO 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25
#Region Fin Crear VIDEO 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25

;Seleccionar archivo para mandar
Func Form30()
$previsual=GUICreate("Archivo Seleccionado",500,500,-1,-1,$WS_SIZEBOX+$WS_SYSMENU)
$message = "Elegir Archivo DICOM para enviar a "&$Alias1
$var = FileOpenDialog($message, @MyDocumentsDir & "\", "Archivos DICOM (*.dcm)", 1 + 4 )
if @error = 1 then 
;		MsgBox(0, "ATENCIÓN", $form1,20)
;	Sleep (5000)
GUIDelete ($form1)
;	MsgBox(0, "ATENCIÓN2", $form1,20)
form1()
EndIf
;Aqui de la ruta y archvio elegido solo se selecciona el nombre del archivo seleccionado
$busca = StringInStr($var, "\",0 , -1)
$arch_DICOM = StringTrimLeft($var, $busca)

If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_DICOM = StringReplace($var, "|", @CRLF)
   MsgBox(4096,"","Archivo elegido =" & $Ruta_DICOM)
EndIf
;Antes se crea un número al azar de cuatro cifras para que los mombres de los temp no se repitan
$Azar=0
While $Azar<1000
	$Azar=int (Random ()*10000)
WEnd
SplashTextOn ("Enviar archivo al servidor", "Se está enviando el archivo al servidor", 250,100)
;MsgBox(0, "Enviar DICOM", "Enviando Archivo al Servidor :"&$Servidor)
$n=0
$retardo=0
While $n<=$Bucle
if $n<$Bucle then $retardo=$n*$n*1000
	sleep ($retardo)
;MsgBox(0, "Intento "&$n, "retardo de "&$retardo/1000,5)
;OK-->  PARA MANDAR UN ARCHIVO.DCM AL SERVIDOR
RunWait( @comspec & " /c dcmsnd -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor&" "&$Ruta_DICOM & " > " & @TempDir & "\Temp"&$Azar&".log",$Dir_trab,@SW_HIDE)
;RunWait( @comspec & " /c dcmsnd -stgcmt -L "&$AE1&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor&" "&$Ruta_DICOM & " > " & @TempDir & "\Temp"&$Azar&".log",$Dir_trab,@SW_HIDE)
;Lee el log
$file = FileOpen(@TempDir & "\Temp"&$Azar&".log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 2759", "No se pudo abrir log temporal. Chequear instalación")
    Exit
EndIf
; Lee el archivo
$chars = FileRead($file)
FileClose($file)
SplashOff()
;Confirmar que archivo fue enviado
$result = StringInStr($chars, "Sent 1")
if $result >0 then
MsgBox(0, "Resultado:", "El archivo fue enviado correctamente",10)
Sleep (100)
If Not $Debug then FileDelete (@TempDir & "\Temp"&$Azar&".log")
GUIDelete ($form1)
Call ("Form1")
EndIf
;Si no fue enviado incrementa el contador
$n=$n+1
WEnd
;si llegó al final
MsgBox(0, "ReSultado:", "NO PUDO SER ENVIADO","")
$file = FileOpen("NoEnviados.log", 1)
FileWriteLine($file, $Arch_nuevo_dcm)
FileClose($file)
FileDelete (@TempDir & "\Temp"&$Azar&".log")
GUIDelete ($form1)
Call ("Form1")
EndFunc;fin de Func30
#Region Fin Enviar DICOM de Herramientas 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
#Region Fin Enviar DICOM de Herramientas 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
#Region Fin Enviar DICOM de Herramientas 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30

Func Form40()
$Form40 = GUICreate("Acerca de", 393, 334, -1, -1)
GUISetBkColor(0xF9FCFF)
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 377, 265)
;$Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\IMAGOJOIco.gif", 262, 26, 33, 33)
$Image1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\Acercade.gif", 264, 32, 81, 81)
$Label1 = GUICtrlCreateLabel("IMAGOJO", 72, 48, 86, 27, $WS_GROUP)
GUICtrlSetFont(-1, 14, 800, 0, "Corbel")
GUICtrlSetColor(-1, 0x007CC3)
$Label2 = GUICtrlCreateLabel("Version1.00", 160, 53, 60, 17, $WS_GROUP)
$Label4 = GUICtrlCreateLabel("Rodrigo Vlaeminck (rvlaeminck@antel.net.uy)", 96, 208, 219, 17, $WS_GROUP)
$Label3 = GUICtrlCreateLabel("Estudiantes:", 96, 192, 87, 17, $WS_GROUP)
$Label5 = GUICtrlCreateLabel("Alvaro Prieto (aprieto@adinet.com.uy)", 99, 223, 185, 17, $WS_GROUP)
$Label6 = GUICtrlCreateLabel("Proyecto en colaboración del Núcleo de Ingeniería Biomédica", 48, 136, 322, 17)
$Label7 = GUICtrlCreateLabel("y el Dpto. de Oftalmología del Hospital de Clínicas", 78, 149, 251, 17)
$Label8 = GUICtrlCreateLabel("Tutor: Franco Simini", 96, 169, 98, 17)
$Label9 = GUICtrlCreateLabel("2012 Montevideo - Uruguay", 128, 244, 136, 17, $WS_GROUP)
$Label10 = GUICtrlCreateLabel("Captura y gestión de", 79, 75, 111, 18, $WS_GROUP)
GUICtrlSetFont(-1, 9, 800, 0, "Corbel")
$Label11 = GUICtrlCreateLabel("imágenes oftalmológicas", 73, 91, 134, 18, $WS_GROUP)
GUICtrlSetFont(-1, 9, 800, 0, "Corbel")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&OK", 176, 288, 75, 25)
GUISetState(@SW_SHOW)

#cs

#Region ### START Koda GUI section ### Form=C:\IMAGOJO\FormAcercade.kxf
$Form40 = GUICreate("Acerca de", 328, 250, -1, -1)
GUISetBkColor(0xF9FCFF)
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 313, 185)
$Image1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\Acercade.gif", 16, 24, 169, 153)
$Label1 = GUICtrlCreateLabel("IMAGOJO", 192, 24, 57, 17, $WS_GROUP)
$Label2 = GUICtrlCreateLabel("Version1.00", 192, 48, 60, 17, $WS_GROUP)
$Label4 = GUICtrlCreateLabel("rvlaeminck@antel.net.uy", 192, 96, 121, 17, $WS_GROUP)
$Label3 = GUICtrlCreateLabel("Contactos:", 192, 80, 55, 17, $WS_GROUP)
$Pic1 = GUICtrlCreatePic($Ruta_IMAGOJO&"\Lib\Gui\IMAGOJOIco.gif", 262, 26, 33, 33)
$Label5 = GUICtrlCreateLabel("aprieto@adinet.com.uy", 195, 111, 120, 17, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&OK", 128, 208, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
#ce
GUISetState ()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	ExitLoop
Case $Button1
	ExitLoop
EndSwitch
WEnd
GUIDelete ($form40)
;GUIDelete ( "Form1")
;Call ("Form1")
EndFunc;fin de Func40 
#Region Fin ACERCA DE 40 40 40 40 40 40 40 40 40 40 40 40      ACERCA DE       40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
#Region Fin ACERCA DE 40 40 40 40 40 40 40 40 40 40 40 40      ACERCA DE       40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
#Region Fin ACERCA DE 40 40 40 40 40 40 40 40 40 40 40 40      ACERCA DE       40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
Func EnviarDcm()
;Bloque para enviar un archivo DICOM
;MsgBox(0, "$bucle", $Bucle,10)
SplashTextOn ("Enviar archivo al servidor", "Se está enviando el archivo al servidor", 250,100)
;MsgBox(0, "Enviar DICOM", "Enviando Imagen al Servidor :"&$Servidor)
$n=0
$retardo=0
While $n<=$Bucle
if $n<$Bucle then $retardo=$n*$n*1000
	sleep ($retardo)
;MsgBox(0, "Intento "&$n, "retardo de "&$retardo/1000,5)
;OK-->  PARA MANDAR UN ARCHIVO.DCM AL SERVIDOR
RunWait( @comspec & " /c dcmsnd -stgcmt -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor&" "&$Arch_nuevo_dcm & " > " & $Temp_log,$dir_trab,@SW_HIDE)
;Lee el log
$file = FileOpen($Temp_log, 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 2868", "No se pudo abri log temporal. Chequear instalación")
EndIf
; Lee el archivo
$chars = FileRead($file)
FileClose($file)
SplashOff()
;Confirmar que archivo fue enviado
$result = StringInStr($chars, "Sent 1")
if $result >0 then
MsgBox(0, "Resultado:", "El archivo fue enviado correctamente",10)
Sleep (100)
If Not $Debug then FileDelete ($Temp_log)
GUIDelete ($FormXX)
Call ("Form1")
EndIf
;Si no fue enviado incrementa el contador
$n=$n+1
WEnd
;si llegó al final
MsgBox(0, "ReSultado:", "NO PUDO SER ENVIADO, EL archivo se mantendrá en la carpeta NoEnviados y podrá enviarse mas tarde a través de la función Herramientas - Enviar NoEnviados")
$file = FileOpen($Ruta_IMAGOJO&"\NoEnviados.log", 1)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 2891", "Chequear instalación")
    Exit
EndIf
FileWriteLine($file, $Arch_nuevo_dcm)
FileClose($file)
If Not $Debug then FileDelete ($Temp_log)
GUIDelete ($FormXX)
Call ("Form1")
EndFunc ;EnviarDcm()
#Region Fin Bloque Enviar DCM Unificado - - - - - - - - -     Envio DCM unificado   - - - - - - - - - - - - - - - - - - - - - - - -
#Region Fin Bloque Enviar DCM Unificado - - - - - - - - -     Envio DCM unificado   - - - - - - - - - - - - - - - - - - - - - - - -
#Region Fin Bloque Enviar DCM Unificado - - - - - - - - -     Envio DCM unificado   - - - - - - - - - - - - - - - - - - - - - - - -


#Region ### START Koda GUI section ### Form=C:\IMAGOJO\koda 1.7.0.1\Forms\Estudios en papel01.kxf
;- - - - - - - - -Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
;- - - - - - - - -Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
;- - - - - - - - -Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
Func Form50()
$habButton2=0
$Button2=''
$paintEst=''
FileInstall ('C:\IMAGOJOInst\Estudios\Amsler-dcm.jpg', 'C:\IMAGOJO\Estudios\Amsler.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Farnsworth15-dcm.jpg', 'C:\IMAGOJO\Estudios\Farnsworth15.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Farnsworth100-dcm.jpg', 'C:\IMAGOJO\Estudios\Farnsworth100.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Goldman-dcm.jpg', 'C:\IMAGOJO\Estudios\Goldman.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Munsell1-dcm.jpg', 'C:\IMAGOJO\Estudios\Munsell1.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Munsell2-dcm.jpg', 'C:\IMAGOJO\Estudios\Munsell2.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\PantallaTGC-dcm.jpg', 'C:\IMAGOJO\Estudios\PantallaTGC.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Pelli-Robinson-dcm.jpg', 'C:\IMAGOJO\Estudios\Pelli-Robinson.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Amsler-ch.jpg', 'C:\IMAGOJO\Estudios\Amsler-ch.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Farnsworth15-ch.jpg', 'C:\IMAGOJO\Estudios\Farnsworth15-ch.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Farnsworth100-ch.jpg', 'C:\IMAGOJO\Estudios\Farnsworth100-ch.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Goldman-ch.jpg', 'C:\IMAGOJO\Estudios\Goldman-ch.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Munsell1-ch.jpg', 'C:\IMAGOJO\Estudios\Munsell1-ch.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Munsell2-ch.jpg', 'C:\IMAGOJO\Estudios\Munsell2-ch.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\PantallaTGC-ch.jpg', 'C:\IMAGOJO\Estudios\PantallaTGC-ch.jpg', 1)
FileInstall ('C:\IMAGOJOInst\Estudios\Pelli-Robinson-ch.jpg', 'C:\IMAGOJO\Estudios\Pelli-Robinson-ch.jpg', 1)

#Region ### START Koda GUI section ### Form=c:\documents and settings\ap\mis documentos\dropbox\imagojo\koda\forms\menuprincipa05.kxf
$Form50 = GUICreate("IMAGOJO: pulse en las imágenes para seleccionar", 802, 445, $X_vent, $Y_vent)
$Pic1 = GUICtrlCreatePic("C:\Imagojo\Estudios\Amsler-ch.jpg", 32, 26, 150, 150 )
$Pic2 = GUICtrlCreatePic("C:\Imagojo\Estudios\Farnsworth15-ch.jpg", 229, 26, 150, 150 )
$Pic3 = GUICtrlCreatePic("C:\Imagojo\Estudios\Farnsworth100-ch.jpg", 424, 26, 150, 150 )
$Pic4 = GUICtrlCreatePic("C:\Imagojo\Estudios\Goldman-ch.jpg", 620, 26, 150, 150 )
$Pic5 = GUICtrlCreatePic("C:\Imagojo\Estudios\Munsell1-ch.jpg", 35, 218, 150, 150 )
$Pic6 = GUICtrlCreatePic("C:\Imagojo\Estudios\Munsell2-ch.jpg", 229, 218, 150, 150 )
$Pic7 = GUICtrlCreatePic("C:\Imagojo\Estudios\PantallaTGC-ch.jpg", 424, 218, 150, 150 )
$Pic8 = GUICtrlCreatePic("C:\Imagojo\Estudios\Pelli-Robinson-ch.jpg", 620, 218, 150, 150 )
$Label1 = GUICtrlCreateLabel("Amsler", 88, 8, 41, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Farnsworth15", 267, 8, 80, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Farnsworth100", 451, 8, 87, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("Goldman", 662, 8, 53, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label5 = GUICtrlCreateLabel("Munsell1", 82, 200, 54, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label6 = GUICtrlCreateLabel("Munsell2", 276, 200, 54, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label7 = GUICtrlCreateLabel("PantallaTGC", 459, 200, 75, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label8 = GUICtrlCreateLabel("Pelli-Robinson", 657, 200, 85, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Button1 = GUICtrlCreateButton("&Cancelar", 668, 388, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	$PID = ProcessExists("mspaint.EXE")
	If $PID Then ProcessClose($PID)
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_ventE=$size[0]
	$Y_ventE=$size[1]
	Else
	$X_ventE=-1
	$Y_ventE=-1
	EndIf
	GUIDelete ($form50)
	Call ("Form1")
Case $Button1; Cancelar
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_ventE=$size[0]
	$Y_ventE=$size[1]
	Else
	$X_ventE=-1
	$Y_ventE=-1
	EndIf
	$PID = ProcessExists("mspaint.EXE")
	If $PID Then ProcessClose($PID)
	GUIDelete ($form50)
	Call ("Form1")
Case $Pic1; Amsler
	$paintEst="Amsler - Paint"
	If WinExists($PaintEst) Then
	WinActivate($PaintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\Amsler.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\Amsler.jpg"' )
	;Run ( "''''mspaint.EXE "&""""&$Ruta_jpg&""""&'''' )	
	GUIDelete ($form50)
	Call ("Form51")
	EndIf
Case $Pic2; Farnsworth15
	$paintEst="Farnsworth15 - Paint"
	If WinExists($PaintEst) Then
	WinActivate($PaintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\Farnsworth15.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\Farnsworth15.jpg"' )
	GUIDelete ($form50)
	Call ("Form51")
	EndIf
Case $Pic3; Farnsworth100
	$paintEst="Farnsworth100 - Paint"
	If WinExists($paintEst) Then
	WinActivate($paintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\Farnsworth100.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\Farnsworth100.jpg"' )
	GUIDelete ($form50)
	Call ("Form51")
	EndIf
Case $Pic4; Perimetría Goldman
	$paintEst="Goldman - Paint"
	If WinExists($paintEst) Then
	WinActivate($paintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\Goldman.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\Goldman.jpg"' )
	GUIDelete ($form50)
	Call ("Form51")
	EndIf
Case $Pic5; Munsell separación
	$paintEst="Munsell1 - Paint"
	If WinExists($paintEst) Then
	WinActivate($paintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\Munsell1.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\Munsell1.jpg"' )
	GUIDelete ($form50)
	Call ("Form51")
	EndIf
Case $Pic6; Munsell clasificación
	$paintEst="Munsell2 - Paint"
	If WinExists($paintEst) Then
	WinActivate($paintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\Munsell2.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\Munsell2.jpg"' )
	GUIDelete ($form50)
	Call ("Form51")
	EndIf
Case $Pic7; Campo visual 2 ojos PantallaTGC
	$paintEst="PantallaTGC - Paint"
	If WinExists($paintEst) Then
	WinActivate($paintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\PantallaTGC.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\PantallaTGC.jpg"' )
	GUIDelete ($form50)
	Call ("Form51")
	EndIf
Case $Pic8; Sensibilidad de constraste Pelli-Robinson
	$paintEst="Pelli-Robinson - Paint"
	If WinExists($paintEst) Then
	WinActivate($paintEst, "")
	Else
	$Ruta_jpg = 'C:\IMAGOJO\Estudios\Pelli-Robinson.jpg'
	Run ( 'mspaint.EXE "C:\IMAGOJO\Estudios\Pelli-Robinson.jpg"' )
	GUIDelete ($form50)
	Call ("Form51")
	EndIf


EndSwitch
WEnd
EndFunc;fin fun50

Func Form51 ()
	$Form51 = GUICreate("IMAGOJO:", 205, 85, $X_ventE, $Y_ventE, -1, $WS_EX_TOPMOST)
	$Button2 = GUICtrlCreateButton("Crear", 128, 48, 58, 25, 0)
	$Button3 = GUICtrlCreateButton("Cancelar", 16, 48, 57, 25, 0)
	$Button4 = GUICtrlCreateButton("N", 158, 16, 17, 17, 0)
	$Button5 = GUICtrlCreateButton("Id", 175, 16, 17, 17, 0)
	$Label2 = GUICtrlCreateLabel("Paciente:", 8, 0, 49, 17)
	$Label3 = GUICtrlCreateLabel( $Ape_pa&", "&$Nom_pa, 8, 16, 122, 17)
	GUICtrlSetFont(-1, 11, 800, 0, "Arial")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	

		
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
		$PID = ProcessExists("mspaint.EXE")
		If $PID Then ProcessClose($PID)
		If $PosVent=1 then
		$size = WinGetPos("IMAGOJO:")
		$X_ventE=$size[0]
		$Y_ventE=$size[1]
		Else
		$X_ventE=-1
		$Y_ventE=-1
		EndIf
		GUIDelete ($form51)
		Call ("Form1")
Case $Button2; Crear DICOM
		If $PosVent=1 then
		$size = WinGetPos("IMAGOJO:")
		$X_ventE=$size[0]
		$Y_ventE=$size[1]
		Else
		$X_ventE=-1
		$Y_ventE=-1
		EndIf
		$PID0 = ProcessExists("mspaint.EXE")
		;If $PID0=0 Then MsgBox(0, "Atención", "Debe Transcribir Estudio primero",10)
		If $PID0 Then
			GUIDelete ($form51)
			;SplashTextOn("Guardar archivo", "Guardando archivo", 285, 150, -1, -1)
			WinClose($paintEst)
			WinActivate("Paint")
			$aparecio=WinWaitActive("Paint",'' ,2)
			;MsgBox(4096, "Guardar archivo", "Guardando archivo",5)
			;Sleep (2500)
			if $aparecio Then 
				Send ("{Enter}")
			EndIf
			SplashTextOn("Guardar archivo", "Archivo guardado", 285, 150, -1, -1)
			Sleep (500)
			SplashOff ()
			form5()
;			Call ("Form1")

		EndIf

Case $Button4
	ClipPut($Ape_pa&', '&$Nom_pa);Coloca el nombre del paciente en el portapapeles
	SplashTextOn ("","Se copió Nombre del Paciente al portapapeles",250,100)
	Sleep (1500)
	SplashOff()
Case $Button5
	ClipPut($Ced_pa);Coloca el id de paciente en el portapapeles
	SplashTextOn ("","Se copió ID Paciente al portapapeles", 250,100)
	Sleep (1500)
	SplashOff()

Case $Button3; Cancelar
	$estudioSel=""
	If $PosVent=1 then
	$size = WinGetPos("IMAGOJO:")
	$X_ventE=$size[0]
	$Y_ventE=$size[1]
	Else
	$X_ventE=-1
	$Y_ventE=-1
	EndIf
	$PID = ProcessExists("mspaint.EXE")
	If $PID Then ProcessClose($PID)
	GUIDelete ($form51)
	Call ("Form1")
EndSwitch
WEnd
EndFunc



#Region Fin Bloque Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
#Region Fin Bloque Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
#Region Fin Bloque Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
#Region ### START Koda GUI section ### Form=C:\IMAGOJO\koda 1.7.0.1\Forms\Estudios en papel01.kxf