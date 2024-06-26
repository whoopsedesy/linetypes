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

x <- data |>
	mutate(label = sprintf("%s (%2d)", line_metrical_shape, line_type_metrical_shape))
x <- x |>
	mutate(label = factor(
		label,
		levels = count(x, label, sort = TRUE)$label,
		exclude = c()
	)) |>
	group_by(work) |>
	count(label) |>
	mutate(frac = n / sum(n))
p <- ggplot(x, aes(label, frac, group = work, color = work)) +
	geom_point(size = 2, alpha = 0.8) +
	geom_line(alpha = 0.1) +
	scale_x_discrete(limits = rev(levels(x$label))) +
	coord_flip() +
	guides(color = guide_legend(override.aes = list(alpha = 1))) +
	labs(
		x = "line_type_metrical_shape",
	) +
	theme(
		axis.text.y = element_text(family = "mono"),
	)
ggsave("line_type_metrical_shape_work.png", p, width = 6, height = 8)

x <- data |>
	mutate(label = sprintf("%s (%5d)", caesurae_schematic, line_type_caesurae))
x <- x |>
	mutate(label = factor(
		label,
		levels = count(x, label, sort = TRUE)$label,
	)) |>
	group_by(work) |>
	count(label) |>
	mutate(frac = n / sum(n))
x <- x |>
	filter(label %in% fct_drop(head(label, 64))) |>
	mutate(label = fct_drop(label))
p <- ggplot(x |> filter(label %in% head(label, 64)), aes(label, frac, group = work, color = work)) +
	geom_point(size = 2, alpha = 0.8) +
	geom_line(alpha = 0.1) +
	scale_x_discrete(limits = rev(levels(x$label))) +
	coord_flip() +
	guides(color = guide_legend(override.aes = list(alpha = 1))) +
	labs(
		x = "line_type_caesurae",
	) +
	theme(
		axis.text.y = element_text(family = "mono"),
	)
ggsave("line_type_caesurae_work.png", p, width = 6, height = 16)
