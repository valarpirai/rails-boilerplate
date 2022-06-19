# frozen_string_literal: true

# Instance variables
# See https://ddnexus.github.io/pagy/api/pagy#instance-variables
Pagy::DEFAULT[:page]   = 1                                  # default
Pagy::DEFAULT[:items]  = 20                                 # default
Pagy::DEFAULT[:outset] = 0                                  # default

require 'pagy/extras/items'
# set to false only if you want to make :items_extra an opt-in variable
Pagy::DEFAULT[:items_extra] = false    # default true
Pagy::DEFAULT[:items_param] = :items   # default
Pagy::DEFAULT[:max_items]   = 100      # default

Pagy::DEFAULT[:size]  = [5,4,4,5]
