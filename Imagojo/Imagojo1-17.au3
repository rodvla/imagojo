; Proyecto de fin de carrera: Imagojo
; Tutor: Franco Simini
; Programa Imagojo
; AutoIt 3.3.61
; Creado :12/11/10   Modificado: 10/12/11 
; Autores: Rodrigo Vlaeminck y Alvaro Prieto
;*********************************
;Tareas que faltan:
;Ver Weasis con navegador

;If WinExists("Imagojo") Then
If ProcessExists("Imagojo.exe") Then
WinActivate("Imagojo", "")
MsgBox(0, "ATENCIÓN", "YA HAY UNA INSTANCIA DE Imagojo EJECUTÁNDOSE",5)
Exit
EndIf
#include <Date.au3>
#include <IE.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>

;MsgBox(0, "Prueba", "Mensaje",10)
Opt("WinTitleMatchMode", 2)

;Declaración de Variables
Global $ced_pa = "", $Nom_pa = "",$Ape_pa = "", $DiaN_pa = "", $MesN_pa = "", $AniN_pa = "", $sex_paciente=" ", $Dir_pa = "", $Tel1_pa = "", $Tel2_pa = ""
Global $ced, $nom, $Ape, $DiaN, $Dir, $Tel1, $Tel2, $MesN, $AniN, $DiaN
Global $EstadoServ = "Inactivo", $IpPuertoServidor, $Arch_nuevo_dcm, $Azar, $Dir_jpg= @MyDocumentsDir, $form1, $form2, $form3, $form4, $form5
Global $ALIAS2, $AE2, $IP2, $PUERTO2, $ALIAS1, $AE1, $IP1, $PUERTO1, $OPSAL=1, $Debug=1
Global $X_vent=-1, $Y_vent=-1, $Escala=1, $var, $coment, $desc_estud, $Ruta_jpg, $arch_jpg, $arch_pdf, $Ruta_pdf
Global $form7, $form8, $form9, $form10, $form11, $form20, $form21, $form22, $nom_paciente, $arch_video
Global $Ruta_video, $form23, $form24, $form25, $BorrarEnv, $Dir_trab, $Temp_log, $FormXX, $X_ventE=790, $Y_ventE=35
Global $Pav=0, $arch_log, $Ocultar, $estudioSel=""

;LECTURA DEL ARCHIVO DE CONFIGURACIÓN Imagojo.ini
$ALIAS1=IniRead("Imagojo.ini", "Servidores", "Alias1", 'xxCharrua')
$AE1=IniRead("Imagojo.ini", "Servidores", "AE1", 'xxCHARRUAPACS')
$IP1=IniRead("Imagojo.ini", "Servidores", "IP1", 'xxlocalhost')
$PUERTO1=IniRead("Imagojo.ini", "Servidores", "PUERTO1", 'xx11112')
$ALIAS2=IniRead("Imagojo.ini", "Servidores", "Alias2", 'xxESTACIONX')
$AE2=IniRead("Imagojo.ini", "Servidores", "AE2", 'xxESTACIONX')
$IP2=IniRead("Imagojo.ini", "Servidores", "IP2", 'xxlocalhost')
$PUERTO2=IniRead("Imagojo.ini", "Servidores", "PUERTO2", 'xx11113')

$Servidor = $ALIAS1
$IpPuertoServidor = $IP1&':'&$PUERTO1

$Bucle=IniRead("Imagojo.ini", "EnvioDicom", "Reintentos", '4')
$BorrarEnv=IniRead("Imagojo.ini", "EnvioDicom", "BorrarEnviados", '1')
$Ocultar=IniRead("C:\Imagojo\Imagojo.ini", "EnvioDicom", "Ocultar", '1')
$visorweb=IniRead("Imagojo.ini", "Navegador", "Visorweb", 'C:\Imagojo\GoogleChromePortable\GoogleChromePortable.exe')
$Estacion=IniRead("Imagojo.ini", "Estación", "Estación", 'Workstation')
$visor=IniRead("Imagojo.ini", "Directorios", "Ruta_Visor", 'C:\Archivos de programa\synedra\ViewPersonal\synedraViewPersonal.exe')

;$Servidor = "Imagojo"
;$IpPuertoServidor = "192.168.1.101:1112"
;directorio de trabajo de Dcm4che
$Dir_trab=IniRead("Imagojo.ini", "Java", "Dcm4che_bin", 'C:\Imagojo\dcm4\bin\')
$Ruta_Imagojo=IniRead("Imagojo.ini", "Directorios", "Ruta_Imagojo", 'C:\Imagojo')
;ruta de archivos dicom locales que se crearán
$Ruta_Dcm= IniRead("Imagojo.ini", "Directorios", "Ruta_Dcm", 'C:\Imagojo\NoEnviados')
$file =DirCreate($Ruta_Dcm)
	If $file = -1 Then
    MsgBox(0, "Error 300", "Intenta crear un directorio en"&@CRLF& "dipositivo sin espacio o de solo lectura")
	EndIf
$arch_log = $Ruta_Imagojo&'\Log\'&@YEAR&@MON&@MDAY&'.log';Creación de ruta y archivo log diario

DirCreate($Ruta_Imagojo&'\Lib\Gui')
DirCreate($Ruta_Imagojo&'\Estudios')
FileInstall ('C:\ImagojoInst\Lib\ImagojoEnv.exe', $Ruta_Imagojo&'\Lib\ImagojoEnv.exe', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\presentacion.jpg', $Ruta_Imagojo&'\Lib\Gui\presentacion.jpg', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\barrita1.jpg', $Ruta_Imagojo&'\Lib\Gui\barrita1.jpg', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\barrita2.jpg', $Ruta_Imagojo&'\Lib\Gui\barrita2.jpg', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\bandacolorV.gif', $Ruta_Imagojo&'\Lib\Gui\bandacolorV.gif', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\bandacolor.gif', $Ruta_Imagojo&'\Lib\Gui\bandacolor.gif', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\mpgImage.jpg', $Ruta_Imagojo&'\Lib\Gui\mpgImage.jpg', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\pdfImage.jpg', $Ruta_Imagojo&'\Lib\Gui\pdfImage.jpg', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\acercade.gif', $Ruta_Imagojo&'\Lib\Gui\acercade.gif', 1)
FileInstall ('C:\ImagojoInst\Lib\Gui\imagojoIco.gif', $Ruta_Imagojo&'\Lib\Gui\imagojoIco.gif', 1)
;IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "Ocultar", '1')
;variables de configuración del .ini
#CS
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "Reintentos", '4')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "Ocultar", '1')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "BorrarEnviados", '0')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Directorios", "Ruta_Dcm", 'C:\Imagojo\Local\Dcm')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "Alias1", 'Charrua')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "AE1", 'CHARRUAPACS')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "IP1", 'localhost')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "PUERTO1", '11112')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "Alias2", 'SYNEDRA')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "AE2", 'CHARRUAPACS')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "IP2", 'localhost')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "PUERTO2", '11317')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "Servidor", 'Charrua')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "SNIFFER", '11317')

IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "IpPuertoServidor", '192.168.1.101:1112')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Navegador", "Visorweb", 'C:\Imagojo\GoogleChromePortable\GoogleChromePortable.exe')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Java", "Dcm4che_bin", 'C:\Imagojo\dcm4\bin\')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Directorios", "Ruta_Imagojo", 'C:\Imagojo')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Estación", "Estación", 'Workstation')
IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Directorios", "Ruta_Visor", 'C:\Archivos de programa\synedra\ViewPersonal\synedraViewPersonal.exe')

#CE

$Nom_Dcm="Im"
;variables prog principal
$usuario = ""
$contrasenia = ""

$ced_paciente = ""
$nom_paciente = ""
$fnac_paciente = ""
$sex_paciente = ""


