class Paginate < Micro::Case
  attribute :data
  attribute :params

  validates :data, kind: ActiveRecord::Relation
  validates :params, kind: ActionController::Parameters

  def call!
    paginated_relation = data.page(params[:page] || 1)

    if params[:show_all]
      paginated_relation = paginated_relation.per(1_000_000)
    end

    Success { { data: paginated_relation } }
  end
end
