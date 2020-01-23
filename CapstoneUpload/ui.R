
library(shiny)
library(shinythemes)
library(markdown)
library(dplyr)
library(tm)

shinyUI(
    navbarPage("Next Word Predict",
               theme = shinytheme("united"),
               tabPanel("Application",
                        HTML("By: TPvdM"),
                        br(),
                        HTML("Date: Jan 23 2020"),
                        br(),
                        br(),
                        fluidPage(
                            titlePanel("Next Word Predict Application"),
                            sidebarLayout(
                                sidebarPanel(
                                    textInput("userInput",
                                              "Enter a word or phrase:",
                                              value =  "",
                                              placeholder = "Enter text here"),
                                    br()),
                                mainPanel(
                                    h3("Input text"),
                                    verbatimTextOutput("userSentence"),
                                    br(),
                                    h3("Predicted word"),
                                    verbatimTextOutput("prediction"),
                                    br(),
                                    strong("Predicted using:"),
                                    textOutput('note')
                                    )
                                )
                            )
                        ),
               tabPanel("About",
                        h4("About the Next Word Predict Application"),
                        br(),
                        br(),
                        HTML("The Next Word Predict application that is designed as
                        part of the Coursera Data Science Capstone of the 
                             Data Science Specialization Course"),
                        br(),
                        HTML("The goal of this application is to predict the next
                             word in a sentence based on a database of text material.
                             These kind of prediction techniques can be found in a
                             multitude of excisting applications, such as google or
                             the keyboard of most smartphones."),
                        br(),
                        HTML("The applications notices when the user stops typing,
                             after which it automatically tries to match the last
                             words with its database. Based on as many words as
                             possible (with a maximum of the last 3 words), it
                             then predicts the next most likely word."),
                        br(),
                        br(),
                        HTML("The source code is available on"),
                        a(target = "_blank", href = "https://github.com/TPvdM/datasciencecoursera/tree/master/NextWordPredictor", "GitHub"),
                        br(),
                        br(),
                        HTML("The course is available on"),
                        a(target = "_blank", href = "https://www.coursera.org/learn/data-science-project/", "Coursera")
                        
               )))
