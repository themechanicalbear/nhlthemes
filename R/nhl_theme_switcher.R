options(stringsAsFactors = FALSE)

themes_folder_mac <- '~/.R/rstudio/themes/'
lib_path <- .Library

nhl_theme_switcher <- function() {
  ui <- fluidPage(
    # titlePanel("title panel"),
    # mainPanel("main panel",
    fluidRow(
      selectInput("dark", "Dark Mode?:",
                  c("Light" = "light",
                    "Dark" = "dark"))),
    fluidRow(
      column(2, imageOutput("avalanche", click = "avalanche_click", width = "150px", height = "100px")),
      column(2, imageOutput("blackhawks", click = "blackhawks_click", width = "150px", height = "100px")),
      column(2, imageOutput("blues", click = "blues_click", width = "150px", height = "100px")),
      column(2, imageOutput("bruins", click = "bruins_click", width = "150px", height = "100px")),
      column(2, imageOutput("canadiens", click = "canadiens_click", width = "150px", height = "100px")),
      column(2, imageOutput("canucks", click = "canucks_click", width = "150px", height = "100px"))),
    fluidRow(
      column(2, imageOutput("capitals", click = "capitals_click", width = "150px", height = "100px")),
      column(2, imageOutput("coyotes", click = "coyotes_click", width = "150px", height = "100px")),
      column(2, imageOutput("devils", click = "devils_click", width = "150px", height = "100px")),
      column(2, imageOutput("ducks", click = "ducks_click", width = "150px", height = "100px")),
      column(2, imageOutput("flames", click = "flames_click", width = "150px", height = "100px")),
      column(2, imageOutput("flyers", click = "flyers_click", width = "150px", height = "100px"))),
    fluidRow(
      column(2, imageOutput("hurricanes", click = "hurricanes_click", width = "150px", height = "100px")),
      column(2, imageOutput("islanders", click = "islanders_click", width = "150px", height = "100px")),
      column(2, imageOutput("jackets", click = "jackets_click", width = "150px", height = "100px")),
      column(2, imageOutput("jets", click = "jets_click", width = "150px", height = "100px")),
      column(2, imageOutput("kings", click = "kings_click", width = "150px", height = "100px")),
      column(2, imageOutput("knights", click = "knights_click", width = "150px", height = "100px"))),
    fluidRow(
      column(2, imageOutput("leafs", click = "leafs_click", width = "150px", height = "100px")),
      column(2, imageOutput("lightning", click = "lightning_click", width = "150px", height = "100px")),
      column(2, imageOutput("oilers", click = "oilers_click", width = "150px", height = "100px")),
      column(2, imageOutput("panthers", click = "panthers_click", width = "150px", height = "100px")),
      column(2, imageOutput("penguins", click = "penguins_click", width = "150px", height = "100px")),
      column(2, imageOutput("predators", click = "predators_click", width = "150px", height = "100px"))),
    fluidRow(
      column(2, imageOutput("rangers", click = "rangers_click", width = "150px", height = "100px")),
      column(2, imageOutput("sabres", click = "sabres_click", width = "150px", height = "100px")),
      column(2, imageOutput("senators", click = "senators_click", width = "150px", height = "100px")),
      column(2, imageOutput("sharks", click = "sharks_click", width = "150px", height = "100px")),
      column(2, imageOutput("stars", click = "stars_click", width = "150px", height = "100px")),
      column(2, imageOutput("wild", click = "wild_click", width = "150px", height = "100px"))),
    fluidRow(
      column(2, imageOutput("wings", click = "wings_click", width = "150px", height = "100px")))
    # )
  )

  server <- function(input, output, session) {
    session$onSessionEnded(stopApp)

    # If you want to mofify the colors used update this spreadsheet and then rerun the use_data function
    # team_colors <- readxl::read_excel("inst/extdata/team_colors.xlsx")
    # usethis::use_data(team_colors, internal = TRUE, overwrite = TRUE)
    team_colors

    set_colors <- function(team) {
      color_gutter_line_numbers = team_colors[team_colors$team == team, "gutter_line_numbers"]
      color_chunk_queued_line = team_colors[team_colors$team == team, "chunk_queued_line"]
      color_chunk_executed_line = team_colors[team_colors$team == team, "chunk_executed_line"]
      color_chunk_resting_line = team_colors[team_colors$team == team, "chunk_resting_line"]
      color_chunk_error_line = team_colors[team_colors$team == team, "chunk_error_line"]
      color_active_line = team_colors[team_colors$team == team, "active_line"]
      color_cursor = team_colors[team_colors$team == team, "cursor"]
      color_function_color = team_colors[team_colors$team == team, "function_color"]
      color_library = team_colors[team_colors$team == team, "library"]
      color_keywords = team_colors[team_colors$team == team, "keywords"]
      bg_team = team

      if (input$dark == "dark") {
        css <- readLines("~/.R/rstudio/themes/NHL_Dark.rstheme",-1)
        # css[6] = paste0("  --main-color-1: ", color_1, ";")
        writeLines(css, "~/.R/rstudio/themes/NHL_Dark.rstheme")
        rstudioapi::applyTheme("NHL_Dark")
      }

      if (input$dark == "light") {
        # Check to make sure the NHL Light theme exists else create
        if (!file.exists(glue(themes_folder_mac, "NHL_Light.rstheme"))) {
          nhl_theme_css <- readLines(system.file("extdata", "NHL_Light.rstheme", package = "nhlthemes"), -1)
          writeLines(nhl_theme_css, glue(themes_folder_mac, "NHL_Light.rstheme"))
        }
        if (!file.exists(glue(themes_folder_mac, "/logos/", bg_team, ".gif"))) {
          file.copy(glue(lib_path, "/nhlthemes/extdata/logos/", bg_team, ".gif"),
                    glue(themes_folder_mac, "logos/", bg_team, ".gif"))
        }
        css <- readLines("~/.R/rstudio/themes/NHL_Light.rstheme",-1)
        css[6] = glue("  --gutter_line_numbers: ", color_gutter_line_numbers, ";")
        css[7] = paste0("  --chunk_queued_line: ", color_chunk_queued_line, ";")
        css[8] = paste0("  --chunk_executed_line: ", color_chunk_executed_line, ";")
        css[9] = paste0("  --chunk_resting_line: ", color_chunk_resting_line, ";")
        css[10] = paste0("  --chunk_error_line: ", color_chunk_error_line, ";")
        css[11] = paste0("  --active_line: ", color_active_line, ";")
        css[12] = paste0("  --cursor: ", color_cursor, ";")
        css[13] = paste0("  --function_color: ", color_function_color, ";")
        css[14] = paste0("  --library: ", color_library, ";")
        css[15] = paste0("  --keywords: ", color_keywords, ";")
        css[16] = paste0("  --background_image: ", "url('logos/", bg_team, ".gif')", ";")
        # css[16] = paste0("  --background_image: ", "url(", lib_path, "/nhlthemes/extdata/logos/", bg_team, ".gif)", ";")
        writeLines(css, "~/.R/rstudio/themes/NHL_Light.rstheme")
        rstudioapi::applyTheme("NHL_Light")
      }
      stopApp()
    }

    observeEvent(input$avalanche_click, {set_colors("avalanche")})
    observeEvent(input$blackhawks_click, {set_colors("blackhawks")})
    observeEvent(input$blues_click, {set_colors("blues")})
    observeEvent(input$bruins_click, {set_colors("bruins")})
    observeEvent(input$canadiens_click, {set_colors("canadiens")})
    observeEvent(input$canucks_click, {set_colors("canucks")})
    observeEvent(input$capitals_click, {set_colors("capitals")})
    observeEvent(input$coyotes_click, {set_colors("coyotes")})
    observeEvent(input$devils_click, {set_colors("devils")})
    observeEvent(input$ducks_click, {set_colors("ducks")})
    observeEvent(input$flames_click, {set_colors("flames")})
    observeEvent(input$flyers_click, {set_colors("flyers")})
    observeEvent(input$hurricanes_click, {set_colors("hurricanes")})
    observeEvent(input$islanders_click, {set_colors("islanders")})
    observeEvent(input$jackets_click, {set_colors("jackets")})
    observeEvent(input$jets_click, {set_colors("jets")})
    observeEvent(input$kings_click, {set_colors("kings")})
    observeEvent(input$knights_click, {set_colors("knights")})
    observeEvent(input$leafs_click, {set_colors("leafs")})
    observeEvent(input$lightning_click, {set_colors("lightning")})
    observeEvent(input$oilers_click, {set_colors("oilers")})
    observeEvent(input$panthers_click, {set_colors("panthers")})
    observeEvent(input$penguins_click, {set_colors("penguins")})
    observeEvent(input$predators_click, {set_colors("predators")})
    observeEvent(input$rangers_click, {set_colors("rangers")})
    observeEvent(input$sabres_click, {set_colors("sabres")})
    observeEvent(input$senators_click, {set_colors("senators")})
    observeEvent(input$sharks_click, {set_colors("sharks")})
    observeEvent(input$stars_click, {set_colors("stars")})
    observeEvent(input$wild_click, {set_colors("wild")})
    observeEvent(input$wings_click, {set_colors("wings")})

    output$avalanche <- renderImage({
      list(src = system.file("extdata/logos", "avalanche.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$blackhawks <- renderImage({
      list(src = system.file("extdata/logos", "blackhawks.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$blues <- renderImage({
      list(src = system.file("extdata/logos", "blues.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$bruins <- renderImage({
      list(src = system.file("extdata/logos", "bruins.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$canadiens <- renderImage({
      list(src = system.file("extdata/logos", "canadiens.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$canucks <- renderImage({
      list(src = system.file("extdata/logos", "canucks.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$capitals <- renderImage({
      list(src = system.file("extdata/logos", "capitals.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$coyotes <- renderImage({
      list(src = system.file("extdata/logos", "coyotes.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$devils <- renderImage({
      list(src = system.file("extdata/logos", "devils.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$ducks <- renderImage({
      list(src = system.file("extdata/logos", "ducks.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$flames <- renderImage({
      list(src = system.file("extdata/logos", "flames.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$flyers <- renderImage({
      list(src = system.file("extdata/logos", "flyers.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$hurricanes <- renderImage({
      list(src = system.file("extdata/logos", "hurricanes.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$islanders <- renderImage({
      list(src = system.file("extdata/logos", "islanders.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$jackets <- renderImage({
      list(src = system.file("extdata/logos", "jackets.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$jets <- renderImage({
      list(src = system.file("extdata/logos", "jets.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$kings <- renderImage({
      list(src = system.file("extdata/logos", "kings.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$knights <- renderImage({
      list(src = system.file("extdata/logos", "knights.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$leafs <- renderImage({
      list(src = system.file("extdata/logos", "leafs.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$lightning <- renderImage({
      list(src = system.file("extdata/logos", "lightning.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$oilers <- renderImage({
      list(src = system.file("extdata/logos", "oilers.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$panthers <- renderImage({
      list(src = system.file("extdata/logos", "panthers.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$penguins <- renderImage({
      list(src = system.file("extdata/logos", "penguins.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$predators <- renderImage({
      list(src = system.file("extdata/logos", "predators.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$rangers <- renderImage({
      list(src = system.file("extdata/logos", "rangers.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$sabres <- renderImage({
      list(src = system.file("extdata/logos", "sabres.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$senators <- renderImage({
      list(src = system.file("extdata/logos", "senators.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$sharks <- renderImage({
      list(src = system.file("extdata/logos", "sharks.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$stars <- renderImage({
      list(src = system.file("extdata/logos", "stars.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$wild <- renderImage({
      list(src = system.file("extdata/logos", "wild.gif", package = "nhlthemes"))}, deleteFile = FALSE)

    output$wings <- renderImage({
      list(src = system.file("extdata/logos", "wings.gif", package = "nhlthemes"))}, deleteFile = FALSE)
  }

  viewer <- dialogViewer(dialogName = "NHL Themes", width = 1200, height = 700)
  runGadget(ui, server, viewer = viewer)
}

# Try running the gadget!
# nhl_theme_switcher()








