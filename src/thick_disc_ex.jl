using Gradus
using Plots
using LaTeXStrings

# Kerr metric
a = 0.98
m = KerrMetric(M = 1.0, a = a)

# Observer position
θ = 60
x = SVector(0.0, 1000.0, deg2rad(θ), 0.0)

# Lamppost model emissivity profile
h = 10.0
model = LampPostModel(h = h)


# Shakura-Sunyaev thick disc with Eddington ratio 0.5
eddington_ratio = 0.5
d = ShakuraSunyaev(m, eddington_ratio = eddington_ratio)
# d = ThinDisc()

# Calculate line profile
profile = emissivity_profile(m, d, model; n_samples=128)
bins, flux = lineprofile(m, x, d, profile)
# Plot line profile
p = plot(title="Lamppost corona above a thick disc")
plot!(p, bins, flux, label="a=$a λ=$eddington_ratio h=$h"; xlabel="g", ylabel="flux", legend=:topleft)
#display(p)

# Plot disc shape (reflected to show both sides)
ρ_min = Gradus.isco(m) #radii
ρ_max = 25.0
ρ_vals = range(ρ_min, ρ_max, length=200)
z_vals = [cross_section(d, abs(ρ)) for ρ in ρ_vals]

p2 = plot(title="Thick disc cross-section (a=$a, λ=$eddington_ratio)", aspect_ratio=:equal)
# Right side of disc (positive ρ)
plot!(p2,ρ_vals, z_vals, label="Disc surface", linewidth=2, color=:blue)
plot!(p2, ρ_vals, -z_vals, label=false, linewidth=2, color=:blue)
# Left side of disc (negative ρ, mirrored)
plot!(p2, -ρ_vals, z_vals, label=false, linewidth=2, color=:blue)
plot!(p2, -ρ_vals, -z_vals, label=false, linewidth=2, color=:blue)
# Corona at x=0, y=±h
scatter!(p2, [0.0, 0.0], [h, -h], marker=:star, markersize=10, color=:orange, label="Corona (h=$h)")
xlabel!(p2, L"\rho" * " (GM/c²)")
ylabel!(p2, "z (GM/c²)")
display(p2)



#plotting line profiles for a range of eddington ratios
colours = ("blue","red","green","purple","deepskyblue")
E = [0.2,0.4,0.6,0.8,1.0]
p3 = plot(title="emissivity functions for varying disc thickness")
p4 = plot(title="line profiles for varying disc thickness")
for i in [1,2,3,4,5]
    e = E[i]
    d = ShakuraSunyaev(m, eddington_ratio = e)
    profile = emissivity_profile(m, d, model; n_samples = 128)
    bins, flux = lineprofile(m, x, d, profile)
    plot!(p3, profile, label="λ=$e"; xlabel="Radius (r_g)", ylabel="Emissivity", colour = colours[i], legend=:topright)
    plot!(p4, bins, flux, label="λ=$e"; xlabel="g", ylabel="flux", colour = colours[i], legend=:topleft)
end
display(p3)
display(p4)

#plotting disc shape for different thicknesses, using same radii (rho) values as previously 
p5 = plot(title= "disc cross sections, a=$a", aspect_ratio=:equal)
for i in [1,2,3,4,5] 
    d = ShakuraSunyaev(m, eddington_ratio = E[i])
    z_vals = [cross_section(d, abs(ρ)) for ρ in ρ_vals]
    # Right side of disc (positive ρ)
    e = E[i]
    plot!(p5, ρ_vals, z_vals, label="λ=$e", linewidth=2, colour=colours[i])
    plot!(p5, ρ_vals, -z_vals, label=false, linewidth=2, colour=colours[i])
    # Left side of disc (negative ρ, mirrored)
    plot!(p5, -ρ_vals, z_vals, label=false , linewidth=2,colour=colours[i])
    plot!(p5, -ρ_vals, -z_vals, label=false, linewidth=2, colour=colours[i])
end 
scatter!(p5, [0.0, 0.0], [h, -h], marker=:star, markersize=10, color=:orange, label="Corona (h=$h)")
xlabel!(p5, "Radius (GM/c²)")
ylabel!(p5, "Height, H (GM/c²)")
hline!(p5, [0,0], colour = "black", label=false)