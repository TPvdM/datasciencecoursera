library(shiny)
summary(mtcars$wt)
shinyUI(fluidPage(
    titlePanel("Prediction of miles per US gallon"),
    sidebarLayout(
        sidebarPanel(
            helpText("Prediction of the miles per US gallon based on horse power and car's weight"),
            helpText("Parameters:"),
            sliderInput(inputId = "hp",
                        label = "Amount of horse power",
                        value = 130,
                        min = 52,
                        max = 335,
                        step = 1),
            sliderInput(inputId = "wt",
                        label = "The weight of the car (lb/1000)",
                        value = 3.2,
                        min = 1.5,
                        max = 5.5,
                        step = 0.5)
        ),
        
        mainPanel(
            htmlOutput("pText"),
            htmlOutput("pred"),
            plotOutput("Plot", width = "50%")
        )
    )
))