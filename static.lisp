;;;; Ace - static.lisp Hunchentoot-based Common Lisp server for Ace
;;;; Copyright (C) 2011  Alexander Kahl <e-user@fsfe.org>
;;;; This file is part of Ace.
;;;; This file is free software; you can redistribute it and/or modify
;;;; it under the terms of the GNU Affero General Public License as published by
;;;; the Free Software Foundation; either version 3 of the License, or (at your
;;;; option) any later version.
;;;;
;;;; This file is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(let ((asdf:*asdf-verbose*))
  (mapc #'require (list :hunchentoot :osicat)))

(defpackage ace
  (:use :cl :hunchentoot :osicat :osicat-sys))

(in-package :ace)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (boundp '*cwd*)
    (defparameter *cwd* (pathname-directory-pathname (compile-file-pathname "")))))

(defparameter *acceptor* (make-instance 'acceptor :port 8888))

(start *acceptor*)
(setq *dispatch-table*
      (list (create-static-file-dispatcher-and-handler "/" (concatenate 'string
                                                                        (native-namestring *cwd*)
                                                                        "index.html"))
            (create-folder-dispatcher-and-handler "/" *cwd*)))

(format t "~&Ready.~%Press return to stop~%")
(read-line)
(stop *acceptor*)
(osicat-posix:exit 0)
