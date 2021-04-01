module FeatureFlagsHelper

  def flag_variation_types(selected = nil)
    options_for_select(FeatureFlag::VARIATION_TYPES_FOR_SELECT, selected)
  end

  def selected_variations(options = [], selected = nil)
    options_for_select(options, selected)
  end
end
