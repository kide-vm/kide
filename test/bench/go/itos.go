package main

import (
    "strconv"
)

func main() {
	sum := 1
	for sum < 100000 {
		sum += 1
    strconv.Itoa(sum)
	}
}
