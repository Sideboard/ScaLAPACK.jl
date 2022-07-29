using ScaLAPACK
using Documenter

DocMeta.setdocmeta!(ScaLAPACK, :DocTestSetup, :(using ScaLAPACK); recursive=true)

makedocs(;
    modules=[ScaLAPACK],
    authors="Sascha Klawohn <sascha.klawohn@warwick.ac.uk>",
    repo="https://github.com/Sideboard/ScaLAPACK.jl/blob/{commit}{path}#{line}",
    sitename="ScaLAPACK.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://sideboard.github.io/ScaLAPACK.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Sideboard/ScaLAPACK.jl",
    devbranch="main",
)
