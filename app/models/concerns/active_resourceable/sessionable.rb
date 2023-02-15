class ActiveResourceable::Sessionable < Module
  extend ActiveSupport::Concern

  def initialize(attrs)
    @session_attrs = attrs
  end

  def included(base)
    session_attrs = @session_attrs

    base.class_eval do

      attr_accessor :session

      define_method(:session_attrs) do
        session_attrs
      end

      def delete_session *attrs
        attrs = session_attrs if attrs.empty?
        attrs.each do |name, opt|
          send(:"delete_#{name}")
        end
      end

      session_attrs.each do |name, opt|

        define_method(:"session_name_for_#{name}") do
          "#{self.class.name.tableize}_#{name}"
        end

        define_method(:"modified_at_session_name_for_#{name}") do
          "#{self.class.name.tableize}_#{name}_modified_at"
        end

        define_method(name) do
          raise "Session is not set" if self.session.nil?
          is_expired = send(:"is_#{name}_expired?")
          is_expired ? nil : self.session[send(:"session_name_for_#{name}")]
        end

        define_method(:"#{name}=") do |value|
          raise "Session is not set" if self.session.nil?
          self.session[send(:"session_name_for_#{name}")] = value
          self.session[send(:"modified_at_session_name_for_#{name}")] = Time.now
        end

        define_method(:"delete_#{name}") do
          raise "Session is not set" if self.session.nil?
          self.session.delete send(:"modified_at_session_name_for_#{name}")
          self.session.delete send(:"session_name_for_#{name}")
        end

        define_method(:"is_#{name}_expired?") do
          raise "Session is not set" if self.session.nil?
          modified_at = self.session[send(:"modified_at_session_name_for_#{name}")]
          (not opt[:expire_after].nil? and not modified_at.nil?) ? modified_at.to_datetime + opt[:expire_after] < Time.now : false
        end

      end

    end

  end

end
