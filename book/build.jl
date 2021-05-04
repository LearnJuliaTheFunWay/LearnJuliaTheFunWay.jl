import Books
using LearnJuliaTheFunWay

function install_fonts()
    @info "installing font[NotoSerifCJKsc]..."
    fonts_dir = joinpath(homedir(), ".fonts")
    run(`wget -q -O tmp.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKsc-hinted.zip`)
    run(`unzip tmp.zip -d $(joinpath(fonts_dir, "NotoSerifCJKsc"))`)
    run(`rm tmp.zip`)
    run(`fc-cache --verbose $fonts_dir`)
end

function build()
    Books.is_ci() && install_fonts()

    @info "building Chinese version..."
    mkpath("_build")
    Books.gen(; M=LearnJuliaTheFunWay.CodeSnippets, project="zh", fail_on_error=true)
    Books.build_all(; project="zh")
    mv("_build", "homepage/zh"; force=true)

    @info "building English version..."
    mkpath("_build")
    Books.gen(; M=LearnJuliaTheFunWay.CodeSnippets, project="en", fail_on_error=true)
    Books.build_all(; project="en")
    mv("_build", "homepage/en"; force=true)
end

build()
