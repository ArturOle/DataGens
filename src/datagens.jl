```
Functions used for generation of synthetic datasets of various shapes and sizes for classification tasks.
To use the functions, include the file in your script and call the functions with the desired parameters.
The functions return a matrix with the generated dataset. The last column of the matrix contains the class labels.
The functions generate_dataset and generate_donut_distribution are used to generate datasets with normal and donut distributions, respectively.

The functions take the following parameters:
- nr_of_classes: the number of classes in the dataset
- nr_of_samples: the number of samples in the dataset
- dimentions: the number of dimentions of the dataset

The nr_of_classes parameter specifies the number of classes in the dataset. The function generates samples evenly in all classes.
If the number of samples is not divisible by the number of classes, the function generates the remaining samples in the classes in a round-robin fashion.
This assures that the classes are as balanced as possible.

To keep the results reproducible, set the seed of the random number generator before calling the functions.
```
module DataGens

    using Distributions



    function generate_dataset(nr_of_classes::Int, nr_of_samples::Int, dimentions::Int)
        samples_per_class = Int(floor(nr_of_samples / nr_of_classes))
        reminder = nr_of_samples % nr_of_classes
        dataset = Matrix{Float64}(undef, nr_of_samples, dimentions + 1)
        for i in 1:nr_of_classes
            for j in 1:samples_per_class
                dataset[(i-1)*samples_per_class + j, 1:dimentions] = rand(Normal(i*i, sqrt(i)), (1, dimentions))
                dataset[(i-1)*samples_per_class + j, dimentions + 1] = i
            end
        end
        for i in 1:reminder
            class = 1 + i % nr_of_classes
            dataset[nr_of_samples - i + 1, 1:dimentions] = rand(Normal(class*class, sqrt(class)), (1, dimentions))
            dataset[nr_of_samples - i + 1, dimentions + 1] = class
        end

        return dataset
    end
    using Plots


    function generate_donut_distribution(nr_of_classes::Int, nr_of_samples::Int)
        samples_per_class = Int(floor(nr_of_samples / nr_of_classes))
        reminder = nr_of_samples % nr_of_classes
        dataset = Matrix{Float64}(undef, nr_of_samples, 3)
        for i in 1:nr_of_classes
            for j in 1:samples_per_class
                r = rand(Uniform(i, 1+i), (1, 1))
                theta = rand(Uniform(0, 2*pi), (1, 1))
                dataset[(i-1)*samples_per_class + j, 1] = (r * cos(theta))[1]
                dataset[(i-1)*samples_per_class + j, 2] = (r * sin(theta))[1]
                dataset[(i-1)*samples_per_class + j, 3] = i
            end
        end

        for i in 1:reminder
            class = 1 + i % nr_of_classes
            r = rand(Uniform(class, 1+class), (1, 1))
            theta = rand(Uniform(0, 2*pi), (1, 1))
            dataset[nr_of_samples - i + 1, 1] = (r * cos(theta))[1]
            dataset[nr_of_samples - i + 1, 2] = (r * sin(theta))[1]
            dataset[nr_of_samples - i + 1, 3] = class
        end

        return dataset
    end
end



# Example usage

# using Plots

# g = DataGens.generate_dataset(4, 300, 2)
# p1 = scatter(g[:, 1], g[:, 2], group=g[:, 3], title="Generated dataset", xlabel="x", ylabel="y", legend=:bottomright)
# display(p1)


# g = DataGens.generate_donut_distribution(4, 300)
# p2 = scatter(g[:, 1], g[:, 2], group=g[:, 3], title="Generated donut dataset", xlabel="x", ylabel="y", legend=:bottomright)