using Test, GeneticAlgorithm

STRING_TO_FIND = "hello"

function createGeneExample() 
    return rand(STRING_TO_FIND)
end

function fitnessExample(ind) 
    allDifferent = filter(((a,b),) -> a != b, collect(zip(STRING_TO_FIND, ind)))
    return length(allDifferent)
end

@test join(runGA(fitnessExample, createGeneExample, 5, maxNumberOfIterations=200)[1]) == "hello"
