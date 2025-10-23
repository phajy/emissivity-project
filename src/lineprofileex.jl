using Gradus, Plots

anim = @animate for a in (0.0:0.05:0.99)
    m = KerrMetric(a=a)
    d = ThinDisc(0.0, Inf)
    x = SVector(0.0, 1000.0, deg2rad(40), 0.0)
    maxrₑ=400.0
    ε(r)=r^(-3)
    gs = range(0.0,1.2,500)
    # lineprofile sets r_in to the ISCO plus espilon by default
    _,flux = lineprofile(gs,ε,m,x,d,maxrₑ=maxrₑ, verbose=true)
    flux_scaled = flux .* (0.015 / maximum(flux))
    plot(gs, flux_scaled, legend=false, xlims=(0.25, 1.25), ylims=(0, 0.018), xlabel="g", ylabel="Flux", title="Line profile for a=$(round(a,digits=2))")
end
gif(anim, "line_profile.gif", fps = 10)
