# create video highlights

library(ovva)
library(datavolley)
library(volleyreport)
library(volleytas)
library(dplyr)
library(ovideo)
library(editry)

data_path = "/home/ick003/Documents/Donnees/VolleyBall/Dropbox/tas/State League 2021 Men/"

x<-datavolley::dv_read(paste0(data_path, "&2021_08_14M-VIK_vs_VDM-GF.dvw"))
dv_meta_video(x) <- paste("/home/ick003/Documents/Donnees/VolleyBall/Dropbox/server_videos/State League 2021 Men/2021_08_14M-VIK_vs_VDM-GF.m4v")

px <- datavolley::plays(x)
px$label <- paste(px$home_team_id, px$home_team_score, "-", px$visiting_team_score, px$visiting_team_id)

px$label <- paste(px$home_team_id, px$home_team_score, "\n", px$visiting_team_id,px$visiting_team_score)

px <- px %>% mutate(
    home_team_lab = stringr::str_pad(string = .data$home_team_id, width = 9, side = "right"),
    visiting_team_lab = stringr::str_pad(string = .data$visiting_team_id, width = 6, side = "right"),
    home_team_score = case_when(.data$point_won_by == .data$home_team ~ home_team_score - 1L,
                                TRUE ~ home_team_score),
    visiting_team_score = case_when(.data$point_won_by == .data$visiting_team ~ visiting_team_score - 1L,
                                    TRUE ~ visiting_team_score),
    home_team_score_lab = stringr::str_pad(string = .data$home_team_score, width = 2, side = "left"),
    visiting_team_score_lab = stringr::str_pad(string = .data$visiting_team_score, width = 2, side = "left"),
    tmp_lab = paste0(.data$home_team_lab," ",.data$home_team_score_lab, "\n", .data$visiting_team_lab," ",.data$visiting_team_score_lab),
    tmp_lab2 = paste0(.data$home_team_lab," ",x$meta$result$score_home_team[1]," ",.data$home_team_score_lab, "\n",
                      .data$visiting_team_lab," ",x$meta$result$score_visiting_team[1]," ",.data$visiting_team_score_lab),
    tmp_lab3 = paste0(.data$home_team_lab," ",x$meta$result$score_home_team[1]," ",x$meta$result$score_home_team[2]," ",.data$home_team_score_lab, "\n",
                      .data$visiting_team_lab," ",x$meta$result$score_visiting_team[1]," ",x$meta$result$score_visiting_team[2]," ",.data$visiting_team_score_lab),
    tmp_lab4 = paste0(.data$home_team_lab," ",x$meta$result$score_home_team[1]," ",x$meta$result$score_home_team[2]," ",x$meta$result$score_home_team[3]," ",.data$home_team_score_lab, "\n",
                      .data$visiting_team_lab," ",x$meta$result$score_visiting_team[1]," ",x$meta$result$score_visiting_team[2]," ",x$meta$result$score_visiting_team[3]," ",.data$visiting_team_score_lab),
    tmp_lab5 = paste0(.data$home_team_lab," ",x$meta$result$score_home_team[1]," ",x$meta$result$score_home_team[2]," ",x$meta$result$score_home_team[3]," ",x$meta$result$score_home_team[4]," ",.data$home_team_score_lab, "\n",
                      .data$visiting_team_lab," ",x$meta$result$score_visiting_team[1]," ",x$meta$result$score_visiting_team[2]," ",x$meta$result$score_visiting_team[3]," ",x$meta$result$score_visiting_team[4]," ",.data$visiting_team_score_lab),
    label = case_when(set_number == 1 ~ tmp_lab,
                      set_number == 2 ~ tmp_lab2,
                      set_number == 3 ~ tmp_lab3,
                      set_number == 4 ~ tmp_lab4,
                      set_number == 5 ~ tmp_lab5))

myfuns <- ovva::ovva_highlight_handler(clip_duration = 20)$fun
team_select = na.omit(unique(px$team))
player_select = na.omit(unique(px$player_name))
selected_pid <- bind_rows(lapply(list(myfuns[[1]]), function(myfun) myfun(x = px, team = team_select, player = player_select)),
                          tidyr::drop_na(px[which(px$point_id == max(px$point_id)-1),], "video_time"))

# Check duration:

sum(pull(selected_pid %>% group_by(point_id) %>% summarise(duration = max(video_time) - min(video_time)), duration))

# Create playlist

tm <- ov_video_timing() ## tighter than normal timing
ply <- ov_video_playlist(selected_pid, x$meta, extra_cols = "label", timing = tm)

# Create clip
vb_logo <- "/home/ick003/Documents/Donnees/VolleyBall/Software/Openvolley/ovlogo-wg.png"


clips <- ov_editry_clips(
    title = "presents...",
    title_args = list(duration = 2, layers = list(er_layer_fill_color())),
    title2 = "2021 Tasmanian State League Final",
    title2_args = list(duration = 3, transition = er_transition(name = "windowslice")),
    playlist = ply, label_col = "label", seamless = TRUE
)

# Create a subtitle layer for the score:

clips[[1]]$layers[[2]] = list()
clips[[1]]$layers[[2]]$type = "image-overlay"
clips[[1]]$layers[[2]]$zoomDirection = NULL
clips[[1]]$layers[[2]]$width = 0.25
clips[[1]]$layers[[2]]$height = 0.25
clips[[1]]$layers[[2]]$position = 'top'
clips[[1]]$layers[[2]]$path = "/home/ick003/Documents/Donnees/VolleyBall/VTi/vtas-recreated.png"

clips_tmp = clips[-c(1:2,length(clips))]
clips_tmp = lapply(clips_tmp, function(x){
    y = x
    y$layers[[3]] = list();
    y$layers[[3]]$type = "subtitle";
    y$layers[[3]]$text = x$layers[[2]]$text
    y$layers[[4]] = list()
    y$layers[[4]]$type = "image-overlay"
    y$layers[[4]]$zoomDirection = NULL
    y$layers[[4]]$width = 0.075
    y$layers[[4]]$height = 0.075
    y$layers[[4]]$position = 'bottom-right'
    y$layers[[4]]$path = "/home/ick003/Documents/Donnees/VolleyBall/Software/ScienceUntangled/icon-su-vtas-stacked.png"
    y$layers[[2]] <- NULL
    return(y)})
clips[3:(length(clips)-1)] = clips_tmp

clips = c(clips, list(er_clip(duration = 2.5, layers = list(er_layer_image(path = vb_logo)))))

library(editry)

outfile <- tempfile(fileext = ".mp4")
my_spec <- er_spec(out_path = outfile, clips = clips, theme = NULL)
er_exec_wait(spec = my_spec, fast = FALSE)

## and view the output
if (interactive()) browseURL(outfile)

