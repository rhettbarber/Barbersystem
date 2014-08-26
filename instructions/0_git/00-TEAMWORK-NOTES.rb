
  # MAKE ALL LINE ENDINGS LF INSTEAD OF CRLF ON GITHUB

http://www.jetbrains.com/ruby/webhelp/handling-lf-and-crlf-line-endings.html

git config --global core.autocrlf true






################################################################################################

EDITOR IN CYGWIN:
              http://stackoverflow.com/questions/10564/how-can-i-set-up-an-editor-to-work-with-git-on-windows

git config --global core.editor "'C:/Program Files (x86)/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"


REBASING:
    http://stackoverflow.com/questions/6199889/rebasing-remote-branches-in-git

Rebase all changes to root.. squash all except first..
                                                   git rebase --root -i


once local rebase looks good, force update on origin... only when no one else works on it.
                                                                                           git push origin master -f
