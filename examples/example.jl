using .DataGens
using Plots

dataset = DataGens.generate_dataset(3, 100, 2)
p = scatter(dataset[:, 1], dataset[:, 2], group=dataset[:, 3], legend=false)
display(p)

dataset = DataGens.generate_donut_distribution(3, 100)
p = scatter(dataset[:, 1], dataset[:, 2], group=dataset[:, 3], legend=false)
display(p)