# This is the example of the diffeqflux blog post.
function diffeqflux_example(param)
    function guess_ODEfunc(du, u, p, t)
        du[1] = param[1]*u[2]^3 + param[2]*u[1]^3
        du[2] = param[3]*u[2]^3 + param[4]*u[1]^3
    end
    return guess_ODEfunc
end


# This is the example of the diffeqflux blog post.
function diffeqflux_example_old(guess_A)
    function guess_ODEfunc(du, u, p, t)
      du .= ((u.^3)'guess_A)'
    end
    return guess_ODEfunc
end


# This is lorenz.
function lorenz_example(guess_p)
    function guess_ODEfunc(du,u,p,t)
     du[1] = guess_p[1](u[2]-u[1])
     du[2] = u[1]*(guess_p[2]-u[3]) - u[2]
     du[3] = u[1]*u[2] - guess_p[3]*u[3]
    end
    return guess_ODEfunc
end
# TODO add other systems. Maybe Rössler system, three gene or bifurcating systems.
