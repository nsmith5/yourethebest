library(Lahman)library(dplyr)
library(readr)
Players <- unique(Master$playerID)
#18846

testf <- Appearances %>%
  group_by(playerID) %>%
  summarise(seasons = n(),
            games_all = sum(G_all),
            GS = sum(GS, na.rm = TRUE),
            start = min(yearID),
            end = max(yearID)) %>%
  arrange(desc(games_all)) %>%
  left_join(Master, by = "playerID")

# Position identifier function ####

p_a <- function(position_var, seuil = 100) {sum(position_var) > seuil}

data(Appearances)

# Players by position by career #

players_positions_etc <- Appearances %>%
  group_by(playerID) %>%
  summarise(seasons = n(),
            games_all = sum(G_all),
            GS = sum(GS, na.rm = TRUE),
            batting = p_a(G_batting, seuil = 100 * seasons),
            on_defense = p_a(G_defense, seuil = 100 * seasons),
            pitcher = p_a(G_p, seuil = 100 * seasons),
            catcher = p_a(G_c, seuil = 100 * seasons),
            fb_CHECK1 = sum(G_1b),
            fb_CHECK2 = 100 * seasons,
            first_b = p_a(G_1b, seuil = 100 * seasons),
            second_b = p_a(G_2b, seuil = 100 * seasons),
            third_b = p_a(G_3b, seuil = 100 * seasons),
            short_s = p_a(G_ss, seuil = 100 * seasons),
            left_f = p_a(G_lf, seuil = 100 * seasons),
            center_f = p_a(G_cf, seuil = 100 * seasons),
            right_f = p_a(G_rf, seuil = 100 * seasons),
            out_f = p_a(G_of, seuil = 100 * seasons),
            desig_hit = p_a(G_dh, seuil = 100 * seasons),
            pinch_hit = p_a(G_ph, seuil = 100 * seasons),
            pinch_run = p_a(G_pr, seuil = 100 * seasons),
            start =  min(yearID),
            end = max(yearID)) %>%
  arrange(playerID) %>%
  left_join(Master, by = "playerID")
samplef <- sample_n(players_positions, 500) %>% arrange(desc(first_b))
View(samplef)

players_positions_career <- Appearances %>%
  group_by(playerID) %>%
  summarise(seasons = n(),
            start =  min(yearID),
            end = max(yearID),
            games = sum(G_all),
            batting = p_a(G_batting, seuil = 100 * seasons),
            on_defense = p_a(G_defense, seuil = 100 * seasons),
            pitcher = p_a(G_p, seuil = 100 * seasons),
            catcher = p_a(G_c, seuil = 100 * seasons),
            first_b = p_a(G_1b, seuil = 100 * seasons),
            second_b = p_a(G_2b, seuil = 100 * seasons),
            third_b = p_a(G_3b, seuil = 100 * seasons),
            short_s = p_a(G_ss, seuil = 100 * seasons),
            left_f = p_a(G_lf, seuil = 100 * seasons),
            center_f = p_a(G_cf, seuil = 100 * seasons),
            right_f = p_a(G_rf, seuil = 100 * seasons),
            out_f = p_a(G_of, seuil = 100 * seasons),
            desig_hit = p_a(G_dh, seuil = 100 * seasons),
            pinch_hit = p_a(G_ph, seuil = 100 * seasons),
            pinch_run = p_a(G_pr, seuil = 100 * seasons)) %>%
  arrange(playerID)

# Players by position by year #####

players_positions_by_year_etc <- Appearances %>%
  group_by(playerID, yearID) %>%
  summarise(seasons = n(),
            games_all = sum(G_all),
            GS = sum(GS, na.rm = TRUE),
            batting = p_a(G_batting),
            on_defense = p_a(G_defense),
            pitcher = p_a(G_p),
            catcher = p_a(G_c),
            fb_CHECK1 = sum(G_1b),
            fb_CHECK2 = 100,
            first_b = p_a(G_1b),
            second_b = p_a(G_2b),
            third_b = p_a(G_3b),
            short_s = p_a(G_ss),
            left_f = p_a(G_lf),
            center_f = p_a(G_cf),
            right_f = p_a(G_rf),
            out_f = p_a(G_of),
            desig_hit = p_a(G_dh),
            pinch_hit = p_a(G_ph),
            pinch_run = p_a(G_pr),
            start =  min(yearID),
            end = max(yearID)) %>%
  arrange(desc(first_b)) %>%
  left_join(Master, by = "playerID")

players_positions_by_year <- Appearances %>%
  group_by(playerID, yearID) %>%
  summarise(games_all = sum(G_all),
            batting = p_a(G_batting),
            on_defense = p_a(G_defense),
            pitcher = p_a(G_p),
            catcher = p_a(G_c),
            first_b = p_a(G_1b),
            second_b = p_a(G_2b),
            third_b = p_a(G_3b),
            short_s = p_a(G_ss),
            left_f = p_a(G_lf),
            center_f = p_a(G_cf),
            right_f = p_a(G_rf),
            out_f = p_a(G_of),
            desig_hit = p_a(G_dh),
            pinch_hit = p_a(G_ph),
            pinch_run = p_a(G_pr)) %>%
  arrange(playerID, yearID)

players_positions_by_year_sum <- Appearances %>%
  group_by(playerID, yearID) %>%
  summarise(games_all = sum(G_all),
            batting = sum(G_batting),
            on_defense = sum(G_defense),
            pitcher = sum(G_p),
            catcher = sum(G_c),
            first_b = sum(G_1b),
            second_b = sum(G_2b),
            third_b = sum(G_3b),
            short_s = sum(G_ss),
            left_f = sum(G_lf),
            center_f = sum(G_cf),
            right_f = sum(G_rf),
            out_f = sum(G_of),
            desig_hit = sum(G_dh),
            pinch_hit = sum(G_ph),
            pinch_run = sum(G_pr)) %>%
  arrange(playerID, yearID)
players_positions_by_year <- players_positions_by_year_sum

for (i in 4:ncol(players_positions_by_year)) {
  players_positions_by_year[i] <- players_positions_by_year[i] > 100
}

players_positions_by_year_master <- players_positions_by_year %>% left_join(Master, by = "playerID")
# scratchpad ####

sample_ppy <- sample_n(players_positions_by_year_master, 500)
View(sample_ppy)

samplef <- sample_n(players_positions_by_year, 1000)
View(samplef)

args(sample_n)

head(players_positions_by_year)
head(as.data.frame(players_positions_by_year))

dim(players_positions_by_year)
dim(testf2)

View(players_positions_by_year)

# Saving csvs ####
saving_path <- file.path("~","Documents","Baseball Hack Day", "Output")
names_output <- select(players_positions,
                       playerID,
                       nameFirst,
                       nameLast,
                       nameGiven)

View(names_output)

write_csv(names_output, path = file.path(saving_path, "player_names.csv"))
write_csv(players_positions_career,
          path = file.path(saving_path, "player_positions_career.csv"))
write_csv(players_positions_by_year,
          path = file.path(saving_path, "player_positions_by_year.csv"))

dir(saving_path)

dir("~")
all_names

