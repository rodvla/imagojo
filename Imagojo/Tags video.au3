;Sector video - Tags DICOM - Etiquetas DICOM 
;# Patient's Name
FileWriteLine ($file, "00100010:"&$Nom_paciente)
;# Patient ID
FileWriteLine ($file, "00100020:"&$ced_paciente)
;# Issuer of Patient ID 00100021
if $PaV=1 and $Cedula_valida=1 then
FileWriteLine ($file, "00100021:C.I. uruguaya")
endif
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
FileWriteLine ($file, "00204000:"&$Coment)
;# StudyID (0020,0010) 
FileWriteLine ($file, "00200010:")
;# (0008,1030) StudyDescription
FileWriteLine ($file, "00081030:"&$Desc_estud)
;# StudyDate
FileWriteLine ($file, "00080020:"&@YEAR&@MON&@MDAY)
;# StudyTime
FileWriteLine ($file, "00080030:"&@HOUR&@MIN&@SEC)
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
FileWriteLine ($file, "00080070:IMAGOJO 1.24")


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