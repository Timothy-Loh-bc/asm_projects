echo "Benchmarking sqroot implementations..."
# -g 	Debug symbols
gcc -g main.s sqroot_clib.s -lm -o sqroot_clib
gcc -g main.s sqroot_naive.s -o sqroot_naive
gcc -g main.s sqroot_bin_search.s -o sqroot_bin_search
for p in ./sqroot_clib ./sqroot_naive ./sqroot_bin_search; 
do echo "=== $p ===";
perf stat -r 20 -e task-clock "$p" > /dev/null; 
done
