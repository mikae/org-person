(require 'org-person)
(require 'f)

(defconst --org-person-directory "/tmp/--org-person-home")

(defun --clear ()
  (setq org-person-directory nil)
  (when (f-dir-p --org-person-directory)
    (delete-directory --org-person-directory :recursive)))

(defun --setup ()
  (setq org-person-directory --org-person-directory)
  (org-person--try-setup))

(describe "New person."
          (describe "Throws errors"
                    (before-each
                     (--clear))

                    (it "throws an error if org-person-directory is not setup"
                        (should-error (org-person-new "test"))))

          (describe "Configures directories"
                    (before-each
                     (--clear))

                    (it "setups directories if they are not created"
                        (setq org-person-directory --org-person-directory)
                        (org-person-new "test")
                        (expect (f-dir-p --org-person-directory)
                                :to-be t)))

          (describe "Creates person directories"
                    (before-each
                     (--clear)
                     (--setup))

                    (it "creates new dir with person's info"
                        (--setup)
                        (org-person-new "test")
                        (save-buffer)
                        (kill-buffer)
                        (expect (f-dir-p (f-join --org-person-directory
                                                 "test")))
                        (expect (f-file-p (f-join --org-person-directory
                                                  "test"
                                                  "person.org"))))
                    (it "creates multiple directories with persons' infos"
                        (--setup)
                        (org-person-new "test-1")
                        (save-buffer)
                        (kill-buffer)
                        (org-person-new "test-2")
                        (save-buffer)
                        (kill-buffer)
                        (expect (f-dir-p (f-join --org-person-directory
                                                 "test-1")))
                        (expect (f-file-p (f-join --org-person-directory
                                                  "test-1"
                                                  "person.org")))
                        (expect (f-dir-p (f-join --org-person-directory
                                                 "test-2")))
                        (expect (f-file-p (f-join --org-person-directory
                                                  "test-2"
                                                  "person.org"))))))

(describe "Open person."
          (describe "Throws errors"
                    (before-each
                     (--clear))

                    (it "throws an error if org-person-directory is not setup"
                        (should-error (org-person-open "test")))

                    (it "throws an error if there is no file with person id"
                        (--setup)
                        (should-error (org-person-open "test"))))
          (it "Opens file"
              (--clear)
              (--setup)
              (org-person-new "test")
              (save-buffer)
              (kill-buffer)
              (org-person-open "test")
              (expect buffer-file-name
                      :to-equal (f-join org-person-directory
                                        "test"
                                        "person.org"))))
