library(tidyverse)

## select all files csv or csv.gz files from the given directory 
# note: there is no reason to unzip the files (unless you want)
data_dir <- "~/Downloads/acc_data"
files <- dir(path=data_dir,full.names = TRUE,pattern = "*.(csv|csv.gz)")

## for a given file
read_accel_data <- function(file_path){
  ## I use the tidyverse.  I could try to install it for you,
  ## but I think that would be quite rude.
  if (!require("tidyverse")){
    stop("Please install tidyverse. install.packages('tidyverse')")
  }
  message("analyzing ",file_path)

  ## extract the user id
  user_id <- sub("^([0-9]+).*","\\1",basename(file_path)) 
  
  ## load the data, if you are testing you
  ## may want to use the following line which reads only 10 rows of a file
  #dta <- read_csv(file_path,n_max = 10,col_types = "dddddddddd")
  dta <- read_csv(file_path,col_types = "dddddddddd")
  
  ## convert the timestamp, which is the number of seconds since 1970
  ## to a posix representation.  Since we dont know the time zone,
  ## it will default to the LOCAL time zone (EST for me) be warned this
  ## may cause trouble when combining data analyzed in England and the US.
  ##
  ## also add the user id...
  dta <- dta %>% mutate(date_time=as.POSIXlt(timenum,origin="1970-1-1"),
                        user_id=user_id)
  return(dta)
}
results <- files %>% map(read_accel_data) %>% bind_rows()
