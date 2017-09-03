;;; package --- Summary
;;; Commentary:
;;; Code:

;; Vars
(defvar org-person-directory nil
  "Directory where person's information will be stored in.")

;; Private
(defun org-person--create-file-name (person-id)
  "Creates file-name for person with PERSON-ID."
  (format "person-%s.org" person-id))

(defun org-person--try-setup ()
  "Tries to setup org-person."
  (if (and org-person-directory
           (stringp org-person-directory))
      (f-mkdir org-person-directory)
    (error "`org-person-directory' is not setup")))

;; Public
(defun org-person-new (person-id)
  "Create new person."
  (org-person--try-setup)
  (find-file (f-join org-person-directory
                     (org-person--create-file-name person-id))))

(defun org-person-open (person-id)
  "Find a file with PERSON-ID."
  (unless (f-dir-p org-person-directory)
    (error "`org-person-directory' is not setup"))
  (unless (f-file-p (f-join org-person-directory
                            (org-person--create-file-name person-id)))
    (error "There is no person with person-id: %s" person-id))
  (find-file (f-join org-person-directory
                     (org-person--create-file-name person-id))))



(provide 'org-person)
;;; org-person.el ends here
