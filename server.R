
function(input,output) {
  year_selected <- reactive({
    df %>%
      filter(.,DATA_YEAR==input$year)
  })
  #crime number geographically
  geo <- reactive({
    year_selected() %>%
      group_by(.,STATE)%>%
      summarise(.,crime = n())
  })

  output$map <- renderGvis({gvisGeoChart(geo(), 'STATE', "crime",
                   options=list(region="US", displayMode="regions",
                                resolution="provinces",
                                width='auto', height='auto',
                                title='Hate Crime Across US',
                                colors="['#DAEFFE', '#1396F9', '#0462A8']"
                                ))
  })

  # Offender Info
  off_ <-reactive({
    year_selected() %>%
      mutate(new=get(input$off))%>%
      group_by(.,new)%>%
      summarise(.,VICTIM_tot = n())%>%
      filter(new != "" & new!= "Unknown")
  })
  
  # Offender bar
  output$off_bar<-renderPlot({
    off_()%>%
      ggplot(.,aes(x = new,y=VICTIM_tot,fill=new)) +
      geom_col(width = 1, stat = "identity", color = "white")+
      ggtitle("Bar Plot of Offener Info")+
      xlab("Offener Info") + ylab("Crime Number") 
  })
  
  # Offender pie
  output$off_pie<-renderPlot({
    off_()%>%
      ggplot(.,aes(x = "new",y=VICTIM_tot,fill=new)) +
      geom_bar(width = 1, stat = "identity", color = "white") +
      coord_polar("y", start=0)+theme_void()+
      ggtitle("Pie Plot of Offener Info")+
      xlab("Offener Info") + ylab("Crime Number") 
  })

  #Victim bar Graph
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
       geom_col(aes(fill=new),position="dodge")+
       ggtitle("Plot of Crime Info")+
       xlab("Crime Info") + ylab("Crime Number")+
       theme(text = element_text(size=15),
             axis.text.x = element_text(angle=45, hjust=1))

   })


  #Victim Table
  output$table <- DT::renderDataTable({
    datatable(victim(),rownames = F) %>%
      formatStyle(input$selected,background = 'skyblue',
                  fontWeight ='bold')
  })

 # Time Series

  output$trend_tot <- renderPlot({
    df%>%
      group_by(.,DATA_YEAR)%>%
      summarise(.,crime = n())%>%
      ggplot(.,aes(x = DATA_YEAR,y=crime)) +
      geom_point(aes(colour =crime))+
      geom_line(linetype="solid", color="red")+
      ylab("Crime Number")

  })
  
  output$trend_bias <- renderPlot({
    df %>%
      group_by(.,DATA_YEAR,BIAS_MOTIVATION)%>%
      summarise(.,crime=n())%>%
      ggplot(.,aes(x = DATA_YEAR,y=crime,color=BIAS_MOTIVATION))+geom_point()+
      facet_wrap(~BIAS_MOTIVATION)+
      geom_line() +ylab("Crime Number")
  })
 
  output$trend_vic <- renderPlot({
    df %>%
      mutate(VICTIM_TYPES = str_split(VICTIM_TYPES, ";")) %>%
      unnest(VICTIM_TYPES)%>%
      group_by(.,DATA_YEAR,VICTIM_TYPES)%>%
      summarise(.,crime=n())%>%
      ggplot(.,aes(x = DATA_YEAR,y=crime,color=VICTIM_TYPES))+geom_point()+
      facet_wrap(~VICTIM_TYPES)+
      geom_line() +ylab("Crime Number")
  })

}
