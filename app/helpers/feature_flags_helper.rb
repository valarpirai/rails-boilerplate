module FeatureFlagsHelper

  def flag_variation_types
    options_for_select(FeatureFlag::VARIATION_TYPES_FOR_SELECT)
  end
end
