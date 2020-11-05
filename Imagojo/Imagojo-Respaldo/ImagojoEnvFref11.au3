; Proyecto de fin de carrera: Imagojo
; Programa ImagojoEnv con fecha de referencia
; AutoIt 3.3.61
; Creado :12/05/11   Modificado: 10/07/11 
; Autores: Rodrigo Vlaeminck y Alvaro Prieto
;*********************************
;MsgBox(0, "Prueba", "Mensaje",10)
;SplashTextOn ("ImagojoEnv", "Iniciando Aplicación", 250,100)
#include <Date.au3>
#include <IE.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode", 2)

;Declaración de Variables
Global $ced_pa = "", $Nom_pa = "",$Ape_pa = "", $DiaN_pa = "", $MesN_pa = "", $AniN_pa = "", $sex_paciente=" ", $Dir_pa = "", $Tel1_pa = "", $Tel2_pa = ""
Global $ced, $nom, $Ape, $DiaN, $Dir, $Tel1, $Tel2, $MesN, $AniN, $DiaN
Global $EstadoServ = "Inactivo", $IpPuertoServidor, $Arch_nuevo_dcm, $Azar, $Dir_jpg= @MyDocumentsDir, $form1, $form2, $form3, $form4, $form5
Global $ALIAS2, $AE2, $IP2, $PUERTO2, $ALIAS1, $AE1, $IP1, $PUERTO1, $OPSAL=1, $Debug=1
Global $X_vent=-1, $Y_vent=-1, $escala=1, $var, $coment, $desc_estud, $Ruta_jpg, $arch_jpg, $arch_pdf, $Ruta_pdf
Global $form7, $form8, $form9, $form10, $form11, $form20, $form21, $form22, $nom_paciente, $arch_video
Global $Ruta_video, $form23, $form24, $form25, $BorrarEnv, $Dir_trab, $Temp_log, $FRef

;LECTURA DEL ARCHIVO DE CONFIGURACIÓN Imagojo.ini
$ALIAS1=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "Alias1", 'xxCharrua')
$AE1=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "AE1", 'xxCHARRUAPACS')
$IP1=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "IP1", 'xxlocalhost')
$PUERTO1=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "PUERTO1", 'xx11112')
$ALIAS2=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "Alias2", 'xxESTACIONX')
$AE2=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "AE2", 'xxESTACIONX')
$IP2=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "IP2", 'xxlocalhost')
$PUERTO2=IniRead("C:\Imagojo\Imagojo.ini", "Servidores", "PUERTO2", 'xx11113')

$Servidor = $ALIAS1
$IpPuertoServidor = $IP1&':'&$PUERTO1

$Bucle=IniRead("C:\Imagojo\Imagojo.ini", "EnvioDicom", "Reintentos", '4')
$BorrarEnv=IniRead("C:\Imagojo\Imagojo.ini", "EnvioDicom", "BorrarEnviados", '0')
$visorweb=IniRead("C:\Imagojo\Imagojo.ini", "Navegador", "Visorweb", 'C:\Imagojo\GoogleChromePortable\GoogleChromePortable.exe')
$Estacion=IniRead("C:\Imagojo\Imagojo.ini", "Estación", "Estación", 'Workstation')
$visor=IniRead("C:\Imagojo\Imagojo.ini", "Directorios", "Ruta_Visor", 'C:\Archivos de programa\synedra\ViewPersonal\synedraViewPersonal.exe')
$Ocultar=IniRead("C:\Imagojo\Imagojo.ini", "EnvioDicom", "Ocultar", '0')

