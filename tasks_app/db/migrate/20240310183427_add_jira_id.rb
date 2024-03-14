class AddJiraId < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :jira_id, :string

    up_only do
      execute <<~SQL
        UPDATE tasks
        SET jira_id = SUBSTRING(name FROM '\[\S+\]');

        UPDATE tasks
        SET name = REGEXP_REPLACE(name, '\[\S+\]', '')
      SQL
    end
  end
end
