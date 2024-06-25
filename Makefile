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
	corpus-linetype.csv \
	linetype.txt

corpus-appositive/*.csv: .EXTRA_PREREQS = merge-appositives.r
corpus-appositive/%.csv: corpus/%.csv
	Rscript merge-appositives.r "$<" > "$@"

corpus-linetype.csv: .EXTRA_PREREQS = linetype.r
corpus-linetype.csv: $(WORKS_CSV)
	Rscript linetype.r $^ > "$@"

linetype.txt: .EXTRA_PREREQS = analyze.r
linetype.txt: corpus-linetype.csv
	Rscript analyze.r "$^" > "$@"

.DELETE_ON_ERROR:
