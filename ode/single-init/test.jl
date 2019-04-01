a = 3
b = 3

aw = [2]
function sss(temp_a,temp_b)
    temp_a =5
end
function s(temp_a::HPOptimisationCache)
    temp_a.a =5
end
struct HPOptimisationCache
    a::Int16
end

eee = HPOptimisationCache(1)

s(eee)
println(eee.a)
