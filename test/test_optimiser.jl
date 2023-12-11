@testset "Optimisation                  " begin
    # initialise inputs to optimisation
    Ny = 5; Nz = 3; Nt = 2; M = 1;
    y = collect(range(-1, 1, length=Ny))
    g = Grid(y, Nz, Nt, DiffMatrix(y, 3, 1), DiffMatrix(y, 3, 2), quadweights(y, 2), 1.0, 1.0)
    a = SpectralField(Grid(ones(M), Nz, Nt, Matrix{Float64}(undef, 0, 0), Matrix{Float64}(undef, 0, 0), ones(M), 1.0, 1.0))
    a .= rand(ComplexF64, M, (Nz >> 1) + 1, Nt)
    modes = rand(ComplexF64, 3*Ny, M, (Nz >> 1) + 1, Nt)
    options = OptOptions(; maxiter=2)

    # perform single iteration of optimisation
    _, trace = @test_nowarn optimise!(a, g, modes, 100, 0.5, opts=options)

    # test the trace outputs
    @test length(trace.value) == length(trace.g_norm) == length(trace.iter) == length(trace.time) == 3
    @test trace.iter == [0, 1, 2]
end