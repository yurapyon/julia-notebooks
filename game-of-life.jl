### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 953e8c22-6a09-4fe5-9539-163cd3f86353
create_buffer(w, h) = falses(w, h)

# ╔═╡ 9a0e0268-cd97-466f-a600-e65974d30346
mutable struct Runtime
	width::UInt
	height::UInt
	front_buffer::Matrix{Bool}
	back_buffer::Matrix{Bool}
	function Runtime(w, h)
		new(w, h, create_buffer(w, h), create_buffer(w, h))
	end
end

# ╔═╡ 22f74b76-dd9b-423d-b8e1-c0d5dcbd0464
function index(rt, x, y)
	rt.front_buffer[mod1(x, rt.width), mod1(y, rt.height)]
end

# ╔═╡ 2ca4dd8b-b876-47ef-9b11-a424aa434086
function count_neighbors(rt, x, y)
	ret = 0
	for i in -1:1
		for j in -1:1
			if i == 0 && j == 0; continue end
			ret += index(rt, x+i, y+j)
		end
	end
	ret
end

# ╔═╡ d1c47dc1-9d56-47c3-b75e-3cc27798a7dc
function fillrand(rt)
	rt.front_buffer = rand([true, false], rt.width, rt.height)
end

# ╔═╡ 6e1d2e7a-4d9d-4400-8cdc-dffc836b6003
function swap!(rt)
	temp = rt.front_buffer
	rt.front_buffer = rt.back_buffer
	rt.back_buffer = temp
end

# ╔═╡ bab75c98-6e5a-489c-9100-6565a5790db5
function step!(rt)
	is, js = axes(rt.front_buffer) 
	for i in is
		for j in js
			alive_now = index(rt, i, j)
			ct = count_neighbors(rt, i, j)
			alive = should_live(alive_now, ct)
			rt.back_buffer[i,j] = alive
		end
	end
	swap!(rt)
end

# ╔═╡ bb2a8849-12fc-4aab-a085-2fa5306ba7d9
function Base.show(rt::Runtime)
	is, js = axes(rt.front_buffer) 
	for i in is
		for j in js
			print(rt.front_buffer[i,j] ? "[]" : "  ")
		end
		println()
	end
end

# ╔═╡ 89321cb7-0704-48b8-abd6-b07ab009a51e
begin
	runtime = Runtime(20,30)
	fillrand(runtime)
	for _ in 1:40
		println("-"^runtime.width)
		show(runtime)
		step!(runtime)
		println()
		println()
	end
end

# ╔═╡ 8afa49f3-2137-4f58-a56b-1657e426ad51
# ╠═╡ disabled = true
#=╠═╡
function should_live(alive_now, ct)
	if ct <= 1
		false
	elseif ct == 2
		alive_now && true
	elseif ct == 3
		true
	else
		false
	end
end
  ╠═╡ =#

# ╔═╡ e987feda-cedc-44bf-ae6d-d2588d9b0130
function should_live(alive_now, neighbors)
	x = neighbors
	should_spawn = -x^2 + 6x - 8
	should_stay = -0.5x^2 + 2.5x - 2
	r = rand() / 8
	alive_now ? should_stay > 0.9 : should_spawn > 0.9
end

# ╔═╡ Cell order:
# ╠═953e8c22-6a09-4fe5-9539-163cd3f86353
# ╠═9a0e0268-cd97-466f-a600-e65974d30346
# ╠═22f74b76-dd9b-423d-b8e1-c0d5dcbd0464
# ╠═2ca4dd8b-b876-47ef-9b11-a424aa434086
# ╠═e987feda-cedc-44bf-ae6d-d2588d9b0130
# ╠═8afa49f3-2137-4f58-a56b-1657e426ad51
# ╠═d1c47dc1-9d56-47c3-b75e-3cc27798a7dc
# ╠═6e1d2e7a-4d9d-4400-8cdc-dffc836b6003
# ╠═bab75c98-6e5a-489c-9100-6565a5790db5
# ╠═bb2a8849-12fc-4aab-a085-2fa5306ba7d9
# ╠═89321cb7-0704-48b8-abd6-b07ab009a51e
