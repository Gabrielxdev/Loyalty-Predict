# %% 
import pandas as pd 
import sqlalchemy 

# %% 

engine = sqlalchemy.create_engine("sqlite:///../../data/loyalty-system/database.db")

# %% 

def import_query(path):
    with open(path) as open_file: 
        return open_file.read() 
query = import_query("frequencia_valor.sql")

# %% 
df = pd.read_sql(query, engine) 
df.head() # visualiza as primeiras linhas do dataframe 
df = df[df['qtdePontosPos'] < 4000]
# %% 

import matplotlib.pyplot as plt

# %%

plt.plot(df['qtdeFrequencia'], df['qtdePontosPos'], 'o')
plt.grid(True)
plt.xlabel('Frequência')
plt.ylabel('Valor')
plt.show()
# %%

from sklearn import cluster 
from sklearn import preprocessing 

minmax = preprocessing.MinMaxScaler()
X = minmax.fit_transform(df[['qtdeFrequencia', 'qtdePontosPos']])

# %%

kmean = cluster.KMeans(n_clusters=5, random_state= 42, max_iter= 1000)
kmean.fit(X)
df['cluster'] = kmean.labels_
df
# %%

df.groupby(by='cluster')['IdCliente'].count()

# %%

import seaborn as sns 

sns.scatterplot(data=df,
                 x="qtdeFrequencia",
                 y="qtdePontosPos",
                 hue="cluster",
                 palette='deep'
                 )
plt.hlines(y=1500, xmin=0, xmax=25, color='black')
plt.hlines(y=750, xmin=0, xmax=25, colors='black')
plt.vlines(x=4, ymin=0, ymax=750, colors='black')
plt.vlines(x=10, ymin=0, ymax=3000, colors='black')
plt.grid()

# %%