library(shiny)

# Load the data.
# Factor the categorical variables.
data <- read.csv("diamond.csv")
data_2 <- data
terms_cut <- c(data$cut[0])
for(val in data$cut) {
    if(!is.element(val, terms_cut)){
        terms_cut <- c(terms_cut, val)
    }
}
terms_cut <- sort(terms_cut)

terms_color <- c(data$color[0])
for(val in data$color) {
    if(!is.element(val, terms_color)){
        terms_color <- c(terms_color, val)
    }
}
terms_color <- sort(terms_color)

term_clarity <- sort(c("I1", "SI2", "SI1", "VS2", "VS1", "VVS2", "VVS1", "IF"))

data_2$cut <- factor(data$cut, levels = terms_cut)
data_2$color <- factor(data$color, levels = terms_color)
data_2$clarity <- factor(data$clarity, levels = term_clarity)


# Define UI for application that displays descriptive statistics for diamond data.
ui <- fluidPage(
    
    # Application title
    titlePanel("Descriptive Statistics for the Diamond Data"),
    br(),
    br(),
    
    
    # Display the table and number of chosen rows. 
    sidebarLayout(
        sidebarPanel(
            numericInput("rows", label = h4("Choose the number of rows to be shown: "), value = 10)
        ),
        
        # Show a table of the data columns.
        mainPanel(
            h3("Data preview:"),
            DT::dataTableOutput("table")
        )
    ),
    
    br(),
    br(),
    br(),
    
    # Descriptive statistics.
    h2("Diamond prices"),
    p("Prices of 3,000 round cut diamonds"),
    br(),
    
    h2("Description"),
    p("A dataset containing the prices and other attributes of a sample of 3000 diamonds. The variables are as follows:"),
    br(),
    
    h2("Variables"),
    p("- price = price in US dollars ($338–$18,791)"),
    p("- carat = weight of the diamond (0.2–3.00)"),
    p("- clarity = a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))"),
    p("- cut = quality of the cut (Fair, Good, Very Good, Premium, Ideal)"),
    p("- color = diamond color, from J (worst) to D (best)"),
    p("- depth = total depth percentage = z / mean(x, y) = 2 * z / (x + y) (54.2–70.80)"),
    p("- table = width of top of diamond relative to widest point (50–69)"),
    p("- x = length in mm (3.73–9.42)"),
    p("- y = width in mm (3.71–9.29)"),
    p("- z = depth in mm (2.33–5.58)"),
    p("- date = shipment date"),
    br(),
    
    h2("Additional information"),
    tags$a(href="https://www.diamondse.info/diamonds-clarity.asp", "Diamond search engine"),
    
    # Vizualizations.
    # Include a drop menu for each type of table. 
    h1("Vizualizations"),
    br(),
    sidebarLayout(
        sidebarPanel(
            selectInput("col_type", label = h3("Select the column:"), 
                        choices = list("price" = 'price', 
                                       "carat" = 'carat', 
                                       "clarity" = 'clarity', 
                                       "cut" = 'cut',
                                       "color" = 'color',
                                       "depth" = 'depth', 
                                       "table" = 'table', 
                                       "x" = 'x', 
                                       "y" = 'y', 
                                       "z" = 'z', 
                                       "date" = 'date'), 
                        selected = 'price'),
        ),
        
        mainPanel(
            plotOutput("distPlot")
        )
    )
)

# Function to handle all the input/output.
server <- function(input, output) {
    output$table <- DT::renderDataTable({
        if (is.na(input$rows) | input$rows <= 0) {
            return()
        }
        shown <- head(data,input$rows)
        DT::datatable(shown,options = list(dom = 't'))
    })
    
    output$distPlot <- renderPlot({
        
        if(input$col_type == 'price') {
            hist(x=data$price, xlab="price", main="A histogram of the price of diamond")
        } else if (input$col_type == 'carat') {
            hist(x=data$carat, xlab="carat", main="A histogram of the carat of diamond")
        } else if (input$col_type == 'clarity') {
            pie(table(factor(data$clarity)),main="A pie diagram of the clarity of diamond")
        } else if (input$col_type == 'cut') {
            pie(table(factor(data$cut)),main="A pie diagram of the cut of diamond")
        } else if (input$col_type == 'color') {
            pie(table(factor(data$color)),main="A pie diagram of the color of diamond")
        } else if (input$col_type == 'depth') {
            hist(x=data$depth, xlab="depth", main="A histogram of the depth of diamond")
        } else if (input$col_type == 'table') {
            hist(x=data$table, xlab="table", main="A histogram of the table of diamond")
        } else if (input$col_type == 'x') {
            hist(x=data$x, xlab="x", main="A histogram of the x of diamond")
        } else if (input$col_type == 'y') {
            hist(x=data$y, xlab="y", main="A histogram of the y of diamond")
        } else if (input$col_type == 'z') {
            hist(x=data$z, xlab="z", main="A histogram of the z of diamond")
        } else if (input$col_type == 'date') {
            year <- str_sub(data$date,1,4) 
            pie(table(factor(year)),main="A pie diagram of the date of diamond")
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
