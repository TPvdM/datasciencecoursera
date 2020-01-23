### Data Science Specialization Capstone; Next word prediction project
### Author: TPvdM

#Loading n-grams
initialPrediction <- "the"
bigram <- readRDS("C:/Users/tomva/ownCloud/Start PhD 1017 (since 280918)/R/Capstone/NextWordPredictor/data/bigram.RData")
trigram <- readRDS("C:/Users/tomva/ownCloud/Start PhD 1017 (since 280918)/R/Capstone/NextWordPredictor/data/trigram.RData")
quadgram <- readRDS("C:/Users/tomva/ownCloud/Start PhD 1017 (since 280918)/R/Capstone/NextWordPredictor/data/quadgram.RData")
note <- ""

matching <- function(input) {
    
    #Cleaning the input
    input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, perl = TRUE, ignore.case = FALSE)  
    input <- gsub("@[^\\s]+", "", input, perl = TRUE, ignore.case = FALSE)
    input <- removeNumbers(removePunctuation(tolower(input)))
    input <- strsplit(input, " ")[[1]]
    
    #More than 2 words as input: Try to match with first three words of quadgram first, otherwise with first two words of trigram, otherwise with first word of bigram
    if (length(input)> 2) {
        input <- tail(input,3)
        if (identical(character(0),head(quadgram[quadgram$unigram == input[1] & quadgram$bigram == input[2] & quadgram$trigram == input[3], 4],1))){
            matching(paste(input[2],input[3],sep=" "))
        }
        else {note <<- "the last three words."; head(quadgram[quadgram$unigram == input[1] & quadgram$bigram == input[2] & quadgram$trigram == input[3], 4],1)}
    }
    else if (length(input) == 2){
        input <- tail(input,2)
        if (identical(character(0),head(trigram[trigram$unigram == input[1] & trigram$bigram == input[2], 3],1))) {
            matching(input[2])
        }
        else {note<<- "the last two words."; head(trigram[trigram$unigram == input[1] & trigram$bigram == input[2], 3],1)}
    }
    else if (length(input) == 1){
        input <- tail(input,1)
        if (identical(character(0),head(bigram[bigram$unigram == input[1], 2],1))) {note <<-"The application was not able to predict the next word. This is a suggestion"; head("Alpaca",1)}
        else {note <<- "the last word."; head(bigram[bigram$unigram == input[1],2],1)}
    }
}


shinyServer(function(input, output) {
    output$userSentence <- renderText({
        input$userInput});
    
    output$prediction <- renderPrint({
        result <- matching(input$userInput)
        output$note <- renderText({note})
        result
    });
}
)
