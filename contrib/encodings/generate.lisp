;;;  -*- Mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;;  Copyright (c) 2009, Giuseppe Attardi.
;;;
;;;    This program is free software; you can redistribute it and/or
;;;    modify it under the terms of the GNU Library General Public
;;;    License as published by the Free Software Foundation; either
;;;    version 2 of the License, or (at your option) any later version.
;;;
;;;    See file '../Copyright' for full details.

(defun read-mapping (url)
  (let ((command (format nil "curl \"~A\" | sed '/^#.*$/d;s,0x,#x,g;s,#UNDEFINED,NIL # UNDEFINED,g;/LEAD BYTE/d' | sed 's,# .*$,,g;/#x.*/!d' > tmp.txt" url)))
    (unless (zerop (si::system command))
      (error "Unable to retrieve file ~A" url)))
  (with-open-file (s "tmp.txt" :direction :input :external-format :utf-8)
    (do ((output '())
	 (line (read-line s nil nil) (read-line s nil nil)))
	((null line))
      (print line)
      (with-input-from-string (aux line)
	(let ((byte 0)
	      (unicode 0))
	  (when (and (setf byte (read aux nil nil))
		     (setf unicode (read aux nil nil)))
	    (push (cons byte unicode) output))))))
  (unless output
    (error "Error reading file ~A" url))
  (si::system "rm -f tmp.txt")
  output)

(defun generate-mapping (name url)
  (let* ((name (string-upcase name))
	 (symbol (intern name (find-package "EXT")))
	 (filename name)
	 (mapping (read-mapping url)))
    (format t "~&;;; Generating ~A from ~A" name url)
    (force-output t)
    (with-open-file (s filename :direction :output :if-exists :supersede)
      (let ((*print-circle* t)
	    (*print-pretty* t))
	(print mapping s)))))

(defconstant +all-mappings+
  '(("ATARIST" . "http://unicode.org/Public/MAPPINGS/VENDORS/MISC/ATARIST.TXT")

    ("ISO-8859-1" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-1.TXT")
    ("ISO-8859-2" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-2.TXT")
    ("ISO-8859-3" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-3.TXT")
    ("ISO-8859-4" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-4.TXT")
    ("ISO-8859-5" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-5.TXT")
    ("ISO-8859-6" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-6.TXT")
    ("ISO-8859-7" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-7.TXT")
    ("ISO-8859-8" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-8.TXT")
    ("ISO-8859-9" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-9.TXT")
    ("ISO-8859-10" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-10.TXT")
    ("ISO-8859-11" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-11.TXT")
    ("ISO-8859-13" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-13.TXT")
    ("ISO-8859-14" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-14.TXT")
    ("ISO-8859-15" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-15.TXT")
    ("ISO-8859-16" . "http://unicode.org/Public/MAPPINGS/ISO8859/8859-16.TXT")
    ("KOI8-R" . "http://unicode.org/Public/MAPPINGS/VENDORS/MISC/KOI8-R.TXT")
    ("KOI8-U" . "http://unicode.org/Public/MAPPINGS/VENDORS/MISC/KOI8-U.TXT")
    ("CP-856" . "http://unicode.org/Public/MAPPINGS/VENDORS/MISC/CP856.TXT")
    ("CP-856" . "http://unicode.org/Public/MAPPINGS/VENDORS/MISC/CP856.TXT")
    
    ("DOS-CP437" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP437.TXT")
    ("DOS-CP737" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP737.TXT")
    ("DOS-CP775" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP775.TXT")
    ("DOS-CP850" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP850.TXT")
    ("DOS-CP852" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP852.TXT")
    ("DOS-CP855" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP855.TXT")
    ("DOS-CP857" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP857.TXT")
    ("DOS-CP860" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP860.TXT")
    ("DOS-CP861" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP861.TXT")
    ("DOS-CP862" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP862.TXT")
    ("DOS-CP863" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP863.TXT")
    ("DOS-CP864" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP864.TXT")
    ("DOS-CP865" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP865.TXT")
    ("DOS-CP866" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP866.TXT")
    ("DOS-CP869" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP869.TXT")
    ("DOS-CP874" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP874.TXT") 

    ; Redundant WINDOWS-CP874 DOS-CP874
    ;("WINDOWS-CP874" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP874.TXT")

    ; Too large: not in default image.
    ;("WINDOWS-CP932" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP932.TXT")
    ;("WINDOWS-CP936" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP936.TXT")
    ;("WINDOWS-CP949" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP949.TXT")
    ;("WINDOWS-CP950" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP950.TXT")

    ("WINDOWS-CP1250" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1250.TXT")
    ("WINDOWS-CP1251" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1251.TXT")
    ("WINDOWS-CP1252" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1252.TXT")
    ("WINDOWS-CP1253" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1253.TXT")
    ("WINDOWS-CP1254" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1254.TXT")
    ("WINDOWS-CP1255" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1255.TXT")
    ("WINDOWS-CP1256" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1256.TXT")
    ("WINDOWS-CP1257" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1257.TXT")
    ("WINDOWS-CP1258" . "http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1258.TXT")
    ))

(loop for (name . url) in +all-mappings+
   for orig = (merge-pathnames name "ext:encodings;")
   for copy = (ensure-directories-exist (merge-pathnames name "build:encodings;"))
   do (progn
	(unless (probe-file orig)
	  (error)
	  (generate-mapping name url))
	(format t "~%;;; Copying ~A to ~A" orig copy)
	(with-open-file (in orig :direction :input)
	  (with-open-file (out copy :direction :output :if-exists :supersede
			       :if-does-not-exist :create)
	    (loop for line = (read-line in nil nil)
	       while line
	       do (write-line line out))))))

(defconstant +aliases+
  '((:us-ascii :ascii)
    (:utf8 :utf-8)
    (:ucs-2 :ucs2 :utf-16 :unicode)
    (:ucs-2le :ucs2le :utf-16le)
    (:ucs-2be :ucs2be :utf-16be)
    (:ucs-4 :ucs4 :utf-32)
    (:ucs-4be :ucs4be :utf-32be)
    (:ucs-4le :ucs4le :utf-32le)

    (:koi8-r :koi8r)
    
    (:iso-8859-1 :latin-1 :latin1)
    (:iso-8859-2 :latin-2 :latin2)
    (:iso-8859-3 :latin-3 :latin3)
    (:iso-8859-4 :latin-4 :latin4)
    (:iso-8859-5 :latin-5 :latin5 :cyrillic)
    (:iso-8859-6 :latin-6 :latin6 :arabic)
    (:iso-8859-7 :latin-7 :latin7 :greek)
    (:iso-8859-8 :latin-8 :latin8 :hebrew)
    (:iso-8859-9 :latin-9 :latin9)
    (:iso-8859-10 :latin-10 :latin10)
    (:iso-8859-11 :latin-11 :latin11 :thai)
    (:iso-8859-15 :latin-0 :latin0)

    (:dos-cp437 :ibm437)
    (:dos-cp850 :ibm850)
    (:dos-cp852 :ibm852)
    (:dos-cp855 :ibm855)
    (:dos-cp857 :ibm857)
    (:dos-cp860 :ibm860)
    (:dos-cp861 :ibm861)
    (:dos-cp862 :ibm862)
    (:dos-cp863 :ibm863)
    (:dos-cp864 :ibm864)
    (:dos-cp865 :ibm865)
    (:dos-cp866 :ibm866)
    (:dos-cp869 :ibm869)

    (:windows-1250 :windows-1250)
    (:windows-1251 :windows-1251)
    (:windows-1252 :windows-1252)
    (:windows-1253 :windows-1253)
    (:windows-1254 :windows-1254)
    (:windows-1255 :windows-1255)
    (:windows-1256 :windows-1256)
    (:windows-1257 :windows-1257)
    (:windows-1258 :windows-1258)
    ))

(loop for (name . aliases) in +aliases+
   do (loop for alias in aliases
	 for filename0 = (merge-pathnames (symbol-name alias) "build:encodings;")
	 for filename = (ensure-directories-exist filename0)
	 do (with-open-file (out filename :direction :output :if-exists :supersede
				 :if-does-not-exist :create :element-type 'base-char)
	      (format t "~%;;; Creating alias ~A -> ~A, ~A" alias name filename)
	      (princ name out))))