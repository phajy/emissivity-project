using Gradus, Plots

### Thin disc geometry images ###
## Single spin and inclination angle 
m = KerrMetric(1.0, 0.0)   #spacetime metric
x = SVector(0.0, 1000.0, deg2rad(70), 0.0)    #position
d = ThinDisc(Gradus.isco(m), 20.0)    #disc geometry thin disc from ISCO to 20 r_g
λ_max = 2*x[2]

#defining point function
time_coord = PointFunction((m,gp,λ)-> gp.x[1]) #point function identifying time coordinate at the end of each geodesic
filter_disc_intersect = ConstPointFunctions.filter_intersected() #filtering the geodesics to find those which intersect the disc
pf = time_coord ∘ filter_disc_intersect #creating reverse order list of the geodesics which intersect the disc

#rendering image of black hole disc 
α, β, image = rendergeodesics(
    m, 
    x, 
    d, 
    λ_max,
    pf = pf, #point function (defining vel)
    # image size
    image_width = 1200,
    image_height = 800,
    # impact parameter axes - 'zoom'
    αlims = (-20, 20),
    βlims = (-10, 10),
    verbose = true)

heatmap(α, β, image, aspect_ratio = 1)

# animation of disc image over inclination angles
# redshift point function
redshift_pf = ConstPointFunctions.redshift(m, x) ∘ ConstPointFunctions.filter_intersected()
anim = @animate for inc in vcat(10:10:80, 70:-10:20)
    x = SVector(0.0, 1000.0, deg2rad(inc), 0.0)
    α, β, image = rendergeodesics(
        m, 
        x, 
        d, 
        λ_max,
        pf = redshift_pf, #point function (defining vel)
        # image size
        image_width = 800,
        image_height = 400,
        # impact parameter axes - 'zoom'
        αlims = (-25, 25),
        βlims = (-25, 25),
        verbose = false)
    heatmap(α, β, image, aspect_ratio = 1, title = "Inclination = $(inc)°", clims = (0, 1.3))
end
gif(anim, "thin_disc_inclination.gif", fps = 15)
