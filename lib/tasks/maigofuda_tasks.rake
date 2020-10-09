# frozen_string_literal: true

desc 'Task for Maigofuda gem.'
namespace :maigofuda do

  desc 'exec maigofuda:rebuild:error_codes'
  task rebuild: 'rebuild:error_codes'

  namespace :rebuild do

    desc 'Rebuild config/error_codes.yml'
    task error_codes: :environment do
      ::Maigofuda.eager_load!
      File.open(::Maigofuda.configuration.error_code_file, 'a+') do |f|
        file_data = f.read
        defineds  = YAML.safe_load file_data
        defineds ||= {}

        f.write("\n") if file_data.present? && file_data[-1] != "\n"

        ([::Maigofuda::BaseError] + ::Maigofuda::BaseError.descendants).each do |klass|
          next if defineds.key? klass.name

          f.write "#{klass.name}: \n"
        end
      end
    end
  end
end
