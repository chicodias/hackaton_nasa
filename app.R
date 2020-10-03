library(shiny)
library(leaflet)
library(RColorBrewer)
library(tidyverse)

# CODIGO DO APP EM SHINY QUE MONITORA AS QUEIMADAS NO BRASIL,
# ATUALIZADO COM OS DADOS DO MODIS
# SPACE APPS NASA
# TEAM ESTAT 020 ICMC (WORKING TITLE)
# mals o codigo feio kkkkkk


dados<-readr::read_csv("MODIS_C6_Global_24h.csv")
dados1<-readr::read_csv("MODIS_C6_South_America_24h.csv")
dados2<-readr::read_csv("fire_nrt_J1V-C2_157510.csv")
dados3<-readr::read_csv("fire_nrt_M6_157509.csv")
dados4<-readr::read_csv("fire_nrt_V1_157511.csv")
dados <- dados %>% drop_na(latitude,longitude)

ui <- fluidPage(
  
  
  navbarPage("Incêndios no Mundo", id="nav",
             tabPanel("Mapa Interativo",
                      div(class="outer",
                          tags$head(
                            #Include our custom CSS
                            includeCSS("styles.css"),
                            #includeScript("gomap.js")
                          ),
                          
                          leafletOutput("map", width="100%", height="100%"),
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                        width = 330, height = "auto",
                                        
                                        hde2("Incêndios no mundo hoje"),
                                        
                                        #radioButtons("radio", h3("Listar por"),
                                        #             choices = list("Cidades" = 1, "Estados" = 0),
                                        #             selected = 1),
                                        
                                        #selectInput("color", "Variável:", vars, selected = "last_available_confirmed"),
                                        #selectInput("size", "Size", vars, selected = "last_available_death_rate")#,
                                        
                                        #conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
                                        # Only prompt for threshold when coloring or sizing by superzip
                                        #                 numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
                          ),
                          #plotOutput("graph", height = 200, click = "plot_click"),
                          #plotOutput("histCentile", height = 200),
                          #plotOutput("scatterCollegeIncome", height = 250)
                      ),
                      
                      #tags$div(id="cite",tags$img(src = "logo-predict-small1.jpg"))
                      
                               'Desenvolvido no', tags$em('HACKATON DA NASA'),
                      #)
                      
             )
  )
)


server <- function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(attribution = 'Dados extraídos do MODIS <a href="http://brasil.io/">da nada</a>') %>%  
      setView(lng =  -47.9292, lat = -15.7801, zoom = 3)
  })
  
  
  # observer que mantém os circulos e a legenda de acordo com as variaveis escolhidas pelo usr
  observe({
    #colorBy <- dados_mapa
    #sizeBy <- input$color
    #if(input$radio == 1)
      zipdata <- dados %>% filter(confidence > 85)
    #else
     # zipdata <- dados #%>% filter(place_type == "state")
    
    #colorData <- zipdata[[colorBy]]
    #pal <- colorBin("viridis", colorData, 5, pretty = FALSE)
    #  dados_mapa <- dados3 %>% filter(confidence > 85)
    
    #radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 100
    #browser()
    leafletProxy("map", data = zipdata) %>%
      clearMarkers() %>%
    addCircleMarkers(~longitude, ~latitude, radius=0.5,# layerId=~city_ibge_code,
                       stroke=FALSE, fillOpacity=0.4, fillColor="red")# %>%
      #addLegend("bottomright", pal=pal, values=colorData, title=colorBy,
       #         layerId="colorLegend")
  })
  
  # funcao que mostra a cidade clicada
  # showCityPopup <- function(city_ibge_code, lat, lng) {
  #   selectedZip <- dados[dados$city_ibge_code == city_ibge_code,]
  #   content <- as.character(tagList(
  #     tags$h4(HTML(sprintf("%s %s",
  #                          selectedZip$city, selectedZip$state
  #     ))),
  #     sprintf("Populacão: %s", as.integer(selectedZip$estimated_population_2019)),tags$br(),
  #     sprintf("Total de Casos Confirmados: %s", as.integer(selectedZip$last_available_confirmed)), tags$br(),
  #     sprintf("Total de óbitos: %s", as.integer(selectedZip$last_available_deaths)), tags$br(),
  #     sprintf("Taxa de letalidade: %s%%", selectedZip$last_available_death_rate)
  #   ))
  #   leafletProxy("map") %>% addPopups(lng, lat, content, layerId = city_ibge_code)
  #   
  # }
  
  
  
  #observador que mostra a cidade clicada
  # observe({
  #   leafletProxy("map") %>% clearPopups()
  #   event <- input$map_marker_click
  #   if (is.null(event))
  #     return()
  #   
  #   isolate({
  #     showCityPopup(event$id, event$lat, event$lng)
  #     #aqui entraria o observador que controla a cidade a ser exibida na previsao
  #   })
  # })
  
  
  
}
shinyApp(ui = ui, server = server)
