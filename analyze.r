library("tidyverse")

options(crayon.enabled = FALSE) # Disable ANSI escapes for text output.

data <- read_csv("corpus-linetype.csv", col_types = cols_only(
	work = col_character(),
	book_n = col_character(),
	line_n = col_character(),
	line_metrical_shape = col_character(),
	line_type_metrical_shape = col_integer(),
	line_type_caesurae = col_integer(),
	caesurae_schematic = col_character(),
))

cat("\nFrequency of line_type_metrical_shape\n")
print(
	data |>
		count(line_type_metrical_shape, line_metrical_shape, sort = TRUE) |>
		mutate(frac = n / sum(n)),
	n = 40
)

cat("\nFrequency of line_type_caesurae\n")
print(
	data |>
		count(line_type_caesurae, caesurae_schematic, sort = TRUE) |>
		mutate(frac = n / sum(n)),
	n = 5000
)
