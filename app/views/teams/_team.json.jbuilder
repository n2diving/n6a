json.extract! team, :id, :team_name, :start_date, :end_date, :created_at, :updated_at
json.url team_url(team, format: :json)