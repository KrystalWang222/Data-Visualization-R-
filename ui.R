library(shiny)
library(ggplot2)

# Define UI for data upload
ui <- fluidPage(
  titlePanel("Supplement Project"),
  # Sidebar layout with input and output
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      # Input: Select a file
      fileInput("d1", "Upload File",
                multiple = T,
                accept = c("text/csv",".zip",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Input: Checkbox if file has header
      checkboxInput("header", "Header", TRUE),
      
      # Input: Select separator 
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      # Input: Select quotes
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),
  
      # Input: Select number of rows to display 
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head"),
    
    # Named the function as you want
    textInput(inputId = "caption",
              label = "Named table:",
              value = "Data functions"),
   
    # Input: Selector for choosing functions
    selectInput(inputId = "functions",
                label = "Choose a function:",
                choices = c("Summary", "Mod", "Standard deviation",
                            "Covariance","Correlation","Linear regression",
                            "T-Tests","ANOVA")),
    #Parametric control
    selectizeInput("col_names", "Select columns",
                   choices = NULL, 
                   #options=list(placeholder='Type columns name,eg NA_Sales'),
                   multiple = TRUE),
    actionButton("show", "Show plot image"),
    # Show table
    numericInput("obs_r", "Rows Control", min=2,max=20,value = 5),
    # Download
    # plotOutput('pl', width=fig.w, height=fig.h),
    # radioButtons('xtype', 'Image format', c('png', 'jpeg', 'bmp'),
    #              selected='png', inline=T),
    downloadLink('file', 'Save Image')
    ),
    
    # Main panel for displaying outputs
  mainPanel(
    # Output: Formatted text for caption
    h4(textOutput("caption", container = span)),
    # Output: Verbatim text for data summary 
    verbatimTextOutput("functions"),
    # Output: Data file 
    tableOutput("contents"),
    # Plot output
    plotOutput("plot")
    )
  )
 )
