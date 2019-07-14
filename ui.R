library(shiny)
library(shinythemes )
library(ggplot2)
library(gridExtra)
houseData<-read.csv("kc_house_data.csv")

fluidPage(theme=shinytheme("darkly"),
  titlePanel(''),
  sidebarLayout(
    sidebarPanel(
      
      # Row 1
      fluidRow(
         
        # Column 1
        column(width = 6,
               selectInput("selectBedrooms", label = strong("Bedrooms"),
                            choices = list(choices = sort(unique(houseData$bedrooms))),
                           selected = 1),
               selectInput("selectBathrooms", label = strong("Bathrooms"),
                           choices = list(choices = sort(unique(houseData$bathrooms))),
                           selected = 1),
               selectInput("selectFloors", label = strong("Floors"),
                           choices = list(choices = sort(unique(houseData$floors))),
                           selected = 1),
               radioButtons("waterFront", label = strong("Is there a waterfront ?"),
                            choices = list("Yes" = 1, "No" = 0), selected = 0, inline = TRUE)
        ),
        
        # Column 2
        column(width = 6,
               numericInput("livingSqFt", label = strong("Basement Area (Sq.ft)"), value = 1000,
                            max = max(houseData$sqft_living), min = min(houseData$sqft_living)),
               #numericInput("basementSqFt", label = strong("Basement area (Sq.ft)"), value = 1000,
                            #max = max(houseData$sqft_basement), min = min(houseData$sqft_basement)),
               numericInput("aboveSqFt", label = strong("Area above (Sq.ft)"), value = min(houseData$sqft_above),
                            max = max(houseData$sqft_above), min = min(houseData$sqft_above)),
               numericInput("neighborSqFt", label = strong("Neighboring area (Sq.ft)"), value = min(houseData$sqft_living15),
                            max = max(houseData$sqft_living15), min = min(houseData$sqft_living15))
               
        )
      ),
      
      hr(),
      
      # SecondRow
      fluidRow(
        
        # Column 1
        column(width = 6,
               sliderInput("view", label = strong("How good is view of the House"), min = min(houseData$view),
                           max = max(houseData$view), value = 2, step = 1),
               radioButtons("isRenovated", label = strong("Is Renovated?"),
                            choices = list("Yes" = 1, "No" = 0), selected = 1, inline = TRUE),
               selectInput("zipcode", label = strong("Zipcode"), choices = sort(unique(houseData$zipcode)))
               
               
        ),
        
        # Column 2
        column(width = 6,
               
               sliderInput("grade", label = strong("Quality of Construction"), min = 0,
                           max = max(houseData$grade), value = 7,step = 1),
               sliderInput("condition", label = strong("Condtion of the House"), min = 0,
                           max = max(houseData$condition), value = 3, step = 1),
               
               conditionalPanel(
                 condition = "input.isRenovated == 1",
                 numericInput("date", label = strong("Year Renovated"), value = 2000)),
               
               conditionalPanel(
                 condition = "input.isRenovated == 0",
                 numericInput("date", label = strong("Year Built"), value = 2000))
               
               
        )
        
      )
    ),
    
    mainPanel(
              tags$img(src='logo.png', height=75,width=250),
              hr(),
              h1("WELCOME TO HOMEHUB !!"),
              h3("know the real worth of your home"),
              h5(""),
              hr(),
      
      
      tabsetPanel(
        tabPanel("Predict House Price", 
      
                 
      fluidRow(
        tags$br(),
        column(4,
               strong("Predicted Price: "),
               verbatimTextOutput("predVal")
        )
        
        #column(4,
         #      strong("Lower Estimate: "),
          #     verbatimTextOutput("lwrPredVal")
        #),
        
        #column(4,
         #      strong("Upper Estimate: "),
          #     verbatimTextOutput("uprPredVal")
        #)
        
      ),
      

      
      fluidRow(
        hr(),
        h4("Checkout the factors that affect the House Price"),
        plotOutput("barPlot")
      )
      
        ),
      
      tabPanel("INFO",
               tags$br(),
               p("The prediction model is fairly self-explanatory. 
                  However, few variable names may need some explanation. 
                  The dataset can be found at "),
               tags$a("https://www.kaggle.com/harlfoxem/housesalesprediction"),
               tags$br(),
               p("After a few statistical tests, the following variables seemed to be significant in predicting 
                 the price of the House."),
               tags$br(),
               tags$ul(
                 tags$li("Bedrooms: Total number of bedrooms in the House"),
                 tags$li("Bathrooms: There will be four major components in the bathroom. They are, toilet, sink, bathtub and shower. 
                         If a bathroom has just 2 components then it a half bathroom, indicated as 0.5. Similarly, there exists a quarter, 
                         half and three quarter bathrooms."),
                 tags$li("Floors: Total number of floors in a house."),
                 tags$li("Waterfront: Is there a overlooking waterfront."),
                 #tags$li("Living area: Total interior living area in Square feet."),
                 tags$li("Basement area: Total interior area under the ground level."),
                 tags$li("Above area: Total interior area above the ground level."),
                 tags$li("Neighboring area: Total interior living area for the nearest 15 neighbors"),
                 tags$li("View: How the house looks like on a scale of 0-4. 4 being a great view." ),
                 tags$li("Condition: Condtion of the house." ),
                 tags$li("Quality and design: Rate the grade of construction and design on a scale of 1-13. 1-3 being low, 7 is an average, 
                         while anything between 11 and 13 shows a high quality."),
                 tags$li("Year Built or Renovated: Self-explanatory"),
                 tags$li("Zipcode: Self-explanatory")
                 
               )
               ),
      tabPanel("ABOUT",
               #h2("HOME HUB"),
               tags$img(src='logo.png', height=60,weight=200),
               hr(),
               fluidRow(
               column(4,
                      h5("DEVELOPED BY:"),
                      
                      
                      h5("JIJO A J"),
                      tags$a("jijoaj619@gmail.com"),
                      h5("JYOTISH MENON"),
                      tags$a("j31menon@gmail.com")
                      
               )
               ),
               
               
               
               
               h5(""),
               fluidRow(
               column(4,
                      h5("GUIDE :"),
                      
                      
                      h5("ASST. PROFESSOR SREERESMI T S")
                      
               )),
               column(10,
                      h5("CSE DEPT"),
                      
                      
                      h5("ADI SHANKARA INSTITUTE OF ENGINEERING AND TECHNOLOGY, Kalady")
                      
               ),
               hr()
               )
      )
    )
  )
)
