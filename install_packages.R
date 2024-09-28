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

# tidytuesdayR not installed, install
if (!("tidytuesdayR") %in% ip$Package){
  install.packages("tidytuesdayR")
}

# ggformula not installed, install
if (!("ggformula") %in% ip$Package){
  install.packages("ggformula")
}

# patchwork not installed, install
if (!("patchwork") %in% ip$Package){
  install.packages("patchwork")
}

# AllanCameron/geomtextpath not installed, install
if (!("geomtextpath") %in% ip$Package){
  pak::pkg_install("AllanCameron/geomtextpath")
}

# gghighlight not installed, install
if (!("gghighlight") %in% ip$Package){
  install.packages("gghighlight")
}

# extrafont not installed, install
if (!("extrafont") %in% ip$Package){
  install.packages("extrafont")
}

# showtext not installed, install
if (!("showtext") %in% ip$Package){
  install.packages("showtext")
}
