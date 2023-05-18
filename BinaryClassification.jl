### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 4e14b7bb-591a-4cfa-9e51-11918d11870c
using DelimitedFiles

# ╔═╡ 68c507ca-8542-4cbe-9510-939bb4f57aa4
using Statistics

# ╔═╡ f0696834-36e4-4081-b2ad-940852178cef
y = readdlm("C:/Users/Asus/OneDrive/Desktop/data/y_wine_data.txt")

# ╔═╡ aea1e670-5023-4eff-933a-542759bf2ace
X = [ones(length(y)) readdlm("C:/Users/Asus/OneDrive/Desktop/data/X_wine_data.txt")]

# ╔═╡ 4506c8bb-ceb7-4063-bf2f-75840eb8dc15
Δ(z) = 1 ./ (1 .+ exp.(-z))

# ╔═╡ 92b798bc-4a7a-4915-9bca-ccfb0f859c63
function J(X, y, θ, λ = 0)
	u = Δ(X * θ)
	R = θ' * θ
	return -(y' * log.(u) + (1 .- y)' * log.(1 .- u)) / length(y) + λ*R
end

# ╔═╡ 717beb46-99dc-43dd-ba49-f58423cc08ec
function δJ(X, y, θ, λ = 0)
	return X' * (Δ(X * θ) - y) / length(y) + 2 * λ * θ
end

# ╔═╡ 378029e6-d66d-4c1d-bcf4-fa0d3a22e0c4
function GD(X, y, θ_start, λ = 0, α = 0.1, T = 10000)
	θ = θ_start
	Jstr = []
	for i in 1:T
		θ = θ - α * δJ(X, y, θ, λ)
		v = J(X, y, θ, λ)
		push!(Jstr, v)
	end
	return θ
end

# ╔═╡ adcc72a0-e653-4581-b663-f18aa1012ab9
label1st, label2nd, label3rd = zeros(length(y)), zeros(length(y)), zeros(length(y))

# ╔═╡ ecbe06bb-042e-4c26-8a8a-01bdf7c860dd
function binarylabel()
	label1st = y .== 0 
	label2nd = y .== 1
	label3rd = y .== 2
	return label1st, label2nd, label3rd
end

# ╔═╡ 6e8af14c-e35b-4cac-af6d-62bded1b4a5b
lb0, lb1, lb2 = binarylabel()

# ╔═╡ 0c9f6b97-b229-4517-acc3-0879fe0bffed
mtrx_0 = zeros(14)

# ╔═╡ c8b03b4b-ce2d-476a-8689-3c71403574b8
best = [GD(X, lb0, mtrx_0) GD(X, lb1, mtrx_0) GD(X, lb2, mtrx_0)]

# ╔═╡ 15c583df-5cec-4e9c-880d-978662eaf9a0
function softmax(x)
    exp_x = exp.(x .- maximum(x, dims=2))
	Σ = exp_x ./ sum(exp_x, dims=2)
    return Σ
end

# ╔═╡ 246c3c0f-2163-466a-857e-b24ed9d00a83
function predict(X, best)
	y_predict = zeros(length(y))
	for i in 1:length(y)
		y_predict[i] = argmax(softmax(X[i, :]' * best))[2] - 1
	end
	return y_predict
end

# ╔═╡ a35fda2a-380e-41c0-a4a4-9019a6893b2a
accuracy = (sum(predict(X, best) .== y) / length(y)) * 100

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DelimitedFiles = "8bb1440f-4735-579b-a4ab-409b98df4dab"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "f8aed8cc7ec98e25caba5c40ea614d484439ba58"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╠═4e14b7bb-591a-4cfa-9e51-11918d11870c
# ╠═68c507ca-8542-4cbe-9510-939bb4f57aa4
# ╠═f0696834-36e4-4081-b2ad-940852178cef
# ╠═aea1e670-5023-4eff-933a-542759bf2ace
# ╠═4506c8bb-ceb7-4063-bf2f-75840eb8dc15
# ╠═92b798bc-4a7a-4915-9bca-ccfb0f859c63
# ╠═717beb46-99dc-43dd-ba49-f58423cc08ec
# ╠═378029e6-d66d-4c1d-bcf4-fa0d3a22e0c4
# ╠═adcc72a0-e653-4581-b663-f18aa1012ab9
# ╠═ecbe06bb-042e-4c26-8a8a-01bdf7c860dd
# ╠═6e8af14c-e35b-4cac-af6d-62bded1b4a5b
# ╠═0c9f6b97-b229-4517-acc3-0879fe0bffed
# ╠═c8b03b4b-ce2d-476a-8689-3c71403574b8
# ╠═15c583df-5cec-4e9c-880d-978662eaf9a0
# ╠═246c3c0f-2163-466a-857e-b24ed9d00a83
# ╠═a35fda2a-380e-41c0-a4a4-9019a6893b2a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
