json.extract! review_item, :id, :name, :display_name, :evaluation_criteria, :scale_min, :scale_max, :start_date, :response_allowed, :created_at, :updated_at
json.url review_item_url(review_item, format: :json)