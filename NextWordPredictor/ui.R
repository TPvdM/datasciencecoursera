shinyUI(
    navbarPage("Next Word Predict",
               theme = shinytheme("spacelab"),
               tabPanel("Home",
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
                                    h3("Predicted words"),
                                    verbatimTextOutput("prediction"),
                                    br(),
                                    strong("Predicted using:"),
                                    tags$style(type='text/css', '#note {background-color: rgba(255,255,0,0.40); color: black;}'),
                                    textOutput('note')
                                    )
                                )
                            )
                        ),
               tabPanel("Course info",
                        HTML("The Next Word Predict application was designed for the 
                             Coursera Data Specialization Capstone"))))