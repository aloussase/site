package quotes

import "math/rand"

type QuotesProviderImpl struct {
	quotes []Quote
}

func New() QuotesProvider {
	return &QuotesProviderImpl{
		quotes: []Quote{
			{
				Quote:  "Just because it’s weird doesn't mean it’s clever",
				Author: "exurb1a",
			},
			{
				Quote:  "Happiness is a chemical reward for hard work",
				Author: "exurb1a",
			},
			{
				Quote:  "If everything is pointless, you may as well just be in a good mood anyway",
				Author: "exurb1a",
			},
		},
	}
}

func (q *QuotesProviderImpl) RandomQuote() (bool, Quote) {
	if len(q.quotes) == 0 {
		return false, Quote{}
	}

	n := rand.Intn(len(q.quotes))
	return true, q.quotes[n]
}
