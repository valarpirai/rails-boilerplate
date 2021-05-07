class AppLogger
	class << self
		[:application, :sidekiq_bb].each do |logger|
			define_method logger do |msg,level=:info|
				instance(logger).public_send(level, msg)
			end
		end
		
		def import(msg,level=:info)
			instance(:import_error, ImportLogger).public_send(level, msg)
		end

		def instance(logger, logger_klass = CustomLogger)
			return class_variable_get(:"@@#{logger}") if class_variable_defined?(:"@@#{logger}")
			class_variable_set :"@@#{logger}", logger_klass.new("#{Rails.root}/log/#{logger}.log")
		end
	end
end

class CustomLogger < Logger
	def format_message(severity, timestamp, progname, msg)
		"#{timestamp.to_formatted_s(:db)} #{msg}\n"
	end
end
