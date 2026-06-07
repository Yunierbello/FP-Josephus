"""
    FPJosephus

Algorithms for the Josephus function `J_k` and its fixed points, implementing the
methods developed in the series of papers by Bello-Cruz and Quintero-Contreras:

  [1] Analytical Study and Efficient Evaluation of the Josephus Function,
      J. Integer Seq. 27 (2024), Article 24.3.8.        (general k: Euler, extremal)
  [2] On the Recurrence Formula for Fixed Points of the Josephus Function,
      Integers 24 (2024), #A115.                         (k = 3 fixed-point recurrence)
  [3] Fixed Points of the Josephus Function via Fractional Base Expansions,
      Integers 26 (2026), #A54.                          (k = 3: CRT, base-3/2)
  [4] A 3-adic Recurrence for the Fixed Points of the Josephus Function J_4,
      arXiv (2026).                                      (k = 4 fixed-point recurrence)

The public API is re-exported from three submodules:

  * `JosephusCore` -- the Josephus function for general k and the linear-segment/extremal
               machinery of [1].
  * `J3`    -- fixed points of J_3 and related tools from [2] and [3].
  * `J4`    -- fixed points of J_4 from [4].

See the README for a guided tour, or the `examples/` folder for runnable scripts.
"""
module FPJosephus

include("core.jl")
include("j3.jl")
include("j4.jl")

using .JosephusCore
using .J3
using .J4

# ---- general k (paper [1]) ----
export josephus, josephus_euler, josephus_knuth,
       next_high_extremal, high_extremal_points, josephus_extremal,
       fixed_points, fixed_points_bruteforce, is_fixed_point

# ---- k = 3 (papers [2], [3]) ----
export fixed_points_J3, fixed_points_J3_recurrence, num_pure_points_J3,
       josephus3_via_fixed_points, fixed_point_J3_crt, base_three_halves

# ---- k = 4 (paper [4]) ----
export fixed_points_J4, next_fixed_point_J4, josephus4_evaluate,
       block_structure_J4, first_block_J4

end # module
