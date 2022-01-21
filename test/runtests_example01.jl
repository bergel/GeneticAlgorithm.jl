using Test, GeneticAlgorithm

"""
createGene()

Create a gene value
"""
function createGeneExample() 
    return floor(Int, rand() * 10)
end

"""
    fitnessExample(ind)

Example of a fitness function that determines how good an individual is. It returns a number.
"""
function fitnessExample(ind)
    solution = 1:5
    allDifferent = filter(((a,b),) -> a != b, collect(zip(solution, ind)))
    return length(allDifferent)
end

@test fitnessExample([3, 2, 1, 4, 5]) == 2
@test fitnessExample(reverse(collect(1:5))) == 4
@test fitnessExample(1:5) == 0

@test pickBestIndividual(fitnessExample, [[3, 2, 1, 4, 5], reverse(collect(1:5)), 1:5]) == 1:5
@test pickBestIndividual(fitnessExample, [[3, 2, 1, 4, 5], reverse(collect(1:5))]) == [3, 2, 1, 4, 5]

@test selectIndividual(fitnessExample, [[3, 2, 1, 4, 5], reverse(collect(1:5)), 1:5]) == 1:5
@test selectIndividual(fitnessExample, [[3, 2, 1, 4, 5], reverse(collect(1:5))]) == [3, 2, 1, 4, 5]

@test runGA(fitnessExample, createGeneExample, 5, maxNumberOfIterations=200)[1] == [1, 2, 3, 4, 5]
