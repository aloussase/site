package quotes

type QuotesProvider interface {
	RandomQuote() (bool, Quote)
}
