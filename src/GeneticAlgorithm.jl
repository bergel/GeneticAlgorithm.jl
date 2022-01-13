"""
Genetic algorithm is a search algorithm, which a computational
metaphor of the natural evolution. Genetic algorithm is useful to solve
a wide range of problems that are hard to solve using brute-force.
"""
module GeneticAlgorithm

export plusTwo
export crossoverAtIndex, checkIfSimilar, fitness, pickBestIndividual, selectIndividual, mutateAtIndex
export runGA

using Test
using Random

# To make everything reproducible
Random.seed!(42)

"""
    createGene()

Create a gene value
"""
function createGene() 
    return floor(Int, rand() * 10)
end

"""
    createIndividual() 

Create an individual
"""
function createIndividual() 
    return [createGene() for i in 1:5]
end

"""
    createPopulation() 

Create population
"""
function createPopulation() 
    return [createIndividual() for i in 1:10]
end

"""
    crossover(ind1, ind2)
    
Genetic operation: Crossover
"""
function crossover(ind1, ind2)
    size = length(ind1)
    randomIndex = floor(Int64, rand() * size)
    return crossoverAtIndex(ind1, ind2, randomIndex)
end

"""
    crossover(ind1, ind2, index)
    
Perform a crossover at a particular index
"""
function crossoverAtIndex(ind1, ind2, index)
    return vcat(ind1[1:index], ind2[index + 1:length(ind2)])
end

"""
    mutate(ind)

Perform a mutation operation on the provided individual
"""
function mutate(ind)
    size = length(ind)
    randomIndex = floor(Int64, rand() * size + 1)
    return mutateAtIndex(ind, randomIndex)
end

"""
    mutate(ind, index)

Perform a mutation operation on the provided individual, at a provided index
"""
function mutateAtIndex(ind, index)
    t = copy(ind)
    t[index] = createGene()
    return t
end

"""
    checkIfSimilar(ind1, ind2)

Return true if the two individuals are the same, expect with a mutation at a particular index.
This function is particularly useful for testing.
"""
function checkIfSimilar(ind1, ind2)
    pairs = collect(zip(ind1, ind2))
    # the predicate is the same than t -> first(t) == last(t)
    allIdentical = filter(((a, b),) -> a == b, pairs)
    allDifferent = filter(((a, b),) -> a != b, pairs)
    oneDiff = length(allDifferent) == 1
    allTheRestTheSame = length(allIdentical) == (length(ind1) - 1)
    return oneDiff && allTheRestTheSame
end


"""
    fitness(ind)

The fitness function determines how good an individual is. It returns a number.
"""
function fitness(ind)
    solution = 1:5
    allDifferent = filter(((a,b),) -> a != b, collect(zip(solution, ind)))
    return length(allDifferent)
end



"""
    bestFitnessOf(population)

Return the maximum fitness for a given population of individuals
"""
function bestFitnessOf(population)
    return maximum(map(fitness, population))
end 

"""
    pickBestIndividual(population)

Pick best individual of a given population.
"""
function pickBestIndividual(population)
    indexMaxFitness = argmin(map(fitness, population))
    bestIndividual = population[indexMaxFitness]
    return bestIndividual
end



"""
    selectIndividual(population; k=5)

Selection using the tournament of size k. Assume that the smallest fitness is the best.
"""
function selectIndividual(population; k=5)
    populationSize = length(population)
    selectedIndividuals = []
    for tmp in 1:k
        anInd = population[floor(Int64, rand()*populationSize) + 1]
        push!(selectedIndividuals, anInd)
    end
    return pickBestIndividual(selectedIndividuals)
end


"""
    run(;maxNumberOfIterations=10, probMutation=0.2)

This is the main function of the genetic algorithm.

# Examples

```julia
julia> runGA(maxNumberOfIterations=40)
```
"""
function runGA(;maxNumberOfIterations=10, probMutation=0.2)
    population = createPopulation()
    numberOfIndividuals = length(population)
    fitnesses = []
    for iteration in 1:maxNumberOfIterations
        newPopulation = []
        for it in 1:numberOfIndividuals
            ind1 = selectIndividual(population)
            ind2 = selectIndividual(population)
            newIndividual = crossover(ind1, ind2)
            if (rand() <= probMutation) 
                newIndividual = mutate(newIndividual)
            end
            push!(newPopulation, newIndividual)
        end
        population = newPopulation
        push!(fitnesses, bestFitnessOf(population))
    end
    return pickBestIndividual(population), fitnesses
end


"""
    plusTwo(x)

Sum the numeric "2" to whatever it receives as input

A more detailed explanation can go here, although I guess it is not needed in this case

# Arguments
* `x`: The amount to which we want to add 2

# Notes
* Notes can go here

# Examples
```julia
julia> five = plusTwo(3)
5
```
"""
plusTwo(x) = return x + 2

end # module

#GeneticAlgorithm.runGA(maxNumberOfIterations=40)
