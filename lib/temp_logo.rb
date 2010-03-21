class TempLogo
  def self.create_logo(company_name) 
    logo_file = "/tmp/#{DateTime.now.strftime("%s")}-logo.jpg"
    `convert ~/Pictures/logo_background.jpg -resize 400x -gravity center -pointsize 22 -fill white -annotate 0 "#{company_name}" "#{logo_file}"`
    return File.new(logo_file)
  end
end
