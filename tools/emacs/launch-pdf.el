
(defun lists-multiply-two (l1 l2)
  (cond
   ((null l1) nil)
   (t (append (mapcar (lambda (x2) (concat (car l1) x2)) l2) (lists-multiply-two (cdr l1) l2)))))

(defun file-path-confirm (p)
  (cond
   ((file-regular-p p) p)
   ((file-symlink-p p) p)
   (t nil)
   ))

(defun launch-pdf-tryfiles (this-doc)
  (let* (;;(this-doc (reftex-this-word "^{}%\n\r,# \t") )
	 (possible-names (mapcar (lambda (f) (concat "/" this-doc f)) '(".pdf" ".djvu" "")))
	 (possible-paths (mapcar 'eval '(default-directory (concat default-directory "/.bib-pile/"))))
	 (possible-files (seq-filter 'file-path-confirm (lists-multiply-two possible-paths possible-names))))
    (and
     (print possible-files)
     possible-files
     (start-process "readme" nil "okular" (car possible-files))
     )
    ;;(start-process (concat "okular " last-opened-from-ref))
   ;; (insert (mapconcat 'identity possible-paths ", "))
    )
  )

(defun launch-pdf ()
  ;; Discern the possible pdf-file names from the buffer and try to launch with okular
  (interactive)
  (let ((this-doc (reftex-this-word "^{}%\n\r,# \t") ))
    (launch-pdf-tryfiles this-doc)
    )
  )

