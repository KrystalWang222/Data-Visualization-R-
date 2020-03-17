#Default file size is 5M
options(shiny.maxRequestSize=30*1024^2)#defined maximum file size 30M
server <- function(input, output,session) {
 
  output$contents <- renderTable({
    req(input$d1)
    x <- read.csv(input$d1$datapath,
                   header = input$header,
                   sep = input$sep,
                   quote = input$quote)
    if(input$disp == "head") {
      return(head(x,n = input$obs_r))
    }
    else {
      return(x)
    }
  })
  
    # Generate a function of the data
  output$caption <- renderText({
    input$caption
  })

  # Mod function
  getmode <- function(v) {
    uniqv <- unique(v)
    uniqv[which.max(tabulate(match(v, uniqv)))]
  }

  # Functions output
  output$functions <- renderPrint({
    req(input$d1)
     x= read.csv(input$d1$datapath)
     if(input$functions=="Summary")
       return(summary(x))
     if(input$functions=="Mod")
       return(getmode(x[,3]))
     if(input$functions=="Standard deviation")
       return(sd(x[,7]))
       if(input$functions=="Covariance")
       return(cov(x[,c(7:11)]))
     if(input$functions=="Correlation")
     {output$plot<-renderPlot({
       require(GGally)
       GGally::ggpairs(x[,c(7:11)],columns = 1:5)})
     return(cor(x[,c(7:11)]))}
         if(input$functions=="Linear regression")
       {output$plot<-renderPlot({
         ggplot(x,aes(x=EU_Sales,y=JP_Sales))+
         geom_point()+geom_smooth(method = 'lm')+
         labs(x='EU',y='JP')
       })
       return(summary(lm(EU_Sales~JP_Sales,data=x)))}
     if(input$functions=="T-Tests")
      { d1.uni=unique(x[,5])
       return(t.test(x[,11],alternative = 'two.sided',mu=0.5))}
     if(input$functions=="ANOVA")
       return(summary(aov(x[,7]~x[,5]-1,x)))
  })
  
# updateSelectInput(
#   session, 'col_name', choices = names(d1)
  
#   options = list(render= I(sprintf(
#     "{
#     option: function(item, escape) {
#     return '<div><img width=\"100\" height=\"50\" ' +
#     'src=\"%s&state=' + escape(item.value) + '\" />' +
#     escape(item.value) + '</div>';
#     }
# }",
#   )))
# )
observeEvent(
  input$show,{
   showModal(
     modalDialog(
     title = "Plot result",
     'Succeed',
     easyClose = TRUE
    ))
   }
  )
}