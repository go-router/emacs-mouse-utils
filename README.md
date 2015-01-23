Emacs mouse utils
=================

A small emacs elisp util allows you manipulate emacs buffers and windows using mouse.
Here is a screencast for its usage.

Copy mouse-utils directory to your local emacs packages. Add its path to "load-path" 
in .emacs as documented in dot_emacs. Add key bindings similar to the following:

* Move content inside window with mouse:

	* (define-key global-map [S-down-mouse-1] 'move-text-around)
	* move cursor to target window and select it; 
	* hold down <Shift>, press down <mouse-1> and move mouse inside window; 
	* the content of window will follow cursor; 
	* [if buffer has text auto-wrapped, the move to left/right will not have effect.]

* DragDrop to exchange windows' content:

	* (define-key global-map [S-drag-mouse-2] 'dragdrop-exchange-buffer)
	* move cursor to source window and select it; 
	* hold down <Shift>, press down <mouse-2> and move mouse to target window;
	* release <mouse-2> at target window;
	* source window and target window will exchange contents.

* Change window size by mouse:

	* (define-key global-map [C-down-mouse-1] 'change-window-size)
	* move cursor into target window and select it;
	* hold down <Ctrl>, press down <mouse-1> and move mouse;
	* target window will resize according to the directions of mouse movement;
	* other windows will resize automatically to accommodate target window size change.
