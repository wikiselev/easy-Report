args <- commandArgs(TRUE)

# load required libraries
library(knitr)
library(slidify)
library(markdown)

# create a report directory with figure directory inside
report.dir <- paste0(args[2], "/")
dir.create(report.dir)
dir.create(paste0(report.dir, "figure"))

# store the total script name and a short script name (without extension .Rmd)
script <- args[1]
script.name <- strsplit(script, "\\.")[[1]][1]

# pull only R code from your script and save it to report.R file
purl(script, paste0(report.dir, "report.R"), documentation = 2)
# knit your script into a report, output will be report.md file
knit(script, paste0(report.dir, "report.md"))
# move figures to the report folder
files <- list.files("figure/", full.names = TRUE)
file.copy(from=files, to=paste0(report.dir, "figure/"), recursive = TRUE,
	overwrite = TRUE)
unlink("figure/", recursive = TRUE)

# create an .html report file from the .md file using a usual github markdown style
markdownToHTML(paste0(report.dir, "report.md"), paste0(report.dir, "report.html"),
	stylesheet = "custom_styles/github.css")

setwd(report.dir)
# copy necessary files and styles from the slidify package directory
# to the current directory
scaffold = system.file('skeleton', package = 'slidify')
file.copy(list.files(scaffold, full.names = T), ".", recursive = TRUE,
	overwrite = TRUE)
# this file from slidify package is not needed - remove it
file.remove("index.Rmd")

# create slides from the report.md file
slidify("report.md")
file.rename(from = "report.txt", to = "slides.html")

# copy the original script file to the report folder
file.copy(from = paste0("../", script), to = script, overwrite = TRUE)

# this is optional
# apply custom styles to your presentation (here are the files that I use)
# these styles make a code font and code box margins and also some header fonts
# smaller than default - this allows to add more stuff to the slides
# it also makes the slides scrollable - this is very useful when you content
# does not fit the slide size
file.copy("../custom_styles/default.css",
	"libraries/frameworks/io2012/css/default.css", overwrite = TRUE)
file.copy("../custom_styles/slidify.css",
	"libraries/frameworks/io2012/css/slidify.css", overwrite = TRUE)
