package main

import "fmt"

func main() {
	sum := 1
	for sum < 100000 {
		sum += 1
    fmt.Println("Hi there")
	}
	fmt.Println(sum)
}
