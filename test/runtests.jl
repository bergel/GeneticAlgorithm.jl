using Test, GeneticAlgorithm

out = plusTwo(2)
@test out == 4

out = plusTwo(5)
@test out == 7


@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 2) == [1, 2, 30, 40]
@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 1) == [1, 20, 30, 40]
@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 0) == [10, 20, 30, 40]
@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 4) == [1, 2, 3, 4]

include("runtests_example01.jl")
include("runtests_example02.jl")