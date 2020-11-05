;3 Script paso 3 Copiar a través de una consola archivos de JBoss runtime al directorio de dcm4chee.
#cs
Run ( 'cmd.EXE' )
Sleep ( 1500 )
Send ("cd C:\apps\dcm4chee-2.16.2-mysql\bin{ENTER}")
Sleep ( 500 )
Send ("install_jboss.bat c:\apps\jboss-4.2.3.GA{ENTER}")
Exit
#ce


;5  Script paso 5 Crear la base de datos para dcm4chee, Si MySql está recien instalado hay que reiniciar el sistema para que este script ande, sino hay que ir a través de el enlace Mysql ir a una consola y teclear.
#cs
Run ( 'cmd.EXE' )
Sleep ( 1500 )
Send ("mysql -uroot -p{ENTER}")
Sleep ( 1500 )
Send ("4624{ENTER}");esto depende de que clave se halla elegido
Sleep ( 1500 )
Send ("create database pacsdb;{ENTER}")

Sleep ( 11500 )
Send ("grant all on pacsdb.* to 'pacs'@'localhost' identified by 'pacs';{ENTER}")
Exit
#ce
#cs
Run ( 'cmd.EXE' )
Sleep ( 1500 )
Send ("cd C:\{ENTER}")
Sleep ( 1500 )
Send ("mysql -upacs -ppacs pacsdb < c:\apps\dcm4chee-2.16.2-mysql\sql\create.mysql")
Exit
#ce

;6 Script 6 Instalar el Audit Record Repository (ARR) Esto es opcional, la primera vez no lo cargué
#cs
Run ( 'cmd.EXE' )
Sleep ( 1500 )
Send ("cd C:\apps\dcm4chee-2.16.2-mysql\bin{ENTER}")
Sleep ( 1500 )
Send ("install_arr.bat c:\apps\dcm4chee-arr-3.0.11-mysql{ENTER}")
Exit
#ce

;VARIBLES DE ENTORNO PARA JAVA al final de instalar jdk-6u26-windows-i586.exe
; JAVA_HOME   C:\Archivos de programa\Java\jdk1.6.0_26

;Pra iniciar el DCM4CHEE en una ventana de sistema
#cs
Run ( 'cmd.EXE' )
Sleep ( 1500 )
Send ("cd C:\apps\dcm4chee-2.16.2-mysql\bin{ENTER}")
Sleep ( 500 )
Send ("run.bat{ENTER}")
Exit
#ce
;Pra iniciar el DCM4CHEE en forma oculta
;#cs
Opt("TrayIconHide", 0)
$dir ='C:\apps\dcm4chee-2.16.2-mysql\bin'
RunWait( @comspec & " /c run.bat > " & @TempDir & "\Dcm4chee.log",$dir,@SW_HIDE)
;RunWait( @comspec & " /c run.bat > " & @TempDir & "\Dcm4chee.log",$dir,@SW_SHOW)
EXIT