# Author(s): P. Durant
# Contributors: 
# Description: Place any themes, color scales, or other functions that help
# you create figures here! Make sure to add yourself to the authors list if
# you add something here. To use this helper script, just run everything to get 
# these functions into your environment. We might make this into a package in 
# the future.

# TX EEB color schemes for insect orders
scale_fill_txeeb_orders <- function() {
  ggplot2:::manual_scale(
    'fill',
    values = setNames(
      # Colors for orders go here 
      c(
        '#8D693B', # brown for Blattodea
        '#DCA356', # soft yellow for Coleoptera
        '#335381', # dark blue for Dermaptera
        '#428291', # official blue for Diptera
        '#9E5E58', # dark red for Hemiptera
        '#597f6b', # light green for Hymenoptera
        '#495649', # dark green for Lepidoptera
        '#6B778F', # gray for Odonata
        '#8F6D85', # purple for Orthoptera
        '#8BBC64' # spring green for Trichoptera
      ),
      # Respective orders go here
      c(
        'Blattodea',
        'Coleoptera',
        'Dermaptera',
        'Diptera',
        'Hemiptera', 
        'Hymenoptera',
        'Lepidoptera',
        'Odonata',
        'Orthoptera',
        'Trichoptera'
      )
    )
  )
}
