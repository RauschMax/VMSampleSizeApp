####Packages####
library(shiny)
#Add all required packages here

####Server####
shinyServer(function(input, output, session) {

  output$variants <- renderUI({

    nAtt <- as.integer(input$nAtt)
    lapply(1:(nAtt), function(i) {
      div(style = "font-size:12px; display:inline-block",
          numericInput(paste0("att", i), label = paste0("# Levels - Att ", i, ":"), value = 4, width = "87px"))
    })

  })

  dataset_nTask <- reactive({
    if (input$SelIn == "driver") {
      nlev <- NULL
      for (i in 1:as.integer(input$nAtt)) {
        nlev <- c(nlev, input[[paste0("att", i)]])
      }
    }

    HLI <- switch(input$HLI,
                  "General Population" = 500,
                  "Category Buyers" = 400,
                  "Specific homogeneus target group" = 200)

    DF <- ifelse(input$SelIn == "pricer", input$price * input$SKU, sum(nlev) - length(nlev))
    DiffPerc <- 1 - (input$PercFixed / 100)
    a_task <- ifelse(input$nConc > 5, input$nConc - 1, switch(input$nConc, 1, 2, 2.5, 3, 4))
    a_final <- a_task - input$nFixed


    nTasks_cal <- (HLI * DF) / (DiffPerc * a_final * input$nResp)

    result <- data.frame(as.integer(round(nTasks_cal, 0)))
    colnames(result) <- "Number of Tasks"
    result
  })

  dataset_nResp <- reactive({
    if (input$SelIn == "driver") {
      nlev <- NULL
      for (i in 1:as.integer(input$nAtt)) {
        nlev <- c(nlev, input[[paste0("att", i)]])
      }
    }

    HLI <- switch(input$HLI,
                  "General Population" = 500,
                  "Category Buyers" = 400,
                  "Specific homogeneus target group" = 200)

    DF <- ifelse(input$SelIn == "pricer", input$price * input$SKU, sum(nlev) - length(nlev))
    DiffPerc <- 1 - (input$PercFixed / 100)
    a_task <- ifelse(input$nConc > 5, input$nConc - 1, switch(input$nConc, 1, 2, 2.5, 3, 4))
    a_final <- a_task - input$nFixed

    nResp_cal <- (HLI * DF) / (DiffPerc * a_final * input$nTasks)

    result <- data.frame(as.integer(round(nResp_cal, 0)))
    colnames(result) <- "Sample Size"
    result
  })

  dataset_nBurn <- reactive({
    if (input$SelIn == "driver") {
      nlev <- NULL
      for (i in 1:as.integer(input$nAtt)) {
        nlev <- c(nlev, input[[paste0("att", i)]])
      }
    }

    nParams <- ifelse(input$SelIn == "pricer", input$price * input$SKU, sum(nlev) - length(nlev))

    nConc <- input$nConc
    nSample <- input$nResp
    het <- switch(input$HLI,
                  "General Population" = 2.5,
                  "Category Buyers" = 2,
                  "Specific homogeneus target group" = 1)
    nTasks <- input$nTasks

    sparseness <- nConc * ((log(nSample)) / (nParams * het)) * nTasks / 100

    calcBurnIn <- 2000 / sparseness

    ceiling(calcBurnIn / 10000) * 10000


  })

  # output$table_nTask <- renderTable({
  #   dataset_nTask()
  # }, bordered = TRUE, striped = TRUE, width = 200)

  output$nTaskBox <- renderValueBox({
    valueBox(
      dataset_nTask(), "tasks per respondent", icon = icon("list"),
      color = "blue"
    )
  })

  # output$table_nResp <- renderTable({
  #   dataset_nResp()
  # }, bordered = TRUE, striped = TRUE, width = 200)

  output$nRespBox <- renderValueBox({
    valueBox(
      dataset_nResp(), "respondents", icon = icon("users"),
      color = "purple"
    )
  })

  output$nBurnBox <- renderValueBox({
    valueBox(
      dataset_nBurn(), "burn-in draws recommended", icon = icon("fire"),
      color = "red"
    )
  })

  output$warning <- renderValueBox({
    infoBox("",
            subtitle = "Target is assumed to be so homogeneous that no subgroup analysis is required.",
            icon = icon("warning"), color = "red",
            width = NULL, fill = TRUE)
  })


  observeEvent(input$SelIn, {
    # We'll use the input$controller variable multiple times, so save it as x
    # for convenience.
    x <- input$SelIn

    updateNumericInput(session, "nConc", value = ifelse(x == "pricer", "13", "4"))

    updateNumericInput(session, "PercFixed", value = ifelse(x == "pricer", "5", "25"))
  })

  # observeEvent(input$SelOutput, {
  #   # We'll use the input$controller variable multiple times, so save it as x
  #   # for convenience.
  #   x <- input$SelOutput
  #
  #   updateNumericInput(session, "nRespOut", value = ifelse(x == "nresp", dataset_nResp(), dataset_nResp()))
  #
  #   updateNumericInput(session, "nTasksOut", value = ifelse(x == "ntasks", dataset_nTask(), dataset_nResp()))
  # },
  # ignoreInit = TRUE)

})
