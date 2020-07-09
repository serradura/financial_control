class Group
  class FindAll < Micro::Case
    attributes :user, :params

    validates :user, kind: User
    validates :params, kind: ActionController::Parameters

    def call!
      groups =
        Group
          .where(user_id: user.id)
          .order(active: :desc, name: :asc)

      Success { { data: groups } }
    end
  end
end
