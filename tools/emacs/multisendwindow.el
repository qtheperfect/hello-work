(defun multisendwindow()
  ;; open thunderbird window and send the marked files in dired by email
  (interactive)
  (setq zfolder (format-time-string "%Y%m%d_%H%M%S"))
  (defun strEscape (s) (concat "'" s "'"))
  (setq fnames (mapconcat 'strEscape (dired-get-marked-files) " "))
  (shell-command (format "7za a /tmp/multisendfiles/%s.7z %s" zfolder fnames))
  (shell-command (format "7za l /tmp/multisendfiles/%s.7z > /tmp/multisendfiles/%s.list.txt" zfolder zfolder))
  (shell-command (format "thunderbird -compose attachment=/tmp/multisendfiles/%s.7z,message=/tmp/multisendfiles/%s.list.txt" zfolder zfolder)))
