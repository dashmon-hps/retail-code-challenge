# frozen_string_literal: true

###
# Class: ImageSorter
# Descr: Mostly a container for holding the meat and bones of the run method and to make rspec look pretty
###
class ImageSorter
  ###
  # Method: run
  # Descr: Takes a stringed list of image name, location, and date and returns a similar string in with transformations
  # Params: (string) @image_list - Stringified list of images, seperated by new line characters
  # Return: (string) Stringified list of sorted and transformed image names in originally provided order
  ###
  def run(image_list)
    # Break main string into individual strings and organize them by location
    locations = {}
    image_list.split("\n").each_with_index do |line, i|
      # Break strings into relevant components
      line_data = line.match(/.+\.(?<ext>.+),\s+(?<loc>.+),\s+(?<date>.+)/).named_captures

      # Clean line_data and then add to location hash
      line_data['idx'] = i
      location = line_data['loc'].to_sym
      line_data.delete('loc')

      locations.key?(location) || locations[location] = []
      locations[location] << line_data
    end

    # Sort and rename images inside of their location based on date
    new_images = []
    locations.each do |loc, lines|
      lines.sort! { |a, b| a['date'] <=> b['date'] }
      tens = (lines.count / 10 + 1).floor
      lines.each_with_index do |line, i|
        new_images << { name: "#{loc}#{(i + 1).to_s.rjust(tens, '0')}.#{line['ext']}", idx: line['idx'] }
      end
    end

    # Sort images back into their original position and return as string
    new_images.sort_by! { |image| image[:idx] }
    new_images.map! { |image| image[:name] }

    new_images.join("\n")
  end
end
