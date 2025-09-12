(when (not (eq system-type 'android))
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1))

(when (eq system-type 'android)
  (setenv "PATH" (format "%s:%s" "/data/data/com.termux/files/usr/bin"
		                 (getenv "PATH")))
  (setenv "PATH" (format "%s:%s" "/data/data/com.termux/files/usr/bin/texlive"
		                 (getenv "PATH")))
  ;; (setenv "TEXMFROOT" "/data/data/com.termux/files/usr/share/texlive/2025")
  (push "/data/data/com.termux/files/usr/bin" exec-path)
  (push "/data/data/com.termux/files/usr/bin/texlive" exec-path))
