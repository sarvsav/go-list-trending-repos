package internals

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/sarvsav/go-list-trending-repos/models"
)

func makeHTTPRequest(interval string) (filename string) {
	client, err := http.Get("https://github.com/trending/go?since=" + interval + "&spoken_language_code=en")
	if err != nil {
		fmt.Println(err)
	}
	defer client.Body.Close()

	// Print the text and status code
	fmt.Println(client.Status)

	body, err := io.ReadAll(client.Body)
	if err != nil {
		fmt.Println(err)
	}

	filename = interval + "_" + time.Now().Format("060102_150405") + ".html"
	// Save the HTML response to a file
	file, err := os.Create(path.Join("output", filename))
	if err != nil {
		fmt.Println(err)
	}
	defer file.Close()

	_, err = file.Write(body)
	if err != nil {
		fmt.Println(err)
	}

	return filename
}

func convertHTMLToJSON(interval, filename string) error {
	data, err := os.Open(path.Join("output", filename))
	if err != nil {
		return err
	}
	defer data.Close()

	doc, err := goquery.NewDocumentFromReader(data)
	if err != nil {
		return err
	}

	// Find all h2 tags with class "h3 lh-condensed"
	repos := []string{}
	doc.Find("h2.h3.lh-condensed").Each(func(i int, s *goquery.Selection) {
		text := s.Text()
		// Clean up the text by removing extra whitespace and newlines
		cleanedText := strings.Join(strings.Fields(text), "")
		repos = append(repos, cleanedText)
	})

	// Save the JSON response to a file
	jsonFilename := "output/data.json"
	jsonFile, err := os.OpenFile(jsonFilename, os.O_RDWR|os.O_CREATE, 0755)
	if err != nil {
		return err
	}
	fmt.Println("Successfully opened data.json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	byteValue, err := io.ReadAll(jsonFile)
	if err != nil {
		return err
	}

	var payload models.TrendingRepos

	if len(byteValue) != 0 {
		err = json.Unmarshal(byteValue, &payload)
		if err != nil {
			return err
		}
	}

	if interval == "daily" {
		payload.Data.Daily = repos
	}

	if interval == "weekly" {
		payload.Data.Weekly = repos
	}

	if interval == "monthly" {
		payload.Data.Monthly = repos
	}

	jsonData, err := json.Marshal(payload)
	if err != nil {
		return err
	}

	// Write the JSON data to a file, preserving formatting
	err = os.WriteFile(jsonFilename, jsonData, 0644)
	if err != nil {
		return err
	}

	return nil
}
