# This file contains the custom type to define a scalar field in physical space
# for a rotating plane couette flow.

export PhysicalField

struct PhysicalField{Ny, Nz, Nt, T, A<:AbstractArray{T, 3}} <: AbstractArray{T, 3}
    data::A
    # construct from size and type
    function PhysicalField(Ny::Int, Nz::Int, Nt::Int, ::Type{T}=Float64) where {T<:Real}
        data = zeros(Ny, Nz, Nt)
        new{Ny, Nz, Nt, T, typeof(data)}(data)
    end

    # construct from data
    function PhysicalField(data::A) where {T<:Real, A<:AbstractArray{T, 3}}
        shape = size(data)
        new{shape[1], shape[2], shape[3], T, A}(data)
    end
end

# define interface
Base.size(::PhysicalField{Ny, Nz, Nt}) where {Ny, Nz, Nt} = (Ny, Nz, Nt)
Base.IndexStyle(::Type{<:PhysicalField}) = Base.IndexLinear()

# get parent array
Base.parent(u::PhysicalField) = u.data

Base.@propagate_inbounds function Base.getindex(u::PhysicalField, I...)
    @boundscheck checkbounds(parent(u), I...)
    @inbounds ret = parent(u)[I...]
    return ret
end

Base.@propagate_inbounds function Base.setindex!(u::PhysicalField, v, I...)
    @boundscheck checkbounds(parent(u), I...)
    @inbounds parent(u)[I...] = v
    return v
end