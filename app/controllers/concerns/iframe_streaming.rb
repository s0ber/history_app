require 'rack/chunked'
require 'renderers/iframe_streaming_renderer'

module IframeStreaming
  extend ActiveSupport::Concern

  protected

    # Set proper cache control and transfer encoding when streaming
    def _process_options(options) #:nodoc:
      super
      if options[:iframe_stream]
        if env["HTTP_VERSION"] == "HTTP/1.0"
          options.delete(:iframe_stream)
        else
          headers["Cache-Control"] ||= "no-cache"
          headers["Transfer-Encoding"] = "chunked"
          headers.delete("Content-Length")
        end
      end
    end

    # Call render_body if we are streaming instead of usual +render+.
    def _render_template(options) #:nodoc:
      if options.delete(:iframe_stream)
        lookup_context.rendered_format = nil if options[:formats]
        Rack::Chunked::Body.new view_renderer.render_iframe_body(view_context, options)
      else
        super
      end
    end
end

module ActionView
  class Renderer
    attr_reader :__iframe_rendering
    attr_accessor :__current_fiber

    def render_iframe_body(context, options)
      @__iframe_rendering = true
      IframeStreamingTemplateRenderer.new(@lookup_context).render(context, options)
    end
  end

  class Template
    def render_with_iframe_streaming(view, locals, buffer=nil, &block)
      # if this is a usual rendering, use default template rendering behavior
      unless view.view_renderer.__iframe_rendering
        render_without_iframe_streaming(view, locals, buffer, &block)
      else
        if locals[:template_type] == :layout
          flat_layout_render(view, locals, buffer, &block)
        elsif locals[:template_type] == :action
          flat_action_render(view, locals, view.output_buffer, &block)
        elsif view.output_buffer
          flat_partial_render(view, locals.merge(partial_id: SecureRandom.uuid), view.output_buffer, &block)
        end
      end
    end

    def flat_layout_render(view, locals, buffer, &block)
      render_without_iframe_streaming(view, locals, buffer, &block)
    end

    def flat_action_render(view, locals, buffer, &block)
      template = render_without_iframe_streaming(view, locals, nil, &block)

      partial = <<-FLAT_PARTIAL
        <script type="text/javascript">parent.ijax.pushHtml('#{locals[:ijax_request_id]}', '#{template}')</script>
      FLAT_PARTIAL

      buffer << partial.html_safe

      return # return empty string, because, we have already modified the output buffer
    end

    def flat_partial_render(view, locals, buffer, &block)
      buffer << render_without_iframe_streaming(view, locals, nil, &block)
      return # return empty string, because, we have already modified the output buffer
    end

    alias_method_chain :render, :iframe_streaming
  end
end
