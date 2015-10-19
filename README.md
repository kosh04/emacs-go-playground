# Go Playground Emacs client

go-playground.el provide interface to Go Playground (https://play.golang.org).
You can compile and run a Go program like `go run prog.go`.


## Requirements

- Emacs 24+


## Install

    $ git clone https://github.com/kosh04/emacs-go-playground.git
    $ cat .emacs
    ...
    (add-to-list 'load-path "/path/to/emacs-go-playground/")
    (require 'go-playground)


## Command

- `M-x go-playground-run-file`         : Compile and run selected go program.
- `M-x go-playground-run-current-file` : Compile and run current go program.

If you installed [go-mode](https://github.com/dominikh/go-mode.el), enable call from the menu-bar.

    menu > Go > Playground > Run


## Links

- [Go Playground](http://play.golang.org/)
- [Inside the Go Playground](http://blog.golang.org/playground)


## License

This software is licensed under the MIT-License.
