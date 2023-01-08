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
function createIndividual(createGene::Function, numberOfGenes::Int64)
    return [createGene(gene_index) for gene_index in 1:numberOfGenes]
end

"""
    createPopulation()

Create population
"""
function createPopulation(population_size::Int64, gene_factory::Function, numberOfGenes::Int64)
    return [createIndividual(gene_factory, numberOfGenes) for i in 1:population_size]
end

"""
    crossover(index1, index2)

Genetic operation: Crossover
"""
function crossover(index1, index2)
    size = length(index1)
    randomIndex = floor(Int64, rand() * size)
    return crossoverAtIndex(index1, index2, randomIndex)
end

"""
    crossover(index1, index2, index)

Perform a crossover at a particular index
"""
function crossoverAtIndex(index1, index2, index)
    return vcat(index1[1:index], index2[index + 1:length(index2)])
end

"""
    mutate(ind)

Perform a mutation operation on the provided individual
"""
function mutate(gene_factory::Function, individual)
    size = length(individual)
    randomIndex::Int64 = floor(Int64, rand() * size + 1)
    return mutateAtIndex(gene_factory, individual, randomIndex)
end

"""
    mutateAtIndex(ind, index)

Perform a mutation operation on the provided individual, at a provided index
"""
function mutateAtIndex(gene_factory::Function, individual, index::Int64)
    t = copy(individual)
    t[index] = gene_factory(index)
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
    indexMinFitness = argmin(map(fitness, population))
    return population[indexMinFitness]
end

"""
    selectIndividual(population; k=5)

Selection using the tournament of size k. Assume that the smallest fitness is the best.
"""
function selectIndividual(fitness, population; k=5)
    populationSize = length(population)
    selectedIndividuals = []
    for _ in 1:k
        anInd = population[floor(Int64, rand()*populationSize) + 1]
        push!(selectedIndividuals, anInd)
    end
    return pickBestIndividual(fitness, selectedIndividuals)
end

gaLog(aString::String, shouldLog=true; color=:blue) = shouldLog && printstyled(aString, color=color)

default_termination_function(bestFitnesses) = false

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
    gene_factory::Function,
    numberOfGenes::Int64;

    maxNumberOfIterations=10,
    probMutation=0.2,
    seed=42,
    logging=true,
    filename="",
    condition_termination::Function=default_termination_function,
    population_size::Int64 = 10
)
    gaLog("BEGINNING - GA commit date 2022-01-23 - 15:59pm\n", logging; color=:red)
    Random.seed!(seed)
    population = createPopulation(population_size, gene_factory, numberOfGenes)
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
            index1 = selectIndividual(fitness, population)
            index2 = selectIndividual(fitness, population)
            newIndividual = crossover(index1, index2)
            if (rand() <= probMutation)
                newIndividual = mutate(gene_factory, newIndividual)
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
