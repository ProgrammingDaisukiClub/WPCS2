json.array!(@contests) do |contest|
  json.extract! contest, :id, :description_en, :description_ja, :end_at, :name_en, :name_ja, :score_baseline, :start_at
  json.url admin_contest_url(contest, format: :json)
end
