echo "Benchmarking sqroot implementations..."
# -g 	Debug symbols

gcc -g main.s sqroot_naive.s -o sqroot_naive
gcc -g main.s sqroot_binary_search.s -o sqroot_binary_search
gcc -g main.s sqroot_quake.s -o sqroot_quake

for p in ./sqroot_binary_search.s ./sqroot_quake.s;
do echo "=== $p ===";
perf stat -r 20 -e task-clock "$p" > /dev/null;
done
