# Simulating a turtle

function gene_factory(index::Int64)
    return isodd(index) ? rand("⬇⬅➡⬆") : rand(-30:30)
end

# Return the number that are identical
function fitness_example(ind)
    solution = ['⬅', -27, '⬅', -6, '⬆', 2]
    t = [a == b for (a, b) in zip(solution, ind)]
    return length(filter((p) -> !p, t))
end

@test fitness_example(['⬆', -6, '⬆', 2, '⬅', -27]) == 6
@test fitness_example(['⬅', -27, '⬅', -6, '⬆', 2]) == 0
@test runGA(fitness_example, gene_factory, 6, maxNumberOfIterations=2000, logging=false)[1] == ['⬅', -27, '⬅', -6, '⬆', 2]
