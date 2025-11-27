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

# Plot disc shape (reflected to show both sides)
ρ_min = Gradus.isco(m)
ρ_max = 25.0
ρ_vals = range(ρ_min, ρ_max, length=200)
z_vals = [cross_section(d, abs(ρ)) for ρ in ρ_vals]

p2 = plot(title="Thick disc cross-section (a=$a, λ=$eddington_ratio)", aspect_ratio=:equal)
# Right side of disc (positive ρ)
plot!(p2, ρ_vals, z_vals, label="Disc surface", linewidth=2, color=:blue)
plot!(p2, ρ_vals, -z_vals, label=false, linewidth=2, color=:blue)
# Left side of disc (negative ρ, mirrored)
plot!(p2, -ρ_vals, z_vals, label=false, linewidth=2, color=:blue)
plot!(p2, -ρ_vals, -z_vals, label=false, linewidth=2, color=:blue)
# Corona at x=0, y=±h
scatter!(p2, [0.0, 0.0], [h, -h], marker=:star, markersize=10, color=:orange, label="Corona (h=$h)")
xlabel!(p2, L"\rho" * " (GM/c²)")
ylabel!(p2, "z (GM/c²)")
display(p2)
