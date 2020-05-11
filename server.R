
function(input,output) {
  #crime number geographically
  year_selected <- reactive({
    df %>%
      filter(.,DATA_YEAR>=input$from & DATA_YEAR<=input$to)
  })
  
  geo <- reactive({
    df %>%
      filter(.,DATA_YEAR>=input$from & DATA_YEAR<=input$to) %>%
      # select(.,STATE,VICTIM_COUNT,BIAS_MOTIVATION==input$type)%>%
      group_by(.,STATE)%>%
      summarise(.,VICTIM_tot = sum(VICTIM_COUNT))
  })
  
  output$map <- renderGvis({gvisGeoChart(geo(), 'STATE', "VICTIM_tot",
                   options=list(region="US", displayMode="regions", 
                                resolution="provinces",
                                width='auto', height='auto',
                                titleTextStyle="{color:'red', fontName:'Courier', fontSize:16}"))
  })
  
  #Offender bar
  output$off<-renderPlot({
      year_selected() %>%
      group_by(.,get(input$off))%>%
      summarise(.,VICTIM_tot = sum(VICTIM_COUNT,na.rm = T))%>%
      # gvisColumnChart(.,xvar =OFFENDER_RACE,yvar=VICTIM_tot)
      ggplot(.,aes(x = get(input$off),y=VICTIM_tot))+ geom_col(get(input$off))
  })
  
 

  # #Victim bar Graph
  victim <- reactive({
    year_selected() %>%
      mutate(new = str_split(get(input$type), ";")) %>%
      unnest(new)%>%
      group_by(.,new)%>%
      summarise(.,VICTIM_tot = sum(VICTIM_COUNT,na.rm = T))%>%
      arrange(.,desc(VICTIM_tot))
    })
      
   output$victim <- renderPlot({
     victim()%>%
       top_n(10)%>%
       ggplot(.,aes(x = new,y=VICTIM_tot)) + 
       geom_col(aes(fill=new),position="dodge")
   })   
      

  #Victim Table
  output$table <- DT::renderDataTable({
    datatable(victim(),rownames = F) %>% 
      formatStyle(input$selected,background = 'skyblue',
                  fontWeight ='bold')
  })
  
  #Time Series
  trend <- reactive({
  year_selected() %>% mutate(DATA_YEAR = as.factor(DATA_YEAR)) %>%
    group_by(DATA_YEAR)%>%
    summarise(.,sum(VICTIM_COUNT,na.rm=T))})


  output$trend <- renderGvis({trend()%>%gvisLineChart()})
}