;; -*- Mode: Emacs-Lisp -*-
;; $Revision: 1.5 $

;; take care of some custom variables right up front
(custom-set-variables
 '(gutter-buffers-tab-enabled nil);;get rid of stupid themometer
 '(gutter-buffers-tab-visible nil);;get rid of stupid themometer
 '(load-home-init-file t t);;don't let XEmacs mangle my .emacs
 )

;;set faces up front
(custom-set-faces)

;; define a variable to tell us if we're running XEmacs/Lucid Emacs
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;;(setq stack-trace-on-error nil)

;; get the local stuff
;(cond ((eq system-type 'windows-nt)
;       (if (not running-xemacs)
;	   (local-customizations '(not HTC-shell-tweaks buffer-switch gnuserv supercite))
;	 (local-customizations '(not HTC-shell-tweaks buffer-switch gnuserv supercite)))
;       ;;Xemacs on NT gets in trouble with file-precious-flag set
;       (setq file-precious-flag nil)
;       )
;      )


;;Make sure XEmacs doesn't close unless I really want it to
(setq kill-emacs-query-functions
      (cons (lambda () (yes-or-no-p "Really kill Emacs? ")) kill-emacs-query-functions))

;;;;;;;;;;;
;;
;; Basic settings
;;
;;;;;;;;;;;;
(message "Basic settings")
;; toolbar stuff
(message "toolbar")
(set-default-toolbar-position 'top)
(set-specifier default-toolbar-visible-p nil)

(setq next-line-add-newlines nil;; no newlines at EOF
      mouse-yank-at-point t;; yank from current position, ignore mouse
      passwd-invert-frame-when-keyboard-grabbed nil;; don't invert on passwd
      inhibit-startup-message t;; no startup screen
      default-fill-column 75;; set width for auto fill
      default-major-mode 'text-mode;; set default mode
      kept-new-versions 1
      kept-old-versions 1
      delete-old-versions t
      version-control t
      shell-multiple-shells t;; allow multiple shell buffers
      browse-url-browser-function 'browse-url-netscape;; use netscape
      browse-url-new-window-flag t;; try to use a new window when browsing
      completion-ignore-case t          ;case insensitive file matching
      find-file-compare-truenames t;; watch out for symlinks
      ;;Manual-program "man"
      visible-bell t;; don't beep
      comint-password-prompt-regexp "\\(\\([Oo]ld \\|[Nn]ew \\|^\\|'s \\)[Pp]assword\\|pass phrase\\):\\s *\\'"
      scroll-step 5			; set how many lines to scroll at a time      
      )

;; set the title to make it easy to determine which XEmacs is running
(setq frame-title-format (concat "XEmacs@" (substring (system-name) 0 (search "." (system-name))) ": %b"))

;; Change all yes/no prompts to y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; turn on line numbers
(line-number-mode t)
;; turn on column numbers
(column-number-mode t)

;; turn off dialog boxes
(setq use-dialog-box nil)

;; move the mouse if it gets in the way
;;(mouse-avoidance-mode 'exile)

;;;;;;;;;;;
;;
;; System specific
;;
;;;;;;;;;;;;
(message "System specific")
(cond ((eq system-type 'windows-nt)
       ;;XEmacs on NT works better this way (I hope)
       (setq directory-sep-char ?/)

       (setq openoffice-executable "c:/packages/OpenOffice/program/soffice.exe")
       
       ;;----------------------------------------------------------------------------
       ;; Cygnus bash as subshell
       ;;
       ;; Prerequisit: Set the SHELL environment variable to bash before
       ;; starting emacs.  The variable shell-file-name is initialized to the
       ;; enviroment variable when emacs starts up.
       (setq shell-file-name "c:\\packages\\cygwin\\bin\\bash.exe"
	     ;; Make "M-x shell-command" use the same shell as "M-x shell"
	     explicit-shell-file-name shell-file-name)
       
       ;; Use -i to force .bashrc file to be run, otherwise aliases defined
       ;; in you .bashrc file will not be available.
       (setq shell-command-switch "-c")


       ;; nasty stuff to get cygwin 1.3.1 to work right
       (setq mswindows-construct-process-command-line-alist
	     '(("[\\/].?.?sh\\." . mswindows-construct-vc-runtime-command-line)
	       ("[\\/]command\\.com$" . mswindows-construct-command-command-line)
	       ("[\\/]cmd\\.exe$" . mswindows-construct-command-command-line)
	       ("" . mswindows-construct-vc-runtime-command-line)))
       ;;Set this to true when debugging processes
       ;;(setq debug-mswindows-process-command-lines nil)
       )
      ((eq system-type 'linux)
       (setq openoffice-executable "/opt/OpenOffice.org/program/soffice")
       ;;ls is screwed up somehow on SuSE >= 8.1, so I use the one from 8.0
       (setq dired-ls-program "ls-xemacs")
       )
      )


;;;;;;;;;;;
;;
;; Font Lock
;;
;;;;;;;;;;;;
(message "Font lock")
;;turn off stupid extra buffer when fontifying things
(setq progress-feedback-use-echo-area t)
(set-face-background 'default "light gray")
(setq font-lock-maximum-decoration t
      font-lock-use-colors '(color)
      font-lock-auto-fontify t
      font-lock-verbose nil ;; no messages while fontifying
      lazy-lock-stealth-verbose nil ;; no messages while fontifying
      fast-lock-cache-directories '("~/.xemacs/font-lock-cache")
      lazy-lock-stealth-time nil
      query-replace-highlight t
      font-menu-ignore-scaled-fonts nil
      )
(require 'font-lock)
(setq font-lock-support-mode 'fast-lock-mode)
(add-hook 'font-lock-mode-hook 'turn-on-fast-lock)
;;(add-hook 'font-lock-mode-hook 'turn-on-lazy-lock)
       
(set-face-foreground 'font-lock-warning-face "yellow")
(set-face-background 'font-lock-warning-face "red")


;;;;;;;;;;;
;;
;; Printing
;;
;;;;;;;;;;;;
(message "Printing")
(setq lpr-command "kprinter"
      lpr-switches '("--stdin");;(list "-r" "-G" "-b\"- jschewe -\"")
      ps-print-header-frame nil		; save some toner
      vm-print-command "kprinter"
      vm-print-command-switches '("--stdin")
      )


;;;;;;;;;;;
;;
;; Parens
;;
;;;;;;;;;;;;
(message "Parens")
(paren-set-mode 'paren)
;; make parens show the text before the paren in the minibuffer
(setq paren-backwards-message t)


;;;;;;;;;;;
;;
;; Grep
;;
;;;;;;;;;;;;
(message "grep")
;;change the default to be my perl script
(setq grep-command "rgrep -n ")


;;;;;;;;;;;
;;
;; comint
;;
;;;;;;;;;;;;
(message "comint")
(require 'comint)

(defun rlogin-hook-jps ()
  (comint-common-hook-jps)
  )
  
(defun comint-common-hook-jps ()
  (local-set-key [up] 'comint-previous-matching-input-from-input)
  (local-set-key [down] 'comint-next-matching-input-from-input)
  (local-set-key "\C-cc" 'comint-continue-subjob)
  (turn-off-font-lock)
  )

(add-hook 'gdb-mode-hook 'comint-common-hook-jps)
(add-hook 'shell-mode-hook 'comint-common-hook-jps)
(add-hook 'rlogin-mode-hook 'rlogin-hook-jps)

(defun ssh-hook-jps ()
  (comint-common-hook-jps)
  (setq comint-process-echoes nil);;some do and some don't, so leave the extra copies in there
  ;;(add-to-list 'comint-output-filter-functions 'comint-strip-ctrl-m)
  ;;(ssh-directory-tracking-mode 1) ;;track via NFS
  )
(add-hook 'ssh-mode-hook 'ssh-hook-jps)

;;;;;;;;;;;
;;
;; ksh-mode
;;
;;;;;;;;;;;;
(message "ksh-mode")
(defun ksh-mode-hook-jps ()
  (setq indent-tabs-mode nil)
  (font-lock-mode)
  )
(add-hook 'ksh-mode-hook  'ksh-mode-hook-jps)

;;;;;;;;;;;
;;
;; text-mode
;;
;;;;;;;;;;;;
(message "text-mode")
;; Turn on word-wrap in text modes
(add-hook 'text-mode-hook 'turn-on-auto-fill)


;;;;;;;;;;;
;;
;; Changelog
;;
;;;;;;;;;;;;
(message "Changelog")
(add-hook 'changelog-mode-hook 'turn-on-auto-fill)


;;;;;;;;;;;
;;
;; Scheme
;;
;;;;;;;;;;;;
(message "Scheme")
(add-hook 'scheme-mode-hook (lambda () (camelCase-mode 1)))
(add-to-list 'auto-mode-alist '("\\.ss$" . scheme-mode))

;;;;;;;;;;;
;;
;; Lisp
;;
;;;;;;;;;;;;
(message "Lisp")
(add-hook 'lisp-mode-hook (lambda () (camelCase-mode 1)))
(add-to-list 'auto-mode-alist  '("\\.alt$" . lisp-mode))
(add-to-list 'auto-mode-alist  '("\\.lib$" . lisp-mode))

;;;;;;;;;;;
;;
;; HTML
;;
;;;;;;;;;;;;
(message "HTML")
(add-hook 'html-mode-hook (lambda ()
			    (camelCase-mode 1)
			    (auto-fill-mode -1)
			    ))


;;;;;;;;;;;
;;
;; Dired
;;
;;;;;;;;;;;;
(message "Dired")
(defun dired-load-hook-jps ()
  (define-key dired-mode-map "q" 'kill-this-buffer)
  (define-key dired-mode-map "^" 'dired-jump-back)
  (define-key dired-mode-map " " 'scroll-up)
  (define-key dired-mode-map "b" 'scroll-down)
  (setq dired-gnutar-program "tar")
  (setq dired-unshar-program "unshar")

  ;;initialize to empty
  (setq dired-auto-shell-command-alist nil)
	    
  ;;palm pilot stuff
  (when (eq system-type 'linux)
    (add-to-list 'dired-auto-shell-command-alist '("\\.pdb$" "pilot-xfer -i"))
    (add-to-list 'dired-auto-shell-command-alist '("\\.prc$" "pilot-xfer -i")))

  ;;images
  (let ((extensions '("ps" "jpg" "bmp" "pbm" "pgm" "ppm" "xbm" "xpm" "ras" "rast" "gif" "tif" "tiff" "png")))
    ;;gimp
    (when (eq system-type 'linux)
      (map 'list '(lambda (ext)
		    (add-to-list 'dired-auto-shell-command-alist (list (concat "\\." ext "$") "gimp"))) extensions))
    ;;display
    (when (eq system-type 'linux)
      (map 'list '(lambda (ext)
		    (add-to-list 'dired-auto-shell-command-alist (list (concat "\\." ext "$") "display"))) extensions))
    )
  
  ;;bzip
  (add-to-list 'dired-auto-shell-command-alist '("\\.bz2$" "bunzip2"))
  (add-to-list 'dired-auto-shell-command-alist '("\\.tar.bz2$" "tar --bzip2 -xvf"))
  (add-to-list 'dired-auto-shell-command-alist '("\\.tar.bz2$" "tar --bzip2 -tf"))

  ;;office documents
  (add-to-list 'dired-auto-shell-command-alist '("\\.doc$" openoffice-executable))
  (add-to-list 'dired-auto-shell-command-alist '("\\.sxw$" openoffice-executable))
  (add-to-list 'dired-auto-shell-command-alist '("\\.xls$" openoffice-executable))
  (add-to-list 'dired-auto-shell-command-alist '("\\.sxc$" openoffice-executable))
  (add-to-list 'dired-auto-shell-command-alist '("\\.sdc$" openoffice-executable))
  (add-to-list 'dired-auto-shell-command-alist '("\\.ppt$" openoffice-executable))
  (add-to-list 'dired-auto-shell-command-alist '("\\.sxi$" openoffice-executable))
  (add-to-list 'dired-auto-shell-command-alist '("\\.rtf$" openoffice-executable))
  
  ;;Protege
  (add-to-list 'dired-auto-shell-command-alist '("\\.prj$" "protege"))

  ;;zip
  (when (or (eq system-type 'linux) (eq system-type 'usg-unix-v))
    (add-to-list 'dired-auto-shell-command-alist '("\\.zip$" "unzip")))

  ;;adobe
  (add-to-list 'dired-auto-shell-command-alist '("\\.pdf$" "acroread"))

  ;;dos/windows executables
  (when (eq system-type 'windows-nt)
    (add-to-list 'dired-auto-shell-command-alist '("\\.exe$" "*f")))

  ;;java
  (add-to-list 'dired-auto-shell-command-alist '("\\.jar$" "jar -xvf"))
  (add-to-list 'dired-auto-shell-command-alist '("\\.jar$" "jar -tvf"))

  ;; default windows handling
  (when (eq system-type 'windows-nt)
    (add-to-list 'dired-auto-shell-command-alist (list ".*"
						       (expand-file-name "winrun" (locate-data-directory "config-jps")))))

  
  (setq dired-compression-method 'gzip)
  )
(add-hook 'dired-load-hook 'dired-load-hook-jps)

(defun dired-mode-hook-jps ()
  (dired-omit-toggle t)
  )
(add-hook 'dired-mode-hook 'dired-mode-hook-jps)

(require 'dired)
(load-library "dired-shell")

;;autorevert directories
;;(defadvice dired-internal-noselect (before my-auto-revert-dired activate)
;;  (let ((buffer)(dirname (ad-get-arg 0)))
;;    (when (and (not (consp dirname))
;;               (setq buffer (dired-find-buffer-nocreate dirname nil)))
;;      (set-buffer buffer)
;;      (if (let ((attributes (file-attributes dirname))
;;                (modtime (visited-file-modtime)))
;;            (or (eq modtime 0)
;;                (not (eq (car attributes) t))
;;                (and (= (car (nth 5 attributes)) (car modtime))
;;                     (= (nth 1 (nth 5 attributes)) (cdr modtime)))))
;;          nil
;;        (kill-buffer buffer)))))



;;;;;;;;;;;
;;
;; Script-mode
;;
;;;;;;;;;;;;
;(message "script-mode")
;(defun delete-from-auto-mode-alist-jps (mode)
;  (delete-if #'(lambda (assoc)
;                 (eq (cdr assoc) mode))
;             auto-mode-alist))
;
;(delete-from-auto-mode-alist-jps 'html-mode)
;(delete-from-auto-mode-alist-jps 'sh-mode)
  
;; stuff for script.el
;;(setq interpreter-mode-alist
;;      (append
;;       ;; Note; these are strings, not regexps.
;;       ;; Use script-bash-mode not script-sh-mode for the first one
;;       ;;   if your shell is actually bash.
;;       '(( "sh" . script-sh-mode )  
;;         ( "bash" . script-bash-mode )
;;         ( "awk" . script-awk-mode )
;;         ( "gawk" . script-awk-mode )
;;         ( "nawk" . script-awk-mode )
;;         ( "tcsh" . script-csh-mode )
;;         ( "csh" . script-csh-mode ))
;;       interpreter-mode-alist))
;;(setq auto-mode-alist
;;      (append '(
;;                ("\\.awk$"  . script-awk-mode);; (replaces std awk-mode)
;;                ("\\.sh$" . script-bash-mode)
;;                )
;;              auto-mode-alist))
;;(autoload 'script-sh-mode "script" "editing mode for sh scripts" t)
;;(autoload 'script-bash-mode "script" "editing mode for bash scripts" t)
;;(autoload 'script-csh-mode "script" "editing mode for csh scripts" t)
;;(autoload 'script-awk-mode "script" "editing mode for awk scripts" t)
;;(setq script-auto-indent t)
;;
;;(defun script-mode-hook-jps ()
;;  (turn-on-lazy-lock)
;;  )
;;(add-hook 'script-mode-hook 'script-mode-hook-jps)



;;;;;;;;;;;
;;
;; c-mode
;;
;;;;;;;;;;;;
(message "c-mode")
(defun c-mode-common-hook-jps ()
  (setq indent-tabs-mode nil);; no tabs in source code
  ;; customize cc-mode
  ;;(c-set-offset 'substatement-open 
  ;;		  )
  ;;    (defvar c-hanging-braces-alist '((block-open before after)
  ;;				     (block-close before after)
  ;;				     (class-close before)
  ;;				     (inline-open before)
  ;;				     (inline-close after)
  ;;				     (substatement-open before after)))
  ;;    (defvar c-cleanup-list '(scope-operator
  ;;			     empty-defun-braces
  ;;			     defun-close-semi))
  
  ;; other customizations here
  (make-local-variable 'c-basic-offset)
  (setq c-basic-offset 2
        tab-width 2
        fill-column 78)
  ;;(c-toggle-hungry-state t)
  ;;(turn-on-auto-fill)

  ;; keybindings for both C and C++.  We can put these in c-mode-map
  ;; because c++-mode-map inherits it
  (define-key c-mode-map "\C-m" 'newline-and-indent)
  (define-key c-mode-map "\C-cc" 'compile)
  (define-key c-mode-map "\C-cr" 'replace-string)

  ;; setup some compile stuff
  (add-hook 'c-mode-hook
	    '(lambda () (or (file-exists-p "makefile") (file-exists-p "Makefile")
			    (progn 
			      (make-local-variable 'compile-command)  
			      (setq compile-command
				    (concat "gmake -j2 "
					    buffer-file-name))))))

  (c-set-offset 'class-close -2)
  ;;(c-set-offset 'c-brace-offset -2)
  (setq c-block-comment-prefix "* ")
  )

(add-hook 'c-mode-common-hook 'c-mode-common-hook-jps)

(defun c++-insert-header ()
  "Insert header denoting C++ code at top of buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert "// "
            "Hey, XEmacs this is "
            "-*- C++ -*-"
            "\n\n")))

;; Tell cc-mode not to check for old-style (K&R) function declarations.
;; This speeds up indenting a lot.
;;(setq c-recognize-knr-p nil)


;;;;;;;;;;;
;;
;; compile
;;
;;;;;;;;;;;;
(message "Compile")
(setq compilation-always-signal-completion nil
      compilation-read-command nil
      compile-highlight-display-limit 1024
      compilation-ask-about-save nil)
(add-hook 'compilation-mode-hook 'turn-off-font-lock)

;;Make sure compilation mode finds the right file when instrumenting Java code
(defun compilation-filter-hook-jps ()
  (interactive)
  (save-excursion
    ;;(goto-char (process-mark (get-buffer-process (current-buffer))))
    ;;Just want to search over the last set of stuff, so exchange point and mark?
    ;;(exchange-point-and-mark t) ;;doesn't work for first compile...
    (let* ((point-marker (point-marker))
	   (end (process-mark (get-buffer-process (current-buffer))))
	   (beg (or (and (boundp 'comint-last-output-start)
			 comint-last-output-start)
		    (- end (length string)))))
      (goto-char beg)
      (while (re-search-forward "[/\\\\]instrumented\\([/\\\\].\\)" nil t)
	(replace-match "/src\\1"))
      (goto-char point-marker))
    ))
(add-hook 'compilation-filter-hook 'compilation-filter-hook-jps)


;;;;;;;;;;;
;;
;; EDiff
;;
;;;;;;;;;;;;
(message "EDiff")
;;HACK to get ediff to work
(defun ediff-file-remote-p (file-name)
  nil)
(setq ediff-ignore-similar-regions t
      ediff-auto-refine t)


;;;;;;;;;;;
;;
;; Perl
;;
;;;;;;;;;;;;
(message "Perl")
(require 'cperl-mode)
(add-to-list 'perl-font-lock-keywords-1
	     '("\\<\\(FIX\\)" 1 font-lock-warning-face t))
(add-to-list 'perl-font-lock-keywords-1
	     '("\\<\\(HACK\\)" 1 font-lock-warning-face t))
(add-to-list 'perl-font-lock-keywords-1
	     '("\\<\\(TODO\\)" 1 font-lock-warning-face t))
(defun cperl-mode-hook-jps ()
  (setq tab-width 2)
  (setq indent-tabs-mode nil)
  (camelCase-mode 1)
  )
(add-hook 'cperl-mode-hook 'cperl-mode-hook-jps)
(add-to-list 'auto-mode-alist '("\\.cgi$" . perl-mode))

;;;;;;;;;;;
;;
;; Java
;;
;;;;;;;;;;;;
(message "Java")
(add-to-list 'auto-mode-alist '("\\.template$" . jde-mode))
(add-to-list 'auto-mode-alist '("\\.jass$" . jde-mode))
(add-to-list 'auto-mode-alist '("\\.jad$" . jde-mode))
(add-to-list 'auto-mode-alist '("\\.xjava$" . jde-mode))

;;basic setup
(setq java-home (getenv "JAVA_HOME"))

(defun java-mode-hook-jps ()
  (make-local-variable 'compile-command)
  (setq compile-command (concat "javac -deprecation -g -J-mx64m "
				(file-name-nondirectory
				 (buffer-file-name))))
  (define-key java-mode-map "\C-cc" 'compile)
  (define-key java-mode-map (concat prefix-key-jps "p") 'insert-package-name-jps)
  (define-key java-mode-map (concat prefix-key-jps "l") 'insert-class-name-jps)
  (define-key java-mode-map (concat prefix-key-jps "e") 'check-java-imports-jps)
  (define-key java-mode-map [(control ?c) (control ?v) (control ?i)] 'jde-import-organize-jps)
  (define-key java-mode-map "\C-cr" 'replace-string)
  (c-set-offset 'inexpr-class 0)	;Don't indent inner classes too much
  (c-set-offset 'class-close 'c-lineup-close-paren) ;Line up end of class
  )
(add-hook 'java-mode-hook 'java-mode-hook-jps)

(set-register ?n "System.getProperty(\"line.separator\")")

(require 'jde)

;;JDE seems to need this for something
(setq system-name (system-name))

;ignore assert files from ant compilation
(setq completion-ignored-extensions (append '(".assert") completion-ignored-extensions))

(when (eq system-type 'windows-nt)
  (require 'jde-ant)
  (require 'jde)
  ;;fix bug with wrong signal being sent to running processes
  (define-key jde-run-mode-map "\C-c\C-c" 'comint-kill-subjob)
  )

(custom-set-variables
 '(jde-run-option-debug '(nil "Attach" nil)) ;;don't open a socket for the debugger
 '(jde-build-function '(jde-ant-build))
 '(jde-ant-home "/opt/jakarta/ant");;FIX need to make this machine independant
 '(jde-ant-read-target t);;prompt for the target name
 '(jde-ant-enable-find t);;make jde-ant look for the build file
 '(jde-ant-complete-target nil);;don't try and parse the build file for me
 '(jde-import-excluded-packages '("\\(bsh.*\\|sched-infra.*\\|com.sun.*\\|sunw.*\\|sun.*\\|org.gjt.mm.mysql.*\\)"))
 '(jde-compile-option-debug (quote ("all")))
 '(jde-auto-parse-buffer-interval 60)
 '(jde-bug-vm-includes-jpda-p t)
 '(jde-auto-parse-enable t)
 '(jde-import-sorted-groups 'asc)
 '(jde-import-group-of-rules
   (quote
    (
     ("^\\(net\\.mtu\\.eggplant\\.[^.]+\\([.][^.]+[.]\\)*\\)" . 1)
     ("^\\(com\\.honeywell\\.htc\\.[^.]+\\([.][^.]+[.]\\)*\\)" . 1)
     ("^\\(com\\.honeywell\\.[^.]+\\([.][^.]+[.]\\)*\\)" . 1)
     ;;("^javax?\\.")
     ("^\\([^.]+\\([.][^.]+[.]\\)*\\)" . 1)
     )))
 ;;see if this helps things at all 
 '(jde-project-context-switching-enabled-p t)
 ;;don't jump to the first error or remove the compilation buffer! 
 '(jde-ant-build-hook '(jde-compile-finish-refresh-speedbar 
			jde-compile-finish-flush-completion-cache)) 
 '(jde-compile-finish-hook '(jde-compile-finish-refresh-speedbar 
			     jde-compile-finish-flush-completion-cache))
 )

(defun jde-mode-hook-jps()
  ;;(modify-syntax-entry ?_ " ")
  (camelCase-mode 1)
  (diminish 'senator-minor-mode "Sen")
  ;;(senator-minor-mode nil)
  
  ;;cperl-mode seems to screw this one up, so just make it buffer local and
  ;;set to nil
  (make-variable-buffer-local 'fill-paragraph-function)
  (setq fill-paragraph-function nil)

  (add-to-list 'java-font-lock-keywords-4
	       '("\\<\\(FIX\\)" 1 font-lock-warning-face t))
  (add-to-list 'java-font-lock-keywords-4
	       '("\\<\\(HACK\\)" 1 font-lock-warning-face t))

  (make-face 'font-lock-todo-face)
  (set-face-parent 'font-lock-todo-face 'default)
  (set-face-foreground 'font-lock-todo-face "red")
  (add-to-list 'java-font-lock-keywords-4
	       '("\\<\\(TODO\\)" 1 font-lock-todo-face t))
  (add-to-list 'java-font-lock-keywords-4
	       '("\\<\\(NOTE\\)" 1 font-lock-todo-face t))
  (add-to-list 'java-font-lock-keywords-4
	       '("\\<\\(\\?\\?\\?\\)" 1 font-lock-todo-face t))
  )
(add-hook 'jde-mode-hook 'jde-mode-hook-jps)

(defun jde-import-organize-jps ()
  (interactive)
  (jde-import-organize t))

(add-hook 'jde-run-mode-hook 'turn-off-font-lock)

;; Tomcat
;;FIX need to make sure this is configured by the OS
(cond ((eq system-type 'windows-nt)
       (setq catalina-home "c:/packages/Apache-Tomcat-4.0"))
      ((eq system-type 'linux)
       (setq catalina-home "/opt/jakarta/tomcat")))

(defun insert-class-name-jps ()
  (interactive)
  (insert (replace-in-string (file-name-nondirectory (buffer-file-name))
			     ".java" "")))

(defun check-java-imports-jps ()
  (interactive)
  (compile (concat "imports.pl "
		   (get-java-file-jps))))

(defun get-java-file-jps ()
  (interactive)
  (file-name-nondirectory (expand-file-name buffer-file-name)))

(defun insert-package-name-jps ()
  (interactive)
  (insert (concat "package "
		  (replace-in-string
		   (replace-in-string
		    (replace-in-string
		     (if (eq nil jde-run-working-directory)
			 (file-name-directory (buffer-file-name))
		       (replace-in-string (file-name-directory
					   (buffer-file-name)) (expand-file-name jde-run-working-directory) "")
		       )
		     "/" "\\.")
		    "\\.$" "")
		   "^\\." "")
		  ";\n")))

(defun get-java-class-file-jps ()
  (interactive)
  (replace-in-string (get-java-file-jps)
                     ".java"
                     ".class"))


;;;;;;;;;;;
;;
;; SGML
;;
;;;;;;;;;;;;
(message "SGML")
(defun sgml-mode-hook-jps ()
  (setq indent-tabs-mode nil)
  (font-lock-mode)
  )
(add-hook 'sgml-mode-hook  'sgml-mode-hook-jps)

(make-face 'sgml-comment-face)
(set-face-parent 'sgml-comment-face 'default)
(set-face-foreground 'sgml-comment-face "darkblue")
(make-face 'sgml-start-tag-face)
(set-face-parent 'sgml-start-tag-face 'default)
(set-face-foreground 'sgml-start-tag-face "black")
(make-face 'sgml-end-tag-face)
(set-face-parent 'sgml-end-tag-face 'default)
(set-face-foreground 'sgml-end-tag-face "SeaGreen")
(make-face 'sgml-entity-face)
(set-face-parent 'sgml-entity-face 'default)
(set-face-foreground 'sgml-entity-face "Red")
(make-face 'sgml-doctype-face)
(set-face-parent 'sgml-doctype-face 'default)
(set-face-foreground 'sgml-doctype-face "White")

;;my own catalog for dtds
(require 'psgml)
(add-to-list 'sgml-catalog-files
             (expand-file-name "~/.xemacs/xemacs-packages/etc/CATALOG" (locate-data-directory "config-jps")))

(setq sgml-auto-activate-dtd nil	; don't parse dtd right away
      sgml-warn-about-undefined-elements nil ; don't complain about unknown elements
      sgml-warn-about-undefined-entities nil ; don't complain about unknown entities
      )

(setq sgml-set-face t)			; without this, all SGML text is in same color
(setq sgml-markup-faces
      '((comment   . sgml-comment-face)
	(start-tag . sgml-start-tag-face)
	(end-tag   . sgml-end-tag-face)
	(doctype   . sgml-doctype-face)
	(entity    . sgml-entity-face)))

(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)
(add-to-list 'auto-mode-alist '("\\.xml$"  . sgml-mode))



;;;;;;;;;;;
;;
;; CamelCase
;;
;;;;;;;;;;;;
(message "CamelCase")
(load-library "camelCase-mode")


;;;;;;;;;;;
;;
;; Mail
;;
;;;;;;;;;;;;
(message "Mail")
(require 'vm)

;;always use vm for mail
(global-set-key "\C-xm" 'vm-mail)

(eval-after-load "vm"
  (progn
    (cond ((eq system-type 'windows-nt)
	   (setq vm-primary-inbox "n:/users/jschewe/Mail/INBOX"
		 mail-archive-file-name "n:/users/jschewe/Mail/sent"
		 vm-folder-directory "n:/users/jschewe/Mail/"
		 )
	   (add-to-list 'vm-mime-attachment-auto-suffix-alist '("application/msword"  . ".doc"))
	   (add-to-list 'vm-mime-attachment-auto-suffix-alist '("application/vnd.ms-excel"  . ".xls"))
	   (add-to-list 'vm-mime-attachment-auto-suffix-alist '("application/vnd.ms-powerpoint"  . ".ppt"))
	   (add-to-list 'vm-mime-attachment-auto-suffix-alist '("application/pdf"  . ".pdf"))
	   )
	  ((or (eq system-type 'linux) (eq system-type 'usg-unix-v))
	   (progn
	     (setq vm-primary-inbox "~/Mail/INBOX"
		   mail-archive-file-name "~/Mail/sent"
		   vm-folder-directory "~/Mail/")
	     ))
	  (t (setq vm-primary-inbox "~/Mail/INBOX"
		   mail-archive-file-name "~/Mail/sent"
		   vm-folder-directory "~/Mail/"
		   )))
    ;;common stuff
    (setq user-mail-address
	  ;;"jon.schewe@honeywell.com";;FIX need to configure based on system
	  "jpschewe@mtu.net"
	  ;;"jpschewe@users.sourceforge.net"
	  user-full-name "Jon Schewe"
	  mail-default-reply-to user-mail-address
	  mail-signature t
	  mail-signature-file "~/.signature"
	  message-default-headers (concat "Reply-To: " user-mail-address "\n")
	  mail-self-blind nil
	  vm-spool-files nil
	  vm-crash-box-suffix ".crash"
	  vm-spool-file-suffixes (list ".spool")
	  vm-auto-get-new-mail 60
	  vm-reply-ignored-addresses (list user-mail-address
					   "schewe_jon@htc.honeywell.com"
					   "jschewe@htc.honeywell.com"
					   "jon.schewe@honeywell.com"
					   "jpschewe@mtu.net"
					   )
	  vm-delete-after-saving t	; delete a message after I save it
	  vm-mime-use-w3-for-text/html t
	  vm-use-toolbar nil
	  vm-mutable-frames nil
	  vm-reply-subject-prefix "RE: "
	  vm-mime-external-content-types-alist
	  `(
	    ("application/msword" ,openoffice-executable)
	    ("application/vnd.ms-excel" ,openoffice-executable)
	    ("application/vnd.ms-powerpoint" ,openoffice-executable)
	    ("application/rtf" ,openoffice-executable)
	    ("application/msexcel" ,openoffice-executable)
	    ("application/pdf" "acroread")
	    )
	  vm-forwarding-subject-format "Fw: %s"
	  vm-forwarding-digest-type "mime" ;;rfc934, rfc1153, mime, nil
	  )
    
    (add-to-list 'vm-mime-default-face-charsets "Windows-1251")
    (add-to-list 'vm-mime-default-face-charsets "Windows-1252")
    (add-to-list 'vm-mime-default-face-charsets "Windows-1257")
    (add-to-list 'vm-mime-default-face-charsets "Windows-1255")
    (add-to-list 'vm-mime-default-face-charsets "utf-8")
    (add-to-list 'vm-mime-default-face-charsets "UTF8")
    (add-to-list 'vm-mime-default-face-charsets "iso-8859-15")
    (add-to-list 'vm-mime-default-face-charsets "X-UNKNOWN")

    (setq-default vm-summary-show-threads t)

    ;; try and speed composing messages
    (fset 'vm-update-composition-buffer-name 'ignore)

    t ;;make sure eval-after-load is happy
    ))

;; smtp
(load-library "smtpmail")
(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function send-mail-function)
(cond ((string-match "honeywell.com" (system-name))
       (setq smtp-server "smtp.honeywell.com"))
      ((string-match "mn.mtu.net" (system-name))
       (setq smtp-server "eggplant"))
      (T
       (setq smtp-server "mtu.net")))
;;(setq smtpmail-debug-info nil) ;;show trace buffer
;;(setq smtpmail-code-conv-from nil)

;;;;;;;;;;;
;;
;; GPG
;;
;;;;;;;;;;;;
(message "GPG")
(load-library "mailcrypt")
(mc-setversion "gpg")
(autoload 'mc-install-write-mode "mailcrypt" nil t)
(autoload 'mc-install-read-mode "mailcrypt" nil t)
(add-hook 'mail-mode-hook 'mc-install-write-mode)
;;for VM
(add-hook 'vm-mode-hook 'mc-install-read-mode)
(add-hook 'vm-summary-mode-hook 'mc-install-read-mode)
(add-hook 'vm-virtual-mode-hook 'mc-install-read-mode)
(add-hook 'vm-mail-mode-hook 'mc-install-write-mode)
;;for gnus
(add-hook 'gnus-summary-mode-hook 'mc-install-read-mode)
(add-hook 'message-mode-hook 'mc-install-write-mode)
(add-hook 'news-reply-mode-hook 'mc-install-write-mode)

;;;;;;;;;;;
;;
;; mspools
;;
;;;;;;;;;;;;
(message "Mspools")
(autoload 'mspools-show "mspools" "Show outstanding mail spools." t)
(setq mspools-update t
      mspools-folder-directory vm-folder-directory
      mspools-vm-system-mail (concat vm-primary-inbox ".spool"))


;;;;;;;;;;;
;;
;; BBDB
;;
;;;;;;;;;;;;
;;(message "BBDB")
;;(require 'bbdb)
;;(bbdb-initialize 'gnus 'sendmail 'message 'vm)

;;(add-hook 'mail-setup-hook 'bbdb-define-all-aliases)
(add-hook 'message-setup-hook 'mail-signature)
(add-hook 'vm-mode-hook 'font-lock-mode)

(defun mail-mode-hook-jps ()
  ;;(flyspell-mode-on)
  ;;(define-key mail-mode-map '(tab)  'bbdb-complete-name)
  (auto-save-mode nil))
(add-hook 'mail-mode-hook 'mail-mode-hook-jps)
(defun message-mode-hook-jps ()
  ;;(flyspell-mode-on)
;;(add-hook 'mail-send-hook 'flyspell-mode-off)
  (define-key mail-mode-map '(tab)  'bbdb-complete-name)
  )
(add-hook 'message-mode-hook 'message-mode-hook-jps)

;(setq bbdb-default-area-code 763)
;(setq bbdb/mail-auto-create-p nil
;      bbdb/news-auto-create-p nil
;      bbdb-use-pop-up nil
;      bbdb-offer-save "save"
;      )


;;;;;;;;;;;
;;
;; Supercite
;;
;;;;;;;;;;;;
(message "Supercite")
(setq sc-auto-fill-region-p           nil)
(autoload 'sc-cite-original "supercite" "Supercite 3.1" t)
(autoload 'sc-submit-bug-report "supercite" "Supercite 3.1" t)
(setq sc-confirm-always-p t)
(setq sc-citation-leader " ")
(setq sc-preferred-attribution-list
      '("x-attribution" "initials" "firstname" "lastname" "sc-lastchoice"))

;;(add-hook 'mail-citation-hook 'sc-cite-original)

;;(setq sc-preferred-attribution-list
;;      '("x-attribution" "sc-consult" "initials" "firstname" "lastname"
;;        "sc-lastchoice"))
;;(setq sc-attrib-selection-list '(
;;                                 ("from" (("foobared Kohler, Annika.*"
;;                                           . (list (car (mail-extract-address-components "\"Kohler, Annika (ON09)\" <Annika.Kohler@iac.honeywell.com>")))
;;                                           )))
;;                                 ))

;; for GNUS and RMAIL
(setq mail-citation-hook 'sc-cite-original)
  
;; for new GNUS message mode:
(setq message-cite-function 'sc-cite-original)



;;;;;;;;;;;
;;
;; Gnus
;;
;;;;;;;;;;;;
(message "Gnus")
(autoload 'gnus "gnus" nil t)
(setq gnus-article-save-directory "~/Mail/")
(setq gnus-nntp-server nil)
(setq gnus-select-method '(nntp "netnews.comcast.net"));;FIX per host
(setq gnus-secondary-select-methods '(nil))
(setq gnus-activate-foreign-newsgroups t)
;;(setq gnus-read-active-file "some")
;;(setq gnus-check-new-newsgroups nil)
;;(setq gnus-local-organization "Honeywell Technology Center")
;;(setq gnus-local-domain "htc.honeywell.com")
(setq gnus-asynchronous t)
(setq gnus-default-article-saver 'gnus-summary-save-in-mail)
(setq gnus-message-archive-group nil)
(setq gnus-outgoing-message-group nil)
(setq gnus-large-newsgroup nil)         ;Don't ask about large newsgroups
                                        ;setup the Summary lines
(setq gnus-summary-line-format "%U%R%z%I%(%[%d: %-20,20n%]%) %s\n")
(setq gnus-uu-user-view-rules 
      '(("\\.\\(jpe?g\\|gif\\|tiff?\\|p[pgb]m\\|xwd\\|xbm\\|pcx\\)$"
	 "display") 
	("\\.tga$" "display")))

;; Article display munging
(add-hook 'gnus-article-display-hook 'gnus-article-hide-headers)
(add-hook 'gnus-article-display-hook 'gnus-article-treat-overstrike)
(add-hook 'gnus-article-display-hook 'gnus-article-highlight-headers)
(add-hook 'gnus-article-display-hook 'gnus-article-highlight-citation)
(add-hook 'gnus-article-display-hook 'gnus-article-highlight-signature)

;;HACK Something is broken right now and this fixes it
(fset 'mailcap-parse-mailcaps 'ignore)
(fset 'mailcap-mime-info 'ignore)


;;;;;;;;;;;
;;
;; TAGS
;;
;;;;;;;;;;;;
(message "TAGS")
(setq tag-table-alist
      '(
        ("\\.el$" . "~/elib/")
        ("\\.emacs" . "~/elib/")
        ("" . ".")
        ))
;;(global-set-key "\M-." 'tags-search)
(global-set-key "\M-." 'find-tag)
(setq tags-auto-read-changed-tag-files t)
(setq tags-build-completion-table nil)


;;;;;;;;;;;
;;
;; W3
;;
;;;;;;;;;;;;
(message "W3")
(defun w3-load-hook-jps ()
  (define-key w3-mode-map "d" 'w3-load-delayed-images))
(add-hook 'w3-load-hook 'w3-load-hook-jps)


;;;;;;;;;;;
;;
;; display-time
;;
;;;;;;;;;;;;
(message "display-time")

;; display time and balloon stuff
;;(load-library "balloon-help")
;;(balloon-help-mode 1)
(setq display-time-balloon-show-mail-from nil
      display-time-24hr-format t
      display-time-day-and-date t
      display-time-echo-area nil
      )
;;(setq display-time-form-list '(time-text load-text mail-text))
(setq display-time-form-list '(date time-text load-text))
(display-time)
;;(display-time-stop)


;;;;;;;;;;;
;;
;; Crypt
;;
;;;;;;;;;;;;
(message "Crypt")
(setq crypt-encryption-type 'pgp
      crypt-confirm-password t
      ;;crypt-never-ever-decrypt t ; handy if never encrypting stuff
      )
(require 'crypt)


;;;;;;;;;;;
;;
;; minibuffer
;;
;;;;;;;;;;;;
(message "minibuffer")

;; resize the minibuffer when stuff is too big
(autoload 'resize-minibuffer-mode "rsz-minibuf" nil t)
(resize-minibuffer-mode 1)
(setq resize-minibuffer-window-exactly nil)


;;;;;;;;;;;
;;
;; Manual mode
;;
;;;;;;;;;;;;
(message "Manual mode")

;; Set the colors for manual mode
(defun my-Manual-mode-hook ()
  ;; Set colors for things in Manual-mode
  (set-face-foreground 'man-bold "white")
  (set-face-foreground 'man-heading "blue")
  (set-face-foreground 'man-italic "steelblue")
  (set-face-foreground 'man-xref "darkgreen")
  )
;;(set-face-foreground 'font-lock-comment-face "red")      
(add-hook 'Manual-mode-hook 'my-Manual-mode-hook)


;;;;;;;;;;;
;;
;; Antlr
;;
;;;;;;;;;;;;
(message "Antrl")
(autoload 'antlr-mode "antlr-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.g$'" . antlr-mode))
(add-hook 'speedbar-load-hook		; would be too late in antlr-mode.el
	  (lambda () (speedbar-add-supported-extension ".g")))
(setq antlr-language "Java")
(setq antlr-tab-offset-alist
      '((antlr-mode nil 2 t)
	(java-mode "antlr" 2 nil)
	(java-mode "antlr" 2 nil)
	))
(defun antlr-mode-hook-jps()
  (make-local-variable 'c-basic-offset)
  (setq c-basic-offset 2)
  (setq fill-column 78)
  (setq indent-tabs-mode nil)
  )
(add-hook 'antlr-mode-hook 'antlr-mode-hook-jps)


;;;;;;;;;;;
;;
;; Palm pilot
;;
;;;;;;;;;;;;
(message "Palm pilot")
;;pilot-memo
(setq pilot-memo-device "/dev/pilot")


;;my nifty functions
;;FIX... (load-library "cool-functions")
;; handy methods

(defun global-change-directory (from to)
  "Change directory of all buffers with default-directory FROM to TO."
  (interactive "DGlobally change directory from: \nDTo: ")
  (let ((bufs (buffer-list))
	(from (expand-file-name from)))
    (while bufs
      (with-current-buffer (car bufs)
	(when (equal from (expand-file-name default-directory))
	  (setq default-directory to)))
      (setq bufs (cdr bufs)))))

(defun raw-unix ()
  "Set buffer-file-coding-system to raw-text (unix)."
  (interactive)
  (setq buffer-file-coding-system 'raw-text)
  )

(defun switch-to-shell-jps ()
  "Switch to the shell buffer"
  (interactive)
  (if (null (get-buffer "*shell*"))
      (shell)
    (switch-to-buffer "*shell*"))
  )

(defun revert-buffer-jps () 
  "Revert the current buffer with no questions asked"
  (interactive)
  (revert-buffer t t nil))

(defun global-change-directory (from to)
  "Change directory of all buffers with default-directory FROM to TO."
  (interactive "DGlobally change directory from: \nDTo: ")
  (let ((bufs (buffer-list))
	(from (expand-file-name from)))
    (while bufs
      (with-current-buffer (car bufs)
	(when (equal from (expand-file-name default-directory))
	  (setq default-directory to)))
      (setq bufs (cdr bufs)))))



;; ASCII table
(defun ascii-table ()
  "Display a list of the first 128 ASCII chars and keyboard equivalents."
  (interactive)
  (let ((char 0)
	(next-line-add-newlines-save next-line-add-newlines))
    (message "Making the ascii table...")
    (setq next-line-add-newlines t)
    (save-excursion
      (set-buffer (get-buffer-create "*ASCII Table*"))
      (setq buffer-read-only nil)
      (erase-buffer)
      (goto-char (point-min))
      (while (<= char 127)
	(insert (format "%d %s\t" char (single-key-description char)))
	(setq char (1+ char))
	(if (>= (count-lines (point-min) (point)) 13)
	    (goto-char (point-min))
	  (next-line 1))
	(end-of-line))
      (goto-char (point-min))
      ;; this may be overkill, but it is the quickest way I know to nuke
      ;; blank space at the end of all the lines in a buffer.
      ;;(picture-mode) (picture-mode-exit)
      (setq buffer-read-only t))
    (setq next-line-add-newlines next-line-add-newlines-save)
    (display-buffer "*ASCII Table*")
    (message "Making the ascii table...done")))

(defun ascii-table-octal ()
  "Display a list of the first 128 ASCII chars and keyboard equivalents."
  (interactive)
  (let ((char 0)
	(next-line-add-newlines-save next-line-add-newlines))
    (message "Making the ascii table...")
    (setq next-line-add-newlines t)
    (save-excursion
      (set-buffer (get-buffer-create "*ASCII Table Octal*"))
      (setq buffer-read-only nil)
      (erase-buffer)
      (goto-char (point-min))
      (while (<= char 127)
	(insert (format "%o %s\t" char (single-key-description char)))
	(setq char (1+ char))
	(if (>= (count-lines (point-min) (point)) 13)
	    (goto-char (point-min))
	  (next-line 1))
	(end-of-line))
      (goto-char (point-min))
      ;; this may be overkill, but it is the quickest way I know to nuke
      ;; blank space at the end of all the lines in a buffer.
      (picture-mode) (picture-mode-exit)
      (setq buffer-read-only t))
    (setq next-line-add-newlines next-line-add-newlines-save)
    (display-buffer "*ASCII Table Octal*")
    (message "Making the ascii table...done")))


;;;;;;;;;;;
;;
;; Buffer list
;;
;;;;;;;;;;;;
(message "Buffer list")
;; fancy buffer list
(require 'bs)
(setq bs-default-configuration "all")
;;(setq bs-buffer-sort-function 'bs-sort-buffer-interns-are-last)
(setq bs-buffer-sort-function 'bs--sort-by-mode)
(setq bs-dont-show-function nil)


;;;;;;;;;;;
;;
;; Backups
;;
;;;;;;;;;;;;
(message "Backups")
;;backup-dir, stick all backups in a directory
(require 'backup-dir)
(setq bkup-backup-directory-info
      '((t "~/.xemacs/backups/" ok-create full-path prepend-name)
	))
(setq make-backup-files t
      backup-by-copying t)

;; XEmacs specific stuff
(when running-xemacs
  ;; XEmacs specific stuff

  (message "Loading xemacs-init")
  
  (setq auto-save-directory (expand-file-name "~/.xemacs/auto-save/")
	auto-save-directory-fallback auto-save-directory
	auto-save-hash-p nil
	;;ange-ftp-auto-save t
	;;ange-ftp-auto-save-remotely nil
	efs-auto-save t
	efs-auto-save-remotely nil
	;; now that we have auto-save-timeout, let's crank this up
	;; for better interactive response.
	auto-save-interval 2000
	efs-ding-on-umask-failure nil
	)
  ;; We load this afterwards because it checks to make sure the
  ;; auto-save-directory exists (creating it if not) when it's loaded.
  (require 'auto-save)
  (require 'efs)
  (efs-display-ftp-activity)

  (when (or (eq system-type 'usg-unix-v) (eq system-type 'linux))
    ;;(setq gnuserv-frame t);;Use the current frame for gnuserv clients, Setting this causes gnuclient to not work correctly!
    (gnuserv-start)
    )
  )

;; dictionary and thesaurus
(autoload 'dict "dict" nil t)
(autoload 'thesaurus "dict" nil t)


;;;;;;;;;;;
;;
;; Tramp
;;
;;;;;;;;;;;;
;;(message "Tramp")
;;(setq tramp-default-method "scp")


;;;;;;;;;;;
;;
;; EFS
;;
;;;;;;;;;;;;
(message "EFS")
(setq efs-disable-netrc-security-check t)
(setq efs-nslookup-threshold 10000)
(setq efs-umask 22)



;;;;;;;;;;;
;;
;; Keybindings
;;
;;;;;;;;;;;;
(message "Keybindings")

(defvar prefix-key-jps "\M-o" "Used as a prefix for my keybindings")

(global-set-key (concat prefix-key-jps "f") 'iconify-frame)
(global-set-key (concat prefix-key-jps "d") 'delete-region)
(global-set-key (concat prefix-key-jps "s") 'switch-to-shell-jps)
(global-set-key (concat prefix-key-jps "m") 'shell)
(global-set-key (concat prefix-key-jps "g") 'gnus)
(global-set-key (concat prefix-key-jps "n") 'rename-buffer)
(global-set-key (concat prefix-key-jps "r") 'revert-buffer-jps)

(global-set-key (concat prefix-key-jps "u") 'ss-uncheckout)
(global-set-key (concat prefix-key-jps "i") 'ss-update)
(global-set-key (concat prefix-key-jps "o") 'ss-checkout)
(global-set-key (concat prefix-key-jps "y") 'ss-get)

(global-set-key [(meta return)] 'hippie-expand);; expand
(global-set-key [insert] 'toggle-read-only)

;;make my scroll wheel work
(global-set-key [(button4)] 'scroll-down-command)
(global-set-key [(button5)] 'scroll-up-command)

;(global-set-key [(control ?s)] 'isearch-forward-regexp)
;(global-set-key [(control ?r)] 'isearch-backward-regexp)

;;(global-set-key [f6] 'x-copy-primary-selection)
;;(global-set-key [f8] 'x-yank-clipboard-selection)
;;(global-set-key [f9] 'function-menu)
;;(global-set-key [f10] 'x-kill-primary-selection)
;;(global-set-key '(shift button3) 'mouse-function-menu)

;;(global-set-key [kp-enter] "\C-m")
;;(global-set-key [kp-0] "0")
;;(global-set-key [kp-1] "1")
;;(global-set-key [kp-2] "2")
;;(global-set-key [kp-3] "3")
;;(global-set-key [kp-4] "4")
;;(global-set-key [kp-5] "5")
;;(global-set-key [kp-6] "6")
;;(global-set-key [kp-7] "7")
;;(global-set-key [kp-8] "8")
;;(global-set-key [kp-9] "9")
;;(global-set-key [kp-divide] "/")
;;(global-set-key [kp-multiply] "*")
;;(global-set-key [kp-subtract] "-")
;;(global-set-key [kp-add] "+")
;;(global-set-key [kp-decimal] ".")
;;(global-set-key [kp-end] [end])
;;(global-set-key [kp-home] [home])
;;(global-set-key [kp-prior] [prior])
;;(global-set-key [kp-next] [next])
;;(global-set-key [kp-delete] [delete])
;;(global-set-key [kp-insert] [insert])
;;(global-set-key [kp-left] [left])
;;(global-set-key [kp-right] [right])
;;(global-set-key [kp-up] [up])
;;(global-set-key [kp-down] [down])
;; for sun3-50
;;(global-set-key [f27] [home])
;;(global-set-key [f33] [end])
;;(global-set-key [f29] [prior])
;;(global-set-key [f35] [next])
;;(global-set-key [(control f27)] 'beginning-of-buffer)
;;(global-set-key [(control f33)] 'end-of-buffer)

(global-set-key "\C-x\C-d" 'insert-stardate)
(autoload 'insert-stardate "stardate" nil t)
(setq stardate-timezone "CST")
(setq user-login-name (getenv "USER"))
 
(global-set-key "\C-x\C-v" 'view-file)
(global-set-key "\C-m" 'newline-and-indent)

(autoload 'todo-show "todo-mode.el" nil t)
(global-set-key (concat prefix-key-jps "t") 'todo-show)

(global-set-key "\C-xk" 'kill-this-buffer)

(global-set-key [scroll-lock] 'overwrite-mode)

(global-set-key "\C-xt" 'toggle-truncate-lines)
;; end keybindings


;;;;;;;;;;;
;;
;; Source Safe
;;
;;;;;;;;;;;;
(when (eq system-type 'windows-nt)
  (message "Source Safe")

  ;; visual source safe stuff
  ;;(require 'source-safe)
  (setq source-safe-program "c:/progra~1/micros~4/vss/win32/ss.exe")
  ;;(setq ss-project-dirs-cache nil) eval after changing project dirs
  (setq ss-project-dirs '(
			  ("^//mn65-fs1/home/jschewe/projects/schedinfra/" . "$/")
			  ("^//mn65-fs1/home/jschewe/projects/dasada/code/" . "$/")
			  ("^//mn65-fs1/home/jschewe/projects/sm-sched/vss/" . "$/")
			  ("^//mn65-fs1/home/jschewe/projects/sydney-poc/" . "$/")
			  ("^//mn65-fs1/home/jschewe/projects/ptm/code/" . "$/")
			  ))
  ;;(setq ss-database-alist-cache nil) eval after changing database alis
  (setq ss-database-alist '(
			    ("^//mn65-fs1/home/jschewe/projects/schedinfra/" . "//hl-dfs/net/projects/SchedInfra/VSS/")
			    ("^//mn65-fs1/home/jschewe/projects/dasada/code/" . "//hl-dfs/net/projects/dasada/VSS/")
			    ("^//mn65-fs1/home/jschewe/projects/sm-sched/vss/" . "//hl-dfs/net/projects/sm-sched/VSS/")
			    ("^//mn65-fs1/home/jschewe/projects/sydney-poc/" . "//hl-dfs/net/projects/hybrid-scheduling/Sydney-POC/VSS/")
			    ("^//mn65-fs1/home/jschewe/projects/ptm/code/" . "//mn65-fs1/projects/PTM/VSS/")
			    ))
  (setq ss-tmp-dir "c:/temp")
  (setq ss-multiple-checkouts-enabled t)

  (autoload 'ss-get "source-safe"
    "Get the latest version of the file currently being visited." t)

  (autoload 'ss-checkout "source-safe"
    "Check out the currently visited file so you can edit it." t)

  (autoload 'ss-lock "source-safe"
    "Check out, but don't get the latest version of the file currently being visited." t)

  (autoload 'ss-uncheckout "source-safe"
    "Un-checkout the curently visited file." t)

  (autoload 'ss-update "source-safe"
    "Check in the currently visited file." t)

  (autoload 'ss-checkin "source-safe"
    "Check in the currently visited file." t)

  (autoload 'ss-branch "source-safe"
    "Branch off a private, writable copy of the current file for you to work on." t)

  (autoload 'ss-unbranch "source-safe"
    "Delete a private branch of the current file.  This is not undoable." t)

  (autoload 'ss-merge "source-safe"
    "Check out the current file and merge in the changes that you have made." t)

  (autoload 'ss-history "source-safe"
    "Show the checkin history of the currently visited file." t)

  (autoload 'ss-status "source-safe"
    "Show the status of the current file." t)

  (autoload 'ss-locate "source-safe"
    "Find a file the the current project." t)

  (autoload 'ss-submit-bug-report "source-safe"
    "Submit a bug report, with pertinent information." t)

  (autoload 'ss-help "source-safe"
    "Describe the SourceSafe mode." t)
  )



;;;;;;;;;;;
;;
;; Info
;;
;;;;;;;;;;;;
(message "Info")

;;(defun setup-bzip2 ()
;;  (progn
;;    (nconc Info-suffix-list '((".info.bz2" . "bzip2 -dc %s")))
;;    (nconc Info-suffix-list '((".bz2" . "bzip2 -dc %s")))))
;;(add-hook 'Info-mode-hook 'setup-bzip2)

;; LDAP
;;(require 'eudc-ldap)
;;(setq ldap-default-host "mn65-exuser2.htc.honeywell.com")


;;;;;;;;;;;
;;
;; jhideshow
;;
;;;;;;;;;;;;
(message "jhideshow")
(defun hideshow-mode-hook-jps ()
  (define-key hs-minor-mode-map (concat prefix-key-jps "v") 'hs-hide-block)
  (define-key hs-minor-mode-map (concat prefix-key-jps "b") 'hs-show-block)
;;(define-key hs-minor-mode-map (concat prefix-key-jps "n") nil)
;;(define-key hs-minor-mode-map (concat prefix-key-jps "m") nil)
;;(define-key hs-minor-mode-map "" 'hs-show-region)
  )
;;(add-hook 'hs-minor-mode-hook 'hideshow-mode-hook-jps)
;;(add-hook 'semantic-after-toplevel-bovinate-hook 'turn-on-jhideshow)



;;;;;;;;;;;
;;
;; gnats
;;
;;;;;;;;;;;;
(message "gnats")
(setq gnats:addr "schedinfra-bugs@htc.honeywell.com")
(setq gnats:alias "schedinfra")
(setq gnats:userid "jschewe")
(setq gnats:password "jschewe")
;;(setq gnats:root "/net/users/gnats/schedinfra-db")


;;;;;;;;;;;
;;
;; Uniquify
;;
;; load this at the end to make sure everything it caches is up to date,
;; such as directory-sep-char
;;
;;;;;;;;;;;;
(message "uniquify")

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)
;; don't change the name until after buffer is deleted
;;(add-hook 'post-command-hook 'delay-uniquify-rationalize-file-buffer-names)


;;;;;;;;;;;
;;
;; Diminish
;;
;; put at end so everything is loaded
;;
;;;;;;;;;;;;
(message "diminish")
(require 'diminish)
(require 'compile)
(require 'lazy-lock)
(diminish 'compilation-in-progress "C")
(diminish 'compilation-minor-mode "C")
(diminish 'abbrev-mode "Abv")
(diminish 'font-lock-mode "F")
(diminish 'lazy-lock-mode "L")
(diminish 'auto-fill-function "Af")
(diminish 'isearch-mode "IS")
(diminish 'camelCase-mode "CC")


;;HACK Something is screwed up, but this fixes it
(when (not (boundp 'null-buffer-file-name)) (defun null-buffer-file-name ()))

(message "done loading configuration")

;;;stuff emacs likes to append on it's own
(put 'erase-buffer 'disabled nil)

(custom-set-variables
 '(package-get-remote (quote (("ftp.xemacs.org" "/pub/xemacs/packages")))))

(put 'narrow-to-region 'disabled nil)

(setq minibuffer-max-depth nil)
