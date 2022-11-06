require 'html/pipeline'

module HtmlPipelineRails
  class Handler
    def default_format
      :html
    end

    def call(template, source = nil)
      source ||= template.source
      compiled_source = self.class.erb.call(template, source)

      <<-END
        pipeline = HtmlPipelineRails.configuration.pipeline
        result = pipeline.call(begin;#{compiled_source};end)
        result[:output].to_s
      END
    end

    # via http://stackoverflow.com/a/10131299/358804
    def self.erb
      @erb ||= ActionView::Template.registered_template_handler(:erb)
    end
  end
end
