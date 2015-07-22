---
layout: post
title: "My Elisp Tweaks"
description: ""
category: 
tags: []
---
{% include JB/setup %}

Here, I put some my own (highly possibly, some other did too) elisp tweaks.

**For the convienience writing in Jekyll**

{% highlight cl %}

(defun my-insert-checkmark ()
  (interactive)
  (insert "✓ "))

(defun my-jekyll-open-local ()
  (interactive)
  (let ((postname (shell-command-to-string (concat "echo "
						   (file-name-sans-extension (file-name-nondirectory (buffer-file-name (current-buffer))))
						   " | sed 's/\\([0-9]\\)\\-/\\1\\//g'"))))
    (shell-command (concat "open http://localhost:4000/" postname))))

{% raw %}
(defun my-jekyll-put-highlight (lang)
  "definition helper" 
  (interactive "sLanguage Name: ")
  (insert (concat "{% highlight " lang " %}\n{% endhighlight %}")))
{% endraw %}

(add-hook 'markdown-mode-hook 
	  (lambda ()
	    (local-set-key (kbd "C-c C-c") 'my-insert-checkmark)
	    (local-set-key (kbd "C-c C-l") 'my-jekyll-open-local)
	    (local-set-key (kbd "C-c C-h") 'my-jekyll-put-highlight)))

{% endhighlight %}
