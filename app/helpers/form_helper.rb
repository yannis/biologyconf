module FormHelper

  def self.included(base)
    ActionView::Helpers::FormBuilder.instance_eval do
      include FormBuilderMethods
    end
  end

  module FormBuilderMethods

    def form_group(method, options = {}, &block)
      classes = [options[:class], 'form-group']
      classes << 'has-error' if @object.errors[method].present?
      return @template.content_tag(:div, class: classes.join(' ')){yield}
    end

    def starred_label(method, text = nil, options = {}, &block)
      @object = options[:object] unless options[:object].nil?
      text = text.nil? ? method.to_s.humanize.capitalize : text
      text << "<span class='red_star'>*</span>" if @object.class.validators_on(method).map(&:class).include?(ActiveRecord::Validations::PresenceValidator)
      @template.label(@object_name, method, text.html_safe, objectify_options(options), &block)
    end

    def error_text(method, text = nil, options = {}, &block)
      if @object.errors[method].present?
        @object.errors.full_messages_for(method).each do |message|
          return @template.content_tag(:div, class: "help-block"){message}
        end
      end
    end
  end
end
