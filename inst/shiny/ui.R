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
    tags$head(tags$style(HTML('.box {min-height: 385px;}'))),
    fluidRow(
      box(title = "Parameters", width = 3, status = "primary", solidHeader = TRUE,
                 radioButtons("SelIn", NULL, c("ValueDriver" = "driver", "ValuePricer" = "pricer"),
                              selected = NULL, inline = TRUE, width = NULL),
                 conditionalPanel(condition = "input.SelIn == 'driver'",
                                  numericInput("nAtt", label = "Enter Number of Attributes", value="5", min=1, width="425px"),
                                  uiOutput("variants")),
                 conditionalPanel(condition = "input.SelIn == 'pricer'",
                                  numericInput("SKU", label = "Enter number of SKUs/products:", value="20", min=2),
                                  numericInput("price", label = "Enter number of prices per SKU/product:", value="5", min=1))
             ),
      box(title = "Settings", width = 2, status = "success", solidHeader = TRUE,
                 numericInput("nFixed", label = "Number of fixed alternatives", value="1", min=0),
                 numericInput("PercFixed", label = "% of fixed alternative expected", value="25", min=1),
                 numericInput("nConc", label = "Number of concepts per task (incl. Fixed)", value="4", min=1),
                 numericInput("HLI", label = "HLI (Homogeneity/Logical Consistency Index)", value="500", min=0, max = 500, step=50)
             ),
      box(title = "Recommendation", width = 2, status = "danger", solidHeader = TRUE,
                 radioButtons("SelOutput", "Choose your output:", c("Number of Tasks" = "ntasks", "Sample size" = "nresp"),
                              selected = NULL, inline = TRUE, width = NULL),
                 conditionalPanel(condition = "input.SelOutput == 'nresp'",
                                  numericInput("nTasks", label = "Number of tasks per respondent", value="12", min=0),
                                  tags$hr(),
                                  infoBoxOutput("nRespBox")),
                 conditionalPanel(condition = "input.SelOutput == 'ntasks'",
                                  numericInput("nResp", label = "Sample size", value="500", min=0),
                                  tags$hr(),
                                  infoBoxOutput("nTaskBox"))
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
