require 'java'
require 'csv'

class OrphanGenerator

attr_accessor :orphan

  def initialize(orphan)
    @orphan = orphan
  end

  def generate(file)
    case(orphan.format)
    when 'csv'
      generate_csv(file)
    else
      'Error'
    end
  end

  def generate_csv(file)
    results = orphan.get_content
    CSV.open(file.path, 'wb') do |csv|
      begin
        csv << results[0].keys
      rescue NoMethodError
        csv << ['No results found.']
      end
      results.each do |result|
        row = []
        result.each do |_key, value|
          row.push(value.is_a?(Array) ? ASUtils.to_json(value) : value)
        end
        csv << row
      end
    end
  end

end
