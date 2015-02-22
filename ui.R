require(markdown)
library(shiny)
library(ggplot2)

colnames <- c("Manufacturer", "Model", "Engine displacement", "Year", "Number of cylinders", "Transmission type", "Drive type", "City miles per gallon", "Highway miles per gallon", "Fuel", "Class")

shinyUI(navbarPage(
    "Fuel Economy of Cars",
    tabPanel("Application",
        sidebarPanel(
            h4('Tweak visualization'),
            helpText("Note: Tweak the visualization by changing the values of the inputs below."),
            # Some form of input (widget: textbox, radio button, checkbox, ...)
            selectInput('x', 'X', colnames, selected = "Transmission type"),
            selectInput('y', 'Y', colnames, selected = "City miles per gallon"),
            selectInput('color', 'Color', selected = "Manufacturer" , c('None', colnames)),
            selectInput('facet_col', 'Facets', c("None", colnames))
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Visualization",
                    # Some reactive output displayed as a result of server calculations
                    plotOutput('plot')
                ),
                tabPanel("Data Table",
                     column(4, 
                        selectInput("man", 
                            "Manufacturer:", 
                            c("All", 
                              unique(as.character(mpg$manufacturer))))
                     ),
                     column(4, 
                        selectInput("trans", 
                            "Transmission:", 
                            c("All", "Automatic", "Manual"))
                     ),
                     column(4, 
                        sliderInput("yr_range", "Year:",
                                    min = as.integer(min(mpg$year)), max = as.integer(max(mpg$year)), value = c(as.integer(min(mpg$year)),as.integer(max(mpg$year))), step=1)
                     ),
                     dataTableOutput(outputId="table")
                )
            )
        )
    ),
    tabPanel("About",mainPanel(includeMarkdown("README.md")))
))