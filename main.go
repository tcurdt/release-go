package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
)

var (
    version = "dev"
    commit  = "none"
    date    = "unknown"
)

type Args struct {
    Version bool
    Port    int
}

func main() {

	args := Args{}

	flag.BoolVar(&args.Version, "v", false, "print version")
	flag.IntVar(&args.Port, "port", 2015, "Port number")

	flag.Parse()

	if flag.NArg() > 0 {
		flag.Usage()
		os.Exit(1)
	}

	if args.Version {
		fmt.Printf("Version %s (%s), %s\n", version, commit, date)
		return
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, you've requested: %s\n", r.URL.Path)
	})

	fmt.Printf("Listening on port %d\n", args.Port)

	http.ListenAndServe(fmt.Sprintf(":%d", args.Port), nil)
}
