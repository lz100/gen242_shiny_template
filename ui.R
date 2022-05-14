library(shiny)
library(DT)
library(ggplot2)
library(plotly)
library(dplyr)

ui <- navbarPage(
  title = "Your Title",
  footer = div(
    style = "position: fixed; bottom: 0; background-color: #f8f8f8; width: 100%; padding: 5px",
    tags$b("Author: xxx (xxxx@xxx)"),
    tags$b("some other text, like github link...", class="pull-right")
  ),
  # Intro section -----
  tabPanel(
    "Introduction",
    markdown(
      '
      ## Introduction
      Include some words here to introduce your project, and some words about
      this app.

      Some code `1+1`

      Some code chunk
      ```r
      mean(1, 2, 3, 4)
      ```

      ### H3
      #### H4
      ##### H5

      **bold**, _italic_

      *****
      section divider

      To include image from URL:

      ![img](https://girke.bioinformatics.ucr.edu/GEN242/img/UC_Riverside_seal.svg)

      To include image from local, use "www" folder as root and reference the image.
      For example, to include a Shiny logo from "/www/img/shiny.png", refer it as
      "img/shiny.png"

      ![shiny](img/shiny.png)

      ...
      '
    )
  ),
  # DEG section -----
  tabPanel(
    "DEG",
    tabsetPanel(
      tabPanel(
        "Data",
        markdown(
          '
          ## About this dataset
          Some words to describe this dataset, how you get it, what each column
          represents, ...
          '
        ),
        DTOutput("deg_data")
      ),
      tabPanel(
        "Plot",
        sidebarLayout(
          sidebarPanel(
            h3("Plot control"),
            textInput("deg_xlab", "X label", "Gene Counts"),
            textInput("deg_ylab", "Y label", "Comparisions"),
            textInput("deg_title", "Plot title", "DEG of xx, DFR <= xxx, LFC >= xx"),
            selectizeInput(
              "deg_color",
              "Palette to use",
              choices = c('Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2', 'Set1', 'Set2', 'Set3'),
              selected = "Set2"
            ),
            selectizeInput(
              "deg_bar_pos",
              "Bar plot position",
              choices = c('stack', 'dodge', 'fill'),
              selected = "Set2"
            ),
            selectizeInput(
              "deg_alpha",
              "Plot alpha value",
              choices = seq(0.1, 1, 0.1),
              selected = "0.5"
            ),
            numericInput("deg_axisy_size", "Y axis text size", 12, 1)
          ),
          mainPanel(
            plotlyOutput("deg_plot", height = "600px")
          )
        ),
        markdown(
          '
          ## XX plot caption
          This plot shows ...

          You can ... with this plot ...


          To change to your own DEG gene table, the file:
          1. Has a column named `genes` with  be gene names (IDs).
          2. Has a column named `cmp` which contains different comparision group names.
             If your project only has one group, give all rows of this column the
             same name.
          3. Has a column named `direction`, usually only has 3 classes: Up, Down and Insignificant.
             This can be calculated by looking at the adjusted P value (FDR) and
             logFoldChange. Any row is NA, 0, or
             goes obove your thresholds will be Insignificant. Then look
             at the `log2FoldChange`, positive is Up and negative is `Down`.
          '
        )
      )
    )
  ),
  # GO section -----
  tabPanel(
    "GO",
    tabsetPanel(
      tabPanel(
        "Data",
        markdown(
          '
          ## About this dataset
          Some words to describe this dataset, how you get it, what each column
          represents, ...
          '
        ),
        DTOutput("go_data")
      ),
      tabPanel(
        "Plot",
        sidebarLayout(
          sidebarPanel(
            h3("Plot control"),
            numericInput("go_topn", label = "How many terms to show", value = 15, min = 5, max = 25),
            selectizeInput(
              "go_sort",
              "sort GO by",
              choices = c(`Gene Counts` = "Count", `P adjust value`="padj")
            ),
            textInput("go_xlab", "X label", "Gene Counts"),
            textInput("go_ylab", "Y label", "GO term"),
            textInput("go_title", "Plot title", "GO of xx"),
            textInput("go_color_low", "Gradient low color value", "#ff0000"),
            textInput("go_color_high", "Gradient high color value", "#0500ff"),
            selectizeInput(
              "go_alpha",
              "Plot alpha value",
              choices = seq(0.1, 1, 0.1),
              selected = "0.8"
            ),
            numericInput("go_axisy_size", "Y axis text size", 12, 1)
          ),
          mainPanel(
            ## plotly is not working perfectly in this case, use normal ggplot
            # plotlyOutput("go_plot", height = "600px")
            plotOutput("go_plot", height = "600px")
          )
        ),
        markdown(
          '
          ## XX plot caption
          This plot shows ...

          You can ... with this plot ...


          To change to your own GO table, the file:
          1. Has a column named `Description` with  GO description.
          2. Has a column named `padj` which has all p adjusted value for the GO
             term.
          3. Has a column named `Count`, which summarises how many genes are enriched under
             this term.
          '
        )
      )
    )
  ),
  # You can add more sections below -----

  ###
  br(), br(), br()
)

