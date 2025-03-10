package main

import (
	"net/http"

	"github.com/aloussase/site/quotes"

	"github.com/a-h/templ"
)

func main() {
	quotesProvider := quotes.New()

	homeComponent := home(quotesProvider)

	http.Handle("/", templ.Handler(homeComponent))
	http.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("./assets"))))

	http.ListenAndServe(":3000", nil)
}
