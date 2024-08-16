# Check if pak is installed, if not install else load
ip <- installed.packages() |> as.data.frame()

# if tidyverse not installed, install
if (!("tidyverse") %in% ip$Package){
  install.packages("tidyverse")
}

# if colorspace not installed, install
if (!("colorspace") %in% ip$Package){
  install.packages("colorspace")
}

# hrbrthemes not installed, install
if (!("hrbrthemes") %in% ip$Package){
  install.packages("hrbrthemes")
}

# ggtext not installed, install
if (!("ggtext") %in% ip$Package){
  install.packages("ggtext")
}