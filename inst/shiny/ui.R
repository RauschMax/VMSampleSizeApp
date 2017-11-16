####Packages####
library(shiny)
library(shinydashboard)
#Add all required packages here

####USER INTERFACE####
dashboardPage(
  ####Header####
  #Title is Kantar Logo - DO NOT REMOVE
  header = dashboardHeader(
    title = tags$img(src = 'logo.svg')
  ),

  ####Sidebar####
  sidebar = dashboardSidebar(disable = TRUE),

  ####Body####
  body = dashboardBody(
    fluidPage (
      sidebarPanel(
        radioButtons("SelIn", NULL, c("Enter Att/Lev" = "attlev", "Enter degrees of freedom directly" = "df"),
                     selected = NULL, inline = TRUE, width = NULL),
        conditionalPanel(condition = "input.SelIn == 'attlev'",
                         numericInput("nAtt", label = "Enter Number of Attributes", value="2", min=1),
                         uiOutput("variants")),
        conditionalPanel(condition = "input.SelIn == 'df'",
                         numericInput("DF", label = "Enter degrees of freedom (nLev - nAtt)", value="10", min=1)),
        width = 3

      ),
      mainPanel(
        div(style="display:inline-block", numericInput("nFixed", label = "Number of fixed alternatives", value="1", min=0)),
        div(style="display:inline-block", numericInput("PercFixed", label = "% of fixed alternative expected", value="25", min=1)),
        div(style="display:inline-block", numericInput("nConc", label = "Number of concepts per task (incl. Fixed)", value="4", min=1)),
        div(style="display:inline-block", numericInput("HLI", label = "HLI (Homogeneity/Logical Consistency Index)", value="500", min=0, max = 500, step=50)),
        hr(),
        radioButtons("SelOutput", "Choose your output:", c("Number of Tasks" = "ntasks", "Sample size" = "nresp"),
                     selected = NULL, inline = TRUE, width = NULL),
        conditionalPanel(condition = "input.SelOutput == 'nresp'",
                         numericInput("nTasks", label = "Number of tasks per respondent", value="12", min=0),
                         tableOutput("table_nResp")),
        conditionalPanel(condition = "input.SelOutput == 'ntasks'",
                         numericInput("nResp", label = "Sample size", value="500", min=0),
                         tableOutput("table_nTask")),
        # updateNumericInput(session, "nResp", value = output$nResp_cal),
        width = 5
      )
    )
),

#Title change from default
title = 'Sample Size Calculator App',

#Skin is to match Kantar asethetics - DO NOT REMOVE
skin = 'black')

# ####Server####
# server <- function(input, output, session) {
#
# }
