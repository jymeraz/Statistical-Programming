import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_table
from dash.dependencies import Input, Output
import plotly.express as px
import pandas as pd

df = pd.read_csv("diamonds.csv")
app = dash.Dash(__name__)

app.layout = html.Div([
    # Make a table containing the first 10 observations of the data.
    html.H1("Descriptive Statistics for the Diamond Data",style={"text-align":"center"}),
    html.H2("Data preview:",style={"text-align":"left"}),
    dash_table.DataTable(
        id="table",
        columns=[{"name": i, "id": i} for i in df.columns],
        data=df.to_dict("records"),
        style_cell={"textAlign": "center"},
            style_cell_conditional=[
                {
                    "if": {"column_id": "Region"},
                    "textAlign": "center",
                    "backgroundColor": "rgb(248, 248, 248)",
                }
            ],
            style_header={
                "backgroundColor": "rgb(230, 230, 230)",
            },
        fixed_rows={'headers': True},
        page_size=10,
        style_table={'height': '330px', 'overflowY': 'auto'}

        # html.Div(["Choose the number of rows to be shown: ",
        #       dcc.Input(id='my-input', value=10, type='number')
        # ]),
    ),

    # Add a description containing information of all variables.
    dcc.Markdown('''
    # Diamond Prices:
    Prices of 3,000 round cut diamonds
    # Description:
    A dataset containing the prices and other attributes of a sample of 3000 diamonds. The variables are as follows:
    # Variables:
    - price = price in US dollars ($338–$18,791)
    - carat = weight of the diamond (0.2–3.00)
    - clarity = a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))
    - cut = quality of the cut (Fair, Good, Very Good, Premium, Ideal)
    - color = diamond color, from J (worst) to D (best)
    - depth = total depth percentage = z / mean(x, y) = 2 * z / (x + y) (54.2–70.80)
    - table = width of top of diamond relative to widest point (50–69)
    - x = length in mm (3.73–9.42)
    - y = width in mm (3.71–9.29)
    - z = depth in mm (2.33–5.58)
    - date = shipment date
    # Additional information:
    [Diamond search engine](https://www.diamondse.info/diamonds-clarity.asp)
    '''),

    # Make an appropriate graph for the column that the user selects.
    html.H1("Vizualization:",style={"text-align":"left"}),
    html.Div(["Select the column: ",
              dcc.Dropdown(
                  id="column_dropdown",
                  options=[
                      {"label": "price", "value": "price"},
                      {"label": "carat", "value":"carat"},
                      {"label": "clarity", "value":"clarity"},
                      {"label": "cut", "value":"cut"},
                      {"label": "color", "value":"color"},
                      {"label": "depth", "value":"depth"},
                      {"label": "table", "value":"table"},
                      {"label": "x", "value":"x"},
                      {"label": "y", "value":"y"},
                      {"label": "z", "value":"z"},
                      {"label": "date", "value":"date"}

                  ],
                  value="price",
                  style={"width": "35%","display":"inline-block"},
              )
    ]),
    html.Div([
        dcc.Graph(id='custom_graph')
    ])
])

@app.callback(
    Output(component_id="custom_graph",component_property="figure"),
    Input(component_id="column_dropdown", component_property="value")
)

def graph(label):
    if label is None:
        raise dash.exceptions.PreventUpdate
    elif label == "price":
        fig = px.histogram(df["price"],title="A histogram of the price of diamond",marginal="box")
    elif label == "carat":
        fig = px.histogram(df["carat"],title="A histogram of the carat of diamond",marginal="box")
    elif label == "clarity":
        fig = px.pie(df["clarity"],values=df["clarity"].value_counts().values,names=df["clarity"].value_counts().index,title="A pie diagram of the clarity of diamond")
    elif label == "cut":
        fig = px.pie(df["cut"],values=df["cut"].value_counts().values,names=df["cut"].value_counts().index,title="A pie diagram of the cut of diamond")
    elif label == "color":
        fig = px.pie(df["color"],values=df["color"].value_counts().values,names=df["color"].value_counts().index,title="A pie diagram of the color of diamond")
    elif label == "depth":
        fig = px.histogram(df["depth"],title="A histogram of the depth of diamond",marginal="box")
    elif label == "table":
        fig = px.histogram(df["table"],title="A histogram of the table of diamond",marginal="box")
    elif label == "x":
        fig = px.histogram(df["x"],title="A histogram of the x of diamond",marginal="box")
    elif label == "y":
        fig = px.histogram(df["y"],title="A histogram of the y of diamond",marginal="box")
    elif label == "z":
        fig = px.histogram(df["z"],title="A histogram of the z of diamond",marginal="box")
    elif label == "date":
        k = pd.DataFrame([i.split("-")[0] for i in df["date"]])
        fig = px.pie(k, values=k[0].value_counts().values,names=k[0].value_counts().index,title="A pie diagram of the date of diamond")
    return fig


if __name__ == "__main__":
    app.run_server(debug=True)
