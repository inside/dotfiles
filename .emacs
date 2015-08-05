;; Evil mode installation guide found here:
;; http://www.emacswiki.org/emacs/Evil#toc1
(require 'package)

(push
  '("marmalade" . "http://marmalade-repo.org/packages/")
  package-archives)
(push
  '("melpa" . "http://melpa.milkbox.net/packages/")
  package-archives)
(package-initialize)

(require 'evil)

(evil-mode 1)
(blink-cursor-mode 0)
