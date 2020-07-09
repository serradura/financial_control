class Paginate < Micro::Case
  attribute :relation
  attribute :params

  validates :relation, kind: ActiveRecord::Relation
  validates :params, kind: ActionController::Parameters

  def call!
    paginated_relation = relation.page(params[:page] || 1)

    if params[:show_all]
      paginated_relation = paginated_relation.per(1_000_000)
    end

    Success { { relation: paginated_relation } }
  end
end
