library(shiny)
library(ggplot2)
library(gridExtra)
houseData<-read.csv("kc_house_data.csv")
shinyServer(
function(input, output){
  library(caret)
  
  
  houseData$howOld<-0
  for(i in 1:nrow(houseData)){
    if(houseData[i,]$yr_renovated==0){
      houseData[i,]$howOld<-2015-houseData[i,]$yr_built
    }
    else{
      houseData[i,]$howOld<-2015-houseData[i,]$yr_renovated
    }
  }
  houseData$bathrooms<-as.factor(houseData$bathrooms)
  houseData$bedrooms<-as.factor(houseData$bedrooms)
  houseData$floors<-as.factor(houseData$floors)
  houseData$yr_renovated<-as.numeric(houseData$yr_renovated)
  houseData$zipcode<-as.factor(houseData$zipcode)
  houseData$waterfront<-as.factor(houseData$waterfront)
  houseData$view<-as.numeric(houseData$view)
  houseData$condition<-as.numeric(houseData$condition)
  houseData$grade<-as.numeric(houseData$grade)
  houseData$sqft_living<-as.numeric(houseData$sqft_living)
  houseData$sqft_lot<-as.numeric(houseData$sqft_lot)
  houseData$sqft_above<-as.numeric(houseData$sqft_above)
  houseData$sqft_basement<-as.numeric(houseData$sqft_basement)
  houseData$sqft_living15<-as.numeric(houseData$sqft_living15)
  houseData$sqft_lot15<-as.numeric(houseData$sqft_lot15)
  
fit <- lm(price ~ bathrooms+bedrooms+floors+yr_renovated+zipcode+waterfront+view+condition+grade+sqft_living+sqft_lot+sqft_above+sqft_basement+sqft_living15+sqft_lot15, data = houseData)  

  dataHandled<-reactive({
    bedRooms<-input$selectBedrooms
    bathRooms<-input$selectBathrooms
    floors<-input$selectFloors
    hasWaterFront<-input$waterFront
    # Area
    living<-input$livingSqFt
    #basement<-input$basementSqFt
    above<-input$aboveSqFt
    neighbor<-input$neighborSqFt
    # View, Grade
    view<-input$view
    grade<-input$grade
    condition<-input$condition

    yr<-input$date
    zip<-input$zipcode

    isRenovated<-input$isRenovated
    yearRenovated<- if(isRenovated==1) yr else 0
    
    

    df<-data.frame("sqft_living" = living, "grade" = grade, "sqft_above" = above, "bathrooms" = bathRooms, "sqft_basement" = 0,
                   "bedrooms" = bedRooms, "floors" = floors, "waterfront" = hasWaterFront, "howOld" = 2015, "view" = view,"condition" = condition,
                   "sqft_living15" = neighbor,"sqft_lot15" = 0,"sqft_lot" = 0, "zipcode" = zip, "yr_renovated" = yearRenovated)

    pred<-predict(fit, newdata = df)

    dd<-data.frame(whichPred = c('Lower Estimate', 'Predicted Price', 'Upper Estimate'), predVals = c(pred[2], pred[1], pred[3]))
    return(list(pr = dd))
  })

  
  output$predVal<-renderPrint({cat(dataHandled()$pr[2,2])})
  output$lwrPredVal<-renderPrint({cat(dataHandled()$pr[1,2])})
  output$uprPredVal<-renderPrint({cat(dataHandled()$pr[3,2])})
  output$barPlot<-renderPlot({
    p1<-ggplot(data = houseData, aes(x = grade, y = price)) + geom_smooth(method = 'lm');
    p2<-ggplot(data = houseData, aes(x = view, y = price)) + geom_smooth(method = 'lm');
    p3<-ggplot(data = houseData, aes(x = sqft_above, y = price)) + geom_smooth(method = 'lm');
    p4<-ggplot(data = houseData, aes(x = sqft_living, y = price)) + geom_smooth(method = 'lm');
    p5<-ggplot(data = houseData, aes(x = sqft_living15, y = price)) + geom_smooth(method = 'lm');
    p6<-ggplot(data = houseData, aes(x = sqft_basement, y = price)) + geom_smooth(method = 'lm');
    p7<-ggplot(data = houseData, aes(x = howOld, y = price)) + geom_smooth(method = 'lm');
    grid.arrange(p1, p2, p3, p4, p5, p6, p7, nrow = 2, ncol = 4)
  })

}
)