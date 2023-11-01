package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
)

var (
	version bool
	port    *int
)

func init() {
	flag.BoolVar(&version, "v", false, "print version")
	port = flag.Int("port", 2015, "port number")
}

func main() {

	flag.Parse()

	if flag.NArg() > 0 {
		flag.Usage()
		os.Exit(1)
	}

	if version {
		fmt.Println("Version 1.0")
		return
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, you've requested: %s\n", r.URL.Path)
	})

	fmt.Printf("Listening on port %d\n", *port)

	http.ListenAndServe(fmt.Sprintf(":%d", *port), nil)
}
