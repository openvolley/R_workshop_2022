![](extra/3logo2red.png)

# R workshop 2022

Structure: 5 x two-hour sessions, each with presentation of course material, and time during which participants can work on exercises or with their own data.

## Preparation

Participants are asked to install R, RStudio, Git, and some R packages in preparation for the workshop, if they do not already have these on their computer.

1. Download and install R

   https://cran.r-project.org/

2. Download and install RStudio

   https://www.rstudio.com/products/rstudio/download/#download

3. Download and install Git

   https://git-scm.com/downloads (Accept all the default options when installing)

4. Start RStudio and install some packages. This will take a while to run:

   ```
   install.packages(c("tidyverse", "remotes"))
   ```

   And finally:

   ```
   install.packages("datavolley", repos = c("https://openvolley.r-universe.dev", "https://cloud.r-project.org"))
   ```


## Course sessions

1. [An introduction to R](https://openvolley.github.io/R_workshop_2022/s1-intro-R.html)<br />Introductions and a general overview of R.

2. [The R datavolley package](https://openvolley.github.io/R_workshop_2022/s2-datavolley-basics.html)<br />Focus on the `datavolley` package in R, reading your data in and working with it.

3. [Advanced reports](https://openvolley.github.io/R_workshop_2022/s3-advanced-reports.html)<br />Different methods of conveying information (tables, graphs, court plots, video) and how to generate these in R. Heatmaps, video playlists, and more.

4. [Advanced analytics](https://openvolley.github.io/R_workshop_2022/s4-advanced-analytics.html)<br />Advanced analytics to support decision making, match preparation, and similar. Examples of statistical models, simulating matches.

5. [Computer vision in R](https://openvolley.github.io/R_workshop_2022/s5-computer-vision.html)<br />Other odds and ends, including computer vision and video processing.

## Acknowledgements

The example data used in this workshop was provided by:

- `DE Men 2019` - 10 matches from the 2019/20 German 1. Bundesliga (Men) season, provided by Michael Mattes
- `DE Women 2020` - 3 matches from the 2020/21 German 1. Bundesliga (Women) season, provided by Michael Mattes
- `VNL_Women_2021.csv` - a summary of team performance from the 2021 Women's Volleyball Nations League. Match data provided by Pablo Sánchez Morillas and Lauren Bertolacci, and analyzed with https://apps.untan.gl
- `NCAA_D1W_2019.csv` - set scores from the 2019 NCAA D1 season, from https://stats.ncaa.org/
- `Serve_Speed_Example` - serve speed data, provided by Felipe Aparecido Lima
- `rec_height_ITA` - long-term player heights and passing performance from the Italian A1 league, from http://www.legavolley.it/
