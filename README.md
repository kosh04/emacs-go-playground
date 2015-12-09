# Go Playground Emacs client

go-playground-cli.el is Go Playground (https://play.golang.org) client tool.
You can compile and run a Go program like `go run prog.go`.


## Requirements

- Emacs 24+


## Install

    $ git clone https://github.com/kosh04/emacs-go-playground.git
    $ edit .emacs
    (add-to-list 'load-path "/path/to/emacs-go-playground/")
    (require 'go-playground-cli)

or el-get

    (require 'el-get)
    (el-get-bundle go-playground-cli :url "https://github.com/kosh04/emacs-go-playground/raw/master/go-playground-cli.el")


## Command

- `M-x go-playground-cli-run`              : Compile and run selected go program.
- `M-x go-playground-cli-run-current-file` : Compile and run current go program.

If you installed [go-mode](https://github.com/dominikh/go-mode.el), enable call from the menu-bar.

    menu > Go > Playground > Run


## Links

- [Go Playground](http://play.golang.org/)
- [Inside the Go Playground](http://blog.golang.org/playground)


## License

This software is licensed under the MIT-License.
