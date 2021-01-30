(defun comfort-open()
  ;; open the file using some shell command with comfort
  (interactive)
  (setq xdgcmd (read-string "cmd:" "  " "evince %s") )
  (if (string-match " %s" xdgcmd)
      (shell-command (concat
		      (format xdgcmd (concat " \"" (dired-get-filename) "\" " ))
		      "&"))
    (shell-command (concat xdgcmd  " \"" (dired-get-filename) "\" &")))
  )
