#include <GUIConstants.au3>
#include "MD5.AU3"
$Ruta_IMAGOJO=IniRead("IMAGOJO.ini", "Directorios", "Ruta_IMAGOJO", 'C:\IMAGOJO')
$arch_ctsU=$Ruta_IMAGOJO&'\Lib\ctsU.imj'
	$passwd = InputBox("Imagojo: Generador Usuarios", "Ingrese su contraseña.", "", "*")
	If $passwd='imagojo1' Then
	Else
		Exit
		EndIf


#Region ### START Koda GUI section ### Form=C:\Documents and Settings\ap\Mis documentos\Dropbox\imagojo\Koda\Forms\Cambio de contraseña.kxf
					$Form1_1_1 = GUICreate("Bienvenido administrador", 389, 190, -1, -1)
					$Button1 = GUICtrlCreateButton("Aceptar", 296, 144, 75, 25, 0)
					$Input1 = GUICtrlCreateInput("", 152, 56, 193, 21)
					$Input2 = GUICtrlCreateInput("", 152, 94, 193, 21)
					$Label1 = GUICtrlCreateLabel("Cedula usuario", 24, 56, 118, 20)
					GUICtrlSetFont(-1, 10, 800, 0, "Arial")
					$Label2 = GUICtrlCreateLabel("Nombre verdadero", 23, 96, 124, 20)
					GUICtrlSetFont(-1, 10, 800, 0, "Arial")
					$Button2 = GUICtrlCreateButton("Cancelar", 21, 144, 75, 25, 0)
					;$Label3 = GUICtrlCreateLabel("(Debe de tener al menos 6 y un máximo de 25 caracteres)", 20, 25, 341, 20)
					;GUICtrlSetFont(-1, 10, 400, 0, "Arial")
					$Button3 = GUICtrlCreateButton("Ver", 175, 144, 46, 25, 0)
					GUISetState(@SW_SHOW)
					#EndRegion ### END Koda GUI section ###
					While 1
					Switch GUIGetMsg()
					Case $Button1;Aceptar
					$cedula = GUICtrlRead($Input1)
					$nombre= GUICtrlRead($Input2)
					$sDigest = md5($cedula&$cedula&"43K")
					IniWrite($arch_ctsU, $cedula, "name", $nombre)
					IniWrite($arch_ctsU, $cedula, "key", $sDigest)
					MsgBox (0,"Creación de contraseña", "Se creo el usuario", 250,100)
						
					Case $Button3;Ver
					Run ( 'notepad.EXE "C:\IMAGOJO\lib\ctsU.imj"' )
					
					Case $GUI_EVENT_CLOSE
					ExitLoop
					Case $Button2;Cancelar
					ExitLoop
					EndSwitch
					WEnd


