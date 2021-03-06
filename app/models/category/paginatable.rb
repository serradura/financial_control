class Category::Paginatable < Micro::Case
  attribute :data

  def call!
    value = {
      data: Category::Serialize.collection_as_json(data),
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
