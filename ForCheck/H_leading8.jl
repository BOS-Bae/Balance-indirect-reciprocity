function H_L3(ki,kj,ij)
    return ((1/2)*(1+ij-kj+kj*ij)-ki)^2
end

function H_L4(ki,kj,ij)
    return ((1/4)*(-kj +3*ij*kj + ij + ij*ki - kj*ki + 1 + ki - ij*kj*ki)-ki)^2
end

function H_L5(ki,kj,ij)
    return ((1/4)*(-kj + 3*ij*kj + ki*kj +1 -ki + ij*ki*kj + ij - ij*ki)-ki)^2
end

function H_L6(ki,kj,ij)
    return (kj*ij-ki)^2
end

function H_L7(ki,kj,ij)
    return ((1/2)*(-ki*kj + ki + ij + kj*ij)-ki)^2
end

function H_L8(ki,kj,ij)
    return ((1/4)*(kj + 3*kj*ij - kj*ki -1 +ki + ij - ij*ki + ij*kj*ki)-ki)^2
end

Binary_o = [[1,1,1],[-1,-1,1],[1,-1,-1],[-1,1,-1],[-1,1,1],[1,-1,1],[1,1,-1],[-1,-1,-1]]

for i in 1:8
    o_ki = Binary_o[i][1]
    o_kj = Binary_o[i][2]
    o_ij = Binary_o[i][3]
    println("\n", i)
    println("L3 :", H_L3(o_ki,o_kj,o_ij))
    println("L4 :", H_L4(o_ki,o_kj,o_ij))
    println("L5 :", H_L5(o_ki,o_kj,o_ij))
    println("L6 :", H_L6(o_ki,o_kj,o_ij))
    println("L7 :", H_L7(o_ki,o_kj,o_ij))
    println("L8 :", H_L8(o_ki,o_kj,o_ij))
end