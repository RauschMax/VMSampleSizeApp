####Packages####
library(shiny)
library(shinydashboard)
#Add all required packages here

####USER INTERFACE####
dashboardPage(
  ####Header####
  #Title is Kantar Logo - DO NOT REMOVE
  header = dashboardHeader(
    title = tags$img(src = 'bms_11b_vektor.png', style = 'height:90%;')
  ),

  ####Sidebar####
  sidebar = dashboardSidebar(collapsed = TRUE,
                             sidebarMenu(
                               menuItem("Contact ValueManager Team", icon = icon("envelope"),
                                        href = "mailto:conjoint@bms-net.de")
                             )),

  ####Body####
  body = dashboardBody(
    tags$head(tags$style(HTML('.box {min-height: 42vh;}
                               .logo {text-align:left !important;}'))),
    # tags$body(tags$style(HTML('body {width: 1100px;}'))),
    fluidRow(
      box(width = 4, title = "Parameters", status = "primary", solidHeader = TRUE,
          radioButtons("SelIn", NULL, c("Feature Conjoint" = "driver", "Price Only DCM" = "pricer"),
                       selected = NULL, inline = TRUE, width = NULL),
          conditionalPanel(condition = "input.SelIn == 'driver'",
                           numericInput("nAtt", label = "Enter Number of Attributes", value = "5",
                                        min = 1),
                           uiOutput("variants")
          ),
          conditionalPanel(condition = "input.SelIn == 'pricer'",
                           numericInput("SKU", label = "Enter number of SKUs/products:",
                                        value = "20", min = 2, width = "425px"),
                           numericInput("price", label = "Enter number of prices per SKU/product:",
                                        value = "5", min = 1, width = "425px")
          )
      ),
      box(width = 4, title = "Settings", status = "success", solidHeader = TRUE,
          numericInput("nFixed", label = "Number of fixed alternatives", value = "1", min = 0),
          numericInput("PercFixed", label = "% of fixed alternative expected", value = "25", min = 1),
          numericInput("nConc", label = "Number of concepts per task (incl. Fixed)", value = "4", min = 1),
          selectInput('HLI', 'Level of Heterogeneity', c("General Population",
                                                         "Category Buyers",
                                                         "Specific homogeneus target group"),
                      selectize = TRUE),
          conditionalPanel(condition = "input.HLI == 'Specific homogeneus target group'",
                           infoBoxOutput("warning", width = NULL)
          )
      ),
      box(width = 4, title = "Recommendation", status = "danger", solidHeader = TRUE,
          radioButtons("SelOutput", "Choose your output:",
                       c("Number of Tasks" = "ntasks",
                         "Sample size" = "nresp",
                         "Burn-In Draws" = "nBurnIn"),
                       selected = NULL, inline = TRUE, width = NULL),
          conditionalPanel(condition = "input.SelOutput == 'nresp'",
                           numericInput("nTasks", label = "Number of tasks per respondent", value = "12", min = 0),
                           tags$hr(),
                           valueBoxOutput("nRespBox", width = NULL)
          ),
          conditionalPanel(condition = "input.SelOutput == 'ntasks'",
                           numericInput("nResp", label = "Sample size", value = "2000", min = 0),
                           tags$hr(),
                           valueBoxOutput("nTaskBox", width = NULL)
          ),
          conditionalPanel(condition = "input.SelOutput == 'nBurnIn'",
                           numericInput("nTasksBurn", label = "Number of tasks per respondent", value = "12", min = 0),
                           numericInput("nRespBurn", label = "Sample size", value = "2000", min = 0),
                           tags$hr(),
                           valueBoxOutput("nBurnBox", width = NULL)
          )
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
