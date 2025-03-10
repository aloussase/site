package main

import (
	"github.com/a-h/templ"
	"github.com/aloussase/site/quotes"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "80"
	}

	addr := ":" + port

	quotesProvider := quotes.New()

	homeComponent := home(quotesProvider)

	http.Handle("/", templ.Handler(homeComponent))
	http.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("./assets"))))

	log.Printf("Listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}
