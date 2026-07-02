# Install packages to run the Shiny_monaro.R script and use the app

# The names of packages needed to run the app
packages <- c("Rtools", "shiny", "readxl", "writexl", "shinyjs", "DT", "data.table", "shinydashboard")

# This function checks to see if the packages are installed and then installs them if required
install.packages(setdiff(packages, rownames(installed.packages())))  