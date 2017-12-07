####Packages####
library(shiny)
#Add all required packages here

####Server####
shinyServer(function(input, output, session) {
  output$variants <- renderUI({
    nAtt <- as.integer(input$nAtt)
    lapply(1:(nAtt), function(i) {
      div(style="font-size:8px; display:inline-block",
          numericInput(paste0("att", i), label = paste0("# Levels - Att ", i, ":"), value=4, width="83px"))
    })
  })

  dataset_nTask <- reactive({
    if (input$SelIn == "driver"){
      nlev <- NULL
      for (i in 1:as.integer(input$nAtt)){
        nlev <- c(nlev, input[[paste0("att", i)]])
      }
    }

    DF <- ifelse(input$SelIn == "pricer", input$SKU + input$price * input$SKU, sum(nlev) - length(nlev))
    DiffPerc <- 1 - (input$PercFixed / 100)
    a_task <- ifelse(input$nConc > 5, input$nConc - 1, switch(input$nConc, 1, 2, 2.5, 3, 4))
    a_final <- a_task - input$nFixed


    nTasks_cal <- (input$HLI * DF) / (DiffPerc * a_final * input$nResp)

    result <- data.frame(as.integer(round(nTasks_cal, 0)))
    colnames(result) <- c("Number of Tasks")
    result
  })

  dataset_nResp <- reactive({
    if (input$SelIn == "driver"){
      nlev <- NULL
      for (i in 1:as.integer(input$nAtt)){
        nlev <- c(nlev, input[[paste0("att", i)]])
      }
    }

    DF <- ifelse(input$SelIn == "pricer", input$SKU + input$price * input$SKU, sum(nlev) - length(nlev))
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

  output$nTaskBox <- renderInfoBox({
    infoBox(
      "Nr of Tasks", paste(dataset_nTask(), "tasks"), icon = icon("list"),
      color = "purple"
    )
  })

  output$table_nResp <- renderTable({
    dataset_nResp()
  }, bordered = TRUE, striped = TRUE, width = 200)

  output$nRespBox <- renderInfoBox({
    infoBox(
      "Sample Size", paste(dataset_nResp(), "respondents"), icon = icon("users"),
      color = "purple"
    )
  })

  observeEvent(input$SelIn, {
    # We'll use the input$controller variable multiple times, so save it as x
    # for convenience.
    x <- input$SelIn

    updateNumericInput(session, "nConc", value = ifelse(x == "pricer", "13", "4"))

    updateNumericInput(session, "PercFixed", value = ifelse(x == "pricer", "5", "25"))
  })

  observeEvent(input$SelOutput, {
    # We'll use the input$controller variable multiple times, so save it as x
    # for convenience.
    x <- input$SelOutput

    updateNumericInput(session, "nRespOut", value = ifelse(x == "nresp", dataset_nResp(), dataset_nResp()))

    updateNumericInput(session, "nTasksOut", value = ifelse(x == "ntasks", dataset_nTask(), dataset_nResp()))
  }, ignoreInit = TRUE)

})
