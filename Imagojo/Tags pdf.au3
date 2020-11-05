;Sector pdf - Tags DICOM - Etiquetas DICOM 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$Nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
;# Issuer of Patient ID 00100021
if $PaV=1 and $Cedula_valida=1 then
FileWriteLine ($file, "00100021:C.I. uruguaya")
endif
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
FileWriteLine ($file, "00081030:"&$Desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
;# Manufacturer
FileWriteLine ($file, "00080070:IMAGOJO 1.24")
;# ReferringPhysiciansName
FileWriteLine ($file, "00080090:"&$MedRef)
;# InstitutionName
FileWriteLine ($file, "00080080:" &$Institucion)
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
