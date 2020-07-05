library(shiny)
library(leaflet)
library(sf)
library(tidyverse)
library(htmltools)
library(waiter)


data <- readRDS("mapdata.RDS")

ui <- bootstrapPage(
  
  use_waiter(include_js = FALSE),
  waiter_show_on_load(html = spin_fading_circles()),
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(bottom = 40, right = 20,
                draggable = TRUE,
                selectInput(inputId = "names", 
                            label = "Valitse nimiä", 
                            choices = unique(data$nimi),
                            selectize = TRUE,
                            selected = c("Alaskartano","Ylöskartano"),
                            multiple = TRUE)
  ),
   waiter_hide_on_render("map")
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    
    bbox <- st_bbox(data) %>% 
      as.vector()
    
    tag.map.title <- tags$style(HTML("
      .leaflet-control.map-title { 
        transform: translate(-50%,20%);
        position: fixed !important;
        left: 40%;
        text-align: center;
        padding-left: 10px; 
        padding-right: 10px; 
        background: #ebf5fb;
        font-weight: bold;
        font-family: verdana;
        font-size: 16px;
      }
    "))
    
    
    title <- tags$div(
      tag.map.title, HTML(paste0("Kartano, järvi, lampi, vesi, gård, sjö, träsk, vatten"))
    )  
    
    leaflet(data) %>%
      addTiles(attribution = '|Data: Statistics Finland, National Land Survey of Finland|@ttso') %>% 
      addControl(title, position = "topleft", className = "map-title") %>% 
      fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])
    
  })
  
  
  filteredNames <- reactive({
    if ( is.null(input$names) )
      return(data)
    data[data$nimi %in% input$names, ]
  })
  
  
  filteredBbox <- reactive({
    bbox <- st_bbox(filteredNames()) %>% 
      as.vector()
  })
  
  
  observeEvent(input$names,{
    
    leafletProxy("map") %>%
      clearMarkers() %>%
      addMarkers(data = filteredNames(),
                 label = ~nimi,
                 labelOptions = labelOptions(noHide = T)) %>% 
      fitBounds(.,
                min(filteredBbox()[1]), min(filteredBbox()[2]),
                max(filteredBbox()[3]), max(filteredBbox()[4]))
  })
  
}

shinyApp(ui, server)