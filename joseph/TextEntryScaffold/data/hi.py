import pandas as pd
df = pd.read_csv("count_1w.txt", sep = '\t', names = ["Word", "Count"])

df.to_excel("word_counts.xlsx")
print("done!")