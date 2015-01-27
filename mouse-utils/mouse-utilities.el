;;
;; functions for mouse utilities
;;	released under apache 2.0, 1999-2015
;;     by yigong liu
;;
(provide 'mouse-utilities)

;;
(defun dragdrop-exchange-buffer (event)
  "Using mouse-drag-drop to exchange buffers of two windows"
  (interactive "@e")
  ;; get the 1st and 2nd windows
  (let* ((1-window (posn-window (event-start event)))
	 (2-window (posn-window (event-end event)))
	 (1-buffer (window-buffer 1-window))
	 (2-buffer (window-buffer 2-window))
	 )
    (set-window-buffer 1-window 2-buffer)
    (set-window-buffer 2-window 1-buffer)
    )
  )

;;
(defun move-text-around (event)
  "Using mouse to move buffer text around"
  (interactive "@e")
  ;; get the first position of move
  (let ((last-pos (posn-col-row (event-start event)))
	(new-event nil)
	(curr-pos nil)
	(delta-x 0) (delta-y 0)
	)
    (track-mouse;; start tracking mouse
      ;; turn off auto-hscroll-mode to avoid interfering horizontal moves
      (setq auto-hscroll-flag nil)
      (when auto-hscroll-mode
        (setq auto-hscroll-flag t)
        (setq auto-hscroll-mode nil)
        )
      ;; read the next event, if it is not mouse movement, quit
      (while (mouse-movement-p (setq new-event (read-event)))
	(setq curr-pos (posn-col-row (event-start new-event)))
	;; calc the position change between last-pos and curr-pos
	(setq delta-x (- (car curr-pos) (car last-pos)))
	(setq delta-y (- (cdr curr-pos) (cdr last-pos)))
	;; move text and update last-pos
	(if (/= delta-x 0)
	    (progn
	      (scroll-right delta-x)
	      (setq last-pos (cons (car curr-pos) (cdr last-pos)))
	      )
	  )

	(if (/= delta-y 0)
	    (progn
	      (scroll-down delta-y)
	      (setq last-pos (cons (car last-pos) (cdr curr-pos)))
	      )
	  )
	)
      ;;restore auto-hscroll-mode
      (if auto-hscroll-flag
          (setq auto-hscroll-mode t)
        )
      )
    )
  )

;;
(defun change-window-size (event)
  "Using mouse to change window size"
  (interactive "@e")
  ;; get the first position of move
  (condition-case err
      (let ((last-pos (posn-col-row (event-start event)))
	    (new-event nil)
	    (curr-pos nil)
	    (delta-x 0) (delta-y 0)
	    (start-event-frame (window-frame (car (car (cdr event)))))
	    (start-event-window (car (car (cdr event))))
	    (start-nwindows (count-windows t))
	    )
	(track-mouse;; start tracking mouse
	  ;; read the next event, if it is not mouse movement, quit
	  (while (mouse-movement-p (setq new-event (read-event)))
	    (cond 
	     ((not (eq start-event-frame (window-frame (car (car (cdr new-event))))))
	      nil)
	     ((not (eq start-event-window (car (car (cdr new-event)))))
	      nil)
	     (t
	      (setq curr-pos (posn-col-row (event-start new-event)))
	      ;; calc the position change between last-pos and curr-pos
	      (setq delta-x (- (car curr-pos) (car last-pos)))
	      (setq delta-y (- (cdr curr-pos) (cdr last-pos)))
	      (setq wconfig (current-window-configuration))
	      ;; move text and update last-pos
	      (if (/= delta-x 0)
		  (progn
		    (condition-case nil
			(enlarge-window-horizontally delta-x)
		      (error nil))
		    (cond 
		     ((/= start-nwindows (count-windows t))
		      (condition-case nil
			  (set-window-configuration wconfig)
			(error nil)))
		     (t
		      (setq last-pos (cons (car curr-pos) (cdr last-pos))))
		     )
		    )
		)

	      (if (/= delta-y 0)
		  (progn
		    (condition-case nil
			(enlarge-window delta-y)
		      (error nil))
		    (cond 
		     ((/= start-nwindows (count-windows t))
		      (condition-case nil
			  (set-window-configuration wconfig)
			(error nil)))
		     (t
		      (setq last-pos (cons (car last-pos) (cdr curr-pos))))
		     )
		    )
		)
	      )
	     )
	    )
	  )
	)
    (error (message "%s" (error-message-string err)))
    )
  )
