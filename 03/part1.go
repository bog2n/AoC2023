package main

import (
	"io"
	"os"
	"strconv"
)

var (
	schematic     [][]byte
	width, height int
)

func isNumber(x byte) bool {
	return x >= 0x30 && x <= 0x39
}

func getNumber(y, x int) int {
	start, stop := x, x
	i := -1
	for {
		if i < 0 {
			if x+i < 0 {
				i = 1
			} else if isNumber(schematic[y][x+i]) {
				start = x + i
				i--
			} else {
				i = 1
			}
		} else {
			if x+i >= width {
				break
			} else if isNumber(schematic[y][x+i]) {
				stop = x + i
				i++
			} else {
				break
			}
		}
	}
	number, err := strconv.Atoi(string(schematic[y][start : stop+1]))
	if err != nil {
		panic(err)
	}
	return number
}

func partNumbers(x, y int) (sum int) {
	// left, right
	if isNumber(schematic[y][x-1]) {
		sum += getNumber(y, x-1)
	}
	if isNumber(schematic[y][x+1]) {
		sum += getNumber(y, x+1)
	}
	for offset := -1; offset <= 2; offset += 2 {
		// top, bottom
		if isNumber(schematic[y+offset][x]) {
			sum += getNumber(y+offset, x)
		} else {
			// corners
			if isNumber(schematic[y+offset][x+1]) {
				sum += getNumber(y+offset, x+1)
			}
			if isNumber(schematic[y+offset][x-1]) {
				sum += getNumber(y+offset, x-1)
			}
		}
	}
	return
}

func main() {
	data, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}
	p := 0
	for i, v := range data {
		if v == '\n' {
			schematic = append(schematic, data[p:i])
			p = i + 1
		}
	}
	width, height = len(schematic[0]), len(schematic)
	var sum = 0

	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			current := schematic[y][x]
			if current != '.' && !isNumber(current) {
				sum += partNumbers(x, y)
			}
		}
	}

	print(sum, "\n")
}
