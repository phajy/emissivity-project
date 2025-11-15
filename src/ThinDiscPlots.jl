using Gradus, Plots

### Thin disc geometry images ###

## Single spin and inclination angle  
m = KerrMetric(1.0, 0.99)
x = SVector(0.0, 1000.0, deg2rad(75), 0.0)
d = ThinDisc(Gradus.isco(m), 20.0)    #disc geometry thin disc from ISCO to 20 r_g
λ_max = 2*x[2]

# defining point function
# point function based on time of disk intersection
    #time_coord = PointFunction((m,gp,λ)-> gp.x[1]) #point function identifying time coordinate at the end of each geodesic
    #filter_disc_intersect = ConstPointFunctions.filter_intersected() #filtering the geodesics to find those which intersect the disc
    #pf_t = time_coord ∘ filter_disc_intersect #creating reverse order list of the geodesics which intersect the disc
# point function based on redshfit of the photons that intersect with the disk 
pf_r = ConstPointFunctions.redshift(m, x) ∘ ConstPointFunctions.filter_intersected()

#rendering image of black hole disc 
α, β, image = rendergeodesics(
    m, 
    x, 
    d, 
    λ_max,
    pf = pf_r, #point function (defining vel)
    # image size
    image_width = 800,
    image_height = 400,
    # impact parameter axes - 'zoom'
    αlims = (-25, 25),
    βlims = (-25, 25),
    verbose = true)
heatmap(α, β, image, aspect_ratio = 1, title = "Inclination = 75°, Spin = 0.99", clims = (0, 1.3))


## animation of disc image over inclination angles
m = KerrMetric(1.0, 0.0)
anim = @animate for inc in vcat(2:2:90, 90:-2:2)
    x = SVector(0.0, 1000.0, deg2rad(inc), 0.0)
    d = ThinDisc(Gradus.isco(m), 20.0)
    λ_max = 2*x[2]
    pf_r = ConstPointFunctions.redshift(m, x) ∘ ConstPointFunctions.filter_intersected()
    α, β, image = rendergeodesics(
        m, 
        x, 
        d, 
        λ_max,
        pf = pf_r, #point function (defining vel)
        # image size
        image_width = 800,
        image_height = 400,
        # impact parameter axes - 'zoom'
        αlims = (-25, 25),
        βlims = (-25, 25),
        verbose = false)
    heatmap(α, β, image, aspect_ratio = 1, title = "Inclination = $(inc)°", clims = (0, 1.3))
end
gif(anim, "thin_disc_inclination4.gif", fps = 15)


## animation of disc image over different black hole spins
x = SVector(0.0,1000.0,deg2rad(75),0.0)
anim = @animate for a in (-0.99:0.03:0.99)
    m = KerrMetric(1.0,a)
    d = ThinDisc(Gradus.isco(m), 20.0)
    λ_max = 2*x[2]
    pf_r = ConstPointFunctions.redshift(m, x) ∘ ConstPointFunctions.filter_intersected()
    α, β, image = rendergeodesics(
        m, 
        x, 
        d,
        λ_max,
        pf = pf_r, #point function (defining vel)
        # image size
        image_width = 800,
        image_height = 400,
        # impact parameter axes - 'zoom'
        αlims = (-25, 25),
        βlims = (-25, 25),
        verbose = false)
    heatmap(α, β, image, aspect_ratio = 1, title = "a=$(round(a,digits=2))", clims = (0, 1.3))
end
gif(anim, "thin_disc_spin2.gif", fps = 10)

