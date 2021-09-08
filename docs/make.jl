using Documenter
using GeneticAlgorithm

push!(LOAD_PATH,"../src/")
makedocs(sitename="GeneticAlgorithm.jl Documentation",
         pages = [
            "Index" => "index.md",
            "An other page" => "anotherPage.md",
         ],
         format = Documenter.HTML(prettyurls = false)
)


#=
makedocs(
    sitename = "GeneticAlgorithm",
    format = Documenter.HTML(),
    modules = [GeneticAlgorithm]
)
=#

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/bergel/GeneticAlgorithm.jl",
    devbranch = "main"
)
