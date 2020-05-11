library(shiny)
library(shinydashboard)
library(DT)
library(googleVis)
library(tidyr)
library(dplyr)
library(ggplot2)
library(stringr)


data = read.csv("hate_crime.csv",stringsAsFactors=F)

df = data%>%
  select(.,DATA_YEAR,STATE_NAME,DIVISION_NAME,
         VICTIM_COUNT,OFFENDER_RACE,OFFENDER_ETHNICITY,LOCATION_NAME,
         OFFENSE_NAME,VICTIM_TYPES,BIAS_DESC)%>%
  rename(.,STATE = STATE_NAME,CRIME_CATEGORY=OFFENSE_NAME)



df = 
  df %>%
  mutate(BIAS_DESC = str_split(BIAS_DESC, ";")) %>%
  unnest(BIAS_DESC)%>%
  mutate(BIAS_MOTIVATION = if_else(BIAS_DESC %in% 
      c("Anti-White","Anti-Black or African American","Anti-Asian","Anti-Multiple Races, Group","Anti-Native Hawaiian or Other Pacific Islander",
        "Anti-Jewish","Anti-Hispanic or Latino","Anti-Arab","Anti-Eastern Orthodox (Russian, Greek, Other)","Anti-American Indian or Alaska Native"),
        "Race/Ethnicity/Ancestry/Bias",
              if_else(BIAS_DESC %in%
                c("Anti-Islamic (Muslim)","Anti-Hindu", "Anti-Other Religion","Anti-Catholic","Anti-Other Christian","Anti-Multiple Religions, Group","Anti-Atheism/Agnosticism","Anti-Mormon","Anti-Sikh","Anti-Buddhist","Anti-Protestant","Anti-Jehovah's Witness"),
                  "Religions",
                  if_else(BIAS_DESC %in% 
                     c("Anti-Gay (Male)","Anti-Lesbian (Female)","Anti-Lesbian, Gay, Bisexual, or Transgender (Mixed Group)","Anti-Bisexual","Anti-Transgender","Anti-Gender Non-Conforming","Anti-Heterosexual" ),"Gender Identity",
                       if_else(BIAS_DESC %in%   
                         c("Anti-Mental Disability","Anti-Physical Disability"),"Disability",
                         if_else(BIAS_DESC %in%
                          c("Anti-Female","Anti-Male"),"Gender",BIAS_DESC))))))

  



