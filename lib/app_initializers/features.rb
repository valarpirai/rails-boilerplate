module Features
  features = config_file('features.yml')

  class << self
    def has_features(tenant = :account)

      features['account'].each |feature|
        define_method :"#{feature}?" do
          account_feature = account.features
        end
      end
    end
  end
end

