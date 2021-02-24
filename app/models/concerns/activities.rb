module Concerns::Activities
  extend ActiveSupport::Concern

  def create_activity(user, description, activity_data = {})
      activities.create(
        :description => description,
        :account => account,
        :user => user,
        :activity_data => activity_data
      ) if user
    end

    def create_initial_activity
      unless spam?
        if User.current
          activity_data = {'eval_args' => {'responder_path' => ['responder_path',{'id' => requester.id, 'name' => requester.name}]}}
          activity_user = User.current
          description = 'activities.tickets.logged_user_ticket.long'
        end
        create_activity(activity_user || requester, description || 'activities.tickets.new_ticket.long', activity_data || {},
          short_descr || 'activities.tickets.new_ticket.short')
      end
    end

	  def update_activity
      @model_changes.each_key do |attr|
        send(ACTIVITY_HASH[attr.to_sym()]) if ACTIVITY_HASH.has_key?(attr.to_sym())
      end
    end

	  def create_source_activity
      create_activity(User.current, 'activities.tickets.source_change.long',
          {'source_name' => source_name}, 'activities.tickets.source_change.short')
    end

end