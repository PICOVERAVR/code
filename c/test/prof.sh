make debug
./db.out
gprof db.out gmon.out > prof_results.txt
echo "profile completed."