;#cs
;Se hace un EchoDicom al empezar
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
;Fin Echo dicom
#ce
;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PRESENTACIÓN Y LOGUEO 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PRESENTACIÓN Y LOGUEO 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PRESENTACIÓN Y LOGUEO 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
$usuario=''
$contrasenia=''
Form0()
Func Form0 ()
#Region ### START Koda GUI section ### Form=C:\Imagojo\koda 1.7.0.1\Forms\Inicio-de-sesion2.kxf
$Form0 = GUICreate("Imagojo - Inicio de sesión", 730, 440, $X_vent, $Y_vent)
GUISetBkColor(0xF9FCFF)
$Pic1 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\presentacion.jpg", 0, 0, 726, 243)
$Input1 = GUICtrlCreateInput($usuario, 232, 288, 193, 21)
$Input2 = GUICtrlCreateInput($contrasenia, 232, 326, 193, 21, $ES_PASSWORD )
$Label1 = GUICtrlCreateLabel("Usuario", 176, 288, 52, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Label2 = GUICtrlCreateLabel("Contraseña", 151, 328, 76, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Button1 = GUICtrlCreateButton("Aceptar", 56, 384, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 597, 376, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
#cs
$Form0 = GUICreate("Bienvenidos a Imagojo", 625, 443, -1)
$continuar = GUICtrlCreateButton("continuar", 464, 336, 75, 25, 0)

$Imagojo = GUICtrlCreateLabel("Imagojo", 232, 112, 176, 52)
GUICtrlSetFont(-1, 28, 400, 0, "MS Sans Serif")
$Imagojo = GUICtrlCreateLabel("Sistema de Captura y Gestión de Imágenes Médicas", 100, 200, 300, 300)
GUICtrlSetFont(-1, 28, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#ce
;habilito chequear usuario y contraseña
$hab=0
$usu=0
While 1
   Switch GUIGetMsg()
   Case $Button1;Aceptar
		$usuario = GUICtrlRead($Input1)
		$contrasenia = GUICtrlRead($Input2)	
;	While $hab
		if $hab=0 Then
			$usuario="Administrador"
			$op=1
			exitloop
		EndIf
		
		if $hab and $usuario = "Alvaro" then
		$usu=1
		ElseIf $hab and $usuario = "Rodrigo" then
		$usu=1
		Else
		MsgBox( 4096, "ATENCIÓN", "Usuario  No registrado")
		$op=0
		exitloop
		EndIf
;	WEnd
	;Chequeo de Contraseña
;	while $hab
;	$contrasenia = InputBox("Chequeo de Seguridad", "Usuario: "&$usuario& @lf &"Ingrese su Contraseña", "", "*")
;	if @error = 1 then Exit
		if $usu=1 and $contrasenia = "valida" then
		$op=1
		ExitLoop
		Else
		MsgBox( 4096, "ATENCIÓN", "Contraseña inválida")
		$op=0
		exitloop
		Endif
;	WEnd	

	Case $GUI_EVENT_CLOSE
         Exit
   Case $Button2;Cancelar
	Exit
ExitLoop
EndSwitch
WEnd
GUIDelete ($form0)
Call ("Form"&$op)


EndFunc

;Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 PRINCIPAL 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
;Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 PRINCIPAL 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
;Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 PRINCIPAL 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
Func Form1 ()
#Region ### START Koda GUI section ### Form=h:\Imagojo\software bajado\programacion\koda 1.7.0.1\forms\menuprincipa01.kxf
$Form1= GUICreate("Imagojo Principal", 801, 451, $X_vent, $Y_vent)
If $EstadoServ = "Activo" Then $Pic1 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\bandacolorV.gif", 0, 0, 801, 40)
If $EstadoServ = "Inactivo" Then $Pic1 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\bandacolor.gif", 0, 0, 801, 40)
;$Pic2 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\barrita1.jpg", 0, 335, 801,110)
;GuiCtrlSetState(-1,$GUI_DISABLE) 
;GUISetBkColor(0xA4D0E6)
GUISetBkColor(0xF9FCFF)
$Button1 = GUICtrlCreateButton("&Paciente", 550, 80, 99, 25, 0)
$Button2 = GUICtrlCreateButton("&Captura", 549, 129, 99, 25, 0)
$Button3 = GUICtrlCreateButton("&Crear Dicom", 549, 177, 99, 25, 0)
$Button4 = GUICtrlCreateButton("&Visor Editor", 549, 227, 100, 25, 0)
$Button5 = GUICtrlCreateButton("&Visualizador Web", 549, 276, 99, 25, 0)
$Label1 = GUICtrlCreateLabel("Sesión: "&$usuario, 112, 380, 140, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Servidor: "&$Servidor, 597, 356, 164, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Button6 = GUICtrlCreateButton("Cerrar Sesión", 32, 376, 75, 25, 0)
$Label3 = GUICtrlCreateLabel("Estado: "&$EstadoServ, 597, 380, 99, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$MenuItem1 = GUICtrlCreateMenu("&Configuración")
$MenuItem8 = GUICtrlCreateMenuItem("Servidores", $MenuItem1)

$MenuItem2 = GUICtrlCreateMenu("Opciones")
$MenuItem5 = GUICtrlCreateMenuItem("Ocultar dialogos al enviar", $MenuItem2)
If $Ocultar=1 then GUICtrlSetState(-1, $GUI_CHECKED)
If $Ocultar=0 then GUICtrlSetState(-1, $GUI_UNCHECKED)
$MenuItem6 = GUICtrlCreateMenuItem("Borrar archivos enviados", $MenuItem2)
If $BorrarEnv=1 then GUICtrlSetState(-1, $GUI_CHECKED)
If $BorrarEnv=0 then GUICtrlSetState(-1, $GUI_UNCHECKED)
$MenuItem9 = GUICtrlCreateMenu("Herramientas")
$MenuItem10 = GUICtrlCreateMenuItem("Enviar un archivo Dicom", $MenuItem9)
$MenuItem12 = GUICtrlCreateMenuItem("Ver carpeta de Archivos Log", $MenuItem9)
$MenuItem13 = GUICtrlCreateMenuItem("Explorar carpeta NoEnviados", $MenuItem9)
$MenuItem11 = GUICtrlCreateMenuItem("Explorar carpeta Temporal", $MenuItem9)
$MenuItem4 = GUICtrlCreateMenu("&Ayuda")
$MenuItem3 = GUICtrlCreateMenuItem("Acerca de", $MenuItem4)
	If $Ced_pa Then
	$Label4 = GUICtrlCreateLabel("Paciente: ", 86, 200, 69, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label5 = GUICtrlCreateLabel($Ape_pa&", "&$Nom_pa, 153, 201, 273, 22)
	GUICtrlSetFont(-1, 11, 800, 0, "Arial")
	$Label6 = GUICtrlCreateLabel("Estación : "&$Estacion, 86, 152, 154, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label7 = GUICtrlCreateLabel("ID Paciente:", 86, 233, 83, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label8 = GUICtrlCreateLabel("Fecha : "&@MDAY & "/" & @MON & "/" & @YEAR, 86, 123, 129, 21)
	GUICtrlSetFont(-1, 11, 400, 0, "Arial")
	$Label9 = GUICtrlCreateLabel($ced_pa, 173, 232, 273, 22)
	GUICtrlSetFont(-1, 11, 800, 0, "Arial")
	$Group1 = GUICtrlCreateGroup(" ", 56, 96, 417, 185)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	EndIf
	
	If $EstadoServ = "Activo" then 
	GuiCtrlCreateLabel(" ", 689, 385, 10, 7)
	GuiCtrlSetBkColor(-1, 0x00FF00)
	EndIf
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$borr=1
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $Button3;Crear Dicom
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$op=8
	ExitLoop
Case $Button4;Visualizador Editor synedra View Personal
	;$op=1
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	If ProcessExists("synedraViewPersonal.exe") Then 
		WinActivate("synedra", "")
	else
		SplashTextOn ("Abrir Visor Editor", "Abriendo", 250,100)
		Run ($visor, @WindowsDir, @SW_MAXIMIZE)
		Sleep (1000)
		If ProcessExists("synedraViewPersonal.exe") Then SplashTextOn ("Abrir Visor Editor", "Se incició proceso", 250,100)
		Sleep (1000)
		SplashOff ()
	EndIf

Case $Button5;Visualizador Web
$size = WinGetPos("Imagojo")
$X_vent=$size[0]
$Y_vent=$size[1]
	;$op=1
	If ProcessExists("FirefoxPortable.exe") Then 
		WinActivate("Mozilla", "")
	ElseIf ProcessExists("GoogleChromePortable.exe") Then
				WinActivate("Google Chrome", "")
	else
		Run ($visorweb, @WindowsDir, @SW_MAXIMIZE)
	EndIf
Case $Button1;Paciente
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$op=2
	$opsal=1
	ExitLoop

Case $Button6;Cerrar Sesión
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$op=0
	$usuario=''
	$contrasenia=''
	$borrar=1
	ExitLoop
Case $Button2;Captura
	
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
		If $ced_pa Then
			$borr=0
			$op=7
		Else 
			$OPSAL=7
			$op=2
		Endif
	ExitLoop
	;MsgBox(0, "ATENCIÓN", $form1,10)
Case $GUI_EVENT_CLOSE
	Exit
Case $MenuItem8;Serviores
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	Call ("Form6")
#cs
Case $MenuItem12; Enviar NoEnviados
	$oculOrig=IniRead("C:\Imagojo\Imagojo.ini", "EnvioDicom", "Ocultar", '1')
	;Sleep (100)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "Ocultar", '0')
	;Sleep (100)
	RunWait($Ruta_Imagojo&'\Lib\ImagojoEnv.exe')
	;Sleep (2000)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "Ocultar", $oculOrig)
#ce

Case $MenuItem12; Ver Carpeta de archivos Log
	;$arch_log = $Ruta_Imagojo&'\Log\'&@YEAR&@MON&@MDAY&'.log';Creación de ruta y archivo log diario
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]

	$path=$Ruta_Imagojo&"\Log\"
	Run("C:\WINDOWS\EXPLORER.EXE /n,/e," & $path)

Case $MenuItem11; Explorar Carpeta Temporal de Windows
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$path=@TempDir
	Run("C:\WINDOWS\EXPLORER.EXE /n,/e," & $path)
	
Case $MenuItem10;Enviar un Dicom
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$op=30
	$opsal=1
	ExitLoop
	
Case $MenuItem13; Explorar Carpeta NoEnviados
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]

	$path=$Ruta_Imagojo&"\NoEnviados"
	Run("C:\WINDOWS\EXPLORER.EXE /n,/e," & $path)

	
Case $MenuItem3;Acerca de
	Call ("Form40")
	
Case $MenuItem5;Ocultar dialogos al enviar

			If BitAND(GUICtrlRead($MenuItem5), $GUI_CHECKED) = $GUI_CHECKED Then
                GUICtrlSetState($MenuItem5, $GUI_UNCHECKED)
				$Ocultar=0
                IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "Ocultar", '0')
            Else
                GUICtrlSetState($MenuItem5, $GUI_CHECKED)
                GUICtrlSetState($MenuItem5, $GUI_SHOW)
                IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "Ocultar", '1')
				$Ocultar=1
            EndIf

Case $MenuItem6;Borrar Enviados

			If BitAND(GUICtrlRead($MenuItem6), $GUI_CHECKED) = $GUI_CHECKED Then
                GUICtrlSetState($MenuItem6, $GUI_UNCHECKED)
                IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "BorrarEnviados", '0')
            Else
                GUICtrlSetState($MenuItem6, $GUI_CHECKED)
                GUICtrlSetState($MenuItem6, $GUI_SHOW)
                IniWrite($Ruta_Imagojo&"\Imagojo.ini", "EnvioDicom", "BorrarEnviados", '1')
            EndIf

EndSwitch
WEnd
If $borr=1 Then GUIDelete ( "Form1")
Call ("Form"&$op)
	EndFunc
#Region Fin Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#Region Fin Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#Region Fin Menú Principal 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1

;Función Paciente 2 2 2 2  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
;Función Paciente 2 2 2 2  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
;Función Paciente 2 2 2 2  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
Func Form2 ()
$noingresa=1
#Region ### START Koda GUI section ### Form=h:\imagojo\software bajado\programacion\koda 1.7.0.1\forms\paciente01.kxf
$Form2 = GUICreate("Imagojo: Paciente", 801, 451, $X_vent, $Y_vent)
GUISetBkColor(0xF9FCFF)
$Paciente = GUICtrlCreateLabel("Paciente", 96, 16, 77, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$ced = GUICtrlCreateInput($Ced_pa, 248, 56, 153, 21)
$Nom = GUICtrlCreateInput($Nom_pa, 248, 93, 425, 21)
$Ape = GUICtrlCreateInput($Ape_pa, 248, 129, 425, 21)
$Sexo = GUICtrlCreateCombo($sex_paciente, 200, 164, 41, 25)
GUICtrlSetData(-1, "F|M|O", $sex_paciente) 
$DiaN = GUICtrlCreateInput($DiaN_pa, 344, 203, 49, 21)
$updown1 = GuiCtrlCreateUpDown(-1)
GUICtrlSetLimit($updown1,31,1)
$MesN = GUICtrlCreateInput($MesN_pa, 416, 203, 49, 21)
$updown2 = GuiCtrlCreateUpDown(-1)
GUICtrlSetLimit($updown2,12,1)
$AniN = GUICtrlCreateInput($AniN_pa, 488, 203, 49, 21)
$updown3 = GuiCtrlCreateUpDown(-1)
GUICtrlSetLimit($updown3,2020,1900)

$Dir = GUICtrlCreateInput($Dir_pa, 240, 257, 425, 21)
$Tel1 = GUICtrlCreateInput($Tel1_pa, 240, 292, 201, 21)
$OK = GUICtrlCreateButton("OK", 632, 384, 75, 25, 0)
$Cedula = GUICtrlCreateLabel("ID Paciente", 142, 56, 99, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000080)
$Nombre = GUICtrlCreateLabel("Nombre(s)", 142, 91, 94, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$Apellidos = GUICtrlCreateLabel("Apellido(s)", 142, 127, 94, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$SexoL = GUICtrlCreateLabel("Sexo", 142, 163, 48, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")

GUICtrlCreateLabel("Fecha de Nacimiento", 142, 203, 185, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$Borrar = GUICtrlCreateButton("Consultar", 592, 52, 75, 25, 0)

$Label1 = GUICtrlCreateLabel("dia", 360, 232, 18, 17)
$Label4 = GUICtrlCreateLabel("mes", 432, 232, 23, 17)
$Label5 = GUICtrlCreateLabel("año", 504, 232, 22, 17)
$Label6 = GUICtrlCreateLabel("Teléfono1", 142, 291, 89, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Teléfono2", 142, 328, 89, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$Label7 = GUICtrlCreateLabel("Dirección", 142, 257, 84, 28)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$Tel2 = GUICtrlCreateInput($Tel2_pa, 240, 329, 201, 21)
$Label2 = GUICtrlCreateLabel("*", 128, 64, 8, 17)
$Label8 = GUICtrlCreateLabel("*", 127, 98, 8, 17)
$Label9 = GUICtrlCreateLabel("*", 127, 134, 8, 17)
$Label10 = GUICtrlCreateLabel("*", 127, 170, 8, 17)
$Label11 = GUICtrlCreateLabel("*", 127, 208, 8, 17)
$Button1 = GUICtrlCreateButton("Volver", 112, 386, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Nuevo", 376, 384, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While $noingresa
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$op=1
	ExitLoop

Case $OK
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$bien=1
	$ced_pa = GUICtrlRead($ced)
	$Nom_pa = GUICtrlRead($Nom)
	$Ape_pa = GUICtrlRead($Ape)
	$DiaN_pa = GUICtrlRead($DiaN)
	$MesN_pa = GUICtrlRead($MesN)
	$AniN_pa = GUICtrlRead($AniN)
	$Dir_pa = GUICtrlRead($Dir)
	$Tel1_pa = GUICtrlRead($Tel1)
	$Tel2_pa = GUICtrlRead($Tel2) 
	$sex_paciente = GUICtrlRead($sexo)

	If $sex_paciente= 'f' Then $sex_paciente= 'F'
	If $sex_paciente= 'm' Then $sex_paciente= 'M'
	if $sex_paciente= 'F' or $sex_paciente= 'M' Then
	else
	$sex_paciente=''
	EndIf
	
	;Se chequean los items mardcados con *
	if $ced_pa = "" or $Nom_pa = "" or $Ape_pa = "" or $DiaN_pa = "" or $MesN_pa = "" Or $AniN_pa = "" or $sex_paciente = "" Or $bien=0 then 
	$noingresa=1
	MsgBox(0, "ATENCIÓN", "Debe ingresar los datos marcados con *",10)
	GUIDelete ($form2)
	Call ("Form2")
	Else 
	$noingresa=0
	EndIf



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

	
	if $noingresa=0 then
	$PaV=1;Validación de Paciente
	$op=$OPSAL
	ExitLoop
	EndIf

Case $Button1;Volver
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$op=1
	If $Pav=0 Then
	$ced_pa = ""
	$Nom_pa = ""
	$Ape_pa = ""
	$DiaN_pa = ""
	$Dir_pa = ""
	$Tel1_pa = ""
	$MesN_pa = ""
	$AniN_pa = ""
	$Tel2_pa = ""
	$sex_paciente = ""	
	EndIf
	ExitLoop

Case $Button2;Borrar todo
	$op=2
	$ced_pa = ""
	$Nom_pa = ""
	$Ape_pa = ""
	$DiaN_pa = ""
	$Dir_pa = ""
	$Tel1_pa = ""
	$MesN_pa = ""
	$AniN_pa = ""
	$Tel2_pa = ""
	$sex_paciente = ""
	$PaV=0
	ExitLoop

EndSwitch
WEnd
$ced_paciente = $Ced_pa
$nom_paciente = $Ape_pa&"^" & $Nom_pa 
$fnac_paciente = $AniN_pa & $MesN_pa & $DiaN_pa 

GUIDelete ($form2)
Call ("Form"&$op)
EndFunc
#Region FIN PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#Region FIN PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#Region FIN PACIENTE 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2


;Función Consulta
;Despliegue de los datos consultados en la base F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F 

;Función 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4   SELECC ARCHIVOS JPG   4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
;Función 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4   SELECC ARCHIVOS JPG   4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
;Función 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4   SELECC ARCHIVOS JPG   4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
Func Form4()
;GUISetState (@SW_DISABLE, $form1 )
FileChangeDir($Dir_jpg)
$previsual=GUICreate("Archivo Seleccionado",500,500,-1,-1,$WS_SIZEBOX+$WS_SYSMENU)
$message = "Elegir imagen para crear archivo para la historia del paciente"
$var = FileOpenDialog($message, $Dir_jpg & "\", "Imagenes (*.jpg)", 1 + 4 )
if @error = 1 then 
;		MsgBox(0, "ATENCIÓN", $form1,20)
;	Sleep (5000)
;	MsgBox(0, "ATENCIÓN22", $form1,20)
form1()
EndIf
;Aqui de la ruta y archvio elegido solo se selecciona el nombre del archivo seleccionado
$busca = StringInStr($var, "\",0 , -1)
$arch_jpg = StringTrimLeft($var, $busca)
$Dir_jpg= StringTrimRight($var, $busca)

;MsgBox(4096, "Ruta", $var& "numero encontrado "&$busca)
;MsgBox(4096, "Imagen", $arch_jpg)

If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_jpg = StringReplace($var, "|", @CRLF)
    ;MsgBox(4096,"","Archivo elegido " & $Ruta_jpg)
	EndIf
;$nom_paciente = $Nom_pa &" " & $Ape_pa
$escala=1;Cuando entre a mostrar va a estar en escala chica
form5()
EndFunc;fin Func4
#Region FIN FORM4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 SELECC ARCHIVOS 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
#Region FIN FORM4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 SELECC ARCHIVOS 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
#Region FIN FORM4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 SELECC ARCHIVOS 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4

;5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
;5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
;5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
Func Form5()
#Region ### START Koda GUI section ### Form=l:\imagojo\software bajado\programacion\koda 1.7.0.1\forms\fotocomentar.kxf
$Form5 = GUICreate("Imagen seleccionada para crear Dicom para paciente: "&$nom_paciente,801, 474, $X_vent, $Y_vent, $WS_SIZEBOX + $WS_SYSMENU + $WS_MAXIMIZEBOX)
if $escala=0 Then $Pic1 = GUICtrlCreatePic($Ruta_jpg, 8, 77, 0, 0)
if $escala=1 Then $Pic1 = GUICtrlCreatePic($Ruta_jpg, 144, 77, 521, 361)
$Button1 = GUICtrlCreateButton("Crear", 712, 48, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 368, 48, 75, 25, 0)
$Label1 = GUICtrlCreateLabel("Comentario de la imagen:", 8, 32, 123, 17)
$Input1 = GUICtrlCreateInput("", 133, 24, 649, 21)
$Label2 = GUICtrlCreateLabel("Descripción del estudio:", 8, 8, 114, 17)
$Input2 = GUICtrlCreateInput($estudioSel, 133, 3, 177, 21)
$Button3 = GUICtrlCreateButton("Escala", 16, 48, 75, 25, 0)
GUISetState ()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	GUIDelete ($form5)
Call ("Form1")
Case $Button1; Crear
	$coment=GUICtrlRead($Input1)
	$desc_estud=GUICtrlRead($Input2);"Aqui va la variable con la desc. del estudio"
	$estudioSel=""
	$op=9; Va a Form9 crear dicom
	ExitLoop
Case $Button2; Cancelar
	$estudioSel=""
	$op=1
	ExitLoop
Case $Button3; Escala
	$escala=Not $escala
	$op=5
	ExitLoop

	EndSwitch
WEnd
if $op=1 or $op=5 Then GUIDelete ($form5)
Call ("Form"&$op)
EndFunc;Fin función 5
#region 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
#region 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
#region 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 MOSTRAR IMAGEN JPG 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5

Func Form9()
;GUISetState (@SW_ENABLE, $form1 )
;SplashTextOn ("Creación de Archivo Dicom", "Se está creando el archivo Dicom", 250,100)
$Formaa = GUICreate("", 393, 157, -1, -1)
$Progress1 = GUICtrlCreateProgress(88, 88, 201, 20)
$Label1 = GUICtrlCreateLabel("Se está creando el archivo Dicom", 24, 40, 346, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
GUICtrlSetData ($Progress1,10)
;Crear archivo cfg para el jpg2dcm.bat
;se crea el archivo cfg vacío(,2)en el direcorio temp, si ya existe borra el contenido
$arch_cfg = @TempDir &"\jpg2dcm.cfg";ruta y archivo cfg
$file = FileOpen($arch_cfg, 2)
If $file = -1 Then
    MsgBox(0, "Error 202", "Chequear instalación")
    Exit
EndIf
;Sector jpg - Tags Dicom - Etiquetas Dicom 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
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
;# Image Comments
FileWriteLine ($file, "00204000:"&$coment)
;# StudyID (0020,0010) 
FileWriteLine ($file, "00200010:"&$desc_estud)
;# (0008,1030) StudyDescription
FileWriteLine ($file, "00081030:"&$desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
;# Manufacturer
FileWriteLine ($file, "00080070:Imagojo")
;# ReferringPhysiciansName
;FileWriteLine ($file, "00080090:"&$usuario)
;# InstitutionName
FileWriteLine ($file, "00080080:Hospital de Clínicas")
;# StationName
FileWriteLine ($file, "00081010:"&$Estacion)
;# Operator's Name
FileWriteLine ($file, "00081070:"&$usuario)
;# InstitutionalDepartment
FileWriteLine ($file, "00081040:Cátedra de Oftalmología")

FileClose($file)
;Crear imagen Dicom
;ruta y archivo dicom a crear:
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
;Creación del archivo dicom con la imagen seleccionada
RunWait( @comspec & " /c jpg2dcm -c "&$arch_cfg& " "&$dir_trab&"\selecc.jpg " & $Arch_nuevo_dcm & " > " & @TempDir & "\conversion.log",$dir_trab,@SW_HIDE)
GUICtrlSetData ($Progress1,50)
;Lee el log
$file = FileOpen(@TempDir & "\conversion.log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 203", "Chequear instalación")
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
	;SplashTextOn ("Creación de Archivo Dicom", "Se creó el archivo :" &$Nom_Dcm&".dcm")
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
					MsgBox(0, "Error 250", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se creó '&$Nom_Dcm&'.dcm a partir de archivo jpg')
				FileClose($file2)
				EndIf
;Fin escritura del log
$respuesta=MsgBox(4, "Archivo creado exitosamente", "Desea enviar al servidor "&$servidor &" el archivo dicom creado ahora?")
if $respuesta= "7" Then
	GUIDelete ($form5)
	Call ("Form1")
	EndIf
$FormXX=$form5
;EnviarDcm()
Run($Ruta_Imagojo&'\Lib\ImagojoEnv.exe')
GUIDelete ($FormXX)
Call ("Form1")
EndFunc;fin de Func9
;6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 CONFIGURACIÓN 6 6 6 6 6 6 6 6 6 6 6 6
;6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 CONFIGURACIÓN 6 6 6 6 6 6 6 6 6 6 6 6
;6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 CONFIGURACIÓN 6 6 6 6 6 6 6 6 6 6 6 6
Func Form6()
GUIDelete ($form1)
#Region ### START Koda GUI section ### Form=C:\Imagojo\koda 1.7.0.1\Forms\ConfiguracionTab.kxf
SplashOff()
$Form6 = GUICreate("Imagojo Configuración", 801, 451, $X_vent, $Y_vent)
;GUISetIcon("D:\005.ico")
$PageControl1 = GUICtrlCreateTab(8, 8, 780, 352)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Servidores")
$Label2 = GUICtrlCreateLabel("Servidor:"&$Servidor, 546, 246, 164, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
;$Button3 = GUICtrlCreateButton("Echo", 667, 268, 75, 25, 0)
;GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label3 = GUICtrlCreateLabel("Estado: "&$EstadoServ, 545, 272, 99, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$alias22 = GUICtrlCreateInput($ALIAS2, 90, 172, 113, 22);input alias2
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label4 = GUICtrlCreateLabel("Alias", 122, 156, 35, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$ae22 = GUICtrlCreateInput($AE2, 227, 173, 113, 22);input ae2
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label5 = GUICtrlCreateLabel("AE  Título", 259, 157, 49, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$ip22 = GUICtrlCreateInput($IP2, 365, 173, 113, 22);input ip2
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label6 = GUICtrlCreateLabel("Dirección IP", 392, 157, 60, 18)
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
;$TabSheet2 = GUICtrlCreateTabItem("TabSheet2")
;$TabSheet3 = GUICtrlCreateTabItem("TabSheet3")
GUICtrlCreateTabItem("")
$Button1 = GUICtrlCreateButton("&OK", 694, 384, 75, 25, 0)

If $EstadoServ = "Activo" then 
	GuiCtrlCreateLabel(" ", 637, 277, 10, 7)
	GuiCtrlSetBkColor(-1, 0x00FF00)
	EndIf

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $Button1
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	GUIDelete ($form6)
	Call ("Form1")
Case $GUI_EVENT_CLOSE
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	GUIDelete ($form6)
	Call ("Form1")
Case $Button7; Activar Op1
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	SplashTextOn ("Activando..", "Activando y efectuando Eco", 250,100)
	$ALIAS1=GUICtrlRead($Alias11)
	$AE1=GUICtrlRead($AE11)
	$IP1=GUICtrlRead($IP11)
	$PUERTO1=GUICtrlRead($PUERTO11)
	$Servidor = $ALIAS1
	$IpPuertoServidor = $IP1&':'&$PUERTO1

	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "Alias1", $ALIAS1)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "AE1", $AE1)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "IP1", $IP1)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "PUERTO1", $PUERTO1)
	;IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "IpPuertoServidor", $IpPuertoServidor)


;Inicio Echo dicom
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
	$op=1
	$borr=1
;Eco Dicom
FileChangeDir($dir_trab)
FileDelete(@TempDir & "\Imagojo.log")
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
;Fin Echo dicom
	GUIDelete ($form6)
	ExitLoop
Case $Button6; Activar Op2
	SplashTextOn ("Activando..", "Activando", 250,100)
	$ALIAS2=GUICtrlRead($Alias22)
	$AE2=GUICtrlRead($AE22)
	$IP2=GUICtrlRead($IP22)
	$PUERTO2=GUICtrlRead($PUERTO22)
	$IpPuertoLocal = $IP2&':'&$PUERTO2
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "Alias2", $ALIAS2)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "AE2", $AE2)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "IP2", $IP2)
	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "PUERTO2", $PUERTO2)
;	;IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "Servidor", $Servidor)
;	IniWrite($Ruta_Imagojo&"\Imagojo.ini", "Servidores", "IpPuertoLocal", $IpPuertoLocal)	
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
#Region Fin Form6 CONFIGURACION 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
#Region Fin Form6 CONFIGURACION 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
#Region Fin Form6 CONFIGURACION 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6


;7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7     CAPTURA     7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
;7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7     CAPTURA     7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
;7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7     CAPTURA     7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
Func Form7 ();Captura
MsgBox(0, "Atención:", "Este equipo no tiene función de Adquisición de Imagenes","")
GUIDelete ($form1)
Call ("Form1")
EndFunc ;FINAL FORM7 CAPTURA
#Region Fin Form7 CAPTURA 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
#Region Fin Form7 CAPTURA 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
#Region Fin Form7 CAPTURA 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7

;8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 MENU CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
;8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 MENU CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
;8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 MENU CREAR DICOM 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
Func Form8 ();
#Region ### START Koda GUI section ### Form=C:\Imagojo\koda 1.7.0.1\Forms\CrearDicom03.kxf
$Form8 = GUICreate("Imagojo Creación de Archivo Dicom a partir de:", 801, 451, $X_vent, $Y_vent)
GUISetBkColor(0xF9FCFF)
$Button5 = GUICtrlCreateButton("&Archivo Pdf", 546, 261, 99, 25, 0)
$Button1 = GUICtrlCreateButton("&Archivo de Imagen", 546, 205, 99, 25, 0)
$Button2 = GUICtrlCreateButton("&Texto", 546, 320, 99, 25, 0)
$Button3 = GUICtrlCreateButton("&Archivo de Video", 547, 151, 99, 25, 0)
$Button4 = GUICtrlCreateButton("Estudios en papel", 546, 98, 99, 25, 0)
$Button6 = GUICtrlCreateButton("Volver", 684, 368, 75, 25, 0)
$Label1 = GUICtrlCreateLabel("Paciente: ", 78, 256, 69, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label2 = GUICtrlCreateLabel($Ape_pa&", "&$Nom_pa, 145, 257, 273, 22)
GUICtrlSetFont(-1, 11, 800, 0, "Arial")
$Label4 = GUICtrlCreateLabel("Estación : "&$Estacion, 78, 208, 154, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label3 = GUICtrlCreateLabel("ID Paciente:", 78, 289, 83, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label5 = GUICtrlCreateLabel("Fecha : "&@MDAY & "/" & @MON & "/" & @YEAR, 78, 179, 129, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label7 = GUICtrlCreateLabel($ced_pa, 165, 288, 273, 22)
GUICtrlSetFont(-1, 11, 800, 0, "Arial")
$Group1 = GUICtrlCreateGroup(" ", 48, 152, 417, 185)
GUICtrlCreateGroup("", -99, -99, 1, 1)
#EndRegion ### END Koda GUI section ###

GUISetState(@SW_SHOW)
While 1
   Switch GUIGetMsg()
   Case $Button1;archivo de imagen
	   	$borr=0
		If $ced_pa Then
			$op=4
		Else 
			$OPSAL=4
			$op=2
		Endif
       exitloop
	Case $GUI_EVENT_CLOSE
	$size = WinGetPos("Imagojo")
	$X_vent=$size[0]
	$Y_vent=$size[1]
		$op=1
       exitloop 
   Case $Button6;Volver
	   $op=1
       exitloop 
   Case $Button5;archivo Pdf
	   	$borr=0
		If $ced_pa Then
			$op=20
		Else 
			$OPSAL=20
			$op=2
		Endif
       exitloop
  Case $Button3;archivo Video
	   	$borr=0
		If $ced_pa Then
			$op=23
		Else 
			$OPSAL=23
			$op=2
		Endif
       exitloop
  Case $Button4;Estudios en papel
	   	$borr=1
		If $ced_pa Then
			$op=50
		Else 
			$OPSAL=50
			$op=2
		Endif
       exitloop
EndSwitch
WEnd
;If $borr=1 Then GUIDelete ( "Form8")
GUIDelete ($form8)
Call ("Form"&$op)
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
$var = FileOpenDialog($message, @MyDocumentsDir & "\", "Archivos Pdf (*.pdf)", 1 + 4 )
if @error = 1 then 
;		MsgBox(0, "ATENCIÓN", $form1,20)
;	Sleep (5000)
GUIDelete ($form1)
;	MsgBox(0, "ATENCIÓN2", $form1,20)
form1()
EndIf
;Aqui de la ruta y archvio elegido solo se selecciona el nombre del archivo seleccionado
$busca = StringInStr($var, "\",0 , -1)
$arch_pdf = StringTrimLeft($var, $busca)


;MsgBox(4096, "Ruta", $var& "numero encontrado "&$busca)
;MsgBox(4096, "Imagen", $arch_jpg)

If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_pdf = StringReplace($var, "|", @CRLF)
;    MsgBox(4096,"","Archivo elegido =" & $Ruta_pdf)
 ;   MsgBox(4096,"","$arch_pdf =" & $arch_pdf)
	EndIf
;$nom_paciente = $Nom_pa &" " & $Ape_pa

form21()
EndFunc;fin Func20
Func Form21()
#Region ### START Koda GUI section ### Form=l:\imagojo\software bajado\programacion\koda 1.7.0.1\forms\fotocomentar.kxf
$Form21 = GUICreate("Archivo "&$arch_pdf&" para crear Dicom para paciente: "&$nom_paciente,527, 440, -1, -1, $WS_SIZEBOX + $WS_SYSMENU)
$Pic1 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\PdfImage.jpg", 136, 117, 249, 281)
$Button1 = GUICtrlCreateButton("Crear", 432, 56, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 16, 56, 75, 25, 0)
$Button3 = GUICtrlCreateButton("Previsualizar", 223, 56, 83, 25, 0)
$Label1 = GUICtrlCreateLabel("Descripción del estudio", 8, 8, 114, 17)
$Label2 = GUICtrlCreateLabel("Título del Archivo pdf", 8, 32, 106, 17)
$Input1 = GUICtrlCreateInput("", 133, 24, 313, 21)
$Input2 = GUICtrlCreateInput("", 133, 3, 177, 21)

GUISetState ()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	GUIDelete ($form21)
Call ("Form1")
Case $Button1; Crear
	$desc_estud=GUICtrlRead($Input2)
	$Coment=GUICtrlRead($Input1)
	$op=22;Va a Form22 crear dicom con Pdf
	ExitLoop
Case $Button3; Previsualizar pdf
	ShellExecute($arch_pdf)
Case $Button2; Cancelar
	$op=1;Vuelve al menú
	ExitLoop
EndSwitch
WEnd
if $op=1 Then GUIDelete ($form21)
Call ("Form"&$op)
EndFunc;Fin función 21
#Region FIN COMENTAR PDF 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
#Region FIN COMENTAR PDF 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
#Region FIN COMENTAR PDF 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
Func Form22()
;GUISetState (@SW_ENABLE, $form1 )
;SplashTextOn ("Creación de Archivo Dicom", "Se está creando el archivo Dicom", 250,100)
$Formaa = GUICreate("", 393, 157, -1, -1)
$Progress1 = GUICtrlCreateProgress(88, 88, 201, 20)
$Label1 = GUICtrlCreateLabel("Se está creando el archivo Dicom", 24, 40, 346, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
GUICtrlSetData ($Progress1,10)
;Crear archivo cfg para el pdf2dcm.bat
;se crea el archivo cfg vacío(,2)en el direcorio temp, si ya existe borra el contenido
$arch_cfg = @TempDir &"\pdf2dcm.cfg";ruta y archivo cfg
$file = FileOpen($arch_cfg, 2)
If $file = -1 Then
    MsgBox(0, "Error 202", "Chequear instalación")
    Exit
EndIf
;Sector pdf - Tags Dicom - Etiquetas Dicom 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
;00100020:1512555.6
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
;# StudyID (0020,0010) 
FileWriteLine ($file, "00200010:")
;# (0008,1030) StudyDescription
FileWriteLine ($file, "00081030:"&$desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
;# Manufacturer
FileWriteLine ($file, "00080070:Imagojo")
;# ReferringPhysiciansName
;FileWriteLine ($file, "00080090:"&$usuario)
;# InstitutionName
FileWriteLine ($file, "00080080:Hospital de Clínicas")
;# StationName
FileWriteLine ($file, "00081010:"&$Estacion)
;# Operator's Name
FileWriteLine ($file, "00081070:"&$usuario)
;# InstitutionalDepartment
FileWriteLine ($file, "00081040:Cátedra de Oftalmología")
;# SC Equipment Module Attributes # Conversion Type


;# Document Title
FileWriteLine ($file, "00420010:"&$Coment)


FileWriteLine ($file, "00080064:SD")
;# MIME Type of Encapsulated Document 00420012:application/pdf
FileWriteLine ($file, "00420012:application/pdf")
;# SOP Common Module Attributes # SOP Class UID 00080016:1.2.840.10008.5.1.4.1.1.104.1
FileWriteLine ($file, "00080016:1.2.840.10008.5.1.4.1.1.104.1")

FileClose($file)
;Crear imagen Dicom
;ruta y archivo dicom a crear:
$Nom_Dcm=@YEAR&@MON&@MDAY&@HOUR&@MIN&@SEC
$arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm &".dcm"
;$arch_nuevo_dcm = $Ruta_Dcm &"\"& $Nom_Dcm&$Azar &".dcm"
;$consola_crea_log = @TempDir & "\conversión.log";log de la consola al crear el archivo
GUICtrlSetData ($Progress1,20)
;Se copia el archivo seleccionado con otro nombre mas corto
FileCopy($Ruta_pdf, $dir_trab&"\selecc.pdf",1)
GUICtrlSetData ($Progress1,30)
Sleep (4000)
;Creación del archivo dicom con la imagen seleccionada
RunWait( @comspec & " /c pdf2dcm -c "&$arch_cfg& " selecc.pdf " & $arch_nuevo_dcm & " > " & @TempDir & "\conversion.log",$dir_trab,@SW_HIDE)
GUICtrlSetData ($Progress1,50)
;Lee el log
$file = FileOpen(@TempDir & "\conversion.log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 203", "Chequear instalación")
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
	;SplashTextOn ("Creación de Archivo Dicom", "Se creó el archivo :" &$Nom_Dcm&".dcm")
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
					MsgBox(0, "Error 250", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se creó '&$Nom_Dcm&'.dcm a partir de archivo pdf')
				FileClose($file2)
				EndIf
;Fin escritura del log
;invitar a enviar Dicom con la opción a elegir a que servidor quiere mandarla
; o invitar a abrir el archivo con algún Visor Dicom
$respuesta=MsgBox(4, "Archivo creado exitosamente", "Desea enviar al servidor "&$servidor &" el archivo dicom creado ahora?")
if $respuesta= "7" Then
	GUIDelete ($form21)
	Call ("Form1")
	EndIf
$FormXX=$form21
;EnviarDcm()
Run($Ruta_Imagojo&'\Lib\ImagojoEnv.exe')
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
$message = "Elegir Video para crear archivo Dicom para la historia del paciente"
$var = FileOpenDialog($message, @MyDocumentsDir & "\", "Archivos de Video (*.mpg;*.mpeg)", 1 + 4 )
if @error = 1 then 
;		MsgBox(0, "ATENCIÓN", $form1,20)
;	Sleep (5000)
GUIDelete ($form1)
;	MsgBox(0, "ATENCIÓN2", $form1,20)
form1()
EndIf
;Aqui de la ruta y archvio elegido solo se selecciona el nombre del archivo seleccionado
$busca = StringInStr($var, "\",0 , -1)
$arch_video = StringTrimLeft($var, $busca)

If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_video = StringReplace($var, "|", @CRLF)
;    MsgBox(4096,"","Archivo elegido =" & $Ruta_video)
 	EndIf
;$nom_paciente = $Nom_pa &" " & $Ape_pa

form24()
EndFunc;fin Func23
Func Form24()
#Region ### START Koda GUI section ### Form=l:\imagojo\software bajado\programacion\koda 1.7.0.1\forms\fotocomentar.kxf
$Form24 = GUICreate("Archivo de video para crear Dicom para paciente: "&$nom_paciente,527, 440, -1, -1, $WS_SIZEBOX + $WS_SYSMENU)
$Pic1 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\MpgImage.jpg", 136, 117, 249, 281)
$Button1 = GUICtrlCreateButton("Crear", 432, 56, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Cancelar", 16, 56, 75, 25, 0)
$Label1 = GUICtrlCreateLabel("Descripción del estudio", 8, 8, 114, 17)
$Label2 = GUICtrlCreateLabel("Descripción del video", 8, 32, 106, 17)
$Input1 = GUICtrlCreateInput("", 133, 24, 313, 21)
$Input2 = GUICtrlCreateInput("", 133, 3, 177, 21)

GUISetState ()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	GUIDelete ($form24)
Call ("Form1")
Case $Button1; Crear
	$coment=GUICtrlRead($Input1)
	$desc_estud=GUICtrlRead($Input2)
	$op=25;Va a Form25 crear dicom con Mpg
	ExitLoop
Case $Button2; Cancelar
	GUIDelete ($form24)
	$op=1;Vuelve al menú
	ExitLoop

	EndSwitch
WEnd
if $op=1 Then GUIDelete ($form24)
Call ("Form"&$op)
EndFunc;Fin función 24
#Region FIN COMENTAR MPG 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24
#Region FIN COMENTAR MPG 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24
#Region FIN COMENTAR MPG 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24 24
Func Form25()
;GUISetState (@SW_ENABLE, $form1 )
;SplashTextOn ("Creación de Archivo Dicom", "Se está creando el archivo Dicom", 250,100)
$Formaa = GUICreate("", 393, 157, -1, -1)
$Progress1 = GUICtrlCreateProgress(88, 88, 201, 20)
$Label1 = GUICtrlCreateLabel("Se está creando el archivo Dicom", 24, 40, 346, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
GUICtrlSetData ($Progress1,10)
;Crear archivo cfg para el JPG2dcm.bat
;se crea el archivo cfg vacío(,2)en el direcorio temp, si ya existe borra el contenido
$arch_cfg = @TempDir &"\mpg2dcm.cfg";ruta y archivo cfg
$file = FileOpen($arch_cfg, 2)
If $file = -1 Then
    MsgBox(0, "Error 210", "Chequear instalación")
    Exit
EndIf
;Sector video - Tags Dicom - Etiquetas Dicom 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
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
;# Image Comments
FileWriteLine ($file, "00204000:"&$coment)
;# StudyID (0020,0010) 
FileWriteLine ($file, "00200010:")
;# (0008,1030) StudyDescription
FileWriteLine ($file, "00081030:"&$desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
;# ReferringPhysiciansName
;FileWriteLine ($file, "00080090:"&$usuario)
;# InstitutionName
FileWriteLine ($file, "00080080:Hospital de Clínicas")
;# StationName
FileWriteLine ($file, "00081010:"&$Estacion)
;# Operator's Name
FileWriteLine ($file, "00081070:"&$usuario)
;# InstitutionalDepartment
FileWriteLine ($file, "00081040:Cátedra de Oftalmología")
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
FileWriteLine ($file, "00080070:Imagojo")


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
FileWriteLine ($file, "00280010:480")

;# Columns 00280011:640
FileWriteLine ($file, "00280011:640")

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
FileWriteLine ($file, "00080008:ORIGINAL\PRIMARY")

;# Lossy Image Compression 00282110:01
FileWriteLine ($file, "00282110:01")

;# SOP Common Module Attributes
;# SOP Class UID 00080016:1.2.840.10008.5.1.4.1.1.77.1.4.1
FileWriteLine ($file, "00080016:1.2.840.10008.5.1.4.1.1.77.1.4.1")

;# SOP Instance UID
;#00080018

FileClose($file)
;Crear video Dicom
;ruta y archivo dicom a crear:
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
;Creación del archivo dicom con la imagen seleccionada
RunWait( @comspec & " /c jpg2dcm --mpeg -C "&$arch_cfg& " "&$Dir_trab&"\selecc.mpg " & $Arch_nuevo_dcm & " > " & @TempDir & "\conversion.log",$Dir_trab,@SW_HIDE)
GUICtrlSetData ($Progress1,60)
;Lee el log
$file = FileOpen(@TempDir & "\conversion.log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 203", "Chequear instalación")
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
	;SplashTextOn ("Creación de Archivo Dicom", "Se creó el archivo :" &$Nom_Dcm&".dcm")
	;GUIDelete ($form22)
Else
	MsgBox(0, "Resultado:", "El archivo de video elegido no es compatible o el comentario contiene avances de línea",10)
	GUIDelete ($form24)
	Call ("Form1")
EndIf
FileDelete($Dir_trab&"\"&$arch_video)
;Escribir en el log
$file2 = FileOpen($arch_log, 9)
				If $file2 = -1 Then
					MsgBox(0, "Error 250", "No se pudo abrir "&$arch_log)
				Else
				FileWriteLine ($file2, @HOUR&':'&@MIN&':'&@SEC&' se creó '&$Nom_Dcm&'.dcm a partir de archivo de video')
				FileClose($file2)
				EndIf
;Fin escritura del log
;invitar a enviar Dicom con la opción a elegir a que servidor quiere mandarla
; o invitar a abrir el archivo con algún Visor Dicom
$respuesta=MsgBox(4, "Archivo creado exitosamente", "Desea enviar al servidor "&$servidor &" el archivo dicom creado ahora?")
if $respuesta= "7" Then
	GUIDelete ($form24)
	Call ("Form1")
	EndIf
$FormXX=$form24
;EnviarDcm()
Run($Ruta_Imagojo&'\Lib\ImagojoEnv.exe')
GUIDelete ($FormXX)
Call ("Form1")
EndFunc;fin de Func25
#Region Fin Crear VIDEO 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25
#Region Fin Crear VIDEO 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25
#Region Fin Crear VIDEO 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25

;Seleccionar archivo para mandar
Func Form30()
$previsual=GUICreate("Archivo Seleccionado",500,500,-1,-1,$WS_SIZEBOX+$WS_SYSMENU)
$message = "Elegir Archivo Dicom para enviar a "&$Alias1
$var = FileOpenDialog($message, @MyDocumentsDir & "\", "Archivos Dicom (*.dcm)", 1 + 4 )
if @error = 1 then 
;		MsgBox(0, "ATENCIÓN", $form1,20)
;	Sleep (5000)
GUIDelete ($form1)
;	MsgBox(0, "ATENCIÓN2", $form1,20)
form1()
EndIf
;Aqui de la ruta y archvio elegido solo se selecciona el nombre del archivo seleccionado
$busca = StringInStr($var, "\",0 , -1)
$arch_dicom = StringTrimLeft($var, $busca)

If @error Then
    MsgBox(4096,"","No se eligió archivo")
Else
    $Ruta_dicom = StringReplace($var, "|", @CRLF)
   MsgBox(4096,"","Archivo elegido =" & $Ruta_dicom)
EndIf
;Antes se crea un número al azar de cuatro cifras para que los mombres de los temp no se repitan
$Azar=0
While $Azar<1000
	$Azar=int (Random ()*10000)
WEnd
SplashTextOn ("Enviar archivo al servidor", "Se está enviando el archivo al servidor", 250,100)
;MsgBox(0, "Enviar Dicom", "Enviando Archivo al Servidor :"&$Servidor)
$n=0
$retardo=0
While $n<=$Bucle
if $n<$Bucle then $retardo=$n*$n*1000
	sleep ($retardo)
;MsgBox(0, "Intento "&$n, "retardo de "&$retardo/1000,5)
;OK-->  PARA MANDAR UN ARCHIVO.DCM AL SERVIDOR
RunWait( @comspec & " /c dcmsnd -L "&$AE2&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor&" "&$Ruta_dicom & " > " & @TempDir & "\Temp"&$Azar&".log",$Dir_trab,@SW_HIDE)
;RunWait( @comspec & " /c dcmsnd -stgcmt -L "&$AE1&":"&$PUERTO2&" "&$AE1&"@"&$IpPuertoServidor&" "&$Ruta_dicom & " > " & @TempDir & "\Temp"&$Azar&".log",$Dir_trab,@SW_HIDE)
;Lee el log
$file = FileOpen(@TempDir & "\Temp"&$Azar&".log", 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 204", "Chequear instalación")
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
#Region Fin Enviar Dicom de Herramientas 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
#Region Fin Enviar Dicom de Herramientas 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
#Region Fin Enviar Dicom de Herramientas 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30

Func Form40()
#Region ### START Koda GUI section ### Form=C:\Imagojo\FormAcercade.kxf
$Form40 = GUICreate("Acerca de", 319, 249, -1, -1)
GUISetBkColor(0xF9FCFF)
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 305, 185)
$Image1 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\Acercade.gif", 16, 24, 169, 153)
$Label1 = GUICtrlCreateLabel("Imagojo", 192, 24, 57, 17, $WS_GROUP)
$Label2 = GUICtrlCreateLabel("Version1.1", 192, 48, 60, 17, $WS_GROUP)
$Label4 = GUICtrlCreateLabel("rvlaeminck@antel.net.uy", 192, 96, 121, 17, $WS_GROUP)
$Label3 = GUICtrlCreateLabel("Contactos:", 192, 80, 55, 17, $WS_GROUP)
$Pic1 = GUICtrlCreatePic($Ruta_Imagojo&"\Lib\Gui\ImagojoIco.gif", 262, 26, 33, 33)
$Label5 = GUICtrlCreateLabel("aprieto@bps.net.uy", 195, 111, 96, 17, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&OK", 112, 208, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

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
;Bloque para enviar un archivo Dicom
;MsgBox(0, "$bucle", $Bucle,10)
SplashTextOn ("Enviar archivo al servidor", "Se está enviando el archivo al servidor", 250,100)
;MsgBox(0, "Enviar Dicom", "Enviando Imagen al Servidor :"&$Servidor)
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
    MsgBox(0, "Error 204", "Chequear instalación")
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
$file = FileOpen($Ruta_Imagojo&"\NoEnviados.log", 1)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error 207", "Chequear instalación")
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


#Region ### START Koda GUI section ### Form=C:\Imagojo\koda 1.7.0.1\Forms\Estudios en papel01.kxf
;- - - - - - - - -Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
;- - - - - - - - -Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
;- - - - - - - - -Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
Func Form50()
$habButton2=0
$Button2=''
$paintEst=''
FileInstall ('C:\ImagojoInst\Estudios\Amsler-dcm.jpg', 'C:\Imagojo\Estudios\Amsler.jpg', 1)
FileInstall ('C:\ImagojoInst\Estudios\Farnsworth15-dcm.jpg', 'C:\Imagojo\Estudios\Farnsworth15.jpg', 1)
FileInstall ('C:\ImagojoInst\Estudios\Farnsworth100-dcm.jpg', 'C:\Imagojo\Estudios\Farnsworth100.jpg', 1)
FileInstall ('C:\ImagojoInst\Estudios\Goldman-dcm.jpg', 'C:\Imagojo\Estudios\Goldman.jpg', 1)
FileInstall ('C:\ImagojoInst\Estudios\Munsell1-dcm.jpg', 'C:\Imagojo\Estudios\Munsell1.jpg', 1)
FileInstall ('C:\ImagojoInst\Estudios\Munsell2-dcm.jpg', 'C:\Imagojo\Estudios\Munsell2.jpg', 1)
FileInstall ('C:\ImagojoInst\Estudios\PantallaTGC-dcm.jpg', 'C:\Imagojo\Estudios\PantallaTGC.jpg', 1)
FileInstall ('C:\ImagojoInst\Estudios\Pelli-Robinson-dcm.jpg', 'C:\Imagojo\Estudios\Pelli-Robinson.jpg', 1)
$Form50 = GUICreate("Imagojo", 197, 165, $X_ventE, $Y_ventE, -1, $WS_EX_TOPMOST)
$Label1 = GUICtrlCreateLabel("Estudio Seleccionado:", 16, 40, 110, 17)
$Combo1 = GUICtrlCreateCombo("", 16, 56, 169, 25)
GUICtrlSetData(-1, "Farnsworth 100|Farnsworth 15|Test de Amsler|Munsell separación|Munsell clasificación|Sensibilidad de constraste|Perimetría Goldman|Campo visual 2 ojos", "estudios")
GUISetState()
$Button1 = GUICtrlCreateButton("Transcribir Estudio", 56, 80, 91, 25, 0)
$Button2 = GUICtrlCreateButton("Crear Dicom", 256, 80, 81, 25, 0)
$Button3 = GUICtrlCreateButton("Cancelar", 72, 128, 57, 25, 0)
$Label2 = GUICtrlCreateLabel("Paciente:", 8, 0, 49, 17)
$Label3 = GUICtrlCreateLabel( $Ape_pa&", "&$Nom_pa, 8, 16, 119, 17)
GUICtrlSetFont(-1, 11, 800, 0, "Arial")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
	$PID = ProcessExists("mspaint.EXE")
	If $PID Then ProcessClose($PID)
	$size = WinGetPos("Imagojo")
	$X_ventE=$size[0]
	$Y_ventE=$size[1]
	GUIDelete ($form50)
	Call ("Form1")
Case $Button1; Transcribir Estudio
	$size = WinGetPos("Imagojo")
	$X_ventE=$size[0]
	$Y_ventE=$size[1]
;	MsgBox(0, "Atención", $X_ventE&" Y="&$Y_ventE,10)
	$estudioSel=GUICtrlRead($Combo1)
	If $estudioSel='Test de Amsler'Then
		$paintEst="Amsler - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\Amsler.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\Amsler.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf



	If $estudioSel='Farnsworth 100'Then
		$paintEst="Farnsworth100 - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\Farnsworth100.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\Farnsworth100.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf

	If $estudioSel='Farnsworth 15'Then
		$paintEst="Farnsworth15 - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\Farnsworth15.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\Farnsworth15.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf

	If $estudioSel='Perimetría Goldman'Then
		$paintEst="Goldman - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\Goldman.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\Goldman.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf

	If $estudioSel='Munsell separación'Then
		$paintEst="Munsell1 - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\Munsell1.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\Munsell1.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf

	If $estudioSel='Munsell clasificación'Then
		$paintEst="Munsell2 - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\Munsell2.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\Munsell2.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf

	If $estudioSel='Sensibilidad de constraste'Then
		$paintEst="Pelli-Robinson - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\Pelli-Robinson.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\Pelli-Robinson.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf

	If $estudioSel='Campo visual 2 ojos'Then
		$paintEst="PantallaTGC - Paint"
		If WinExists($paintEst) Then
		WinActivate($paintEst, "")
		Else
		$Ruta_jpg = 'C:\Imagojo\Estudios\PantallaTGC.jpg'
		Run ( 'mspaint.EXE "C:\Imagojo\Estudios\PantallaTGC.jpg"' )
		GUICtrlDelete($Button1)
		GUICtrlDelete($Button2)
		$Button1 = GUICtrlCreateButton("Transcribir Estudio", 256, 80, 91, 25, 0)
		$Button2 = GUICtrlCreateButton("Crear Dicom", 56, 80, 81, 25, 0)
		EndIf
	EndIf

	If $estudioSel=''Then MsgBox(0, "Atención", 'Debe eleccionar estudio',10)
Case $Button2; Crear Dicom
	$size = WinGetPos("Imagojo")
	$X_ventE=$size[0]
	$Y_ventE=$size[1]
	$PID0 = ProcessExists("mspaint.EXE")
	;If $PID0=0 Then MsgBox(0, "Atención", "Debe Transcribir Estudio primero",10)
	If $PID0 Then
		SplashTextOn("Guardar archivo", "Guardando archivo", 285, 150, -1, -1)
		WinClose($paintEst)
		WinActivate("Paint")
		;WinWaitActive("Paint")
		;MsgBox(4096, "Guardar archivo", "Guardando archivo",5)
		Sleep (2500)
		Send ("{Enter}")
		SplashTextOn("Guardar archivo", "Archivo guardado", 285, 150, -1, -1)
		Sleep (500)
		SplashOff ()
		$escala=1;Cuando entre a mostrar va a estar en escala chica
		Sleep (1500)
		$t =  FileGetTime($Ruta_jpg, 0, 1)
		if $t="20000101000000" Then 
			MsgBox(0, "Atención", "No le ha hecho cambios al archivo",5)
			GUICtrlDelete($Button1)
			GUICtrlDelete($Button2)
			$Button1 = GUICtrlCreateButton("Transcribir Estudio", 56, 80, 91, 25, 0)
			$Button2 = GUICtrlCreateButton("Crear Dicom", 256, 80, 81, 25, 0)
		Else
			GUIDelete ($form50)
			form5()
			Call ("Form1")
		Endif
	EndIf

Case $Button3; Cancelar
	$estudioSel=""
	$size = WinGetPos("Imagojo")
	$X_ventE=$size[0]
	$Y_ventE=$size[1]
	$PID = ProcessExists("mspaint.EXE")
	If $PID Then ProcessClose($PID)
	GUIDelete ($form50)
	Call ("Form1")
EndSwitch
WEnd
EndFunc
#Region Fin Bloque Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
#Region Fin Bloque Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
#Region Fin Bloque Estuios en papel - - - - - - - - - - - - - -    Estuios en papel   - - - - - - - - - - - - - - - - - - - - - - - -
#Region ### START Koda GUI section ### Form=C:\Imagojo\koda 1.7.0.1\Forms\Estudios en papel01.kxf