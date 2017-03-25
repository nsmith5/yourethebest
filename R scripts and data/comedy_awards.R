library(stringr)

# all players ####

data(Master)

comedy_awards <- data_frame(playerID = unique(Master$playerID))
View(comedy_awards)

l <- nrow(comedy_awards)
v <- vector("logical", length = l)
# not in HOF ###
data("HallOfFame")
not_inducted_hof <- HallOfFame %>%
  group_by(playerID) %>%
  summarise(sum = sum(inducted == "Y")) %>%
  filter(sum == 0) %>%
  .$playerID

comedy_awards$not_inducted_hof <- v
for (i in 1:l) {
  comedy_awards$not_inducted_hof[i] <- comedy_awards$playerID[i] %in% not_inducted_hof
}

# taller ####

table(Master$height)
taller_six_two <- Master %>%
  group_by(playerID) %>%
  filter(height > 74) %>%
  .$playerID

comedy_column <- function (lookup,
                           column = comedy_awards$playerID,
                           l = 18846) {
  holder <- vector("logical", length = l)
  for (i in 1:l) {
    holder[i] <- column[i] %in% lookup
  }
  holder
}

comedy_awards$taller_six_two <- comedy_column(lookup = taller_six_two)

table(Master$height)

# is dead ####

is_dead <- Master %>%
  filter(!is.na(deathYear)) %>%
  .$playerID

comedy_awards$is_dead <- comedy_column(lookup = is_dead)

# born 19thC ####

born_19th <- Master %>%
  filter(!is.na(deathYear) & birthYear < 1900) %>%
  .$playerID

comedy_awards$born_19th <- comedy_column(born_19th)

#testing ####

View(comedy_awards)
comedy_awards$test <- comedy_awards$not_inducted_hof | comedy_awards$taller_six_two | comedy_awards$born_19th |comedy_awards$all_star
comedy_awards$test <- comedy_awards$test | comedy_awards$is_millenial
comedy_awards$test <- comedy_awards$test | comedy_awards$one_season
comedy_awards$test <- comedy_awards$test | comedy_awards$born_outside_us
comedy_awards$test <- comedy_awards$test | comedy_awards$alliterative
comedy_awards$test <- comedy_awards$test | comedy_awards$throws_left
comedy_awards$test <- comedy_awards$test | comedy_awards$bats_left
sum(comedy_awards$test)


tail(sort(table(Master$deathCity)))
#is millenial ####
is_millenial <- Master %>%
  filter(birthYear > 1982) %>%
  .$playerID

comedy_awards$is_millenial <- comedy_column(is_millenial)

#lived 90 ####

Master %>%
  filter(deathYear - birthYear > 90)

# one season ####

one_season <- players_positions_career %>%
  filter(seasons == 1) %>%
  .$playerID

comedy_awards$one_season <- comedy_column(one_season)

# born outside US ####

born_outside_us <- Master %>%
  filter(birthCountry != "USA") %>%
  .$playerID

comedy_awards$born_outside_us <- comedy_column(born_outside_us)

sort(table(Master$birthState))

# alliterative names ####

alliterative <- Master[str_extract(Master$nameFirst, pattern = "[:alpha:]{1}") == str_extract(Master$nameLast, pattern = "[:alpha:]{1}"),]$playerID

alliterative_frame <- Master[str_extract(Master$nameFirst, pattern = "[:alpha:]{1}") == str_extract(Master$nameLast, pattern = "[:alpha:]{1}"),]
View(alliterative_frame)

comedy_awards$alliterative <- comedy_column(alliterative)

# left handed ####

table(Master$throws)
table(Master$bats)

throws_left <- Master %>%
  filter(throws == "L") %>%
  .$playerID

comedy_awards$throws_left <- comedy_column(throws_left)

# bats left ####

bats_left <- Master %>%
  filter(bats == "L") %>%
  .$playerID

comedy_awards$bats_left <- comedy_column(bats_left)


comedy_awards$output2 <- NA

# All Star Table ###
#unused
data("AllstarFull")

all_star <- AllstarFull %>%
  group_by(playerID) %>%
  summarise(n = n(), games = sum(GP)) %>%
  filter(n > 4) %>%
  .$playerID

comedy_awards$all_star <- comedy_column(all_star)

# output and saving ####

comedy_awards$output2 <- NA
comedy_awards$output2[comedy_awards$bats_left == TRUE] <- "who bats left"
comedy_awards$output2[comedy_awards$throws_left == TRUE] <- "who throws left"
comedy_awards$output2[comedy_awards$born_outside_us == TRUE] <- "who was born outside the U.S."
comedy_awards$output2[comedy_awards$taller_six_two == TRUE] <- "who is taller than 6'2"
comedy_awards$output2[comedy_awards$one_season == TRUE] <- "who only played 1 season"
comedy_awards$output2[comedy_awards$born_19th == TRUE] <- "who was born in the 1800s"
comedy_awards$output2[comedy_awards$is_millenial == TRUE] <- "who is a millenial"
comedy_awards$output2[comedy_awards$alliterative == TRUE] <- "with an alliterative name"
comedy_awards$output2[comedy_awards$not_inducted_hof == TRUE] <- "who missed the Hall of Fame"


comedy_awards_output <- select(coemdy_awards, playerID = )
write_csv(comedy_awards_output, path = file.path(saving_path, "final_append.csv"))
