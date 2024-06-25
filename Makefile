PYTHON = python3

WORKS = \
	aratus \
	argonautica \
	callimachushymns \
	homerichymns \
	iliad \
	nonnusdionysiaca \
	odyssey \
	quintussmyrnaeus \
	shield \
	theocritus \
	theogony \
	worksanddays

WORKS_CSV = $(addprefix corpus-appositive/,$(addsuffix .csv,$(WORKS)))

.PHONY: all
all: \
	$(WORKS_CSV) \
	corpus-linetype.csv

corpus-appositive/*.csv: .EXTRA_PREREQS = merge-appositives.r
corpus-appositive/%.csv: corpus/%.csv
	Rscript merge-appositives.r "$<" > "$@"

.DELETE_ON_ERROR:
