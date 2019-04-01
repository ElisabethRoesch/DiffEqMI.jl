using OrdinaryDiffEq, Plots, Optim, Distributions
function param_ODEfunc(guess_A)
    function guess_ODEfunc(du, u, p, t)
      du .= ((u.^3)'guess_A)'
    end
    return guess_ODEfunc
end
function add_noise(in_data, noise_sigma)
    out_data = Array{Float64}(undef, size(in_data)[1], size(in_data)[2])
    if (noise_sigma>0)
        out_data = in_data + rand(Normal(0, noise_sigma), size(in_data)...)
    end
    return out_data
end
function L2_loss_fct(params)
    print(params)
    return sum(abs2,noisy_data .- make_ode(params))
end
function make_ode(init_temp_A)
    temp_u0 = init_temp_A[1,:]
    temp_A = init_temp_A[2:3,:]
    temp_ODEfunc = param_ODEfunc(temp_A)
    temp_prob = ODEProblem(temp_ODEfunc, temp_u0, tspan)
    temp_ode_data = Array(solve(temp_prob,Tsit5(),saveat=t))
    return temp_ode_data
end
