package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"sync"

	"github.com/google/go-github/v69/github"
)

const (
	GH_API_BFF_ACCESS_TOKEN = "GH_API_BFF_ACCESS_TOKEN"
	APP_PORT                = "PORT"
)

var (
	client          *github.Client
	ghRepoUserOpt   *github.RepositoryListByAuthenticatedUserOptions
	ghIssuesRepoOpt *github.IssueListByRepoOptions
)

func stringOr(s *string, def string) string {
	if s == nil {
		return def
	} else {
		return *s
	}
}

func addCors(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Access-Control-Allow-Origin", "*")
	w.Header().Add("Access-Control-Allow-Headers", "Content-Type")
}

func getIssues(w http.ResponseWriter, r *http.Request) {
	addCors(w, r)

	ctx := context.Background()

	repos, _, err := client.Repositories.ListByAuthenticatedUser(ctx, ghRepoUserOpt)
	if err != nil {
		log.Printf("Error while requesting repositories for authenticated user: %v", err)
		http.Error(w, "Failed to retrieve repositories", http.StatusUnauthorized)
		return
	}

	type issue struct {
		Title string `json:"title"`
		Id    int64  `json:"id"`
		Body  string `json:"body"`
		Url   string `json:"url"`
	}

	issues := make([]issue, 0, 20)

	var mutex sync.Mutex
	var wg sync.WaitGroup
	wg.Add(len(repos))

	for _, repo := range repos {
		go (func(repo *github.Repository) {
			defer wg.Done()
			if repo.HasIssues != nil && *repo.HasIssues {
				i, _, e := client.Issues.ListByRepo(
					ctx,
					*repo.Owner.Login,
					*repo.Name,
					ghIssuesRepoOpt)
				if e != nil {
					log.Printf("Failed to retrieve issues for repo %s: %v", *repo.Name, e)
				} else {
					for _, i := range i {
						mutex.Lock()
						issues = append(issues, issue{
							Title: *i.Title,
							Id:    *i.ID,
							Body:  stringOr(i.Body, ""),
							Url:   *i.HTMLURL,
						})
						mutex.Unlock()
					}
				}
			}
		})(repo)
	}

	wg.Wait()

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(issues)
}

func main() {
	authToken := os.Getenv(GH_API_BFF_ACCESS_TOKEN)
	if authToken == "" {
		panic(fmt.Sprintf("%s is not set", GH_API_BFF_ACCESS_TOKEN))
	}

	port := os.Getenv(APP_PORT)
	if port == "" {
		port = "3000"
	}

	client = github.NewClient(nil).WithAuthToken(authToken)
	ghRepoUserOpt = &github.RepositoryListByAuthenticatedUserOptions{}
	ghIssuesRepoOpt = &github.IssueListByRepoOptions{}

	mux := http.DefaultServeMux
	mux.HandleFunc("OPTIONS /api/issues", addCors)
	mux.HandleFunc("GET /api/issues", getIssues)

	s := &http.Server{
		Addr:    fmt.Sprintf(":%s", port),
		Handler: mux,
	}

	log.Fatal(s.ListenAndServe())
}
