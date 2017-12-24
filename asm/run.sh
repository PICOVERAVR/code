echo 'Starting KForth...'
cat core.f $1 - | ./a.out
# push core.f and any files to a running forth interpreter
