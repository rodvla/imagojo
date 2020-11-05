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