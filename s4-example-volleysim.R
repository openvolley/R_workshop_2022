library(volleysim)
library(datavolley)
library(dplyr)

## read an example file
x <- dv_read(dv_example_file())

## calculate the rates we need to simulate
rates <- list(vs_estimate_rates(x, target_team = home_team(x)),
              vs_estimate_rates(x, target_team = visiting_team(x)))

vs_simulate_match(rates, simple = TRUE)

summary(x)

rates <- tribble(~team, ~serve_ace, ~serve_error, ~rec_set_error, ~rec_att_error, ~rec_att_kill, ~trans_set_error, ~trans_att_error, ~trans_att_kill, ~sideout, ~rec_block, ~trans_block,
                 "My Team",    0.062, 0.156, 0.009, 0.071, 0.499, 0.018, 0.082, 0.452, 0.668, 0.075, 0.079,
                 "Other Team", 0.069, 0.190, 0.014, 0.063, 0.523, 0.021, 0.102, 0.435, 0.683, 0.083, 0.109)
knitr::kable(rates)


vs_simulate_match(rates, simple = TRUE)

rates2 <- rates

## increase my team's serve aces and errors by 1% each, and attack kills by 2%
rates2[1, c("serve_ace", "serve_error", "rec_att_kill", "trans_att_kill")] <-
    rates2[1, c("serve_ace", "serve_error", "rec_att_kill", "trans_att_kill")] + c(0.01, 0.01, 0.02, 0.02)

## increase opposition serve aces by 1%
rates2[2, c("serve_ace")] <- rates2[2, c("serve_ace")] + 0.01

vs_simulate_match(rates2, simple = TRUE)


rates3 <- rates

## increase my team's serve aces by 2% and errors by 5%
rates3[1, c("serve_ace", "serve_error")] <- rates3[1, c("serve_ace", "serve_error")] + c(0.02, 0.05)

## decrease opposition reception kills by 5% due to their expected poorer passing
rates3[2, c("rec_att_kill")] <- rates3[2, c("rec_att_kill")] - 0.05
vs_simulate_match(rates3, simple = TRUE)
