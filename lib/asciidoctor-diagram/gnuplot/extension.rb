require_relative '../extensions'
require_relative '../util/cli_generator'
require_relative '../util/platform'
require_relative '../util/which'

module Asciidoctor
  module Diagram
    # @private
    module Gnuplot
      include CliGenerator
      include Which

      def self.included(mod)
        [:png, :svg].each do |f|
          mod.register_format(f, :image) do |parent, source|
            gnuplot(parent, source, f)
          end
        end
      end

      def gnuplot(parent, source, format)
        inherit_prefix = name
        
        width = source.attr("width", "1024", inherit_prefix)
        height = source.attr("height", "768", inherit_prefix)
        
        code = "set term #{format} size #{width},#{height}\n" + source.to_s 
        generate_stdin_stdout(which(parent, 'gnuplot'), code) do |tool_path|
          [tool_path]
        end
 
      end
    end

    class GnuplotBlockProcessor < Extensions::DiagramBlockProcessor
      include Gnuplot
    end

    class GnuplotBlockMacroProcessor < Extensions::DiagramBlockMacroProcessor
      include Gnuplot
    end
  end
end