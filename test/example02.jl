using Test, GeneticAlgorithm

STRING_TO_FIND = "hellohellohello"

function createGeneExample(index::Int64)
    return rand(STRING_TO_FIND)
end

function fitnessExample(ind)
    allDifferent = filter(((a,b),) -> a != b, collect(zip(STRING_TO_FIND, ind)))
    return length(allDifferent)
end

@test join(runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false)[1]) == STRING_TO_FIND

# Try the logging
@test join(runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false)[1]) == STRING_TO_FIND

# Try WITH NO condition termination
res, best_fitnesses = runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false)
@test join(res) == STRING_TO_FIND
@test length(best_fitnesses) == 200

# Try WITH condition termination
ct(fitnesses::Vector{Number}) = last(fitnesses) == 0
res, best_fitnesses = runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false; condition_termination=ct)
@test join(res) == STRING_TO_FIND
@test length(best_fitnesses) == 97

# Try WITH condition termination and large population
ct(fitnesses::Vector{Number}) = last(fitnesses) == 0
res, best_fitnesses = runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false; condition_termination=ct, population_size = 50)
@test join(res) == STRING_TO_FIND
@test length(best_fitnesses) == 8

# Try WITH condition termination and very large population
ct(fitnesses::Vector{Number}) = last(fitnesses) == 0
res, best_fitnesses = runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false; condition_termination=ct, population_size = 2_000)
@test join(res) == STRING_TO_FIND
@test length(best_fitnesses) == 5

# Try persistence
@test join(runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false, filename="foo.csv")[1]) == STRING_TO_FIND
rm("foo.csv")
rm("foo.csv-individuals", recursive=true, force=true)
