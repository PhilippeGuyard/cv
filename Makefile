.PHONY: pdf clean

pdf:
	./build.sh

clean:
	rm -f *.aux *.log *.out *.toc *.synctex.gz philippe-guyard-cv.tex

all: clean pdf
