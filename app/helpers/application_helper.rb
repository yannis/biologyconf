module ApplicationHelper
  def javascript(*files)
    content_for(:javascript) { javascript_include_tag(*files)}
  end

  def stylesheet(*files)
    content_for(:stylesheet) { stylesheet_link_tag(*files)}
  end

  def document_ready(content, urgent=false)
    container = urgent == true ? :urgent_document_ready : :document_ready
    content_for(container){
      javascript_tag do
        content.html_safe
      end
    }
  end

  def title(content, to_header=true)
    content_for(:title) {content}
    if to_header
      content_for(:header_title){
        content_tag( :header, content_tag(:h1, content))
      }
    end
  end
end
