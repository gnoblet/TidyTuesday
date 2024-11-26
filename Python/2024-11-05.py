# Get CSV
import pandas as pd
df = pd.read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-11-05/democracy_data.csv')
df

# Get online geojson of all countries
# https://datahub.io/core/geo-countries/_r/-/data/countries.geojson
import geopandas as gpd  # noqa: E402
world = gpd.read_file('https://datahub.io/core/geo-countries/_r/-/data/countries.geojson')
world

# Plot world
# world.plot()

# Join both df DataFrame and world GeoDataFrame by df['country_code'] == world['ISO_A3']

# Function that left join df and gdf, left on key_df and right on key_gdf, and set geometry
def left_join_gdf(df, gdf, key_df, key_gdf, how = 'left'):
    return pd.merge(df, gdf, left_on = key_df, right_on = key_gdf, how = how).set_geometry('geometry')

df_shp = left_join_gdf(
    df,
    world,
    key_df = 'country_code', 
    key_gdf = 'ISO_A3', 
    how = 'left')

# 2 nominal colors and one null
col1 = '#5F4B8BFF'
col2 = '#E69A8DFF'
col3 = '#4c4b4c'

# Prepare a map for 2020
import altair as alt
year = 2020
df_to_alt = df_shp[df_shp['year'] == year]



# Function to draw the map
def alt_geo(df, title, subtitle, var_color, legend_title, scale, orient):
    

#.plot(column = 'is_democracys', cmap = 'RdYlGn', figsize = (15, 10))
alt.Chart(
    df_to_alt,
    title = alt.Title
    (
        str(year) + ' States considered democratic',
        subtitle = 'Centered around America and Europe'
    )
).mark_geoshape(
    stroke = 'white'
).encode(
    color = alt.Color(
        'is_democracy', 
        scale = alt.Scale(scheme = 'pastel2')
    ).title(
        'Is democratic?'
    ).legend(
        orient = "bottom"
    )
)


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
# for year in years:
#     # filter using query 
#     df_shp_sub = df_shp.loc[:,['year', 'is_democracy', 'country_code', 'geometry']].query('year == @year')
#     fig = df_shp_sub.plot(
#         column = 'is_democracy', 
#         legend = True,
#         cmap = 'RdYlGn', 
#         figsize = (15, 10))

#     # # Remove axis and add title
#     fig.axis('off')
#     fig.set_title(
#         f'{year} Democracies', 
#         fontdict = {
#         'fontsize': 20,
#         'fontweight': 'bold'}
#     )

#     fig.savefig(f'{path}/is_democracy_{year}.svg')
