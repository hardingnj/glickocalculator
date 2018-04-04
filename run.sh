docker run -d -p 3838:3838 \
  -v /srv/shinyapps/:/srv/shiny-server/ \
  -v /srv/shinylog/:/var/log/shiny-server/ \
  hardingnj/glickocalculator
