class TasksController < ApplicationController
  def my
    render_response(
      MyTasksTransaction.new, params_with_session
    ) { |r| @tasks = r[:tasks] }
  end

  def create
    render_response(
      CreateTaskTransaction.new, params_with_session
    ) { |r| @task = r[:task] }
  end

  def assign
    render_response(
      AssignTasksTransaction.new, params_with_session
    )
  end

  def mark_as_done
    render_response(
      MarkTaskAsDoneTransaction.new, params_with_session
    )
  end
end
