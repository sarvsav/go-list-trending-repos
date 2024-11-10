package models

type TrendingRepos struct {
	Data Data `json:"data"`
}

type Data struct {
	Daily   []string `json:"daily"`
	Weekly  []string `json:"weekly"`
	Monthly []string `json:"monthly"`
}
