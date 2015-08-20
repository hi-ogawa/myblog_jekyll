---
layout: post
title: "Emacs/Elisp Tips"
description: ""
category: [tips]
tags: [elisp, emacs]
---

Here, I put some my own (highly possibly, some other did too) elisp tweaks.

# stop inserting tabs in any modes

- <http://www.emacswiki.org/emacs/NoTabs>
- <http://vserver1.cscs.lsa.umich.edu/~rlr/Misc/emacs_tabs.htm>

# Auto Completion of Matching Brankets

When I start to write _TypeScript_, I feel I need some support to automatically insert
a matching branket or parenthesis, which is not necessarily as long as with _CoffeeScript_.

Here is what I found about that kind of support:

- <http://www.emacswiki.org/emacs/AutoPairs>
- <http://ergoemacs.org/emacs/emacs_insert_brackets_by_pair.html>

Actually, I might have used this mode before, then anyhow I threw it away.
Maybe, I will appreciate this mode while writing _TypeScript_ now that I've gotten into
_CoffeeScript's_ elegant syntax. We'll see.

For now, I'm just turning on the electric-pair-mode, but some day, I want to tweak
some setting by myself.

# Complete a variable name with the same prefix word appearing in the same file

- `Alt - slash`: `(dabbrev-expand ARG)`
- Is it possible to widen referenced file to not only current file?
  - It seems possible, see the variable: `dabbrev-friend-buffer-function`.
	When the time comes, I'll check this out.

# For the Convienience Writing in Jekyll

{% highlight cl %}

(defun my-insert-checkmark ()
  (interactive)
  (insert " "))

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


# Elisp Functions Reference

- shell-command-to-string
- interctive function definition
  - read-string
  - interactive
  - <http://stackoverflow.com/questions/9646088/emacs-interactive-commands-with-default-value>
  - <http://www.gnu.org/software/emacs/manual/html_node/elisp/Using-Interactive.html>

