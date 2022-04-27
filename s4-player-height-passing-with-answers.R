library(ggplot2)
library(dplyr)
library(mgcv)

## Italian A1 Men's league data that was scraped from the league web site
x <- readRDS("example_data/rec_height_ITA.rds")

## we use the number of perfect receptions per set, as a measure of passing performance
## not that we necessarily believe that this is a particularly good basis for measuring passing performance, but it is all we had available for this data set

## let's make a simple plot of passing performance against player height, for liberos and outsides

ggplot(x, aes(height, `R# per set`, group = role, col = role)) + geom_point(alpha = 0.15) + geom_smooth(method = "gam", formula = y ~ s(x, k = 5), se = FALSE) + theme_bw() + scale_colour_discrete(name = "Role") + labs(x = "Height (cm)")

## this plot suggests that the passing performance for liberos increases with libero player height, which seems unlikely

## if we look at the player heights over time
ggplot(x, aes(year, height, group = role, col = role)) + geom_point(alpha = 0.15) + geom_smooth(method = "gam", formula = y ~ s(x, k = 5), se = FALSE) + theme_bw() + scale_colour_discrete(name = "Role") + labs(x = "Year", y = "Height (cm)")

## and the passing performance over time
ggplot(x, aes(year, `R# per set`, group = role, col = role)) + geom_point(alpha = 0.15) + geom_smooth(method = "gam", formula = y ~ s(x, k = 5), se = FALSE) + theme_bw() + scale_colour_discrete(name = "Role") + labs(x = "Year", y = "R# per set")

## we can see a problem: as time progressed, liberos got shorter but at the same time passing performance decreased overall, likely as a result of increased jump serve pressure

## can we disentangle these signals?

## we'll fit a model for passing performance to the data, accounting for year and player height
##  a separate model each for liberos and outsides

fitL <- gam(n_perfect_receptions ~ s(height, k = 7) + s(year, k = 5), offset = log(n_sets_played), family = poisson, data = x %>% dplyr::filter(role == "Libero"))
fitS <- gam(n_perfect_receptions ~ s(height, k = 7) + s(year, k = 5), offset = log(n_sets_played), family = poisson, data = x %>% dplyr::filter(role == "Spiker"))

## details of model assessment omitted ...

## show the fitted relationships identified by these models

## first passing performance over time, for a player of average height (for their role)

## data to predict onto
px0 <- as_tibble(as.data.frame(expand.grid(role = c("Libero", "Spiker"), year = seq(min(x$year), max(x$year), by = 1)), stringsAsFactors = FALSE)) %>%
    left_join(x %>% group_by(role) %>% dplyr::summarize(height = mean(height, na.rm = TRUE)), by = "role")

px <- bind_rows({
    ## predictions for liberos
    this <- px0 %>% dplyr::filter(role == "Libero")
    temp <- predict(fitL, newdata = this, se = TRUE)
    this$`R# per set` <- exp(temp$fit)
    this$lower <- exp(temp$fit - 1.96*temp$se.fit)
    this$upper <- exp(temp$fit + 1.96*temp$se.fit)
    this
},
{
    ## predictions for outsides
    this <- px0 %>% dplyr::filter(role == "Spiker")
    temp <- predict(fitS, newdata = this, se = TRUE)
    this$`R# per set` <- exp(temp$fit)
    this$lower <- exp(temp$fit - 1.96*temp$se.fit)
    this$upper <- exp(temp$fit + 1.96*temp$se.fit)
    this
})

## plot it
ggplot(px, aes(year, `R# per set`, group = role)) +
    geom_ribbon(aes(ymin = lower, ymax = upper, fill = role), alpha = 0.4) +
    geom_path(aes(color = role)) + theme_bw() + labs(x = "Year") + scale_colour_discrete(name = "Role") + scale_fill_discrete(name = "Role")

## (reasonably similar to the plot above, from the raw data with a simple smooth)

## now passing performance by player height, assuming the year 2019
px2 <- bind_rows({
    ## range of heights for liberos
    temp <- quantile(x$height[x$role == "Libero"], c(0.05, 0.95), na.rm = TRUE)
    this <- tibble(role = "Libero", height = seq(temp[1], temp[2], by = 1), year = 2019)
    temp <- predict(fitL, newdata = this, se = TRUE)
    this$`R# per set` <- exp(temp$fit)
    this$lower <- exp(temp$fit - 1.96*temp$se.fit)
    this$upper <- exp(temp$fit + 1.96*temp$se.fit)
    this
}, {
    ## range of heights for outsides
    temp <- quantile(x$height[x$role == "Spiker"], c(0.05, 0.95), na.rm = TRUE)
    this <- tibble(role = "Spiker", height = seq(temp[1], temp[2], by = 1), year = 2019)
    temp <- predict(fitS, newdata = this, se = TRUE)
    this$`R# per set` <- exp(temp$fit)
    this$lower <- exp(temp$fit - 1.96*temp$se.fit)
    this$upper <- exp(temp$fit + 1.96*temp$se.fit)
    this
})

ggplot(px2, aes(height, `R# per set`, group = role)) +
    geom_ribbon(aes(ymin = lower, ymax = upper, fill = role), alpha = 0.4) +
    geom_path(aes(color = role)) + theme_bw() + labs(x = "Height (cm)") + scale_colour_discrete(name = "Role") + scale_fill_discrete(name = "Role")

