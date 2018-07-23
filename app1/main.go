package main

import (
	"fmt"
	"html"
	"net/http"

	"github.com/spf13/viper"
)

func main() {
	viper.AutomaticEnv()
	viper.SetEnvPrefix("hello")

	fmt.Println("gender", viper.GetBool("gender"))
	fmt.Println("age", viper.GetInt("age"))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "In App 1 Hello, %q", html.EscapeString(r.URL.Path))
	})

	fmt.Println("starting at :4000")
	fmt.Println("Hello1")
	fmt.Println("Hello2")
	err := http.ListenAndServe(":4000", nil)
	if err != nil {
		panic(err)
	}
}
