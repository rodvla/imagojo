Opt("TrayIconHide", 0)
$dir ='C:\apps\dcm4chee-2.16.2-mysql\bin'
RunWait( @comspec & " /c run.bat > " & @TempDir & "\Dcm4chee.log",$dir,@SW_HIDE)
EXIT