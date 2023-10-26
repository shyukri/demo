package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
)

func main() {
	// register crate function to handle all requests
	mux := http.NewServeMux()
	mux.HandleFunc("/", crate)

	// use PORT environment variable, or default to 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// start the web server on port and accept requests
	log.Printf("Server listening on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, mux))
}

// crate responds to the request with a plain-text message and headers.
func crate(w http.ResponseWriter, r *http.Request) {
	tmpl := template.Must(template.ParseFiles("index.html"))
	tmpl.Execute(w, r.Header)
	log.Printf("Serving request: %s", r.URL.Path)
	// fmt.Fprintf(w, "Request at %v\n", time.Now())
	// for k, v := range r.Header {
	// 	fmt.Fprintf(w, "%v: %v\n", k, v)
	// }
}
