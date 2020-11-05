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

;RunWait( @comspec & " /c dcmrcv "&$AE2&":"&$PUERTO2&" -dest /"&$Ruta_dcm&"\Recibidos > " & $Temp_log,$dir_trab,@SW_HIDE)
RunWait( @comspec & " /c dcmrcv "&$AE2&":"&$PUERTO2+1&" -dest /"&$Ruta_dcm&"\Recibidos ",$dir_trab,@SW_HIDE)
;RunWait( @comspec & " /c dcmrcv DCMRCV:11113 -dest /tmp > " & $Temp_log,$dir_trab,@SW_HIDE)
;RunWait( @comspec & " /c dcmrcv DCMRCV:11113 -dest /tmp " ,$dir_trab,@SW_HIDE)