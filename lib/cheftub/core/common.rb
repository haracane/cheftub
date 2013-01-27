module Cheftub
  module Core
    module Common
      def self.create_content_after_confirm(dest_path, content, input_stream=$stdin, output_stream=$stdout, options={})
        exist_flag = FileTest.exist?(dest_path)
        if options[:all_flag] || exist_flag
          answer_options = ["y", "n"]
          answer_options.push "a" if options[:all_flag] == false
          output_stream.print "overwrite #{dest_path}?(#{answer_options}.join("/")): "
          answer = input_stream.gets
          answer.chomp!
          case answer
          when "y"
          when "n"
            return
          when "a"
            options[:all_flag] = true
          end
        end
        File.open(dest_path, "w") do |f|
          f.write(content)
        end
        if exist_flag
          output_stream.puts "overwrited #{dest_path}"
        else
          output_stream.puts "created #{dest_path}"
        end
      end
    end
  end
end