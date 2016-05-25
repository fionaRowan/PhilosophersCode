#!/bin/sh

GCC="gcc"
PC="./philosophers_code"
ulimit -t 30 
error=0
globalerror=0
keep=0
globallog=run-all.log
rm -f $globallog

Compile(){
	eval $1 -o $2 $3 || {
		SignalError $2 "compile"
		error=1
		return 1
	}
	if [ $error -eq 0 ] ; then 
		$1 -o $2 $3 
		echo "compile SUCCESS!"	
	fi
	
	
}

CompileFail(){
	eval $1 -o $2 $3 && {
		SignalError $2 "compile"
		error=1
		return 1
	}
	if [ $error -eq 0 ] ; then 
		echo "compile failed (which is good)" 
	fi

}

SignalError(){
	echo "$1 $2 FAILED"
	error=1
	globalerror=$((globalerror+1)) 
	echo "  $1"
}

Run(){
	if [ $error -eq 0 ] ; then
		eval ./$1 || {
			SignalError $1 "run" 
			error=1
			return 1
		} 
	fi
	if [ $error -eq 0]; then 
		echo "run SUCCESS!"
	fi
	error=0
}

RunFail(){
	if [ $error -eq 0 ] ; then 
		eval ./$1 && {
			SignalError $1 "run"
			error=1
		}
	fi
	error=0
}

FileIterator(){
basename=`echo $1 | sed 's/.*\\///
                             s/.hp//'`
	echo ""
	echo "########testing $basename"
	if [ $2 -eq 1 ] ; then 
		$PC < $1 > tests/$basename.c
		Compile $GCC tests/$basename.out tests/$basename.c 2>> globallog 
		Run tests/$basename.out $basename 2>> globallog 
	fi
	
	if [ $2 -eq 0 ] ; then 
		$PC < $1 > tests/$basename.c
		CompileFail $GCC tests/$basename.out tests/$basename.c 2>> globallog 
		RunFail tests/$basename.out $basename 2>> globallog 
	fi	

}
failFiles="tests/fail-*.hp"
testFiles="tests/test-*.hp"
for tFile in $testFiles
do
	FileIterator $tFile 1
done

for fFile in $failFiles
do 
	FileIterator $fFile 0
done

echo ""
echo "########TEST SUITE STATUS"

if [ $globalerror -eq 0 ] ; then 
	echo "everything works as planned!" 

fi

if [ $globalerror -ne 0 ] ; then 
	echo "there are $globalerror tests that don't have expected"
fi
