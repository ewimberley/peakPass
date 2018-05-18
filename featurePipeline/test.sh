#!/bin/bash
source config.sh

function cleanup {
	./cleanup.sh > /dev/null 2>&1
}

function runTest {
	#./pipeline.sh testHarness $1 configurations/test.sh > /dev/null 2>&1
	./pipeline.sh testHarness $1 configurations/test.sh
}

function printTestName {
	printf '\e[1;44m%s\e[m\n' "*****Running Test $1*****"
}

function printResult {
	if $1 ; then
		printf '\e[1;42m%s\e[m\n\n' "*****PASS*****"
	else
		printf '\e[1;41m%s\e[m\n\n' "*****FAIL*****"
	fi
}

#############################################
# generateSamples                           #
#############################################
cleanup
printTestName "generateSamples"
runTest generateSamples
testPassed=true
if [ ! -f $SAMPLES_FILE ]; then
	testPassed=false
fi
if [ ! -f $TILES_BED ]; then
	testPassed=false
fi
numSamples=$(wc -l $SAMPLES_FILE | awk '{print $1}')
minSamples=300
if [ "$numSamples" -lt "$minSamples" ]; then
	testPassed=false
fi
printResult $testPassed

#############################################
# setup                                     #
#############################################
cleanup
printTestName "setup"
runTest generateSamples
runTest setup
testPassed=true
printResult $testPassed
