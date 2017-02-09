require 'pony'

# Email adapter for Pony gem
module Marfa
  # Extending Helpers
  module Helpers
    # Provide helpers for Sinatra controllers
    module Email
      # Send email using mailbox config
      # @param template [String] - path to template file
      # @param to [String] - email address to send
      # @param subject [String] - email subject
      # @param data [Hash] - data to render in template
      # @param mailbox [Symbol] - mailbox config
      # @example:
      #   send_email('mail', 'user@example.com', :admin, 'Hello', { title: 'Hello!' })
      def send_email(template, to, mailbox = :default, subject = '', data = {})
        config = Marfa.config.email[mailbox]
        return if config.nil?

        body = haml :"#{template}", locals: data, layout: false

        Pony.options = {
          via: :smtp,
          via_options: config
        }

        Pony.mail(to: to, subject: subject, html_body: body)
      end
    end
  end
end