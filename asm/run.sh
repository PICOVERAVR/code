echo 'Starting KForth...'
cat core.f $1 - | ./dev.out
# push core.f and any files to a running forth interpreter
