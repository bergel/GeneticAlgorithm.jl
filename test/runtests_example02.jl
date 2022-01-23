using Test, GeneticAlgorithm

STRING_TO_FIND = "hellohellohello"

function createGeneExample() 
    return rand(STRING_TO_FIND)
end

function fitnessExample(ind) 
    allDifferent = filter(((a,b),) -> a != b, collect(zip(STRING_TO_FIND, ind)))
    return length(allDifferent)
end

@test join(runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false)[1]) == STRING_TO_FIND

# Try the logging
@test join(runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false)[1]) == STRING_TO_FIND

# Try persistence 
@test join(runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=200, logging=false, filename="foo.csv")[1]) == STRING_TO_FIND
rm("foo.csv")
rm("foo.csv-individuals", recursive=true, force=true)
