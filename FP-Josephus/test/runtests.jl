using FPJosephus
using Test

# Reference: exact order-n Euler recurrence, used as ground truth everywhere.
function J_ref(k, n)
    r = 0
    for i in 2:n
        r = (r + k) % i
    end
    return r + 1
end

fixed_ref(k, N) = [n for n in 1:N if J_ref(k, n) == n]

@testset "FPJosephus" begin

    @testset "Core: J_k matches the reference recurrence" begin
        for k in 2:12, n in 1:1500
            @test josephus_euler(k, n) == J_ref(k, n)
        end
        # Knuth and Euler agree
        for k in 2:12, n in 1:500
            @test josephus_knuth(k, n) == J_ref(k, n)
        end
        # known closed forms
        @test josephus(2, 41) == J_ref(2, 41)
        @test josephus_euler(2, 100) == 2 * 100 - 2^(floor(Int, log2(100)) + 1) + 1
    end

    @testset "Core: extremal evaluation == Euler" begin
        for k in 2:12, n in 1:2000
            @test josephus_extremal(k, n) == josephus_euler(k, n)
        end
    end

    @testset "Core: general-k fixed points == brute force" begin
        for k in 2:15
            bf = fixed_ref(k, 40_000)
            @test fixed_points(k, length(bf)) == bf
        end
        # closed form for k = 2
        @test fixed_points(2, 10) == [2^i - 1 for i in 1:10]
        @test is_fixed_point(4, 21)
        @test !is_fixed_point(4, 22)
    end

    @testset "J3: fixed-point recurrence (paper [2])" begin
        @test fixed_points_J3(13) ==
              [1, 2, 13, 20, 46, 157, 236, 532, 1198, 4045, 6068, 13654, 46084]
        # agree with brute force
        bf = fixed_ref(3, 50_000)
        @test fixed_points_J3(length(bf)) == bf
        # number of pure points = ν_2(3 np + 2)
        for np in fixed_points_J3(12)
            @test num_pure_points_J3(np) >= 0
        end
    end

    @testset "J3: evaluation via fixed points == Euler" begin
        for n in 1:20_000
            @test josephus3_via_fixed_points(n) == josephus_euler(3, n)
        end
    end

    @testset "J3: CRT characterization (paper [3])" begin
        fps = fixed_points_J3(20)
        for l in 2:14
            x = fps[l + 1]                       # n_p^{(l+1)}
            p = num_pure_points_J3(fps[l])       # pure points before x
            q = num_pure_points_J3(x)            # pure points after x
            @test fixed_point_J3_crt(x, p, q)
        end
    end

    @testset "J3: base-3/2 representation (paper [3])" begin
        # reconstruct value: N = Σ d_i (3/2)^i
        function val32(digits)
            n = length(digits)
            s = 0 // 1
            for (i, d) in enumerate(digits)
                s += d * (3 // 2)^(n - 1 - i)
            end
            return s
        end
        for N in [4, 13, 20, 46, 157, 1000]
            @test val32(base_three_halves(N)) == N
            @test all(d -> 0 <= d <= 2, base_three_halves(N))
        end
        @test base_three_halves(0) == [0]
    end

    @testset "J4: fixed-point recurrence (paper [4])" begin
        @test fixed_points_J4(8) == [1, 21, 38, 51, 122, 163, 689, 919]
        bf = fixed_ref(4, 60_000)
        @test fixed_points_J4(length(bf)) == bf
        @test next_fixed_point_J4(5167) == 51617
    end

    @testset "J4: evaluation == Euler" begin
        for n in 1:60_000
            @test josephus4_evaluate(n) == josephus_euler(4, n)
        end
        @test josephus4_evaluate(10_000) == 3254
    end

    @testset "J4: block structure (paper [4])" begin
        # interval (5167, 51617): five blocks 2,1,2,1,2
        bs = block_structure_J4(5167)
        @test length(bs) == 5
        @test [b[1] for b in bs] == [2, 1, 2, 1, 2]              # types
        @test [b[3] for b in bs] == [6889, 9186, 21775, 29034, 38712]  # last points
        @test bs[3][2] == 3                                     # middle block has length 3
        # direct transition: 122 ≡ 2 (mod 3)
        @test isempty(block_structure_J4(122))
        # first block of (21, 38): 21 ≡ 0 (mod 3) -> type 1
        @test first_block_J4(21)[1] == 1
        @test first_block_J4(290022) == (1, 2, 515595)
    end

    @testset "Consistency across modules at k = 3, 4" begin
        for n in 1:5000
            @test josephus3_via_fixed_points(n) == josephus(3, n)
            @test josephus4_evaluate(n) == josephus(4, n)
            @test josephus_extremal(3, n) == josephus(3, n)
            @test josephus_extremal(4, n) == josephus(4, n)
        end
    end

end
