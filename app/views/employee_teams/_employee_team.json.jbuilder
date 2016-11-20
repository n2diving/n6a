json.extract! employee_team, :id, :user_id, :team_lead, :supervisor, :created_at, :updated_at
json.url employee_team_url(employee_team, format: :json)