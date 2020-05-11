dashboardPage(
  dashboardHeader(title = "USA Hate Crime"),
  dashboardSidebar(
    sidebarUserPanel("Jingrou Wei"),


sidebarMenu(
  menuItem('Hate Crime Geo',tabName = 'geo',icon=icon('map')),
  menuItem('Known Offenders',tabName = 'off_info',icon=icon('database')),
  menuItem('Crime Info',tabName = 'crime',icon=icon('database')),
  menuItem('Data Trend',tabName = 'trend',icon = icon("chart-line"))
),


  selectizeInput('from','Year From',
               choices = unique(df$DATA_YEAR),
               selected = unique(df$DATA_YEAR)[1]),
  selectizeInput('to','To',
               choices=unique(df$DATA_YEAR),
               selected = unique(df$DATA_YEAR)[28])
  ),
dashboardBody(
  tabItems(
    tabItem(tabName = 'geo',
            # selectizeInput('type','Vic Type',
            #               choices = unique(df$BIAS_MOTIVATION),
            #               selected = unique(df$BIAS_MOTIVATION)[1]),
            fluidRow(box(htmlOutput("map"),height='auto',width = 'auto'))
    ),
    tabItem(tabName = "off_info",
            selectizeInput('off','Offenders',
                           choices = names(df)[5:6],
                           selected = names(df)[5]),
            fluidRow(box(plotOutput('off'),height='auto',width = 'auto'))
    ),
    tabItem(tabName = "crime",
            selectizeInput('type','Vic Type',
                           choices = names(df)[c(7:9,11)],
                           selected = names(df)[11]),
            column(7,fluidRow(box(plotOutput('victim'),height='auto',width = 'auto'))),
            column(4,fluidRow(box(dataTableOutput('table'),width='auto')))
    ),
    tabItem(tabName = "trend",
            fluidRow(box(plotOutput('trend'),height='auto',width = 'auto'))
    )
)
)
)
