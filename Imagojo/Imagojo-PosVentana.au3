Opt("WinTitleMatchMode", 1)

While 1
$size = WinGetPos("Imagojo:")
If @error then
	MsgBox(0, "Sistema "&@DesktopWidth&' '&@DesktopHeight, "la ventana Imagojo no está presente")
Else
	MsgBox(0, "Sistema "&@DesktopWidth&' '&@DesktopHeight, $size[0] & " " & $size[1])
EndIf
WEnd
