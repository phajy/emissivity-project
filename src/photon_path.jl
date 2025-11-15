# photon trajectory example
using Gradus, Plots, LaTeXStrings

m = KerrMetric(1.0,0.0)
# observer position
x = SVector(0.0, 10000.0, π/2, 0.0)

# set up impact parameter space
α = collect(range(-10.0, 10.0, 20))
β = fill(0, size(α))

# build initial velocity and position vectors
vs = map_impact_parameters(m, x, α, β)
xs = fill(x, size(vs))

sols = tracegeodesics(m, xs, vs, 20000.0)

plot_paths(sols, legend = false, n_points = 2048, title = "Photon paths around 
    Kerr black hole (a = 0.0)", xlabel = L"\text{X} (r_g)", ylabel = L"\text{Y} (r_g)")
plot_horizon!(m, lw = 2.0, color = :black)