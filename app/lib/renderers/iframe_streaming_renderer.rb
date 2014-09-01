module ActionView
  class IframeStreamingTemplateRenderer < StreamingTemplateRenderer #:nodoc:
    private

    def delayed_render(buffer, template, layout, view, locals)
      # Wrap the given buffer in the StreamingBuffer and pass it to the
      # underlying template handler. Now, every time something is concatenated
      # to the buffer, it is not appended to an array, but streamed straight
      # to the client.
      output  = ActionView::StreamingBuffer.new(buffer)

      instrument(:template, :identifier => template.identifier, :layout => layout.try(:virtual_path)) do
        # Set the view flow to support streaming. It will be aware
        # when to stop rendering the layout because it needs to search
        # something in the template and vice-versa.
        locals[:template_type] = :layout
        layout.render view, locals, output do |*name|
          # if yielding without key, then this is action template rendering
          if name.size == 0
            locals[:template_type] = :action
            template.render(view, locals)
          else
            view._layout_for(*name)
          end
        end
      end
    end
  end
end
