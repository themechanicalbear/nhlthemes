# library(shiny)
# library(miniUI)
# library(dplyr)

options(stringsAsFactors = FALSE)

# team_colors <- readxl::read_excel("data/team_colors.xlsx")

# We'll wrap our Shiny Gadget in an addin.
# Let's call it 'nhl_theme_switcher()'.
nhl_theme_switcher <- function() {

  # Our ui will be a simple gadget page, which
  # simply displays the time in a 'UI' output.
  ui <- miniPage(
    gadgetTitleBar("Theme"),
    miniContentPanel(
      selectInput("team", "Team Selected:",
                  c("Anaheim Ducks", "Arizona Coyotes", "Boston Bruins", "Buffalo Sabres", "Calgary Flames",
                    "Carolina Hurricanes", "Chicago Blackhawks", "Colorado Avalanche",
                    "Columbus Blue Jackets", "Dallas Stars", "Detroit Red Wings", "Edmonton Oilers",
                    "Florida Panthers", "Los Angeles Kings", "Minnesota Wild", "Montreal Canadiens",
                    "Nashville Predators", "New Jersey Devils", "New York Islanders", "New York Rangers",
                    "Ottawa Senators", "Philadelphia Flyers", "Pittsburgh Penguins", "St. Louis Blues",
                    "San Jose Sharks", "Tampa Bay Lightning", "Toronto Maple Leafs", "Vancouver Canucks",
                    "Vegas Golden Knights", "Washington Capitals", "Winnipeg Jets")),
      selectInput("dark", "Dark Mode?:",
                  c("Light" = "light",
                    "Dark" = "dark"))
    )
  )

  server <- function(input, output, session) {

    team_colors <- readxl::read_excel("inst/extdata/team_colors.xlsx")

    # Listen for 'done' events. When we're finished, we'll update the theme, and then stop the gadget.
    observeEvent(input$done, {
      color_gutter_line_numbers = team_colors[team_colors$team == input$team, "gutter_line_numbers"]
      color_chunk_queued_line = team_colors[team_colors$team == input$team, "chunk_queued_line"]
      color_chunk_executed_line = team_colors[team_colors$team == input$team, "chunk_executed_line"]
      color_chunk_resting_line = team_colors[team_colors$team == input$team, "chunk_resting_line"]
      color_chunk_error_line = team_colors[team_colors$team == input$team, "chunk_error_line"]
      color_active_line = team_colors[team_colors$team == input$team, "active_line"]
      color_cursor = team_colors[team_colors$team == input$team, "cursor"]
      color_function_color = team_colors[team_colors$team == input$team, "function_color"]
      color_library = team_colors[team_colors$team == input$team, "library"]
      color_keywords = team_colors[team_colors$team == input$team, "keywords"]

      if (input$dark == "dark") {
        css <- readLines("~/.R/rstudio/themes/NHL_Dark.rstheme",-1)
        # css[6] = paste0("  --main-color-1: ", color_1, ";")
        writeLines(css, "~/.R/rstudio/themes/NHL_Dark.rstheme")
        rstudioapi::applyTheme("NHL_Dark")
      }

      if (input$dark == "light") {
        css <- readLines("~/.R/rstudio/themes/NHL_Light.rstheme",-1)
        css[6] = paste0("  --gutter_line_numbers: ", color_gutter_line_numbers, ";")
        css[7] = paste0("  --chunk_queued_line: ", color_chunk_queued_line, ";")
        css[8] = paste0("  --chunk_executed_line: ", color_chunk_executed_line, ";")
        css[9] = paste0("  --chunk_resting_line: ", color_chunk_resting_line, ";")
        css[10] = paste0("  --chunk_error_line: ", color_chunk_error_line, ";")
        css[11] = paste0("  --active_line: ", color_active_line, ";")
        css[12] = paste0("  --cursor: ", color_cursor, ";")
        css[13] = paste0("  --function_color: ", color_function_color, ";")
        css[14] = paste0("  --library: ", color_library, ";")
        css[15] = paste0("  --keywords: ", color_keywords, ";")
        writeLines(css, "~/.R/rstudio/themes/NHL_Light.rstheme")
        rstudioapi::applyTheme("NHL_Light")
      }
      stopApp()
    })

  }

  # We'll use a pane viwer, and set the minimum height at
  # 300px to ensure we get enough screen space to display the gadget.
  # viewer <- paneViewer(300)
  viewer <- dialogViewer(dialogName = "NHL Themes", width = 600, height = 300)
  runGadget(ui, server, viewer = viewer)

}

# Try running the gadget!
# nhl_theme_switcher()


