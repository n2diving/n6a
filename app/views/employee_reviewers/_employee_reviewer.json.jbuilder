json.extract! employee_reviewer, :id, :employee_user_id, :reviewer_user_id, :created_at, :updated_at
json.url employee_reviewer_url(employee_reviewer, format: :json)