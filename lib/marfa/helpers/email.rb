require 'pony'

# Email adapter for Pony gem
module Marfa
  # Extending Helpers
  module Helpers
    # Provide helpers for Sinatra controllers
    module Email
      # Send email using mailbox config
      # @param options [Hash] - params
      # @example:
      #   send_email({ template: 'mail', to: 'user@example.com', mailbox: :admin, subject: 'Hello', data: { title: 'Hello!' } })
      def send_email(options)
        mailbox = options[:mailbox] || :default

        config = Marfa.config.email[mailbox]
        return if config.nil?

        body = haml :"#{options[:template]}", locals: options[:data], layout: false

        Pony.options = {
          via: :smtp,
          via_options: config
        }

        Pony.mail(to: options[:to], subject: options[:subject], html_body: body)
      end
    end
  end
end