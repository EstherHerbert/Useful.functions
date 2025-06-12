################################################################################
## Project:
## Program: Read-data.R
## R version 4.3.0 (2023-04-21 ucrt)
## Author:
## Purpose: This script reads in the trial data, applies labels, does basic
##          formatting and performs some checks.
## Packages used:
## Outputs:
## Date:
################################################################################

# Location of data
get_data <- ""

# Lookups ----------------------------------------------------------------------

# CHECK CASE OF LOOKUPS FILE
lookups <- read.csv(paste0(get_data, "Lookups.csv"))

# This chunk of commented out code is only needed if lookups have been provided
# in a different format to how read_prospect is expecting.
#
# fields <- read.csv(paste0(get_data, "Fields.csv"))
#
# lookups <- wrangle_lookups(lookups, fields)

# SOMETIMES I CHANGE LABELS IN LOOKUPS HERE IF NEEDED

# Read data --------------------------------------------------------------------

# List all csv files in the data location
files <- list.files(get_data, ".csv")

# Create clean data names
names <- str_remove(files, ".csv") %>%
  str_replace_all("( - )| ", "_") %>%
  str_remove_all("^[[:digit:]]+") %>%
  str_remove_all("\\(|\\)|-") %>%
  str_to_lower()

# Loop to read in all csv files
master <- list()
for(i in 1:length(files)){
  master[[i]] <- read_prospect(paste0(get_data, files[i]))
  names(master)[i] <- names[i]
}; rm(i, files, names)

# SCRAM report -----------------------------------------------------------------

# IF NOT SAVED IN THE SAME LOCATION AS THE PROSPECT DATA

# Check form lengths -----------------------------------------------------------

export_check(paste0(get_data, "export_notes.txt"), master)

# Save data --------------------------------------------------------------------

# Saving the raw, formatted data, useful when collaborating with others
map2(master, names(master), ~ {
  save(.x, file = paste0("Data/Raw/", .y, ".RData"))
})

# List to environment ----------------------------------------------------------

# This brings all of the data frames out of the list and into the global
# environment so that you can access them without specifying master$data
list2env(master, envir = .GlobalEnv)
