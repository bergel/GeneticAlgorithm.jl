using Test, GeneticAlgorithm

STRING_TO_FIND = "hellohellohello"

function createGeneExample() 
    return rand(STRING_TO_FIND)
end

function fitnessExample(ind) 
    allDifferent = filter(((a,b),) -> a != b, collect(zip(STRING_TO_FIND, ind)))
    return length(allDifferent)
end

@test join(runGA(fitnessExample, createGeneExample, length(STRING_TO_FIND), maxNumberOfIterations=10, logging=false)[1]) == "hello"
