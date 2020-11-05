; Proyecto de fin de carrera: IMAGOJO
; Programa IMAGOJODIR con fecha de referencia
; AutoIt 3.3.61
; Creado :12/05/11   Modificado: 10/07/11 
; Autores: Rodrigo Vlaeminck y Alvaro Prieto
;*********************************
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#include <Date.au3>
#include <IE.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode",1)
Opt("TrayIconHide", 1)
;Declaración de Variables
Global $Ocultar, $Dir_trab, $Ruta_IMAGOJO, $Ruta_Dcm, $FRef,$ALIAS1, $AE1, $IP1, $PUERTO1, $AE2, $PUERTO2
Global $IpPuertoServidor, $EstadoServ, $Servidor, $Debug, $Temp_log

;LECTURA DEL ARCHIVO DE CONFIGURACIÓN IMAGOJO.ini
$ALIAS1=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Comunicaciones", "Alias1", 'xxCharrua')
$AE1=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Comunicaciones", "AE1", 'xxCHARRUAPACS')
$IP1=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Comunicaciones", "IP1", 'xxlocalhost')
$PUERTO1=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Comunicaciones", "PUERTO1", 'xx11112')
$AE2=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Comunicaciones", "AE2", 'xxESTACIONX')
$PUERTO2=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Comunicaciones", "PUERTO2", 'xx11113')

;$Servidor = "IMAGOJOServ"
$Servidor = $ALIAS1
;$IpPuertoServidor = "192.168.1.100:1112"
$IpPuertoServidor = $IP1&':'&$PUERTO1

$Bucle=IniRead("C:\IMAGOJO\IMAGOJO.ini", "EnvioDicom", "Reintentos", '4')
$Ocultar=IniRead("C:\IMAGOJO\IMAGOJO.ini", "EnvioDicom", "Ocultar", '0')

;directorio de trabajo de Dcm4che
$Dir_trab=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Java", "Dcm4che_bin", 'C:\IMAGOJO\dcm4\bin\')
$Ruta_IMAGOJO=IniRead("C:\IMAGOJO\IMAGOJO.ini", "Directorios", "Ruta_IMAGOJO", 'C:\IMAGOJO')
;Directorio de archivos dicom a enviar
$Ruta_Dcm= IniRead("C:\IMAGOJO\IMAGOJO.ini", "Directorios", "Ruta_Dcm", 'C:\IMAGOJO\Dcm')
;YYYYMMDDHHMMSS
;IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "IMAGOJODIRFref", "FRef", '20110720000000')
;IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Directorios", "Ruta_DcmF", 'C:\IMAGOJO\NoEnviados')

$FRef=IniRead($Ruta_IMAGOJO&"\IMAGOJO.ini", "Fechas", "FRef", '20110720000000')
;$FRef=IniRead($Ruta_IMAGOJO&"\IMAGOJO.ini", "IMAGOJODIRFref", "FRef", '20110720000000')

$file =DirCreate($Ruta_Dcm)
	If $file = -1 Then
    MsgBox(0, "Error 300", "Intenta crear un directorio en"&@CRLF& "dipositivo sin espacio o de solo lectura")
	EndIf
FileChangeDir($Ruta_Dcm)

; Contar la cantidad de archivos Dicom con fecha mayor a la fecha de ref
$search = FileFindFirstFile("*.DCM")  
$K=0
;Chequea si la búsqueda es exitosa
If $search = -1 Then
    ;SplashOff()
	GUIDelete ()
	MsgBox(0, "IMAGOJODIR", "No hay archivos Dicom en la carpeta",5)
    Exit
EndIf
While 1
    $arch = FileFindNextFile($search) 
    If @error Then ExitLoop
;    MsgBox(4096, "$arch:", $arch)
	$t =  FileGetTime($arch, 0, 1)
	if $t>$FRef Then
		$K=$K+1
EndIf
WEnd
;MsgBox(0, $t&"  "&$arch, $FRef)
If $K=0 Then
		MsgBox(0, "IMAGOJODIR", "No hay archivos nuevos para enviar",5)
    Exit
EndIf
;MsgBox(0, $t, $FRef)

