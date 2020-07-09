module Serialize
  class PaginatedRelationAsJson < Micro::Case
    attribute :data
    attribute :serializer

    validates :data, kind: ActiveRecord::Relation
    validates :serializer, kind: { respond_to: :collection_as_json }

    def call!
      value = {
        data: serializer.collection_as_json(data),
        paginatable: {
          current_page: data.current_page,
          prev_page: data.prev_page,
          next_page: data.next_page,
          size: data.size,
          total_count: data.total_count,
          total_pages: data.total_pages,
          offset_value: data.offset_value
        }
      }

      Success { { data: value } }
    end
  end
end
