module DiffEqMI
	export
		diffeqflux_example,
		lorenz_example,
		mi_ode,
		add_noise,
		init_tester,
		tester,
		update_tester,
		L2_loss_fct;
	using OrdinaryDiffEq, Optim, Distributions
	include("mi.jl")
	include("example_systems.jl")
end
