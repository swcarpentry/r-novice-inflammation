source("build_lesson.R")

get_stage("before_install") %>%
  add_code_step(update.packages(ask = FALSE))

get_stage("install") %>%
  add_code_step(remotes::install_github("hadley/requirements")) %>%
  add_code_step(install.packages(requirements:::req_dir("_episodes_rmd")))

get_stage("deploy") %>%
  add_step(build_lesson())

get_stage("after_deploy") %>%
  add_code_step(install.packages("readr")) %>%
  add_step(check_links())

if (Sys.getenv("id_rsa") != "" && ci()$get_branch() == "master") {
  # pkgdown documentation can be built optionally. Other example criteria:
  # - `inherits(ci(), "TravisCI")`: Only for Travis CI
  # - `ci()$is_tag()`: Only for tags, not for branches
  # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
  # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_push_deploy(path = "_rendered", branch = "gh-pages"))
}
