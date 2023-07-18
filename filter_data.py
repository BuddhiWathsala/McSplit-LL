files = [
    "./results/biochemicalReactions_min_max_10.txt",
    "./results/images-CVIU11_min_max_10.txt",
    "./results/images-PR15_min_max_10.txt",
    "./results/largerLV_min_max_10.txt",
    "./results/LV_min_max_10.txt",
    "./results/meshes-CVIU11_min_max_10.txt",
    "./results/scalefree_min_max_10.txt",
    "./results/si_min_max_10.txt",
]
for f in files:
    with open(f) as file:
        dataFileName = f.split("_")[0].strip() + "_data.txt"
        dataFile = open(dataFileName, "w")
        for line in file:
            if line.find("time out") > 0:
                tokens = [token.strip() for token in line.split(",")]
                dataFile.write(f"{tokens[0]}, {tokens[1]}\n")
