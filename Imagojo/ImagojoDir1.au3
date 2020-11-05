; Proyecto de fin de carrera: IMAGOJO
; Programa IMAGOJODIR1
; AutoIt 3.3.61
; Creado :12/11/10   Modificado: 14/12/11 
; Autores: Rodrigo Vlaeminck y Alvaro Prieto
;*********************************
$Ruta_IMAGOJO=IniRead("IMAGOJO2.ini", "Directorios", "Ruta_IMAGOJO", 'C:\IMAGOJO')
While 1
$Minutos=IniRead("IMAGOJO2.ini", "EnvioDicom", "Minutos", '1')
	If ProcessExists("IMAGOJODIR2.exe") Then

	Else
	RunWait($Ruta_IMAGOJO&'\Lib\IMAGOJODIR2.exe')
	EndIf
Sleep ($Minutos*60000)
WEnd