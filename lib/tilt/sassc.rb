require 'tilt'
require 'sassc'

module Tilt
  # Sass template implementation. See:
  # http://haml.hamptoncatlin.com/
  #
  # Sass templates do not support object scopes, locals, or yield.
  class SassCTemplate < Template
    self.default_mime_type = 'text/css'

    def prepare
      @engine = ::SassC::Engine.new(data, sass_options)
    end

    def evaluate(scope, locals, &block)
      @output ||= @engine.render
    end

    def allows_script?
      false
    end

  private
    def sass_options
      options.merge(:filename => eval_file, :line => line, :syntax => :sass)
    end
  end

  # Sass's new .scss type template implementation.
  class ScssCTemplate < SassCTemplate
    self.default_mime_type = 'text/css'

  private
    def sass_options
      options.merge(:filename => eval_file, :line => line, :syntax => :scss)
    end
  end

  register Tilt::SassCTemplate, 'sass'
  register Tilt::ScssCTemplate, 'scss'
end
