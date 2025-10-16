using Gradus, Plots
d = ThinDisc(0.0,400.0)
x = SVector(0.0,1000.0,deg2rad(40),0.0)
m = KerrMetric(1.0,0.998)
maxrₑ=50.0
ε(r)=r^(-3)
gs = range(0.0,1.2,500)
_,flux = lineprofile(gs,ε,m,x,d,maxrₑ=maxrₑ, verbose=true)
plot(gs,flux, legend=false)

savefig("/home/xv22578/Julia_tests/line_profile_test2.png")