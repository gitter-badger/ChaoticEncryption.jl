using Images
using FileIO

"""
    substitution_encryption(path_to_image, keys, path_for_result="./encrypted.png")

Performs substitution encryption on a given image with the given keys.

# Algorithm
Iterates simulataneously over each pixel and key, and XORs the pixel value
(all R, G, and B) with the given key. Hence, the order of the keys matter.

# Arguments
- `path_to_image::String`: The path to the image to be encrypted.
- `keys::Array{Int64, 1}`: Keys for encryption.
- `path_for_result::String`: The path for storing the encrypted image.

# Example
```julia-repl
julia> keys = logistic_key(0.01, 3.97, 719 * 718)
516242-element Array{Any,1}:
   0
  44
   7
  26
  14
 224
   ⋮
 115
  65
 126
 152
  74
 198
julia> substitution_encryption("D:\\Saransh\\Docs\\PyCon_Squared.jpg", keys)
ENCRYPTING
ENCRYPTED
```
"""
function substitution_encryption(
    path_to_image::String,
    keys::Array{Int64, 1},
    path_for_result::String="./encrypted.png",
)
    image = load(path_to_image)

    # Generating dimensions of the image
    height = size(image)[1]
    width = size(image)[2]

    if length(keys) != height * width
        throw(ArgumentError("Number of keys must be equal to height * width of image."))
    end

    z = 1

    encryptedImage = copy(image)

    println("ENCRYPTING")

    for i = 1:height
        for j = 1:width
            rgb = encryptedImage[i, j]
            r, g, b = trunc(Int, rgb.r * 255), trunc(Int, rgb.g * 255), trunc(Int, rgb.b * 255)
            encryptedImage[i, j] = RGB((r ⊻ keys[z]) / 255, (g ⊻ keys[z]) / 255, (b ⊻ keys[z]) / 255)
            z += 1
        end
    end

    println("ENCRYPTED")
    save(path_for_result, encryptedImage)
end


"""
    substitution_decryption(path_to_image, keys, path_for_result="./decrypted.png")

Performs substitution decryption on a given image with the given keys.

# Algorithm
Iterates simulataneously over each pixel and key, and XORs the pixel value
(all R, G, and B) with the given key. Hence, the keys provided must be the same
as the ones provided during encryption.

# Arguments
- `path_to_image::String`: The path to the image to be decrypted.
- `keys::Array{Int64, 1}`: Keys for decryption.
- `path_for_result::String`: The path for storing the decrypted image.

# Example
```julia-repl
julia> substitution_decryption("./encrypted.png", keys)
DECRYPTING
DECRYPTED
```
"""
function substitution_decryption(
    path_to_image::String,
    keys::Array{Int64, 1},
    path_for_result::String="./decrypted.png",
)
    image = load(path_to_image)

    # Generating dimensions of the image
    height = size(image)[1]
    width = size(image)[2]

    if length(keys) != height * width
        throw(ArgumentError("Number of keys must be equal to height * width of image."))
    end

    z = 1

    decryptedImage = copy(image)
    println("DECRYPTING")

    for i = 1:height
        for j = 1:width
            rgb = decryptedImage[i, j]
            r, g, b = trunc(Int, rgb.r * 255), trunc(Int, rgb.g * 255), trunc(Int, rgb.b * 255)
            decryptedImage[i, j] = RGB((r ⊻ keys[z]) / 255, (g ⊻ keys[z]) / 255, (b ⊻ keys[z]) / 255)
            z += 1
        end
    end

    println("DECRYPTED")
    save(path_for_result, decryptedImage)
end
