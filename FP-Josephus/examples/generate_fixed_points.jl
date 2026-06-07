#!/usr/bin/env julia
#
# Generate fixed points of the Josephus function J_k.
#
# Run from the repository root with:
#     julia --project=. examples/generate_fixed_points.jl

using FPJosephus

println("Fixed points of J_k (first 8), for k = 2, ..., 8\n")
for k in 2:8
    fps = fixed_points(k, 8)
    println("  k = $k:  ", join(fps, ", "))
end

println("\nSpecialized fast recurrences:\n")
println("  J_3 (paper [2]):  ", join(fixed_points_J3(10), ", "))
println("  J_4 (paper [4]):  ", join(fixed_points_J4(10), ", "))

println("\nFor J_3, the number of pure high extremal points between consecutive")
println("fixed points equals ν_2(3 n_p + 2):\n")
for np in fixed_points_J3(8)
    println("  n_p = $np\t-> pure points after it: $(num_pure_points_J3(np))")
end

println("\nFor J_4, the block structure between 5167 and the next fixed point:\n")
for (t, len, last) in block_structure_J4(5167)
    println("  type $t block, length $len, last point $last")
end
