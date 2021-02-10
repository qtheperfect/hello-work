(defun run-rsyncWhat-from (dir)
  "See run-rsyncWhat which is fulfilled by recursively calling this"
  (defun parent-dirname (filepath)
    (file-name-directory (directory-file-name filepath)))
  (cond
   ((not (or (file-regular-p dir) (file-directory-p dir))) nil)
   ((equal "/" dir) nil)
   ((file-regular-p (concat dir "rsyncWhat.sh"))
    (shell-command (concat "bash " dir "/rsyncWhat.sh up -y &")))
   (t (run-rsyncWhat-from (parent-dirname dir)))))

(defun run-rsyncWhat ()
  "Find the closest bash script in parent paths named 'rsyncWhat.sh' \
 and run it so as to automatically update files to a remote server"
  (interactive)
  (run-rsyncWhat-from default-directory))
  
  
