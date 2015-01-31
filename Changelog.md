#  Yop Changelog


## v0.0.1

Initial release.

* Run `yop <template> <directory>` to copy a template in a directory (created
  if it doesn’t exist)
* Templates are stored in `~/.yop/templates/`
* Yop doesn’t replace anything in the files for now
* File permissions are preserved
* Some common file patterns are excluded (e.g. `.git`, `*.pyc` and `*.class`)
