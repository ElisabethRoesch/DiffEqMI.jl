mutable struct tester
    fnct
    current_params::Array{Float64,1}
    n_subs::Int64
    n_species::Int64
    tspans::Array{Tuple{Float64,Float64},1}
    datasize::Int64
    datasize_per_sub::Int64
    odes
    sols::Array{Float64,2}
end
# Declare the tester
function tester()
    return tester(
        x->0,       # fnct
        zeros(0),   # current_params
        0,          # n_subs
        0,          # n_species
        [(0.,0.)],  # tspans
        0,          # datasize
        0,          # datasize_per_sub
        nothing,    # odes
        zeros(0,0)) #sols
end
# Init the tester
function init_tester(tester, fnct, datasize, n_subs, n_species, total_tspan, u0_start_values, params_start_values)
    tester.current_params= vcat(u0_start_values...,params_start_values)
    tester.datasize = datasize
    tester.n_species = n_species
    tester.n_subs = n_subs
    tester.fnct = fnct
    tester.datasize_per_sub = trunc(Int, datasize/n_subs)
    tspan_per_sub = (total_tspan[2]-total_tspan[1])/n_subs
    tester.tspans = Array{Tuple{Float64,Float64},1}(undef,n_subs)
    for i in 1:n_subs
        tester.tspans[i] = (tspan_per_sub*(i-1), tspan_per_sub*(i))
    end
    inits = tester.current_params[1:(n_subs)*n_species]
    inits = reshape(inits,n_species,n_subs)
    DiffEqMI.make_multiple(tester)
    DiffEqMI.solve_multiple(tester)
end
#solve ODE
function make_ode(ode_prob, u0, tspan, datasize)
    t = range(tspan[1], tspan[2], length = datasize)
    ode_data = Array(solve(ode_prob,Tsit5(),saveat=t))
    return ode_data
end
# Add experimental noise
function add_noise(in_data::AbstractArray{Float64,2}, noise_sigma::Float64)
    out_data = Array{Float64}(undef, size(in_data)[1], size(in_data)[2])
    if (noise_sigma>0)
        out_data = in_data + rand(Normal(0, noise_sigma), size(in_data)...)
    end
    return out_data
end
# Create "sub" odes
function make_multiple(tester)
    fnct = tester.fnct
    n_subs = tester.n_subs
    tspans = tester.tspans
    n_species = tester.n_species
    inits_linear = tester.current_params[1:n_subs*n_species]
    inits = reshape(inits_linear,n_species,n_subs)
    params_start_values = tester.current_params[(n_subs*n_species)+1:end]
    odes = Array{ODEProblem,1}(undef, n_subs)
    for i in 1:n_subs
        i_u0 = inits[:,i]
        i_tspan = tspans[i]
        ode_prob = ODEProblem(fnct(params_start_values), i_u0, i_tspan)
        odes[i] = ode_prob
    end
    tester.odes = odes
end
# Solve the ODEs
function solve_multiple(tester)
    n_species = tester.n_species
    n_subs = tester.n_subs
    datasize = tester.datasize
    datasize_per_sub = tester.datasize_per_sub
    odes = tester.odes
    inits_linear = tester.current_params[1:n_subs*n_species]
    inits = reshape(inits_linear,n_species,n_subs)
    tspans = tester.tspans
    tester.sols = Array{Float64,2}(undef,n_species,datasize)
    for i in 1:n_subs
        tester.sols[:,datasize_per_sub*(i-1)+1:datasize_per_sub*i] = DiffEqMI.make_ode(odes[i], inits[:,i], tspans[i], datasize_per_sub)
    end
end
# Update model
function update_tester(tester, params)
    n_species = tester.n_species
    n_subs = tester.n_subs
    tester.current_params = params
    inits = tester.current_params[1:(n_subs)*n_species]
    inits = reshape(inits,n_species,n_subs)
    DiffEqMI.make_multiple(tester)
    DiffEqMI.solve_multiple(tester)
    return tester.sols
end
