library(tidyverse)
library(filesstrings)
behav_path <- "C:\\Users\\cat4624\\Box\\craigthorburn\\production_nonlinguistic_tones\\analysis\\alldata_t3.5\\input\\behavioral\\"
raw_path <- "C:\\Users\\cat4624\\Box\\craigthorburn\\production_nonlinguistic_tones\\analysis\\alldata_t3.5\\input\\raw\\"
upload_path <- "C:\\Users\\cat4624\\Box\\craigthorburn\\production_nonlinguistic_tones\\analysis\\alldata_t3.5\\input\\uploads\\"

setwd(behav_path)
behav_csv <- read.csv("data_exp_195560-v5-concat.csv")
PIDs <- behav_csv %>% select("Participant.External.Session.ID","Participant.Private.ID")  %>% 
              distinct() %>% 
              mutate(Participant.ID=substring(Participant.External.Session.ID, 20, 24))
#rm(behav_csv)
              #mutate(Participant.External.Session.ID=as.character(Participant.Private.ID,))


setwd(raw_path)
sapply(PIDs$Participant.ID, dir.create)

setwd(upload_path)
files <- list.files()

file_mover <- function(IDs, file_list, to_path, from_path)
{
  priv_ID <- IDs$Participant.Private.ID
  pub_ID <- IDs$Participant.ID
  files_to_move <- file_list[grepl(priv_ID, file_list)]
  print(files_to_move)
  to_path <- paste0(to_path, pub_ID, "\\")
  files_to_move_w_path <- sapply(c(to_path, files_to_move), paste0)
  move_files(files_to_move, to_path, overwrite = FALSE)
}

for(i in 1:nrow(PIDs)){
  file_mover(PIDs[i,], files, raw_path, upload_path)
}

