using JSON
using Printf

"""
    read_arc_task(filepath::String)

Read an ARC task from a JSON file and return the parsed data.
"""
function read_arc_task(filepath::String)
    return JSON.parsefile(filepath)
end

"""
    display_grid(grid::Vector{Any})

Display a colored grid representation of the ARC task input/output.
Colors are represented using ANSI escape codes.
"""
function display_grid(grid::Vector{Any})
    # ANSI color codes for different numbers (0-9)
    colors = [
        "\e[0m",      # 0: Default
        "\e[31m",     # 1: Red
        "\e[32m",     # 2: Green
        "\e[33m",     # 3: Yellow
        "\e[34m",     # 4: Blue
        "\e[35m",     # 5: Magenta
        "\e[36m",     # 6: Cyan
        "\e[37m",     # 7: White
        "\e[91m",     # 8: Bright Red
        "\e[92m"      # 9: Bright Green
    ]
    
    for row in grid
        for val in row
            color_idx = (Int(val) % length(colors)) + 1
            print(colors[color_idx], "$(val) ", "\e[0m")
        end
        println()
    end
end

"""
    get_sample(filepath::String, sample_index::Int; dataset::String="train")

Get a specific sample from an ARC task file.
Returns both input and output grids for the specified sample index.
"""
function get_sample(filepath::String, sample_index::Int; dataset::String="train")
    data = read_arc_task(filepath)
    if !haskey(data, dataset)
        throw(ArgumentError("Dataset '$dataset' not found in file"))
    end
    
    samples = data[dataset]
    if sample_index < 1 || sample_index > length(samples)
        throw(ArgumentError("Sample index out of bounds"))
    end
    
    sample = samples[sample_index]
    return sample["input"], sample["output"]
end

"""
    display_sample(filepath::String, sample_index::Int; dataset::String="train")

Display both input and output grids for a specific sample from an ARC task.
"""
function display_sample(filepath::String, sample_index::Int; dataset::String="train")
    input, output = get_sample(filepath, sample_index, dataset=dataset)
    println("Input grid:")
    display_grid(input)
    println("\nOutput grid:")
    display_grid(output)
end

# Example usage:
# filepath = "path/to/arc/task.json"
# display_sample(filepath, 1)  # Display first training sample
# input, output = get_sample(filepath, 1)  # Get grids for first training sample
