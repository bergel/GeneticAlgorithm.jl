using Test, GeneticAlgorithm

out = plusTwo(2)
@test out == 4

out = plusTwo(5)
@test out == 7