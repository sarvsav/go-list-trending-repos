package internals

import (
	"fmt"
	"os"
)

func GetTrendingRepos(since string) {
	dirPath := "/output"

	// Create the directory if it does not exist
	err := os.MkdirAll(dirPath, os.ModePerm)
	if err != nil {
		fmt.Println("Error creating directory:", err)
		return
	}

	//fmt.Println("Directory created or already exists:", dirPath)

	switch since {
	case "daily", "weekly", "monthly":
		reportFile := makeHTTPRequest(since)
		result, _ := convertHTMLToJSON(since, reportFile)
		fmt.Println(result)
	case "all":
		reportFile := makeHTTPRequest("daily")
		convertHTMLToJSON(since, reportFile)
		reportFile = makeHTTPRequest("weekly")
		convertHTMLToJSON(since, reportFile)
		reportFile = makeHTTPRequest("monthly")
		result, _ := convertHTMLToJSON(since, reportFile)
		fmt.Println(result)
	default:
		fmt.Println("Invalid interval:", since)
	}
}