$formaa = GUICreate("", 258, 131, -1, -1, $WS_BORDER)
$progress1 = GUICtrlCreateProgress(48, 56, 153, 20)
$label1 = GUICtrlCreateLabel("Verificando conexión con el Servidor", 24, 24, 213, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
If $Ocultar=0 Then GUISetState(@SW_SHOW)
GUICtrlSetData ($progress1,10)
Sleep (150)
GUICtrlSetData ($progress1,20)
;Se hace un EchoDicom al empezar
FileChangeDir($Dir_trab)
	FileDelete(@TempDir & "\ECO.log")
	GUICtrlSetData ($progress1,30)
	RunWait( @comspec & " /c dcmecho "&$AE1&"@"&$IpPuertoServidor & " > " & @TempDir & "\ECO.log",$Dir_trab,@SW_HIDE)
	$file = FileOpen(@TempDir & "\ECO.log", 0)
	If $file = -1 Then
    MsgBox(0, "Error 200", "Chequear instalación")
	Exit
	EndIf
	GUICtrlSetData ($progress1,90)
	$chars = FileRead($file)
	$result = StringInStr($chars, "verification")
	if $result >0 then $EstadoServ = "Activo"
	if $result <=0 then $EstadoServ = "Inactivo"
	FileClose($file)
;Fin Echo dicom
	GUICtrlSetData ($progress1,100)
Sleep (1000)
GUIDelete ()
;SplashOff()
If $result <=0 Then
    MsgBox(0, "IMAGOJODIR: carpeta "&$Ruta_Dcm, "Hay "&$K &" archivos para mandar, pero el servidor "&$Servidor&" no está"&@CRLF&"disponible, inténtelo mas tarde")
    Exit
EndIf
;$Pregunta=MsgBox(4, "IMAGOJODIR", "Hay "&$K &" archivos para mandar, ¿desea hacerlo ahora?")
;If $Pregunta=7 then Exit
Local $Listafechas[1]
FileChangeDir($Ruta_Dcm)
$search = FileFindFirstFile("*.DCM")  
While 1
    $arch = FileFindNextFile($search) 
    If @error Then ExitLoop
;    MsgBox(4096, "$arch:", $arch)
	$t =  FileGetTime($arch, 0, 1)
	if $t>$FRef Then
	_ArrayAdd($Listafechas, $t)
EndIf
WEnd
;_ArrayDisplay($Listafechas, "Antes")
_ArraySort($Listafechas)
;_ArrayDisplay($Listafechas, "Despues")


; Check if the search was successful
;If $search = -1 Then
    ;MsgBox(0, "Error", "No files/directories matched the search pattern")
   ; Exit
;EndIf
$arch_log = $Ruta_IMAGOJO&'\Log\'&@YEAR&@MON&@MDAY&'.log';Creación de ruta y archivo log diario
$n=0
;Envio de los archivos de la carpeta
$formB = GUICreate("IMAGOJO Envio de Archivo", 393, 157, -1, -1)
$progress2 = GUICtrlCreateProgress(88, 80, 209, 20)
;"Enviando DICOM, restan "&($k-$n)&" de "&$k&" archivo(s)"
;"Enviando DICOM,  "&$n&" de "&$k&" archivo(s)"
$label1 = GUICtrlCreateLabel("Enviando DICOM,  1 de "&$k&" archivo(s)", 72, 24, 300, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$label2 = GUICtrlCreateLabel(" ", 71, 50, 270, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$cancelar = GUICtrlCreateButton("Cancelar", 296, 112, 73, 25, 0)
GUICtrlSetOnEvent($cancelar, "Cancelar")
If $Ocultar=0 Then GUISetState(@SW_SHOW)
;BLOQUE DE ENVIO DE ARCHIVOS
$m=0;contador de archivos movidos a NoEnviados
$j=1;índice de la matriz de fechas de archivos
While 1;bloque de envío 
	;Se empieza el ciclo para buscar en orden los archivos en la carpeta
	;Se buscan el o los archivos que coinciden con la fecha
	Local $archivos[1];inicializa matriz con nombres de archivos
	FileChangeDir($Ruta_Dcm)
	$search = FileFindFirstFile("*.DCM")
	;Se van seleccionado los archivos en la carpeta.
		If $search = -1 Then
		MsgBox(0, "IMAGOJODIR", "Fueron movidos los Dicom de la carpeta",5)
		Exit
		EndIf
	$w=0;contador de archivos con la misma fecha
	While 1;se busca en todos los archivos de la carpeta
	$arch = FileFindNextFile($search) 
		If @error Then ExitLoop
	$t =  FileGetTime($arch, 0, 1)
	if $t>$FRef Then
		if $t=$Listafechas[$j] Then
		_ArrayAdd($archivos, $arch)
		$w=$w+1
		EndIf
	Endif
		
	WEnd
	;_ArrayDisplay($archivos, "Resulta "&$w)
			;Bloque de envío simple
			For $y=1 to $w
				;Antes se crea un número al azar de cuatro cifras para que los mombres de los temp no se repitan
				$azar=0
				While $azar<1000
				$azar=int (Random ()*10000)
				WEnd
				$Temp_log=@TempDir & "\TempNOenv"&$azar&".log"
				;SplashTextOn ("Enviar archivo al servidor", "Se está enviando el archivo al servidor", 250,100)
				;MsgBox(0, "Enviar Dicom", "Enviando Imagen al Servidor :"&$Servidor)
				$n=0
				$retardo=0
				While $n<=$Bucle;bucle de envio persitente
				if $n<$Bucle then $retardo=$n*$n*1000
				sleep ($retardo)
				;MsgBox(0, "$y vale "&$y, "archivo ");&$archivos[$y]
				;OK-->  PARA MANDAR UN ARCHIVO.DCM AL SERVIDOR
				RunWait( @comspec & " /c dcmsnd -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor&" "&$Ruta_dcm&"\"&$archivos[$y] & " > " & $Temp_log,$dir_trab,@SW_HIDE)
				;Lee el log
				$file = FileOpen($Temp_log, 0)
				; Check if file opened for reading OK
				If $file = -1 Then
				MsgBox(0, "Error 204", "Chequear instalación")
				EndIf
				; Lee el archivo
				$chars = FileRead($file)
				FileClose($file)		
				;Confirmar que archivo fue enviado
				$result = StringInStr($chars, "Sent 1")
				if $result >0 then
				$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then MsgBox(0, "Error 250", "No se pudo abrir archivo de log")
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se envió '&$archivos[$y])
				FileClose($file2)
				$N=$BUCLE+1
;				FileDelete ($Ruta_dcm&"\"&$arch);En esta función no se borran los archivos

				;GUIDelete ($form1)
				;Call ("Form1")
				EndIf;$result >0
				;Si no fue enviado incrementa el contador
				if $result =0 then $n=$n+1
				WEnd;fin de envio persistente
				;si llegó al final
				if $result =0 then $m=$m+1
				;if $result =0 then 	GUICtrlSetData ($label1,"Enviando archivo dicom, restan "&($k-$j)&" archivos")
				if $result =0 then 	GUICtrlSetData ($progress2,($j/($k))*100)
				;if $result =0 then MsgBox(0, "IMAGOJODIR:", "El archivo "&$arch&" NO PUDO SER ENVIADO, se mantendrá en la carpeta NoEnviados",12)
				if $result =0 then;escritura en el log
					$file2 = FileOpen($arch_log, 9)
					If $file2 = -1 Then MsgBox(0, "Error 251", "No se pudo abrir el log")
					FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' no se envió '&$archivos[$y])
					FileClose($file2)
					EndIf
				if $result =0 then GUICtrlSetData ($label2,$m&" archivo(s) copiado(s) a carpeta NoEnviados")
				if $result =0 then FileCopy($Ruta_dcm&"\"&$archivos[$y], $Ruta_IMAGOJO&"\C:\IMAGOJO\NoEnviados", 8)
					;"Enviando DICOM, restan "&($k-$j)&" de "&$k&" archivo(s)"
					;"Enviando DICOM "&$j&"/"&$k&", restan "&($k-$j)&" archivo(s)"
				;if $k-$j>0 then GUICtrlSetData ($label1,"Enviando DICOM, restan "&($k-$j)&" de "&$k&" archivo(s)")
				GUICtrlSetData ($label1,"Enviando DICOM,  "&$j&" de "&$k&" archivo(s)")
				GUICtrlSetData ($progress2,($j/($k))*100)
				If $k=$j then Sleep (850)
				Sleep (150)
				IniWrite($Ruta_IMAGOJO&"\IMAGOJO.ini", "Fechas", "FRef", $Listafechas[$j])
				If Not $Debug then FileDelete ($Temp_log)
				Next
If $j=$k then ExitLoop
$j=$j+$w

WEnd

Exit
Func Cancelar()
Exit
EndFunc

Func CLOSEClicked()
Exit
EndFunc