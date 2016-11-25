json.extract! review_note, :id, :user_review_id, :general_notes, :pros, :cons, :created_at, :updated_at
json.url review_note_url(review_note, format: :json)