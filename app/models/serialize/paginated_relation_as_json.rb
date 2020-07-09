module Serialize
  class PaginatedRelationAsJson < Micro::Case
    attribute :relation
    attribute :serializer

    validates :relation, kind: ActiveRecord::Relation
    validates :serializer, kind: { respond_to: :as_json }

    def call!
      data = relation.map { |record| serializer.as_json(record) }

      paginatable = {
        current_page: relation.current_page,
        prev_page: relation.prev_page,
        next_page: relation.next_page,
        size: relation.size,
        total_count: relation.total_count,
        total_pages: relation.total_pages,
        offset_value: relation.offset_value
      }

      Success { { data: data, paginatable: paginatable } }
    end
  end
end
