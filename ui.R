dashboardPage(skin = "black",
  dashboardHeader(title = "USA Hate Crime"),
  dashboardSidebar(
    sidebarUserPanel("Jingrou Wei"),


sidebarMenu(
  menuItem('Introduction',tabName = 'intro',icon=icon('book-open')),
  menuItem('Hate Crime Map',tabName = 'geo',icon=icon('map')),
  menuItem('Known Offenders',tabName = 'off_info',icon=icon('database')),
  menuItem('Crime Info',tabName = 'crime',icon=icon('database')),
  menuItem('Data Trend',tabName = 'trend',icon = icon("chart-line"))
),


  selectizeInput('year','Year',
               choices = unique(df$DATA_YEAR),
               selected = unique(df$DATA_YEAR)[28])
  ),
dashboardBody(
  tabItems(
    tabItem(tabName='intro',
            fluidRow(
              box(width = 12,
                  tags$h1(strong("Measuring the Hate Crime in USA")),
                  tags$h1(p("\n")),
                  tags$h4(
                    p("A hate crime is criminal offense against a person or property motivated in whole or in part 
                      by an offender’s bias against a race, religion, disability, sexual orientation, ethnicity, gender, or gender identity."),
                    p("Thousands of hate crimes happen every year in the United States, in which people are targeted for the way they look, 
                      the religion they practice, the people they love and the languages they speak. The hate crime need to be valued
                      due to the freedom and equality of each person in US."),
                    p("In the project, we will observe how hate crime distributed based on known offenser identity, victim types, and crime information.
                    Additionally, the trend of hate crime over years is shown for time series analysis purpose.")),
                  tags$h1(p("\n")),
                  tags$h3(strong("Known Offenser - Race/Ethnicity")),
                  tags$h5(          
                    p("The following five racial designations are: White, Black or African American, American Indian or Alaska Native, Asian, and Native Hawaiian or Other Pacific Islander. \n 
                      In addition, the project uses the ethnic designations of 'Hispanic or Latino' and 'Not Hispanic or Latino'.")
                  ),
                  tags$h3(strong("Crime Information")),
                  tags$h4(strong("Offense Types")),
                  tags$h5(
                    p("13 offense types that crimes against persons and crimes against property already being reported: 
                      murder and nonnegligent manslaughter, rape (revised and legacy definitions), aggravated assault, simple assault, intimidation, human trafficking—commercial sex acts, 
                      and human trafficking—involuntary servitude (crimes against persons); and robbery, burglary, larceny-theft, motor vehicle theft, arson, and destruction/damage/vandalism (crimes against property)."),
                    p("Crimes against society, which includes drug or narcotic offenses, gambling offenses, prostitution offenses, weapon law violations, and animal cruelty offenses."),
                  ),
                  tags$h4(strong("Victim Types")),
                  tags$h5(
                    p("The victim of a hate crime can be an individual, a business/financial institution, a government entity, a religious organization, or society/public as a whole.")
                    ),
                  
                  tags$h4(strong("Bias Motivition")),
                  tags$h5(
                    p("Offender’s bias against a race, gender, gender identity, religion, disability, sexual orientation, or ethnicity of persons, property, or society.")
                  )
    ))),
    
    
    tabItem(tabName = 'geo',
            fluidRow(box(htmlOutput("map"),height='auto',width = 'auto'))
    ),
    tabItem(tabName = "off_info",
            selectizeInput('off','Offenders',
                           choices = names(df)[5:6],
                           selected = names(df)[5]),
            column(6,fluidRow(box(plotOutput('off_bar'),height='auto',width = 'auto'))),
            column(6,fluidRow(box(plotOutput('off_pie'),height='auto',width = 'auto')))
    ),
    tabItem(tabName = "crime",
            selectizeInput('type','Crime Info',
                           choices = names(df)[c(7:9,11)],
                           selected = names(df)[11]),
            column(7,fluidRow(box(plotOutput('victim'),height='auto',width = 'auto'))),
            column(4,fluidRow(box(dataTableOutput('table'),width='auto')))
    ),
    tabItem(tabName = "trend",
            tags$h4(          
              p("Total Crime Number Changes")),
            fluidRow(box(plotOutput('trend_tot'),height='auto',width = 'auto')),
            tags$h4(          
              p("Time Series of Bias Motivition")),
            fluidRow(box(plotOutput('trend_bias'),height='auto',width = 'auto')),
            tags$h4(          
              p("Time Series of Victim Type")),
            fluidRow(box(plotOutput('trend_vic'),height='auto',width = 'auto'))
            
            

 )
)
)
)
