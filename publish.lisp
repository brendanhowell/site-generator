(in-package :site-generator)
;;;; ## Site publishing
(defun publish-site (dir)
  "Pathspec -> nil"
  (generate-site dir)
  (print-message "Publishing ~a" dir)
  (let ((server (getf (parse-content (merge-pathnames "config" *content-dir*))
		    :server)))
    (unless server
      (error "No server specified in the top-level config file."))
    (asdf/interface::run-program 
     (join-string-list (list "rsync"
			     "-CvaLz --copy-unsafe-links --del"
			     (namestring *site-dir*)
			     server))
     :output :interactive)))
