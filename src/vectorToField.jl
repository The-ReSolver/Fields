# This file contain the utility functions to allow the transformation of a
# spectral field into an equivalent state vector

function _velocityCoefficientsToVector!(vector, velocityCoefficients::SpectralField{Ny, Nz, Nt}) where {Ny, Nz, Nt}
    Nz_spec = size(velocityCoefficients, 2)
    for nt in 1:Nt, nz in 1:Nz_spec, ny in 1:Ny
        vector[2*(ny + Ny*(nz - 1) + Ny*Nz_spec*(nt - 1)) - 1] = real(velocityCoefficients[ny, nz, nt])
        vector[2*(ny + Ny*(nz - 1) + Ny*Nz_spec*(nt - 1))]     = imag(velocityCoefficients[ny, nz, nt])
    end

    return vector
end

function _vectorToVelocityCoefficients!(velocityCoefficients::SpectralField{Ny, Nz, Nt}, vector) where {Ny, Nz, Nt}
    Nz_spec = size(velocityCoefficients, 2)
    for nt in 1:Nt, nz in 1:Nz_spec, ny in 1:Ny
        velocityCoefficients[ny, nz, nt] = vector[2*(ny + Ny*(nz - 1) + Nz_spec*Ny*(nt - 1)) - 1] + 1im*vector[2*(ny + Ny*(nz - 1) + Nz_spec*Ny*(nt - 1))]
    end

    return velocityCoefficients
end
