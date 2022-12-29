"""
Genetic algorithm is a search algorithm, which a computational
metaphor of the natural evolution. Genetic algorithm is useful to solve
a wide range of problems that are hard to solve using brute-force.
"""
module GeneticAlgorithm

export crossoverAtIndex, pickBestIndividual, selectIndividual
export runGA
export mutateAtIndex
export gaLog

using DataFrames
using CSV
using Random

"""
    createIndividual()

Create an individual
"""
function createIndividual(createGene, numberOfGenes)
    return [createGene() for i in 1:numberOfGenes]
end

"""
    createPopulation()

Create population
"""
function createPopulation(createGene, numberOfGenes)
    return [createIndividual(createGene, numberOfGenes) for i in 1:10]
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
function mutate(createGene, ind)
    size = length(ind)
    randomIndex = floor(Int64, rand() * size + 1)
    return mutateAtIndex(createGene, ind, randomIndex)
end

"""
    mutateAtIndex(ind, index)

Perform a mutation operation on the provided individual, at a provided index
"""
function mutateAtIndex(createGene, ind, index)
    t = copy(ind)
    t[index] = createGene()
    return t
end

"""
    bestFitnessOf(fitness, population)

Return the maximum fitness for a given population of individuals
"""
function bestFitnessOf(fitness, population)
    return minimum(map(fitness, population))
end

"""
    worseFitnessOf(fitness, population)

Return the worse fitness for a given population of individuals
"""
function worseFitnessOf(fitness, population)
    return maximum(map(fitness, population))
end

"""
    pickBestIndividual(population)

Pick best individual of a given population.
"""
function pickBestIndividual(fitness, population)
    indexMaxFitness = argmin(map(fitness, population))
    bestIndividual = population[indexMaxFitness]
    return bestIndividual
end

"""
    selectIndividual(population; k=5)

Selection using the tournament of size k. Assume that the smallest fitness is the best.
"""
function selectIndividual(fitness, population; k=5)
    populationSize = length(population)
    selectedIndividuals = []
    for tmp in 1:k
        anInd = population[floor(Int64, rand()*populationSize) + 1]
        push!(selectedIndividuals, anInd)
    end
    return pickBestIndividual(fitness, selectedIndividuals)
end

function gaLog(aString::String, shouldLog=true; color=:blue)
    if(shouldLog)
        printstyled(aString, color=color)
    end
end

function default_termination_function(bestFitnesses)
    return false
end

function should_continue_evolution(bestFitnesses::Vector{Number}, condition_termination::Function)
    isempty(bestFitnesses) && return true
    return !condition_termination(bestFitnesses)
end

"""
    runGA(;maxNumberOfIterations=10, probMutation=0.2, seed=42)

This is the main function of the genetic algorithm.

# Examples

```julia
julia> runGA(maxNumberOfIterations=40)
```
"""
function runGA(
    fitness::Function,
    createGene::Function,
    numberOfGenes::Int64;

    maxNumberOfIterations=10,
    probMutation=0.2,
    seed=42,
    logging=true,
    filename="",
    condition_termination::Function=default_termination_function
)
    gaLog("BEGINNING - GA commit date 2022-01-23 - 15:59pm\n", logging; color=:red)
    Random.seed!(seed)
    population = createPopulation(createGene, numberOfGenes)
    numberOfIndividuals = length(population)
    bestFitnesses = Number[]
    worstFitnesses = Number[]
    if(!isempty(filename))
        rm(filename * "-individuals", recursive=true, force=true)
        mkpath(filename * "-individuals")
    end
    local iteration = 1
    while (iteration <= maxNumberOfIterations && should_continue_evolution(bestFitnesses, condition_termination))
        gaLog("Begining of iteration = $(iteration)/$(maxNumberOfIterations) ... ", logging)
        newPopulation = []
        for it in 1:numberOfIndividuals
            ind1 = selectIndividual(fitness, population)
            ind2 = selectIndividual(fitness, population)
            newIndividual = crossover(ind1, ind2)
            if (rand() <= probMutation)
                newIndividual = mutate(createGene, newIndividual)
            end
            push!(newPopulation, newIndividual)
        end
        population = newPopulation
        bestFitness = bestFitnessOf(fitness, population)
        worstFitness = worseFitnessOf(fitness, population)
        push!(bestFitnesses, bestFitness)
        push!(worstFitnesses, worstFitness)
        gaLog("end (best fitness = $(bestFitness), worse fitness= $(worstFitness))\n", logging)
        if(!isempty(filename))
            open(filename * "-individuals/$(iteration).txt", "w") do f
                write(f, string(pickBestIndividual(fitness, population)))
            end
        end
        iteration = iteration + 1
    end
    if(!isempty(filename))
        dataFrame = DataFrame(Generation = 1:maxNumberOfIterations, BestFitness = bestFitnesses, WorstFitness = worstFitnesses)
        rm(filename, force=true)
        CSV.write(filename, dataFrame)
    end
    return pickBestIndividual(fitness, population), bestFitnesses
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
