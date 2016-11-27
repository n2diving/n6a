json.extract! review_criteria, :id, :name, :scale, :start_date, :end_date, :created_at, :updated_at
json.url review_criteria_url(review_criteria, format: :json)