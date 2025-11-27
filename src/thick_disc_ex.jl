# Thick disc example

using Gradus
using Plots
using LaTeXStrings

# Kerr metric
a = 0.8
m = KerrMetric(M = 1.0, a = a)

# Shakura-Sunyaev thick disc with Eddington ratio 0.2
eddington_ratio = 0.2
d = ShakuraSunyaev(m, eddington_ratio = eddington_ratio)

# Observer position
θ = 55.0
x = SVector(0.0, 1000.0, deg2rad(θ), 0.0)

# Lamppost model emissivity profile
h = 10.0
model = LampPostModel(h = h)
profile = emissivity_profile(m, d, model; n_samples=128)

# Calculate line profile
bins, flux = lineprofile(m, x, d, profile)

# Plot line profile
p = plot(title="Lamppost corona above a thick disc")
plot!(p, bins, flux, label="a=$a λ=$eddington_ratio h=$h"; xlabel="g", ylabel="flux", legend=:topleft)
display(p)
