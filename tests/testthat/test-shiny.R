context('Shiny App Running')

test_that('runKTShiny - Expect message when no package is specified', expect_message(KTShiny::runKTShiny()))

test_that('runKTShiny - Expect message when package isn\'t loaded', expect_message(KTShiny::runKTShiny('BeastDevTools')))
