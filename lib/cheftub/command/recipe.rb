# coding: utf-8
module Cheftub
  module Command
    module Recipe
      def self.parse_opts(argv)
        ret = {}
        
        next_argv = []
        
        while 0 < argv.size do
          val = argv.shift
          if val[0..1] == "--"
            label = val[2..-1].gsub(/-/,"_").to_sym
          else
            label = nil
          end
          case label
          when :type, :package, :repository
            ret[label] = ARGV.shift
          else
            next_argv.push val
          end
        end
        argv.push(*next_argv)
        
        if ret[:verbose_flag] then
          Cheftub.logger.level = Logger::INFO
        else
          Cheftub.logger.level = Logger::WARN
        end
        
        return ret
      end
      
      def self.run(argv, input_stream=$stdin, output_stream=$stdout)
        params = self.parse_opts(argv)
        recipe_name = argv.shift
        
        template = "default"
        case params[:type]
        when "yum"
          template = params[:type]
          params[:package] ||= recipe_name
        when "yum_repo"
          template = params[:type]
          params[:repository] ||= recipe_name
        else
          params[:package] ||= recipe_name
        end
        
        if ! FileTest.exists?("recipes")
          Cheftub.logger.error("recipes directory does not exist")
        end

        template_path = "#{Cheftub::CHEFTUB_HOME}/lib/cheftub/templates/recipes/#{template}.rb.erb"
        STDERR.puts template_path
        content = ERB.new(File.read(template_path)).result(binding)
        dest_path = "recipes/#{recipe_name}.rb"
        
        Cheftub::Core::Common.create_content_after_confirm(dest_path, content, input_stream, output_stream)
        
        case params[:type]
        when "yum_repo"
          if FileTest.exists?("/etc/yum.repos.d/#{target}")
            Cheftub::Core::Common.create_content_after_confirm("templates/default/etc/yum.repos.d/#{target}.erb", File.read("/etc/yum.repos.d/#{target}"), input_stream, output_stream)
          end
        end
        
        return 0
      end
    end
  end
end