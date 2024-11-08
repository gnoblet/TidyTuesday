# Get CSV
import pandas as pd
df = pd.read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-11-05/democracy_data.csv')
df

# Get online geojson of all countries
# https://datahub.io/core/geo-countries/_r/-/data/countries.geojson
import geopandas as gpd
world = gpd.read_file('https://datahub.io/core/geo-countries/_r/-/data/countries.geojson')
world
