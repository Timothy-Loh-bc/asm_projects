echo "Benchmarking sqroot implementations..."
# -g 	Debug symbols

gcc -g main.s sqroot_clib.s -o sqroot_clib -lm
gcc -g main.s sqroot_naive.s -o sqroot_naive

for p in ./sqroot_clib ./sqroot_naive;
do echo "=== $p ===";
perf stat -r 20 -e task-clock "$p" > /dev/null;
done
