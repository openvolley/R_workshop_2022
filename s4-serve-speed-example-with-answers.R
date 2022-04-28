library(dplyr)
library(datavolley)
library(mgcv)
library(ggplot2)
# Serve agressiveness

sx <- readRDS("example_data/DE Men 2019/processed.rds")

dat <- sx %>% dplyr::filter(skill == "Serve") %>% mutate(bp = case_when(team == point_won_by ~ 1,
                                    TRUE ~ 0),
                     err = evaluation == "Error") %>% group_by(match_id, set_number, team) %>%
    summarise(bp_rate = mean(bp), err_rate = mean(err), n = n()) %>% ungroup()

ggplot(data = dat, aes(x = err_rate, y = bp_rate) )+ geom_point() + geom_smooth(method = 'gam', method.args = list(family = 'betar'))

# Serve speed

# Data kindly provided by Felipe Lima (Ori)

sx <- readRDS(file = "example_data/Serve_Speed_Example/serve_speed_example.rds")

dat <- dplyr::filter(sx, skill_type == "Jump serve" & serve_speed >= 60) %>%
    mutate(player = as.factor(player_id),
           err = evaluation == "Error",
           pos = evaluation_code %in% c("+", "#", "/"),
           neg = evaluation_code %in% c("=", "-"))

##fite <- gam(err ~ s(serve_speed) + s(player, bs = "re"), data = dat, family = binomial)

fiterr <- gam(err ~ s(serve_speed), data = dat, family = binomial)
fitpos <- gam(pos ~ s(serve_speed), data = dat, family = binomial)
fitneg <- gam(neg ~ s(serve_speed), data = dat, family = binomial)

plot(fiterr)
plot(fitpos)
plot(fitneg)

