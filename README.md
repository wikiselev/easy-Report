easy-Report
=============

An R script which allows you to quickly produce a report from a (suitable) [RMarkdown](http://www.rstudio.com/ide/docs/authoring/using_markdown) file.

The script is based on [knitr](https://github.com/yihui/knitr), [slidify](https://github.com/ramnathv/slidify) and [markdown](http://cran.r-project.org/web/packages/markdown/index.html) R packages, you need to install them in advance to be able to run the script.

__Usage__: Change a content of script.Rmd to your own one and run

```bash
Rscript easy-Report.R script.Rmd report
```
__Output__: The `report` folder will be created and all output report files (.R, .md, .html, html_slides) will be written in it.

You can view the output report.html and slides.html pages produced from the default script.Rmd here:

http://wikiselev.github.io/easy-Report/report.html

http://wikiselev.github.io/easy-Report/slides.html

Motivation and Explanation
=============

Coding can be very exciting. And the more excited you are the less you wish to comment your code or to create any simple report about what you have done. It becomes even more complicated if your code produces not just one output file but also a lot of different figures which can change upon changing some of the code parameters (for example when you need to experiment with your parameter set and find the best one and then prove that it was the best). In this case I would spend a lot of time for coding, then for commenting and then for creating a report in a pdf or powerpoint/keynote format. Luckily there are tools that can help with reporting your results in a very efficient way.

knitr
-------------

Recently I found out about [knitr](https://github.com/yihui/knitr) R package. The basic idea of this package is that it allows you to knit your R code in your report. To be able to do that you need to create a [RMarkdown](http://www.rstudio.com/ide/docs/authoring/using_markdown) file which contains a step-by-step description of your script and the R code of your script at the same time. Then you need to compile it and as an output you will get a [Markdown](http://en.wikipedia.org/wiki/Markdown) version of your report. Then you can convert it to HTML and share with you colleagues. One of the coolest thing about this package is that it embeds all the figures produced by the R code in the report so that you do not need to worry about updating figures in your report upon updating any parameter in the R code. You just need to compile your file again and you will get a new report with the updated figures.

[knitr](https://github.com/yihui/knitr) is an optimization of a classical [Sweave](http://www.stat.uni-muenchen.de/~leisch/Sweave/) package which has been widely used for creating R reports. A list of all optimized features is [here](https://github.com/yihui/knitr#motivation).

slidify
-------------

While HTML report is cool, it is still not very useful if you need to present it to a large audience. For these purposes there is another cool R package [slidify](https://github.com/ramnathv/slidify). If you modify your RMarkdown file a bit by adding slide separator signs it will produce beautiful HTML5 slides out of your report. Since the slides are in HTML format one does not need any special software to open it (any modern web browser will do the job) and then it’s super easy to share your presentation just by sending a web link to it. However, there are some slidify disadvantages which do not allow one to easily use it.

### slidify issues

1. By default the main function author() of this package requires a manual creation of an RMarkdown file which makes it impossible to automate the reporting.

2. [__The most important one!__] Even though this package utilizes knitr package described above to produce an .md file, sometimes it can behave differently from the original knitr behaviour. For example, have a look at this [issue](https://github.com/ramnathv/slidify/issues/276) with a data.table compatibility. This can be a serious problem because in some cases it prevents slidify from compilation of the original .Rmd file.

### easy-Report script

This script `easy-Report.R` was written to solve the two issues above. The script first knits `script.Rmd` file and produces `script.R` (pure R code from `script.Rmd`) and a markdown `script.md` file, then it creates `report.html` (an html report for `script.Rmd`) using [github css markdown style](https://gist.github.com/andyferra/2554919). Finally, it also slidifies the markdown file into `slides.html` (two custom css styles are used here - see description of `custom_styles` folder below).

Minimal script.Rmd file requirements
==============

To be able to get a report without errors or messages one has to write a properly formatted .Rmd file. Here are the minimal requirements for the .Rmd file:

* An input script.Rmd file must have the following header (it is needed for a slidification of the report)

```bash
---
title       : Your title
subtitle    : Your subtitle
author      : Your name
job         :
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      #
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---
```

All of the line parameters of the header can be changed for your needs (please check the slidify manual).

* The report is splitted into slides by `---` separator. Make sure you properly separate your slides so that the information is homogeneously distributed over your presentation. Please see script.Rmd for a minimal example.

* A slide title is defined by `##`. Please see script.Rmd for a minimal example.

custom_styles folder
==============

`custom_styles` folder is used in the script by default. The main purpose of it is to change the default markdown and slidify styles. I made these changes because I did not like the default styles. However, if you do not want to make these changes in the default settings you need to comment the last 4 lines of easy-Report.R script and not read further.

`custom_styles` folder contains three files:

* __github.css__

    This is a [standard github style](https://gist.github.com/andyferra/2554919). It is used to produce a 'github markdown'-like HTML report from an .md file.
  
  
* __default.css__: This is my modification of default.css file included in slidify package. Below are my changes.

Original file:

```css
slides > slide {
  overflow: hidden;
}

pre {
  line-height: 28px;
  padding: 10px 0 10px 60px;
  letter-spacing: -1px;
  margin-bottom: 20px;
}

code {
  font-size: 95%;
}
```

My modifications:

```css
slides > slide {
  overflow: scroll;
}

pre {
  line-height: 20px;
  padding: 0 0 0 60px;
  letter-spacing: 0px;
  margin-bottom: 5px;
}

code {
  font-size: 55%;
}
```

* __slidify.css__: This is my modification of slidify.css file included in slidify package. Below are my changes.

Original file:  

```css
article p, article li, article li.build{
  font-size:22px;
}

slide:not(.segue) h2{
  font-size: 52px;
}
```

My modifications:  

```css
article p, article li, article li.build{
  font-size:16px;
}

slide:not(.segue) h2{
  font-size: 26px;
}
```
