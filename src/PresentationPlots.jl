using Gradus, Plots

### Thin disc geometry images ###
## Single spin and inclination angle 
m = KerrMetric(1.0, 0.998)   #spacetime metric
x = SVector(0.0, 1000.0, deg2rad(70), 0.0)    #position
d = ThinDisc(0.0,400.0)    #disc geometry
λ_max = 2*x[2]
α = range(-10.0, 10.0, 100)
β = range(-10.0, 10.0, 100)

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