class ImageSorter
    def run(image_list)
        # Break main string into individual strings and organize them by location
        locations = {}
        image_list.split("\n").each_with_index do |line, _i|
            # Break strings into relevant components - Not sure how to backreference to symbols :\
            line_data = line.match(/.+\.(?<ext>.+),\s+(?<loc>.+),\s+(?<date>.+)/).named_captures

            # Clean line_data and then add to location hash
            line_data['idx'] = _i
            location = line_data['loc'].to_sym
            line_data.delete('loc')

            if !locations.key?(location) then locations[location] = [] end
            locations[location] << line_data
        end

        # Sort and rename images inside of their location based on date
        new_images = []
        locations.each do |loc, lines|
            lines.sort! {|a, b| a['date'] <=> b['date']}
            tens = (lines.count / 10 + 1).floor
            lines.each_with_index do |line, _i|
                new_images << {name: "#{loc}#{(_i+1).to_s.rjust(tens, '0')}.#{line['ext']}", idx: line['idx']}
            end
        end

        # Sort images back into their original position and return as string
        new_images.sort_by! {|image| image[:idx]}
        new_images.map! {|image| image[:name]}
        return new_images.join("\n")
    end
end