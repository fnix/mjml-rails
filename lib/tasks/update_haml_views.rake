namespace :mjml do
  desc 'Update the views in test/views/haml with the erb files in test/views/{notifier,template_subdir}'
  task :erb2haml do
    VIEWS_PATH = 'test/views'
    erb_files = Dir.glob("#{VIEWS_PATH}/{notifier,template_subdir}/**/*.{mjml,erb}").select { |f| File.file? f}
    erb_files.each do |file|
      puts "Generating HAML for #{file}..."
      FileUtils.mkdir_p File.dirname(file).gsub(VIEWS_PATH, "#{VIEWS_PATH}/haml")
      `html2haml -e #{file} #{file.gsub(VIEWS_PATH, "#{VIEWS_PATH}/haml").gsub(/\.erb\z/, '.haml')}`
    end
  end
end