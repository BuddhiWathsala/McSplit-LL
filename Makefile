all:
	g++ -Wall -std=c++17 *.cpp -pthread -o bin/run.o
build:
	g++ -Wall -std=c++17 *.cpp -pthread -o bin/run.o
macbuild:
	/usr/bin/clang++ -Wall -std=c++17 *.cpp -pthread -g -o bin/run.o -I/opt/homebrew/Cellar/argp-standalone/1.3/include -L/opt/homebrew/Cellar/argp-standalone/1.3/lib/ -largp
run:
	./bin/run.o min_max ./data/tests/case1/pattern ./data/tests/case1/pattern -l -c

MAX_TIME := 5
test:
	./bin/run.o min_max ./data/tests/case1/pattern ./data/tests/case1/target -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case2/pattern ./data/tests/case2/target -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case3/001.txt ./data/tests/case3/071.txt -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case4/055.txt ./data/tests/case4/173.txt -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case5/001.txt ./data/tests/case5/094.txt -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case6/g50 ./data/tests/case6/g92 -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case7/g11 ./data/tests/case7/g93 -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case8/g10 ./data/tests/case8/g51 -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case9/pattern ./data/tests/case9/target -l -c -q -t ${MAX_TIME}
	./bin/run.o min_max ./data/tests/case10/pattern ./data/tests/case10/target -l -c -q -t ${MAX_TIME}
