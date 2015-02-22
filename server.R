library(shiny)
library(ggplot2)

getvarname <- function(x) {
    switch(tolower(x),
           "engine displacement" = "displ",
           "number of cylinders" = "cyl",
           "transmission type" = "trans",
           "drive type" = "drv",
           "city miles per gallon" = "cty",
           "highway miles per gallon" = "hwy",
           "fuel" = "fl",
           tolower(x))
}

shinyServer(
    function(input, output) {
        
        # Data table: Filter data based on selections
        output$table <- renderDataTable({
            data <- mpg # mpg dataset from ggplot2
            
            if (input$man != "All"){
                data <- data[data$manufacturer == input$man,]
            }
            if (input$trans == "Automatic"){
                data <- data[grepl("^auto.*", data$trans),]
            } 
            if (input$trans == "Manual") {
                data <- data[grepl("^manual.*", data$trans),]
            }
            
            syr <- input$yr_range[1]
            eyr <- input$yr_range[2]
            if ((syr != min(data$year))|(eyr != max(data$year))) {
                data <- subset(data, year >= syr & year <= eyr)
            }
            
            data
        })
        
        # # Some operation on the ui input in sever.R
        output$plot <- renderPlot({
            x <- getvarname(input$x)
            y <- getvarname(input$y)
            color <- getvarname(input$color)
            facet_col <- getvarname(input$facet_col)
            
            p <- ggplot(mpg, aes_string(x=x, y=y)) + geom_point()
            
            if (color != 'none') 
                p <- p + aes_string(color=color)

            if(facet_col != 'none') {
                facets <- paste('.~', facet_col)
                p <- p + facet_grid(facets)
            }
            
            print(p)
            
        })
    }
)