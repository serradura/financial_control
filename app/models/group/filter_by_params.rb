class Group
  class FilterByParams < Micro::Case
    attributes :data, :params

    validates :params, kind: ActionController::Parameters
    validates :data, kind: ActiveRecord::Relation

    def call!
      filter_as_json = params[:filter] || '{}'
      filter = JSON.parse(filter_as_json).with_indifferent_access

      filtered_relation = filter_by_name(data, filter)
      filtered_relation = filter_by_active(filtered_relation, filter)

      Success { { data: filtered_relation } }
    end

    private

    def filter_by_name(relation, filter)
      return relation unless value = filter[:by_name].presence

      relation.where('name ILIKE ?', "%#{value}%")
    end

    def filter_by_active(relation, filter)
      return relation unless value = filter[:by_active].presence

      relation.where(active: value) if value
    end
  end
end
