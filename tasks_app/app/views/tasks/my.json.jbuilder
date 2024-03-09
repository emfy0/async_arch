respond_with_success(json, nil) do
  json.tasks do
    json.array! @tasks do |task|
      json.partial! 'tasks/task', task:
    end
  end
end
