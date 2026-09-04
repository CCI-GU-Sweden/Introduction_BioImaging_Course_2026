# Read the csv file into a pandas dataframe
data_dir = "data"
csv_file = f"{data_dir}/Results_rounding_assay0000.csv"

df = pd.read_csv(csv_file)


# Exercise 1
standard_deviation_area = areas.std()
print(f"Standard deviation of area: {standard_deviation_area:.2f}")
median_area = areas.median()
print(f"Median area: {median_area:.2f}")


# Plot a histogram of the areas
plt.hist(df["Area"], bins=30, color='blue', alpha=0.7)
plt.vlines(median_area, ymin=0, ymax=plt.gca().get_ylim()[1], color='green', linestyle='dashed', label=f'Median: {median_area:.2f}')
plt.xlabel("Area")
plt.ylabel("Frequency")
plt.title("Distribution of Areas")
plt.legend()
plt.show()


# Exercise 2: reuse code from Line 15 onwards


# Scatter plot
param_1 = "Circ."
param_2 = "Round"

plt.scatter(df[param_1], df[param_2], color='blue', alpha=0.5)
plt.xlabel("Circularity")
plt.ylabel("Roundness")


# Exercise 3: reuse code from scatter plot


# Saving a plot
plot_name = "sample_plot.png"
plt.savefig(f"{data_dir}/{plot_name}")


# create a new column checking whether area > 100
df["Large"] = df["Area"] > 100


# slice this column to select only the large areas
df_large = df[df["Area"]] > 100

# count the number of large cells
df["Large"].sum()
# or 
(df["Area"] > 100).sum()


# Exercise 4: Apply the principles from Line 45 and 49


# Exercise 5: reuse Exercise 4 and the scatter plot code


# Pivot table based on cell size
df["Large"] = df["Area"] > 100
pd.pivot_table(
    df,
    values="Area",
    index="Large",
    aggfunc=["mean"]
)


# Exercise 6: use concepts from Line 64


# Combining two dataframes into one
df_combined = pd.concat([df_1, df_2], ignore_index=True)


# read all the csv files and get the cell count from each of them
folder = Path("path/to/directory")
n_csv = len(list(folder.glob("*.csv"))) # get the number of csv files from our folder

all_dfs = [] # initialize an empty list to hold the dataframes
cell_numbers = [] # initialize an empty list to hold the number of cells in each image

for i in range(n_csv):
    file_number = str(i).zfill(4) # this adds trailing zeros to the number so that it is 4 digits long, e.g. 0000, 0001, 0002, ..., 0063

    # read the csv file into a dataframe
    csv_name = f"Results_rounding_assay{file_number}.csv"
    df = pd.read_csv(f"{data_dir}/{csv_name}")

    all_dfs.append(df) # add the dataframe to the list

    cell_numbers.append(len(df)) # add the number of cells in this image to the list


# plot the cell numbers with time
plt.plot(range(len(cell_numbers)), cell_numbers, c='b')
plt.xlabel("Time point")
plt.ylabel("Number of cells")
plt.title("Cell count over time")
plt.show()


# Exercise 7: use the concepts from Line 81