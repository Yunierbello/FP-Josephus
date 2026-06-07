#!/usr/bin/env julia
#
# Solve the Josephus problem: find the surviving position J_k(n).
#
# Run from the repository root with:
#     julia --project=. examples/solve_josephus.jl

using FPJosephus

# The classical instance: 41 people, every 3rd eliminated (Josephus and Bachet).
println("Classical Josephus instance (n = 41, k = 3):")
println("  survivor position = ", josephus(3, 41), "\n")

# A large instance, three ways (all agree).
n, k = 1_000_000, 4
println("Evaluating J_$k($n) by three methods:")
println("  exact recurrence (O(n)):      ", josephus_euler(k, n))
println("  extremal algorithm (paper [1]): ", josephus_extremal(k, n))
println("  J_4 fixed-point method (paper [4]): ", josephus4_evaluate(n))

println()
n = 10_000
println("J_4($n) via the fixed-point walk of paper [4]: ", josephus4_evaluate(n))
println("J_3($n) via the fixed-point method of paper [2]: ", josephus3_via_fixed_points(n))

# A table of survivors.
println("\nSurvivor positions J_k(100) for k = 2, ..., 10:")
for k in 2:10
    println("  J_$k(100) = ", josephus(k, 100))
end
