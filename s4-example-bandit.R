# Example of running the bandit


dvw <- ovdata_example("190301_kats_beds")
ssd <- ov_simulate_setter_distribution(dvw = dvw, play_phase = "Reception", n_sim = 100, attack_by = "zone",   setter_position_by = "rotation")

ov_plot_ssd(ssd)

ov_plot_sequence_distribution(ssd)[[1]]

ov_plot_distribution(ssd)

# With historical data

sd_history <- ov_create_history_table(dvw = dvw, attack_by = 'zone', play_phase = "Reception", setter_position_by = "front_back")

ov_plot_history_table(sd_history, team = sd_history$prior_table$team[1], setter_id = sd_history$prior_table$setter_id[1])
