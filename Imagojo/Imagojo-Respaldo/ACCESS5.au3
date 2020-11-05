Local $oRS
Local $oConn

$oConn = ObjCreate("ADODB.Connection")
$oRS = ObjCreate("ADODB.Recordset")
$oConn.Open("Driver={Microsoft Access Driver (*.mdb)};Dbq=BScan.mdb")

$oRS.Open("Select * FROM tabPatient", $oConn, 1, 3)

MsgBox(1,"", "Hay " & $oRS.RecordCount & " campos.")

$cedula = InputBox("Ingresar datos", "Ingrese la cedula sin guiones Ej: 3994162-1 = 39941621")
If @error = 1 Then Exit



$oRS.MoveFirst

For $iIndex = 1 To $oRS.RecordCount
	If $oRS.Fields("SSNumber").value = $cedula Then 
	MsgBox(1,"", "Es el paciente " & $oRS.Fields("ID_Patient").value )
	MsgBox(1,"", "Es el paciente " & $oRS.Fields("FirstName").value )
	$paciente = $oRS.Fields("ID_Patient").value
	EndIf
	$oRS.MoveNext	
	Next

$oConn.Close
$oConn = 0

$oConn = ObjCreate("ADODB.Connection")
$oRS = ObjCreate("ADODB.Recordset")
$oConn.Open("Driver={Microsoft Access Driver (*.mdb)};Dbq=BScan.mdb")


$oRS.Open("Select * FROM tabTest", $oConn, 1, 3)
MsgBox(1,"", "Hay " & $oRS.RecordCount & " campos.")

$oRS.MoveFirst

For $iIndex = 1 To $oRS.RecordCount
	If $oRS.Fields("ID_Patient").value = $paciente Then MsgBox(1,"", "Estudio " & $oRS.Fields("Image").value )
	$oRS.MoveNext	
	Next

MsgBox(1,"", "No hay mas registros ")
$oConn.Close
$oConn = 0

Exit
For $iIndex = 1 To $oRS.RecordCount
    $NewAddress = InputBox("Chequeo", $oRS.Fields("FirstName").value & "'s address is currently: " & _
            $oRS.Fields("LastName").value & ". Please enter a new LastName.", $oRS.Fields("LastName").value)
    
    $oRS.Fields("LastName").value = $NewAddress
    $oRS.MoveNext
Next

$oConn.Close
$oConn = 0