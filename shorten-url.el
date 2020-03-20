;;
;; $Id: shorten-url.el,v 1.1 2020/03/20 00:20:00 u1 Exp u1 $
;;
;; This program is tools to simplify the appearance of URLs written in
;; a buffer.  After evaluating `shorten-url-region' and
;; `shorten-url-narrow', try running `shorten-url-narrow' on the
;; following line.
;;
;; https://example.com/hogehoge.whowhowho/EXAMPLE
;;
;; The appearance of the URL changes as follows.
;;
;; example.com/...XAMPLE
;;
;; You can shorten all URLs in the current buffer with
;; `shorten-all-url-buffer'.  If you always want to shorten URLs in a
;; minor mode, add `shorten-all-url-buffer' to that minor mode hook.
;;
;; `tinyurl' developed by Jari Aalto is a program that has similar
;; functions to this program. It is huge and multifunctional than this
;; program.  (GitHub page:
;; https://github.com/jaalto/project--emacs-tiny-tools/blob/devel/lisp/tiny/tinyurl.el,
;; Emacs Wiki: https://www.emacswiki.org/emacs/TinyUrl)

(defun shorten-url-region (begin end)
  "Shorten URL in region. This function changes the appearance of
the URL to a shorter one, specifically the concatenation of the
domain and the last six characters. For example, this function
changes `https://example.com/hogehoge.whowhowho/EXAMPLE' to
`example.com/...XAMPLE'"
  (interactive "r")
  (let*
      (
       (o (make-overlay begin end))
       (str (buffer-substring-no-properties begin end))
       (m (string-match "http[s]?://[www\\.]*\\([^/]*\\).*\\(......\\)" str))
       (head (match-string 1 str))
       (tail (match-string 2 str))
       )
    (overlay-put o 'invisible t)
    (overlay-put o 'before-string (propertize (concat head "/..." tail) 'face 'link))
    (overlay-put o 'evaporate t)
    (overlay-put o 'isearch-open-invisible t)
    )
  )

(defun shorten-url-narrow ()
  "Shorten URL near current cursor position"
  (interactive)
  (save-excursion
    (let
	((url-region (bounds-of-thing-at-point 'url)))
      (if url-region
	  (shorten-url-region (car url-region) (cdr url-region))
	       (message "No URL around here"))
      ))
  )

(defun shorten-all-url-buffer ()
  "Shorten all URLs in current buffer"
  (interactive)
  (save-excursion
    (while (re-search-forward "http[s]?://" nil t)
      (shorten-url-narrow)
      ))
  )

(provide 'shorten-url)
