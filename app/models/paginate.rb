class Paginate < Micro::Case
  attribute :data
  attribute :params
  attribute :serializer

  validates :data, kind: ActiveRecord::Relation
  validates :params, kind: ActionController::Parameters
  validates :serializer, kind: { respond_to: :collection_as_json }

  def call!
    paginated_relation = data.page(params[:page] || 1)

    if params[:show_all]
      paginated_relation = paginated_relation.per(1_000_000)
    end

    value = {
      data: serializer.collection_as_json(paginated_relation),
      paginatable: {
        current_page: paginated_relation.current_page,
        prev_page: paginated_relation.prev_page,
        next_page: paginated_relation.next_page,
        size: paginated_relation.size,
        total_count: paginated_relation.total_count,
        total_pages: paginated_relation.total_pages,
        offset_value: paginated_relation.offset_value
      }
    }

    Success { { data: value } }
  end
end
