using Test, GeneticAlgorithm

out = plusTwo(2)
@test out == 4

out = plusTwo(5)
@test out == 7


@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 2) == [1, 2, 30, 40]
@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 1) == [1, 20, 30, 40]
@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 0) == [10, 20, 30, 40]
@test crossoverAtIndex([1, 2, 3, 4], [10, 20, 30, 40], 4) == [1, 2, 3, 4]

#=
@test checkIfSimilar([1, 2, 3, 4], mutateAtIndex([1, 2, 3, 4], 2))
@test checkIfSimilar([1, 2, 3, 4], mutateAtIndex([1, 2, 3, 4], 1))
@test checkIfSimilar([1, 2, 3, 4], mutateAtIndex([1, 2, 3, 4], 4))
=#

@test fitness([3, 2, 1, 4, 5]) == 2
@test fitness(reverse(collect(1:5))) == 4
@test fitness(1:5) == 0

@test pickBestIndividual([[3, 2, 1, 4, 5], reverse(collect(1:5)), 1:5]) == 1:5
@test pickBestIndividual([[3, 2, 1, 4, 5], reverse(collect(1:5))]) == [3, 2, 1, 4, 5]

@test selectIndividual([[3, 2, 1, 4, 5], reverse(collect(1:5)), 1:5]) == 1:5
@test selectIndividual([[3, 2, 1, 4, 5], reverse(collect(1:5))]) == [3, 2, 1, 4, 5]

@test runGA(maxNumberOfIterations=200)[1] == [1, 2, 3, 4, 5]