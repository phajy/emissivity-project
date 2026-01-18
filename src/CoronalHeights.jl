using Gradus, Plots, LaTeXStrings, SpectralFitting

m = KerrMetric(1.0, 0.98) #spin of MCG 6-30-15
d = ThinDisc(Gradus.isco(m), 1000.0) #disc out to 1000 grav. radii
x = SVector(0.0, 1000.0, deg2rad(60),0.0)

p = plot(title="emissivity profiles for varying coronal heights")
for H in (5.0:5.0:30.0)
    model = LampPostModel(h=H) #corona height in grav. radii 
    profile = emissivity_profile(m, d, model; n_samples = 128)
    plot!(p, profile, label="h=$H"; xlabel="Radius (GM/c²)", ylabel="Emissivity")
end
display(p)

# plotting line profiles for a range of different coronal heights 
p1 = plot(title="line profiles for varying coronal height")
for H in (5.0:5.0:30.0)
    model = LampPostModel(h=H) #using defaults for theta (0.01rad) and phi (0)
    profile = emissivity_profile(m,d,model; n_samples=128)
    bins, flux = lineprofile(m,x,d,profile)
    plot!(p1,bins,flux, label="h=$H"; xlabel="g", ylabel="flux")
end   
display(p1)