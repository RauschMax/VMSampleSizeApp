####Packages####
library(shiny)
#Add all required packages here

####Server####
shinyServer(function(input, output, session) {
  output$variants <- renderUI({
    nAtt <- as.integer(input$nAtt)
    lapply(1:(nAtt), function(i) {
      div(style="font-size:8px; display:inline-block",
          numericInput(paste0("att", i), label = paste0("# Levels - Att ", i, ":"), value=2, width="90px"))
    })
  })

  dataset_nTask <- reactive({
    if (input$SelIn == "attlev"){
      nlev <- NULL
      for (i in 1:as.integer(input$nAtt)){
        nlev <- c(nlev, input[[paste0("att", i)]])
      }
    }

    DF <- ifelse(input$SelIn == "df", input$DF, sum(nlev) - length(nlev))
    DiffPerc <- 1 - (input$PercFixed / 100)
    a_task <- ifelse(input$nConc > 5, input$nConc - 1, switch(input$nConc, 1, 2, 2.5, 3, 4))
    a_final <- a_task - input$nFixed


    nTasks_cal <- (input$HLI * DF) / (DiffPerc * a_final * input$nResp)

    result <- data.frame(as.integer(round(nTasks_cal, 0)))
    colnames(result) <- c("Number of Tasks")
    result
  })

  dataset_nResp <- reactive({
    if (input$SelIn == "attlev"){
      nlev <- NULL
      for (i in 1:as.integer(input$nAtt)){
        nlev <- c(nlev, input[[paste0("att", i)]])
      }
    }

    DF <- ifelse(input$SelIn == "df", input$DF, sum(nlev) - length(nlev))
    DiffPerc <- 1 - (input$PercFixed / 100)
    a_task <- ifelse(input$nConc > 5, input$nConc - 1, switch(input$nConc, 1, 2, 2.5, 3, 4))
    a_final <- a_task - input$nFixed

    nResp_cal <- (input$HLI * DF) / (DiffPerc * a_final * input$nTasks)

    result <- data.frame(as.integer(round(nResp_cal, 0)))
    colnames(result) <- c("Sample Size")
    result
  })

  output$table_nTask <- renderTable({
    dataset_nTask()
  }, bordered = TRUE, striped = TRUE, width = 200)

  output$table_nResp <- renderTable({
    dataset_nResp()
  }, bordered = TRUE, striped = TRUE, width = 200)

})
