library(shiny)
library(tidyverse)


#The intention of this tool is to show how the miles per US gallon is related to horse power and weight of the car
# linear model

model1 <- lm(mpg ~ hp + wt, data=mtcars)


shinyServer(function(input, output) {
    output$pText <- renderText({
        paste("When the engine of the car contains",
              strong(round(input$hp, 2)),
              "Horse Power, and the car's weight is ",
              strong(round(input$wt, 2)),
              "kg, the estimated mileage per US gallon is:")
    })
    output$pred <- renderText({
        df <- data.frame(hp=input$hp,
                         wt=input$wt)
        model <- predict(model1, newdata=df)
    })
    output$Plot <- renderPlot({
        
        df <- data.frame(hp=input$hp,
                         wt=input$wt)
        mphM <- predict(model1, newdata=df)
        yvals <- c("Horse Power", "Miles / Gallon", "Weight")
        df <- data.frame(
            x = factor(yvals, levels = yvals, ordered = TRUE),
            y = c(input$hp, mphM, input$wt))
        ggplot(df, aes(x=x, y=y, color=c("red", "blue", "green"), fill=c("red", "blue", "green"))) +
            geom_bar(stat="identity", width=0.5) +
            xlab("") +
            ylab("") +
            theme_minimal() +
            theme(legend.position="none")
    })
})
     