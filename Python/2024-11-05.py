# Get CSV
import pandas as pd
df = pd.read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-11-05/democracy_data.csv')
df

# Get online geojson of all countries
# https://datahub.io/core/geo-countries/_r/-/data/countries.geojson
import geopandas as gpd
world = gpd.read_file('https://datahub.io/core/geo-countries/_r/-/data/countries.geojson')
world

# Plot world
world.plot()

# Join both datasets by df['country_code'] == world['ISO_A3']
df_shp = df.set_index('country_code', drop = False).sjoin(
    world.set_index('ISO_A3', drop = False),
    how = 'left',
    lsuffix = '_df', 
    rsuffix = '_world') 
# set geometry
df_shp = df_shp.set_geometry('geometry')

# Prepare a map for 2020
year = 2020
df_shp[df_shp['year'] == year].plot(column = 'regime_category', cmap = 'RdYlGn', figsize = (15, 10))

# path 2024-11-05
path = 'Python/2024-11-05'

# loop init
i = 0

# years, unique and sorteds
years = df_shp['year'].unique().sort_values()

# set the min and max range for the choropleth map
# not sure i need it, depends on what is ploted
# vmin, vmax = 200, 1200

# map
for year in years:
    # filter using query 
    df_shp_sub = df_shp.loc[:,['year', 'regime_category', 'country_code', 'geometry']].query('year == @year')
    fig = df_shp_sub.plot(
        column = 'regime_category', 
        legend = True,
        cmap = 'RdYlGn', 
        figsize = (15, 10))

    # # Remove axis and add title
    fig.axis('off')
    fig.set_title(
        f'{year} Regime categories', 
        fontdict = {
        'fontsize': 20,
        'fontweight': 'bold'}
    )

    fig.savefig(f'{path}/regime_category_{year}.svg')
