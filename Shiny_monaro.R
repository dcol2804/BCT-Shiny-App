
# load packages
library(shiny)
library(readxl)
library(writexl)
library(shinyjs)
library(DT)
library(data.table)
library(shinydashboard)

# set the system time
Sys.setenv(TZ = "Australia/NSW")
# Define functions
source("monaro.R")

# Define UI ----

  
  header = dashboardHeader(title = "Floristic Value Scoring Tool for grasslands of NSW")
  
  sidebar = 
    dashboardSidebar(
      sidebarMenu(
      menuItem("Data entry", tabName = "data",
      
     
      fileInput("file", "Upload your file template here", 
                accept = c(".xlsx")),
      
      
      actionButton(inputId = "searchButton", label = "Run"),
      
      
      actionButton(inputId = "checkboxButton", label = "Calculate FVS"),
      # Button
      
      downloadButton("downloadData", "Download result", tags$style(".skin-blue .sidebar a { color: #444; }"),
      
      tags$style(".skin-blue .sidebar .shiny-download-link { color: #444; }")),
      
      div(tags$img(src="my_pic.JPG", height = "160px", width = "225px"))
      
      
    )))
    
    
   body = dashboardBody(
                id = "results",
                h4("Return a Floristic Value Score for each plot by uploading a spreadsheet of species names (titled Scientific_Name), their corresponding Bionet currentScientificNameCode (titled Species_Code_Bionet), their coverage (titled Cover_%) and abundance (titled Abundance). Each species should have a Plot_ID code and Bioregion assigned to it. The code index is as follows: \n\nRIV for Riverina, \nMON for the Monaro, \nSEH for SEH non-Monaro, \nNSS for NSW South Western Slopes or \nBBS for Brigalow Belt South) \n(see example spreadsheet below)."),
                fluidRow(column(8, img(src="Capture.JPG")) 
                ),
                DT::dataTableOutput("mytable", width = "70%"),
                tableOutput("errors")
              
               )
    
   ui <- dashboardPage(header, sidebar, body, useShinyjs())
   

    
  

# Define server logic ----
server <- function(input, output, session) {
  
  

  ### The "Run" Button
 Random_vals = eventReactive(input$searchButton, {
    

   
    data = read_xlsx(input$file$datapath)
    data = unique(data) 
    return(data)
  
    })
 
 native_exotic = eventReactive(input$searchButton, {
   
   x = deal_with_native_exotic(Random_vals())
   
 })
 
 #####
 

   
   

     output$mytable <- DT::renderDataTable( 
       expr = {
         
         
         
         x = native_exotic()
         
         if (nrow(x) != 0){
           
           x = x %>% select(output) %>% unique()
           
 
           
           df <- data.table( 'output' = x$output, Native = rep("Native",length(x$output)), Exotic = rep("Exotic",length(x$output)), `Ignore in FVS calculation` = rep(NA,length(x$output)) )
           
    
           df[, Native := sprintf( '<input type="radio" name="%s" value="%s" %s/>', output, df[, Native],"")]
           df[, Exotic := sprintf( '<input type="radio" name="%s" value="%s" %s/>', output, df[, Exotic],"")]
           df[, `Ignore in FVS calculation` := sprintf( '<input type="radio" name="%s" value="%s" %s/>', output, df[, `Ignore in FVS calculation`] ,"checked")]
           names(df)[1] <- " "
           df
         }else{
           df = data.frame(Success = "There is no need to assign native or exotic status to any species in this dataset")
         }}, 
       rownames = FALSE,
       server = FALSE, 
       escape = FALSE,
       selection = 'none',
       options = list(
         ordering = FALSE,
         searching = FALSE,
         paging = FALSE,
         info = FALSE),
       callback = JS("table.rows().every(function(i, tab, row) {
                    var $this = $(this.node());
                    $this.attr('id', this.data()[0]);
                    $this.addClass('shiny-input-radiogroup');
  });
                    Shiny.unbindAll(table.table().node());
                    Shiny.bindAll(table.table().node());")
     )
  
  
 

   #############################################
   
   data_with_ne <- reactive({
     
     
     data = as.data.frame(Random_vals())
     y = as.data.frame(native_exotic())
     
     index = unique(y$output)
     sel = data.frame(output = index, conditions = sapply(index, function(i) input[[i]]))
     
     if (nrow(y) == 0){
       
       return(data)
       
     }else{
     
     
     selected = merge(y, sel, by = c("output", "conditions"))
     # BUG FIX: Was "selected = y %>% select(...)" — this discarded the merge result
     # and used the unfiltered y, meaning user radio button selections were never applied.
     selected = selected %>% select(Plot_ID, Scientific_Name, conditions)
     
     data = merge(data, selected, by = c("Plot_ID", "Scientific_Name"), all.x = T)
     
     return(data)
     
     }
      })
     

   
 
 
   data_ready = eventReactive(input$checkboxButton, {
       
     data = data_with_ne()
     
     data = deal_with_conditions(data)

     return(data)
     
   })


   

   output$errors <- renderTable({

     #req(data_ready())
     
     warnings = error_lists(data_ready())
     
     # BUG FIX: Previously the if/else lacked explicit returns in the first two
     # branches, so renderTable received NULL silently in the success and >50% cases.
     if (nrow(warnings) == 0){
       
       return(data.frame(Success = "A significance rating has been assigned to all species"))
       
     } else if (nrow(warnings) / nrow(data_ready()) * 100 > 50){
       
       return(data.frame(Error = "More than half the data didn't match a speciesID value. Check you are using the correct Bionet ID codes."))
       
     } else {
     
       return(warnings)
     
     }
   })



   FVS <- reactive({

     #req(data_ready())

     out = calculate_FVS(data_ready())

   })

  #  Downloadable csv of selected dataset ----
   output$downloadData <- downloadHandler(

# Add this in following changes POSIXct(s, "EAST")
     filename = function() {
       paste("FVS", format(Sys.time(),'_%Y%m%d_%H%M%S'), ".xlsx", sep = "")
     },

    content = function(file) {
       write_xlsx(FVS(), file)
     }
   )
   

}

# Run the app ----
shinyApp(ui = ui, server = server)

   