;$Servidor = "Imagojo"
;$IpPuertoServidor = "192.168.1.101:1112"
;directorio de trabajo de Dcm4che
$Dir_trab=IniRead("C:\Imagojo\Imagojo.ini", "Java", "Dcm4che_bin", 'C:\Imagojo\dcm4\bin\')
$Ruta_Imagojo=IniRead("C:\Imagojo\Imagojo.ini", "Directorios", "Ruta_Imagojo", 'C:\Imagojo')
;ruta de archivos dicom locales que se crearán
$Ruta_Dcm= IniRead("C:\Imagojo\Imagojo.ini", "Directorios", "Ruta_DcmF", 'C:\Imagojo\Dcm')
;YYYYMMDDHHMMSS
;IniWrite($Ruta_Imagojo&"\Imagojo.ini", "ImagojoEnvFref", "FRef", '20110720000000')
;IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Directorios", "Ruta_DcmF", 'C:\Imagojo\NoEnviados')

$FRef=IniRead($Ruta_Imagojo&"\Imagojo.ini", "Fechas", "FRef", '20110720000000')
;$FRef=IniRead($Ruta_Imagojo&"\Imagojo.ini", "ImagojoEnvFref", "FRef", '20110720000000')

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
	MsgBox(0, "ImagojoEnv", "No hay archivos Dicom en la carpeta",5)
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
		MsgBox(0, "ImagojoEnv", "No hay archivos nuevos para enviar",5)
    Exit
EndIf
;MsgBox(0, $t, $FRef)

$Formaa = GUICreate("", 258, 131, -1, -1, $WS_BORDER)
$Progress1 = GUICtrlCreateProgress(48, 56, 153, 20)
$Label1 = GUICtrlCreateLabel("Verificando conexión con el Servidor", 24, 24, 213, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
If $Ocultar=0 Then GUISetState(@SW_SHOW)
GUICtrlSetData ($Progress1,10)
Sleep (150)
GUICtrlSetData ($Progress1,20)
;Se hace un EchoDicom al empezar
FileChangeDir($dir_trab)
	FileDelete(@TempDir & "\ECO.log")
	GUICtrlSetData ($Progress1,30)
	RunWait( @comspec & " /c dcmecho "&$AE1&"@"&$IpPuertoServidor & " > " & @TempDir & "\ECO.log",$dir_trab,@SW_HIDE)
	$file = FileOpen(@TempDir & "\ECO.log", 0)
	If $file = -1 Then
    MsgBox(0, "Error 200", "Chequear instalación")
	Exit
	EndIf
	GUICtrlSetData ($Progress1,90)
	$chars = FileRead($file)
	$result = StringInStr($chars, "verification")
	if $result >0 then $EstadoServ = "Activo"
	if $result <=0 then $EstadoServ = "Inactivo"
	FileClose($file)
;Fin Echo dicom
	GUICtrlSetData ($Progress1,100)
Sleep (1000)
GUIDelete ()
;SplashOff()
If $result <=0 Then
    MsgBox(0, "ImagojoEnv: carpeta "&$Ruta_Dcm, "Hay "&$K &" archivos para mandar, pero el servidor "&$Servidor&" no está"&@CRLF&"disponible, inténtelo mas tarde")
    Exit
EndIf
;$Pregunta=MsgBox(4, "ImagojoEnv", "Hay "&$K &" archivos para mandar, ¿desea hacerlo ahora?")
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
$arch_log = $Ruta_Imagojo&'\Log\'&@YEAR&@MON&@MDAY&'.log';Creación de ruta y archivo log diario
$n=0
;Envio de los archivos de la carpeta
$FormB = GUICreate("Imagojo Envio de Archivo", 393, 157, -1, -1)
$Progress2 = GUICtrlCreateProgress(88, 80, 209, 20)
$Label1 = GUICtrlCreateLabel("Enviando archivo dicom, restan "&($k-$n)&" archivo(s)", 72, 24, 300, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel(" ", 71, 50, 270, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$Cancelar = GUICtrlCreateButton("Cancelar", 296, 112, 73, 25, 0)
GUICtrlSetOnEvent($Cancelar, "Cancelar")
If $Ocultar=0 Then GUISetState(@SW_SHOW)
;BLOQUE DE ENVIO DE ARCHIVOS
$m=0;contador de archivos movidos a NoEnviados
$j=1;índice de la matriz de fechas de archivos
While 1;bloque de envío 
	;Se empieza el ciclo para buscar en orden los archivos en la carpeta
	;Se buscan el o los archivos que coinciden con la fecha
	Local $Archivos[1];inicializa matriz con nombres de archivos
	FileChangeDir($Ruta_Dcm)
	$search = FileFindFirstFile("*.DCM")
	;Se van seleccionado los archivos en la carpeta.
		If $search = -1 Then
		MsgBox(0, "ImagojoEnv", "Fueron movidos los Dicom de la carpeta",5)
		Exit
		EndIf
	$w=0;contador de archivos con la misma fecha
	While 1;se busca en todos los archivos de la carpeta
	$arch = FileFindNextFile($search) 
		If @error Then ExitLoop
	$t =  FileGetTime($arch, 0, 1)
	if $t>$FRef Then
		if $t=$Listafechas[$j] Then
		_ArrayAdd($Archivos, $arch)
		$w=$w+1
		EndIf
	Endif
		
	WEnd
	;_ArrayDisplay($Archivos, "Resulta "&$w)
			;Bloque de envío simple
			For $y=1 to $w
				;Antes se crea un número al azar de cuatro cifras para que los mombres de los temp no se repitan
				$Azar=0
				While $Azar<1000
				$Azar=int (Random ()*10000)
				WEnd
				$Temp_log=@TempDir & "\TempNOenv"&$Azar&".log"
				;SplashTextOn ("Enviar archivo al servidor", "Se está enviando el archivo al servidor", 250,100)
				;MsgBox(0, "Enviar Dicom", "Enviando Imagen al Servidor :"&$Servidor)
				$n=0
				$retardo=0
				While $n<=$Bucle;bucle de envio persitente
				if $n<$Bucle then $retardo=$n*$n*1000
				sleep ($retardo)
				;MsgBox(0, "$y vale "&$y, "archivo ");&$Archivos[$y]
				;OK-->  PARA MANDAR UN ARCHIVO.DCM AL SERVIDOR
				RunWait( @comspec & " /c dcmsnd -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor&" "&$Ruta_dcm&"\"&$Archivos[$y] & " > " & $Temp_log,$dir_trab,@SW_HIDE)
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
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se envió '&$Archivos[$y])
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
				;if $result =0 then 	GUICtrlSetData ($Label1,"Enviando archivo dicom, restan "&($k-$j)&" archivos")
				if $result =0 then 	GUICtrlSetData ($Progress2,($j/($k))*100)
				;if $result =0 then MsgBox(0, "ImagojoEnv:", "El archivo "&$arch&" NO PUDO SER ENVIADO, se mantendrá en la carpeta NoEnviados",12)
				if $result =0 then;escritura en el log
					$file2 = FileOpen($arch_log, 9)
					If $file2 = -1 Then MsgBox(0, "Error 251", "No se pudo abrir el log")
					FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' no se envió '&$Archivos[$y])
					FileClose($file2)
					EndIf
				if $result =0 then GUICtrlSetData ($Label2,$m&" archivo(s) copiado(s) a carpeta NoEnviados")
				GUICtrlSetData ($Label1,"Enviando archivo dicom, restan "&($k-$j)&" archivo(s)")
				GUICtrlSetData ($Progress2,($j/($k))*100)
				If $k=$j then Sleep (850)
				Sleep (150)
				IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Fechas", "FRef", $Listafechas[$j])
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