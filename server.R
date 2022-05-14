


server <- function(input, output, session) {
  # DEG -----
  ## read data
  df_deg <- read.csv("data/degs.csv")
  ## display data
  output$deg_data <- renderDT({
    datatable(df_deg)
  })
  ## plot data
  output$deg_plot <- renderPlotly({
    # use dplyr to clean data
    df_clean <-  df_deg %>%
      group_by(cmp, direction) %>%
      count(direction)
    ## make the plot
    p1 <- ggplot(df_clean) +
      geom_bar(
        aes(x = n, y = cmp, fill = direction),
        position = input$deg_bar_pos,
        alpha = as.numeric(input$deg_alpha),
        stat = "identity"
      ) +
      ggtitle(input$deg_title) +
      xlab(input$deg_xlab) +
      ylab(input$deg_ylab) +
      scale_fill_brewer(palette=input$deg_color) +
      theme_minimal() +
      theme(
        axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.text.y = element_text(size=as.numeric(input$deg_axisy_size))
      )
    ## use plotly to make it interactive
    plotly::ggplotly(p1)
  })

  # GO -----
  ## read data
  df_go <- read.csv("data/go.csv")
  ## display data
  output$go_data <- renderDT({
    datatable(df_go)
  })
  ## plot data (plotly is not working perfectly in this case, use normal ggplot)
  # output$go_plot <- renderPlotly({
  output$go_plot <- renderPlot({
    # use dplyr to clean data
    df_clean <-  df_go %>%
      arrange(!!input$go_sort) %>%
      top_n(as.numeric(input$go_topn))
    ## make the plot
    p1 <- ggplot(df_clean) +
      geom_bar(
        aes(x = Count, y = reorder(Description, !!sym(input$go_sort)), fill = padj),
        alpha = as.numeric(input$go_alpha),
        stat = "identity"
      ) +
      ggtitle(input$go_title) +
      xlab(input$go_xlab) +
      ylab(input$go_ylab) +
      scale_fill_gradient(low = input$go_color_low, high = input$go_color_high) +
      theme_minimal() +
      theme(
        axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.text.y = element_text(size= as.numeric(input$go_axisy_size))
      )
    ## use plotly to make it interactive
    # plotly::ggplotly(p1)
    p1
  })
}
